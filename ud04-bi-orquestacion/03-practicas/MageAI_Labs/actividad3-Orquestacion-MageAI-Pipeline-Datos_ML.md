# 🤖 Actividad 3 — Mage AI + Machine Learning

## 🧠 Objetivo

Crear un pipeline que:

* Prepare datos
* Entrene un modelo sencillo
* Genere predicciones

---

## 🧩 Escenario

Dataset: `supermarket_sales.csv`

Objetivo:

👉 Predecir el **Total** o analizar comportamiento de ventas

---

## 🔧 Paso 1 — Pipeline

```text
Nombre: ml_pipeline
```

---

## 📥 Paso 2 — Data Loader

```python
import pandas as pd

def load_data(*args, **kwargs):
    return pd.read_csv("data/supermarket_sales.csv")
```

---

## 🔄 Paso 3 — Transformer (feature engineering)

```python
def transform(df, *args, **kwargs):
    df = df.copy()
    
    df['Total'] = df['Total'].astype(float)
    df['Quantity'] = df['Quantity'].astype(int)
    
    df['Unit_price_x_Quantity'] = df['Unit price'] * df['Quantity']
    
    return df
```

---

## 🤖 Paso 4 — Nuevo bloque: Model (Custom)

```python
from sklearn.linear_model import LinearRegression

def train_model(df, *args, **kwargs):
    X = df[['Quantity']]
    y = df['Total']
    
    model = LinearRegression()
    model.fit(X, y)
    
    df['prediction'] = model.predict(X)
    
    return df
```

---

## 📊 Paso 5 — Evaluación simple

Añade:

```python
def evaluate(df, *args, **kwargs):
    from sklearn.metrics import mean_squared_error
    
    mse = mean_squared_error(df['Total'], df['prediction'])
    print("MSE:", mse)
    
    return df
```

---

## 💾 Paso 6 — Exporter

```python
def export(df, *args, **kwargs):
    df.to_csv("output/ml_predictions.csv", index=False)
```

---

## 🧠 Paso 7 — Reflexión (MUY IMPORTANTE)

Responder:

* ¿Qué está aprendiendo el modelo realmente?
* ¿Es un buen modelo? ¿Por qué?
* ¿Qué mejorarías?
* ¿Dónde encaja este pipeline en un sistema real?
