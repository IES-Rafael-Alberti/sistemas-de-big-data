### **Cuestionario para el Estudio Teórico (10 preguntas)**

1. **¿Qué diferencia principal existe entre almacenamiento de objetos, bloques y archivos?**
   - a) El tipo de datos que pueden almacenar.
   - b) La manera en que los datos se organizan y acceden.**
   - c) La velocidad de acceso a los datos.
   - d) Todas las anteriores.

2. **¿Cuál es la principal ventaja de Amazon S3 frente a otros tipos de almacenamiento en AWS?**
   - a) Almacenamiento rápido y accesible desde cualquier lugar.
   - b) Altísima durabilidad y escalabilidad.
   - c) Costos bajos comparados con almacenamiento en bloque.
   - d) Todas las anteriores.**

3. **¿Qué servicio de Azure es equivalente a Amazon S3 para almacenamiento de objetos?**
   - a) Azure Disk Storage.
   - b) Azure Blob Storage.**
   - c) Azure Files.
   - d) Azure Data Lake.

4. **En Google Cloud, ¿qué servicio es ideal para almacenamiento de datos no estructurados?**
   - a) Filestore.
   - b) Persistent Disk.
   - c) Google Cloud Storage.**
   - d) BigQuery.

5. **¿Cuál de las siguientes opciones no es una ventaja del almacenamiento en la nube?**
   - a) Escalabilidad automática.
   - b) Reducción de costos iniciales.
   - c) Disponibilidad local sin conexión a internet.**
   - d) Redundancia geográfica.

6. **¿Qué tipo de almacenamiento es más adecuado para cargas de trabajo analíticas?**
   - a) Almacenamiento en bloque.
   - b) Almacenamiento de objetos.**
   - c) Almacenamiento en archivos.
   - d) Almacenamiento en cinta.

7. **¿Qué significa que un sistema de almacenamiento sea "distribuido"?**
   - a) Los datos se almacenan en múltiples ubicaciones para mejorar el rendimiento y la tolerancia a fallos. **
   - b) Los datos se distribuyen entre varios usuarios.
   - c) El almacenamiento está disponible en varios formatos.
   - d) Los datos solo se almacenan localmente.

8. **¿Cuál de las siguientes herramientas es la mejor opción para realizar estimaciones de costos en Google Cloud?**
   - a) Google Pricing Calculator.**
   - b) Google Cloud Estimator.
   - c) Cloud Storage Analyzer.
   - d) CostOptimizer.

9. **¿Qué característica hace que Azure Files sea único frente a otras opciones de almacenamiento en Azure?**
   - a) Es ideal para almacenamiento de objetos.
   - b) Ofrece almacenamiento compartido con protocolos SMB/NFS.**
   - c) Se utiliza exclusivamente para backups.
   - d) Tiene soporte exclusivo para Windows.

10. **¿Cuál es el principal desafío del almacenamiento de grandes volúmenes de datos?**
    - a) Costos asociados al almacenamiento.
    - b) Seguridad y cumplimiento normativo.
    - c) Escalabilidad y redundancia.
    - d) Todas las anteriores.**

---

### **Cuestionario para la Práctica de S3 (10 preguntas)**

1. **¿Qué necesitas hacer antes de comenzar a usar Amazon S3?**
   - a) Configurar una cuenta en AWS y acceder a la consola de Amazon S3.**
   - b) Descargar una aplicación de escritorio de S3.
   - c) Configurar una máquina virtual EC2.
   - d) Crear un bucket en EBS.

2. **¿Qué características debe tener el nombre de un bucket en Amazon S3?**
   - a) Debe incluir caracteres especiales.
   - b) Debe ser único globalmente.**
   - c) Debe ser único dentro de una región.
   - d) Puede repetirse en distintas cuentas.

3. **¿Qué significa deshabilitar el bloqueo de acceso público en un bucket de S3?**
   - a) Permitir acceso completo solo a usuarios autenticados.
   - b) Hacer que el bucket sea accesible públicamente para leer objetos.**
   - c) Evitar que los objetos sean eliminados accidentalmente.
   - d) Aumentar la seguridad del bucket.

4. **¿Cuál es el propósito de una política de bucket en Amazon S3?**
   - a) Configurar reglas para el ciclo de vida de los datos.
   - b) Gestionar permisos y control de acceso a los objetos en el bucket.**
   - c) Asignar costos a los datos almacenados.
   - d) Crear carpetas y subcarpetas dentro del bucket.

5. **¿Qué herramienta utilizarías para organizar y subir archivos masivamente a un bucket de S3?**
   - a) AWS Management Console.
   - b) AWS Command Line Interface (CLI).
   - c) Herramientas de terceros como Cyberduck.
   - d) Todas las anteriores.**

6. **¿Cómo puedes verificar que un objeto en S3 es accesible públicamente?**
   - a) Revisando la consola de AWS para confirmar los permisos.
   - b) Intentando acceder al archivo a través de su URL pública.**
   - c) Modificando la política de bucket.
   - d) Usando el AWS Cost Explorer.

7. **¿Qué formato tiene una política de bucket en Amazon S3?**
   - a) JSON.**
   - b) XML.
   - c) YAML.
   - d) CSV.

8. **¿Qué servicio de AWS permite la gestión del ciclo de vida de objetos en S3?**
   - a) Amazon S3 Lifecycle Management.**
   - b) Amazon Glacier.
   - c) Amazon EC2.
   - d) Amazon Athena.

9. **¿Qué función específica realiza la opción "Create Folder" dentro de un bucket en S3?**
   - a) Crea un directorio para almacenar carpetas.
   - b) Crea una estructura lógica para organizar objetos.**
   - c) Crea un nuevo bucket dentro del bucket existente.
   - d) No tiene una funcionalidad práctica.

10. **¿Qué componente permite acceder a los objetos de S3 mediante URL?**
    - a) La configuración de permisos del bucket.
    - b) El nombre de dominio global del bucket.
    - c) Los endpoints S3.
    - d) Todas las anteriores.**

---

### **Cuestionario para la Tarea Extra (5 preguntas)**

1. **¿Qué servicio de almacenamiento en Azure es más adecuado para datos de objetos grandes?**
   - a) Azure Blob Storage.**
   - b) Azure Disk Storage.
   - c) Azure Files.
   - d) Azure Virtual Machines.

2. **¿Cómo puedes gestionar archivos de forma eficiente en Google Cloud Storage?**
   - a) Usando la consola de Google Cloud o gsutil.**
   - b) Usando únicamente un navegador.
   - c) Mediante un sistema operativo específico.
   - d) Configurando una VM.

3. **¿Qué diferencia principal tiene Azure Blob Storage frente a Google Cloud Storage?**
   - a) Google Cloud Storage no permite archivos públicos.
   - b) Azure Blob Storage incluye herramientas exclusivas para Windows.**
   - c) Google Cloud Storage no tiene niveles de almacenamiento.
   - d) Azure Blob Storage ofrece soporte SMB/NFS.

4. **¿Qué herramienta facilita la transferencia masiva de datos a Google Cloud Storage?**
   - a) Google Transfer Appliance.**
   - b) AWS DataSync.
   - c) Azure Data Factory.
   - d) Cyberduck.

5. **¿Qué política de seguridad es fundamental al hacer objetos públicos en cualquier servicio de almacenamiento?**
   - a) Configurar permisos de lectura adecuados.
   - b) Proteger el bucket con una clave privada.
   - c) Limitar el tiempo de acceso público.
   - d) Todas las anteriores.**

---

Estos cuestionarios cubren tanto los conceptos teóricos como los aspectos prácticos y específicos de cada tarea, ayudando a evaluar el entendimiento y la habilidad técnica del alumno en sistemas de almacenamiento de Big Data.
