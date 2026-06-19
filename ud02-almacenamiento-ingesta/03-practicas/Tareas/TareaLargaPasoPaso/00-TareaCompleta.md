### **Criterios de Evaluación para Cada Tarea**

#### **Tarea 1: Simulación de un Pipeline de Datos**
**Criterios de Evaluación (20% del total):**
1. **Configuración del Entorno (5%)**:
   - Creación correcta del bucket S3 y otros recursos necesarios.
   - Organización clara de carpetas y archivos en S3.

2. **Simulación de Ingesta de Datos (5%)**:
   - Uso correcto del generador de datos y configuración de Kafka.
   - Datos en el formato esperado (JSON, Parquet).

3. **Procesamiento de Datos (5%)**:
   - Implementación adecuada de una función básica en AWS Lambda.
   - Datos procesados correctamente y almacenados en S3.

4. **Validación (5%)**:
   - Verificación del flujo completo de datos desde la ingesta hasta el almacenamiento.
   - Evidencia de los resultados (capturas de pantalla o logs).

---

#### **Tarea 2: Comparación de Formatos de Datos**
**Criterios de Evaluación (20% del total):**
1. **Preparación del Entorno (5%)**:
   - Creación correcta de buckets S3 para cada formato de datos.
   - Organización y nomenclatura adecuada.

2. **Carga de Archivos (5%)**:
   - Archivos cargados en todos los formatos especificados (CSV, JSON, Parquet, ORC).
   - Tamaño y estructura de los datos consistente.

3. **Medición de Tamaño y Rendimiento (5%)**:
   - Comparación precisa de tamaños de archivos en la consola S3.
   - Medición de tiempos utilizando Athena o SageMaker.

4. **Resultados y Análisis (5%)**:
   - Tabla comparativa clara y precisa.
   - Reflexión sobre las ventajas y desventajas de cada formato.

---

#### **Tarea 3: Exploración de Herramientas de Almacenamiento**
**Criterios de Evaluación (20% del total):**
1. **Investigación del Servicio Asignado (10%)**:
   - Cobertura de características, costos, ventajas y desventajas.
   - Ejemplos claros de casos de uso.

2. **Presentación (10%)**:
   - Contenido organizado y visualmente atractivo.
   - Explicación clara, con comparaciones relevantes entre servicios.

---

#### **Tarea 4: Diseño de Soluciones de Almacenamiento**
**Criterios de Evaluación (30% del total):**
1. **Identificación de Requisitos (10%)**:
   - Cobertura completa de necesidades del caso (volumen, seguridad, accesibilidad).
   - Clasificación adecuada de los datos según su tipo y uso.

2. **Diseño de Arquitectura (10%)**:
   - Elección apropiada de servicios AWS para cada necesidad (S3, DynamoDB, Redshift).
   - Diagrama claro y detallado que refleje la solución propuesta.

3. **Presentación de la Solución (10%)**:
   - Argumentos bien fundamentados sobre las elecciones de diseño.
   - Claridad en la exposición, con soporte visual (diagrama, tablas).

---

#### **Tarea Extra: Creación de una Página HTML Pública en S3**
**Criterios de Evaluación (10% del total):**
1. **Configuración del Bucket S3 (3%)**:
   - Habilitación correcta del hosting web estático.
   - Configuración pública del bucket.

2. **Carga de Archivos HTML (3%)**:
   - Subida exitosa de los archivos y estructura organizada.
   - Recursos (imágenes, CSS) funcionales en la página.

3. **Validación (4%)**:
   - Acceso exitoso a la página web desde la URL pública.
   - Página funcional con todos los elementos cargados correctamente.

---

### **Resumen del Porcentaje por Tareas**
| **Tarea**                          | **Ponderación Total** | **Criterios Evaluados**                                             |
|------------------------------------|-----------------------|---------------------------------------------------------------------|
| Simulación de Pipeline de Datos    | 20%                   | Configuración, ingesta, procesamiento, validación.                 |
| Comparación de Formatos de Datos   | 20%                   | Preparación, carga, medición, análisis.                            |
| Exploración de Herramientas        | 20%                   | Investigación, presentación.                                       |
| Diseño de Soluciones de Almacenamiento | 30%               | Requisitos, diseño, presentación.                                 |
| Tarea Extra (Página HTML en S3)    | 10% (opcional)        | Configuración, carga, validación.                                  |

Este esquema asegura que cada etapa del proyecto sea evaluada de manera justa y fomenta el desarrollo tanto práctico como teórico.
