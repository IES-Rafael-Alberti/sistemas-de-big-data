### **Tarea: Gestión de Grandes Volúmenes de Datos con Hadoop y Spark**

#### **📌 Objetivo**
En esta tarea, los alumnos trabajarán con **Hadoop y Spark** para gestionar grandes volúmenes de datos en un entorno distribuido. La actividad se centrará en la **implementación, almacenamiento, procesamiento y análisis** de datos utilizando ambas tecnologías.

#### **📂 Contenidos de la Tarea**
1. **Instalación y Configuración** de Hadoop y Spark.
2. **Carga de Datos Masivos** en HDFS y procesamiento con Spark.
3. **Ejercicio Práctico** con un dataset real en Hadoop y Spark.
4. **Comparación de Rendimiento** entre ambas tecnologías.
5. **Generación de Informes y Conclusiones**.

📌 **Como apéndices**, se incluirán **una guía de instalación y uso de Hadoop y otra de Spark**.

---

## **1️⃣ Instalación y Configuración de Hadoop y Spark**
### **A. Configuración de un Entorno Hadoop**
1. **Descargar e instalar Hadoop** en un clúster o en una máquina virtual.
2. Configurar **HDFS** y probar su funcionamiento con `hdfs dfs -ls /`.
3. Ejecutar un proceso **MapReduce de prueba** para verificar la instalación.

📌 **Apéndice 1: Guía de Hadoop** 📘
(Explicación detallada sobre cómo instalar y configurar Hadoop en entornos locales o en la nube).

---

### **B. Configuración de un Entorno Spark**
1. **Descargar e instalar Apache Spark**.
2. Configurar el entorno para ejecutar Spark en modo local o en clúster.
3. Ejecutar un script de prueba para procesar datos con Spark.

📌 **Apéndice 2: Guía de Spark** 📘
(Explicación detallada sobre cómo instalar y configurar Spark en modo standalone o sobre Hadoop).

---

## **2️⃣ Carga de Datos en HDFS y Procesamiento con Spark**
### **A. Carga de Datos en Hadoop (HDFS)**
1. Descargar un **dataset de gran tamaño** (ejemplo: datos meteorológicos, logs de servidores, o transacciones bancarias).
2. Subir el dataset a HDFS usando:
   ```bash
   hdfs dfs -put dataset.csv /user/hadoop/dataset/
   ```
3. Verificar que los datos están almacenados correctamente:
   ```bash
   hdfs dfs -ls /user/hadoop/dataset/
   ```

### **B. Procesamiento de Datos con Spark**
1. Leer los datos desde HDFS en Spark:
   ```python
   from pyspark.sql import SparkSession

   spark = SparkSession.builder.appName("BigDataProcessing").getOrCreate()
   df = spark.read.csv("hdfs:///user/hadoop/dataset/", header=True, inferSchema=True)
   df.show()
   ```
2. Aplicar transformaciones:
   ```python
   df_filtered = df.filter(df["column_name"] > 1000)
   df_filtered.show()
   ```
3. Guardar los resultados en HDFS:
   ```python
   df_filtered.write.csv("hdfs:///user/hadoop/output/")
   ```

---

## **3️⃣ Ejercicio Práctico con Dataset Real**
📌 **Objetivo**: Procesar un gran volumen de datos y comparar el rendimiento de Hadoop y Spark.

1. **Seleccionar un dataset** (Ejemplo: datos de transacciones, logs de servidores, registros meteorológicos).
2. **Procesamiento con Hadoop (MapReduce)**:
   - Escribir un script MapReduce para analizar los datos.
   - Comparar el tiempo de ejecución en distintos tamaños de dataset.
3. **Procesamiento con Spark**:
   - Procesar los mismos datos usando Spark y medir el tiempo de ejecución.

✅ **Comparar resultados** y documentar la diferencia de rendimiento.

---

## **4️⃣ Comparación de Rendimiento**
1. **Ejecutar el mismo análisis con Hadoop y Spark**.
2. Medir los tiempos de procesamiento y consumo de recursos.
3. Completar la siguiente tabla:

| **Tarea**        | **Hadoop (MapReduce)** | **Spark** |
|-----------------|----------------------|----------|
| Carga de datos  | X segundos           | X segundos |
| Procesamiento   | X segundos           | X segundos |
| Guardado       | X segundos           | X segundos |

🔹 **Conclusión:** ¿Cuál tecnología es más rápida? ¿En qué situaciones es mejor usar Hadoop o Spark?

---

## **5️⃣ Generación de Informes y Conclusiones**
📌 **Entrega Final**:
1. **Capturas de pantalla** de la instalación y ejecución de los procesos.
2. **Códigos fuente** de los scripts MapReduce y Spark utilizados.
3. **Tabla comparativa de rendimiento**.
4. **Reflexión**: ¿Cuándo usarías Hadoop y cuándo Spark en proyectos reales?

---

# **📘 Apéndices**
## **📌 Apéndice 1: Guía de Instalación y Uso de Hadoop**
💡 **Contenido:**
1. Instalación de Hadoop en local o en la nube.
2. Configuración de HDFS y YARN.
3. Comandos básicos (`hdfs dfs -ls`, `hdfs dfs -put`, etc.).
4. Ejemplo de procesamiento con MapReduce.

---

## **📌 Apéndice 2: Guía de Instalación y Uso de Spark**
💡 **Contenido:**
1. Instalación de Apache Spark.
2. Configuración para ejecución en modo local y clúster.
3. Uso de `spark-submit` y lectura de datos desde HDFS.
4. Ejemplo de procesamiento con Spark DataFrame API.

---

## **✅ Resumen de la Tarea**
| **Paso** | **Actividad** |
|----------|-------------|
| **1️⃣ Instalación** | Configurar entornos de Hadoop y Spark. |
| **2️⃣ Carga de Datos** | Subir un dataset real a HDFS. |
| **3️⃣ Procesamiento** | Analizar los datos con Hadoop (MapReduce) y Spark. |
| **4️⃣ Comparación** | Medir y comparar tiempos de ejecución. |
| **5️⃣ Informe Final** | Presentar conclusiones y evidencias. |

---

# **🎯 Beneficios de Esta Tarea**
✅ **Aprender sobre Big Data en la práctica** con tecnologías líderes.
✅ **Comparar rendimiento** entre Hadoop y Spark.
✅ **Trabajar con datasets reales y herramientas de clústeres**.
✅ **Aplicable a proyectos reales** en empresas que manejan datos masivos.

---

🚀 **¡Con esta tarea, los alumnos comprenderán cómo gestionar grandes volúmenes de datos de manera efectiva!** 🚀
Si necesitas ajustes o más detalles en algún paso, dime y lo resolvemos. 🔥
