# UD6 - Proyecto Integrador
## Big Data + BI + Procesamiento + ML + Orquestación

---

# 1. Objetivo general

Vais a desarrollar un proyecto completo de ingeniería y analítica de datos que incluya:

- Ingesta de múltiples fuentes.
- Integración y calidad.
- Procesamiento distribuido.
- Visualización BI.
- Analítica avanzada o ML.
- Diseño formal del pipeline completo.

El proyecto debe reflejar un flujo realista de datos.

---

# 2. Estructura obligatoria del pipeline

El proyecto debe contemplar las siguientes fases:

1. Fuente de datos A
2. Fuente de datos B
3. Ingesta
4. Limpieza
5. Integración
6. Procesamiento (Spark obligatorio)
7. Almacenamiento final
8. Visualización BI
9. Analítica avanzada o ML

No se aceptarán proyectos donde falte alguna fase.

---

# 3. Diseño obligatorio del pipeline

Cada grupo deberá incluir:

- Diagrama del flujo completo.
- Representación tipo DAG.
- Justificación de dependencias.
- Identificación de tareas paralelas si existen.

El diseño del pipeline es obligatorio aunque no se implemente en Airflow.

Debe quedar claro:

- Qué tareas dependen de cuáles.
- Qué tareas pueden ejecutarse en paralelo.
- Qué tareas son críticas.

---

# 4. Implementación de orquestación (opcional evaluable)

Opcionalmente el grupo podrá:

- Implementar el pipeline en Airflow.
- Crear un DAG funcional.
- Automatizar al menos 3 tareas reales.

Si se implementa correctamente:

- Mejora la calificación final.
- Se evaluará robustez y coherencia.

Si no se implementa:

- El diseño conceptual sigue siendo obligatorio.

---

# 5. Spark obligatorio

Debe existir al menos:

- Una transformación significativa en Spark.
- Una agregación distribuida.
- Justificación del uso de Spark frente a pandas.

No se aceptarán usos triviales.

---

# 6. ML o analítica avanzada obligatoria

Debe incluir al menos uno de los siguientes:

- Regresión.
- Clasificación.
- Clustering.
- Análisis de correlación estructurado.
- Detección de anomalías.

Debe justificarse:

- Variable objetivo.
- Variables explicativas.
- Métricas.
- Interpretación.

No se aceptará ML sin sentido de negocio.

---

# 7. BI obligatorio

Debe incluir:

- Mínimo 3 visualizaciones.
- Mínimo 1 KPI.
- Filtro o segmentación.
- Interpretación razonada.

El dashboard debe responder a las preguntas definidas en la Fase 1.

---

# 8. Entregables obligatorios

1. Documento técnico completo.
2. Repositorio con scripts.
3. Diagrama de arquitectura.
4. Diagrama del pipeline tipo DAG.
5. Dashboard funcional.
6. Defensa oral.

Si se implementa Airflow:

7. Captura del DAG ejecutado.
8. Captura de logs.

---

# 9. Criterios de evaluación

| Área | Peso |
|------|------|
| Definición del problema | 10% |
| Calidad de fuentes e integración | 15% |
| Procesamiento Spark | 20% |
| BI | 15% |
| ML | 20% |
| Diseño del pipeline | 10% |
| Defensa oral | 10% |
| Implementación Airflow (bonus) | Hasta +10% |

---

# 10. Aprobación previa obligatoria

Antes de comenzar el desarrollo completo, el grupo deberá entregar:

- Problema definido.
- Fuentes propuestas.
- Esquema preliminar del pipeline.

No se podrá continuar sin aprobación docente.

---

# 11. Restricciones

No se aceptarán:

- Datasets triviales sin transformación.
- ML artificial sin interpretación.
- Dashboards decorativos.
- Proyectos excesivamente simples.

---

# 12. Objetivo final

El proyecto debe demostrar:

- Comprensión del ciclo completo de datos.
- Capacidad técnica.
- Capacidad de interpretación.
- Comprensión arquitectónica.

No se evalúa solo código.
Se evalúa pensamiento estructural.

---

## Fin del documento
