# UD3 - Cierre de la unidad  
## Visualizacion, observabilidad y computacion distribuida

---

## 1. Contexto de la unidad

En la Unidad Didactica 3 se ha trabajado el ciclo completo del dato en sistemas Big Data, desde su procesamiento hasta su visualizacion y observabilidad.

Durante la unidad se han utilizado distintas herramientas, cada una con un proposito concreto:

- Spark para el procesamiento distribuido,
- Kibana para la exploracion y visualizacion de datos indexados,
- Grafana para la visualizacion de metricas y observabilidad tecnica.

El objetivo de este documento es consolidar los conceptos y entender el papel de cada herramienta.

---

## 2. Tipos de datos trabajados en la UD3

A lo largo de la unidad se han trabajado distintos tipos de datos:

- datos estructurados procesados por Spark,
- datos indexados en Elasticsearch,
- metricas temporales recogidas por Prometheus.

Cada tipo de dato requiere herramientas y enfoques distintos.

---

## 3. Kibana y Grafana: enfoque general

### Kibana

Kibana es una herramienta orientada a la exploracion, busqueda y visualizacion de datos almacenados en Elasticsearch.

Se utiliza principalmente para:

- analisis de logs,
- exploracion de eventos,
- visualizacion de datos de negocio o tecnicos indexados.

---

### Grafana

Grafana es una herramienta orientada a la visualizacion de metricas y series temporales.

No almacena datos, sino que se conecta a distintas fuentes externas.

Se utiliza principalmente para:

- monitorizacion de sistemas,
- observabilidad tecnica,
- analisis de rendimiento y estado.

---

## 4. Comparativa tecnica Kibana vs Grafana

| Aspecto | Kibana | Grafana |
|------|--------|--------|
| Tipo de datos | Logs, eventos, documentos | Metricas, series temporales |
| Almacenamiento | Elasticsearch | No almacena datos |
| Fuente de datos | Elastic Stack | Multiples fuentes |
| Uso principal | Exploracion y analisis | Monitorizacion |
| Dashboards | Analiticos | Tecnicos |
| Usuarios | Analistas, tecnicos | Tecnicos, DevOps |

---

## 5. Relacion con Spark

Spark se ha utilizado como motor de procesamiento distribuido.

- Spark procesa grandes volumenes de datos.
- Kibana y Grafana permiten analizar y observar resultados y sistemas.

En proyectos reales:

- Spark produce datos o resultados,
- Kibana puede usarse para analizar esos datos,
- Grafana puede monitorizar el propio sistema Spark.

Las herramientas trabajan juntas, no de forma aislada.

---

## 6. Observabilidad frente a analisis de negocio

Es importante distinguir:

- analisis de negocio:
  - indicadores,
  - tendencias,
  - comportamiento de usuarios.
- observabilidad tecnica:
  - errores,
  - rendimiento,
  - estado del sistema.

Kibana puede cubrir ambos ambitos en parte, mientras que Grafana se centra claramente en el segundo.

---

## 7. Eleccion de herramientas en proyectos reales

La eleccion de herramientas depende de:

- tipo de datos,
- volumen,
- frecuencia de actualizacion,
- usuarios finales,
- objetivo del analisis.

No existe una herramienta universal para todos los casos.

---

## 8. Reflexion guiada para el alumnado

Responde de forma razonada:

1. Por que no se ha utilizado una unica herramienta de visualizacion en la UD3?
2. En que casos tiene sentido usar Kibana?
3. En que casos es mas adecuado Grafana?
4. Que papel juega Spark dentro del conjunto?
5. Que herramienta te ha resultado mas clara y por que?

---

## 9. Conclusiones de la UD3

Tras completar la UD3, el alumnado ha trabajado:

- procesamiento distribuido,
- visualizacion de datos,
- dashboards,
- observabilidad tecnica.

Esto proporciona una vision realista del ecosistema Big Data y prepara para unidades posteriores orientadas a:

- inteligencia de negocio,
- analitica avanzada,
- arquitecturas de datos completas.

---

## Fin del documento
