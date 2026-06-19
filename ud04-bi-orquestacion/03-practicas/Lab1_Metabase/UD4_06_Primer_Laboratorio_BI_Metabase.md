# UD4 - Laboratorio 1
## Creación de un cuadro de mando en Metabase

> **RA/CE**: RA2.c (cuadro de mando con técnicas sencillas),
> RA4.b (implantar BI), RA4.f (visualizar datos).

---

## 1. Objetivo del laboratorio

En este laboratorio el alumnado deberá:

- Conectar Metabase a la base de datos preparada.
- Crear preguntas utilizando la interfaz gráfica.
- Diseñar un dashboard coherente.
- Justificar las métricas utilizadas.
- Interpretar los resultados obtenidos.

No se evaluará la estética avanzada.
Se evaluará la coherencia analítica.

---

## 2. Contexto

Partimos de:

- Dataset limpio.
- Tablas estructuradas.
- Vistas agregadas si fuera necesario.

No está permitido:

- Modificar la base de datos sin justificarlo.
- Crear métricas arbitrarias sin explicación.

---

## 3. Parte A - Conexión y exploración

### 3.1 Conexión

- Conectar Metabase a la base de datos PostgreSQL.
- Verificar que las tablas son visibles.
- Identificar tabla de hechos y tablas de dimensiones.

### 3.2 Exploración inicial

Responder:

1. ¿Cuál es la tabla principal?
2. ¿Cuál es su granularidad?
3. ¿Qué columnas representan métricas?
4. ¿Qué columnas representan dimensiones?

---

## 4. Parte B - Creación de preguntas

Se deben crear al menos 3 preguntas guardadas.

### Pregunta 1 - Evolución temporal

Requisitos:

- Agregación temporal por mes o semana.
- Suma o media de una métrica principal.
- Visualización en gráfico de líneas.

### Pregunta 2 - Comparación por categoría

Requisitos:

- Agrupación por categoría relevante.
- Visualización en gráfico de barras.
- Orden descendente por valor.

### Pregunta 3 - Indicador clave (KPI)

Requisitos:

- Valor numérico único.
- Puede ser suma total, media o ratio.
- Visualización tipo indicador.

Cada pregunta debe:

- Tener nombre claro.
- Estar guardada.

---

## 5. Parte C - Creación del dashboard

El dashboard debe incluir:

- Las 3 preguntas anteriores.
- Disposición ordenada.
- Títulos descriptivos.
- Al menos un filtro global (si procede).

El dashboard debe responder a una pregunta de negocio clara.

Ejemplo:

- ¿Cómo evoluciona la actividad?
- ¿Qué categoría domina?
- ¿Cuál es el rendimiento global?

---

## 6. Parte D - Interpretación

El informe debe incluir:

1. ¿Qué patrones se observan?
2. ¿Existen picos o anomalías?
3. ¿Qué categoría tiene mayor impacto?
4. ¿Qué decisión podría tomarse a partir del dashboard?

No basta describir el gráfico.
Se debe interpretar.

---

## 7. Parte E - Reflexión técnica

Responder:

1. ¿Se utilizó agregación correcta?
2. ¿Se podría mejorar el modelo de datos?
3. ¿Sería necesario preagregar si el volumen creciera?
4. ¿Se mezclaron granularidades distintas?

---

## 8. Entregable

Documento markdown/docx/

PDF con:

- Capturas de las preguntas creadas.
- Captura del dashboard final.
- Respuestas razonadas.
- Justificación de las métricas.

No se aceptarán entregas sin interpretación.

---

## 9. Criterios de evaluación

Se evaluará:

- Correcta conexión y uso de datos.
- Coherencia de agregaciones.
- Calidad de interpretación.
- Claridad del dashboard.
- Capacidad de reflexión técnica.

---

## 10. Extensión opcional

Opcional para subir nota:

- Crear una cuarta visualización comparativa.
- Implementar filtro dinámico avanzado.
- Proponer mejora del modelo SQL.

---

## Fin del laboratorio
