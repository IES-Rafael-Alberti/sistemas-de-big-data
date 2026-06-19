# Pipeline completo de datos (Big Data + ML + BI)

Este es el flujo que hay que visualizar:

```
Fuentes de datos
    |
    v
Ingesta de datos
    |
    v
Procesamiento y transformación (Spark)
    |
    v
Almacenamiento analitico
    |
    +--------------------+
    |                    |
    v                    v
Machine Learning        Business Intelligence
(Spark MLlib)           (Metabase / Superset)
    |                    |
    v                    v
Predicciones          Dashboards
```

Este diagrama conecta todas las unidades:

| Unidad | Parte del pipeline     |
| ------ | ---------------------- |
| UD2    | limpieza y preparación |
| UD3    | procesamiento Spark    |
| UD4    | BI y dashboards        |
| UD5    | Machine Learning       |
| UD6    | proyecto completo      |

---

# En plata

## 1. Fuentes de datos

Datos que llegan al sistema.

Ejemplos:

* APIs
* logs
* sensores
* bases de datos
* archivos CSV o Parquet

Ejemplo real:

```
ventas.csv
transacciones.parquet
api_clientes
```

---

## 2. Ingesta de datos

Proceso de traer los datos al sistema.

Puede implicar:

* descarga
* lectura desde base de datos
* lectura desde API
* ingestión desde streams

Herramientas típicas:

* Python
* Spark
* Kafka
* ETL

---

## 3. Procesamiento de datos (Spark)

En esta fase se realiza:

* limpieza
* filtrado
* agregación
* transformación
* cálculo de métricas

Ejemplo:

```
ventas brutas
   ->
ventas limpias
   ->
ventas agregadas por ciudad
```

Esta fase suele ser **la más costosa en Big Data**.

---

## 4. Almacenamiento analítico

Los datos procesados se guardan en sistemas optimizados para análisis.

Ejemplos:

* parquet
* data warehouse
* bases analíticas

Ejemplo:

```
tabla_ventas_agregadas
tabla_clientes
tabla_metricas
```

---

## 5. Machine Learning

A partir de los datos procesados se entrenan modelos predictivos.

Ejemplos:

* predecir ventas
* detectar fraude
* clasificar clientes

Aquí entra:

**Spark MLlib**

Pipeline típico:

```
dataset
   ->
features
   ->
entrenamiento
   ->
evaluación
```

---

## 6. Business Intelligence

Los resultados se visualizan mediante dashboards.

Herramientas vistas:

* Metabase
* Superset
* Power BI

Ejemplos de paneles:

* evolución de ventas
* comportamiento de clientes
* resultados del modelo

---

# Dónde entra Airflow

Airflow permite **automatizar el pipeline completo**.

Ejemplo:

```
DAG diario

1 descargar datos
2 ejecutar Spark
3 actualizar dataset
4 entrenar modelo
5 actualizar dashboard
```

Esto convierte el sistema en un **pipeline automatizado de datos**.

---

# Version simplificada para diapositiva

Puedes usar esta en clase:

```
Datos
 |
 v
Ingesta
 |
 v
Spark (procesamiento)
 |
 v
Datos analiticos
 | \
 |  \
 v   v
ML   BI
```

---

# Mensaje clave

Los algoritmos de ML **no son lo importante**.

Lo importante es el sistema completo:

```
datos -> pipeline -> modelo -> decision
```
