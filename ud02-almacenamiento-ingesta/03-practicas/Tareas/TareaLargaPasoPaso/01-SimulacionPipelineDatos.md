### **Tarea 1: Simulación de un Pipeline de Datos**

**Objetivo:** Crear un pipeline de datos básico en AWS para simular el flujo de datos desde su ingesta, pasando por el almacenamiento temporal y procesamiento, hasta el almacenamiento final en Amazon S3.

**Nivel:** Introducción, ideal para alumnos que no tienen experiencia previa con AWS.

---

### **Pasos para Implementar el Pipeline**

#### **Paso 1: Configuración del Entorno**
1. **Acceso al Lab de AWS Academy:**
   - Inicia sesión en **AWS Academy**.
   - Abre el laboratorio asignado para esta tarea y accede a la consola de AWS.

2. **Explorar la Consola de AWS:**
   - Familiarízate con la consola de AWS.
   - Busca **Amazon S3** desde la barra de búsqueda.

3. **Crear un Bucket en Amazon S3:**
   - Ve a **S3** > **Create Bucket**.
   - Introduce un nombre único para el bucket, por ejemplo: `pipeline-datos-grupo1`.
   - Selecciona la región recomendada (usualmente "US East").
   - Acepta la configuración predeterminada y haz clic en **Create Bucket**.

---

#### **Paso 2: Generación de Datos Simulados**
1. **Usar un Generador de Datos:**
   - Accede a un generador de datos online como [Mockaroo](https://mockaroo.com/).
   - Configura un esquema para generar datos ficticios. Ejemplo:
     - `timestamp` (tipo: DateTime)
     - `page` (tipo: URL)
     - `user_id` (tipo: Number)

2. **Exportar los Datos:**
   - Genera un archivo JSON con al menos 50 registros.
   - Guarda el archivo como `data.json` en tu computadora.

---

#### **Paso 3: Configuración del Almacenamiento Temporal con Kafka**
1. **Configurar Amazon MSK (Managed Streaming for Apache Kafka):**
   - Ve a la consola de **MSK** en AWS.
   - Haz clic en **Create Cluster**.
   - Selecciona **Quick Create** para facilitar la configuración.
   - Asigna un nombre al clúster, por ejemplo: `kafka-pipeline`.
   - Haz clic en **Create Cluster** y espera unos minutos hasta que el clúster esté activo.

2. **Producir Datos a Kafka:**
   - Usa un script en Python para enviar datos simulados a un tópico de Kafka:
     ```python
     from kafka import KafkaProducer
     import json

     producer = KafkaProducer(bootstrap_servers=['<bootstrap-server-url>'], value_serializer=lambda v: json.dumps(v).encode('utf-8'))
     data = [{"timestamp": "2024-01-01T12:00:00", "page": "/home", "user_id": 123}]
     for record in data:
         producer.send('topic-name', record)
     ```
   - Reemplaza `<bootstrap-server-url>` y `topic-name` con los valores correspondientes de tu clúster Kafka.

---

#### **Paso 4: Procesamiento de Datos con AWS Lambda**
1. **Crear una Función Lambda:**
   - Ve a la consola de **AWS Lambda** > **Create Function**.
   - Selecciona **Author from scratch**.
   - Introduce un nombre como `procesar-datos`.
   - Elige **Python 3.x** como runtime.
   - Crea un nuevo rol con permisos básicos de ejecución de Lambda.

2. **Escribir el Código de Procesamiento:**
   - En el editor de código, reemplaza el contenido con el siguiente ejemplo:
     ```python
     import json

     def lambda_handler(event, context):
         # Procesar datos recibidos
         for record in event['Records']:
             payload = json.loads(record['body'])
             print(f"Procesando: {payload}")
         return {
             'statusCode': 200,
             'body': json.dumps('Datos procesados correctamente')
         }
     ```

3. **Conectar Lambda a Kafka:**
   - Configura un disparador en Lambda para que consuma datos del tópico de Kafka creado previamente.

---

#### **Paso 5: Almacenamiento Final en Amazon S3**
1. **Actualizar la Función Lambda:**
   - Agrega código para guardar los datos procesados en S3:
     ```python
     import boto3

     s3 = boto3.client('s3')
     bucket_name = 'pipeline-datos-grupo1'

     def lambda_handler(event, context):
         for record in event['Records']:
             payload = json.loads(record['body'])
             file_name = f"{payload['timestamp']}_data.json"
             s3.put_object(Bucket=bucket_name, Key=file_name, Body=json.dumps(payload))
         return {
             'statusCode': 200,
             'body': json.dumps('Datos almacenados en S3')
         }
     ```

2. **Probar la Función:**
   - Envía un mensaje al tópico de Kafka y verifica que los datos procesados se guarden como objetos JSON en tu bucket de S3.

---

#### **Paso 6: Validación**
1. **Verificar los Datos en S3:**
   - Ve a la consola de S3 y abre el bucket.
   - Asegúrate de que los datos procesados se almacenan correctamente con el formato esperado.

2. **Documentar el Flujo:**
   - Crear un diagrama que muestre el flujo del pipeline (por ejemplo, usando Lucidchart o Draw.io).
   - Explicar el propósito de cada componente: Kafka, Lambda, S3.

---

### **Resultados Esperados**
1. Un pipeline funcional que:
   - Ingiera datos simulados desde un generador.
   - Los almacene temporalmente en Kafka.
   - Los procese con AWS Lambda.
   - Los guarde en Amazon S3 en formato JSON.

2. Evidencia del proyecto:
   - Capturas de pantalla del bucket S3 con los datos procesados.
   - Diagrama del flujo del pipeline.

---

### **Criterios de Evaluación**
| **Aspecto Evaluado**              | **Peso (%)** |
|-----------------------------------|--------------|
| Configuración del entorno         | 20%          |
| Simulación de ingesta de datos    | 20%          |
| Configuración de almacenamiento temporal | 20%   |
| Implementación de la función Lambda | 20%         |
| Validación y presentación         | 20%          |

Este enfoque paso a paso asegura que los alumnos se familiaricen con las herramientas básicas de AWS mientras construyen un pipeline simple pero funcional.
