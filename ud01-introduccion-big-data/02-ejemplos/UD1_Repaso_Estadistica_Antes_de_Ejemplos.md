# UD1 — Repaso rápido antes de los ejemplos

Dos pantallas para proyectar antes del [notebook de Anscombe y latencias web](UD1_Estadistica_Decisiones_Anscombe_Latencias_Web.ipynb).
El [PDF de estas dos pantallas](UD1_Repaso_Estadistica_Antes_de_Ejemplos.pdf) está en esta misma carpeta.

## Pantalla 1 — ¿Qué cuenta cada medida?

| Medida | Qué muestra | Qué conviene recordar |
|---|---|---|
| Media | Promedio de los valores. | Todos los valores influyen; un extremo puede arrastrarla. |
| Mediana | Valor central de los datos ordenados. | Es más resistente a extremos; no muestra toda la distribución. |
| Rango | Máximo menos mínimo. | Depende de los dos extremos. |
| Cuartiles | Q1: 25 %, Q2: 50 %, Q3: 75 %. | Q2 es la mediana; permiten situar la zona central. |
| Varianza | Dispersión respecto a la media, usando diferencias al cuadrado. | Se expresa en unidades al cuadrado. |
| Desviación típica | Raíz de la varianza. | Recupera las unidades originales; también es sensible a extremos. |

**La media no está “mal”: puede ser insuficiente para describir lo habitual.**
Hay que acompañarla de otras medidas, gráficas y contexto.

Pregunta: **¿conocer el promedio basta para saber qué ocurre en los datos?**

---

## Pantalla 2 — IQR: detectar no significa borrar

El rango intercuartílico es la amplitud del 50 % central:

```text
IQR = Q3 − Q1
Límite inferior = Q1 − 1,5 × IQR
Límite superior = Q3 + 1,5 × IQR
```

Se señala como valor atípico lo que cae por debajo del límite inferior o por
encima del superior. Los límites se calculan desde Q1 y Q3, no desde la media.

```text
detectar → investigar → decidir → documentar
```

- ¿Hay un error de captura o de unidades?
- ¿Es un caso real poco frecuente?
- ¿Qué cambia en el análisis si se conserva o se retira?

**Ahora vamos a poner a prueba nuestras conclusiones:**
primero mirar una tabla; después descubrir lo que oculta con gráficas y medidas adecuadas a la pregunta.
