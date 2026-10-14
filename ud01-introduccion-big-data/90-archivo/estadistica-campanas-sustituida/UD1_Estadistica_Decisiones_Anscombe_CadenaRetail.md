# Archivo — primera demostración con campañas, sustituida

[Descargar el notebook con datos, tablas y gráficas](UD1_Estadistica_Decisiones_Anscombe_CadenaRetail.ipynb).

Demostración de 35–50 minutos para ver por qué un sistema de datos necesita
estadística e interpretación, además de código correcto. Acompaña la
[estadística aplicada](../01-teoria/00-estadistica-y-base-matematica/UD1_P0_Estadistica_para_BigData.md)
y sirve como entrada al trabajo de EDA.

## Dos decisiones que cambian al explorar

| Caso | Primera impresión | Qué descubrimos | Aplicación técnica |
|---|---|---|---|
| Cuarteto de Anscombe | Las medias, varianzas, correlaciones y rectas son casi iguales. | Las gráficas muestran relación lineal, curvatura, un punto influyente y falta de cobertura. | No decidir un modelo ni una interpretación solo con un resumen; revisar scatter y sensibilidad. |
| Campañas de CadenaRetail | A convierte un 74 % y B un 31 %: B parece peor. | B mejora en cada segmento; el resultado global baja porque cambia la mezcla de visitas. | Publicar denominadores y composición, conservar detalle y comprobar comparabilidad. |

El primer caso utiliza los datos construidos clásicos de Anscombe. El segundo
usa **2.000 visitas sintéticas**, con semilla fija y sin datos personales. No se
presentan como datos reales de una empresa ni como prueba causal del efecto de
una campaña.

## Cómo usarlo en clase

Si el alumnado ya conoce las medidas pero aún no las ha usado, empezar con las
[dos pantallas de repaso](UD1_Repaso_Estadistica_Antes_de_Ejemplos.md), durante
unos ocho minutos, y dedicar el resto a decidir e interpretar los ejemplos.

1. Mostrar los resúmenes de Anscombe y pedir una hipótesis antes de las gráficas.
2. Mostrar los cuatro scatter plots con la misma escala y discutir qué cambia.
3. Comparar la conversión global de A y B; pedir una decisión antes de segmentar.
4. Mostrar tasas por segmento, mezcla de visitas y media ponderada.
5. Cerrar con una decisión sobre el pipeline: qué detalle conservar, qué indicadores
   acompañar y qué límites explicitar.

No hace falta introducir entrenamiento de modelos ni demostraciones matemáticas.
La recta es un ajuste descriptivo para contrastar lo que oculta el resumen.

## Ejecución

- Abrir el `.ipynb` en Jupyter, VS Code con soporte de notebooks o Colab.
- Dependencias: `numpy`, `pandas`, `matplotlib`.
- Ejecutar de arriba abajo. Los datos están incluidos; no necesita descargas.
- El notebook incluye tablas, gráficas, pausas para decidir y preguntas de cierre.

## Fuente de Anscombe

F. J. Anscombe (1973), *Graphs in Statistical Analysis*, **The American Statistician**,
27(1), 17–21. [DOI](https://doi.org/10.1080/00031305.1973.10478966).
Los valores están documentados en el [paquete datasets de R](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/anscombe.html).
