#!/usr/bin/env python3
"""
Ejemplo introductorio de PySpark DataFrame — Unidad 3

Este script demuestra cómo:
1. Iniciar una SparkSession local de forma correcta.
2. Crear un DataFrame a partir de una lista de datos en memoria (para pruebas rápidas).
3. Realizar transformaciones comunes (select, filter, con nuevas columnas).
4. Agrupar y agregar datos (groupBy y count/sum).
5. Escribir resultados a formato estructurado Parquet.
"""

from __future__ import annotations
import sys
from pyspark.sql import SparkSession
from pyspark.sql import functions as F

def main():
    print("=" * 60)
    print("Iniciando ejemplo básico de PySpark DataFrame...")
    print("=" * 60)

    # 1. Crear la SparkSession
    # Configurada para ejecutarse en modo local con 2 hilos (local[2])
    spark = SparkSession.builder \
        .appName("EjemploSparkDataFrameBasic") \
        .master("local[2]") \
        .getOrCreate()

    # Reducimos el nivel de logs para evitar exceso de información
    spark.sparkContext.setLogLevel("WARN")

    try:
        # 2. Datos de muestra (ventas simuladas)
        data = [
            ("2026-07-01", "tienda_madrid", "teclado", 5, 25.0),
            ("2026-07-01", "tienda_barcelona", "raton", 10, 15.0),
            ("2026-07-01", "tienda_madrid", "monitor", 2, 180.0),
            ("2026-07-02", "tienda_valencia", "teclado", 3, 27.5),
            ("2026-07-02", "tienda_madrid", "raton", 8, 12.0),
            ("2026-07-02", "tienda_barcelona", "monitor", 1, 199.9),
            ("2026-07-03", "tienda_valencia", "monitor", 4, 175.0),
            ("2026-07-03", "tienda_madrid", "teclado", 12, 22.0),
        ]

        schema = ["fecha", "tienda", "producto", "cantidad", "precio_unitario"]

        # Crear el DataFrame
        df = spark.createDataFrame(data, schema)
        print("\n[INFO] DataFrame original cargado:")
        df.show()
        print("[INFO] Esquema inferido:")
        df.printSchema()

        # 3. Transformaciones: Filtrar y calcular nueva columna de importe
        # Calculamos 'importe_total' como cantidad * precio_unitario
        print("\n[INFO] 1. Filtrando ventas de teclados o monitores y calculando importe total...")
        df_transformed = df.filter(F.col("producto").isin("teclado", "monitor")) \
                           .withColumn("importe_total", F.round(F.col("cantidad") * F.col("precio_unitario"), 2))
        
        df_transformed.show()

        # 4. Agrupaciones y agregaciones
        # Agrupamos por tienda para calcular unidades totales e importe total
        print("\n[INFO] 2. Agrupando e integrando métricas por tienda...")
        df_aggregated = df_transformed.groupBy("tienda").agg(
            F.sum("cantidad").alias("total_unidades"),
            F.round(F.sum("importe_total"), 2).alias("ingresos_totales"),
            F.count("producto").alias("numero_operaciones")
        ).orderBy(F.col("ingresos_totales").desc())

        df_aggregated.show()

        # 5. Escribir resultados a formato estructurado Parquet
        output_path = "tmp_pyspark_output"
        print(f"\n[INFO] 3. Escribiendo resultados agregados a Parquet en: {output_path}...")
        
        # Guardamos sobreescribiendo si ya existe
        df_aggregated.write.mode("overwrite").parquet(output_path)
        print("  [OK] Escritura completada con éxito.")

        # Leemos para verificar
        df_verify = spark.read.parquet(output_path)
        print("\n[INFO] 4. Verificación de lectura de Parquet:")
        df_verify.show()

    except Exception as e:
        print(f"\n❌ Error en la ejecución de Spark: {e}", file=sys.stderr)
    finally:
        # Cerrar la sesión siempre al finalizar
        print("\n[INFO] Cerrando la SparkSession...")
        spark.stop()
        print("=" * 60)
        print("Ejemplo finalizado.")
        print("=" * 60)

if __name__ == "__main__":
    main()
