# UD1 — Laboratorio: Exploración de logs JSON (datos no estructurados)

> **RA/CE**: RA4.a (escenarios y tipologías de datos no estructurados),
> RA4.f (visualizar datos), RA3.b (tecnologías eficientes).
>
> **Duración**: 1 sesión.
>
> **Entrega**: Notebook o script Python con respuestas a las preguntas.

---

## 1. Objetivo

Trabajar con **datos semiestructurados en formato JSON** simulando logs de un
servidor web. Vas a explorar la estructura, extraer información, detectar
patrones y visualizar resultados — todo sin SQL, usando Python y DuckDB.

Los logs JSON son un caso real de datos no estructurados que aparecen en
cualquier sistema Big Data: logs de aplicación, eventos de usuario, datos de
sensores, etc.

---

## 2. Generar los datos

Ejecuta el generador desde la terminal:

```bash
cd ud01-introduccion-big-data/03-practicas/UD1-Parte4/lab_logs_json
python generar_logs_server.py
```

Esto crea `logs_servidor.jsonl` con 500 registros simulados. Cada línea es un
JSON con esta estructura:

```json
{
  "timestamp": "2026-06-03T14:22:10",
  "ip": "192.168.1.47",
  "metodo": "GET",
  "endpoint": "/api/ventas",
  "status_code": 200,
  "latency_ms": 145,
  "usuario": "user_023",
  "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
  "size_bytes": 12340,
  "region": "norte"
}
```

---

## 3. Exploración con Python

### 3.1 Cargar y explorar

```python
import json
import pathlib
from collections import Counter

ruta = pathlib.Path("logs_servidor.jsonl")
logs = []
with ruta.open() as f:
    for linea in f:
        logs.append(json.loads(linea))

print(f"Total registros: {len(logs)}")
print(f"Campos disponibles: {list(logs[0].keys())}")
```

### 3.2 Preguntas iniciales

Responde usando Python (sin librerías externas, solo `json` y `collections`):

1. **¿Cuántos endpoints diferentes hay?** ¿Cuál es el más llamado?
2. **¿Cuántos códigos de error HTTP (400+) hay?** ¿Qué porcentaje del total?
3. **¿Cuál es la latencia media por endpoint?** ¿Hay algún endpoint
   significativamente más lento?
4. **¿Cuántos usuarios distintos aparecen?** ¿Cuántos requests sin usuario?
5. **¿Qué región genera más tráfico?**

---

## 4. Consultas con DuckDB

DuckDB puede leer JSONL directamente, sin necesidad de cargarlo en Python:

```python
import duckdb

con = duckdb.connect()
con.execute("""
    CREATE TABLE logs AS
    SELECT * FROM read_json_auto('logs_servidor.jsonl');
""")
```

Ahora responde las mismas preguntas con SQL:

```sql
-- 1. Endpoint más llamado
SELECT endpoint, COUNT(*) AS veces
FROM logs
GROUP BY endpoint
ORDER BY veces DESC
LIMIT 5;
```

```sql
-- 2. Porcentaje de errores
SELECT
    COUNT(*) AS total,
    SUM(CASE WHEN status_code >= 400 THEN 1 ELSE 0 END) AS errores,
    ROUND(100.0 * SUM(CASE WHEN status_code >= 400 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_errores
FROM logs;
```

```sql
-- 3. Latencia media por endpoint
SELECT endpoint,
       ROUND(AVG(latency_ms), 1) AS latencia_media,
       MAX(latency_ms) AS latencia_max
FROM logs
GROUP BY endpoint
ORDER BY latencia_media DESC;
```

### Pregunta de reflexión

¿Qué diferencias encuentras entre hacer las consultas con Python puro
(listas/diccionarios) vs con DuckDB (SQL)? ¿Cuándo usarías cada uno?

---

## 5. Detección de anomalías

Usando DuckDB, identifica:

```sql
-- 5.1 Requests con latencia anómala (más de 3 desviaciones de la media)
SELECT timestamp, endpoint, latency_ms
FROM logs
WHERE latency_ms > (
    SELECT AVG(latency_ms) + 3 * stddev(latency_ms) FROM logs
)
ORDER BY latency_ms DESC;
```

```sql
-- 5.2 Endpoints que fallan más del 10% de las veces
SELECT endpoint,
       COUNT(*) AS total,
       SUM(CASE WHEN status_code >= 400 THEN 1 ELSE 0 END) AS errores,
       ROUND(100.0 * SUM(CASE WHEN status_code >= 400 THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_error
FROM logs
GROUP BY endpoint
HAVING pct_error > 10
ORDER BY pct_error DESC;
```

### Preguntas

1. **¿Qué considerarías una anomalía en estos logs?** ¿Solo la latencia alta
   o también los errores repetidos?
2. **¿Cómo decidirías si un endpoint "está caído"** basándote en estos datos?
3. **¿Qué metadatos añadirías a estos logs** para facilitar el diagnóstico?

---

## 6. Visualización

Con los resultados de las consultas anteriores, crea 3 visualizaciones
(puedes usar matplotlib, seaborn o pandas):

1. **Barras**: top-5 endpoints por número de requests.
2. **Línea**: latencia media por hora del día (extrae la hora del timestamp).
3. **Tarta o barras**: proporción de códigos de estado (2xx vs 4xx vs 5xx).

Si usas pandas + matplotlib:

```python
import pandas as pd
import matplotlib.pyplot as plt

df = con.execute("SELECT * FROM logs").df()

# Ejemplo: códigos de estado
df['status_group'] = (df['status_code'] // 100) * 100
conteo = df['status_group'].value_counts().sort_index()
conteo.plot(kind='bar', title='Distribución de códigos de estado')
plt.xlabel('Código')
plt.ylabel('Cantidad')
plt.show()
```

---

## 7. Cierre

Responde por escrito:

1. **¿Qué has aprendido sobre trabajar con JSON como formato de datos?**
2. **¿Qué ventajas tiene JSONL frente a JSON array** para logs?
3. **¿Cómo encaja este tipo de datos en una arquitectura Medallion?**
   ¿En qué capa lo pondrías?
4. **¿Qué RA/CE has trabajado?** Identifica al menos dos.

---

## 8. Criterios de evaluación

| Concepto | Puntos |
|----------|--------|
| Exploración Python correcta (5 preguntas) | 3 |
| Consultas DuckDB correctas | 3 |
| Detección de anomalías | 2 |
| Visualizaciones (3 gráficos con interpretación) | 2 |
| **Total** | **10** |

---

## Histórico

| Fecha | Cambio |
|-------|--------|
| 2026-06-18 | Creación del laboratorio de logs JSON. |
