"""
P1 - Crime Solved con/sin City (Spark MLlib)

Uso en Colab:
1) Instala Java + PySpark (si hace falta en tu runtime).
2) Sube el parquet o monta Drive.
3) Ajusta DATA_PATH.
4) Ejecuta este script.
"""

from pyspark.sql import SparkSession, functions as F
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer, VectorAssembler
from pyspark.ml.classification import RandomForestClassifier
from pyspark.ml.evaluation import BinaryClassificationEvaluator, MulticlassClassificationEvaluator


# Cambia esta ruta en Colab:
DATA_PATH = "/content/US_Crime_DataSet.parquet"

# Variables base para P1.
TARGET_COL = "Crime Solved"
CATEGORICAL_BASE = [
    "Agency Type",
    "State",
    "Month",
    "Crime Type",
    "Victim Sex",
    "Victim Race",
    "Victim Ethnicity",
    "Perpetrator Sex",
    "Perpetrator Race",
    "Perpetrator Ethnicity",
    "Relationship",
    "Weapon",
]
NUMERIC_BASE = [
    "Year",
    "Incident",
    "Victim Age",
    "Victim Count",
    "Perpetrator Count",
]
RF_MAX_BINS = 4096


def build_and_train(df, include_city):
    categorical_cols = CATEGORICAL_BASE[:] + (["City"] if include_city else [])
    numeric_cols = NUMERIC_BASE[:]

    # Nos quedamos solo con columnas necesarias.
    model_cols = [TARGET_COL] + categorical_cols + numeric_cols
    work_df = df.select(*model_cols)

    # Limpieza mínima para evitar nulls en columnas críticas.
    work_df = work_df.dropna(subset=[TARGET_COL])
    for c in categorical_cols:
        work_df = work_df.fillna({c: "Unknown"})
    for c in numeric_cols:
        work_df = work_df.fillna({c: 0})

    label_indexer = StringIndexer(
        inputCol=TARGET_COL,
        outputCol="label",
        handleInvalid="skip",
    )

    feature_indexers = [
        StringIndexer(inputCol=c, outputCol=f"{c}_idx", handleInvalid="keep")
        for c in categorical_cols
    ]
    assembled_inputs = [f"{c}_idx" for c in categorical_cols] + numeric_cols

    assembler = VectorAssembler(
        inputCols=assembled_inputs,
        outputCol="features",
        handleInvalid="keep",
    )

    # En árboles de Spark, maxBins debe cubrir la cardinalidad de categóricas indexadas.
    # Con este dataset, 32 (por defecto) se queda corto (ej. "State" ya tiene 52).
    clf = RandomForestClassifier(
        labelCol="label",
        featuresCol="features",
        numTrees=120,
        maxDepth=12,
        maxBins=RF_MAX_BINS,
        seed=42,
    )

    pipeline = Pipeline(stages=[label_indexer] + feature_indexers + [assembler, clf])
    train_df, test_df = work_df.randomSplit([0.8, 0.2], seed=42)
    fitted = pipeline.fit(train_df)
    pred = fitted.transform(test_df)

    auc_eval = BinaryClassificationEvaluator(
        labelCol="label",
        rawPredictionCol="rawPrediction",
        metricName="areaUnderROC",
    )
    f1_eval = MulticlassClassificationEvaluator(
        labelCol="label",
        predictionCol="prediction",
        metricName="f1",
    )
    acc_eval = MulticlassClassificationEvaluator(
        labelCol="label",
        predictionCol="prediction",
        metricName="accuracy",
    )

    auc = auc_eval.evaluate(pred)
    f1 = f1_eval.evaluate(pred)
    acc = acc_eval.evaluate(pred)

    rf_model = fitted.stages[-1]
    importances = list(rf_model.featureImportances)
    feature_importance_pairs = sorted(
        zip(assembled_inputs, importances),
        key=lambda x: x[1],
        reverse=True,
    )

    return {
        "include_city": include_city,
        "auc": auc,
        "f1": f1,
        "accuracy": acc,
        "rows_train": train_df.count(),
        "rows_test": test_df.count(),
        "top_features": feature_importance_pairs[:12],
    }


def main():
    spark = (
        SparkSession.builder.appName("P1-CrimeSolved-ConSinCity")
        .config("spark.sql.shuffle.partitions", "200")
        .getOrCreate()
    )

    df = spark.read.parquet(DATA_PATH)

    print("=== Dataset ===")
    print(f"Filas: {df.count()}")
    df.groupBy(TARGET_COL).count().orderBy(F.desc("count")).show(truncate=False)

    print("=== Entrenando modelo SIN City ===")
    no_city = build_and_train(df, include_city=False)

    print("=== Entrenando modelo CON City ===")
    with_city = build_and_train(df, include_city=True)

    print("\n=== RESULTADOS COMPARATIVOS ===")
    print(
        f"SIN City  -> AUC={no_city['auc']:.4f} | F1={no_city['f1']:.4f} | ACC={no_city['accuracy']:.4f}"
    )
    print(
        f"CON City  -> AUC={with_city['auc']:.4f} | F1={with_city['f1']:.4f} | ACC={with_city['accuracy']:.4f}"
    )
    print(
        f"Delta AUC (CON - SIN): {with_city['auc'] - no_city['auc']:+.4f}"
    )
    print(
        f"Delta F1  (CON - SIN): {with_city['f1'] - no_city['f1']:+.4f}"
    )
    print(
        f"Delta ACC (CON - SIN): {with_city['accuracy'] - no_city['accuracy']:+.4f}"
    )

    print("\nTop features SIN City:")
    for name, score in no_city["top_features"]:
        print(f"  {name:30s} {score:.6f}")

    print("\nTop features CON City:")
    for name, score in with_city["top_features"]:
        print(f"  {name:30s} {score:.6f}")

    spark.stop()


if __name__ == "__main__":
    main()
