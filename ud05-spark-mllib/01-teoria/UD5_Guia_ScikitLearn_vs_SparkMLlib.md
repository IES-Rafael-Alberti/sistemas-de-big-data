# UD5 — Guía: ¿scikit-learn o Spark MLlib? Cuándo cada uno

> **Propósito**: Aclarar cuándo el Machine Learning es Big Data y cuándo no.
> No todas las ML tasks necesitan Spark. Elegir la herramienta equivocada añade
> complejidad sin beneficio.
>
> **RA/CE asociado**: RA1.f (selección integrada de sistemas), RA1.g (coste y calidad).

---

## 1. El problema real

No es "qué herramienta es mejor". Es **qué problema tienes**:

```
¿El dataset cabe en memoria RAM?
  ├── Sí → ¿Ya estás usando Spark para ETL?
  │        ├── Sí → Usa Spark MLlib (evitas mover datos)
  │        └── No → Usa scikit-learn (más simple, más rápido)
  └── No → ¿El dataset cabe en un cluster modesto?
           ├── Sí → Spark MLlib
           └── No → Necesitas particionar, muestrear o cloud
```

---

## 2. Comparativa directa

| Dimensión | scikit-learn | Spark MLlib |
|-----------|-------------|-------------|
| **Volumen de datos** | Memoria RAM (típico < 10 GB) | Distribuido (cientos de GB a TB) |
| **Curva de aprendizaje** | Baja. API Python pura | Media. Requiere entender Spark |
| **Instalación** | `pip install scikit-learn` | Java + Spark + config |
| **Velocidad en datos pequeños** | Más rápido | Overhead de distribución |
| **Velocidad en datos grandes** | No escala | Escala horizontalmente |
| **Algoritmos** | Muy amplia (clasificación, regresión, clustering, reducción, etc.) | Suficiente para lo común (regresión, clasificación, clustering, recomendación) |
| **Pipeline** | `Pipeline` + `GridSearchCV` | `Pipeline` + `CrossValidator` / `TrainValidationSplit` |
| **Evaluación** | Metrics variadas + validación cruzada integrada | Metrics básicas, validación cruzada distribuida |
| **Ecosistema** | numpy, pandas, matplotlib | Spark DataFrame, Parquet, HDFS |
| **Producción** | Export con pickle/joblib + microservicio | Spark model export + batch predict |
| **Debugging** | Fácil. Dataset pequeño, iteras rápido | Más lento. Cada iteración requiere Spark job |

---

## 3. ¿Cuándo usar scikit-learn?

### ✅ Situaciones ideales

- **Dataset < 1-2 GB** → Cabe en RAM sobrado.
- **Prototipado rápido** → Estás explorando features y modelos.
- **Entorno local sin Spark** → No quieres montar Java + Spark.
- **Equipo pequeño** → Nadie tiene experiencia con Spark.
- **Necesitas algoritmos específicos** → scikit-learn tiene RandomForest, SVM, GradientBoosting, etc. con hiperparametrización muy madura.

### Ejemplo típico

```python
# 5 minutos, cero config
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error

model = RandomForestRegressor()
model.fit(X_train, y_train)
preds = model.predict(X_test)
print(mean_squared_error(y_test, preds))
```

### ⚠️ Cuándo NO usar scikit-learn

- Dataset > 10 GB y no cabe en RAM.
- Necesitas procesar datos que ya están en Spark DataFrame.
- El problema requiere escalar horizontalmente.

---

## 4. ¿Cuándo usar Spark MLlib?

### ✅ Situaciones ideales

- **Dataset > 10 GB** → No cabe en RAM de una máquina.
- **Ya tienes Spark funcionando** → Tus datos ya están en DataFrames de Spark.
- **Necesitas distribuirlo** → El dataset crece y necesitas escalar.
- **Pipeline Big Data completo** → Ingesta → Spark ETL → ML → salida.

### Ejemplo típico

```python
# Misma estructura que scikit-learn, pero distribuido
from pyspark.ml.regression import LinearRegression
from pyspark.ml.evaluation import RegressionEvaluator

lr = LinearRegression(featuresCol="features", labelCol="price")
model = lr.fit(train)
preds = model.transform(test)
evaluator = RegressionEvaluator(labelCol="price", metricName="rmse")
rmse = evaluator.evaluate(preds)
```

### ⚠️ Cuándo NO usar Spark MLlib

- Dataset cabe en RAM de un portátil → el overhead de Spark ralentiza.
- Solo necesitas entrenar un modelo rápido → scikit-learn es más ágil.
- El equipo no tiene Java/Spark instalado → pérdida de tiempo en setup.

---

## 5. Árbol de decisión rápido

```
Tu dataset
│
├─ ¿Cabe en RAM? (< 5-10 GB)
│  ├─ SÍ → ¿Usas Spark para ETL?
│  │       ├─ SÍ → MLlib (mismo contexto)
│  │       └─ NO → scikit-learn (simple y rápido)
│  └─ NO → MLlib (necesitas distribución)
│
├─ ¿Es prototipo/exploración?
│  ├─ SÍ → scikit-learn (iteras rápido)
│  └─ NO → MLlib (producción Big Data)
│
└─ ¿El equipo domina Spark?
   ├─ SÍ → MLlib
   └─ NO → scikit-learn primero, después migra si toca
```

---

## 6. Coste y viabilidad

| Factor | scikit-learn | Spark MLlib |
|--------|-------------|-------------|
| Tiempo de setup | Minutos | 30-60 min (Java + Spark) |
| Coste hardware | Portátil normal | Cluster o máquina con > 8 GB RAM |
| Curva de aprendizaje | 1-2 sesiones | 3-4 sesiones |
| Mantenimiento | Bajo | Medio (Java updates, Spark config) |
| Escalabilidad | No escala | Escala horizontal |

Conclusión: **scikit-learn es más barato y rápido para datasets pequeños-medianos.
Spark MLlib se justifica cuando el volumen o la integración con el ecosistema Big Data
lo exigen.**

---

## 7. Estrategia recomendada para SBD

```
Fase 1 — Prototipo con scikit-learn (UD5 intro)
  → Dataset pequeño, pruebas de concepto, validar enfoque
Fase 2 — Migrar a Spark MLlib si toca (UD5 avanzado)
  → Mismo pipeline, misma lógica, API similar
Fase 3 — Proyecto completo (UD6)
  → Decisión razonada según contexto
```

No hay una respuesta correcta única. La respuesta correcta es **justificar la decisión**
según coste, volumen, equipo y requisitos. Eso es exactamente lo que pide RA1.g.

---

## Histórico de cambios

| Fecha       | Cambio |
| ----------- | ------ |
| 2026-06-18 | Creación de la guía de decisión. |
