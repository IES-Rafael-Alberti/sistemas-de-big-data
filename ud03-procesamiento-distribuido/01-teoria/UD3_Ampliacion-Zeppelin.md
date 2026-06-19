
---

## Actividad de ampliación — **Lab “Zeppelin 101 con Spark”** (3 h)

**Ubicación en la UD3:** Semana **12** (tras particionado, `cache()` y `explain()`, antes del informe de rendimiento de la semana 13).
**Naturaleza:** ampliación **opcional/evaluable** para experimentación rápida con Spark+SQL+gráficos.
**Ponderación dentro de UD3:** **10–15 %** de la nota de la UD3 (si no se realiza, se puede cubrir con la alternativa sin Zeppelin indicada abajo).

### Resultados de aprendizaje vinculados

* **RA1:** b) extracción y análisis a escala; d) construcción/relación de datasets complejos; f) integración de sistemas; g) criterios de coste/calidad.
* **RA3:** a) extracción/almacenamiento multi-fuente; d) gestión/procesamiento eficiente y seguro.
* **RA4:** d) diferencias entre entornos de procesamiento; f) visualización para análisis/presentación.

### Objetivos específicos

* Ejecutar consultas **Spark SQL** sobre Parquet/Delta y visualizar resultados en el propio cuaderno.
* Crear **formularios** (parámetros) para filtros dinámicos sin desarrollar una app.
* Medir el efecto de **cache/particionado** en tiempos de consulta y documentarlo.

### Contenidos y actividades

1. **Arranque Zeppelin** y configuración del intérprete **%spark** (vinculado al Master).
2. **Lectura** de datos del data lake (Parquet/Delta; local o MinIO vía `s3a://`).
3. **Vistas temporales** y consultas con **%sql** (3 KPIs: por tiempo, por categoría, y un top-k).
4. **Gráficos** integrados (líneas/barras) y **formularios** (`z.input`, `z.select`) para parametrizar fechas/categorías.
5. *(Opcional)* **%jdbc** a Postgres para enriquecer con dimensiones.
6. Mini-benchmark: antes/después de `cache()` o cambio de particionado; anotar tiempos.

### Requisitos

* **Spark** (standalone) operativo en aula (1 Master + ≥1 Worker).
* **Zeppelin** ≥ 0.10 configurado con intérprete Spark y (opcional) JDBC.
* Dataset **Parquet/Delta particionado** preparado en la UD3.
* Buenas prácticas de seguridad: **no** subir credenciales; variables en `.env`.

### Entregables

* Cuaderno **`.zpln`** con:

  1. conexión a Spark y lectura Parquet/Delta;
  2. **3 consultas** `%sql` sobre vistas;
  3. **2 visualizaciones** (línea/barra) correctas;
  4. **1 formulario** que parametriza al menos un filtro;
  5. **nota de rendimiento** (2–5 líneas) comparando tiempos con/ sin `cache()` o distinto particionado.
* Export del cuaderno y **2–3 capturas** de los KPIs.

### Rúbrica rápida (/10)

* **2** · Conexión a Spark + lectura correcta del lake.
* **3** · Consultas `%sql` correctas y relevantes (JOIN/AGG/filtros).
* **2** · Visualizaciones adecuadas (ejes/etiquetas, KPIs legibles).
* **1** · Formulario funcional (parámetros que afectan a la consulta).
* **1** · Evidencia de rendimiento (medidas + breve interpretación).
* **1** · Orden/claridad del cuaderno (títulos, pasos, sin credenciales).

### Alternativa sin Zeppelin (sustitutiva)

Si no se usa Zeppelin, el alumno entregará un **notebook Jupyter** que reproduzca:

* Lectura Parquet/Delta y creación de **vistas** con **DuckDB** o Spark SQL.
* **3 KPIs** equivalentes y **2 visualizaciones**.
* Mini-benchmark con `cache()`/particionado + nota de rendimiento.
  *(Se aplica la misma rúbrica adaptada al entorno.)*

### Checklist docente (sí/no)

* [ ] Cuaderno `.zpln` ejecuta en el clúster (o notebook Jupyter alternativo).
* [ ] 3 consultas `%sql` no triviales (como mínimo 1 agregación + 1 JOIN/ventana).
* [ ] 2 visualizaciones interpretables con títulos/ejes correctos.
* [ ] 1 formulario que parametriza filtros/fechas/categorías.
* [ ] Medición de rendimiento y explicación breve.
* [ ] Sin secretos en texto claro; uso de `.env`/variables.

---

Cuando lleguemos a la UD3 preparo el **cuaderno Zeppelin preconfigurado (.zpln)**, y si quieres, un **docker-compose** opcional con Spark Master/Worker + Zeppelin y la guía “bare-metal” para el aula.