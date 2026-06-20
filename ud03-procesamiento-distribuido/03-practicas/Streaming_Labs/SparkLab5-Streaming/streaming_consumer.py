from pyspark.sql import SparkSession
from pyspark.sql.functions import avg as _avg
from pyspark.sql.functions import col, count, from_json, sum as _sum
from pyspark.sql.types import DoubleType, IntegerType, StringType, StructField, StructType


schema = StructType([
    StructField("fecha", StringType(), True),
    StructField("ciudad", StringType(), True),
    StructField("canal", StringType(), True),
    StructField("importe", DoubleType(), True),
    StructField("unidades", IntegerType(), True),
    StructField("id_hash", StringType(), True),
])


spark = SparkSession.builder.appName("SparkLab5-Streaming").getOrCreate()
spark.sparkContext.setLogLevel("WARN")

# Read the Kafka topic as a streaming source.
raw_stream = spark.readStream.format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "ventas-stream") \
    .option("startingOffsets", "latest") \
    .load()

# Kafka delivers key/value as bytes, so we parse the JSON payload from value.
parsed_stream = raw_stream.select(
    from_json(col("value").cast("string"), schema).alias("data")
).select("data.*")

# Real-time aggregation by city.
aggregated = parsed_stream.groupBy("ciudad").agg(
    count("*").alias("num_ventas"),
    _sum("importe").alias("importe_total"),
    _avg("importe").alias("importe_medio"),
    _sum("unidades").alias("unidades_totales"),
)

# Output the evolving result to the console.
query = aggregated.writeStream \
    .outputMode("complete") \
    .format("console") \
    .option("truncate", "false") \
    .start()

query.awaitTermination()
