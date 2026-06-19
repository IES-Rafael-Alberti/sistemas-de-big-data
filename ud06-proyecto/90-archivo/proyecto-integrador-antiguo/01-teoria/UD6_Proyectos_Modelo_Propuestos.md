

## 1️⃣ Predicción de demanda o ventas

### Problema

Estimar ventas futuras o demanda de un producto/servicio.

### Fuentes posibles

* Dataset histórico de ventas.
* Dataset externo (meteorología, eventos, calendario, precios).
* API pública (festivos, eventos deportivos, etc.).

### Qué obliga a hacer

* Integración temporal.
* Feature engineering.
* Regresión con Spark MLlib.
* Dashboard con evolución histórica y predicción.

### Por qué es bueno

Es clásico, entendible y arquitectónicamente completo.

---

## 2️⃣ Análisis de abandono o comportamiento de usuarios

### Problema

Detectar probabilidad de abandono o segmentar usuarios.

### Fuentes posibles

* Dataset de actividad de usuarios.
* Dataset demográfico.
* Logs de uso (simulados o reales).

### Qué obliga a hacer

* Integración de comportamiento + perfil.
* Clasificación distribuida.
* KPI de riesgo en dashboard.
* Pipeline de reentrenamiento posible.

### Por qué es bueno

Introduce clasificación con sentido real.

---

## 3️⃣ Análisis de calidad del aire / medio ambiente

### Problema

Analizar patrones y predecir niveles críticos.

### Fuentes posibles

* Dataset histórico de contaminación.
* Datos meteorológicos.
* Datos de tráfico.

### Qué obliga a hacer

* Integración espacial y temporal.
* Agregaciones Spark.
* Regresión.
* Dashboard con alertas.

### Por qué es bueno

Conecta muy bien con Big Data y datos públicos.

---

## 4️⃣ Sistema de recomendación sencillo

### Problema

Recomendar productos, películas o contenidos.

### Fuentes posibles

* Dataset de ratings.
* Dataset de productos.
* Dataset de usuarios.

### Qué obliga a hacer

* Integración de varias tablas.
* Procesamiento distribuido.
* Modelo básico (ALS o similar).
* Dashboard con popularidad y recomendaciones.

### Por qué es bueno

Es ML claro, pero sin deep learning.

---

## 5️⃣ Análisis financiero o de mercados

### Problema

Analizar tendencias y predecir comportamiento básico.

### Fuentes posibles

* Dataset histórico de precios.
* Datos macroeconómicos.
* Indicadores externos.

### Qué obliga a hacer

* Integración temporal.
* Feature engineering.
* Regresión o clasificación.
* Dashboard con indicadores clave.

### Por qué es bueno

Es serio y profesional, pero cuidado con elegir datasets adecuados.

---
