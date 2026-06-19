---
title: "UD3 — Procesamiento Distribuido y Analítica Escalable"
author: "José Manuel Sánchez Álvarez"
institution: "IES Rafael Alberti"
course: "Sistemas de Big Data · 2025–2026"
revealjs-theme: simple
revealjs-transition: slide
---

## UD3 — Procesamiento Distribuido  
### y Analítica Escalable en Big Data

---

## ¿Dónde estamos ahora?

Hasta este momento hemos trabajado en:

- Ingesta de datos
- Integración de fuentes
- Limpieza y calidad
- Anonimización (RGPD)
- Almacenamiento en un destino común

👉 **Los datos ya están preparados**

---

## Cambio de problema

Antes el problema era:

> “¿Cómo consigo los datos?”

Ahora el problema es:

> **“¿Cómo los proceso cuando el volumen crece?”**

Esto marca el inicio real del **Big Data operativo**

---

## Recordatorio: enfoque clásico

Hemos trabajado principalmente con:

- Python
- pandas
- CSV / ficheros locales

Y eso está **bien**… hasta cierto punto.

---

## ¿Qué hace bien pandas?

- Análisis exploratorio (EDA)
- Limpieza compleja
- Transformaciones flexibles
- Datasets pequeños o medianos

👉 pandas **no es el problema**

---

## ¿Dónde empiezan los límites?

Cuando el volumen crece:

- Todo va a memoria (RAM)
- Procesamiento secuencial
- Tiempos cada vez mayores
- No escala con más datos

---

## Ejemplo conceptual

- 10 MB → sin problema  
- 5 GB → lento / inestable  
- 200 GB → imposible en local  

👉 Aquí **no falla el código**,  
falla el **modelo de procesamiento**

---

## No basta con “optimizar”

Cuando el volumen es grande:

- No basta con mejores algoritmos
- No basta con más RAM
- No basta con “hacerlo más rápido”

Hay que **cambiar el paradigma**

---

## Nuevo paradigma

Pasamos de:

- Un programa
- Un proceso
- Una máquina

A:

- Muchos procesos
- En paralelo
- Repartidos en varios núcleos o nodos

---

## Procesamiento distribuido

La idea clave es sencilla:

> **Dividir los datos y procesarlos a la vez**

Cada parte trabaja en paralelo  
y luego se combinan los resultados

---

## Aquí entra Apache Spark

Apache Spark es:

- Un motor de procesamiento distribuido
- Diseñado para grandes volúmenes
- Capaz de ejecutarse:
  - en local
  - en un clúster
  - en la nube

---

## Spark no sustituye a pandas

Spark responde a **otro problema**

| pandas | Spark |
|------|------|
| RAM local | Memoria distribuida |
| Secuencial | Paralelo |
| Dataset pequeño | Dataset grande |
| Exploración | Procesamiento masivo |

---

## ¿Qué cambia para el programador?

Muchas operaciones son familiares:

- Leer datos
- Filtrar
- Agrupar
- Calcular métricas

Pero:

- Los datos están repartidos
- Spark decide **cómo** ejecutar en paralelo

---

## Tú defines el *qué*

Spark se encarga del *cómo*:

- Planificación
- Paralelización
- Reparto de carga
- Ejecución eficiente

---

## ¿Qué vamos a hacer en la UD3?

Partimos de:

- Datos ya integrados
- Datos ya anonimizados
- Datos ya almacenados

Ahora vamos a:

- Procesarlos en paralelo
- Calcular métricas a gran escala
- Prepararlos para visualización
- Dejarlos listos para automatización

---

## Flujo de trabajo

1. Datos preparados (UD2)  
2. Procesamiento distribuido (Spark)  
3. Resultados agregados  
4. Visualización (Kibana)  
5. Automatización (Airflow, más adelante)

---

## Spark vs pandas en la práctica

Veremos:

- La **misma lógica**
- Las **mismas operaciones**
- Pero con un enfoque escalable

La pregunta clave será:

> **¿Cuándo merece la pena usar Spark?**

---

## Otras herramientas en juego

---

## Zeppelin (opcional)

- Entorno interactivo para Spark
- Similar a un notebook
- Permite ver el procesamiento distribuido en acción

No es obligatorio, pero ayuda a entender qué ocurre

---

## Kibana

- No procesa grandes volúmenes
- Visualiza resultados ya calculados
- Dashboards, gráficas, exploración

👉 Separación clara de responsabilidades

---

## Y después… Airflow

Spark será una pieza más de un pipeline mayor:

- Ingesta
- Procesamiento
- Almacenamiento
- Visualización

Airflow se encargará de **orquestar**

---

## Objetivo real de la UD3

No buscamos:

- Memorizar APIs
- Montar clústeres complejos

Buscamos que sepáis:

- Cuándo usar procesamiento distribuido
- Qué aporta Spark
- Cómo encaja en un sistema Big Data real

---

## Resumen

- Los datos ya están listos
- Ahora toca **escalar el procesamiento**
- Spark amplía lo que ya sabemos
- No sustituye, **complementa**

---

## Siguiente paso

👉 Primer laboratorio con Spark  
Mismo tipo de datos  
Nueva forma de procesarlos