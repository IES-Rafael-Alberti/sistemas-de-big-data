"""
P3 - Clustering (tipologías de casos) con Spark MLlib

Qué hace:
- Construye un vector de features (categóricas one-hot + numéricas escaladas)
- Prueba varios k y elige el mejor por silhouette (cosine)
- Entrena KMeans
- "Visualiza centroides" como perfiles interpretables por cluster:
  - tamaño del cluster
  - medias de variables numéricas
  - categorías más frecuentes (top-1) en columnas clave

Uso en Colab:
1) Instala Java + PySpark si hace falta.
2) Sube el parquet o monta Drive.
3) Ajusta DATA_PATH.
4) Ejecuta este script.

Si aparece OutOfMemoryError (Java heap space):
- Antes de importar pyspark, en la primera celda del notebook:
  import os
  os.environ["PYSPARK_SUBMIT_ARGS"] = (
      "--driver-memory 8g --executor-memory 8g pyspark-shell"
  )
- Baja SAMPLE_FRACTION_SILHOUETTE y/o pon TRAIN_ON_SUBSET = True.
"""

import os

from pyspark.sql import SparkSession, functions as F, Window
from pyspark.ml import Pipeline
from pyspark.ml.feature import (
    StringIndexer,
    OneHotEncoder,
    VectorAssembler,
    StandardScaler,
    PCA,
)
from pyspark.ml.clustering import KMeans
from pyspark.ml.evaluation import ClusteringEvaluator
from pyspark.ml.functions import vector_to_array


DATA_PATH = "/content/US_Crime_DataSet.parquet"

# Para clustering conviene NO meter City directamente (cardinalidad enorme).
# Si quieres probarlo, conviértelo a Top-N + Other primero.
USE_CITY = False
TOP_N_CITY = 50
USE_TARGET_IN_FEATURES = False  # si False, no se usa "Crime Solved" para formar clusters

BASE_CATEGORICAL_COLS = [
    "State",
    "Month",
    "Crime Type",
    "Crime Solved",
    "Victim Sex",
    "Victim Race",
    "Perpetrator Sex",
    "Perpetrator Race",
    "Relationship",
    "Weapon",
]

NUMERIC_COLS = [
    "Year",
    "Victim Age",
    "Victim Count",
    "Perpetrator Count",
]

K_CANDIDATES = list(range(2, 21))  # k de 2 a 20

# Muestra para elegir k (silhouette). Menor fracción = menos RAM en Colab.
SAMPLE_FRACTION_SILHOUETTE = 0.05

# Si True, el KMeans final se entrena solo sobre una muestra y luego
# se asigna cluster a todo work con transform (más ligero; perfiles siguen siendo sobre todos).
TRAIN_ON_SUBSET = False
TRAIN_SAMPLE_FRACTION = 0.2

# PCA solo sobre una muestra pequeña (evita materializar 600k filas con "features").
PCA_SAMPLE_FRACTION = 0.02


def add_city_topn(df):
    # City_top: Top-N ciudades y resto a "Other".
    top_cities = (
        df.groupBy("City")
        .count()
        .orderBy(F.desc("count"))
        .limit(TOP_N_CITY)
        .select("City")
    )
    top_list = [r["City"] for r in top_cities.collect()]
    return df.withColumn(
        "City_top",
        F.when(F.col("City").isin(top_list), F.col("City")).otherwise(F.lit("Other")),
    )


def build_pipeline(k, categorical_cols, numeric_cols):
    # Fill NA para estabilidad.
    # OneHotEncoder -> KMeans funciona bastante mejor que usar solo índices.
    indexers = [
        StringIndexer(inputCol=c, outputCol=f"{c}_idx", handleInvalid="keep")
        for c in categorical_cols
    ]
    encoder = OneHotEncoder(
        inputCols=[f"{c}_idx" for c in categorical_cols],
        outputCols=[f"{c}_oh" for c in categorical_cols],
        handleInvalid="keep",
    )

    assembler = VectorAssembler(
        inputCols=[f"{c}_oh" for c in categorical_cols] + numeric_cols,
        outputCol="features_raw",
        handleInvalid="keep",
    )

    scaler = StandardScaler(
        inputCol="features_raw",
        outputCol="features",
        withStd=True,
        withMean=False,  # con sparse vectors, withMean=True puede densificar
    )

    kmeans = KMeans(
        k=k,
        seed=42,
        featuresCol="features",
        predictionCol="cluster",
        distanceMeasure="cosine",
        maxIter=40,
    )

    return Pipeline(stages=indexers + [encoder, assembler, scaler, kmeans])


def pick_best_k(df_features, pipeline_builder):
    evaluator = ClusteringEvaluator(
        featuresCol="features",
        predictionCol="cluster",
        metricName="silhouette",
        distanceMeasure="cosine",
    )

    # Silhouette sobre un df coalesceado: menos presión de shuffle en modo local[*].
    df_small = df_features.coalesce(16)

    best = {"k": None, "silhouette": float("-inf")}
    scores = []
    for k in K_CANDIDATES:
        model = pipeline_builder(k).fit(df_small)
        pred = model.transform(df_small).select("features", "cluster")
        score = evaluator.evaluate(pred)
        scores.append((k, score))
        if score > best["silhouette"]:
            best = {"k": k, "silhouette": score}

    print("\n=== Silhouette por k (cosine) ===")
    for k, s in scores:
        print(f"k={k:2d} -> silhouette={s:.4f}")
    print(f"Mejor k={best['k']} (silhouette={best['silhouette']:.4f})")
    return best["k"]


def top_category_by_cluster(pred_df, col, cluster_col="cluster"):
    counts = pred_df.groupBy(cluster_col, col).count()
    w = Window.partitionBy(cluster_col).orderBy(F.desc("count"), F.asc(col))
    ranked = counts.withColumn("rn", F.row_number().over(w)).where(F.col("rn") == 1)
    return ranked.select(
        F.col(cluster_col),
        F.col(col).alias(f"{col}_top"),
        F.col("count").alias(f"{col}_top_count"),
    )


def main():
    spark = (
        SparkSession.builder.appName("P3-Clustering-Tipologias")
        .config("spark.sql.shuffle.partitions", "64")
        .config("spark.driver.memory", os.environ.get("SPARK_DRIVER_MEMORY", "4g"))
        .config("spark.driver.maxResultSize", "2g")
        .config("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
        .getOrCreate()
    )

    df = spark.read.parquet(DATA_PATH)

    # Selección de columnas y limpieza mínima.
    categorical_cols = BASE_CATEGORICAL_COLS[:]
    if not USE_TARGET_IN_FEATURES and "Crime Solved" in categorical_cols:
        categorical_cols.remove("Crime Solved")
    if USE_CITY:
        df = add_city_topn(df)
        categorical_cols = categorical_cols + ["City_top"]

    needed = categorical_cols + NUMERIC_COLS
    work = df.select(*needed)

    # Fill NA
    for c in categorical_cols:
        work = work.fillna({c: "Unknown"})
    for c in NUMERIC_COLS:
        work = work.fillna({c: 0})

    # Filtrado suave de edades para que no distorsione clusters.
    work = work.where((F.col("Victim Age") >= 0) & (F.col("Victim Age") <= 110))

    def pipeline_builder(k):
        return build_pipeline(k, categorical_cols=categorical_cols, numeric_cols=NUMERIC_COLS)

    # Elegimos k con silhouette sobre una muestra pequeña (evita OOM).
    sample = work.sample(
        withReplacement=False, fraction=SAMPLE_FRACTION_SILHOUETTE, seed=42
    )
    best_k = pick_best_k(sample, pipeline_builder)

    print("\n=== Entrenando KMeans final ===")
    if TRAIN_ON_SUBSET:
        train_df = work.sample(
            withReplacement=False, fraction=TRAIN_SAMPLE_FRACTION, seed=43
        ).coalesce(16)
        model = pipeline_builder(best_k).fit(train_df)
        print(
            f"(KMeans entrenado en muestra TRAIN_SAMPLE_FRACTION={TRAIN_SAMPLE_FRACTION})"
        )
    else:
        model = pipeline_builder(best_k).fit(work.coalesce(32))

    # Sin guardar la columna "features" (vectores enormes): solo cluster + atributos.
    pred = model.transform(work).select("cluster", *categorical_cols, *NUMERIC_COLS)

    # Tamaños de cluster
    print("\n=== Tamaño de clusters ===")
    pred.groupBy("cluster").count().orderBy("cluster").show(truncate=False)

    # "Centroides" interpretables: medias numéricas y top categorías.
    print("\n=== Perfil numérico por cluster (medias) ===")
    pred.groupBy("cluster").agg(
        F.avg("Year").alias("Year_avg"),
        F.avg("Victim Age").alias("VictimAge_avg"),
        F.avg("Victim Count").alias("VictimCount_avg"),
        F.avg("Perpetrator Count").alias("PerpCount_avg"),
    ).orderBy("cluster").show(truncate=False)

    profile = pred
    summary = profile.select("cluster").distinct()
    for c in categorical_cols:
        summary = summary.join(top_category_by_cluster(profile, c), on="cluster", how="left")

    print("\n=== Categoría más frecuente por cluster (top-1) ===")
    summary.orderBy("cluster").show(truncate=False)

    # PCA 2D: transform solo sobre muestra pequeña (lleva "features" en memoria solo ahí).
    print("\n=== PCA 2D para visualización (muestra) ===")
    pca_work = work.sample(
        withReplacement=False, fraction=PCA_SAMPLE_FRACTION, seed=44
    ).coalesce(8)
    pca_with_features = model.transform(pca_work).select("cluster", "features").cache()
    try:
        pca = PCA(k=2, inputCol="features", outputCol="pca2d")
        pca_model = pca.fit(pca_with_features)
        pca_df = pca_model.transform(pca_with_features)
    finally:
        pca_with_features.unpersist(blocking=True)

    # pca2d es un Vector (UDT); no se puede indexar con [0] en SQL: usar vector_to_array.
    pca_df = (
        pca_df.withColumn("_pca_arr", vector_to_array(F.col("pca2d")))
        .select(
            "cluster",
            F.col("_pca_arr")[0].alias("pc1"),
            F.col("_pca_arr")[1].alias("pc2"),
        )
    )
    pca_df.show(10, truncate=False)
    print(
        "Puedes convertir este DataFrame a Pandas en Colab y hacer un scatter:\n"
        "pdf = pca_df.toPandas(); pdf.plot.scatter(x='pc1', y='pc2', c=pdf['cluster'], colormap='tab10')"
    )

    spark.stop()


if __name__ == "__main__":
    main()

