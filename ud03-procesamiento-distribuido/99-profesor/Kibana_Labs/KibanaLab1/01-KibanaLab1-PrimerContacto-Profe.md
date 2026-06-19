Perfecto. A continuación te dejo **el Laboratorio 1 de Kibana actualizado**, ya **alineado con Elastic Stack 9.2.4**, coherente con todo lo que habéis trabajado en la **UD3** y con el enfoque FP (sin seguridad, sin fricción, centrado en conceptos).

El documento está pensado para **copiar/pegar tal cual** como `LAB1_Kibana_Exploracion.md`.

---

````markdown
# UD3 — Laboratorio 1  
## Exploración de datos con Kibana (Discover)

---

### Módulo
Sistemas de Big Data

### Unidad Didáctica
UD3 — Procesamiento y visualización de datos en sistemas Big Data

### Laboratorio
Laboratorio 1 — Exploración inicial de datos con Kibana

---

## 1. Objetivo del laboratorio

El objetivo de este laboratorio es **familiarizarse con Kibana** como herramienta de **exploración y análisis inicial de datos**, utilizando la funcionalidad **Discover**.

Este tipo de análisis corresponde a la fase de *data understanding* y *data exploration* dentro de un pipeline Big Data, y es clave antes de construir visualizaciones o dashboards.

---

## 2. Contexto dentro de la UD3

Hasta este momento, en la unidad didáctica:

- Los datos ya han sido **ingestados, integrados y depurados** (UD2).
- Se asume que los datos están disponibles en un sistema de almacenamiento accesible por Elasticsearch.
- En esta UD se empieza a trabajar el **consumo y análisis de datos a escala**, tanto desde el punto de vista del procesamiento (Spark) como de la visualización (Kibana).

Este laboratorio es el **primer contacto con Kibana** y servirá de base para los laboratorios posteriores.

---

## 3. Entorno de trabajo

Para este laboratorio se utiliza un entorno local basado en Docker, compuesto por:

- **Elasticsearch 9.2.4** (single-node)
- **Kibana 9.2.4**

La seguridad avanzada (usuarios, roles, TLS) está **desactivada** para centrarse en el análisis de datos.

---

## 4. Puesta en marcha del entorno

Desde el directorio que contiene el `docker-compose.yml`:

```bash
docker compose up -d
````

Comprobar que los servicios están accesibles:

* Elasticsearch: [http://localhost:9200](http://localhost:9200)
* Kibana: [http://localhost:5601](http://localhost:5601)

---

## 5. Acceso a Kibana

1. Accede a Kibana desde el navegador:
   `http://localhost:5601`

2. Espera a que Kibana termine de inicializarse.

3. Accede al menú lateral izquierdo.

---

## 6. Creación del Data View (Index Pattern)

Antes de explorar los datos, es necesario crear un **Data View**.

1. Ve a **Stack Management → Data Views**.
2. Pulsa **Create data view**.
3. Introduce:

   * **Name:** el nombre que prefieras.
   * **Index pattern:** el patrón correspondiente a los índices cargados (por ejemplo: `logs-*`, `events-*`, etc.).
4. Selecciona el campo temporal si existe (por ejemplo `@timestamp`).
5. Finaliza la creación.

---

## 7. Exploración de datos con Discover

1. Accede a **Discover** desde el menú lateral.
2. Selecciona el Data View creado.
3. Observa:

   * Número de documentos.
   * Rango temporal disponible.
   * Campos detectados automáticamente.

---

## 8. Trabajo con filtros y consultas

Realiza las siguientes acciones:

* Cambia el rango temporal (últimos 15 min, última hora, último día).
* Aplica filtros sobre distintos campos.
* Observa cómo cambia el número de documentos.
* Identifica campos clave del dataset.

Si el dataset contiene niveles de evento (INFO, WARN, ERROR), prueba a filtrar por ellos.

---

## 9. Análisis inicial de los datos

Reflexiona mientras exploras:

* ¿Qué tipo de datos se están almacenando?
* ¿Son datos técnicos, de negocio o mixtos?
* ¿Qué campos parecen más relevantes?
* ¿Existen valores anómalos o inesperados?

Este análisis es equivalente al **EDA (Exploratory Data Analysis)** que se haría en Pandas, pero aplicado a datos indexados.

---

## 10. Guardado de búsquedas

1. Guarda al menos **una búsqueda** desde Discover.
2. Asigna un nombre descriptivo.
3. Esta búsqueda se reutilizará en los siguientes laboratorios.

---

## 11. Relación con otros laboratorios

Este laboratorio sirve como base para:

* **Lab 2:** creación de visualizaciones.
* **Lab 3:** construcción de dashboards.
* **Laboratorio de observabilidad:** análisis técnico de logs y métricas.

Sin una correcta exploración inicial, las visualizaciones posteriores pierden sentido.

---

## 12. Preguntas de reflexión

Responde brevemente:

1. ¿Qué ventajas aporta Discover frente a consultar directamente Elasticsearch?
2. ¿En qué casos sería suficiente Discover sin crear dashboards?
3. ¿Qué similitudes encuentras entre Discover y un EDA en Pandas?

---

## 13. Cierre del laboratorio

Este laboratorio no busca obtener conclusiones finales, sino **comprender la estructura y naturaleza de los datos**.

El siguiente paso será **representar visualmente esta información** mediante gráficos y dashboards.

---

## Fin del Laboratorio 1

```

---

### Qué hemos hecho exactamente
- ✔ Actualizado explícitamente a **Kibana 9.2.4**
- ✔ Eliminado referencias antiguas (index patterns → data views)
- ✔ Alineado con UD2 y Spark
- ✔ Nivel adecuado para FP (ni trivial ni enterprise)

Cuando quieras, el orden lógico es:
1. **Documento de entrega del Lab 1 (Kibana)**  
2. **Lab 2 — Visualizaciones**  
3. **Lab 3 — Dashboards**

Dime el siguiente paso y seguimos.
```