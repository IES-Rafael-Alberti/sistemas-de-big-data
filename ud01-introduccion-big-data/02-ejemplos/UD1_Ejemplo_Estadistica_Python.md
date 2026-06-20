# UD1 — Ejemplo de estadística aplicada con Python

Este ejemplo acompaña a la parte de [estadística aplicada](../01-teoria/UD1-Parte0-BaseMatematica/UD1_P0_Estadistica_para_BigData.md). Usa un dataset pequeño para que los cálculos se puedan comprobar a mano antes de automatizarlos.

También puedes descargar y ejecutar el [notebook de este ejemplo](UD1_Ejemplo_Estadistica_Python.ipynb).

## Dataset

Trabajamos con ventas de una tienda. Hay un valor extremo intencionado para ver cómo afecta a media, mediana y outliers.

| venta_id | ciudad | unidades | precio_unitario | precio_total | tiempo_entrega_h |
| --- | --- | ---: | ---: | ---: | ---: |
| 1 | Cádiz | 2 | 12 | 24 | 24 |
| 2 | Cádiz | 1 | 15 | 15 | 26 |
| 3 | Sevilla | 3 | 10 | 30 | 30 |
| 4 | Sevilla | 4 | 11 | 44 | 28 |
| 5 | Málaga | 2 | 14 | 28 | 25 |
| 6 | Málaga | 1 | 1000 | 1000 | 200 |

## Código

```python
import pandas as pd

df = pd.DataFrame({
    'venta_id': [1, 2, 3, 4, 5, 6],
    'ciudad': ['Cádiz', 'Cádiz', 'Sevilla', 'Sevilla', 'Málaga', 'Málaga'],
    'unidades': [2, 1, 3, 4, 2, 1],
    'precio_unitario': [12, 15, 10, 11, 14, 1000],
    'precio_total': [24, 15, 30, 44, 28, 1000],
    'tiempo_entrega_h': [24, 26, 30, 28, 25, 200],
})

media = df['precio_total'].mean()
mediana = df['precio_total'].median()
desviacion = df['precio_total'].std(ddof=1)

q1 = df['precio_total'].quantile(0.25)
q3 = df['precio_total'].quantile(0.75)
iqr = q3 - q1
limite_superior = q3 + 1.5 * iqr

outliers = df[df['precio_total'] > limite_superior]

correlacion = df['precio_total'].corr(df['tiempo_entrega_h'])

print('Media:', media)
print('Mediana:', mediana)
print('Desviación típica:', desviacion)
print('Q1:', q1)
print('Q3:', q3)
print('IQR:', iqr)
print('Límite superior:', limite_superior)
print('Outliers:')
print(outliers)
print('Correlación precio_total vs tiempo_entrega_h:', correlacion)
```

## Qué observar

- La media queda arrastrada por la venta de 1000 euros.
- La mediana describe mejor una venta típica.
- El método IQR marca la venta de 1000 euros como outlier.
- La correlación entre `precio_total` y `tiempo_entrega_h` puede parecer alta, pero eso no demuestra causalidad: el mismo valor extremo afecta a ambas variables.

## Preguntas para clase

1. ¿Eliminarías la venta de 1000 euros? Justifica la decisión.
2. ¿Qué medida usarías para resumir `precio_total`: media o mediana?
3. ¿La correlación entre precio y tiempo de entrega permite afirmar que los pedidos caros tardan más?
4. ¿Qué regla lógica validarías sobre `precio_total`, `unidades` y `precio_unitario`?
