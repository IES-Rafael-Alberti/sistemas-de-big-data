# Configuración de Séneca y del calificador Moodle — SBD 2026/2027

Este documento separa los dos registros necesarios: Séneca determina la
calificación oficial por resultados de aprendizaje; Moodle ordena los
instrumentos y sus evidencias. No se debe convertir el total de Moodle en la
nota oficial del módulo.

## Ponderación de RA en Séneca

| RA | Ponderación | Justificación operativa |
|---|---:|---|
| RA1 — Integración, procesamiento y análisis | 30 % | Es el eje transversal: arquitectura, fuentes, datasets, planificación y decisión técnica. |
| RA2 — Cuadros de mando | 20 % | Se demuestra principalmente en la ruta BI técnica y en el proyecto. |
| RA3 — Gestión y almacenamiento | 25 % | Tiene evidencia práctica específica en ingesta, Medallion, calidad y seguridad. |
| RA4 — Visualización y herramientas Big Data | 25 % | Abarca datos no estructurados, procesamiento distribuido, automatización y visualización. |
| **Total** | **100 %** | |

En Séneca, asociar cada CE a su RA y distribuir de forma uniforme el peso dentro
del RA: RA1.a-g, 1/7 cada CE; RA2.a-e y RA3.a-e, 1/5 cada CE; RA4.a-f, 1/6 cada
CE. La nota del RA se obtiene de sus CE, no de la media de las unidades.

## Criterio de cálculo en Moodle

- Crear cada categoría con agregación **Media ponderada de calificaciones**.
- Calificar todos los ítems evaluables sobre 100 puntos.
- Las ponderaciones de las tablas son internas a cada UD y suman 100 %.
- Ocultar el total general o identificarlo como **informativo**.
- Usar el valor de `ID` como número de identificación del ítem.
- Tareas y cuestionarios generan su propio ítem: no crear uno manual duplicado.
- Actividades de ampliación, ejemplos y seguimiento no generan una nota
  independiente o se excluyen del total.
- Las tareas cooperativas aportan evidencia de grupo; el CE solo se acredita tras
  revisar contribución, trazabilidad y defensa individual.

## Árbol de categorías

```text
Sistemas de Big Data 2026/2027 (total informativo, oculto)
├── UD1 — Fundamentos y arquitectura
│   └── UD1 — Cuestionarios Moodle
├── UD2 — Almacenamiento e ingesta
│   └── UD2 — Cuestionarios Moodle
├── UD3 — Procesamiento distribuido
│   └── UD3 — Cuestionarios Moodle
├── UD4 — BI y orquestación
│   └── UD4 — Cuestionarios Moodle
├── UD5 — Spark MLlib
│   └── UD5 — Cuestionarios Moodle
├── UD6 — Proyecto integrador
└── Acreditación individual (sin peso en el total)
```

`Acreditación individual` conserva defensas, recuperaciones y comprobaciones de
autoría que no deben convertirse en una segunda calificación de la práctica.

## Ítems evaluables

| Categoría | Actividad Moodle / ítem | Tipo | Peso | ID | RA/CE principal |
|---|---|---|---:|---|---|
| UD1 | EDA y calidad con DuckDB | Tarea | 30 % | `ud1-eda-calidad` | RA1.b |
| UD1 | Modelado documental y consulta analítica | Tarea | 20 % | `ud1-modelado-documental` | RA4.a |
| UD1 | Diseño de arquitectura Medallion | Tarea | 35 % | `ud1-arquitectura-medallion` | RA1.a, c-d, f-g; RA3.a-d |
| UD1 / Cuestionarios | Quiz UD1 | Cuestionario | 100 % de cuestionarios | `ud1-quiz` | RA1.a; contraste de arquitectura |
| UD1 | Total de cuestionarios | Categoría | 15 % | `ud1-cuestionarios` | RA1.a |
| UD2 | Pipeline de integración dlt | Tarea | 25 % | `ud2-pipeline-dlt` | RA1.b-c; RA3.a, d |
| UD2 | Calidad, RGPD e idempotencia | Tarea | 15 % | `ud2-calidad-rgpd` | RA3.d-e; RA1.g |
| UD2 | Matriz coste-calidad-viabilidad | Tarea | 15 % | `ud2-coste-calidad` | RA1.f-g |
| UD2 | Práctica Medallion local | Tarea | 30 % | `ud2-medallion` | RA1.b-d; RA3.a-b; RA4.a |
| UD2 / Cuestionarios | Quiz UD2 | Cuestionario | 100 % de cuestionarios | `ud2-quiz` | RA3.a-d; RA4.a, c |
| UD2 | Total de cuestionarios | Categoría | 15 % | `ud2-cuestionarios` | RA3; RA4 |
| UD3 | Portfolio SparkLabs 1-5 | Tarea | 45 % | `ud3-portfolio-spark` | RA3.c; RA4.c, e |
| UD3 | Benchmark pandas, DuckDB y Spark | Tarea | 30 % | `ud3-benchmark` | RA1.f-g; RA3.b; RA4.d |
| UD3 / Cuestionarios | Quiz UD3 | Cuestionario | 100 % de cuestionarios | `ud3-quiz` | RA3.c; RA4.c-e |
| UD3 | Total de cuestionarios | Categoría | 15 % | `ud3-cuestionarios` | RA3; RA4 |
| UD3 | Defensa técnica individual | Tarea sin entrega | 10 % | `ud3-defensa` | RA3.c; RA4.c-e |
| UD4 | Mini-proyecto BI técnico | Tarea | 35 % | `ud4-mini-bi` | RA2.a-b, e; RA4.b, f |
| UD4 | Dashboard técnico Medallion y Airflow | Tarea | 40 % | `ud4-dashboard-airflow` | RA2.c-d; RA4.e-f |
| UD4 / Cuestionarios | Quiz UD4 | Cuestionario | 100 % de cuestionarios | `ud4-quiz` | RA2.a-c; RA4.b, e-f |
| UD4 | Total de cuestionarios | Categoría | 15 % | `ud4-cuestionarios` | RA2; RA4 |
| UD4 | Defensa técnica individual | Tarea sin entrega | 10 % | `ud4-defensa` | RA2.b-e; RA4.b, e-f |
| UD5 | Portfolio Spark MLlib | Tarea | 70 % | `ud5-portfolio-mllib` | RA2.d; RA4.d-e |
| UD5 / Cuestionarios | Quiz UD5 | Cuestionario | 100 % de cuestionarios | `ud5-quiz` | RA1.f-g; RA2.d; RA4.d-e |
| UD5 | Total de cuestionarios | Categoría | 20 % | `ud5-cuestionarios` | RA1; RA2; RA4 |
| UD5 | Defensa técnica individual | Tarea sin entrega | 10 % | `ud5-defensa` | RA2.d; RA4.e |
| UD6 | Proyecto integrador SBD | Tarea | 70 % | `ud6-proyecto-sbd` | RA1, RA2.c-e, RA3.a-d, RA4.d-f |
| UD6 | Defensa individual y modificación dirigida | Tarea sin entrega | 30 % | `ud6-defensa` | CE aplicables del proyecto |
| Acreditación individual | Recuperación o contraste de CE | Tarea sin entrega | Excluido | `acreditacion-ce-*` | CE pendiente concreto |

## Elementos sin nota independiente

- HDFS/EMR, DynamoDB, Airbyte y AWS Academy son ampliaciones: no se califican
  mientras no estén validadas sus condiciones de aula.
- Grafana y Kibana son ampliación de UD3; no duplican la evidencia principal de
  visualización de UD4.
- Labs preparatorios, propuestas de proyecto y seguimientos de fase se integran
  en el ítem principal de su unidad o quedan sin calificación.

## Orden de montaje en Moodle

1. Crear el curso plantilla `Sistemas de Big Data 2026/2027 — plantilla`, sin alumnado.
2. Crear las siete categorías del árbol y seleccionar media ponderada.
3. Crear tareas y cuestionarios; Moodle generará los ítems automáticamente.
4. Mover los ítems, asignar su `ID` y aplicar los pesos indicados.
5. Crear las tareas sin entrega para defensas y recuperaciones, excluyendo estas
   últimas del total.
6. Verificar con una cuenta de prueba que cada UD suma 100 %.
7. Guardar una copia de seguridad sin usuarios y probar su restauración antes de
   usarla con un grupo real.

Moodle no importa categorías, pesos ni actividades desde un CSV de notas. La
cobertura y acreditación por RA/CE se controla en
`MATRIZ_SEGUIMIENTO_RA_CE_2026_2027.md` y su plantilla CSV.
