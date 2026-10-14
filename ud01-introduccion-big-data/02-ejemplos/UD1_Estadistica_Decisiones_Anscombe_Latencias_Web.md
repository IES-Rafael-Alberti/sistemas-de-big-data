# UD1 — Anscombe y tiempos de respuesta de una web

## Todo el material en esta misma carpeta

- [PDF panorámico de la demostración](UD1_Estadistica_Decisiones_Anscombe_Latencias_Web.pdf).
- [Notebook ejecutado](UD1_Estadistica_Decisiones_Anscombe_Latencias_Web.ipynb).
- [Datos de Anscombe — 44 filas](anscombe.csv).
- [Datos de peticiones web — 1.000 filas](latencias_web.csv).
- [Repaso de dos pantallas](UD1_Repaso_Estadistica_Antes_de_Ejemplos.pdf) y su
  [Markdown fuente](UD1_Repaso_Estadistica_Antes_de_Ejemplos.md).

Los CSV **ya están generados**. El notebook los lee: no hace falta descargar datos,
conectarse a una API ni generar nada antes de clase. Copiar la carpeta completa
`02-ejemplos/` para llevarlo a otro equipo.

## 1. Anscombe: recordatorio de lo ya trabajado

Se conserva el cuarteto clásico: cuatro conjuntos con estadísticos casi iguales
y gráficas diferentes. El CSV tiene una fila por par `(x, y)` y una columna
`conjunto` con los nombres I, II, III y IV. Son datos construidos, no medidas del
servidor del segundo ejemplo.

Fuente: F. J. Anscombe (1973), *Graphs in Statistical Analysis*,
[DOI](https://doi.org/10.1080/00031305.1973.10478966), y los valores del
[paquete datasets de R](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/anscombe.html).

## 2. La pregunta que queremos responder

Tenemos la página de inicio de una web, `GET /inicio`. Nos interesa comprobar
este requisito del ejercicio:

> Al menos el **95 % de las peticiones** debe responder en **500 ms o menos**.

500 ms son medio segundo. Con 1.000 peticiones, deberían cumplir al menos 950.
La pregunta no es «¿la media baja de 500 ms?», sino «¿cuántas peticiones cumplen?».

### Qué son los datos y de dónde salen

`latencias_web.csv` representa el fichero que podría producir un script cliente
de monitorización HTTP. **Es una simulación didáctica:** no se ha medido ningún
servidor real ni se han enviado peticiones de red. El generador está en
`preparar_estadistica_web.py`, en esta carpeta.

Cada fila es una petición. La duración mide el tiempo desde el envío hasta recibir
la respuesta completa. No representa una persona, una compra ni una campaña.

| Columna | Significado | Unidad o ejemplo |
|---|---|---|
| `request_id` | Identificador único de la petición. | Entero |
| `instante_peticion` | Inicio de la petición. | Fecha y hora ficticias |
| `metodo` | Método HTTP. | GET |
| `ruta` | Recurso solicitado. | /inicio |
| `estado_http` | Estado de la respuesta recibida. | 200 |
| `duracion_ms` | Tiempo hasta recibir la respuesta completa. | Milisegundos |

Las peticiones pueden solaparse. El orden está barajado con semilla fija para que
no aparezcan primero todas las rápidas y después todas las lentas.

### Una distribución que podemos comprobar a mano

Los tiempos están simplificados a tres valores, intencionadamente:

| Duración | Peticiones | Porcentaje |
|---|---:|---:|
| 100 ms (0,1 s) | 900 | 90 % |
| 1.000 ms (1 s) | 90 | 9 % |
| 10.000 ms (10 s) | 10 | 1 % |
| **Total** | **1.000** | **100 %** |

Todas devuelven HTTP 200. **Terminar correctamente no significa responder rápido.**

La media se comprueba así:

```text
(900 × 100 + 90 × 1.000 + 10 × 10.000) / 1.000 = 280 ms
```

La mediana es 100 ms. Ambos cálculos son correctos, pero solo **900 de 1.000
peticiones** cumplen el límite: **90 %**, por debajo del 95 % exigido. El P95 es
1.000 ms: en esta muestra, al menos el 95 % está en un segundo o menos, no en medio segundo.
Con tiempos repetidos puede haber más del 95 % bajo ese umbral (aquí, el 99 %);
el percentil no exige que haya exactamente un 95 % de observaciones por debajo.

### Qué demuestran las gráficas

- Las barras de duración hacen visible la mayoría rápida y la cola de peticiones
  lentas; muestran recuentos, no una evolución temporal.
- La comparación del porcentaje observado y el objetivo permite comprobar el requisito.
- Borrar las 100 lentas daría un 100 % de cumplimiento entre las 900 conservadas,
  pero ocultaría lo que pasó. No habríamos mejorado la web.

La estadística nos permite elegir la medida que responde a la pregunta. Para
investigar las causas harían falta otros datos: no se puede diagnosticar red,
base de datos o bloqueos únicamente a partir del promedio.

## Trabajo en clase

1. Abrir el CSV y explicar las columnas antes de calcular.
2. Comprobar frecuencias y media; decidir si basta para aceptar el requisito.
3. Contar peticiones bajo el límite y contrastar con las gráficas.
4. Conservar las peticiones lentas y escribir una regla para marcarlas.
5. Aplicar conjuntos y lógica sobre los mismos identificadores, sin cambiar de caso.

## Ejecución y regeneración

El material entregado está preparado. Para **usarlo**, basta abrir los PDF o el
notebook junto a los dos CSV. No instalar nada durante la explicación.

El notebook requiere Python, `numpy`, `pandas` y `matplotlib`, además del entorno
Jupyter/VS Code habitual.

Solo si se modifica el ejemplo y se quiere **regenerar** todo, ejecutar desde esta carpeta:

```bash
python preparar_estadistica_web.py
```

Este comando sobrescribe los dos CSV sintéticos y el notebook generado, ejecuta
el notebook y produce los dos PDF junto a sus fuentes. Requiere Jupyter/nbconvert.
El texto y las celdas del notebook se definen en ese script; los datos sintéticos
se definen en `generar_datos()`.
La maquetación y las gráficas de los PDF se definen en
`generar_pdf_estadistica_proyeccion.py`.

Para comprobar que está todo, sin regenerar ni sobrescribir:

```bash
python preparar_estadistica_web.py --check
```
