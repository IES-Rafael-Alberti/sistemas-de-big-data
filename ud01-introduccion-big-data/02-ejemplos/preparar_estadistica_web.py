"""Generar CSV, notebook ejecutado y PDF de la demostración estadística UD1.

python preparar_estadistica_web.py          # regenerar el material completo
python preparar_estadistica_web.py --check  # comprobar archivos, sin modificarlos

Las rutas se resuelven junto a este script, no según el directorio de ejecución.
La regeneración requiere numpy, pandas, matplotlib y Jupyter/nbconvert.
"""

import argparse
import json
from pathlib import Path
import subprocess
import sys

import numpy as np
import pandas as pd


BASE = Path(__file__).resolve().parent
NOMBRE = "UD1_Estadistica_Decisiones_Anscombe_Latencias_Web"


def generar_datos():
    x = [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5]
    series = {
        "I": (x, [8.04, 6.95, 7.58, 8.81, 8.33, 9.96, 7.24, 4.26, 10.84, 4.82, 5.68]),
        "II": (x, [9.14, 8.14, 8.74, 8.77, 9.26, 8.10, 6.13, 3.10, 9.13, 7.26, 4.74]),
        "III": (x, [7.46, 6.77, 12.74, 7.11, 7.81, 8.84, 6.08, 5.39, 8.15, 6.42, 5.73]),
        "IV": ([8, 8, 8, 8, 8, 8, 8, 19, 8, 8, 8], [6.58, 5.76, 7.71, 8.84, 8.47, 7.04, 5.25, 12.50, 5.56, 7.91, 6.89]),
    }
    anscombe = pd.concat([
        pd.DataFrame({"conjunto": nombre, "x": xs, "y": ys})
        for nombre, (xs, ys) in series.items()
    ], ignore_index=True)
    anscombe.to_csv(BASE / "anscombe.csv", index=False, encoding="utf-8")

    # Valores repetidos a propósito: el alumnado puede comprobar las cuentas.
    duraciones = np.random.default_rng(42).permutation([100] * 900 + [1000] * 90 + [10000] * 10)
    latencias = pd.DataFrame({
        "request_id": np.arange(1, 1001),
        "instante_peticion": pd.date_range("2026-10-15 09:00:00", periods=1000, freq="s").strftime("%Y-%m-%dT%H:%M:%S"),
        "metodo": "GET",
        "ruta": "/inicio",
        "estado_http": 200,
        "duracion_ms": duraciones,
    })
    latencias.to_csv(BASE / "latencias_web.csv", index=False, encoding="utf-8")


def generar_notebook():
    celdas = []

    def md(identificador, texto):
        celdas.append({"cell_type": "markdown", "id": identificador, "metadata": {},
                       "source": texto.strip().splitlines(keepends=True)})

    def code(identificador, texto):
        celdas.append({"cell_type": "code", "id": identificador, "metadata": {},
                       "execution_count": None, "outputs": [],
                       "source": texto.strip().splitlines(keepends=True)})

    md("inicio", """
# UD1 — Anscombe y tiempos de respuesta de una web

**Pregunta del segundo ejemplo:** ¿una media de 280 ms demuestra que el 95 % de
las peticiones responde en 500 ms o menos?

Primero recordamos Anscombe, que ya se ha trabajado. Después usamos un único
servidor, una única ruta y un único fichero de peticiones. No comparamos campañas
ni necesitamos clasificar personas.

## Archivos que debes tener en esta misma carpeta

- `anscombe.csv`: 44 pares de valores de los cuatro conjuntos clásicos.
- `latencias_web.csv`: 1.000 peticiones HTTP sintéticas, ya generadas.
- Este notebook y la guía Markdown homónima.

Los datos **son archivos CSV**, no se descargan y no se generan ocultamente al
abrir el notebook. Copia la carpeta completa. Ejecuta de arriba abajo.
""")
    code("entorno", """
from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from IPython.display import display

%matplotlib inline
candidatos = [Path.cwd(), Path.cwd() / 'ud01-introduccion-big-data' / '02-ejemplos']
if '__file__' in globals():
    candidatos.insert(0, Path(__file__).resolve().parent)
BASE = next((p for p in candidatos if (p / 'anscombe.csv').is_file()
             and (p / 'latencias_web.csv').is_file()), None)
if BASE is None:
    raise FileNotFoundError('Faltan anscombe.csv o latencias_web.csv. Copia la carpeta completa de ejemplos y abre el notebook desde ella.')
plt.rcParams.update({'figure.figsize': (10, 4), 'font.size': 11})
""")
    md("anscombe-origen", """
## 1. Recordatorio: Anscombe

**Fuente:** datos construidos clásicos de F. J. Anscombe (1973), documentados en
el [paquete datasets de R](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/anscombe.html).
No son medidas de nuestro servidor. Cada fila del CSV contiene el nombre del
conjunto y un par `(x, y)`. Son 11 observaciones por conjunto.

Objetivo: recordar que resúmenes casi iguales no implican gráficas iguales.
""")
    code("anscombe-datos", """
anscombe = pd.read_csv(BASE / 'anscombe.csv')
assert len(anscombe) == 44 and not anscombe.isna().any().any()
assert anscombe.groupby('conjunto').size().eq(11).all()
display(anscombe.head())
filas = []
for nombre, grupo in anscombe.groupby('conjunto', sort=False):
    pendiente, intercepto = np.polyfit(grupo.x, grupo.y, 1)
    filas.append({'conjunto': nombre, 'media_x': grupo.x.mean(), 'media_y': grupo.y.mean(),
                  'var_x': grupo.x.var(ddof=1), 'var_y': grupo.y.var(ddof=1),
                  'r_Pearson': grupo.x.corr(grupo.y), 'pendiente': pendiente, 'intercepto': intercepto})
resumen_anscombe = pd.DataFrame(filas).set_index('conjunto')
display(resumen_anscombe.round(2))
""")
    code("anscombe-graficas", """
fig, ejes = plt.subplots(2, 2, figsize=(11, 8), sharex=True, sharey=True)
for eje, (nombre, grupo) in zip(ejes.flat, anscombe.groupby('conjunto', sort=False)):
    xx = np.linspace(3, 20, 100)
    eje.scatter(grupo.x, grupo.y, color='#2563eb', s=65)
    eje.plot(xx, resumen_anscombe.loc[nombre, 'intercepto'] + resumen_anscombe.loc[nombre, 'pendiente'] * xx, color='#ea580c')
    eje.set(title=f'Conjunto {nombre}', xlabel='x', ylabel='y', xlim=(3, 20), ylim=(2, 14))
    eje.grid(alpha=0.2)
fig.suptitle('Estadísticos casi iguales, datos distintos')
fig.tight_layout(rect=(0, 0, 1, 0.95))
plt.show()
""")
    md("web-contexto", """
## 2. Nuestro caso: ¿la web responde lo bastante rápido?

### Qué estamos estudiando

Tenemos la página de inicio de una web, `GET /inicio`. Queremos saber
cuánto tarda en responder a sus peticiones. El requisito de este ejercicio es:

> **Al menos el 95 % de las peticiones debe responder en 500 ms o menos.**

500 ms son medio segundo. En una muestra de 1.000 peticiones, deberían cumplir
al menos 950. Es un objetivo fijado para el ejemplo, no una ley universal.

### De dónde salen los datos

`latencias_web.csv` representa la salida que podría guardar un script cliente de
monitorización HTTP: una fila por petición y su tiempo de respuesta. Aquí lo
hemos **simulado**, sin conectarnos a un servidor real ni hacer peticiones de red.
El generador es `preparar_estadistica_web.py`, en esta misma carpeta.

La duración representa el tiempo desde enviar la petición hasta recibir la
respuesta completa. Los instantes son ficticios y las peticiones pueden solaparse.
Los tiempos se han simplificado a tres valores para poder comprobar las cuentas.

| Columna | Qué significa | Ejemplo / unidad |
|---|---|---|
| `request_id` | Identificador de esta petición, no de una persona. | 1 |
| `instante_peticion` | Momento en que empieza la petición. | Fecha y hora ficticias |
| `metodo` | Método HTTP solicitado. | GET |
| `ruta` | Recurso de la web que se solicita. | /inicio |
| `estado_http` | Estado devuelto al terminar. | 200: respuesta correcta |
| `duracion_ms` | Tiempo hasta recibir la respuesta completa. | Milisegundos |

**HTTP 200 no significa respuesta rápida.** Una petición puede terminar bien
y obligarnos a esperar diez segundos.
""")
    code("web-cargar", """
latencias = pd.read_csv(BASE / 'latencias_web.csv')
assert len(latencias) == 1000
assert latencias.request_id.is_unique
assert not latencias.isna().any().any()
assert latencias.duracion_ms.ge(0).all()
assert latencias.ruta.eq('/inicio').all()
assert latencias.estado_http.eq(200).all()
display(latencias.head(8))
print('Una fila por petición. Todas son GET /inicio y terminan con HTTP 200.')
print('Ejemplos de peticiones con cada una de las tres duraciones:')
display(latencias.sort_values('duracion_ms').groupby('duracion_ms', sort=True).head(1))
""")
    code("web-frecuencias", """
frecuencias = latencias.groupby('duracion_ms').size().rename('peticiones').to_frame()
frecuencias['porcentaje'] = 100 * frecuencias.peticiones / len(latencias)
display(frecuencias)
print('900 × 100 ms + 90 × 1.000 ms + 10 × 10.000 ms = 280.000 ms acumulados')
print('Media = 280.000 / 1.000 = 280 ms por petición')
""")
    code("web-medidas", """
t = latencias.duracion_ms
resumen_web = pd.Series({
    'Peticiones': len(t), 'Media (ms)': t.mean(), 'Mediana (ms)': t.median(),
    'Mínimo (ms)': t.min(), 'Máximo (ms)': t.max(), 'Rango (ms)': t.max() - t.min(),
    'Varianza muestral (ms²)': t.var(ddof=1), 'Desviación típica muestral (ms)': t.std(ddof=1),
    'P95 (ms)': t.quantile(0.95),
}, name='valor')
display(resumen_web.to_frame().round(2))
""")
    md("web-pausa", """
### Decide antes de seguir

La media es **280 ms**, menor que 500 ms. La mediana es **100 ms**.

**¿Basta con eso para decir que el 95 % respondió en 500 ms o menos?**

El requisito habla de cuántas peticiones cumplen, no de la media ni de la mediana.
Predice el porcentaje usando la tabla de frecuencias antes de ejecutar la celda.
""")
    code("web-cumplimiento", """
UMBRAL_MS = 500
OBJETIVO_PCT = 95
cumplen = int(t.le(UMBRAL_MS).sum())
lentas = len(t) - cumplen
porcentaje_cumple = 100 * cumplen / len(t)
p95 = float(t.quantile(0.95))
display(pd.DataFrame({
    'Comprobación': ['Peticiones totales', 'En 500 ms o menos', 'Más de 500 ms', 'Porcentaje que cumple', 'Objetivo mínimo (%)'],
    'Valor': [len(t), cumplen, lentas, porcentaje_cumple, OBJETIVO_PCT],
}))
print(f'Resultado: {cumplen} de {len(t)} = {porcentaje_cumple:.0f} %. Objetivo: {OBJETIVO_PCT} %.')
print('¿Cumple el requisito?', porcentaje_cumple >= OBJETIVO_PCT)
print(f'P95 = {p95:.0f} ms: en esta muestra, al menos el 95 % está en 1.000 ms o menos; en 500 ms solo cumple el 90 %.')
assert np.isclose(t.mean(), 280) and t.median() == 100
assert cumplen == 900 and lentas == 100 and porcentaje_cumple == 90 and p95 == 1000
""")
    code("web-graficas", """
fig, ejes = plt.subplots(1, 2, figsize=(12, 4.5))
etiquetas = [f'{d:,} ms'.replace(',', '.') for d in frecuencias.index]
barras = ejes[0].bar(etiquetas, frecuencias.peticiones, color=['#2563eb', '#f59e0b', '#dc2626'])
ejes[0].bar_label(barras, labels=[f'{n} ({p:.0f} %)' for n, p in zip(frecuencias.peticiones, frecuencias.porcentaje)], padding=4)
ejes[0].set(title='Cuántas peticiones tardan cada tiempo', ylabel='Número de peticiones', ylim=(0, 1050))
ejes[1].barh(['Objetivo mínimo', 'Resultado observado'], [OBJETIVO_PCT, porcentaje_cumple], color=['#64748b', '#2563eb'])
ejes[1].set(title='Peticiones que responden en ≤500 ms', xlabel='Porcentaje de peticiones (%)', xlim=(0, 105))
for y, v in enumerate([OBJETIVO_PCT, porcentaje_cumple]):
    ejes[1].text(v + 1, y, f'{v:.0f} %', va='center')
fig.tight_layout()
plt.show()
""")
    md("web-lectura", """
### Qué acabamos de demostrar

- La media de 280 ms está bien calculada, pero no responde al requisito.
- El 90 % responde en 100 ms; **100 de las 1.000 peticiones** tardan más de 500 ms.
- El objetivo exigía que cumplieran al menos 950. Solo cumplen 900: **no se alcanza**.
- El P95 es un segundo. Un percentil expresa un límite para una fracción de las
  observaciones; no significa que todas tarden ese tiempo.
- Las peticiones lentas son datos reales dentro de nuestra simulación, no errores
  que podamos borrar para mejorar la nota del servidor.

No sabemos por qué son lentas. Harían falta otras medidas para investigar red,
base de datos, bloqueos o carga. No se deduce la causa de una media.

### ¿Y si quitamos las lentas?

Quedarían 900 filas, media 100 ms y cumplimiento del 100 % **entre las filas
conservadas**. No habríamos arreglado la web: habríamos ocultado las 100 peticiones
que incumplían. Detectar un dato extremo o lento no autoriza a borrarlo.
""")
    md("web-ejercicios", """
## 3. Trabajo con el CSV (parejas, 20 minutos)

1. Abre `latencias_web.csv` y explica las seis columnas con tus palabras.
2. Comprueba cuántas filas cumplen `duracion_ms <= 500`. Calcula su porcentaje.
3. Explica por qué media y mediana no bastan para comprobar el requisito.
4. Elige una gráfica y escribe qué muestra: número de peticiones, duración o porcentaje.
5. Escribe qué datos conservarías para investigar las peticiones lentas.

## 4. Matemáticas del mismo caso (15–20 minutos)

- **Conjuntos:** forma el conjunto de `request_id` con HTTP 200 y el de peticiones
  de más de 500 ms. ¿Cuántas pertenecen a ambos? ¿Respuesta correcta implica rápida?
- **Lógica:** escribe una regla `SI ... ENTONCES ...` que marque una petición lenta,
  sin eliminarla. Distingue marcar cada fila de comprobar el 95 % de toda la muestra.
- **Complejidad:** para contar lentas basta recorrer n filas. Para calcular un
  percentil exacto por ordenación, un enfoque habitual necesita ordenar. ¿Por qué
  no conviene comparar cada petición con todas las demás?

### Cierre individual

> La media responde a esta pregunta: …\n>
> Para comprobar nuestro requisito necesito calcular: …\n>
> Un dato que debo conservar aunque me empeore el indicador es: …
""")
    notebook = {"nbformat": 4, "nbformat_minor": 5,
                "metadata": {"kernelspec": {"display_name": "Python 3", "language": "python", "name": "python3"},
                             "language_info": {"name": "python", "version": "3"}}, "cells": celdas}
    (BASE / f"{NOMBRE}.ipynb").write_text(json.dumps(notebook, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")


def comprobar_archivos(incluir_pdf=True):
    a = pd.read_csv(BASE / "anscombe.csv")
    w = pd.read_csv(BASE / "latencias_web.csv")
    assert len(a) == 44 and a.groupby("conjunto").size().eq(11).all()
    assert len(w) == 1000 and w.request_id.is_unique
    assert w.duracion_ms.value_counts().to_dict() == {100: 900, 1000: 90, 10000: 10}
    assert np.isclose(w.duracion_ms.mean(), 280) and w.duracion_ms.quantile(0.95) == 1000
    assert w.duracion_ms.le(500).sum() == 900
    nombres = [f"{NOMBRE}.md", f"{NOMBRE}.ipynb", "UD1_Repaso_Estadistica_Antes_de_Ejemplos.md"]
    if incluir_pdf:
        nombres += [f"{NOMBRE}.pdf", "UD1_Repaso_Estadistica_Antes_de_Ejemplos.pdf"]
    for nombre in nombres:
        assert (BASE / nombre).is_file(), f"Falta {BASE / nombre}"
    print("Archivos comprobados: CSV Anscombe (44 filas), CSV web (1.000 filas), notebook y materiales de proyección.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="comprobar sin regenerar")
    args = parser.parse_args()
    if args.check:
        comprobar_archivos()
        return
    generar_datos()
    generar_notebook()
    subprocess.run([sys.executable, "-m", "jupyter", "nbconvert", "--to", "notebook", "--execute", "--inplace",
                    "--ExecutePreprocessor.timeout=120", str(BASE / f"{NOMBRE}.ipynb")], check=True, cwd=BASE)
    subprocess.run([sys.executable, str(BASE / "generar_pdf_estadistica_proyeccion.py")], check=True, cwd=BASE)
    comprobar_archivos()


if __name__ == "__main__":
    main()
