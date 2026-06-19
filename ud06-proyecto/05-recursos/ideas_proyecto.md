# UD6 — Ideas orientativas de proyecto

Este documento propone dominios de trabajo para el proyecto integrador. No son
enunciados cerrados: cada grupo debe concretar fuentes, arquitectura, tratamiento
de datos, calidad, anonimización y alcance con el docente.

El proyecto final es **común para SBD, Big Data Aplicado y Programación de IA**.
No se espera que el alumnado haga tres proyectos distintos: se espera un único
sistema de datos con evidencias suficientes para que cada módulo evalúe su parte.

El foco de **SBD** no es hacer el mejor modelo ni el dashboard más vistoso, sino
demostrar un sistema de datos bien diseñado: ingesta, almacenamiento, calidad,
procesamiento, trazabilidad, coste/viabilidad y dashboard técnico.

---

## 1. Predicción de demanda o ventas

**Problema**: estimar ventas futuras o demanda de un producto/servicio.

**Fuentes posibles**:

- histórico de ventas;
- meteorología, eventos, calendario o precios;
- API pública de festivos, eventos deportivos u otros factores externos.

**Qué obliga a trabajar**:

- integración temporal;
- calidad de fechas y granularidad;
- predicción sencilla: media móvil, regresión o Spark MLlib si procede;
- dashboard con evolución histórica y previsión.

---

## 2. Comportamiento de usuarios o abandono

**Problema**: detectar patrones de uso, segmentar usuarios o estimar riesgo de
abandono.

**Fuentes posibles**:

- actividad de usuarios;
- perfiles o segmentos simulados;
- logs de uso simulados o anonimizados.

**Qué obliga a trabajar**:

- integración de comportamiento + perfil;
- anonimización fuerte de identificadores;
- clasificación o segmentación si tiene sentido;
- KPIs técnicos de calidad y volumen.

---

## 3. Calidad del aire o medio ambiente

**Problema**: analizar patrones ambientales y detectar periodos críticos.

**Fuentes posibles**:

- histórico de contaminación;
- meteorología;
- tráfico, sensores o estaciones públicas.

**Qué obliga a trabajar**:

- integración espacial y temporal;
- tratamiento de nulos y estaciones incompletas;
- agregaciones por zona/fecha;
- dashboard técnico con anomalías o alertas.

---

## 4. Recomendación sencilla

**Problema**: recomendar productos, películas, contenidos o recursos.

**Fuentes posibles**:

- ratings o interacciones;
- catálogo de productos/contenidos;
- usuarios anonimizados o simulados.

**Qué obliga a trabajar**:

- integración de varias tablas;
- cuidado especial con identificadores de usuario;
- modelo básico de recomendación o ranking;
- dashboard con popularidad, cobertura y resultados.

---

## 5. Datos financieros o económicos

**Problema**: analizar tendencias o relaciones entre indicadores económicos.

**Fuentes posibles**:

- histórico de precios o indicadores;
- IPC, salarios, empleo u otros datos públicos;
- noticias, calendarios o eventos externos si están disponibles.

**Qué obliga a trabajar**:

- integración temporal;
- normalización de fuentes heterogéneas;
- análisis de correlación o predicción sencilla;
- dashboard con métricas técnicas y resultados interpretables.

---

## Criterios para aceptar una propuesta

Una idea es válida si permite demostrar:

- al menos **dos fuentes de datos**;
- ingesta reproducible;
- almacenamiento en capas o estructura equivalente;
- calidad y anonimización completada;
- procesamiento no trivial;
- dashboard técnico o vista de seguimiento;
- justificación de herramientas, coste y limitaciones.

No se aceptan proyectos basados sólo en descargar un CSV, hacer tres gráficas y
entrenar un modelo sin sentido técnico.
