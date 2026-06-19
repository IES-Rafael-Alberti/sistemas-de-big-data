# 🧪 Actividad 2 — Mage AI + API (Ingesta de datos externos)

## 🧠 Objetivo

Construir un pipeline en Mage que:

* Obtenga datos desde una API
* Los transforme
* Genere un dataset útil

---

## 🧩 Escenario

Vamos a trabajar con una API pública.

Ejemplo recomendado:

👉 API de países:
`https://restcountries.com/v3.1/all`

---

## 🔧 Paso 1 — Crear pipeline

En Mage:

```text
New Pipeline → Standard (batch)
Nombre: api_pipeline
```

---

## 🔌 Paso 2 — Data Loader (API)

Crea un bloque **Data Loader** con este código:

```python
import requests
import pandas as pd

def load_data(*args, **kwargs):
    url = "https://restcountries.com/v3.1/all"
    response = requests.get(url)
    data = response.json()
    
    # Convertimos a DataFrame
    df = pd.json_normalize(data)
    return df
```

---

## 🔍 Paso 3 — Explorar datos

👉 Ejecuta el bloque y responde:

* ¿Cuántas columnas hay?
* ¿Qué columnas parecen útiles?

---

## 🔄 Paso 4 — Transformer

Crea un bloque **Transformer**:

```python
def transform(df, *args, **kwargs):
    df = df[[
        'name.common',
        'region',
        'population',
        'area'
    ]]
    
    df = df.dropna()
    
    df['density'] = df['population'] / df['area']
    
    return df.sort_values(by='density', ascending=False)
```

---

## 📊 Paso 5 — Análisis básico

👉 Responde:

* ¿Qué países tienen mayor densidad?
* ¿Qué regiones predominan?

---

## 💾 Paso 6 — Exporter

```python
def export(df, *args, **kwargs):
    df.to_csv("output/countries_density.csv", index=False)
```

---

## 🧠 Paso 7 — Reflexión (CLAVE)

Responde en tu documento:

* ¿Qué ventajas tiene usar una API frente a un CSV?
* ¿Qué problemas pueden surgir?
* ¿Qué cambiarías en el pipeline?



