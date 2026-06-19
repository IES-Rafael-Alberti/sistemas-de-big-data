---
output:
  pdf_document: 
     toc: true
     latex_engine: xelatex
  html_document: default
---
# 🧠 Orquestación de Datos con Mage AI

## 1. Introducción

**Mage AI** es una herramienta moderna de orquestación de pipelines de datos orientada a:

* Simplicidad
* Desarrollo interactivo (tipo notebook)
* Integración nativa con Python
* Experiencia “developer-friendly”

👉 A diferencia de Airflow, Mage prioriza la **rapidez de desarrollo y visualización inmediata** frente a la complejidad empresarial.

---

## 2. ¿Qué es la orquestación de datos?

La orquestación consiste en:

* Definir **tareas (tasks)**
* Establecer **dependencias**
* Gestionar **ejecución automática**
* Controlar **errores y reintentos**

Ejemplo típico:

```
Extraer datos → Transformar → Guardar → Visualizar
```

---

## 3. Instalación de Mage AI

### Opción 1: Instalación con pip (local)

```bash
pip install mage-ai
```

Crear proyecto:

```bash
mage start mi_proyecto
cd mi_proyecto
mage start
```

Acceso:

```
http://localhost:6789
```

---

### Opción 2: Docker (recomendado para clase)

```bash
docker run -it -p 6789:6789 mageai/mageai /app/run_app.sh mage start mi_proyecto
```

Luego:

```
http://localhost:6789
```

---

## 4. Conceptos clave en Mage

### 4.1 Pipeline

Un pipeline es un flujo de trabajo compuesto por bloques:

```
[Data Loader] → [Transformer] → [Exporter]
```

---

### 4.2 Bloques (Blocks)

Tipos principales:

* **Data Loader** → carga datos
* **Transformer** → transforma
* **Data Exporter** → guarda resultados
* **Custom** → lógica personalizada

---

### 4.3 Ejecución

* Manual
* Programada (scheduler)
* Trigger por eventos

---

## 5. Primer ejemplo práctico

### Objetivo

Pipeline sencillo:

1. Generar datos
2. Transformarlos
3. Mostrar resultado

---

### Paso 1: Crear pipeline

En la interfaz:

```
New Pipeline → Standard (batch)
Nombre: ejemplo_pipeline
```

---

### Paso 2: Data Loader

Código:

```python
import pandas as pd

def load_data(*args, **kwargs):
    data = {
        "nombre": ["Ana", "Luis", "Carlos"],
        "edad": [25, 30, 35]
    }
    return pd.DataFrame(data)
```

---

### Paso 3: Transformer

```python
def transform(df, *args, **kwargs):
    df["edad_doble"] = df["edad"] * 2
    return df
```

---

### Paso 4: Exporter

```python
def export(df, *args, **kwargs):
    print(df)
```

---

### Resultado esperado

```
   nombre  edad  edad_doble
0     Ana    25          50
1    Luis    30          60
2  Carlos    35          70
```

---

## 6. Versión más realista (dataset CSV)

### Data Loader

```python
def load_data(*args, **kwargs):
    import pandas as pd
    return pd.read_csv("data/supermarket_sales.csv")
```

---

### Transformer

```python
def transform(df, *args, **kwargs):
    df["Total_con_IVA"] = df["Total"] * 1.21
    return df
```

---

### Exporter

```python
def export(df, *args, **kwargs):
    df.to_csv("output/resultado.csv", index=False)
```

---

## 7. Scheduling en Mage

Se puede programar:

* Cron jobs
* Intervalos (cada X minutos)

Ejemplo:

```
0 * * * *  → cada hora
```

---

## 8. Ventajas de Mage AI

✔ Muy fácil de usar
✔ Interfaz visual clara
✔ Integración directa con Python
✔ Ideal para enseñanza
✔ Feedback inmediato

---

## 9. Introducción a Airflow (recordatorio)

**Apache Airflow** es el estándar industrial para orquestación:

* Basado en DAGs
* Muy potente
* Alta complejidad
* Orientado a producción

---

## 10. Comparativa Mage vs Airflow

| Característica       | Mage AI              | Airflow             |
| -------------------- | -------------------- | ------------------- |
| Facilidad de uso     | ⭐⭐⭐⭐⭐                | ⭐⭐                  |
| Interfaz             | Visual + interactiva | Web + logs          |
| Curva de aprendizaje | Baja                 | Alta                |
| Programación         | Python directo       | DAGs con operadores |
| Debugging            | Muy sencillo         | Complejo            |
| Escalabilidad        | Media                | Alta                |
| Uso en industria     | Emergente            | Estándar            |

---

## 11. Comparativa práctica (mismo ejemplo)

### Mage (ya visto)

```python
def transform(df):
    df["edad_doble"] = df["edad"] * 2
    return df
```

---

### Airflow equivalente

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pandas as pd

def load_data():
    return pd.DataFrame({
        "nombre": ["Ana", "Luis", "Carlos"],
        "edad": [25, 30, 35]
    })

def transform():
    df = load_data()
    df["edad_doble"] = df["edad"] * 2
    print(df)

with DAG(
    dag_id="ejemplo",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False
) as dag:

    task = PythonOperator(
        task_id="transform_task",
        python_callable=transform
    )
```

---

## 12. Conclusión

👉 Mage AI:

* Ideal para empezar
* Muy visual
* Refuerza lógica de pipelines

👉 Airflow:

* Para entornos reales
* Introducir después

---





## 🎯 Ejemplo: ETL de Ventas (CSV → PostgreSQL → Dashboard) con MageAI

### 📁 Datos de entrada
Un archivo `ventas.csv` con columnas:
```
fecha,producto,cantidad,precio,total
2024-01-01,Producto A,10,15.5,155.0
2024-01-02,Producto B,5,20.0,100.0
...
```

---

## 🛠️ En Mage AI (versión visual + código)

### Paso 1: **Data Ingestion (Lectura del CSV)**
```python
# Block: "load_sales_data"
import pandas as pd

df = pd.read_csv('ventas.csv')
df['fecha'] = pd.to_datetime(df['fecha'])
return df
```

### Paso 2: **Transformación (Agregar por producto)**
```python
# Block: "transform_sales"
df_agg = df.groupby('producto').agg(
    total_ventas=('total', 'sum'),
    promedio_precio=('precio', 'mean')
).reset_index()
return df_agg
```

### Paso 3: **Carga a PostgreSQL**
```python
# Block: "load_to_db"
from sqlalchemy import create_engine

engine = create_engine('postgresql://user:pass@localhost:5432/ventas_db')
df_agg.to_sql('ventas_agregadas', engine, if_exists='replace', index=False)
```

### Paso 4: **Visualización (opcional)**
Puedes añadir un bloque de **visualización con Plotly** o simplemente mostrar el DataFrame en el preview de Mage.

---

## 🆚 Comparación con Airflow

| Característica          | Airflow                            | Mage AI                            |
|-------------------------|------------------------------------|------------------------------------|
| **Definición del pipeline** | DAG en Python (código puro)          | Bloques visuales + código opcional   |
| **Debugging**           | Logs en UI, más complejo            | Preview en tiempo real, más intuitivo |
| **Escalabilidad**       | Alta (para grandes pipelines)      | Ideal para mini-big-data / MVP      |
| **Curva de aprendizaje** | Alta                               | Baja                               |
| **Integración con ML**  | Requiere más configuración         | Soporte nativo para modelos        |

---

## 💡 Actividad
 **Recrea el mismo pipeline en Airflow** (uno que hayáis hecho en airflow) y luego en Mage AI. 
 
 Comparad:
 
- Tiempo de desarrollo
- Facilidad de lectura
- Debugging
- Posibilidad de reutilizar bloques

---
