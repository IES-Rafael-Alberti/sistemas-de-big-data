# UD1 · Parte 0 — Cuestionario: estadística aplicada y cápsula normativa

## Objetivo

Evaluar que el alumnado entiende la base matemática útil para trabajar con datos en Sistemas de Big Data.

Este cuestionario cubre:

- estadística aplicada,
- interpretación de gráficos,
- calidad de datos,
- correlación y colinealidad,
- nociones mínimas de matemática discreta,
- lógica algorítmica,
- complejidad computacional básica.

## Relación curricular

Principalmente relacionado con:

- **RA1/CE1.a**: conceptos básicos de matemática discreta, lógica algorítmica y complejidad computacional aplicados al tratamiento automático de información.
- **RA1/CE1.b**: extracción automática de información y conocimiento.
- **RA1/CE1.c-d**: combinación de fuentes y construcción de datasets complejos.
- **RA3/CE3.d**: gestión, almacenamiento y procesamiento eficiente y seguro.

## Formato sugerido

- Modalidad: cuestionario individual.
- Duración orientativa: 30-40 minutos.
- Puntuación: 10 puntos.
- Puede usarse en Moodle o como actividad escrita.

## Preguntas tipo test

Cada pregunta vale 0,5 puntos.

### 1. ¿Qué medida es más robusta que la media cuando hay outliers?

- a) La varianza.
- b) La mediana.
- c) El máximo.
- d) El rango.

Respuesta correcta: **b**

### 2. ¿Qué gráfico usarías para detectar la distribución de una variable numérica?

- a) Histograma.
- b) Diagrama de Gantt.
- c) Mapa conceptual.
- d) Tabla de permisos.

Respuesta correcta: **a**

### 3. Un scatter plot sirve principalmente para...

- a) Comparar dos variables numéricas.
- b) Ver permisos de usuario.
- c) Ordenar carpetas.
- d) Crear claves primarias.

Respuesta correcta: **a**

### 4. Una correlación cercana a 1 indica...

- a) Ausencia total de relación.
- b) Relación positiva fuerte.
- c) Relación negativa fuerte.
- d) Que una variable causa necesariamente la otra.

Respuesta correcta: **b**

### 5. ¿Qué afirmación es correcta?

- a) Correlación implica causalidad.
- b) Correlación nunca sirve para nada.
- c) Correlación puede sugerir relación, pero no demuestra causalidad.
- d) Correlación sólo se usa con variables categóricas.

Respuesta correcta: **c**

### 6. La colinealidad aparece cuando...

- a) Dos variables contienen información muy parecida.
- b) Un dataset no tiene columnas.
- c) Un gráfico tiene muchos colores.
- d) Un servidor está caído.

Respuesta correcta: **a**

### 7. ¿Qué dimensión de calidad se relaciona con datos faltantes?

- a) Completitud.
- b) Unicidad.
- c) Latencia.
- d) Compresión.

Respuesta correcta: **a**

### 8. En matemática discreta, una intersección de conjuntos puede servir para...

- a) Detectar elementos comunes entre dos fuentes de datos.
- b) Borrar una base de datos.
- c) Medir temperatura.
- d) Crear un histograma.

Respuesta correcta: **a**

### 9. Una regla lógica de limpieza sería...

- a) Si edad < 0, marcar registro como inválido.
- b) Dibujar un gráfico circular.
- c) Instalar un sistema operativo.
- d) Cambiar el color de un dashboard.

Respuesta correcta: **a**

### 10. Una operación O(n²) suele ser problemática en Big Data porque...

- a) Requiere comparar muchos elementos entre sí y escala mal.
- b) Siempre es la más rápida.
- c) Sólo funciona con texto.
- d) No consume memoria.

Respuesta correcta: **a**

## Preguntas de respuesta corta

Cada pregunta vale 1 punto.

### 11. Explica por qué no se deben borrar outliers automáticamente.

Respuesta esperada:

El alumnado debe indicar que un outlier puede ser error, caso raro real, fraude, evento especial o señal relevante. Debe revisarse, justificarse y documentarse antes de decidir.

### 12. Observas una correlación alta entre dos variables. ¿Qué comprobación harías antes de sacar conclusiones?

Respuesta esperada:

Debe mencionar que correlación no implica causalidad, revisar posible variable externa, ver scatter plot, contexto del problema, calidad de datos y si la relación tiene sentido.

### 13. Pon un ejemplo de colinealidad en un dataset.

Respuesta esperada:

Ejemplos válidos: precio con IVA/precio sin IVA/IVA; peso en kg/peso en gramos; fecha de nacimiento/edad; total/unidades/precio unitario.

### 14. Explica con tus palabras por qué la complejidad computacional importa en Big Data.

Respuesta esperada:

Debe explicar que al crecer el volumen de datos, algoritmos o procesos que funcionan en pequeño pueden volverse lentos o inviables. Debe mencionar escalabilidad, coste o rendimiento.

### 15. ¿Cómo usarías conjuntos o relaciones al combinar dos fuentes de datos?

Respuesta esperada:

Puede hablar de unión, intersección, diferencia, claves comunes, joins, registros que aparecen en una fuente y no en otra, o relaciones entre entidades.

## Pregunta práctica

Vale 2 puntos.

### 16. Caso práctico

Tienes un dataset de ventas con estas columnas:

- `id_venta`
- `fecha`
- `cliente_id`
- `producto`
- `unidades`
- `precio_unitario`
- `precio_total`
- `ciudad`

Responde:

1. Indica dos variables numéricas y dos categóricas.
2. Indica una regla lógica de validación.
3. Indica una posible relación o colinealidad.
4. Indica un gráfico útil y qué mirarías en él.

### Criterios de corrección

| Criterio | Puntos |
| -------- | ------ |
| Identifica correctamente tipos de variables | 0,5 |
| Propone una regla lógica válida | 0,5 |
| Detecta una relación/colinealidad razonable | 0,5 |
| Propone gráfico útil e interpretación | 0,5 |

Ejemplos de respuesta válida:

- Numéricas: `unidades`, `precio_unitario`, `precio_total`.
- Categóricas: `producto`, `ciudad`, `cliente_id`.
- Regla: `precio_total = unidades * precio_unitario`; `unidades > 0`; `fecha no vacía`.
- Colinealidad: `precio_total`, `unidades` y `precio_unitario` están relacionados.
- Gráfico: scatter `unidades` vs `precio_total`; histograma de `precio_total`; barras por `producto` o `ciudad`.

## Rúbrica global

| Nivel | Descripción |
| ----- | ----------- |
| Excelente | Interpreta datos, gráficos y reglas con justificación técnica clara. |
| Adecuado | Responde correctamente a la mayoría y entiende los conceptos básicos. |
| Básico | Reconoce algunos conceptos, pero le cuesta justificar decisiones. |
| Insuficiente | Confunde conceptos clave o responde de forma memorística sin aplicación. |
