---
output:
  pdf_document: default
  html_document: default
---
# UD4 - Documento 09
## Diseño profesional de dashboards

---

# 1. Introducción

Un dashboard no es un conjunto de gráficos.

Es una herramienta de decisión.

Un buen dashboard:

- responde a preguntas claras,
- facilita la interpretación,
- evita ambigüedades,
- permite detectar patrones y problemas.

Un mal dashboard:

- satura de información,
- mezcla métricas sin coherencia,
- confunde más de lo que ayuda.

---

# 2. Antes de crear un dashboard

Antes de arrastrar campos en Metabase o Superset, debemos responder:

1. ¿Qué pregunta de negocio quiero responder?
2. ¿Quién es el usuario del dashboard?
3. ¿Qué decisión podría tomarse con esta información?
4. ¿Qué nivel de detalle necesita el usuario?

Sin estas respuestas, el dashboard será decorativo.

---

# 3. Jerarquía visual

Un dashboard debe tener estructura.

Orden recomendado:

1. KPI principal (visión global)
2. Evolución temporal
3. Desglose por categorías
4. Detalle adicional

No mezclar todo al mismo nivel.

El usuario debe entender en segundos:

- Situación general
- Tendencia
- Causa probable

---

# 4. Selección adecuada de gráficos

Reglas básicas:

Evolución temporal -> Gráfico de líneas  
Comparación entre categorías -> Barras  
Valor único destacado -> Indicador  
Distribución -> Histograma  

Evitar:

- Gráficos circulares con muchas categorías.
- Gráficos innecesariamente complejos.
- Visualizaciones que requieren demasiado esfuerzo cognitivo.

---

# 5. Consistencia de métricas

Un error común es mezclar granularidades.

Ejemplo incorrecto:

- KPI mensual
- Gráfico diario
- Comparación anual

Todo debe estar alineado en nivel de detalle.

---

# 6. Evitar sobrecarga

Un dashboard no debe tener:

- 10 gráficos sin relación,
- 5 colores sin significado,
- métricas sin explicación.

Regla orientativa:

Entre 3 y 6 visualizaciones principales es suficiente.

---

# 7. Uso de filtros

Los filtros deben:

- facilitar análisis,
- no generar confusión,
- mantener coherencia con las métricas.

No abusar de filtros si el usuario no los necesita.

---

# 8. Interpretación obligatoria

Un dashboard sin interpretación es incompleto.

Siempre debe responder:

- ¿Qué está ocurriendo?
- ¿Por qué?
- ¿Qué decisión podría tomarse?

La visualización es un medio.
La interpretación es el objetivo.

---

# 9. Errores frecuentes en proyectos académicos

- Hacer gráficos solo porque se pueden hacer.
- No justificar métricas.
- No revisar valores extremos.
- No analizar nulos.
- No comprobar coherencia del modelo.

---

# 10. Checklist antes de entregar un dashboard

- ¿Responde a la pregunta inicial?
- ¿Las agregaciones son correctas?
- ¿Las etiquetas son claras?
- ¿El orden tiene sentido?
- ¿La interpretación está documentada?

---

# 11. Conexión con el proyecto integrador

En el proyecto UD6:

- No se evaluará estética avanzada.
- Se evaluará claridad analítica.
- Se evaluará coherencia de modelo.
- Se evaluará interpretación razonada.

Un dashboard simple pero bien pensado vale más que uno complejo sin criterio.

---

# 12. Conclusiones

Diseñar un dashboard es:

- pensar en decisiones,
- estructurar información,
- comunicar con claridad.

La herramienta es secundaria.
El pensamiento analítico es central.

---

## Fin del documento

