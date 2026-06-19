# UD3 — Laboratorio 4: Apache Zeppelin y Spark interactivo
## Versión definitiva (decisiones técnicas cerradas)



## 1. Objetivo del laboratorio

El objetivo de este laboratorio es **introducir Apache Zeppelin como entorno de análisis interactivo sobre Spark**, de forma estable y coherente con lo trabajado previamente en la UD3.

En este laboratorio aprenderás a:

- Utilizar Apache Zeppelin como entorno de notebooks.
- Ejecutar código PySpark de forma interactiva.
- Analizar datos en formato Parquet.
- Utilizar Spark SQL desde un notebook.
- Comprender el papel de Zeppelin dentro de un sistema Big Data real.
- Diferenciar entre **Spark distribuido** y **Spark interactivo**.

---

## 2. Contexto pedagógico (muy importante)

En los laboratorios anteriores ya se ha trabajado:

- Spark en modo distribuido (Master / Worker).
- Procesamiento paralelo de grandes volúmenes.
- Comparativa Spark vs pandas.
- Formatos optimizados (Parquet) y particionado.

Por tanto, **el despliegue del clúster Spark NO es el objetivo de este laboratorio**.

👉 En este laboratorio, Zeppelin se utiliza **únicamente como herramienta de análisis interactivo**, no como entorno de despliegue.

---

## 3. Decisión técnica final

En este laboratorio:

- Apache Zeppelin se ejecuta en un contenedor independiente.
- Zeppelin utiliza **Spark en modo local (`local[*]`)**.
- Los datos utilizados son datasets grandes ya preparados.
- No se utiliza Hadoop.
- No se utiliza Git como backend de notebooks.

### Justificación

- El uso de Spark distribuido **ya ha sido evaluado**.
- Zeppelin requiere acceso al binario `spark-submit`, lo que complica innecesariamente la arquitectura.
- El uso de Spark local permite:
  - estabilidad,
  - simplicidad,
  - foco en el análisis,
  - evitar problemas de permisos y dependencias.

👉 Esta decisión es **pedagógicamente correcta y profesional**.

---

## 4. Preparación del entorno

### 4.1 Directorios necesarios en el host

Antes de arrancar Zeppelin, crea las siguientes carpetas:

```bash
mkdir -p zeppelin/notebook zeppelin/logs
chmod -R 777 zeppelin
````

> En entornos docentes se usan permisos amplios para evitar problemas que no forman parte del objetivo del laboratorio.

---

## 5. Docker Compose de Zeppelin (configuración estable)

Crea el fichero `docker-compose.zeppelin.yml` con el siguiente contenido:

```yaml
services:
  zeppelin:
    image: apache/zeppelin:0.11.1
    container_name: zeppelin
    environment:
      - USE_HADOOP=false
      - ZEPPELIN_NOTEBOOK_STORAGE=org.apache.zeppelin.notebook.repo.VFSNotebookRepo
      - ZEPPELIN_NOTEBOOK_DIR=/notebook
    ports:
      - "8082:8080"
    volumes:
      - ./zeppelin/notebook:/notebook
      - ./zeppelin/logs:/opt/zeppelin/logs
      - ./data:/opt/spark-data
```

### Decisiones clave de esta configuración

* ❌ GitNotebookRepo desactivado (evita errores de permisos).
* ❌ Hadoop desactivado.
* ✔ Persistencia simple de notebooks.
* ✔ Compatible con Linux, WSL y equipos del centro.

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

No deben aparecer errores de permisos ni referencias a `.git`.

---

## 7. Acceso a la interfaz web

Abre el navegador:

```
http://localhost:8082
```

Si ves la interfaz de Zeppelin, el servicio está correctamente levantado.

---

## 8. Configuración del intérprete Spark (PASO OBLIGATORIO)

Antes de ejecutar cualquier celda:

1. Accede a **Interpreter**
2. Localiza el intérprete **Spark**
3. Configura:

   ```
   master = local[*]
   ```
4. Guarda los cambios
5. Reinicia el intérprete

👉 Esto indica a Zeppelin que use Spark en modo local.

---

## 9. Creación del primer notebook

1. Pulsa **Create new note**
2. Nombre:

   ```
   UD3_Zeppelin_Exploracion
   ```
3. Intérprete: **pyspark**

Si aparece algún error:

* revisa permisos de `zeppelin/notebook`,
* asegúrate de haber aplicado `chmod -R 777 zeppelin`,
* reinicia el contenedor.

---

## 10. Primeras celdas (muy guiadas)

### 10.1 Comprobar SparkSession

```python
spark
```

Debe mostrarse información de la sesión Spark activa.

---

### 10.2 Lectura de datos Parquet

```python
df = spark.read.parquet("/opt/spark-data/parquet/ventas")
df.printSchema()
```

---

### 10.3 Visualización de datos

```python
df.show(10)
```

---

### 10.4 Filtro y agregación

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

## 11. Uso de Spark SQL en Zeppelin

### 11.1 Crear vista temporal

```python
df.createOrReplaceTempView("ventas")
```

---

### 11.2 Consulta SQL

```sql
%sql
SELECT ciudad, COUNT(*) AS num_ventas, SUM(importe) AS total
FROM ventas
GROUP BY ciudad
ORDER BY total DESC
```

Prueba también las visualizaciones desde Zeppelin.

---

## 12. Problemas habituales y soluciones

### ❌ Error al crear notebooks (`Permission denied`)

**Causa**: la carpeta `zeppelin/notebook` no es escribible.
**Solución**:

```bash
chmod -R 777 zeppelin
docker compose down
docker compose up -d
```

---

### ❌ Errores relacionados con Git o `.git`

**Causa**: uso de GitNotebookRepo.
**Solución**: usar `VFSNotebookRepo` (ya configurado).

---

### ❌ Error relacionado con `spark-submit`

**Causa**: Zeppelin no tiene acceso a Spark distribuido.
**Solución**: usar Spark en modo local (`local[*]`).

---

## 13. Buenas prácticas (mensaje clave)

* Zeppelin es adecuado para:

  * exploración,
  * análisis interactivo,
  * validación de datos.
* Los scripts Spark siguen siendo necesarios para:

  * procesos productivos,
  * automatización,
  * ejecución distribuida real.

---

## 14. Evidencias para la entrega

Incluye en la entrega:

* captura del notebook Zeppelin,
* celda con lectura Parquet,
* celda con agregación o SQL,
* breve reflexión sobre el uso de Zeppelin.

---

## 15. Conclusión

Apache Zeppelin permite trabajar de forma cómoda sobre Spark sin perder los conceptos de Big Data.
En este laboratorio se ha priorizado la **estabilidad y el aprendizaje**, no la complejidad de despliegue.

---

## Fin del Laboratorio 4

```

---

## Estado final (puedes estar tranquilo)

- Problemas técnicos **cerrados**
- Decisiones **justificadas**
- Documento **coherente y defendible**
- UD3 **redonda**

A partir de aquí, ya puedes seguir con **Kibana** sin ninguna deuda técnica ni sensación de “chapuza”.

Si quieres, el siguiente paso natural es:
- **Documento de entrega del Lab 4**, o  
- **Laboratorio 2 de Kibana (dashboards)**.
```