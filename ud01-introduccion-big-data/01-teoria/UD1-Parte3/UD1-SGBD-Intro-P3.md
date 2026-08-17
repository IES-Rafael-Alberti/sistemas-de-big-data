# UD1 · Parte 3 — Arquitecturas Big Data modernas

## Resultado de esta parte

Al terminar esta parte debes poder **elegir y justificar una arquitectura Big Data** según el caso de uso: batch, streaming, Lambda, Kappa, arquitectura por capas, lakehouse/Medallion, arquitectura orientada a eventos o modelos organizativos como data products.

La idea no es memorizar diagramas. La idea es responder con criterio:

- qué datos entran,
- dónde se guardan,
- cómo se transforman,
- qué calidad tienen,
- cómo se sirven,
- cuánto cuesta,
- qué latencia necesita el problema,
- y qué tecnología tiene sentido en un aula real.

## Relación curricular

Esta parte ayuda especialmente a cubrir:

- **RA1**: aplica técnicas de análisis de datos que integran, procesan y analizan información.
- **RA1.c-d**: combina fuentes/tipos de datos y construye conjuntos de datos complejos.
- **RA1.f-g**: selecciona/integrar sistemas y determina coste/calidad.
- **RA3**: gestiona y almacena datos en grandes conjuntos.
- **RA4**: aplica herramientas de visualización y procesamiento automático.

## 1. Qué es una arquitectura Big Data

Una **arquitectura Big Data** es el diseño del sistema que permite **ingerir, almacenar, procesar, analizar y servir datos** cuando una solución tradicional se queda corta por volumen, velocidad, variedad o complejidad.

No es un dibujo bonito para una presentación. Es una cadena de decisiones técnicas:

| Decisión | Pregunta real |
| -------- | ------------- |
| Ingesta | ¿Cómo entran los datos? |
| Almacenamiento | ¿Dónde se guardan y en qué formato? |
| Procesamiento | ¿Qué transformaciones se aplican? |
| Calidad | ¿Qué reglas validan el dato? |
| Consulta | ¿Cómo se accede al dato procesado? |
| Visualización | ¿Qué información se muestra y a quién? |
| Coste | ¿Cuánto cuesta ejecutarlo y mantenerlo? |
| Latencia | ¿Hace falta respuesta inmediata o vale D+1? |

Una arquitectura mala no suele fallar el primer día. Falla cuando crece el volumen, cambian las fuentes, sube el coste o nadie puede explicar de dónde salió un dato.

## 2. Principios básicos

Toda arquitectura Big Data debería mirar estos principios:

| Principio | Significado |
| --------- | ----------- |
| Escalabilidad | Puede crecer sin rehacerlo todo. |
| Tolerancia a fallos | Un fallo parcial no destruye el sistema. |
| Distribución | Datos y cómputo pueden repartirse entre nodos. |
| Localidad del dato | Conviene procesar cerca de donde está el dato. |
| Bajo acoplamiento | Una pieza puede cambiar sin romper todo. |
| Seguridad | Acceso mínimo necesario, control y trazabilidad. |
| Observabilidad | Se puede saber qué pasa, qué falla y cuánto tarda. |
| Coste controlado | Lo técnicamente posible no siempre es viable en aula o empresa. |

La web de referencia de Aitor Medrano insiste en varias ideas útiles para clase: escalabilidad, tolerancia a fallos, datos/procesamiento distribuidos, localidad del dato, seguridad, bajo acoplamiento y evitar sobreingeniería. Encaja bien con nuestro enfoque, aunque allí los materiales se organizan por bloques de curso, no separados estrictamente entre Sistemas de Big Data y Big Data Aplicado.

## 3. Batch, streaming y arquitectura orientada a eventos

Antes de elegir arquitectura, piensa el **ritmo** del problema.

### Batch

El procesamiento **batch** trabaja por lotes.

Tiene inicio, fin y resultado estable.

Ejemplos:

- cálculo diario de ventas,
- informe nocturno de reservas,
- generación de dataset curado,
- entrenamiento periódico de un modelo,
- reconstrucción de tablas agregadas.

Ventajas:

- más simple,
- más barato,
- más fácil de depurar,
- permite usar histórico completo,
- encaja muy bien con Parquet, DuckDB y Spark.

Limitación:

- no sirve si la decisión caduca en segundos o minutos.

### Streaming

El procesamiento **streaming** trabaja con datos que llegan continuamente.

Ejemplos:

- sensores IoT,
- eventos de una app,
- clicks web,
- transacciones,
- logs,
- alertas.

Ventajas:

- baja latencia,
- actualizaciones continuas,
- permite reaccionar rápido.

Limitaciones:

- mayor complejidad,
- más coste,
- más necesidad de monitorización,
- problemas con eventos tardíos, duplicados y ventanas temporales.

### Regla práctica

> Si batch resuelve el problema, no fuerces streaming.

Streaming queda muy bien en un diagrama, pero en producción y en aula se paga con complejidad.

### Event-driven / streaming-first

Una arquitectura **orientada a eventos** no se limita a “usar streaming”. La idea es que los cambios importantes del sistema se publican como eventos y otras piezas reaccionan a ellos.

```txt
aplicación / sensor / BD
        ↓ evento
broker o log de eventos
        ↓
consumidores: Spark, alertas, dashboards, almacenamiento
```

Ejemplos de eventos:

- `venta_realizada`,
- `sensor_supera_umbral`,
- `reserva_cancelada`,
- `pedido_actualizado`,
- `log_error_servicio`.

Esta arquitectura es relevante cuando:

- hay que reaccionar rápido;
- varias aplicaciones consumen los mismos eventos;
- se quiere desacoplar productores y consumidores;
- se necesita registrar una secuencia de cambios para reprocesar o auditar.

No debe usarse por moda. Si el sistema sólo necesita informes diarios, batch + Medallion suele ser más simple y suficiente.

## 4. Arquitectura Lambda

La arquitectura **Lambda** combina dos caminos:

- una capa **batch** para precisión histórica,
- una capa **streaming** para baja latencia,
- una capa **serving** para servir resultados.

```txt
fuentes
  ├── capa batch ───────┐
  │                     ├── serving / consulta / visualización
  └── capa streaming ───┘
```

### Cuándo tiene sentido

Cuando necesitas:

- histórico completo,
- resultados precisos,
- y además información reciente.

Ejemplo:

- recomendador que entrena con todo el histórico por la noche,
- pero actualiza señales recientes durante el día.

### Problema principal

Duplica lógica.

Hay que mantener dos caminos: batch y streaming. Eso da potencia, pero también aumenta coste, complejidad y riesgo de inconsistencias.

## 5. Arquitectura Kappa

La arquitectura **Kappa** simplifica Lambda: todo pasa por un único flujo de eventos.

```txt
fuentes → log/eventos → procesamiento streaming → vistas/serving
```

La idea clave:

> El batch puede verse como reprocesar un histórico de eventos.

### Cuándo tiene sentido

Cuando:

- el dato llega como evento,
- la lógica para histórico y nuevo dato es parecida,
- interesa poder reproducir el procesamiento desde el log,
- se quiere evitar duplicar código.

### Problema principal

Si necesitas cálculos históricos muy pesados o muy diferentes del tiempo real, Kappa puede quedarse corta o volverse forzada.

## 6. Arquitectura por capas

Otra forma de pensar una arquitectura es verla como capas del ciclo de vida del dato:

```txt
fuentes
  ↓
ingesta
  ↓
transporte / colección
  ↓
procesamiento
  ↓
almacenamiento
  ↓
consulta
  ↓
visualización
```

| Capa | Responsabilidad |
| ---- | --------------- |
| Ingesta | Recibir datos desde APIs, CSV, bases de datos, eventos, logs. |
| Transporte | Mover datos entre sistemas. |
| Procesamiento | Limpiar, transformar, enriquecer, agregar. |
| Almacenamiento | Guardar datos brutos, limpios y preparados. |
| Consulta | Permitir SQL, APIs, notebooks o motores analíticos. |
| Visualización | Mostrar KPIs, gráficos, dashboards o informes. |

Esta lectura por capas es muy útil para clase porque permite ubicar tecnologías sin perderse.

Ejemplo:

| Capa | Herramienta posible |
| ---- | ------------------- |
| Ingesta | Python, Airbyte, NiFi, Kafka |
| Procesamiento | pandas, DuckDB, Spark |
| Almacenamiento | Parquet, S3/HDFS, MongoDB, Delta/Iceberg/Hudi |
| Consulta | DuckDB, Spark SQL, Trino, Athena |
| Visualización | Metabase, Superset, Power BI, notebook |

## 7. Data lake, lakehouse y por qué aparece Medallion

### Data lake

Un **data lake** guarda datos de muchas fuentes, normalmente en almacenamiento barato y flexible: ficheros, objetos, Parquet, JSON, CSV, logs, etc.

Ventaja:

- mucha flexibilidad.

Problema:

- si no hay gobierno ni calidad, se convierte en un “pantano de datos”.

### Data warehouse

Un **data warehouse** organiza datos ya modelados para consulta, informes y BI.

Ventaja:

- estructura y rendimiento para análisis.

Problema:

- menos flexible para datos brutos o semiestructurados.

### Lakehouse

Un **lakehouse** intenta combinar lo mejor de ambos:

- flexibilidad de data lake,
- estructura y calidad de warehouse,
- formatos columnares,
- transacciones o control de versiones si se usan tecnologías como Delta Lake, Iceberg o Hudi.

### Medallion

La arquitectura **Medallion** organiza un lakehouse por capas de calidad:

```txt
fuentes → bronze → silver → gold → consumo
```

Databricks describe Medallion como un patrón de diseño por capas para mejorar progresivamente estructura y calidad desde **Bronze** a **Silver** y **Gold**. Bronze conserva datos crudos, Silver valida/limpia/enriquece y Gold prepara datos para analítica, reporting, BI o ML.

## 8. Capas Medallion

| Capa | Qué contiene | Calidad | Usuarios típicos | Ejemplo en aula |
| ---- | ------------ | ------- | ---------------- | --------------- |
| Bronze | Datos crudos tal como llegan. | Baja / sin validar. | Ingeniería de datos, auditoría. | CSV/API original guardado en Parquet. |
| Silver | Datos limpios, validados, deduplicados y enriquecidos. | Media/alta. | Analistas, ciencia de datos, procesamiento posterior. | Ventas limpias con tipos correctos y joins aplicados. |
| Gold | Datos agregados y orientados a consulta/dashboard. | Alta y orientada a consumo. | BI, usuarios finales, dashboards, modelos. | KPIs por día, ciudad, producto o cliente. |

### Bronze

Bronze no intenta “arreglar” demasiado.

Su misión es preservar el dato original y permitir reprocesar.

Buenas prácticas:

- conservar fuente,
- añadir metadatos de carga,
- no perder columnas inesperadas,
- registrar fecha/hora de ingesta,
- guardar errores si aparecen.

### Silver

Silver es donde empieza la calidad.

Aquí hacemos:

- tipos correctos,
- nulos tratados,
- duplicados detectados,
- reglas de validación,
- joins,
- normalización,
- limpieza de outliers si procede,
- datos listos para análisis técnico.

### Gold

Gold es la capa de consumo.

Aquí creamos:

- KPIs,
- agregados,
- tablas para dashboard,
- vistas por negocio,
- datasets preparados para ML o BI.

En SBD, Gold no debe convertirse necesariamente en “proyecto de negocio completo”. Eso puede quedar para Big Data Aplicado. En SBD nos interesa que el alumnado entienda cómo se llega técnicamente a una capa Gold fiable.

## 9. Data products y Data Mesh

Hasta ahora hemos hablado sobre todo de arquitectura técnica. En sistemas grandes aparece otro problema: **quién es responsable de cada dato**.

Un **data product** es un dataset o servicio de datos tratado como producto: tiene responsables, documentación, contrato, calidad esperada, usuarios y ciclo de vida.

Ejemplo:

| Data product | Responsable | Consumidores | Compromiso mínimo |
| ------------ | ----------- | ------------ | ----------------- |
| `gold_ventas_diarias` | Equipo de ventas/datos | BI, dirección, modelos ML | Actualización diaria, esquema documentado, calidad ≥ umbral. |
| `silver_reservas_limpias` | Equipo de integración | Analítica, proyecto final | Sin duplicados críticos, fechas válidas, linaje disponible. |

**Data Mesh** lleva esta idea más lejos: organiza los datos por dominios de negocio o áreas responsables, en lugar de centralizar todo en un único equipo de datos.

Principios útiles para entenderlo:

- propiedad por dominio;
- datos como producto;
- plataforma común de autoservicio;
- gobierno federado.

### Encaje docente

En este módulo no vamos a implantar Data Mesh completo. Sería excesivo. Pero sí conviene mencionarlo porque ayuda a entender una idea importante:

> Gold no es “una carpeta con agregados”; puede ser un producto de datos que otros equipos consumen.

En SBD lo usaremos como criterio de documentación y calidad. En Big Data Aplicado puede servir para hablar de consumidores, usuarios, producto y toma de decisiones.

## 10. Arquitecturas que sólo conviene mencionar

Hay enfoques actuales que son relevantes profesionalmente, pero no deben ocupar el centro de esta unidad.

| Enfoque | Qué es | Tratamiento en SBD |
| ------- | ------ | ------------------ |
| Data Fabric | Capa de integración, metadatos, catálogo, gobierno y acceso unificado a datos distribuidos. | Mención breve: útil para gobierno y descubrimiento, no como práctica principal. |
| HTAP | Sistemas que combinan procesamiento transaccional y analítico con baja latencia. | Mención breve: interesante, pero especializado y menos didáctico para este módulo. |
| Microservicios | Arquitectura de aplicaciones separadas en servicios pequeños. | No es tema central; sólo usar como analogía si se habla de data products. |

La regla es simple: si una arquitectura no ayuda a tomar mejores decisiones sobre ingesta, almacenamiento, procesamiento, calidad, consulta o coste, no debe ocupar tiempo de aula.

## 11. Medallion frente a Lambda, Kappa y eventos

No son exactamente lo mismo.

| Arquitectura | Pregunta principal | Foco |
| ------------ | ------------------ | ---- |
| Batch | ¿Puedo procesar por lotes? | Tiempo de procesamiento. |
| Streaming | ¿Necesito procesar continuamente? | Latencia. |
| Lambda | ¿Necesito precisión histórica + baja latencia? | Dos caminos: batch + speed. |
| Kappa | ¿Puedo tratar todo como eventos? | Un único flujo. |
| Event-driven | ¿Necesito desacoplar productores y consumidores mediante eventos? | Log/broker de eventos y consumidores independientes. |
| Por capas | ¿Qué responsabilidad tiene cada parte? | Ciclo de vida del dato. |
| Medallion | ¿Qué calidad tiene el dato en cada etapa? | Progresión bronze/silver/gold. |
| Data products / Mesh | ¿Quién es responsable de cada dato y quién lo consume? | Organización, ownership, contratos y calidad. |

Medallion puede convivir con batch o streaming.

Ejemplo:

- Batch diario que carga Bronze, transforma Silver y genera Gold.
- Streaming que actualiza Bronze/Silver con eventos y refresca Gold cada cierto tiempo.

La pregunta ya no es sólo “batch o streaming”. También es:

> ¿En qué capa está este dato y qué calidad puedo prometer?

## 12. Ejemplo didáctico: turismo + ventas

Supongamos que tenemos datos de turismo y ventas:

- ventas en CSV,
- reservas de API,
- eventos web en JSON,
- datos meteorológicos,
- catálogo de productos.

### Bronze

Guardamos el dato casi tal cual llega:

```txt
bronze/ventas_raw/
bronze/reservas_raw/
bronze/eventos_web_raw/
bronze/meteo_raw/
```

Formato recomendado en aula:

- CSV/JSON de entrada,
- conversión a Parquet cuando proceda,
- metadatos: fecha de carga, fuente, fichero original.

### Silver

Limpiamos y unificamos:

```txt
silver/ventas_limpias/
silver/reservas_limpias/
silver/eventos_web_limpios/
silver/dataset_integrado_turismo_ventas/
```

Reglas posibles:

- fechas válidas,
- unidades > 0,
- precio_total = unidades * precio_unitario,
- ciudad normalizada,
- duplicados eliminados,
- nulos documentados,
- joins controlados.

### Gold

Preparamos consumo:

```txt
gold/kpis_diarios/
gold/ventas_por_ciudad/
gold/ocupacion_vs_meteo/
gold/dashboard_resumen/
```

Ejemplos de KPIs:

- ventas por día,
- ticket medio,
- reservas por ciudad,
- ocupación por mes,
- relación entre meteorología y demanda,
- productos más vendidos.

## 13. Calidad y trazabilidad por capa

Una arquitectura moderna no sólo mueve datos: **explica qué les ha pasado**.

| Capa | Pregunta de calidad |
| ---- | ------------------- |
| Bronze | ¿Puedo reconstruir el dato original? |
| Silver | ¿El dato está limpio, validado y unido correctamente? |
| Gold | ¿El dato responde a una pregunta concreta con rendimiento aceptable? |

Trazabilidad mínima:

- fuente original,
- fecha de carga,
- versión del proceso,
- reglas aplicadas,
- registros rechazados,
- cambios de esquema,
- responsable o notebook/script.

Si no puedes explicar de dónde ha salido un KPI, el dashboard no es fiable.

## 14. Parquet, Spark y DuckDB en esta arquitectura

### Parquet

Parquet es un formato columnar muy útil para analítica.

Ventajas:

- compresión,
- lectura eficiente por columnas,
- buen encaje con Spark, DuckDB y motores SQL,
- adecuado para capas Bronze/Silver/Gold en aula.

### Spark

Spark tiene sentido cuando:

- hay volumen,
- hay transformaciones costosas,
- hay que procesar datos distribuidos,
- hay que trabajar con Parquet particionado,
- se quiere conectar batch y streaming.

### DuckDB

DuckDB tiene sentido cuando:

- trabajamos localmente,
- queremos SQL rápido,
- no necesitamos clúster,
- queremos bajo coste y poca instalación,
- queremos enseñar conceptos sin morir con infraestructura.

Una arquitectura docente razonable puede usar:

```txt
CSV/JSON → Bronze Parquet → Silver con DuckDB/Python → Gold con DuckDB/Spark → dashboard
```

Y, si hay tiempo:

```txt
Silver/Gold con Spark local o Colab
```

## 15. Decidir arquitectura sin caer en la moda

Usa esta tabla antes de elegir:

| Si el problema necesita... | Arquitectura candidata |
| -------------------------- | ---------------------- |
| Informe diario estable | Batch + Medallion |
| Datos fiables por capas | Medallion |
| Reprocesar histórico completo | Batch / Lambda |
| Baja latencia + histórico preciso | Lambda |
| Eventos continuos y un solo flujo | Kappa |
| Datos de distintas calidades | Medallion |
| Dashboard técnico sencillo | Batch + Gold |
| Alertas operativas | Streaming / Kappa |
| Aula con bajo presupuesto | Local batch + Parquet + DuckDB/Spark |

Y esta otra para evitar fantasías:

| Pregunta | Si la respuesta es “no” |
| -------- | ----------------------- |
| ¿Necesito baja latencia real? | No uses streaming como centro. |
| ¿Tengo cuentas cloud estables? | Evita depender de AWS/GCP/Azure. |
| ¿Puedo mantener un clúster? | Usa local/Colab/Docker antes de complicar. |
| ¿Hay volumen real suficiente? | Simula volumen o explica el límite. |
| ¿La herramienta añade aprendizaje o ruido? | Simplifica. |

## 16. Relación con Big Data Aplicado e IA

La web de referencia consultada mezcla contenidos de NoSQL, cloud, ingeniería de datos, Hadoop, Spark, flujos, IA y proyectos. Eso es normal en muchos centros: se organiza por bloques de trabajo, no por frontera rígida entre módulos.

Para nuestro curso:

- **Sistemas de Big Data** debe quedarse con arquitectura, almacenamiento, integración, procesamiento, calidad, formatos y visualización técnica.
- **Big Data Aplicado** puede absorber solución de negocio, monitorización profunda, operación, despliegue cloud completo y BI aplicado.
- La parte de **IA/Hugging Face/Gradio/datasets de audio** no debe entrar aquí como núcleo. Puede tener sentido en Programación de IA o en proyectos integradores, pero sólo conectaría con SBD si se usa para explicar datasets, pipelines o almacenamiento/procesamiento.

No confundamos “interesante” con “curricularmente central”. Esa es la trampa.

## 17. Actividad rápida de comprensión

Elige una de estas situaciones y justifica la arquitectura:

1. Un ayuntamiento quiere KPIs diarios de turismo por zona.
2. Una tienda online quiere detectar picos de ventas en tiempo casi real.
3. Un hotel quiere cruzar reservas, meteorología y ventas para preparar personal.
4. Una app genera eventos de uso cada segundo y quiere alertas.

Para cada caso, responde:

- ¿Batch, streaming, Lambda, Kappa, Medallion o combinación?
- ¿Qué iría a Bronze?
- ¿Qué limpiarías en Silver?
- ¿Qué publicarías en Gold?
- ¿Qué herramienta usarías en aula?
- ¿Qué coste o limitación ves?

## 18. Checklist de diseño de arquitectura

Antes de cerrar una arquitectura:

- [ ] El caso de uso está claro.
- [ ] Sé qué latencia necesita.
- [ ] Sé qué fuentes entran.
- [ ] Distingo dato raw, limpio y preparado.
- [ ] Defino reglas de calidad.
- [ ] Mantengo trazabilidad.
- [ ] Elijo formato de almacenamiento.
- [ ] Justifico batch o streaming.
- [ ] Justifico herramientas.
- [ ] Evalúo coste y viabilidad en aula.
- [ ] Sé qué parte sería más propia de Big Data Aplicado.

## 19. Referencias consultadas

- Aitor Medrano — Arquitecturas Big Data: `https://aitor-medrano.github.io/iabd/de/arq.html`
- Aitor Medrano — Materiales IABD: `https://aitor-medrano.github.io/iabd/`
- Databricks — Medallion lakehouse architecture: `https://docs.databricks.com/en/lakehouse/medallion.html`
- Microsoft Learn / Azure Databricks — Medallion architecture: `https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion`
- Confluent — Event streaming patterns and Kafka architecture: `https://developer.confluent.io/patterns/`
- Thoughtworks — Data Mesh: `https://www.thoughtworks.com/what-we-do/data-and-ai/data-mesh`
- IBM — Data Fabric: `https://www.ibm.com/topics/data-fabric`
