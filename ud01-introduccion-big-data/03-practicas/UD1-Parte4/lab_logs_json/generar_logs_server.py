#!/usr/bin/env python3
"""Genera logs simulados de servidor web en JSON para la práctica de logs."""

import json
import random
import datetime
import pathlib

OUTPUT = pathlib.Path(__file__).parent / "logs_servidor.jsonl"

IP_BASE = ["192.168.1", "10.0.0", "172.16.0"]
ENDPOINTS = [
    "/api/ventas", "/api/usuarios", "/api/productos",
    "/api/reservas", "/api/inventario",
    "/login", "/logout", "/static/css/main.css", "/static/js/app.js",
]
METODOS = ["GET", "POST", "PUT", "DELETE"]
STATUS_CODES = [200, 200, 200, 200, 201, 204, 301, 400, 401, 403, 404, 500, 502]
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "curl/7.88.1",
    "Python-httpx/0.27.0",
    "Apache-HttpClient/4.5.14",
]
USUARIOS = [f"user_{i:03d}" for i in range(1, 51)]


def generar_logs(num_registros=500):
    base = datetime.datetime(2026, 6, 1, 0, 0, 0)
    logs = []
    for i in range(num_registros):
        ts = base + datetime.timedelta(
            days=random.randint(0, 6),
            hours=random.randint(0, 23),
            minutes=random.randint(0, 59),
            seconds=random.randint(0, 59),
        )
        ip = f"{random.choice(IP_BASE)}.{random.randint(1, 254)}"
        metodo = random.choice(METODOS)
        endpoint = random.choice(ENDPOINTS)
        status = random.choice(STATUS_CODES)
        latency_ms = random.randint(5, 2000)
        usuario = random.choice(USUARIOS) if random.random() > 0.3 else None
        tamano_bytes = random.randint(200, 50000)

        log = {
            "timestamp": ts.isoformat(),
            "ip": ip,
            "metodo": metodo,
            "endpoint": endpoint,
            "status_code": status,
            "latency_ms": latency_ms,
            "usuario": usuario,
            "user_agent": random.choice(USER_AGENTS),
            "size_bytes": tamano_bytes,
            "region": random.choice(["norte", "sur", "este", "oeste"]),
        }
        logs.append(log)
    return logs


def guardar_logs(logs, ruta=OUTPUT):
    with ruta.open("w", encoding="utf-8") as f:
        for log in logs:
            f.write(json.dumps(log, ensure_ascii=False) + "\n")
    print(f"Generados {len(logs)} logs en {ruta}")


if __name__ == "__main__":
    logs = generar_logs(500)
    guardar_logs(logs)
