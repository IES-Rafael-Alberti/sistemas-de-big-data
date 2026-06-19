# Práctica: ELT serverless con AWS (S3 + Glue + Athena)

> **Propósito**: Contrastar el enfoque ELT tradicional (pipeline que mueve datos)
> con el enfoque **serverless**: los datos se quedan en S3, se catalogan y se
> consultan donde están. Sin pipeline que gestionar.
>
> **Duración estimada**: 45-60 minutos.
>
> **Prerrequisito**: Tener la práctica Ruta A (dlt) completada.
>
> **Importante**: AWS Academy debe estar activo y los servicios validados por el
> docente. Esta práctica no es evaluable.

---

## 1. Acceso a AWS

El docente te indicará cómo acceder a tu laboratorio AWS Academy.

Una vez dentro de la consola AWS, verifica que tienes acceso a:

- **S3** (Simple Storage Service)
- **AWS Glue** (Crawlers + Data Catalog)
- **Athena**

> Si algún servicio no aparece, avisa al docente. Los laboratorios AWS Academy
> tienen permisos preconfigurados que pueden variar.

---

## 2. Subir datos a S3 (Raw datalake)

En la práctica con dlt tenías los datos en CSV y los cargabas a DuckDB.
Ahora los vas a dejar en S3, que actúa como **data lake raw**.

1. Ve a **S3 → Create bucket**.
   - **Bucket name**: `sbd-alu-XXXX-raw` (donde XXXX es tu número de alumno o grupo).
     Los nombres de bucket S3 son **globales**, así que debe ser único.
   - **Region**: la que indique el docente.
   - **Block all public access**: activado (no necesitamos que sea público).
   - **Create bucket**.

2. Dentro del bucket, crea carpetas organizadas por capa:
   ```text
   sbd-alu-XXXX-raw/
     raw/
       ventas/
       reservas/
       meteo/
       zonas/
   ```

3. Sube los archivos desde tu máquina local (o desde la instancia cloud):
   - Sube `ventas.csv` a `raw/ventas/`
   - Sube `reservas.jsonl` a `raw/reservas/`
   - etc.

   Puedes hacerlo desde la consola web (Upload) o desde CloudShell si está disponible:

   ```bash
   # Desde AWS CloudShell
   aws s3 cp ventas.csv s3://sbd-alu-XXXX-raw/raw/ventas/
   ```

---

## 3. Catalogar con Glue Crawler

AWS Glue Crawler inspecciona los archivos, detecta el esquema y lo registra
en el **Data Catalog** para que Athena pueda consultarlos.

1. Ve a **AWS Glue → Crawlers → Create crawler**.
   - **Name**: `crawler-medallion-XXXX`
   - **Data sources**: S3 → selecciona `sbd-alu-XXXX-raw/raw/`
     (la carpeta raíz, para que escanee todos los subdirectorios).
   - **IAM role**: elige `AWSGlueServiceRole-XXXX` o crea uno nuevo.
   - **Output database**: crea una base de datos nueva, p.ej. `medallion_airbyte`.
   - **Schedule**: `On-demand` (lo ejecutaremos manualmente).
   - **Create**.

2. Selecciona el crawler y **Run**.

3. Espera a que termine (suele tardar 1-3 minutos). Cuando el estado sea
   **Ready**, ve a **Databases → Tables** y deberías ver las tablas
   creadas automáticamente: `raw_ventas`, `raw_reservas`, etc.

---

## 4. Consultar con Athena

1. Ve a **Athena**.
2. Selecciona la base de datos `medallion_airbyte`.
3. En el editor de consultas, escribe:

   ```sql
   SELECT * FROM raw_ventas LIMIT 10;
   ```

4. Athena muestra los datos directamente desde S3. **No moviste los datos
   a ningún lado** — los consultas donde están.

5. Prueba una consulta analítica:

   ```sql
   SELECT
     DATE_TRUNC('day', fecha) AS dia,
     COUNT(DISTINCT comercio_id) AS comercios_activos,
     SUM(unidades) AS total_unidades,
     SUM(importe) AS total_importe
   FROM raw_ventas
   GROUP BY DATE_TRUNC('day', fecha)
   ORDER BY dia;
   ```

6. Y con join:

   ```sql
   SELECT
     v.fecha,
     v.comercio,
     v.importe,
     z.nombre AS zona
   FROM raw_ventas v
   LEFT JOIN raw_zonas z ON v.zona_id = z.zona_id;
   ```

> **Nota**: Athena cobra por TB escaneado. Si el laboratorio tiene límites,
> las consultas sobre estos CSVs pequeños escanean pocos KB y no deberían
> generar coste significativo.

---

## 5. Ampliación: Glue ETL (Spark gestionado)

Si el laboratorio lo permite, puedes crear un **Glue ETL job** que transforme
los datos con PySpark antes de que Athena los consulte.

1. Ve a **AWS Glue → ETL Jobs → Spark script editor → Source**:
   - Source: las tablas del catálogo (`raw_ventas`, etc.)
   - Transform: un JOIN simple (como hiciste en la práctica Medallion)
   - Target: un nuevo dataset en S3, p.ej. `sbd-alu-XXXX-raw/curated/`

2. Glue genera un script PySpark que puedes inspeccionar y modificar.
   Ejecútalo y verifica el resultado desde Athena.

Esta ampliación conecta directamente con el contenido de **Spark de UD3**
(procesamiento distribuido). De hecho, el mismo script PySpark que usaste
en el benchmark de UD3 podría ejecutarse aquí como Glue job.

---

## 6. Comparación con dlt y Airbyte

Completa la tabla añadiendo la columna AWS:

| Aspecto | dlt | Airbyte | AWS Serverless |
|---------|-----|---------|----------------|
| ¿Qué necesité instalar? | | | |
| ¿Dónde viven los datos? | | | |
| ¿Hay un pipeline que mover? | | | |
| ¿Qué tan fácil es debuggear? | | | |
| Coste económico | | | |
| ¿Para qué proyecto? | | | |

Preguntas de reflexión:

1. **El enfoque serverless (S3 + Athena) elimina el concepto de "pipeline ELT".**
   Los datos se quedan en S3 y se consultan donde están. ¿Es siempre mejor?
   ¿Cuándo necesitas un pipeline aunque tengas S3?

2. **Coste**: dlt es gratis (solo tu ordenador). Airbyte necesita un servidor.
   AWS cobra por almacenamiento y consulta. ¿Cómo afecta esto a una PYME?
   ¿Y a una gran empresa?

3. **Vendor lock-in**: si montas todo en AWS, ¿qué pasa si quieres migrar a
   Azure o Google Cloud? ¿Y si usas dlt con DuckDB?

4. **Formato de datos**: AWS cobra por TB escaneado en Athena. Si los CSVs
   son grandes, ¿cómo reducirías el coste? (Pista: Parquet, compresión,
   particionamiento).

5. **¿Cuál de los tres enfoques (dlt, Airbyte, AWS) elegirías para un
   proyecto integrador de SBD?** Justifica tu respuesta con criterios
   de coste, aprendizaje, flexibilidad y realismo.

---

## 7. Recursos adicionales

- [AWS Glue Crawler docs](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)
- [Amazon Athena query examples](https://docs.aws.amazon.com/athena/latest/ug/querying.html)
- [AWS Academy](https://aws.amazon.com/es/training/awsacademy/) (portal del alumno)

---

## Histórico

| Fecha       | Cambio |
|-------------|--------|
| 2026-06-18 | Creación de la práctica AWS serverless. Servicios pendientes de validación en AWS Academy. |
