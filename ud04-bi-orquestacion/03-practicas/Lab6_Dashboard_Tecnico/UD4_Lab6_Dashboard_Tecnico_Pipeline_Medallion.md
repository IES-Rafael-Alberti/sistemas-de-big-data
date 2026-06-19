# UD4 — Laboratorio 6: Dashboard técnico de monitorización de pipeline

> **Enfoque**: Dashboard técnico/operativo. No es BI de negocio.
> Supervisamos la salud del pipeline de datos, no las ventas.
>
> **RA/CE**: RA2.c (cuadro de mando técnico), RA2.d* (técnicas predictivas),
> RA2.e (evaluar impacto), RA4.f (visualizar datos).
>
> *RA2.d cubierto por la ampliación predictiva (sección 10).
>
> **Duración estimada**: 2-3 sesiones.
>
> **Entrega**: Individual o parejas. PDF con capturas del dashboard +
> respuestas a las preguntas de reflexión.

---

## 1. Objetivo

Construir un **dashboard técnico** que monitorice el estado de un pipeline de datos
Medallion (Bronce → Silver → Gold). Vas a usar los datos generados en la UD2 y
cargarlos en Metabase para crear visualizaciones que respondan preguntas como:

- ¿Cuántos registros hay en cada capa del pipeline?
- ¿Hay errores o nulos en los datos?
- ¿El pipeline funciona correctamente?
- ¿Cuánto tiempo tarda cada etapa?

Este enfoque es el que usaría un **data engineer** para supervisar que el sistema
de datos funciona correctamente, antes de que un analista de negocio toque los datos.

---

## 2. Diferencia con BI de negocio

| Dimensión | BI de negocio (BDA) | Dashboard técnico (SBD) |
|-----------|--------------------|------------------------|
| Pregunta | ¿Suben las ventas? | ¿El pipeline funciona? |
| Usuario | Analista de negocio | Data engineer |
| Métricas | KPIs de negocio | Caudal, calidad, errores |
| Herramientas | Power BI, Tableau | Metabase, Grafana |
| Fuente | Datos Gold (finales) | Todas las capas + metadatos |

En este laboratorio trabajamos en la columna derecha. El BI de negocio se verá
en el módulo de **Big Data Aplicado**.

---

## 3. Requisitos

- Docker y docker-compose.
- Python 3.10+ con `pip install psycopg2-binary pandas pyarrow`.
- Datos generados por la práctica Medallion de UD2.

Si no tienes los datos, ejecuta desde la raíz del repositorio:

```bash
python ud02-almacenamiento-ingesta/05-recursos/practica-local-medallion/generar_datos_turismo.py
```

---

## 4. Montaje

### 4.1 Arrancar Metabase con PostgreSQL

```bash
cd ud04-bi-orquestacion/03-practicas/Lab1_Metabase
docker compose -f docker-compose-bi.yml up -d
```

Esto levanta:
- PostgreSQL en `localhost:5433` (usuario `bi_user`, contraseña `bi_pass`, db `bi_db`).
- Metabase en `http://localhost:3001`.

### 4.2 Cargar los datos del pipeline

```bash
python ud04-bi-orquestacion/05-recursos/dashboard-tecnico-medallion/load_pipeline_data.py
```

El script:
1. Lee los CSV/JSONL generados en UD2.
2. Los carga en PostgreSQL como tablas `bronze_*`.
3. Crea la tabla `pipeline_metadata` con históricos ficticios de 5 días.
4. Crea la tabla `calidad_log` con chequeos de calidad.
5. Crea la vista `gold_resumen_pipeline` para el dashboard.

### 4.3 Conectar Metabase

1. Abre `http://localhost:3001`.
2. Regístrate (es local, cualquier email vale).
3. Añadir base de datos → PostgreSQL:
   - Host: `postgres` (nombre del contenedor)
   - Puerto: `5432`
   - Base de datos: `bi_db`
   - Usuario: `bi_user`
   - Contraseña: `bi_pass`

---

## 5. Construcción del dashboard técnico

Crea las siguientes preguntas (questions) en Metabase y agrúpalas en un dashboard.

### Pregunta 1 — Registros por capa del pipeline (barra)

Usa la tabla `pipeline_metadata`.

- **Visualización**: Barras agrupadas.
- **Eje X**: `fecha_carga`.
- **Eje Y**: Suma de `registros`.
- **Serie**: `capa` (bronze, silver, gold).
- **Objetivo**: Ver si el caudal de datos se mantiene estable en el tiempo.

### Pregunta 2 — Calidad del pipeline (indicador)

Usa la tabla `calidad_log`.

- **Filtro**: `check_name = 'nulos detectados'`.
- **Visualización**: Número (scalar) con el total de nulos.
- **Condicional**: Si > 0, mostrar en rojo.
- **Objetivo**: Detectar problemas de calidad al instante.

### Pregunta 3 — Duración de carga por capa (líneas)

Usa la tabla `pipeline_metadata`.

- **Visualización**: Líneas.
- **Eje X**: `fecha_carga`.
- **Eje Y**: Media de `duracion_seg`.
- **Serie**: `capa`.
- **Objetivo**: Detectar si una capa está degradándose en rendimiento.

### Pregunta 4 — Proporción de calidad válida (donut/tarta)

Usa la tabla `pipeline_metadata`.

- **Visualización**: Tarta.
- **Dimensión**: `calidad_valida`.
- **Métrica**: Conteo.
- **Objetivo**: % de ejecuciones del pipeline que pasaron controles de calidad.

### Pregunta 5 — Resultados de chequeos de calidad (tabla)

Usa la tabla `calidad_log`.

- **Visualización**: Tabla.
- **Columnas**: `tabla`, `check_name`, `resultado`, `valor`, `fecha_check`.
- **Orden**: Por `fecha_check` descendente.
- **Objetivo**: Auditoría detallada de cada chequeo.

### Pregunta 6 — Evolución temporal de registros Gold (área)

Usa la tabla `pipeline_metadata`. Filtro: `capa = 'gold'`.

- **Visualización**: Área.
- **Eje X**: `fecha_carga`.
- **Eje Y**: `registros`.
- **Objetivo**: Ver si el volumen de datos finales crece o se mantiene.

---

## 6. Dashboard final

Agrupa las 6 preguntas en un solo dashboard. Organízalo en dos filas:

```
Fila 1: [P1 Barras]        [P2 Indicador]     [P4 Tarta]
Fila 2: [P3 Líneas]        [P6 Área]          [P5 Tabla]
```

Añade un filtro por fecha en el dashboard para poder segmentar.

---

## 7. Preguntas de reflexión

Responde después de construir el dashboard:

1. **¿Qué capa del pipeline tiene más registros? ¿Es esperable?**
2. **¿Hay algún día con problemas de calidad? ¿Cómo lo detectaste?**
3. **¿Qué capa tarda más en procesarse? ¿Por qué crees que ocurre?**
4. **Si este pipeline fuera producción, ¿qué alerta configurarías primero?**
5. **¿Qué diferencia hay entre este dashboard técnico y uno de negocio?**
6. **¿Podrías usar las mismas preguntas para un dataset diferente? ¿Qué cambiaría?**

---

## 8. Criterios de evaluación

| Criterio | Peso | Excelente (4) | Notable (3) | Aprobado (2) | Insuficiente (1) |
| -------- | ---- | ------------- | ----------- | ------------ | ---------------- |
| **Dashboard completo** | 30% | 6 preguntas + dashboard organizado | 5-6 preguntas | 3-4 preguntas | < 3 preguntas |
| **Conexión técnica** | 20% | Conecta Metabase a PostgreSQL sin errores | Conecta con ayuda menor | Conecta con ayuda significativa | No conecta |
| **Interpretación** | 30% | Responde con análisis crítico, detecta anomalías | Responde correctamente | Respuestas genéricas | Sin respuestas |
| **Comprensión conceptual** | 20% | Explica claramente la diferencia dashboard técnico vs BI negocio | Diferencia conceptual correcta | Confusión parcial | No diferencia |

---

## 9. Ampliación opcional (si sobra tiempo)

Repite el laboratorio usando **Apache Superset** en lugar de Metabase:

```bash
cd ud04-bi-orquestacion/03-practicas/Lab2_Superset
docker compose -f docker-compose-superset-light.yml up -d
```

La conexión a PostgreSQL es similar. La diferencia principal: Superset permite
gráficos más complejos y SQL Lab para consultas ad-hoc.

¿Qué herramienta prefieres para un dashboard técnico? ¿Por qué?

---

---

## 10. Ampliación: predicción en el dashboard (RA2.d)

La técnica predictiva más directa sobre un pipeline de datos es la **previsión
del volumen esperado**. Saber cuántos registros debería procesar el pipeline
mañana te permite detectar anomalías (si llegan muchos menos de los esperados,
algo puede estar roto).

### 10.1 Predicción simple con media móvil

Añade una séptima pregunta a tu dashboard:

> **Pregunta 7 — Previsión de registros para mañana**
>
> Usando los datos históricos de `pipeline_metadata`, calcula la media de
> registros de los últimos 3 días. Esa es tu predicción para mañana.
> Añade una serie en el dashboard que muestre: valor real + predicción.

En SQL:

```sql
SELECT
    fecha_ejecucion,
    registros_procesados,
    AVG(registros_procesados) OVER (
        ORDER BY fecha_ejecucion
        ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
    ) AS prediccion_mañana
FROM pipeline_metadata
ORDER BY fecha_ejecucion;
```

Esto ya es una **técnica predictiva** (media móvil, usada en forecasting
de series temporales). No necesitas Spark ni ML — a veces una media móvil
bien entendida es más útil que un modelo complejo.

### 10.2 Predicción con regresión lineal (conexión UD5)

Si has hecho el LAB1 de Spark MLlib (regresión), puedes exportar las
predicciones del modelo a PostgreSQL y visualizarlas en el mismo dashboard:

```bash
# Desde el LAB1 de Spark MLlib, guarda predicciones a CSV
predicciones.to_csv("predicciones_mañana.csv")
# Cárgalas a PostgreSQL
python -c "
import pandas as pd
from sqlalchemy import create_engine

df = pd.read_csv('predicciones_mañana.csv')
engine = create_engine('postgresql://user:pass@localhost:5432/medallion')
df.to_sql('predicciones_ml', engine, if_exists='replace', index=False)
"
```

Luego conecta Metabase a esa tabla y añade una visualización comparando
valor real vs predicción ML.

### 10.3 Preguntas de reflexión

1. **¿Qué ventaja tiene una media móvil frente a un modelo de regresión
   para predecir el volumen de un pipeline?** ¿Y qué ventaja tiene la
   regresión?

2. **¿Cómo detectarías una anomalía** (p.ej., el pipeline procesó 10×
   menos registros de lo esperado) usando estas predicciones?

3. **¿Esta predicción sería útil para un dashboard de BI de negocio?**
   ¿Por qué sí o no?

### 10.4 Cobertura curricular

Esta sección cubre **RA2.d**: "Se han utilizado técnicas predictivas
complejas para anticiparse a lo que ocurra." Has aplicado dos técnicas
(media móvil y regresión lineal) para predecir el comportamiento del
pipeline y detectar anomalías. No se trata de construir el mejor modelo,
sino de **integrar la predicción en un cuadro de mando** para la toma
de decisiones técnicas.

---

## Histórico de cambios

| Fecha       | Cambio |
| ----------- | ------ |
| 2026-06-18 | Creación del laboratorio de dashboard técnico. |
| 2026-06-18 | Añadida sección 10: predicción en el dashboard (RA2.d). |
