### **Tarea 2: Comparación de Formatos de Datos en AWS**

**Objetivo:** Experimentar con diferentes formatos de datos (CSV, JSON, Parquet y ORC) y evaluar su impacto en el almacenamiento y rendimiento al consultarlos en Amazon S3.

**Nivel:** Introducción, ideal para alumnos que no tienen experiencia previa con AWS.

---

### **Pasos para Implementar la Tarea**

#### **Paso 1: Configuración del Entorno**
1. **Acceso al Lab de AWS Academy:**
   - Inicia sesión en **AWS Academy** y abre el laboratorio asignado.
   - Accede a la consola de **AWS**.

2. **Crear un Bucket en Amazon S3:**
   - Desde la consola de AWS, busca y selecciona **Amazon S3**.
   - Haz clic en **Create Bucket**.
   - Introduce un nombre único, por ejemplo: `comparacion-formatos-grupo1`.
   - Selecciona una región (por ejemplo, "US East (N. Virginia)").
   - Deja las configuraciones predeterminadas y haz clic en **Create Bucket**.

---

#### **Paso 2: Preparar los Datos**
1. **Obtener un Conjunto de Datos:**
   - Descarga un dataset público desde [Kaggle](https://www.kaggle.com/) o utiliza un generador de datos como [Mockaroo](https://mockaroo.com/).
   - Asegúrate de que los datos tengan varias columnas y filas para que los formatos sean comparables. Ejemplo:
     - `ID`, `Name`, `Age`, `Country`, `Timestamp`.

2. **Crear Archivos en Diferentes Formatos:**
   - **CSV:** Usa Excel o Google Sheets para guardar el dataset en formato `.csv`.
   - **JSON:** Convierte los datos a formato JSON con Python o herramientas online.
   - **Parquet y ORC:** Usa Python con **pandas** para generar los formatos:
     ```python
     import pandas as pd

     # Cargar datos
     df = pd.read_csv('data.csv')

     # Guardar como Parquet
     df.to_parquet('data.parquet')

     # Guardar como ORC
     df.to_orc('data.orc')
     ```

3. **Verificar Archivos:**
   - Asegúrate de que todos los archivos tienen los mismos datos y nombres consistentes.

---

#### **Paso 3: Subir los Archivos a Amazon S3**
1. **Organización en S3:**
   - En la consola de S3, abre el bucket creado en el paso 1.
   - Crea carpetas para cada formato: `csv/`, `json/`, `parquet/`, `orc/`.

2. **Subir los Archivos:**
   - Haz clic en la carpeta correspondiente.
   - Selecciona **Upload** > **Add Files** y elige el archivo correspondiente.
   - Haz clic en **Upload** para cada formato.

---

#### **Paso 4: Medición del Tamaño de los Archivos**
1. **Verificar el Tamaño de los Archivos:**
   - En la consola de S3, abre cada carpeta y anota el tamaño de cada archivo.
   - Registra los valores en una tabla comparativa.

Ejemplo de tabla:
| **Formato** | **Tamaño (MB)** |
|-------------|-----------------|
| CSV         | 12.5            |
| JSON        | 14.3            |
| Parquet     | 3.2             |
| ORC         | 2.8             |

---

#### **Paso 5: Consultar los Datos en AWS Athena**
1. **Acceder a AWS Athena:**
   - Desde la consola de AWS, busca y selecciona **Athena**.
   - Haz clic en **Get Started** si es la primera vez que usas el servicio.

2. **Configurar un Bucket de Resultados:**
   - Athena requiere un bucket para guardar los resultados de las consultas.
   - Ve a S3 y crea un nuevo bucket llamado, por ejemplo, `athena-resultados-grupo1`.

3. **Configurar Athena:**
   - Ve a **Settings** en Athena.
   - En **Query result location**, selecciona el bucket recién creado.

4. **Crear una Base de Datos:**
   - En Athena, ejecuta la consulta:
     ```sql
     CREATE DATABASE comparacion_formatos;
     ```
   - Haz clic en **Run Query**.

5. **Crear Tablas para Cada Formato:**
   - **CSV:**
     ```sql
     CREATE EXTERNAL TABLE csv_table (
       ID INT,
       Name STRING,
       Age INT,
       Country STRING,
       Timestamp STRING
     )
     ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
     LOCATION 's3://comparacion-formatos-grupo1/csv/';
     ```
   - Repite el proceso para JSON, Parquet y ORC adaptando las configuraciones específicas.

6. **Ejecutar Consultas Simples:**
   - Por ejemplo, contar registros:
     ```sql
     SELECT COUNT(*) FROM csv_table;
     ```
   - Medir el tiempo que toma ejecutar cada consulta (Athena muestra el tiempo automáticamente).

7. **Registrar Resultados:**
   - Anota los tiempos de consulta para cada formato y agrégalo a la tabla.

Ejemplo de tabla final:
| **Formato** | **Tamaño (MB)** | **Tiempo de Consulta (s)** |
|-------------|-----------------|----------------------------|
| CSV         | 12.5            | 1.2                        |
| JSON        | 14.3            | 1.5                        |
| Parquet     | 3.2             | 0.4                        |
| ORC         | 2.8             | 0.3                        |

---

#### **Paso 6: Análisis y Reflexión**
1. **Comparar Resultados:**
   - Analiza el tamaño y tiempo de consulta para cada formato.
   - Reflexiona sobre las ventajas y desventajas en términos de almacenamiento y rendimiento.

2. **Discusión:**
   - ¿Qué formato es más eficiente en términos de tamaño?
   - ¿Qué formato permite consultas más rápidas? ¿Por qué?

---

### **Resultados Esperados**
1. **Archivos Subidos a S3:**
   - Los alumnos deben haber subido y organizado correctamente los archivos en sus carpetas correspondientes.

2. **Tamaños de Archivos:**
   - Tabla comparativa mostrando diferencias en tamaño entre formatos.

3. **Tiempos de Consulta:**
   - Tabla con tiempos de ejecución de consultas para cada formato.

4. **Análisis Final:**
   - Reflexión sobre el impacto del formato en el almacenamiento y rendimiento.

---

### **Criterios de Evaluación**
| **Aspecto Evaluado**              | **Peso (%)** |
|-----------------------------------|--------------|
| Creación y organización del bucket S3 | 25%         |
| Generación y subida de archivos    | 25%          |
| Ejecución y registro de consultas  | 30%          |
| Análisis y reflexión               | 20%          |

Esta guía paso a paso asegura que los alumnos puedan explorar y comparar formatos de datos en AWS con una experiencia práctica y resultados tangibles.
