"""
P2 - Regresion de edades (Spark MLlib)

Objetivo:
- Modelo 1: predecir Victim Age
- Modelo 2: predecir Perpetrator Age (solo si calidad suficiente)

Uso en Colab:
1) Instala Java + PySpark (si hace falta en tu runtime).
2) Sube el parquet o monta Drive.
3) Ajusta DATA_PATH.
4) Ejecuta este script.
"""

from pyspark.sql import SparkSession, functions as F
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer, VectorAssembler
from pyspark.ml.regression import RandomForestRegressor
from pyspark.ml.evaluation import RegressionEvaluator


DATA_PATH = "/content/US_Crime_DataSet.parquet"
RF_MAX_BINS = 4096
MIN_VALID_RATIO = 0.90

# Variables que usaremos como features (sin incluir los targets).
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
    "Victim Count",
    "Perpetrator Count",
]


def cast_and_filter_target(df, target_col):
    # Convertimos el target a double y filtramos valores imposibles.
    work = df.withColumn("label", F.col(target_col).cast("double"))

    if target_col == "Victim Age":
        work = work.where((F.col("label") >= 0) & (F.col("label") <= 110))
    elif target_col == "Perpetrator Age":
        work = work.where((F.col("label") >= 0) & (F.col("label") <= 100))

    return work


def run_regression(df, target_col):
    feature_cats = [c for c in CATEGORICAL_BASE if c != target_col]
    feature_nums = [c for c in NUMERIC_BASE if c != target_col]

    model_cols = [target_col] + feature_cats + feature_nums
    work_df = df.select(*model_cols)

    # Nulos en features.
    for c in feature_cats:
        work_df = work_df.fillna({c: "Unknown"})
    for c in feature_nums:
        work_df = work_df.fillna({c: 0})

    work_df = cast_and_filter_target(work_df, target_col).dropna(subset=["label"])

    indexers = [
        StringIndexer(inputCol=c, outputCol=f"{c}_idx", handleInvalid="keep")
        for c in feature_cats
    ]
    vec_inputs = [f"{c}_idx" for c in feature_cats] + feature_nums

    assembler = VectorAssembler(
        inputCols=vec_inputs,
        outputCol="features",
        handleInvalid="keep",
    )

    reg = RandomForestRegressor(
        labelCol="label",
        featuresCol="features",
        numTrees=140,
        maxDepth=12,
        maxBins=RF_MAX_BINS,
        seed=42,
    )

    train_df, test_df = work_df.randomSplit([0.8, 0.2], seed=42)
    pipeline = Pipeline(stages=indexers + [assembler, reg])
    fitted = pipeline.fit(train_df)
    pred = fitted.transform(test_df)

    rmse_eval = RegressionEvaluator(
        labelCol="label",
        predictionCol="prediction",
        metricName="rmse",
    )
    mae_eval = RegressionEvaluator(
        labelCol="label",
        predictionCol="prediction",
        metricName="mae",
    )
    r2_eval = RegressionEvaluator(
        labelCol="label",
        predictionCol="prediction",
        metricName="r2",
    )

    rmse = rmse_eval.evaluate(pred)
    mae = mae_eval.evaluate(pred)
    r2 = r2_eval.evaluate(pred)

    model = fitted.stages[-1]
    importances = list(model.featureImportances)
    top_features = sorted(
        zip(vec_inputs, importances),
        key=lambda x: x[1],
        reverse=True,
    )[:12]

    return {
        "target": target_col,
        "rows_train": train_df.count(),
        "rows_test": test_df.count(),
        "rmse": rmse,
        "mae": mae,
        "r2": r2,
        "top_features": top_features,
    }


def valid_ratio(df, col_name):
    numeric_col = F.col(col_name).cast("double")
    stats = df.select(
        F.count("*").alias("total"),
        F.sum(F.when(numeric_col.isNotNull(), 1).otherwise(0)).alias("valid"),
    ).collect()[0]
    return stats["valid"] / stats["total"] if stats["total"] else 0.0


def print_results(res):
    print(f"\n=== {res['target']} ===")
    print(f"Train rows: {res['rows_train']}")
    print(f"Test rows : {res['rows_test']}")
    print(f"RMSE      : {res['rmse']:.4f}")
    print(f"MAE       : {res['mae']:.4f}")
    print(f"R2        : {res['r2']:.4f}")
    print("Top features:")
    for name, score in res["top_features"]:
        print(f"  {name:30s} {score:.6f}")


def main():
    spark = (
        SparkSession.builder.appName("P2-Regresion-Edades")
        .config("spark.sql.shuffle.partitions", "200")
        .getOrCreate()
    )

    df = spark.read.parquet(DATA_PATH)
    print(f"Filas dataset: {df.count()}")

    victim_ratio = valid_ratio(df, "Victim Age")
    perp_ratio = valid_ratio(df, "Perpetrator Age")

    print(f"Valid ratio Victim Age      : {victim_ratio:.4f}")
    print(f"Valid ratio Perpetrator Age : {perp_ratio:.4f}")

    # P2.1 - Victim Age (siempre que pase umbral minimo).
    if victim_ratio >= MIN_VALID_RATIO:
        victim_res = run_regression(df, "Victim Age")
        print_results(victim_res)
    else:
        print("Victim Age no se entrena por calidad insuficiente.")

    # P2.2 - Perpetrator Age (condicional por calidad).
    if perp_ratio >= MIN_VALID_RATIO:
        perp_res = run_regression(df, "Perpetrator Age")
        print_results(perp_res)
    else:
        print("Perpetrator Age no se entrena por calidad insuficiente.")

    spark.stop()


if __name__ == "__main__":
    main()
