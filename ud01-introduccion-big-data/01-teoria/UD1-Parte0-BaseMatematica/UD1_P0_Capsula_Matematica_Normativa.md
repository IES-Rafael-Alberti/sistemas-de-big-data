# UD1 · Parte 0 — Cápsula normativa: matemática discreta, lógica algorítmica y complejidad

## Por qué existe esta cápsula

El RA1/CE1.a de **Sistemas de Big Data** menciona:

> conceptos básicos de matemática discreta, lógica algorítmica y complejidad computacional, y su aplicación para el tratamiento automático de la información por medio de sistemas computacionales.

En este módulo no vamos a estudiar matemática discreta como asignatura teórica. La trabajaremos sólo en lo que aporta valor para entender sistemas Big Data.

La base principal del curso será estadística aplicada, calidad de datos e interpretación de datos. Esta cápsula sirve para cubrir la parte normativa mínima de forma útil.

## 1. Matemática discreta útil en Big Data

La matemática discreta trabaja con elementos separados o contables.

En Big Data aparece en:

- conjuntos,
- relaciones,
- grafos,
- conteos,
- combinaciones,
- claves,
- identificadores,
- estructuras de datos.

### Conjuntos

Un conjunto es una colección de elementos.

Ejemplo:

- conjunto de clientes,
- conjunto de productos,
- conjunto de eventos,
- conjunto de registros válidos,
- conjunto de registros duplicados.

Operaciones útiles:

| Operación | Uso en datos |
| --------- | ------------ |
| Unión | combinar fuentes |
| Intersección | encontrar coincidencias entre datasets |
| Diferencia | detectar registros que faltan en una fuente |
| Pertenencia | comprobar si un valor está permitido |

### Relaciones

Una relación conecta elementos.

Ejemplos:

- cliente compra producto,
- usuario genera evento,
- pedido contiene líneas,
- ciudad pertenece a provincia.

Esto ayuda a entender datasets relacionales, joins y modelos de datos.

### Grafos

Un grafo conecta nodos mediante aristas.

Ejemplos:

- usuarios conectados en una red social,
- rutas de transporte,
- dependencias entre tareas,
- relaciones entre entidades.

No hace falta profundizar en teoría de grafos, pero sí entender que muchos problemas Big Data son problemas de relaciones.

## 2. Lógica algorítmica

La lógica algorítmica consiste en expresar reglas de decisión de forma clara.

En datos aparece constantemente:

- filtros,
- condiciones,
- validaciones,
- reglas de limpieza,
- transformaciones,
- pipelines.

Ejemplo:

```text
SI edad < 0 ENTONCES dato inválido
SI email está vacío ENTONCES registro incompleto
SI precio_total != unidades * precio_unitario ENTONCES inconsistencia
```

En Big Data, estas reglas deben ser reproducibles y automatizables.

## 3. Complejidad computacional básica

La complejidad computacional estudia cómo crece el coste de un algoritmo cuando aumenta el tamaño de los datos.

No vamos a hacer teoría avanzada. Necesitamos entender una idea:

> Una solución que funciona con 1.000 filas puede no funcionar con 100 millones.

### Órdenes de crecimiento básicos

| Notación | Idea | Ejemplo intuitivo |
| -------- | ---- | ----------------- |
| O(1) | coste constante | acceder a un elemento por clave |
| O(n) | crece linealmente | recorrer todos los registros |
| O(n log n) | crece más que lineal | ordenar datos eficientemente |
| O(n²) | crece cuadráticamente | comparar todos contra todos |

En Big Data, evitar O(n²) suele ser crítico.

## 4. Relación con sistemas Big Data

Estas ideas ayudan a entender:

- por qué importan los índices,
- por qué se particionan datos,
- por qué se distribuye el procesamiento,
- por qué algunos joins son caros,
- por qué se usan formatos columnares como Parquet,
- por qué Spark reparte trabajo,
- por qué hay que medir coste y calidad.

## 5. Qué entra y qué no entra

### Sí entra

- conjuntos aplicados a fuentes de datos,
- relaciones aplicadas a joins/modelado,
- grafos como idea para datos conectados,
- reglas lógicas de limpieza,
- complejidad básica para razonar sobre escalabilidad.

### No entra

- demostraciones formales,
- teoría profunda de grafos,
- álgebra discreta avanzada,
- cálculo de complejidad complejo,
- matemática desconectada de datos reales.

## 6. Idea clave

La parte normativa se cubre de forma aplicada:

- conjuntos para combinar datos,
- relaciones para modelar datos,
- lógica para limpiar y validar,
- complejidad para entender escalabilidad.

Lo importante es que el alumnado pueda justificar decisiones técnicas en sistemas Big Data.
