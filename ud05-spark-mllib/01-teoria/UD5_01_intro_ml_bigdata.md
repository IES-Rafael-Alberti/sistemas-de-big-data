# UD5 - Analítica predictiva con Spark

## Introducción

El análisis de datos no termina en la visualización.

En muchos sistemas modernos el objetivo es **predecir comportamientos futuros** a partir de datos históricos.

Ejemplos:

- predecir demanda
- detectar fraude
- clasificar clientes
- recomendar productos

Estos problemas se abordan mediante técnicas de Machine Learning.

---

# Machine Learning en el ecosistema Big Data

En un entorno Big Data el flujo de datos suele ser:

fuentes de datos
→ ingesta
→ procesamiento distribuido
→ almacenamiento analítico
→ modelos predictivos
→ explotación de resultados

El Machine Learning se sitúa en la fase final del pipeline.

---

# Diferencia entre analítica descriptiva y predictiva

Analítica descriptiva responde a preguntas como:

- ¿qué ocurrió?
- ¿cuántas ventas hubo?
- ¿qué categoría vende más?

La analítica predictiva intenta responder:

- ¿qué ocurrirá?
- ¿qué probabilidad tiene un evento?
- ¿qué clientes abandonarán?

---

# Requisitos del Machine Learning

Para entrenar modelos predictivos se necesitan:

- datos históricos
- variables explicativas
- variable objetivo
- evaluación del modelo

Sin datos adecuados no es posible construir modelos útiles.

---

# El problema del volumen de datos

Muchos sistemas generan cantidades masivas de datos.

Ejemplos:

- logs web
- sensores
- transacciones financieras
- registros de usuarios

Procesar estos datos en una sola máquina puede ser inviable.

Aquí es dónde entran los sistemas distribuidos.

---

# Spark como plataforma para ML

Apache Spark permite:

- procesar grandes datasets
- entrenar modelos en paralelo
- escalar análisis de datos

La librería de Machine Learning de Spark se llama **MLlib**.

MLlib proporciona algoritmos para:

- regresión
- clasificación
- clustering
- recomendación

---

# Arquitectura típica de ML en Big Data

Un pipeline típico incluye:

1. ingesta de datos
2. limpieza y transformación
3. generación de features
4. entrenamiento del modelo
5. evaluación
6. despliegue

Cada etapa forma parte del sistema completo.

---

# Conclusión

El Machine Learning no es un proceso aislado.

Forma parte de una arquitectura de datos más amplia.

En esta unidad veremos cómo utilizar Spark MLlib para entrenar modelos predictivos dentro de un pipeline Big Data.
