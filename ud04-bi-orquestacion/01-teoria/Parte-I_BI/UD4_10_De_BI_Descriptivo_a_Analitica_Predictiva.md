---
output:
  pdf_document: default
  html_document: default
---
# UD4 - Documento 10
## De BI descriptivo a analítica predictiva

---

# 1. Introducción

Hasta ahora hemos trabajado con:

- datos históricos,
- agregaciones,
- visualizaciones,
- indicadores,
- dashboards.

Esto corresponde a analítica descriptiva.

Pero la analítica no termina ahí.

El siguiente paso es intentar responder:

- ¿Qué va a ocurrir?
- ¿Qué probabilidad tiene?
- ¿Qué escenario es más probable?

Aquí comienza la analítica predictiva.

---

# 2. Tipos de analítica

Podemos distinguir cuatro niveles:

1. Analítica descriptiva
   Qué ha ocurrido.

2. Analítica diagnóstica
   Por qué ha ocurrido.

3. Analítica predictiva
   Qué puede ocurrir.

4. Analítica prescriptiva
   Qué debería hacerse.

En UD4 hemos trabajado principalmente en el nivel 1 y parcialmente en el 2.

En UD5 trabajaremos en el nivel 3.

---

# 3. Limitaciones de BI tradicional

Un dashboard puede mostrar:

- tendencia creciente,
- estacionalidad,
- comportamiento irregular.

Pero no puede:

- anticipar valores futuros con base matemática,
- estimar probabilidades,
- clasificar automáticamente nuevos casos.

Para eso necesitamos modelos.

---

# 4. Ejemplo conceptual

En BI podemos observar:

- Ventas por mes.
- Incremento en determinadas categorías.
- Comportamiento estacional.

Pregunta predictiva:

- ¿Cuánto venderemos el próximo mes?
- ¿Qué clientes abandonarán?
- ¿Qué días se producirá mayor demanda?

Esto requiere modelos estadísticos o de aprendizaje automático.

---

# 5. De la agregación al modelo

En BI usamos:

- SUM
- AVG
- COUNT
- GROUP BY

En ML utilizaremos:

- Variables predictoras.
- Variable objetivo.
- Entrenamiento.
- Validación.
- Métricas de evaluación.

La diferencia es conceptual.

BI resume.
ML aprende patrones.

---

# 6. Conexión con Spark

En UD3 utilizamos Spark para:

- procesar grandes volúmenes,
- realizar agregaciones distribuidas.

En UD5 utilizaremos Spark MLlib para:

- entrenar modelos distribuidos,
- trabajar con datasets grandes,
- aplicar algoritmos escalables.

La tecnología es la misma.
El enfoque cambia.

---

# 7. Relación con el proyecto integrador

En el proyecto final:

- El dashboard mostrará resultados históricos.
- El modelo predictivo aportará estimaciones futuras.
- El pipeline integrará ambos.

El objetivo es pasar de:

Ver lo que pasó
a
Estimar lo que puede pasar.

---

# 8. Cambios en la mentalidad

BI:

- Visualizar.
- Interpretar.
- Explicar.

ML:

- Formular problema.
- Seleccionar variables.
- Entrenar modelo.
- Evaluar resultados.
- Interpretar predicciones.

Ambos requieren pensamiento crítico.

---

# 9. Advertencia importante

El modelo no sustituye al análisis.

Un modelo sin interpretación:

- no aporta valor,
- puede inducir a error,
- puede estar mal entrenado.

La calidad del dato sigue siendo fundamental.

UD2 y UD3 siguen siendo la base.

---

# 10. Qué veremos en la siguiente unidad

En UD5 trabajaremos:

- Conceptos básicos de aprendizaje automático.
- Regresión.
- Clasificación.
- Evaluación de modelos.
- Uso de Spark MLlib.
- Integración en el pipeline.

El objetivo no es convertirse en científicos de datos.
Es comprender cómo se integra ML en un sistema Big Data.

---

# 11. Conclusiones

BI permite comprender el pasado.

ML permite estimar el futuro.

Ambos forman parte de un mismo ecosistema.

En la siguiente unidad daremos el siguiente paso.

---

## Fin del documento
