# UD3 — Cierre del bloque de Computación Distribuida con Spark
## Sistemas de Big Data

---

## 1. Punto de partida: ¿qué problema estamos resolviendo?

En los bloques anteriores del módulo, el alumnado ha trabajado con:

- ingesta de datos,
- integración de fuentes,
- calidad y limpieza,
- anonimización,
- almacenamiento en formatos adecuados.

A partir de este punto surge una pregunta clave:

> ¿Qué ocurre cuando el volumen de datos crece y ya no es viable procesarlos de forma secuencial?

La **computación distribuida** aparece como respuesta a esta necesidad:  
no se trata de programar “más rápido”, sino de **procesar en paralelo** grandes volúmenes de datos de forma eficiente y escalable.

---

## 2. Spark como motor de computación distribuida

Apache Spark se ha utilizado en esta unidad como:

- **motor de procesamiento**,
- **orquestador del paralelismo**,
- **alternativa a herramientas mononodo** como pandas.

Spark permite:

- dividir los datos en particiones,
- distribuir el trabajo entre nodos,
- ejecutar operaciones de forma paralela,
- abstraer la complejidad del reparto de tareas.

El alumnado ha trabajado Spark no como una librería aislada, sino como **parte de un sistema Big Data completo**.

---

## 3. Qué hemos aprendido con los laboratorios

### 3.1 Laboratorio 1 — Spark básico

En este laboratorio se ha introducido:

- el modelo **Master / Worker**,
- la ejecución de jobs con `spark-submit`,
- la diferencia entre ejecución local y distribuida.

Objetivo clave:
> Entender que Spark no es “otra librería de Python”, sino un **motor distribuido**.

---

### 3.2 Laboratorio 2 — Spark frente a pandas

Este laboratorio ha permitido:

- comparar un enfoque secuencial (pandas) con uno distribuido (Spark),
- observar el impacto del volumen de datos,
- identificar el punto en el que pandas deja de ser cómodo o viable.

Conclusión esencial:
> Spark no es siempre mejor, pero **es imprescindible cuando el volumen lo exige**.

---

### 3.3 Laboratorio 3 — Parquet y particionado

Aquí se ha trabajado la relación entre:

- **procesamiento** y **almacenamiento**,
- formato Parquet como optimización clave,
- particionado como herramienta para reducir costes de lectura.

Idea fundamental:
> En Big Data, **cómo se almacenan los datos** es tan importante como **cómo se procesan**.

---

### 3.4 Laboratorio 4 — Zeppelin y Spark interactivo

Con Zeppelin se ha introducido:

- análisis interactivo sobre Spark,
- exploración y validación de datos,
- visualización directa sin perder el motor distribuido.

Se ha reforzado la idea de que:

- los scripts Spark son adecuados para procesos productivos,
- los notebooks (Zeppelin) son ideales para análisis y exploración.

---

## 4. Ideas clave que deben quedar claras

Tras este bloque, el alumnado debería tener interiorizado que:

- Spark **no sustituye** a pandas, lo complementa.
- El paralelismo no es gratuito: tiene coste y complejidad.
- El formato de los datos influye directamente en el rendimiento.
- Las herramientas se eligen **según el problema**, no por moda.
- Big Data no es solo volumen, sino **arquitectura y decisiones técnicas**.

---

## 5. Relación con el flujo completo de Big Data

Hasta ahora, el flujo trabajado ha sido:

1. Ingesta de datos  
2. Integración de fuentes  
3. Calidad y limpieza  
4. Almacenamiento optimizado  
5. **Procesamiento distribuido (Spark)**  

El siguiente paso natural es:

> **explotar los resultados**, analizarlos y visualizarlos.

Aquí es donde entran las herramientas de **consulta y visualización**, como Kibana.

---

## 6. Transición hacia la visualización (Kibana)

Spark se ha utilizado para:

- preparar los datos,
- transformarlos,
- agregarlos,
- dejarlos listos para su explotación.

En los siguientes laboratorios:

- los datos ya no se procesarán principalmente,
- se **consultarán, analizarán y visualizarán**,
- se trabajará con dashboards y cuadros de mando.

Spark **no desaparece**, pero pasa a un segundo plano como motor de backend.

---

## 7. Mensaje final al alumnado

> En Big Data, ninguna herramienta trabaja sola.  
> Spark procesa, los formatos optimizan,  
> y las herramientas de visualización permiten **tomar decisiones**.

Comprender **cuándo y por qué usar cada pieza** es más importante que dominar una sola tecnología.

---

## 8. Cierre del bloque

Con este bloque se cierra la parte de **computación distribuida de la UD3**.  
A partir de ahora, el foco se desplaza de *cómo procesar* a *cómo interpretar y comunicar* los datos.

**Siguiente bloque:**  
👉 Visualización y análisis con **Kibana**.


---

