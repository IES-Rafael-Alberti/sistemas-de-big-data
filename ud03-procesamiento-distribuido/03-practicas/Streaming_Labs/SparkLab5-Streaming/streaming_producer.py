import argparse
import csv
import hashlib
import json
import logging
import random
import time
from datetime import datetime

from kafka import KafkaProducer


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)


def build_id_hash(fecha, ciudad, canal, importe, unidades):
    raw = f"{fecha}|{ciudad}|{canal}|{importe}|{unidades}"
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()


def parse_args():
    parser = argparse.ArgumentParser(description="Streaming producer for Redpanda/Kafka")
    parser.add_argument("--csv", default=None, help="Path to CSV file")
    parser.add_argument("--bootstrap-server", default="localhost:9092")
    parser.add_argument("--topic", default="ventas-stream")
    parser.add_argument("--delay", type=float, default=1.0)
    return parser.parse_args()


def random_row():
    fecha = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
    ciudad = random.choice(["Madrid", "Barcelona", "Valencia", "Sevilla", "Bilbao"])
    canal = random.choice(["tienda", "web", "telefono"])
    importe = round(random.uniform(10, 500), 2)
    unidades = random.randint(1, 10)
    return {
        "fecha": fecha,
        "ciudad": ciudad,
        "canal": canal,
        "importe": importe,
        "unidades": unidades,
        "id_hash": build_id_hash(fecha, ciudad, canal, importe, unidades),
    }


def csv_rows(csv_path):
    with open(csv_path, newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        for row in reader:
            yield {
                "fecha": row.get("fecha", datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")),
                "ciudad": row.get("ciudad", "desconocida"),
                "canal": row.get("canal", "desconocido"),
                "importe": float(row.get("importe", 0) or 0),
                "unidades": int(float(row.get("unidades", 0) or 0)),
            }


def main():
    args = parse_args()

    producer = KafkaProducer(
        bootstrap_servers=args.bootstrap_server,
        value_serializer=lambda value: json.dumps(value).encode("utf-8"),
        key_serializer=lambda value: value.encode("utf-8") if value else None,
        retries=5,
        linger_ms=10,
    )

    logging.info("Connected to %s", args.bootstrap_server)

    try:
        rows = csv_rows(args.csv) if args.csv else None

        while True:
            if rows is None:
                payload = random_row()
            else:
                try:
                    payload = next(rows)
                    payload["id_hash"] = build_id_hash(
                        payload["fecha"],
                        payload["ciudad"],
                        payload["canal"],
                        payload["importe"],
                        payload["unidades"],
                    )
                except StopIteration:
                    logging.info("CSV finished, restarting from beginning")
                    rows = csv_rows(args.csv)
                    continue

            future = producer.send(args.topic, key=payload["ciudad"], value=payload)
            metadata = future.get(timeout=10)
            logging.info(
                "Sent message topic=%s partition=%s offset=%s",
                metadata.topic,
                metadata.partition,
                metadata.offset,
            )
            time.sleep(args.delay)

    except KeyboardInterrupt:
        logging.info("Producer interrupted by user")
    except Exception:
        logging.exception("Producer failed")
    finally:
        producer.flush()
        producer.close()


if __name__ == "__main__":
    main()
