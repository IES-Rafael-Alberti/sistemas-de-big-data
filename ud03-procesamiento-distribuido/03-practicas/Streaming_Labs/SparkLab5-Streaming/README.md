# SparkLab5-Streaming

Laboratorio 5 — Streaming con Redpanda + Spark Structured Streaming.

## Enlace al lab

- [01-SparkLab5-Streaming.md](01-SparkLab5-Streaming.md)

## Requisitos

- Docker
- Python 3.9+
- `kafka-python`
- `pyspark`

## Quick start

1. Levantar el entorno:

```bash
docker compose up -d
```

2. Crear el tópico:

```bash
docker exec -it streaming-redpanda-1 rpk topic create ventas-stream --partitions 3
```

3. Ejecutar el productor:

```bash
python streaming_producer.py --csv ventas_clientes_anon.csv
```

4. Ejecutar el consumidor:

```bash
python streaming_consumer.py
```
