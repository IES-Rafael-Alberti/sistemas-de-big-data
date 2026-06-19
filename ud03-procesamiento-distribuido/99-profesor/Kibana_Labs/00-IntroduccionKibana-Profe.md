# UD3 — Introducción a Kibana y la visualización en Big Data

## Sistemas de Big Data

---

## 1. Por qué ahora hablamos de visualización

En los bloques anteriores de la UD3 hemos trabajado con:

* grandes volúmenes de datos,
* procesamiento distribuido con Spark,
* optimización del almacenamiento (Parquet, particiones),
* preparación de datos para su explotación.

Hasta este punto, el foco ha sido **cómo procesar datos**.

A partir de aquí, el foco cambia:

> **Cómo interpretar, explorar y comunicar los resultados del análisis de datos.**

En sistemas de Big Data, **procesar datos no es el objetivo final**.
El objetivo es **obtener información útil para la toma de decisiones**.

---

## 2. El papel de la visualización en Big Data

La visualización de datos permite:

* detectar patrones,
* identificar anomalías,
* comparar magnitudes,
* comunicar resultados a perfiles no técnicos.

En entornos Big Data, la visualización tiene particularidades propias:

* grandes volúmenes de datos,
* consultas complejas,
* necesidad de agregaciones,
* rendimiento como factor clave.

Por ello, **no cualquier herramienta de visualización es válida**.

---

## 3. ¿Qué es Kibana?

Kibana es una herramienta de:

* **consulta**
* **análisis**
* **visualización**
* **creación de dashboards**

Diseñada para trabajar sobre datos indexados en **Elasticsearch**.

Forma parte del conocido **Elastic Stack** (ELK):

* Elasticsearch → almacenamiento e indexación
* Logstash / Beats → ingesta
* **Kibana → visualización y análisis**

En este bloque nos centraremos en **Kibana**, no en toda la pila ELK.

---

## 4. Kibana NO es una herramienta de procesamiento

Es importante aclarar qué **no** hace Kibana:

* ❌ No limpia datos
* ❌ No sustituye a Spark
* ❌ No procesa grandes volúmenes en bruto
* ❌ No es una base de datos generalista

Kibana **consume datos ya preparados**, normalmente:

* filtrados,
* agregados,
* estructurados,
* listos para consulta.

👉 Por eso aparece **después de Spark** en el flujo.

---

## 5. Flujo completo trabajado en el módulo

Con Kibana, el flujo trabajado queda así:

1. Ingesta de datos
2. Integración de fuentes
3. Calidad y anonimización
4. Almacenamiento optimizado
5. Procesamiento distribuido (Spark)
6. **Indexación y visualización (Kibana)**

Cada herramienta cumple una función clara y distinta.

---

## 6. ¿Por qué Kibana y no otra herramienta?

Kibana se utiliza ampliamente en:

* análisis de logs,
* observabilidad,
* métricas,
* análisis de eventos,
* cuadros de mando operativos.

Ventajas clave:

* Muy eficiente para consultas agregadas
* Pensada para grandes volúmenes
* Visualizaciones rápidas
* Dashboards interactivos
* Uso habitual en entornos profesionales

Además, encaja bien con perfiles técnicos y no técnicos.

---

## 7. Qué vamos a hacer con Kibana en la UD3

En los laboratorios de Kibana vamos a:

* cargar datos ya procesados,
* definir índices,
* explorar campos y métricas,
* crear visualizaciones básicas,
* construir dashboards sencillos,
* interpretar resultados.

El objetivo **no es** hacer dashboards complejos, sino:

> **Entender cómo se explotan datos Big Data una vez procesados.**

---

## 8. Relación entre Spark y Kibana

Spark y Kibana **no compiten**, se complementan:

| Spark            | Kibana             |
| ---------------- | ------------------ |
| Procesa datos    | Explora datos      |
| Transformaciones | Consultas          |
| Batch / paralelo | Interactivo        |
| Backend          | Frontend analítico |

Spark prepara los datos.
Kibana los hace comprensibles.

---

## 9. Qué conocimientos previos se reutilizan

Al llegar a Kibana, el alumnado ya sabe:

* qué es un dataset grande,
* por qué se agregan datos,
* por qué no se trabaja siempre con datos en bruto,
* cómo influyen las decisiones técnicas en el resultado final.

Kibana permite **ver todo esto reflejado visualmente**.

---

## 10. Qué NO se evaluará en Kibana

Para evitar frustración innecesaria:

* ❌ No se evaluará el diseño gráfico
* ❌ No se evaluará la estética del dashboard
* ❌ No se evaluará creatividad visual

✔️ Se evaluará:

* comprensión de los datos,
* interpretación correcta,
* uso adecuado de visualizaciones,
* razonamiento técnico.

---
Perfecto, encaja muy bien añadirlo **antes de empezar con el Lab 1**, porque ayuda a **contextualizar Kibana sin absolutizarla** y refuerza el criterio técnico del alumnado.

Te dejo **un apartado listo para insertar** (por ejemplo como **punto 10**, desplazando el resto).

---

## 11. Otras herramientas de visualización y análisis (comparativa)

Kibana **no es la única herramienta** para la visualización y análisis de datos, pero sí una de las más utilizadas en determinados contextos profesionales. Es importante conocer **qué alternativas existen y cuándo tiene sentido usarlas**.

### 11.1 Grafana

Grafana es una herramienta muy extendida para:

* monitorización,
* métricas en tiempo real,
* observabilidad,
* dashboards operativos.

Suele utilizarse junto a fuentes como:

* Prometheus,
* Elasticsearch,
* InfluxDB,
* bases de datos SQL.

**Diferencia clave con Kibana**:

* Grafana está orientada principalmente a **series temporales y métricas**.
* Kibana está más enfocada a **exploración de datos, eventos y análisis ad-hoc**.

👉 En Big Data:

* **Grafana** es muy habitual en entornos de infraestructura y DevOps.
* **Kibana** es más común en análisis de logs, eventos y datasets indexados.

---

### 11.2 Power BI, Tableau y herramientas BI clásicas

Herramientas como **Power BI**, **Tableau** o **Looker** pertenecen a la categoría de **Business Intelligence (BI)**.

Se utilizan principalmente para:

* análisis de negocio,
* informes ejecutivos,
* cuadros de mando estratégicos,
* usuarios no técnicos.

Características habituales:

* fuerte orientación visual,
* modelos semánticos,
* integración con fuentes empresariales,
* menor foco en grandes volúmenes en bruto.

**Relación con Big Data**:

* Estas herramientas **no sustituyen** a Spark ni a Kibana.
* Normalmente trabajan sobre:

  * datos ya agregados,
  * datamarts,
  * vistas preparadas,
  * lagos de datos curados.

👉 En muchos entornos reales:

* Spark prepara los datos,
* Elasticsearch / bases analíticas los almacenan,
* Power BI o Tableau los consumen.

---

### 11.3 ¿Por qué usamos Kibana en este módulo?

En el contexto del módulo de **Sistemas de Big Data**, Kibana se utiliza porque:

* trabaja bien con grandes volúmenes,
* permite consultas rápidas y exploratorias,
* encaja con flujos técnicos,
* es habitual en entornos profesionales,
* no requiere modelado BI previo complejo.

Además, permite entender mejor la relación entre:

* datos,
* índices,
* consultas,
* visualizaciones.

---

### 11.4 Idea clave para el alumnado

> No existe una “mejor herramienta” universal.
> La herramienta adecuada depende del **tipo de datos**, el **objetivo del análisis** y el **perfil del usuario**.

Aprender Kibana en este módulo no significa que sea la única opción, sino que **es una pieza habitual dentro de un ecosistema Big Data real**.


---
## 12. Mensaje clave antes de empezar

> Kibana no sirve para “hacer gráficos bonitos”,
> sino para **entender grandes volúmenes de datos de forma eficiente**.

---

## 13. Próximo paso

Con este contexto claro, el siguiente paso será:

👉 **Laboratorio 1 de Kibana**

* Primer contacto
* Exploración de datos
* Visualizaciones básicas
* Sin dashboards complejos
