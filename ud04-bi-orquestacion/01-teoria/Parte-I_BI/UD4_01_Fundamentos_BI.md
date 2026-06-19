# UD4 - Documento 01
## Fundamentos de Business Intelligence y cuadros de mando

---

## 1. Qué es Business Intelligence

Business Intelligence, o BI, es el conjunto de procesos, tecnologías y prácticas orientadas a transformar datos en información útil para la toma de decisiones.

No se trata solo de visualizar datos, sino de responder preguntas de negocio como:

- ¿Están aumentando las ventas?
- ¿Qué productos generan mayor margen?
- ¿Qué clientes aportan más valor?
- ¿Qué tendencia se observa en el último trimestre?

El objetivo de BI no es almacenar datos ni procesarlos más rápido, sino interpretarlos de forma estructurada para apoyar decisiones.

---

## 2. De los datos a la decisión

En un sistema Big Data completo existen varias fases:

1. Ingesta de datos.
2. Limpieza y calidad.
3. Procesamiento.
4. Análisis.
5. Visualización.
6. Decisión.

La UD4 se centra principalmente en las dos últimas fases:

- visualización orientada a negocio,
- interpretación para toma de decisiones.

Sin interpretación, un dashboard es solo una pantalla con gráficos.

---

## 3. Dashboard técnico vs cuadro de mando de negocio

Es importante diferenciar claramente estos conceptos.

### Dashboard técnico

Responde a preguntas como:

- ¿Hay errores en el sistema?
- ¿Cuánta memoria se está utilizando?
- ¿Hay picos anormales de carga?

Se centra en el funcionamiento del sistema.

Ejemplos de herramientas: Grafana, Kibana técnico.

---

### Cuadro de mando de negocio

Responde a preguntas como:

- ¿Cómo evolucionan las ventas?
- ¿Qué línea de producto es más rentable?
- ¿Qué segmento de clientes crece más rápido?

Se centra en el rendimiento del negocio.

Ejemplos de herramientas: Metabase, Superset, Power BI.

---

## 4. KPI, métricas y dimensiones

En BI se utilizan conceptos fundamentales que deben comprenderse con claridad.

### 4.1 Métrica

Una métrica es un valor numérico que mide algo.

Ejemplos:

- número de ventas
- ingresos totales
- número de clientes activos

---

### 4.2 KPI (Key Performance Indicator)

Un KPI es una métrica considerada estratégica para evaluar el rendimiento.

No todas las métricas son KPI.

Ejemplo:

- Ingresos mensuales puede ser un KPI.
- Número total de registros en base de datos probablemente no.

Un KPI debe:

- estar alineado con un objetivo,
- ser medible,
- permitir comparación en el tiempo.

---

### 4.3 Dimensión

Una dimensión es el eje desde el que se analiza una métrica.

Ejemplos:

- tiempo
- producto
- cliente
- región

Ejemplo práctico:

Métrica: ingresos
Dimensión: mes

---

### 4.4 Granularidad

La granularidad define el nivel de detalle del dato.

Ejemplos:

- ventas por día
- ventas por mes
- ventas por año

Cambiar la granularidad cambia la interpretación.

---

## 5. Tipos de analítica

En BI es habitual clasificar la analítica en cuatro niveles.

### 5.1 Analítica descriptiva

Responde a la pregunta:

¿Qué ha pasado?

Ejemplo:

- ventas del último trimestre.

---

### 5.2 Analítica diagnóstica

Responde a la pregunta:

¿Por qué ha pasado?

Ejemplo:

- bajaron las ventas porque disminuyeron las compras en una región concreta.

---

### 5.3 Analítica predictiva

Responde a la pregunta:

¿Qué podría pasar?

Ejemplo:

- previsión de ventas para el próximo mes.

Este tipo de analítica se trabajará principalmente en la UD5 con Spark MLlib.

---

### 5.4 Analítica prescriptiva

Responde a la pregunta:

¿Qué deberíamos hacer?

Ejemplo:

- ajustar precios o reforzar una campaña de marketing.

---

## 6. Ciclo de vida de un cuadro de mando

Un cuadro de mando no es un conjunto de gráficos al azar.

Debe seguir un proceso estructurado:

1. Identificar preguntas de negocio.
2. Definir KPI adecuados.
3. Preparar y validar los datos.
4. Diseñar visualizaciones coherentes.
5. Validar con el usuario.
6. Iterar y mejorar.

En entornos reales, este proceso es continuo.

---

## 7. Errores frecuentes en BI

Algunos errores habituales:

- confundir muchas métricas con información relevante,
- usar gráficos incorrectos para los datos,
- no definir claramente los KPI,
- no contextualizar las cifras,
- no explicar la interpretación.

Un buen cuadro de mando debe ser claro y responder preguntas concretas.

---

## 8. Conexión con el resto del módulo

Lo trabajado en UD3 permite:

- procesar grandes volúmenes de datos,
- limpiar y estructurar información,
- preparar datasets coherentes.

La UD4 utiliza esos datos preparados para:

- construir cuadros de mando,
- interpretar resultados,
- preparar el terreno para analítica predictiva en la UD5.

---

## 9. Conclusiones

Business Intelligence no consiste en hacer gráficos bonitos.

Consiste en transformar datos en decisiones.

Un cuadro de mando bien diseñado:

- simplifica la información,
- destaca lo relevante,
- permite actuar.

La UD4 se centrará en desarrollar esta capacidad.

---

## Fin del documento

# Resumen de Inicio de Clase: Introducción a Business Intelligence (UD4)

## 1. Contexto y Cambio de Enfoque (UD4_00)
*   **De dónde venimos (UD3):** Hasta ahora hemos trabajado con un enfoque técnico: procesamiento distribuido (Spark), logs (Kibana) y observabilidad de sistemas (Grafana). La pregunta era *"¿Cómo funciona el sistema?"*.
*   **A dónde vamos (UD4):** Cambiamos el foco hacia el **negocio**. El objetivo ya no es solo monitorear servidores, sino **tomar decisiones estratégicas**. La pregunta clave ahora es *"¿Qué decisiones podemos tomar con estos datos?"*.
*   **Herramientas:** Dejamos la pila ELK/Grafana por herramientas de BI como **Metabase** (principal), **Superset** (avanzado) y opcionalmente Power BI.
*   **El camino:** Esta unidad es el puente hacia la Analítica Predictiva (UD5) y el Proyecto Integrador (UD6).

## 2. Fundamentos de Business Intelligence (UD4_01)
*   **Definición:** El BI no es "hacer gráficos bonitos", es el proceso de transformar datos en información útil para decidir.
*   **Diferencia Clave:**
    *   **Dashboard Técnico:** ¿Hay errores? ¿Cuánta CPU se usa? (Para administradores).
    *   **Cuadro de Mando de Negocio:** ¿Vendemos más? ¿Qué producto es más rentable? (Para directivos/analistas).
*   **Conceptos Vocabulario:**
    *   **Métrica:** Un dato numérico (ej. *número de ventas*).
    *   **KPI (Key Performance Indicator):** Una métrica estratégica alineada con un objetivo (ej. *% de crecimiento mensual*). No todas las métricas son KPIs.
    *   **Dimensión:** El "eje" desde donde miramos el dato (ej. *tiempo, región, categoría de producto*).
    *   **Granularidad:** El nivel de detalle del dato (día, mes, año).
*   **Niveles de Analítica:**
    1.  **Descriptiva:** ¿Qué ha pasado? (Foco de esta unidad).
    2.  **Diagnóstica:** ¿Por qué ha pasado?
    3.  **Predictiva:** ¿Qué pasará? (UD5).
    4.  **Prescriptiva:** ¿Qué debemos hacer?

## 3. Modelado de Datos para BI (UD4_02)
*   **OLTP vs OLAP:**
    *   **Operacional (OLTP):** Escritura rápida, tiempo real, gestión del día a día (ej. crear un pedido).
    *   **Analítico (OLAP):** Lectura masiva, agregaciones, análisis de tendencias.
*   **El Modelo Estrella:** Estructura estándar para BI que simplifica las consultas:
    *   **Tabla de Hechos:** Contiene los números (métricas) y claves ajenas (ej. *Tabla Ventas*: cantidad, importe, id_cliente).
    *   **Tablas de Dimensiones:** Contienen las descripciones (ej. *Tabla Clientes*: nombre, ciudad, edad).
*   **Importancia:** Un mal modelado (datos sucios, duplicados o mal relacionados) lleva a conclusiones erróneas, aunque el gráfico se vea bien. Las herramientas de BI (Metabase/Superset) funcionan mucho mejor si separamos claramente hechos de dimensiones.