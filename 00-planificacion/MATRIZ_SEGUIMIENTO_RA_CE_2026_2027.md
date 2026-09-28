# Matriz de cobertura y seguimiento individual RA/CE — SBD 2026/2027

Esta matriz relaciona cada CE con su evidencia de cierre. Complementa el
calificador Moodle: sus categorías organizan instrumentos, pero la calificación
oficial y la acreditación se deciden por RA/CE en Séneca.

La plantilla editable es `plantilla_seguimiento_ra_ce.csv`. Se duplica por cada
estudiante y se actualiza al revisar evidencia individual.

## Regla de acreditación

- `NE`: sin evidencia individual evaluada.
- `PE`: evidencia entregada o revisada parcialmente; falta calificar o defender.
- `AC`: evidencia individual suficiente, con calificación del CE igual o superior a 5.
- `NR`: no acreditado; requiere refuerzo o recuperación.
- Un RA queda cerrado cuando todos sus CE son `AC` y la media de sus CE es igual
  o superior a 5, conforme a la ponderación registrada en Séneca.
- Una práctica en pareja o equipo solo acredita tras comprobar repositorio,
  contribución individual y defensa técnica. Un quiz no cierra por sí solo un CE
  práctico.

## Distribución principal

| RA | CE | Unidad primaria | Refuerzo o contraste | Ítem Moodle y evidencia individual de cierre |
|---|---|---|---|---|
| RA1 | a | UD1 | UD6 | `ud1-arquitectura-medallion` y `ud1-quiz`: explicación individual de complejidad y decisión arquitectónica. |
| RA1 | b | UD1 | UD2, UD6 | `ud1-eda-calidad`: notebook explicado y resultados de extracción/EDA. |
| RA1 | c | UD2 | UD1, UD6 | `ud2-pipeline-dlt`: integración reproducible de fuentes y explicación de joins. |
| RA1 | d | UD2 | UD1, UD6 | `ud2-medallion`: Silver/Gold relacionado, esquema y trazabilidad. |
| RA1 | e | UD6 | UD2 | `ud6-proyecto-sbd`: planificación técnica individual, prioridades y revisión del plan. |
| RA1 | f | UD2 | UD3, UD6 | `ud2-coste-calidad`: selección razonada de sistemas. |
| RA1 | g | UD2 | UD3, UD6 | `ud2-coste-calidad`: matriz de coste, calidad y viabilidad defendida. |
| RA2 | a | UD4 | UD4 quiz | `ud4-mini-bi`: comparativa técnica de herramientas de visualización. |
| RA2 | b | UD4 | UD6 | `ud4-mini-bi`: elección de visualizaciones según objetivo y datos. |
| RA2 | c | UD4 | UD6 | `ud4-dashboard-airflow`: dashboard técnico funcional y explicado. |
| RA2 | d | UD5 | UD4, UD6 si procede | `ud5-portfolio-mllib`: modelo predictivo, métricas e interpretación individual. |
| RA2 | e | UD4 | UD6 | `ud4-mini-bi` o `ud4-dashboard-airflow`: reflexión individual sobre impacto. |
| RA3 | a | UD2 | UD6 | `ud2-pipeline-dlt` y `ud2-medallion`: ingesta de varias fuentes a almacenamiento reproducible. |
| RA3 | b | UD2 | UD3, UD6 | `ud2-medallion`: Parquet/DuckDB y justificación de eficiencia. |
| RA3 | c | UD3 | UD6 | `ud3-portfolio-spark`: procesamiento distribuido explicado y ejecutado. |
| RA3 | d | UD2 | UD6 | `ud2-calidad-rgpd`: calidad, idempotencia, seguridad y normativa documentadas. |
| RA3 | e | UD2 | UD6 | `ud2-calidad-rgpd`: hipótesis, método, resultados y conclusión propios. |
| RA4 | a | UD1 | UD2 | `ud1-modelado-documental`: tipología de datos no estructurados/semi-estructurados y modelado. |
| RA4 | b | UD4 | UD6 | `ud4-mini-bi`: implantación de BI para responder preguntas técnicas. |
| RA4 | c | UD3 | UD2, UD6 | `ud3-portfolio-spark`: clúster, distribución y redundancia explicados. |
| RA4 | d | UD3 | UD5, UD6 | `ud3-benchmark`: comparación razonada de pandas, DuckDB y Spark. |
| RA4 | e | UD3 | UD4, UD5, UD6 | `ud3-portfolio-spark` y defensa: script PySpark automatizado. |
| RA4 | f | UD4 | UD6 | `ud4-dashboard-airflow`: visualizaciones justificadas para análisis técnico. |

## Uso con Moodle y Séneca

1. Mantener la matriz fuera del cálculo de totales de Moodle.
2. Al corregir, registrar solo los CE que la evidencia demuestre realmente.
3. Anotar el `ID` de Moodle y el enlace al repositorio, prueba o defensa que
   sustenta la decisión.
4. Registrar en Séneca el logro de cada CE y dejar que aplique la ponderación del
   RA definida en la configuración.
5. Si un CE queda `NR`, generar una evidencia equivalente individual con
   `acreditacion-ce-*`; no sustituirlo por una nota del grupo.

La matriz asegura cobertura y trazabilidad; las rúbricas específicas y
`plantillas/rubrica_comun_SBD_por_RA_CE.md` determinan el nivel de logro.
