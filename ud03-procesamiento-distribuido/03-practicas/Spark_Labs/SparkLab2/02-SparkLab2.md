# Laboratorio 2 — Spark frente a pandas  
## Procesamiento de datos a mayor escala

En este laboratorio vamos a **aumentar el volumen de datos** y a comparar dos enfoques:

- Procesamiento clásico con pandas
- Procesamiento distribuido con Spark

El objetivo no es “ver quién va más rápido”, sino **entender cuándo Spark empieza a marcar la diferencia**.

---

## 1. Objetivos del laboratorio

Al finalizar este laboratorio deberías ser capaz de:

- Generar un dataset de mayor tamaño a partir de uno pequeño.
- Procesar el mismo dataset con pandas y con Spark.
- Observar diferencias de tiempo y consumo.
- Comprender por qué Spark escala mejor cuando el volumen crece.
- Preparar datos para su uso posterior (visualización / automatización).

---

## 2. Punto de partida

Partimos del proyecto del Laboratorio 1:

```

ud3-spark-lab1/
apps/
data/
ventas_clientes_anon.csv
scripts/
inflar_dataset.py

````

El dataset original es **correcto**, pero demasiado pequeño para notar diferencias.

---

## 3. Inflar el dataset (paso clave)

### 3.1 ¿Por qué inflar los datos?

En clase no siempre podemos trabajar con datos realmente grandes.  
Para simular un escenario Big Data:

👉 **replicamos los datos muchas veces**, manteniendo su estructura.

---

### 3.2 Generar un dataset grande

Desde la raíz del proyecto:

```bash
python scripts/inflar_dataset.py \
  --input data/ventas_clientes_anon.csv \
  --output data/ventas_clientes_anon_big.csv \
  --factor 100
```

Esto genera un CSV con muchas más filas.

Comprueba el tamaño:

```bash
ls -lh data/ventas_clientes_anon_big.csv
```

---

## 4. Procesamiento con pandas (referencia)

Este paso sirve **solo como comparación**.

### 4.1 Crear un script pandas sencillo

Crea el fichero `apps/pandas_job.py`:

```python
import pandas as pd
import time

start = time.time()

df = pd.read_csv("data/ventas_clientes_anon_big.csv")

df_f = df[df["importe"] > 100]

res = (
    df_f.groupby("ciudad")
    .agg(
        num_ventas=("importe", "count"),
        importe_total=("importe", "sum"),
        importe_medio=("importe", "mean")
    )
    .sort_values("importe_total", ascending=False)
)

print(res.head(10))

end = time.time()
print(f"Tiempo total pandas: {end - start:.2f} segundos")
```

Ejecuta:

```bash
python apps/pandas_job.py
```

⚠️ Si tu equipo va justo, este paso puede tardar bastante o incluso fallar.
Eso **forma parte del experimento**.

---

## 5. Procesamiento con Spark

### 5.1 Usar el dataset inflado en Spark

Edita `apps/lab1_job.py` y cambia la ruta:

```python
DATA_PATH = "/opt/spark-data/ventas_clientes_anon_big.csv"
```

---

### 5.2 Ejecutar el job Spark

Desde el **Master**:

```bash
docker exec -it spark-master spark-submit \
  --master spark://IP_DEL_MASTER:7077 \
  /opt/spark-apps/lab1_job.py
```

Observa:

* El tiempo de ejecución
* El uso de CPU
* La actividad en la UI del Master (`:8080`)

---

## 6. Observación y comparación

Completa esta tabla (aunque sea mentalmente):

| Aspecto             | pandas | Spark |
| ------------------- | ------ | ----- |
| Tiempo de ejecución |        |       |
| Uso de CPU          |        |       |
| Uso de memoria      |        |       |
| Sensación general   |        |       |

---

## 7. Preguntas clave (reflexión)

Responde en tu cuaderno o en el informe:

1. ¿Qué ha pasado al aumentar el volumen de datos?
2. ¿En qué momento pandas empieza a ser incómodo?
3. ¿Spark es siempre mejor? ¿Por qué?
4. ¿Qué coste tiene usar Spark frente a pandas?
5. ¿Qué enfoque usarías para:

   * un análisis rápido
   * un proceso periódico
   * un volumen muy grande?

---

## 8. Salida del procesamiento

Spark genera resultados en:

```
data/output/ventas_por_ciudad/
```

Estos datos se usarán en los siguientes bloques:

* Visualización con Kibana
* Trabajo interactivo con Zeppelin
* Automatización con Airflow

---

## 9. Qué deberías tener claro al terminar

Al finalizar este laboratorio deberías entender que:

* Spark no sustituye a pandas.
* Spark **escala mejor cuando el volumen crece**.
* El cambio importante no es la sintaxis, sino el modelo de ejecución.
* En Big Data real se combinan ambas herramientas.

---

## 10. Lo que viene después

En el siguiente bloque:

* Trabajaremos con formatos eficientes (Parquet).
* Prepararemos datos para visualización.
* Usaremos herramientas específicas de Big Data.

👉 **No corras**: lo importante aquí es entender el porqué.




