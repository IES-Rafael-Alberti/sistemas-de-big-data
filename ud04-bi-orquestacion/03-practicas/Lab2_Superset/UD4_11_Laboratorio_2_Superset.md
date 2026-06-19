# UD4 - Laboratorio 2
## Cuadro de mando en Apache Superset

> **RA/CE**: RA2.b (cruzar información), RA4.b (implantar BI), RA4.f (visualizar datos).

---

# 1. Objetivo del laboratorio

En este laboratorio el alumnado deberá:

- Conectar Superset a la base de datos.
- Definir un dataset.
- Crear al menos 2 visualizaciones.
- Construir un dashboard.
- Comparar brevemente con Metabase.

Este laboratorio es obligatorio.

---

# 2. Contexto

Se utilizará el mismo dataset empleado en el Laboratorio 1 (Metabase).

El objetivo no es repetir exactamente lo mismo, sino:

- Observar diferencias.
- Comprender el enfoque más profesional.
- Analizar el nivel de control que ofrece Superset.

---

# 3. Parte A - Configuración inicial

## 3.1 Acceso

- Acceder a la interfaz web de Superset.
- Iniciar sesión como usuario administrador.

## 3.2 Conexión a la base de datos

1. Ir a "Settings" -> "Database Connections".
2. Crear nueva conexión.
3. Introducir URI de PostgreSQL:

   postgresql://usuario:password@host:puerto/base

4. Guardar y verificar conexión.

---

# 4. Parte B - Definición de Dataset

1. Ir a "Data" -> "Datasets".
2. Crear nuevo dataset.
3. Seleccionar base de datos.
4. Seleccionar tabla principal o vista agregada.
5. Guardar dataset.

Responder:

- ¿Qué tabla has seleccionado?
- ¿Cuál es su granularidad?

---

# 5. Parte C - Creación de visualizaciones

Se deben crear al menos 2 charts.

---

## 5.1 Chart 1 - Evolución temporal

Requisitos:

- Tipo: Time Series.
- Métrica: suma o media relevante.
- Dimensión temporal.
- Rango temporal adecuado.

Guardar como:
Evolución temporal - Superset

---

## 5.2 Chart 2 - Comparación por categoría

Requisitos:

- Tipo: Bar Chart.
- Dimensión categórica.
- Métrica agregada.
- Orden descendente.

Guardar como:
Comparación categorías - Superset

---

# 6. Parte D - Creación del Dashboard

1. Crear nuevo dashboard.
2. Añadir los 2 charts creados.
3. Organizar disposición.
4. Añadir título descriptivo.

Debe ser coherente y claro.

---

# 7. Parte E - Comparación con Metabase

Responder de forma razonada:

1. ¿Qué herramienta te ha resultado más sencilla?
2. ¿Cuál ofrece mayor control?
3. ¿Cuál parece más profesional?
4. ¿Cuál usarías en una pequeña empresa?
5. ¿Cuál usarías en un entorno corporativo?
6. ¿En qué casos elegirías cada una?

---

# 8. Reflexión técnica

Responder:

1. ¿Es diferente la lógica de agregación respecto a Metabase?
2. ¿Has tenido que definir métricas explícitamente?
3. ¿Te parece más técnica o más flexible?

---

# 9. Entregable

Documento PDF con:

- Capturas de conexión.
- Capturas de los 2 charts.
- Captura del dashboard.
- Respuestas razonadas.

---

# 10. Criterios de evaluación

Se evaluará:

- Correcta conexión y dataset.
- Coherencia de agregaciones.
- Construcción del dashboard.
- Capacidad crítica en comparación.
- Claridad de respuestas.

No se evaluará estética avanzada.
Se evaluará criterio analítico.

---

## Fin del laboratorio
