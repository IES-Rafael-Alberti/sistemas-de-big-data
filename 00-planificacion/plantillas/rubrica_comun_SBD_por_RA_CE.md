# Rúbrica común — Sistemas de Big Data por RA/CE

> **Propósito**: Evaluación coherente entre unidades. Cada RA/CE se evalúa con
> los mismos criterios transversales, independientemente de la actividad concreta.
>
> **Uso**: El docente selecciona los RA/CE que cubre una actividad y aplica los
> criterios correspondientes de esta rúbrica. No es necesario usarlos todos en cada tarea.

---

## RA1 — Aplica técnicas de análisis de datos

| CE | Criterio | Excelente (4) | Notable (3) | Aprobado (2) | Insuficiente (1) |
|----|----------|---------------|-------------|--------------|------------------|
| **a** | Base matemática | Aplica estadística descriptiva e inferencial correctamente, interpreta correlación/colinealidad y outliers con criterio | Aplica correctamente pero sin profundidad en la interpretación | Aplica fórmulas pero no interpreta resultados | No aplica o errores graves |
| **b** | Extracción automática | Implementa extracción automatizada desde múltiples fuentes con código reutilizable | Extrae datos de al menos una fuente con script propio | Usa script proporcionado sin adaptación | No extrae datos |
| **c** | Combinación de fuentes | Integra 3+ fuentes heterogéneas (CSV, JSON, API, DB) con joins/union correctos y justificados | Integra 2 fuentes correctamente | Integra 2 fuentes con errores menores | No integra o errores graves |
| **d** | Dataset complejo | Construye dataset integrando múltiples fuentes con relaciones, tipado correcto y documentación | Dataset integrado correcto con al menos 2 fuentes | Dataset básico sin relaciones entre tablas | Dataset incompleto o inexistente |
| **e** | Planificación técnica | Entrega planificación con objetivos, prioridades, secuenciación y tiempos realistas (ver plantilla) | Planificación completa pero tiempos poco realistas | Planificación básica sin prioridades | Sin planificación |
| **f** | Selección de sistemas | Compara 2+ alternativas con criterios objetivos y justifica la elección razonadamente | Compara alternativas pero justificación genérica | Menciona alternativas sin comparación real | No selecciona o no justifica |
| **g** | Coste y calidad | Usa la matriz coste-calidad-viabilidad con todas las alternativas valoradas y justificaciones concretas | Matriz completa con justificaciones genéricas | Matriz parcial o justificaciones superficiales | Matriz incompleta o sin justificar |

---

## RA2 — Configura cuadros de mando

| CE | Criterio | Excelente (4) | Notable (3) | Aprobado (2) | Insuficiente (1) |
|----|----------|---------------|-------------|--------------|------------------|
| **a** | Clasificación librerías | Compara 3+ herramientas de visualización clasificadas por tipo, licencia y caso de uso | Compara 2 herramientas correctamente | Enumera herramientas sin clasificar | No clasifica |
| **b** | Cruce información-objetivo | Elige tipo de visualización según objetivo analítico y naturaleza de los datos, justificando la decisión | Relación parcial pero justificada | Elección arbitraria sin justificación | Sin relación entre objetivo y visualización |
| **c** | Cuadro de mando técnico | Dashboard técnico funcional con 6+ visualizaciones coherentes, filtros y organización clara | Dashboard con 4-5 visualizaciones | Dashboard básico con 2-3 visualizaciones | Sin dashboard o no funcional |
| **d** | Técnicas predictivas | Aplica modelo predictivo (regresión/clasificación) y lo integra en el análisis del dashboard | Aplica modelo pero no lo integra en el dashboard | Menciona predictivo sin implementarlo | No aplica |
| **e** | Impacto del análisis | Evalúa el impacto de los resultados en la toma de decisiones con argumentos concretos | Evalúa impacto de forma genérica | Menciona impacto sin analizarlo | No evalúa |

---

## RA3 — Gestiona y almacena datos

| CE | Criterio | Excelente (4) | Notable (3) | Aprobado (2) | Insuficiente (1) |
|----|----------|---------------|-------------|--------------|------------------|
| **a** | Extracción y almacenamiento | Extrae datos de 2+ fuentes distintas y los almacena en formato eficiente (Parquet) justificando la elección | Almacena en formato correcto sin justificar | Almacena en formato básico (CSV) | No almacena o pérdida de datos |
| **b** | Valor de los datos | Define objetivos de valoración del dataset y elige tecnología según el objetivo | Objetivo definido pero tecnología no alineada | Objetivo vago | Sin objetivo |
| **c** | Revolución digital | Contextualiza el proyecto en el panorama Big Data actual identificando tendencias y retos | Contextualiza correctamente | Mención genérica | Sin contextualización |
| **d** | Eficiencia, seguridad y normativa | Implementa almacenamiento eficiente y completa el proceso de anonimización: busca identificadores, documenta ausencia o aplica medidas hasta que no se pueda identificar a personas | Almacenamiento eficiente y revisión básica de identificadores | Solo eficiencia o solo privacidad de forma superficial | No considera seguridad, normativa ni privacidad |
| **e** | Habilidades científicas | Documenta el proceso experimental: hipótesis, metodología, resultados y conclusiones | Proceso documentado pero sin metodología explícita | Documentación básica | Sin documentación |

---

## RA4 — Aplica herramientas de visualización

| CE | Criterio | Excelente (4) | Notable (3) | Aprobado (2) | Insuficiente (1) |
|----|----------|---------------|-------------|--------------|------------------|
| **a** | Escenarios y tipologías | Identifica tipos de datos (estructurados, semiestructurados, no estructurados) y elige visualización adecuada para cada uno | Identifica tipos pero no siempre acierta con la visualización | Confunde tipos de datos | No identifica |
| **b** | BI para extracción de valor | Usa herramienta BI (Metabase/Superset) para construir dashboard que responde preguntas técnicas concretas | Dashboard funcional pero preguntas mejorables | Herramienta BI usada sin preguntas definidas | No usa BI |
| **c** | Almacenamiento distribuido | Comprende y explica las ventajas del almacenamiento distribuido (Parquet, HDFS, S3) y lo aplica en el proyecto | Explica correctamente pero no lo aplica | Comprensión parcial | No comprende |
| **d** | Diferencias herramientas | Compara herramientas del ecosistema Big Data explicando sus diferencias (procesamiento, almacenamiento, visualización) | Compara algunas herramientas | Enumera sin comparar | No diferencia |
| **e** | Programación automática | Implementa procesamiento automatizado de datos (scripts reutilizables, pipelines parametrizados) | Scripts funcionales pero no reutilizables | Automatización básica | Sin automatización |
| **f** | Visualización | Crea 3+ visualizaciones diferentes y justifica por qué cada una es adecuada para los datos y la pregunta | Visualizaciones correctas pero justificación genérica | Visualizaciones sin justificación | Sin visualizaciones |

---

## Ponderación por actividad

No todas las actividades cubren todos los CE. Para cada tarea, el docente debe:

1. **Seleccionar los CE aplicables** de la tabla anterior.
2. **Asignar peso** a cada CE según la importancia en la actividad (total 100%).
3. **Calcular nota**: suma de (puntuación CE × peso).
4. **Convertir a escala** si es necesario (sobre 10, sobre 100, etc.).

### Criterio transversal: uso de IA

Si el alumnado usa IA generativa en una tarea o proyecto, el docente debe valorar
la **transparencia y defensa** de ese uso. Este criterio puede integrarse dentro
de documentación, reproducibilidad o defensa oral.

En SBD no se aplica la escala completa 0-5 de uso de IA del módulo de
Programación de 1º. La exigencia es más ligera: si se usa IA, el alumnado debe
declararla, explicar el proceso seguido y defender qué ha aprendido.

| Aspecto | Excelente | Aceptable | Insuficiente |
|---------|-----------|-----------|--------------|
| **Declaración** | Declara herramienta/modelo, prompts relevantes, partes afectadas y resultado incorporado | Declara uso de IA pero con poca trazabilidad | No declara IA aunque hay indicios claros de uso |
| **Proceso seguido** | Explica cuándo usó IA, qué problema intentaba resolver, cómo cambió la solución y qué comprobó | Describe el uso de IA de forma superficial | No puede reconstruir cómo llegó al resultado |
| **Verificación** | Ejecuta, contrasta y corrige lo generado; documenta cambios propios | Verifica parcialmente | Copia sin probar o mantiene errores obvios |
| **Comprensión** | Puede explicar oralmente el código/texto asistido por IA | Explica parcialmente | No puede defender partes esenciales |
| **Responsabilidad técnica** | Distingue decisiones propias de sugerencias de la IA | Distinción poco clara | Atribuye a la IA decisiones que no entiende |

Recurso: `00-planificacion/plantillas/plantilla_declaracion_uso_ia.md`.

### Ejemplo: Actividad práctica Medallion (UD2)

| CE | Criterio | Peso | Puntuación | Nota |
|----|----------|------|------------|------|
| RA1.b | Extracción automática | 15% | 4 | 0.60 |
| RA1.c | Combinación de fuentes | 15% | 3 | 0.45 |
| RA1.d | Dataset complejo | 20% | 4 | 0.80 |
| RA1.e | Planificación | 10% | 3 | 0.30 |
| RA3.a | Extracción y almacenamiento | 20% | 4 | 0.80 |
| RA3.d | Eficiencia y seguridad | 20% | 3 | 0.60 |
| **Total** | | **100%** | | **3.55/4** → **8.9/10** |

---

## Histórico de cambios

| Fecha       | Cambio |
| ----------- | ------ |
| 2026-06-18 | Creación de la rúbrica común transversal. |
| 2026-06-19 | Añadido criterio transversal de uso de IA. |
| 2026-06-19 | Añadida exigencia SBD de explicar el proceso de uso de IA sin aplicar niveles 0-5. |
