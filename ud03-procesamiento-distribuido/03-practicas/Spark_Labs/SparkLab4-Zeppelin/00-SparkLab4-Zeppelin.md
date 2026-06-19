# UD3 — Laboratorio 4: Apache Zeppelin y Spark interactivo
## Versión actualizada (con resolución de errores habituales)

---

## 1. Objetivos del laboratorio

En este laboratorio aprenderás a:

- Utilizar Apache Zeppelin como entorno de notebooks para Spark.
- Conectarte a un clúster Spark existente.
- Explorar datos en formato Parquet de forma interactiva.
- Ejecutar consultas PySpark y Spark SQL.
- Comprender el papel de Zeppelin dentro de un flujo Big Data real.
- Resolver problemas habituales de configuración en entornos Docker.

---

## 2. Contexto del laboratorio

Hasta ahora has trabajado con:

- procesamiento distribuido con Spark,
- datasets grandes,
- formatos optimizados (Parquet),
- particionado.

Zeppelin se introduce **después** de Spark como una herramienta de:

- exploración,
- análisis interactivo,
- validación de resultados.

👉 Zeppelin **no sustituye** a los scripts Spark ni a los procesos productivos.

---

## 3. Arquitectura de trabajo

En este laboratorio:

- Spark se ejecuta como clúster (Master / Worker).
- Zeppelin se ejecuta en un contenedor independiente.
- Zeppelin se conecta al Spark Master remoto.
- Los notebooks se almacenan en el sistema de ficheros local (sin Git).

---

## 4. Preparación del entorno

### 4.1 Directorios necesarios en el host

Antes de arrancar Zeppelin, crea las siguientes carpetas:

```bash
mkdir -p zeppelin/logs zeppelin/notebook
````

⚠️ **Muy importante**: estas carpetas deben ser escribibles.

Se recomienda, en entorno docente:

```bash
chmod -R 777 zeppelin
```

> Esto evita problemas de permisos que no forman parte del objetivo del laboratorio.

---

## 5. Docker Compose de Zeppelin (configuración estable)

Utiliza el siguiente fichero `docker-compose.zeppelin.yml`:

```yaml
services:
  zeppelin:
    image: apache/zeppelin:0.11.1
    container_name: zeppelin
    environment:
      - USE_HADOOP=false
      - ZEPPELIN_NOTEBOOK_STORAGE=org.apache.zeppelin.notebook.repo.VFSNotebookRepo
      - ZEPPELIN_NOTEBOOK_DIR=/notebook
      - ZEPPELIN_LOG_DIR=/opt/zeppelin/logs
      - MASTER=spark://spark-master:7077
      - SPARK_MASTER=spark://spark-master:7077
    ports:
      - "8082:8080"
    volumes:
      - ./zeppelin/notebook:/notebook
      - ./zeppelin/logs:/opt/zeppelin/logs
      - ./data:/opt/spark-data
```

### Decisiones importantes de esta configuración

* ❌ Git desactivado (`VFSNotebookRepo`)
* ❌ Hadoop desactivado
* ✔ Persistencia simple de notebooks
* ✔ Compatible con Linux, WSL y equipos del centro

---

## 6. Arranque de Zeppelin

Desde la carpeta del proyecto:

```bash
docker compose -f docker-compose.zeppelin.yml up -d
```

Comprueba los logs:

```bash
docker logs zeppelin
```

Debes **NO ver errores de permisos** ni referencias a `.git`.

---

## 7. Acceso a la interfaz web

Abre el navegador:

```
http://localhost:8082
```

Si ves la interfaz de Zeppelin, el servicio está correctamente levantado.

---

## 8. Creación del primer notebook

1. Pulsa **Create new note**
2. Nombre del notebook:

   ```
   UD3_Zeppelin_Exploracion
   ```
3. Intérprete: **pyspark**

Si aparece un error al crear el notebook:

* revisa permisos de `zeppelin/notebook`,
* asegúrate de haber aplicado `chmod -R 777 zeppelin`,
* reinicia el contenedor.

---

## 9. Primeras celdas (muy guiadas)

### 9.1 Comprobar SparkSession
Perfecto. A continuación tienes el **Laboratorio 4 (Zeppelin) actualizado**, **integrando explícitamente los errores reales que han aparecido y su solución**, de forma **didáctica, preventiva y limpia**.
Está pensado para que **el alumnado no se bloquee** y para que tú **no tengas que improvisar en clase**.

Puedes **sustituir directamente** el Lab 4 anterior por este.

---

````markdown
# UD3 — Laboratorio 4: Apache Zeppelin y Spark interactivo
## Versión actualizada (con resolución de errores habituales)

---

## 1. Objetivos del laboratorio

En este laboratorio aprenderás a:

- Utilizar Apache Zeppelin como entorno de notebooks para Spark.
- Conectarte a un clúster Spark existente.
- Explorar datos en formato Parquet de forma interactiva.
- Ejecutar consultas PySpark y Spark SQL.
- Comprender el papel de Zeppelin dentro de un flujo Big Data real.
- Resolver problemas habituales de configuración en entornos Docker.

---

## 2. Contexto del laboratorio

Hasta ahora has trabajado con:

- procesamiento distribuido con Spark,
- datasets grandes,
- formatos optimizados (Parquet),
- particionado.

Zeppelin se introduce **después** de Spark como una herramienta de:

- exploración,
- análisis interactivo,
- validación de resultados.

👉 Zeppelin **no sustituye** a los scripts Spark ni a los procesos productivos.

---

## 3. Arquitectura de trabajo

En este laboratorio:

- Spark se ejecuta como clúster (Master / Worker).
- Zeppelin se ejecuta en un contenedor independiente.
- Zeppelin se conecta al Spark Master remoto.
- Los notebooks se almacenan en el sistema de ficheros local (sin Git).

---

## 4. Preparación del entorno

### 4.1 Directorios necesarios en el host

Antes de arrancar Zeppelin, crea las siguientes carpetas:

```bash
mkdir -p zeppelin/logs zeppelin/notebook
````

⚠️ **Muy importante**: estas carpetas deben ser escribibles.

Se recomienda, en entorno docente:

```bash
chmod -R 777 zeppelin
```

> Esto evita problemas de permisos que no forman parte del objetivo del laboratorio.

---

## 5. Docker Compose de Zeppelin (configuración estable)

Utiliza el siguiente fichero `docker-compose.zeppelin.yml`:

```yaml
services:
  zeppelin:
    image: apache/zeppelin:0.11.1
    container_name: zeppelin
    environment:
      - USE_HADOOP=false
      - ZEPPELIN_NOTEBOOK_STORAGE=org.apache.zeppelin.notebook.repo.VFSNotebookRepo
      - ZEPPELIN_NOTEBOOK_DIR=/notebook
      - ZEPPELIN_LOG_DIR=/opt/zeppelin/logs
      - MASTER=spark://spark-master:7077
      - SPARK_MASTER=spark://spark-master:7077
    ports:
      - "8082:8080"
    volumes:
      - ./zeppelin/notebook:/notebook
      - ./zeppelin/logs:/opt/zeppelin/logs
      - ./data:/opt/spark-data
```

### Decisiones importantes de esta configuración

* ❌ Git desactivado (`VFSNotebookRepo`)
* ❌ Hadoop desactivado
* ✔ Persistencia simple de notebooks
* ✔ Compatible con Linux, WSL y equipos del centro

---

## 6. Arranque de Zeppelin

Desde la carpeta del proyecto:

```bash
docker compose -f docker-compose.zeppelin.yml up -d
```

Comprueba los logs:

```bash
docker logs zeppelin
```

Debes **NO ver errores de permisos** ni referencias a `.git`.

---

## 7. Acceso a la interfaz web

Abre el navegador:

```
http://localhost:8082
```

Si ves la interfaz de Zeppelin, el servicio está correctamente levantado.

---

## 8. Creación del primer notebook

1. Pulsa **Create new note**
2. Nombre del notebook:

   ```
   UD3_Zeppelin_Exploracion
   ```
3. Intérprete: **pyspark**

Si aparece un error al crear el notebook:

* revisa permisos de `zeppelin/notebook`,
* asegúrate de haber aplicado `chmod -R 777 zeppelin`,
* reinicia el contenedor.

---

## 9. Primeras celdas (muy guiadas)

### 9.1 Comprobar SparkSession

```python
spark
```

Esto confirma que Zeppelin está conectado al clúster Spark.

---

### 9.2 Leer datos Parquet

```python
df = spark.read.parquet("/opt/spark-data/parquet/ventas")
df.printSchema()
```

---

### 9.3 Visualización rápida

```python
df.show(10)
```

---

### 9.4 Filtro y agregación

```python
(
    df.filter(df.importe > 100)
      .groupBy("ciudad")
      .count()
      .orderBy("count", ascending=False)
      .show()
)
```

---

## 10. Uso de Spark SQL en Zeppelin

### 10.1 Crear vista temporal

```python
df.createOrReplaceTempView("ventas")
```

---

### 10.2 Consulta SQL

```sql
%sql
SELECT ciudad, COUNT(*) AS num_ventas, SUM(importe) AS total
FROM ventas
GROUP BY ciudad
ORDER BY total DESC
```

Prueba la visualización desde la interfaz de Zeppelin.

---

## 11. Problemas habituales y soluciones

### ❌ Error al crear notebook (`Permission denied`)

**Causa**: la carpeta `zeppelin/notebook` no es escribible.
**Solución**:

```bash
chmod -R 777 zeppelin
docker compose down
docker compose up -d
```

---

### ❌ Errores relacionados con `.git`

**Causa**: GitNotebookRepo activado.
**Solución**: usar `VFSNotebookRepo` (ya incluido en el compose).

---

### ⚠️ Avisos sobre Hadoop

Son normales. Hadoop no se usa en este laboratorio.

---

## 12. Buenas prácticas (mensaje clave)

* Zeppelin es ideal para:

  * exploración,
  * análisis interactivo,
  * validación de datos.
* Los scripts Spark siguen siendo necesarios para:

  * procesos productivos,
  * automatización,
  * pipelines.

---

## 13. Evidencias para la entrega

Incluye en la entrega:

* captura del notebook Zeppelin,
* celda con lectura Parquet,
* celda con agregación o SQL,
* breve reflexión sobre el uso de Zeppelin.

---

## 14. Conclusión

Apache Zeppelin permite trabajar de forma cómoda sobre Spark sin perder el motor Big Data.
Es una herramienta de **apoyo al análisis**, no un sustituto del procesamiento distribuido.

---

## Fin del Laboratorio 4

```

---

## Estado final de la UD3 (tranquilo ya 😄)

- Spark ✔
- Volumen ✔
- Parquet ✔
- Zeppelin ✔ (estable)
- Kibana ✔ (siguiente bloque)

Si quieres, el siguiente paso natural es:
- **Documento de entrega del Lab 1 de Kibana**, o  
- **Laboratorio 2 de Kibana (dashboards)**.
```
```python
spark
```

Esto confirma que Zeppelin está conectado al clúster Spark.

---

### 9.2 Leer datos Parquet

```python
df = spark.read.parquet("/opt/spark-data/parquet/ventas")
df.printSchema()
```

---

### 9.3 Visualización rápida

```python
df.show(10)
```

---

### 9.4 Filtro y agregación

```python
(
    df.filter(df.importe > 100)
      .groupBy("ciudad")
      .count()
      .orderBy("count", ascending=False)
      .show()
)
```

---

## 10. Uso de Spark SQL en Zeppelin

### 10.1 Crear vista temporal

```python
df.createOrReplaceTempView("ventas")
```

---

### 10.2 Consulta SQL

```sql
%sql
SELECT ciudad, COUNT(*) AS num_ventas, SUM(importe) AS total
FROM ventas
GROUP BY ciudad
ORDER BY total DESC
```

Prueba la visualización desde la interfaz de Zeppelin.

---

## 11. Problemas habituales y soluciones

### ❌ Error al crear notebook (`Permission denied`)

**Causa**: la carpeta `zeppelin/notebook` no es escribible.
**Solución**:

```bash
chmod -R 777 zeppelin
docker compose down
docker compose up -d
```

---

### ❌ Errores relacionados con `.git`

**Causa**: GitNotebookRepo activado.
**Solución**: usar `VFSNotebookRepo` (ya incluido en el compose).

---

### ⚠️ Avisos sobre Hadoop

Son normales. Hadoop no se usa en este laboratorio.

---

## 12. Buenas prácticas (mensaje clave)

* Zeppelin es ideal para:

  * exploración,
  * análisis interactivo,
  * validación de datos.
* Los scripts Spark siguen siendo necesarios para:

  * procesos productivos,
  * automatización,
  * pipelines.

---

## 13. Evidencias para la entrega

Incluye en la entrega:

* captura del notebook Zeppelin,
* celda con lectura Parquet,
* celda con agregación o SQL,
* breve reflexión sobre el uso de Zeppelin.

---

## 14. Conclusión

Apache Zeppelin permite trabajar de forma cómoda sobre Spark sin perder el motor Big Data.
Es una herramienta de **apoyo al análisis**, no un sustituto del procesamiento distribuido.

---

## Fin del Laboratorio 4



