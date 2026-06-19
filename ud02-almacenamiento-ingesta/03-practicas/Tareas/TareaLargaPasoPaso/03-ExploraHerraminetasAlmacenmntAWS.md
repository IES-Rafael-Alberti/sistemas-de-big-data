### **Tarea 3: Exploración de Herramientas de Almacenamiento en AWS**

**Objetivo:** Familiarizar a los alumnos con diferentes herramientas de almacenamiento en la nube disponibles en AWS, como **Amazon S3**, **Amazon EBS**, **Amazon EFS**, y **Amazon DynamoDB**, y guiarlos para que comparen características, casos de uso y costos.

**Nivel:** Introducción, ideal para alumnos que no tienen experiencia previa con AWS.

---

### **Paso a Paso**

#### **Paso 1: Configuración Inicial**
1. **Acceso al Lab de AWS Academy:**
   - Inicia sesión en **AWS Academy** con tus credenciales.
   - Abre el laboratorio asignado y accede a la consola de **AWS**.

2. **Familiarización con la Consola AWS:**
   - Explora brevemente los servicios de almacenamiento: busca **S3**, **EBS**, **EFS**, y **DynamoDB** desde la barra de búsqueda de servicios.

---

#### **Paso 2: Introducción a Amazon S3**
1. **Accede a Amazon S3:**
   - Selecciona **Amazon S3** desde la consola.
   - Crea un bucket llamado `herramientas-almacenamiento-grupo1` siguiendo los pasos de la tarea 2.

2. **Características Clave de S3:**
   - **Escalabilidad automática**: Capaz de manejar grandes volúmenes de datos.
   - **Casos de uso comunes**: Almacenamiento de objetos, respaldo, y almacenamiento de datos para análisis.

3. **Ejercicio Práctico:**
   - Sube un archivo de prueba (como una imagen o un documento).
   - Intenta configurarlo como público desde la pestaña de permisos (recuerda habilitar acceso público en la configuración del bucket).

---

#### **Paso 3: Exploración de Amazon EBS**
1. **Accede a Amazon EC2:**
   - Desde la consola de AWS, busca y selecciona **EC2**.
   - Explora la sección de volúmenes EBS en el menú lateral.

2. **Crear un Volumen EBS:**
   - Haz clic en **Create Volume**.
   - Configura los siguientes valores:
     - **Size**: 10 GiB.
     - **Availability Zone**: Selecciona la misma que el laboratorio.
     - **Volume Type**: Selecciona **General Purpose (gp2)**.
   - Haz clic en **Create Volume**.

3. **Asociar el Volumen a una Instancia:**
   - Desde el menú lateral, selecciona **Instances**.
   - Crea una instancia EC2 simple si no hay una disponible.
   - Vuelve a **Volumes**, selecciona tu volumen recién creado y haz clic en **Attach Volume**.
   - Asócialo a la instancia EC2.

4. **Características Clave de EBS:**
   - **Almacenamiento por bloques**: Ideal para bases de datos y sistemas de archivos.
   - **Persistencia**: Los datos se conservan aunque la instancia se detenga.

---

#### **Paso 4: Exploración de Amazon EFS**
1. **Accede a Amazon EFS:**
   - Desde la consola, busca y selecciona **EFS (Elastic File System)**.

2. **Crear un Sistema de Archivos EFS:**
   - Haz clic en **Create File System**.
   - Configura un nombre como `efs-grupo1` y selecciona una **VPC** predeterminada.
   - Haz clic en **Create**.

3. **Montar EFS en una Instancia EC2:**
   - Sigue las instrucciones proporcionadas en **Attach** para montar el EFS en una instancia EC2.
   - Requiere permisos y configuración de red (VPC).

4. **Características Clave de EFS:**
   - **Almacenamiento compartido**: Ideal para aplicaciones distribuidas.
   - **Escalabilidad automática**: Expande o reduce según sea necesario.

---

#### **Paso 5: Exploración de Amazon DynamoDB**
1. **Accede a DynamoDB:**
   - Busca y selecciona **Amazon DynamoDB** en la consola.

2. **Crear una Tabla DynamoDB:**
   - Haz clic en **Create Table**.
   - Configura los siguientes valores:
     - **Table Name**: `dynamodb-grupo1`.
     - **Partition Key**: `ID` (tipo Number).
   - Deja las configuraciones predeterminadas y haz clic en **Create Table**.

3. **Insertar Datos en la Tabla:**
   - Una vez creada, selecciona la tabla y ve a **Explore Table Items**.
   - Haz clic en **Create Item** y añade datos manualmente, como:
     ```json
     {
       "ID": 1,
       "Name": "John Doe",
       "Age": 25
     }
     ```

4. **Características Clave de DynamoDB:**
   - **Base de datos NoSQL**: Optimizada para alto rendimiento en tiempo real.
   - **Casos de uso comunes**: Aplicaciones móviles, IoT, y análisis en tiempo real.

---

#### **Paso 6: Comparación de Herramientas**
1. **Aspectos a Comparar:**
   - **Tipo de Almacenamiento:**
     - S3: Almacenamiento de objetos.
     - EBS: Almacenamiento de bloques.
     - EFS: Sistema de archivos.
     - DynamoDB: Base de datos NoSQL.
   - **Casos de Uso Comunes.**
   - **Ventajas y Desventajas.**

2. **Crear una Tabla Comparativa:**
   - Los alumnos deben crear una tabla como esta para resumir:
     | **Herramienta** | **Tipo de Almacenamiento** | **Caso de Uso Común**     | **Ventajas**                 | **Desventajas**              |
     |------------------|----------------------------|----------------------------|------------------------------|------------------------------|
     | Amazon S3        | Objeto                    | Respaldo, análisis         | Escalable, económico         | Menor velocidad en consultas|
     | Amazon EBS       | Bloque                    | Bases de datos, VM         | Alta velocidad               | No es compartido            |
     | Amazon EFS       | Archivos                  | Aplicaciones distribuidas  | Compartido, escalable        | Más costoso                 |
     | DynamoDB         | Base de datos NoSQL       | Aplicaciones en tiempo real| Alto rendimiento, flexible   | Modelo de costos complejo   |

---

#### **Paso 7: Presentación de Resultados**
1. **Preparar una Presentación:**
   - Los alumnos deben resumir sus hallazgos sobre cada herramienta.
   - Incluir capturas de pantalla de la consola AWS para mostrar la configuración.

2. **Puntos a Incluir:**
   - Características principales de cada herramienta.
   - Comparación de casos de uso.
   - Ventajas y desventajas específicas.

---

### **Resultados Esperados**
1. **Práctica en AWS:**
   - Los alumnos deben haber explorado y configurado ejemplos básicos de S3, EBS, EFS, y DynamoDB.

2. **Análisis Comparativo:**
   - Tabla detallada con características, casos de uso, ventajas y desventajas de cada herramienta.

3. **Presentación de Hallazgos:**
   - Breve presentación con capturas de pantalla y conclusiones.

---

### **Criterios de Evaluación**
| **Aspecto Evaluado**                 | **Peso (%)** |
|--------------------------------------|--------------|
| Creación y configuración de S3       | 20%          |
| Exploración y configuración de EBS   | 20%          |
| Exploración y configuración de EFS   | 20%          |
| Configuración básica de DynamoDB     | 20%          |
| Comparación y presentación de hallazgos | 20%       |

Este paso a paso asegura que los alumnos aprendan los conceptos básicos de almacenamiento en AWS mientras desarrollan habilidades prácticas y comparativas.
