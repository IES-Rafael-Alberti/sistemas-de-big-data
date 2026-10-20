# UD1 · Centro y dispersión: dos partes de la misma historia

La media, la mediana y la moda dicen algo sobre el **centro** o el valor más
frecuente de los datos. No dicen, por sí solas, si los valores están muy juntos,
si varían mucho o si una parte importante queda lejos del centro. Para interpretar
un conjunto necesitamos acompañarlas de medidas de **dispersión** y, cuando
tomamos decisiones, mirar también la distribución.

Este apunte amplía la [estadística aplicada para Big Data](UD1_P0_Estadistica_para_BigData.md)
y acompaña el [notebook de extensión de latencias](../../02-ejemplos/UD1_Extension_Latencias_Centro_y_Dispersion.ipynb).
No modifica el material que ya se había distribuido.

## Dos grupos, mismo centro

Imaginemos dos ventanas de diez peticiones de una web. Los tiempos están en
milisegundos y aparecen ordenados:

| Petición | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **A: respuesta estable** | 90 | 95 | 98 | 99 | 100 | 100 | 101 | 102 | 105 | 110 |
| **B: respuesta variable** | 20 | 50 | 80 | 90 | 100 | 100 | 110 | 120 | 150 | 180 |

En ambos grupos:

\[
\text{media} = 100\text{ ms}, \qquad \text{mediana} = 100\text{ ms}
\]

Si solo comunicamos esos dos estadísticos, las ventanas parecen equivalentes.
Pero las peticiones de A se agrupan alrededor de 100 ms; en B hay respuestas
mucho más rápidas y mucho más lentas. **El centro coincide; la experiencia no.**

## Añadimos la dispersión

| Medida | Grupo A | Grupo B | Qué revela |
|---|---:|---:|---|
| Media | 100 ms | 100 ms | El promedio coincide. |
| Mediana | 100 ms | 100 ms | El punto central coincide. |
| Desviación típica muestral | 5,37 ms | 45,70 ms | B tiene mucha más variabilidad alrededor de la media. |
| Rango | 20 ms | 160 ms | B cubre un intervalo mucho más amplio. |
| IQR (Q3 − Q1) | 3,5 ms | 45 ms | También la mitad central de B está mucho más extendida. |
| Peticiones ≤ 110 ms | 10 de 10 (100 %) | 7 de 10 (70 %) | Bajo este umbral, A cumple más a menudo. |

La desviación típica y el rango cuentan aspectos diferentes. El rango depende
solo del mínimo y del máximo; la desviación típica resume la distancia de todos
los datos respecto a la media. El IQR describe la anchura de la mitad central y
suele ser menos sensible a extremos que el rango.

> En este ejemplo se usa la desviación típica **muestral** (divisor \(n-1\)),
> como en `pandas` con `std()` por defecto. El valor numérico cambia si se usa
> la fórmula poblacional (divisor \(n\)); la comparación entre A y B se mantiene.

## ¿Qué aporta cada tipo de medida?

- **Media / mediana / moda:** ¿dónde se concentra el centro o cuál es el valor
  más frecuente?
- **Desviación típica:** ¿cuánto se alejan, en conjunto, los valores de la media?
- **Rango:** ¿qué distancia hay entre los extremos? ¿Hay un extremo que domina
  la lectura?
- **IQR:** ¿qué anchura tiene la zona central de los datos?
- **Percentiles y proporciones bajo un umbral:** ¿qué fracción cumple una
  condición concreta, por ejemplo responder en 500 ms o menos?
- **Gráficos de distribución:** ¿hay asimetría, varios grupos, huecos o extremos
  que un único número no muestra?

Las medidas no son intercambiables ni existe una pareja obligatoria para todas
las preguntas. Elige las que describan el fenómeno y respondan a la decisión que
queremos tomar.

## Conexión con Anscombe y las latencias

El [cuarteto de Anscombe](../../02-ejemplos/UD1_Estadistica_Decisiones_Anscombe_Latencias_Web.ipynb)
lleva la advertencia un paso más allá: los conjuntos tienen estadísticos muy
parecidos —incluidas medidas de centro y dispersión— y, aun así, sus formas y
relaciones son distintas. Por eso, **centro + dispersión ofrecen una fotografía
más completa, pero no sustituyen a mirar la distribución**.

En el ejemplo de latencias, la media de 280 ms no comprueba el requisito de que
el 95 % responda en 500 ms o menos. El porcentaje que cumple responde esa
pregunta; los percentiles, la dispersión y la gráfica ayudan a entender cómo se
reparten los tiempos y cuánto pesa la cola lenta. Ninguna medida aislada
diagnostica por qué la web tarda.

### Regla de lectura

Antes de afirmar que un valor es «típico» o que un sistema «va bien», pregunta:

1. ¿Qué medida de centro estoy comunicando?
2. ¿Cuánta dispersión hay y qué medida la resume mejor?
3. ¿Qué forma tiene la distribución y hay valores o grupos que debo investigar?
4. ¿Qué medida responde exactamente al requisito de negocio?

Una medida de centro sin contexto de dispersión puede ocultar diferencias
importantes. Y unas pocas medidas sin gráfico pueden seguir ocultando la forma
de los datos.
