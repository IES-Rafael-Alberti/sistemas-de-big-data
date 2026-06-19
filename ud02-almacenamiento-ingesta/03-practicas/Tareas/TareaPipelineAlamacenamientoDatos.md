### Tarea 1: **Estudio de Sistemas de Almacenamiento de Big Data en AWS, Azure y Google Cloud**

#### **Objetivo**:
Analizar y comparar las características, costos, ventajas y desventajas de los sistemas de almacenamiento de Big Data ofrecidos por las principales plataformas en la nube: **Amazon Web Services (AWS)**, **Microsoft Azure**, y **Google Cloud Platform (GCP)**.

---

#### **Parte A: Investigación Teórica**
1. **Sistemas de Almacenamiento a Investigar**
   - **AWS**:
     - **Amazon S3 (Simple Storage Service)**: Almacenamiento escalable de objetos.
     - **Amazon EBS (Elastic Block Store)**: Almacenamiento en bloque para instancias EC2.
     - **Amazon FSx**: Soluciones para almacenamiento de archivos (Windows, Lustre).
   - **Azure**:
     - **Azure Blob Storage**: Almacenamiento de objetos para cargas masivas.
     - **Azure Disk Storage**: Almacenamiento en bloque para máquinas virtuales.
     - **Azure Files**: Soluciones para almacenamiento de archivos compartidos.
   - **Google Cloud**:
     - **Google Cloud Storage**: Almacenamiento de objetos global.
     - **Persistent Disks**: Almacenamiento en bloque para VM.
     - **Filestore**: Almacenamiento de archivos gestionado.

2. **Aspectos a Comparar**
   - **Características**:
     - Tipos de almacenamiento ofrecidos (objeto, bloque, archivo).
     - Escalabilidad y redundancia.
     - Niveles de durabilidad y disponibilidad.
   - **Costos**:
     - Costo de almacenamiento por GB.
     - Cargos adicionales (solicitudes, transferencia de datos, almacenamiento de clase fría).
   - **Ventajas**:
     - Integración con otros servicios de la plataforma.
     - Opciones de seguridad (cifrado, control de acceso).
   - **Desventajas**:
     - Complejidad de uso.
     - Limitaciones en comparación con los competidores.

3. **Ejemplo de Comparación**
   - Para cada servicio, pueden usar las calculadoras de precios de la nube para estimar costos, como almacenar 1 TB de datos durante un mes con accesos frecuentes:
     - **AWS Calculator**: [AWS Pricing Calculator](https://calculator.aws/)
     - **Azure Pricing Calculator**: [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)
     - **Google Cloud Pricing Calculator**: [Google Pricing Calculator](https://cloud.google.com/products/calculator)

4. **Entrega**:
   - Un cuadro comparativo con los hallazgos.
   - Una conclusión sobre cuál sistema se adapta mejor a distintos casos de uso (ejemplo: almacenamiento de backups, aplicaciones de IA, análisis de Big Data).

---

#### **Parte B: Tarea Práctica**

##### **Introducción a Amazon S3: Configuración Básica**
1. **Objetivo**: Crear y gestionar un bucket de S3 en AWS Academy Lab, subir archivos a carpetas y configurar acceso público.
2. **Pasos Detallados**:
   - **Abrir el Lab**:
     - Inicia sesión en **AWS Academy**.
     - Accede a un **Lab práctico** y selecciona uno que incluya el uso de **Amazon S3**.
     - Haz clic en "Start Lab" para abrir la consola de AWS.

   - **Crear un Bucket en S3**:
     1. Ve a la **Consola de AWS** > **S3**.
     2. Haz clic en **Create Bucket**.
     3. Ingresa un nombre único para el bucket (ejemplo: `bigdata-storage-lab`).
     4. Selecciona una región cercana a tu ubicación.
     5. Desactiva el **bloqueo de acceso público** (para esta tarea).
     6. Crea el bucket.

   - **Subir Archivos al Bucket**:
     1. Accede al bucket y crea carpetas (ejemplo: `images`, `documents`).
     2. Sube archivos (imágenes, documentos).
     3. Asegúrate de verificar los permisos de los archivos.

   - **Configurar Acceso Público**:
     1. Ve a las propiedades del bucket.
     2. Habilita el acceso público para los objetos subidos.
     3. Configura una política de bucket para permitir acceso público:
        ```json
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "PublicReadGetObject",
              "Effect": "Allow",
              "Principal": "*",
              "Action": "s3:GetObject",
              "Resource": "arn:aws:s3:::bigdata-storage-lab/*"
            }
          ]
        }
        ```

   - **Crear una Página HTML y Subirla**:
     1. Crea un archivo HTML sencillo (ejemplo: `index.html`) que enlace a las imágenes subidas:
        ```html
        <!DOCTYPE html>
        <html>
        <head>
          <title>Big Data Storage Lab</title>
        </head>
        <body>
          <h1>Archivos del Bucket</h1>
          <img src="https://bigdata-storage-lab.s3.amazonaws.com/images/your-image.jpg" alt="Uploaded Image">
        </body>
        </html>
        ```
     2. Sube este archivo al bucket.
     3. Comparte la URL pública del archivo HTML.

---

### **Tarea Extra (Avanzada)**: Uso de Otro Sistema de Almacenamiento en la Nube

#### **Azure Blob Storage**:
1. **Crear un Almacenamiento**:
   - Ve al **Portal de Azure**.
   - Crea una cuenta de almacenamiento y selecciona **Blob Storage**.
2. **Subir Archivos**:
   - Utiliza la herramienta **Azure Storage Explorer** para organizar y cargar los datos.
3. **Configurar Acceso Público**:
   - Modifica los permisos del contenedor para permitir acceso anónimo a los blobs.

#### **Google Cloud Storage**:
1. **Crear un Bucket**:
   - Accede a la **Consola de Google Cloud**.
   - Crea un bucket en Cloud Storage.
2. **Subir Archivos**:
   - Utiliza la consola para subir archivos o herramientas como `gsutil`.
3. **Configurar Acceso Público**:
   - Configura políticas para que los objetos sean accesibles públicamente.

---

### Entregables

1. **Tarea Teórica**:
   - Cuadro comparativo con las características, costos, ventajas y desventajas de los sistemas de almacenamiento.
   - Conclusión detallada sobre el sistema más adecuado para diferentes casos de uso.

2. **Tarea Práctica**:
   - URL pública del bucket o archivo HTML subido en Amazon S3.
   - Descripción de los pasos realizados, acompañada de capturas de pantalla.
   - Para la tarea extra, incluye los resultados obtenidos en **Azure Blob Storage** o **Google Cloud Storage**.

Esta tarea combina el aprendizaje teórico con una experiencia práctica que refuerza las capacidades técnicas en la gestión de sistemas de almacenamiento en la nube.