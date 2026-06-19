# UD4 - Documento 05
## Apache Superset - Introduccion y enfoque profesional

---

## 1. Introduccion

Apache Superset es una plataforma de Business Intelligence orientada a entornos profesionales.

A diferencia de Metabase:

- ofrece mayor capacidad de configuracion,
- permite modelos semanticos mas complejos,
- esta muy extendida en entornos empresariales,
- es mas exigente en configuracion inicial.

En esta unidad no profundizaremos tanto como en Metabase, pero es importante conocerla para no limitar el perfil profesional al uso de una unica herramienta.

---

## 2. Que es Superset

Superset es:

- una aplicacion web open source,
- orientada a visualizacion y exploracion de datos,
- compatible con multiples motores de bases de datos,
- diseñada para analisis interactivo.

No es:

- una herramienta ETL,
- un motor de procesamiento,
- un sustituto de Spark.

Es una capa de visualizacion sobre datos ya preparados.

---

## 3. Arquitectura basica

Superset trabaja con:

- bases de datos externas,
- conexiones configuradas manualmente,
- datasets definidos dentro de la herramienta.

Proceso general:

1. Conectar base de datos.
2. Definir dataset.
3. Crear chart.
4. Construir dashboard.

Es similar conceptualmente a Metabase, pero mas configurable.

---

## 4. Conexion a la base de datos

Pasos generales:

1. Acceder a la interfaz web.
2. Crear usuario administrador.
3. Ir a "Settings" -> "Database Connections".
4. Anadir nueva base de datos.
5. Introducir URI de conexion.

Ejemplo URI PostgreSQL:

postgresql://usuario:password@host:puerto/base

Una vez conectada, se pueden crear datasets.

---

## 5. Dataset en Superset

Un dataset en Superset es:

- una tabla o vista existente en la base de datos,
- o una consulta SQL guardada.

Superset permite:

- definir dimensiones,
- definir metricas,
- establecer tipos de columnas.

Esto crea una capa semantica mas controlada.

---

## 6. Creacion de graficos

Superset utiliza el concepto de "Chart".

Proceso:

1. Seleccionar dataset.
2. Elegir tipo de grafico.
3. Definir dimension.
4. Definir metrica.
5. Aplicar filtros.
6. Guardar.

Tipos de graficos:

- time series,
- bar chart,
- pie chart,
- table,
- big number,
- heatmap.

Es mas flexible pero tambien mas tecnico que Metabase.

---

## 7. Diferencias clave respecto a Metabase

Metabase:

- mas simple,
- mas rapido de configurar,
- orientado a usuario menos tecnico.

Superset:

- mayor control,
- mejor integracion en entornos profesionales,
- mejor gestion de metricas definidas,
- mas potente en personalizacion.

En esta unidad:

- Metabase sera herramienta principal,
- Superset se utilizara como aproximacion profesional.

---

## 8. Cuándo usar Superset

Superset es recomendable cuando:

- el equipo tecnico necesita control fino,
- se requieren metricas definidas centralmente,
- hay multiples equipos accediendo a los mismos datos,
- se busca entorno mas profesional.

---

## 9. Buenas practicas en Superset

- Definir claramente metricas reutilizables.
- Evitar consultas SQL repetidas en cada grafico.
- Documentar datasets.
- Mantener coherencia entre dashboards.

Superset no debe convertirse en una acumulacion de graficos sin criterio.

---

## 10. Relacion con UD5 y UD6

En la UD5:

- los resultados de Spark MLlib pueden visualizarse en Superset.

En la UD6:

- el proyecto final podra utilizar:
  - Metabase,
  - Superset,
  - o combinacion de ambas.

La herramienta sera una decision justificada.

---

## 11. Conclusiones

Superset representa una herramienta de nivel profesional.

Conocerla permite:

- ampliar perfil tecnico,
- comprender entornos reales,
- no depender de una unica plataforma.

En BI, la herramienta es secundaria frente al modelo y la interpretacion.

---

## Fin del documento
