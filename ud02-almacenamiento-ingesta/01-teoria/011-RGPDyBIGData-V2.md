---
title: "RGPD y Big Data: Guía esencial para estudiantes"
subtitle: "Módulo: Sistemas de Big Data (SBD)"
author: "José Manuel Sánchez Álvarez"
lang: "es"
toc: true
numbersections: true
fontsize: 11pt
geometry: margin=2.5cm
---

# 1. Introducción

El Reglamento General de Protección de Datos (RGPD) no debe ser visto como un obstáculo insuperable para la analítica de datos masivos. Por el contrario, es un **marco legal que permite tratar grandes volúmenes de datos (Big Data) garantizando la protección de los derechos fundamentales de las personas**. 

En esta unidad, profundizaremos en cómo los siete principios fundamentales del RGPD se traducen en requisitos técnicos y de gobernanza para arquitecturas de Big Data, y qué medidas proactivas (*Privacy by Design* y *Default*) deben implementar los futuros profesionales.

---

# 2. Qué son datos personales

Se considera dato personal *cualquier información que identifique o pueda hacer identificable a una persona física*. Es fundamental para un arquitecto de datos entender la diferencia entre datos **directamente identificables** y los **pseudónimos/indirectamente identificables** en entornos de Big Data.

| Tipo de Dato | Ejemplos en Big Data | Requisito de Protección |
| :--- | :--- | :--- |
| **Identificación Directa** | Nombre, DNI, Correo electrónico corporativo | Máxima; requiere Anonimización o Cifrado. |
| **Identificación Indirecta** | Dirección IP persistente, Identificador de dispositivo (IDFA/GAID), Cookie única, Hash de email | Media-Alta; la combinación de varios puede re-identificar. |
| **Datos Sensibles** (*Categorías especiales*) | Datos de salud, Biométricos, Origen étnico, Ideología política | Protección **reforzada**; uso justificado y explícito. |

**Importante:** En Big Data, un conjunto de datos aparentemente *anonimizado* (ej. solo edad y código postal) puede ser re-identificado al cruzarlo con otras fuentes públicas.

---

# 3. Principios del RGPD aplicados al Big Data

## 3.1 Licitud, lealtad y transparencia

Debe existir una **base legal clara** para cada tratamiento (ej. consentimiento explícito, interés legítimo o cumplimiento de un contrato). La **transparencia** exige que el interesado sea informado de forma concisa y accesible.

* **Aplicación SBD:** El usuario debe saber en el momento de la recogida (ej. vía *web log* o *app*) que sus datos serán volcados en un *Data Lake* o *Warehouse*, qué tipo de análisis se hará con ellos y quién es el responsable. Las políticas de privacidad deben ser **multicapa** y fáciles de entender.

## 3.2 Limitación de la finalidad

Los datos recogidos para un propósito específico **no pueden ser reutilizados para un fin diferente** que sea incompatible con el original, salvo que se obtenga un nuevo consentimiento o exista una base legal sólida (ej. investigación científica).

* **Aplicación SBD:** Si se recogen datos de ubicación para optimizar la logística de un almacén, no se deben usar posteriormente para campañas de marketing de fidelización sin informarlo y justificarlo. El *pipeline* de datos debe incluir **controles de propósito** desde la ingesta.

## 3.3 Minimización

Este es un principio crucial en Big Data, donde la tendencia es almacenar *todo* ("guardo todo por si acaso"). Se debe recolectar, almacenar y procesar **únicamente la cantidad de datos personales estrictamente necesaria** para el fin perseguido.

* **Aplicación SBD:** Antes de volcar un *log* completo en Kafka o HDFS, el ingeniero de datos debe implementar una fase de **filtrado o enmascaramiento** para eliminar columnas con identificadores directos (ej. nombre completo, DNI) si estos no son requeridos por el análisis. Se prioriza la **seudonimización** en la fase más temprana del *pipeline*.

## 3.4 Exactitud

Los datos deben ser exactos y, si es necesario, mantenerse actualizados. Esto es vital para evitar decisiones automatizadas (ej. *credit scoring*) basadas en información obsoleta o errónea.

* **Aplicación SBD:** Implementar procesos automatizados de **calidad de datos** (*Data Quality*) que detecten y corrijan registros inválidos o incoherentes, o que marquen los datos que no han sido validados por el interesado recientemente.

## 3.5 Limitación del plazo de conservación

Los datos personales **no deben almacenarse indefinidamente**. El responsable debe definir un plazo de conservación basado en la finalidad del tratamiento y, una vez cumplido, los datos deben ser **borrados o anonimizados de forma irreversible**.

* **Aplicación SBD:** Es obligatorio establecer políticas de **retención y purgado** en los *Data Lakes*. Esto incluye la configuración de *Time-To-Live (TTL)* en bases de datos NoSQL y la ejecución periódica de trabajos (*jobs*) de borrado en *clusters* distribuidos (ej. en Spark).

## 3.6 Integridad y confidencialidad

Requiere la implementación de **medidas de seguridad técnicas y organizativas adecuadas** para proteger los datos contra el tratamiento no autorizado o ilícito, la pérdida, la destrucción o el daño accidental. Este es el pilar de la ciberseguridad.

* **Aplicación SBD:**
    * **Cifrado** en tránsito (TLS/SSL) y en reposo (AES-256 en HDFS, S3).
    * **Control de Accesos** basado en roles (*Role-Based Access Control - RBAC*) para limitar quién puede ejecutar consultas o acceder a *buckets* específicos.
    * **Auditoría** (registro de quién y cuándo accedió) de los *clusters* y *Data Warehouses*.

## 3.7 Responsabilidad proactiva (*accountability*)

El responsable del tratamiento no solo debe cumplir el RGPD, sino que debe **ser capaz de demostrar ese cumplimiento** ante las autoridades. Este es el principio rector de toda la gobernanza de datos.

* **Aplicación SBD:** Se requiere mantener un **Registro de Actividades de Tratamiento (RAT)** detallado y realizar **Evaluaciones de Impacto (DPIA)** en tratamientos de alto riesgo. La documentación de la arquitectura de datos debe incluir las medidas técnicas de protección implementadas.

---

# 4. Derechos de las personas en Big Data

La naturaleza distribuida y replicada del Big Data presenta un desafío especial para garantizar los derechos del interesado.

| Derecho | Reto en Arquitecturas Distribuidas |
| :--- | :--- |
| **Acceso y Rectificación** | Localizar todas las copias de los datos de un individuo en múltiples *tiers* (raw, staging, mart) y sistemas (HDFS, Kafka, Data Warehouse). |
| **Supresión** (*Derecho al olvido*) | Garantizar el borrado total e irreversible en todas las réplicas y *backups*. Esto requiere procesos de **propagación de borrado** que pueden ser complejos y costosos en *clusters* masivos. |
| **Portabilidad** | Extraer los datos personales en un formato estructurado, de uso común y legible por máquina (ej. JSON o CSV) a partir de conjuntos de datos *semi-estructurados* o *no estructurados*. |
| **Oposición** | Implementar *flags* o *tags* a nivel de registro que impidan que los datos de un individuo sean usados en procesos analíticos o modelos futuros. |
| **No ser objeto de decisiones automatizadas** | Exigir la intervención humana para validar ciertas decisiones de alto impacto (ej. denegación de un préstamo) tomadas por algoritmos de Machine Learning. |

---

# 5. Evaluación de Impacto (DPIA)

La **Evaluación de Impacto en la Protección de Datos (DPIA)** es un análisis de riesgos formal y obligatorio.

Es crítica y obligatoria para tratamientos que utilizan **nuevas tecnologías** y que implican un **alto riesgo** para los derechos y libertades de las personas.

* **Casos Típicos en SBD:**
    * **Tratamientos a gran escala** de datos (millones de registros).
    * **Creación de perfiles masivos** con fines predictivos (ej. riesgo crediticio, fraude).
    * **Uso de IA y *Machine Learning* predictivo** que pueda llevar a decisiones vinculantes sin supervisión.
    * **Observación sistemática o monitorización** de espacios públicos (CCTV, sensores IoT).
    * Tratamiento de **datos sensibles** (salud, biometría) a gran escala.

La DPIA debe incluir la descripción del tratamiento, la evaluación de su necesidad/proporcionalidad, la gestión de riesgos y la aplicación de las salvaguardias necesarias.

---

# 6. Brechas de seguridad en Big Data

Una **brecha de seguridad** es cualquier violación que ocasione la destrucción, pérdida o alteración accidental o ilícita de datos personales, o su comunicación o acceso no autorizado. 

En Big Data, las brechas a menudo se deben a fallos de configuración, no a ataques directos.

* **Ejemplos de Brechas por Configuración:**
    * **Buckets abiertos:** Un *bucket* de almacenamiento en la nube (ej. S3, Azure Blob) configurado accidentalmente como público, exponiendo *datasets* completos.
    * **Logs con datos personales:** Archivos de *logs* (ej. errores de aplicación) que registran variables de sesión o parámetros URL que contienen identificadores personales sin haber sido enmascarados previamente.
    * **Permisos incorrectos en clusters:** Un usuario o servicio con privilegios de administrador en Apache Hadoop o Spark que accede a datos de producción sensibles sin necesidad.
    * **Publicación accidental en repositorios:** Subir código o *notebooks* (ej. en GitHub) que contienen claves de acceso (API keys) o *samples* de datos reales con información personal.

Las brechas deben ser notificadas a la autoridad de control (AEPD en España) en un plazo no superior a **72 horas** desde que se tuvo conocimiento de ella, si existe un riesgo para los derechos y libertades.

---

# 7. Principios RGPD vs. retos del Big Data

Esta tabla resume los puntos de fricción y cómo la tecnología debe actuar como garante del cumplimiento:

| Principio RGPD | Reto Big Data | Solución Tecnológica/Ejemplo |
| :--- | :--- | :--- |
| **Minimización** | Captura masiva de datos (*Data hoarding*). | Implementar procesos de **mascaramiento y filtrado** en la ingesta (*streaming* o *batch*) para **retirar columnas innecesarias** o reemplazarlas por *tokens* (seudonimización). |
| **Transparencia** | Modelos complejos (*Black Box*) de IA. | Uso de herramientas de **IA Explicable (XAI)** para justificar predicciones (ej. explicar las *features* clave de una recomendación). |
| **Limitación de la finalidad** | Reutilización de datos entre departamentos. | Uso de **etiquetado de datos** (*Data Tagging*) y **políticas de uso** aplicadas automáticamente a nivel de *metadata* que impidan a un usuario acceder a un *dataset* con un fin no autorizado. |
| **Seguridad** | Infraestructuras distribuidas y multicloud. | Uso de **mecanismos de cifrado de extremo a extremo** (de cliente a servidor y en reposo) y **gestores centralizados de secretos/credenciales**. |
| **Derecho al olvido** | Sistemas altamente replicados y *backups* inmutables. | Desarrollo de **servicios de borrado centralizados** que propaguen la solicitud a todas las capas (DB, *Data Lake*, *Cache*) y la auditen para demostrar el cumplimiento. |

---

# 8. Actividades en clase

* **Análisis de casos reales:** Estudio de sanciones impuestas por la AEPD o el CNIL (Francia) a empresas de Big Data, identificando qué principio del RGPD se vulneró.
* **Simulaciones (empresa vs. autoridad de protección):** Ejercicio de respuesta a una solicitud de "Derecho de Acceso" o "Derecho al Olvido" por parte del equipo de ingeniería de datos.
* **Diseño de un *pipeline* con minimización y anonimización:** Modelar un flujo de ingesta (ej. Kafka -> Spark -> HDFS) indicando los puntos exactos donde se aplica la seudonimización y el filtrado de datos sensibles (*Privacy by Design*). 
* **Debates éticos sobre IA y privacidad:** Discusión sobre el riesgo de sesgo en los algoritmos (*Bias*) y cómo los datos de entrenamiento pueden vulnerar la **No discriminación** (Principio 4).

---

# 9. Conclusión

El RGPD es un facilitador de la confianza en la era del dato. El futuro profesional de SBD debe integrar los principios de **Privacidad desde el Diseño** (*Privacy by Design*) y **Por Defecto** (*Privacy by Default*) en cada etapa del desarrollo.

Un profesional debe saber:

* cómo **minimizar** y **seudonimizar** datos en la ingesta,
* cómo **documentar** tratamientos y riesgos (*DPIA*),
* cómo garantizar la **seguridad** (cifrado, accesos) en entornos distribuidos, y
* cómo implementar la **transparencia** y los **derechos** de las personas en sistemas masivos.

---

