"""PDF panorámicos para proyectar el repaso y el notebook estadístico UD1.

Desde la raíz SBD:
python ud01-introduccion-big-data/02-ejemplos/generar_pdf_estadistica_proyeccion.py

Requiere numpy, pandas y matplotlib, igual que el notebook. No descarga datos.
Los cálculos proceden de las celdas del notebook; las dos pantallas de repaso
proceden del Markdown homónimo. La secuencia de proyección se define aquí.
"""

from contextlib import redirect_stdout
from io import StringIO
import json
from pathlib import Path
import re
import textwrap

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import numpy as np
import pandas as pd


EJEMPLOS = Path(__file__).resolve().parent
DESTINO = EJEMPLOS
REPASO = "UD1_Repaso_Estadistica_Antes_de_Ejemplos"
DEMO = "UD1_Estadistica_Decisiones_Anscombe_Latencias_Web"
AZUL = "#2563eb"
NARANJA = "#ea580c"
TEXTO = "#0f172a"
FONDO = "#f8fafc"


def cargar_calculos():
    """Reutilizar el código del notebook local, sin kernel ni salidas persistidas."""
    notebook = json.loads((EJEMPLOS / f"{DEMO}.ipynb").read_text(encoding="utf-8"))
    contexto = {"__name__": "__main__", "__file__": str(EJEMPLOS / f"{DEMO}.ipynb")}
    with redirect_stdout(StringIO()):
        for celda in notebook["cells"]:
            if celda["cell_type"] != "code":
                continue
            fuente = celda["source"]
            fuente = fuente if isinstance(fuente, str) else "".join(fuente)
            fuente = fuente.replace("%matplotlib inline", "")
            fuente = fuente.replace("from IPython.display import display", "display = lambda *args, **kwargs: None")
            fuente = fuente.replace("plt.show()", "")
            exec(compile(fuente, str(EJEMPLOS / f"{DEMO}.ipynb"), "exec"), contexto)
            # display() no se necesita al generar estas diapositivas.
            contexto["display"] = lambda *args, **kwargs: None
            plt.close("all")
    # Mantener el mismo bloque visual de Anscombe ya utilizado en clase.
    contexto["anscombe"] = contexto["anscombe"].rename(columns={"conjunto": "fuente"})
    sensibilidad = []
    for nombre in ["III", "IV"]:
        grupo = contexto["anscombe"].query("fuente == @nombre")
        indice = grupo.y.idxmax() if nombre == "III" else grupo.x.idxmax()
        resto = grupo.drop(index=indice)
        sensibilidad.append({
            "fuente": nombre,
            "pendiente_original": contexto["resumen_anscombe"].loc[nombre, "pendiente"],
            "pendiente_sin_punto": float(np.polyfit(resto.x, resto.y, 1)[0]) if resto.x.nunique() > 1 else np.nan,
            "x_distintos_restantes": resto.x.nunique(),
        })
    contexto["sensibilidad"] = sensibilidad
    return contexto


def configurar_estilo():
    plt.rcParams.update({
        "font.family": "DejaVu Sans",
        "font.size": 20,
        "axes.titlesize": 23,
        "axes.labelsize": 20,
        "xtick.labelsize": 17,
        "ytick.labelsize": 17,
        "legend.fontsize": 18,
        "pdf.fonttype": 42,
        "figure.facecolor": FONDO,
    })


def pagina(pdf, numero, titulo, subtitulo=None):
    fig = plt.figure(figsize=(16, 9), facecolor=FONDO)
    fig.text(0.05, 0.91, titulo, fontsize=29, fontweight="bold", color=TEXTO)
    if subtitulo:
        fig.text(0.05, 0.85, subtitulo, fontsize=19, color="#475569")
    fig.text(0.05, 0.035, "SBD · UD1 · Estadística aplicada", fontsize=12, color="#64748b")
    fig.text(0.95, 0.035, str(numero), ha="right", fontsize=12, color="#64748b")
    return fig


def guardar(pdf, fig):
    # Conservar el tamaño fijo 16:9: no utilizar bbox_inches='tight'.
    pdf.savefig(fig)
    plt.close(fig)


def lineas(fig, contenido, y=0.76, tam=23, ancho=78, paso=0.055):
    for texto in contenido:
        for linea in textwrap.wrap(texto, width=ancho) or [""]:
            fig.text(0.07, y, linea, fontsize=tam, color=TEXTO)
            y -= paso
        y -= paso * 0.55
    if y < 0.09:
        raise ValueError("Demasiado texto para una página panorámica")


def tabla(fig, encabezados, filas, pos=(0.05, 0.26, 0.90, 0.50), anchos=None, tam=19):
    eje = fig.add_axes(pos)
    eje.axis("off")
    t = eje.table(cellText=filas, colLabels=encabezados, colWidths=anchos,
                  cellLoc="center", loc="center", bbox=[0, 0, 1, 1])
    t.auto_set_font_size(False)
    t.set_fontsize(tam)
    for (fila, col), celda in t.get_celld().items():
        celda.set_edgecolor("#cbd5e1")
        celda.PAD = 0.08
        if fila == 0:
            celda.set_facecolor("#1e3a8a")
            celda.set_text_props(color="white", weight="bold")
        else:
            celda.set_facecolor("white" if fila % 2 else "#e2e8f0")
            celda.set_text_props(color=TEXTO)
    return t


def decimal(valor, cifras=2):
    return f"{valor:.{cifras}f}".replace(".", ",")


def generar_repaso():
    fuente = (EJEMPLOS / f"{REPASO}.md").read_text(encoding="utf-8")
    filas = []
    for linea in fuente.splitlines():
        if not linea.startswith("| "):
            continue
        columnas = [col.strip() for col in linea.strip("|").split("|")]
        if columnas[0] != "Medida":
            filas.append(columnas[:2])
    assert len(filas) == 6
    reglas = re.search(r"```text\n(IQR =.*?)\n```", fuente, re.S).group(1).splitlines()
    with PdfPages(DESTINO / f"{REPASO}.pdf") as pdf:
        pdf.infodict()["Title"] = "UD1 — Repaso estadístico antes de los ejemplos"
        fig = pagina(pdf, 1, "¿Qué cuenta cada medida?", "Repaso · 1 de 2 · Interpretar, no memorizar fórmulas")
        tabla(fig, ["Medida", "Qué muestra"], filas, pos=(0.06, 0.28, 0.88, 0.51),
              anchos=[0.25, 0.75], tam=20)
        fig.text(0.06, 0.18, "La media puede ser insuficiente: no está mal por definición.", fontsize=22, color=TEXTO)
        fig.text(0.06, 0.11, "¿Conocer el promedio basta para saber qué ocurre?", fontsize=23, color=AZUL)
        guardar(pdf, fig)

        fig = pagina(pdf, 2, "IQR: detectar no significa borrar", "Repaso · 2 de 2 · El 50 % central de los datos")
        for y, regla in zip([0.74, 0.65, 0.56], reglas):
            fig.text(0.08, y, regla, fontsize=28, color=AZUL, fontweight="bold")
        fig.text(0.08, 0.45, "Los límites salen de Q1 y Q3, no de la media.", fontsize=22, color=TEXTO)
        fig.text(0.08, 0.34, "detectar → investigar → decidir → documentar", fontsize=25, color=NARANJA)
        fig.text(0.08, 0.23, "¿Error de captura, unidades o caso real poco frecuente?", fontsize=22, color=TEXTO)
        fig.text(0.08, 0.14, "Ahora: una tabla, una decisión y una gráfica que la pone a prueba.", fontsize=21, color=TEXTO)
        guardar(pdf, fig)


def generar_demo(ctx):
    resumen = ctx["resumen_anscombe"]
    datos = ctx["anscombe"]
    latencias = ctx["latencias"]
    frecuencias = ctx["frecuencias"]
    porcentaje = ctx["porcentaje_cumple"]
    sensibilidad = ctx["sensibilidad"]
    with PdfPages(DESTINO / f"{DEMO}.pdf") as pdf:
        pdf.infodict()["Title"] = "UD1 — El código funciona, ¿la conclusión también?"

        fig = pagina(pdf, 1, "El código funciona, ¿la conclusión también?", "Dos decisiones para entender por qué necesitamos estadística")
        lineas(fig, [
            "1. Anscombe: casi los mismos estadísticos, cuatro situaciones distintas.",
            "2. Servidor web: una media rápida puede ocultar peticiones lentas.",
            "Antes de revelar la gráfica, toma una decisión. Después, defiéndela o cámbiala.",
            "CSV incluidos: anscombe.csv (44 filas) y latencias_web.csv (1.000 peticiones sintéticas).",
        ], ancho=78)
        guardar(pdf, fig)

        fig = pagina(pdf, 2, "Anscombe: primero, solo los números", "Cuatro fuentes · 11 observaciones cada una · Varianzas muestrales")
        filas = [[nombre, decimal(r.media_x), decimal(r.media_y), decimal(r.var_y),
                  decimal(r.r_Pearson), decimal(r.pendiente), decimal(r.intercepto)]
                 for nombre, r in resumen.iterrows()]
        tabla(fig, ["Fuente", "Media x", "Media y", "Varianza y", "r", "Pendiente", "Intercepto"],
              filas, tam=20)
        fig.text(0.06, 0.18, "En todas: varianza de x = 11; recta aproximada y = 3 + 0,5x.", fontsize=22, color=TEXTO)
        fig.text(0.06, 0.11, "Son casi iguales, no exactamente iguales: los datos están redondeados.", fontsize=20, color="#475569")
        guardar(pdf, fig)

        fig = pagina(pdf, 3, "¿Tratarías las cuatro fuentes igual?", "Decide antes de ver las gráficas")
        lineas(fig, [
            "¿Usarías la misma recta para interpretar las cuatro fuentes?",
            "¿Qué comprobarías antes de automatizar esa conclusión?",
            "Pearson resume relación lineal: r está entre −1 y 1. Una correlación alta no demuestra causalidad.",
            "Una recta de ajuste describe una tendencia; no garantiza que sea una buena descripción del dataset.",
        ])
        guardar(pdf, fig)

        for numero, nombres in [(4, ["I", "II"]), (5, ["III", "IV"])]:
            fig = pagina(pdf, numero, "Mira los datos: la tabla no lo contaba", "Mismas escalas en todas las gráficas")
            for izquierda, nombre in zip([0.07, 0.56], nombres):
                eje = fig.add_axes([izquierda, 0.19, 0.37, 0.57])
                grupo = datos[datos["fuente"].eq(nombre)]
                x = np.linspace(3, 20, 100)
                eje.scatter(grupo.x, grupo.y, s=120, color=AZUL, zorder=3)
                eje.plot(x, resumen.loc[nombre, "intercepto"] + resumen.loc[nombre, "pendiente"] * x,
                         color=NARANJA, linewidth=3)
                eje.set(title=f"Fuente {nombre}", xlabel="x", ylabel="y", xlim=(3, 20), ylim=(2, 14))
                eje.grid(alpha=0.2)
            fig.text(0.07, 0.09, "¿Qué cambia en tu decisión? La línea naranja es el ajuste, no la verdad del dato.", fontsize=20, color=TEXTO)
            guardar(pdf, fig)

        fig = pagina(pdf, 6, "Después de mirar: cuatro decisiones", "Los resúmenes se complementan con gráficas y contexto")
        tabla(fig, ["Fuente", "Lo que aparece", "Decisión técnica"], [
            ["I", "Tendencia aproximadamente lineal", "Revisar dispersión y límites"],
            ["II", "Curva", "No forzar una interpretación lineal"],
            ["III", "Un punto altera el ajuste", "Investigar y medir sensibilidad"],
            ["IV", "Diez x iguales y una alejada", "Pedir más cobertura; no generalizar"],
        ], pos=(0.05, 0.24, 0.90, 0.53), anchos=[0.09, 0.41, 0.50], tam=19)
        fig.text(0.06, 0.13, "No sustituimos estadística por dibujos: combinamos ambas evidencias.", fontsize=22, color=TEXTO)
        guardar(pdf, fig)

        fig = pagina(pdf, 7, "¿Qué ocurre si retiramos un punto?", "Experimento de sensibilidad, no una receta de limpieza")
        filas = [[r["fuente"], decimal(r["pendiente_original"], 3),
                  "No identificable" if pd.isna(r["pendiente_sin_punto"]) else decimal(r["pendiente_sin_punto"], 3),
                  str(r["x_distintos_restantes"])] for r in sensibilidad]
        tabla(fig, ["Fuente", "Pendiente original", "Sin punto destacado", "x distintas restantes"],
              filas, pos=(0.05, 0.41, 0.90, 0.33), tam=20)
        lineas(fig, [
            "En IV, todas las x restantes son 8: no se puede identificar una pendiente.",
            "Un punto influyente exige investigar su origen; no se elimina automáticamente.",
        ], y=0.29, tam=22)
        guardar(pdf, fig)

        fig = pagina(pdf, 8, "¿La web responde lo bastante rápido?", "Un servidor · Una ruta · Un CSV · Una pregunta")
        lineas(fig, [
            "Un cliente pide la página de inicio: GET /inicio. Cada fila es una petición, no una persona.",
            "latencias_web.csv simula un registro de monitorización HTTP. No se ha medido un servidor real.",
            "duracion_ms: tiempo hasta recibir la respuesta completa. 500 ms = medio segundo.",
            "Requisito: al menos el 95 % debe responder en 500 ms o menos. De 1.000 peticiones, al menos 950.",
        ])
        guardar(pdf, fig)

        fig = pagina(pdf, 9, "Qué contiene el fichero", "Una fila por petición · Datos sintéticos simplificados")
        muestra = latencias.sort_values("duracion_ms").groupby("duracion_ms").head(1)
        tabla(fig, ["Petición (id)", "Método y ruta", "Estado HTTP", "Duración (ms)"],
              [[str(r.request_id), "GET /inicio", str(r.estado_http), str(r.duracion_ms)]
               for r in muestra.itertuples()], tam=21)
        fig.text(0.06, 0.17, "1.000 filas. Todas responden con HTTP 200. Sin nulos ni ids duplicados.", fontsize=21, color=TEXTO)
        fig.text(0.06, 0.10, "HTTP 200 significa respuesta correcta; no significa respuesta rápida.", fontsize=22, color=AZUL)
        guardar(pdf, fig)

        fig = pagina(pdf, 10, "Los datos caben en una tabla", "Los tiempos están repetidos a propósito para comprobar las cuentas")
        tabla(fig, ["Tiempo de respuesta", "Peticiones", "Porcentaje"],
              [[f"{d:,} ms".replace(",", "."), str(int(r.peticiones)), f"{r.porcentaje:.0f} %"]
               for d, r in frecuencias.iterrows()], tam=23)
        fig.text(0.06, 0.17, "900 × 100 + 90 × 1.000 + 10 × 10.000 = 280.000 ms acumulados", fontsize=21, color=TEXTO)
        fig.text(0.06, 0.10, "Media = 280.000 / 1.000 = 280 ms. Mediana = 100 ms.", fontsize=23, color=AZUL)
        guardar(pdf, fig)

        fig = pagina(pdf, 11, "Media: 280 ms. ¿Cumplimos?", "El requisito no pide una media inferior a 500 ms")
        lineas(fig, [
            "Pide que el 95 % de las peticiones responda en 500 ms o menos.",
            "De 1.000 peticiones deben cumplir, al menos, 950.",
            "Usa la tabla anterior: ¿cuántas cumplen de verdad?",
            "Primero decide. Después comprobamos con código y gráficas.",
        ], tam=25)
        guardar(pdf, fig)

        fig = pagina(pdf, 12, "La gráfica muestra lo que oculta la media", "No todas las peticiones se parecen al promedio")
        eje = fig.add_axes([0.10, 0.25, 0.80, 0.50])
        etiquetas = [f"{d:,} ms".replace(",", ".") for d in frecuencias.index]
        barras = eje.bar(etiquetas, frecuencias.peticiones, color=[AZUL, "#f59e0b", "#dc2626"])
        eje.bar_label(barras, labels=[f"{n} peticiones ({p:.0f} %)" for n, p in zip(frecuencias.peticiones, frecuencias.porcentaje)], fontsize=20, padding=7)
        eje.set(ylim=(0, 1100), ylabel="Número de peticiones", xlabel="Duración de la respuesta")
        fig.text(0.07, 0.12, "100 peticiones tardan más de medio segundo; 10 tardan diez segundos.", fontsize=22, color=TEXTO)
        guardar(pdf, fig)

        fig = pagina(pdf, 13, "Solo cumplen 900 de 1.000: un 90 %", "El mínimo exigido es 95 %. No se alcanza el requisito.")
        eje = fig.add_axes([0.25, 0.35, 0.66, 0.35])
        barras = eje.barh(["Objetivo mínimo", "Resultado observado"], [95, porcentaje], color=["#64748b", AZUL])
        eje.bar_label(barras, labels=["95 %", f"{porcentaje:.0f} %"], padding=8, fontsize=25)
        eje.set(xlim=(0, 110), xlabel="Porcentaje de peticiones en 500 ms o menos")
        fig.text(0.06, 0.20, "P95 = 1.000 ms: al menos el 95 % responde en un segundo o menos.", fontsize=21, color=TEXTO)
        fig.text(0.06, 0.11, "La media responde al promedio; el requisito pide un porcentaje bajo un límite.", fontsize=21, color=NARANJA)
        guardar(pdf, fig)

        fig = pagina(pdf, 14, "¿Lo arreglamos borrando las lentas?", "Cambiar la muestra no mejora la web")
        tabla(fig, ["Datos usados", "Peticiones", "Media", "En ≤500 ms"], [
            ["Registro completo", "1.000", "280 ms", "90 %"],
            ["Solo peticiones rápidas", "900", "100 ms", "100 % del subconjunto"],
        ], pos=(0.05, 0.39, 0.90, 0.35), anchos=[0.31, 0.15, 0.17, 0.37], tam=21)
        lineas(fig, [
            "Las 100 peticiones lentas siguen habiendo ocurrido. HTTP 200 no las convierte en rápidas.",
            "Conservar, marcar e investigar. No borrar registros para embellecer el indicador.",
        ], y=0.32, tam=21, paso=0.04)
        guardar(pdf, fig)

        fig = pagina(pdf, 15, "¿Qué cambia en nuestro sistema?", "Estadística aplicada a decisiones de ingeniería")
        tabla(fig, ["Antes", "Después"], [
            ["Mostrar solo la media", "Media, percentiles y porcentaje bajo el límite"],
            ["Guardar solo el resumen", "Conservar cada petición y su duración"],
            ["HTTP 200 → todo va bien", "Separar respuesta correcta y respuesta rápida"],
            ["Borrar las lentas", "Marcar e investigar sin ocultar observaciones"],
        ], pos=(0.06, 0.25, 0.88, 0.52), anchos=[0.36, 0.64], tam=20)
        fig.text(0.06, 0.13, "Datos técnicamente válidos no garantizan una interpretación válida.", fontsize=22, color=TEXTO)
        guardar(pdf, fig)

        fig = pagina(pdf, 16, "Trabaja con latencias_web.csv", "Mismo caso para estadística, conjuntos y lógica")
        lineas(fig, [
            "1. Cuenta las peticiones que tardan más de 500 ms y calcula su porcentaje.",
            "2. ¿Cuántas son lentas y, a la vez, responden HTTP 200?",
            "3. Escribe una regla que marque una petición lenta sin borrarla.",
            "4. ¿Qué dato conservarías para investigar la causa?",
            "Cierre: ¿por qué una media correcta no basta para comprobar nuestro requisito?",
        ], tam=24)
        guardar(pdf, fig)


def main():
    if not DESTINO.is_dir():
        raise FileNotFoundError(DESTINO)
    contexto = cargar_calculos()
    configurar_estilo()
    generar_repaso()
    generar_demo(contexto)
    print(f"PDF de repaso (2 páginas): {DESTINO / (REPASO + '.pdf')}")
    print(f"PDF de demostración (16 páginas): {DESTINO / (DEMO + '.pdf')}")


if __name__ == "__main__":
    main()
