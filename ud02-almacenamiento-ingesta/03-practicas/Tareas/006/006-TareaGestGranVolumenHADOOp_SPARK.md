### Tarea: Procesamiento de Datos Masivos con Apache Spark en AWS

#### **Objetivo**
Aprender a configurar, ejecutar y analizar un flujo de trabajo de procesamiento de datos masivos utilizando Apache Spark en un entorno basado en AWS.

#### **Requisitos Previos**
- Cuenta habilitada en AWS Academy con acceso a los Learner Labs.
- Conocimiento básico de Python o Scala para trabajar con Spark.
- Familiaridad con los conceptos de Big Data y tecnologías como Hadoop y Spark.

#### **Instrucciones**

1. **Preparación del Entorno en AWS**
   - Accede a AWS Academy y abre el Learner Lab correspondiente.
   - Crea una instancia de EMR (Elastic MapReduce) para gestionar clústeres Spark:
     - Configura un clúster con Apache Spark preinstalado.
     - Selecciona un tamaño de clúster adecuado (por ejemplo, 1 master y 2 worker nodes con instancias `m5.xlarge`).
     - Asegúrate de habilitar HDFS para almacenamiento.

2. **Carga de Datos**
   - Descarga un dataset público (por ejemplo, el conjunto de datos de logs de acceso web de NASA, disponible en [Kaggle](https://www.kaggle.com)).
   - Sube el dataset al almacenamiento S3 creado dentro del clúster EMR.

3. **Procesamiento de Datos en Spark**
   - Abre un notebook Jupyter configurado con el clúster Spark (disponible en EMR).
   - Realiza las siguientes operaciones:
     - **Carga del Dataset:** Utiliza Spark para leer los datos desde S3.
     - **Limpieza de Datos:** Filtra las filas incompletas o con errores.
     - **Análisis Básico:**
       - Calcula la cantidad de solicitudes por día.
       - Identifica las páginas más visitadas.
       - Genera estadísticas descriptivas (máximos, mínimos, promedios).

4. **Visualización de Resultados**
   - Utiliza bibliotecas como `matplotlib` o `seaborn` para generar gráficos de los resultados.
   - Visualiza directamente en el notebook o guarda las imágenes en S3 para su descarga.

5. **Optimización**
   - Aplica una partición eficiente a los datos basándote en campos como la fecha.
   - Evalúa cómo las particiones impactan el tiempo de procesamiento.

6. **Entrega**
   - Documenta los pasos realizados, incluyendo capturas de pantalla del clúster Spark y del notebook con los resultados.
   - Genera un informe final que incluya:
     - Configuración del clúster.
     - Código utilizado.
     - Gráficos generados.
     - Reflexiones sobre el impacto de Spark en la rapidez y eficacia del procesamiento.

#### **Criterios de Evaluación**
- Correcta configuración del entorno Spark en AWS.
- Uso adecuado de Spark para leer, procesar y analizar datos.
- Calidad y claridad del informe entregado.
- Implementación de técnicas de optimización en Spark.
- Creatividad en las visualizaciones y análisis.

---
El bucket S3 no se genera automáticamente al crear un clúster EMR. En AWS EMR, debes configurar y asociar un bucket S3 manualmente como parte del flujo de trabajo. Aquí tienes las claves para identificar y trabajar con el bucket S3 en relación con un clúster EMR:

### Configuración del Bucket S3 al Crear el Clúster
1. **Durante la creación del clúster EMR**, en la sección "Advanced Options":
   - En "Cluster Logs", puedes especificar un bucket S3 para almacenar logs y resultados.
   - En "Debugging", habilita la opción para depuración y asigna un bucket S3.

2. **Subir datos al Bucket S3:**
   - Crea un bucket S3 en el servicio **Amazon S3** de AWS antes de iniciar el clúster (puedes usar la consola de S3 para crearlo).
   - Sube el dataset al bucket.

3. **Configuración del Bucket en Spark:**
   - Accede al cluster EMR.
   - En el notebook o script Spark, utiliza la ruta del bucket S3 para cargar o guardar datos:
     ```python
     s3_bucket = "s3://nombre-del-bucket/directorio/"
     data = spark.read.csv(f"{s3_bucket}archivo.csv")
     ```

### Verificación del Bucket Asociado al Clúster
Si necesitas confirmar qué bucket está asociado:
1. **En la consola de AWS EMR:**
   - Ve a la sección **"Cluster Summary"**.
   - Busca el campo **"Cluster Logs"**, donde se muestra la ruta del bucket asociado para logs (si fue configurado).

2. **En el script Spark o en Jupyter Notebook:**
   - Si el bucket está configurado como almacenamiento principal, puedes acceder a los datos directamente desde la ruta `s3://nombre-del-bucket/`.

### Acceso a Datos en S3 desde el Clúster
Para interactuar con el bucket S3 desde el clúster:
- **Subir Datos al Bucket:**
  Usa la consola de S3 o la CLI de AWS:
  ```bash
  aws s3 cp archivo.csv s3://nombre-del-bucket/directorio/
  ```
- **Acceso desde Spark:**
  En Python o Scala, asegúrate de que Spark esté configurado para interactuar con S3 (lo está por defecto en EMR):
  ```python
  data = spark.read.csv("s3://nombre-del-bucket/archivo.csv")
  ```

Si no configuraste un bucket al inicio, crea uno en S3 y asegúrate de subir tus datos para que Spark pueda procesarlos.
