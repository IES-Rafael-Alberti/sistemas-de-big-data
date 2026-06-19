### **Actualización de la Tarea para Trabajar con un Archivo Parquet en HDFS Usando EMR y PySpark**

#### **Descripción Actualizada**
En esta actividad, los alumnos cargarán un archivo Parquet en HDFS, configurarán su entorno PySpark y realizarán operaciones básicas en el archivo para familiarizarse con HDFS, EMR y PySpark.

---

### **Pasos Detallados**

---

#### **Paso 1: Subir el Archivo a CloudShell**
1. Abre **AWS CloudShell** desde la consola de AWS.
2. Sube el archivo Parquet a CloudShell utilizando la opción **Upload File**.
3. Confirma que el archivo se haya subido correctamente listando el directorio actual:
   ```bash
   ls -la
   ```
   Deberías ver el archivo subido (por ejemplo, `airline_passenger_satisfaction.parquet`).

---

#### **Paso 2: Transferir el Archivo al Nodo Maestro de EMR**
1. Identifica la clave privada que usaste para crear tu clúster EMR (por ejemplo, `vockey.pem`) y verifica que esté disponible en CloudShell.
2. Usa `scp` para transferir el archivo desde CloudShell al nodo maestro del clúster EMR:
   ```bash
   scp -i ~/vockey.pem airline_passenger_satisfaction.parquet hadoop@<Master-Public-DNS>:/home/hadoop/
   ```
   Reemplaza `<Master-Public-DNS>` con la dirección pública del nodo maestro del clúster EMR (disponible en la consola de EMR bajo "Cluster Details").

---

#### **Paso 3: Subir el Archivo a HDFS**
1. Conéctate al nodo maestro del clúster EMR usando SSH:
   ```bash
   ssh -i ~/vockey.pem hadoop@<Master-Public-DNS>
   ```
2. Verifica que el archivo esté en el nodo maestro:
   ```bash
   ls -l /home/hadoop/
   ```
3. Crea un directorio en HDFS para almacenar el archivo:
   ```bash
   hdfs dfs -mkdir -p /user/data/
   ```
4. Sube el archivo a HDFS:
   ```bash
   hdfs dfs -put /home/hadoop/airline_passenger_satisfaction.parquet /user/data/
   ```
5. Verifica que el archivo se haya subido correctamente:
   ```bash
   hdfs dfs -ls /user/data/
   ```

---

#### **Paso 4: Configurar PySpark en el Nodo Maestro**
1. Instala PySpark si no está instalado:
   ```bash
   sudo pip3 install pyspark
   ```
   **Nota:** Si ves advertencias sobre la instalación como root, considera usar un entorno virtual:
   ```bash
   python3 -m venv pyspark-env
   source pyspark-env/bin/activate
   pip install pyspark
   ```
2. Confirma que PySpark está instalado ejecutando:
   ```bash
   pyspark --version
   ```

---

#### **Paso 5: Crear un Script PySpark**
1. Crea un archivo Python llamado `pruebaSpar.py` en el nodo maestro:
   ```bash
   nano pruebaSpar.py
   ```
2. Escribe el siguiente código en el archivo:
   ```python
   from pyspark.sql import SparkSession

   # Crear una sesión Spark
   spark = SparkSession.builder.appName("LeerParquet").getOrCreate()

   # Leer el archivo Parquet desde HDFS
   df = spark.read.parquet("hdfs:///user/data/airline_passenger_satisfaction.parquet")

   # Mostrar el esquema y las primeras filas
   df.printSchema()
   df.show()
   ```

3. Guarda y cierra el archivo (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

#### **Paso 6: Ejecutar el Script PySpark**
1. Ejecuta el script usando `spark-submit`:
   ```bash
   spark-submit pruebaSpar.py
   ```
2. Observa la salida en la terminal. Deberías ver el esquema del archivo y las primeras filas del DataFrame.

---

### **Notas Adicionales**
1. **Errores Comunes:**
   - Si aparece `PATH_NOT_FOUND`, asegúrate de que la ruta al archivo en HDFS sea correcta y de que el archivo esté en el directorio `/user/data/`.
   - Si recibes un error `Permission denied`, verifica los permisos del archivo en CloudShell y en HDFS.

2. **Depuración:**
   - Para verificar la conexión con HDFS, usa:
     ```python
     spark.sparkContext._jvm.org.apache.hadoop.fs.FileSystem.get(
         spark._jsc.hadoopConfiguration()
     ).listStatus(spark._jvm.org.apache.hadoop.fs.Path("/user/data"))
     ```

3. **Limpieza:**
   - Después de completar la actividad, puedes eliminar el archivo de HDFS para liberar espacio:
     ```bash
     hdfs dfs -rm /user/data/airline_passenger_satisfaction.parquet
     ```

---

### **Resultados Esperados**
Al finalizar esta actividad,  habremos aprendido a:
- Subir un archivo Parquet desde CloudShell a HDFS.
- Configurar y usar PySpark en un clúster EMR.
- Realizar operaciones básicas en un DataFrame de PySpark.


## Parte 2
### **Actualización de la Tarea: Cargar Datos desde un Bucket S3 a PySpark**

Además de trabajar con datos en HDFS, esta sección guía a los alumnos para cargar datos almacenados en un bucket S3 directamente en PySpark. Esta actividad complementa el uso de HDFS y demuestra cómo integrar S3 en los flujos de trabajo de Big Data.

---

### **Pasos para Cargar Datos desde un Bucket S3**

---

#### **Paso 1: Crear y Configurar el Bucket S3**
1. **Crear un Bucket S3:**
   - En la consola de AWS, navega a **S3** y haz clic en **Create bucket**.
   - Asigna un nombre único al bucket (por ejemplo, `airline-data-bucket`) y selecciona una región cercana.
   - Configura las opciones predeterminadas y crea el bucket.

2. **Subir el Archivo Parquet:**
   - Abre tu bucket en la consola S3.
   - Haz clic en **Upload** y selecciona el archivo `airline_passenger_satisfaction.parquet`.
   - Completa el proceso de subida.

3. **Obtener la Ruta del Archivo:**
   - Navega al archivo en el bucket, haz clic en él y copia su URL completa (por ejemplo: `s3://airline-data-bucket/airline_passenger_satisfaction.parquet`).

---

#### **Paso 2: Configurar las Credenciales de AWS**
PySpark necesita acceso a las credenciales de AWS para leer datos desde S3. Sigue estos pasos:

1. **Verifica las Credenciales IAM:**
   - Asegúrate de que el rol IAM asociado con el clúster EMR tenga permisos para acceder a S3. Este rol debe incluir al menos el permiso `AmazonS3ReadOnlyAccess`.

2. **Configura las Credenciales Manualmente (Opcional):**
   - Si es necesario, crea un archivo de credenciales AWS en el nodo maestro:
     ```bash
     nano ~/.aws/credentials
     ```
     Añade las credenciales de acceso:
     ```plaintext
     [default]
     aws_access_key_id=YOUR_ACCESS_KEY
     aws_secret_access_key=YOUR_SECRET_KEY
     ```
   - Guarda y cierra el archivo (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

#### **Paso 3: Modificar el Script PySpark para Leer desde S3**
1. Abre el archivo Python `pruebaSpar.py` que creaste anteriormente:
   ```bash
   nano pruebaSpar.py
   ```
2. Modifica el script para incluir la carga desde S3:
   ```python
   from pyspark.sql import SparkSession

   # Crear una sesión Spark
   spark = SparkSession.builder \
       .appName("LeerParquetDesdeS3") \
       .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem") \
       .config("spark.hadoop.fs.s3a.aws.credentials.provider", "com.amazonaws.auth.DefaultAWSCredentialsProviderChain") \
       .getOrCreate()

   # Leer el archivo Parquet desde S3
   s3_path = "s3a://airline-data-bucket/airline_passenger_satisfaction.parquet"
   df = spark.read.parquet(s3_path)

   # Mostrar el esquema y las primeras filas
   df.printSchema()
   df.show()
   ```
3. Guarda y cierra el archivo (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

#### **Paso 4: Ejecutar el Script**
1. Ejecuta el script con `spark-submit`:
   ```bash
   spark-submit pruebaSpar.py
   ```
2. Verifica que el archivo se haya cargado correctamente desde S3. Deberías ver el esquema del archivo y las primeras filas en la salida.

---

### **Notas Adicionales**
1. **Protocolo `s3a`:**
   - Usa el prefijo `s3a://` para indicar que estás accediendo a S3 usando el conector `S3A`, diseñado para trabajar con grandes volúmenes de datos.

2. **Errores Comunes y Soluciones:**
   - **`java.lang.NoClassDefFoundError`:** Asegúrate de que el conector `s3a` está incluido en la configuración de Spark. En EMR, esto suele estar preconfigurado.
   - **Permisos de S3:** Si recibes un error relacionado con permisos, verifica que el rol IAM tenga acceso al bucket S3 y al archivo.

3. **Limpiar los Datos en S3:**
   - Después de completar la actividad, puedes eliminar el archivo o el bucket desde la consola de S3 para evitar costos innecesarios.

---

### **Resultados Esperados**
Al completar esta actividad,  habremos aprendido a:
- Configurar y trabajar con S3 como sistema de almacenamiento en la nube.
- Cargar datos directamente desde un bucket S3 a PySpark.
- Comparar el flujo de datos entre HDFS y S3.
