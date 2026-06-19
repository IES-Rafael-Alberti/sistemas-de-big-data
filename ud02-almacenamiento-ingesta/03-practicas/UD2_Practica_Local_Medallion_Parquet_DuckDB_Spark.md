# UD2 — Práctica local: ingesta → Parquet → DuckDB/Spark con arquitectura Medallion

## Objetivo

Construir un pipeline local y reproducible que aterrice la arquitectura trabajada en UD1:

```text
fuentes CSV/JSON → Bronze → Silver → Gold → consulta técnica
```

No usamos cloud. No usamos servicios gestionados. Primero hay que entender el sistema con herramientas controlables en aula. DESPUÉS ya tendrá sentido hablar de S3, Glue, Athena, Databricks o similares.

## Resultado esperado

Al terminar la práctica tendrás:

- datos raw generados localmente;
- una zona **Bronze** con datos originales convertidos a Parquet;
- una zona **Silver** con datos limpios, tipados y cruzados;
- una zona **Gold** con KPIs listos para consultar;
- consultas con DuckDB;
- comparación opcional con Spark/PySpark;
- una breve justificación técnica de coste, calidad y viabilidad.

## Relación curricular

- **RA1.c-d**: combinación de fuentes y construcción de datasets complejos.
- **RA1.f-g**: selección de sistemas y valoración coste/calidad.
- **RA3.a-d**: extracción, almacenamiento, procesamiento eficiente y seguro.
- **RA4.d-f**: procesamiento automático y visualización/consulta de resultados.

## Herramientas

Ruta recomendada:

- Python
- pandas
- pyarrow
- DuckDB

Ampliación:

- PySpark

Instalación mínima:

```bash
python -m venv .venv
source .venv/bin/activate
pip install pandas pyarrow duckdb
```

Si se va a probar Spark:

```bash
pip install pyspark
```

## Datos de partida

Usaremos un caso de zona turística similar al de arquitectura:

| Fuente | Formato | Descripción |
| ------ | ------- | ----------- |
| `ventas.csv` | CSV | ventas por comercio y día |
| `reservas.jsonl` | JSON Lines | reservas de alojamientos |
| `meteo.csv` | CSV | meteorología diaria |
| `zonas.csv` | CSV | catálogo de zonas y tipos |

Genera los datos con:

```bash
python ud02-almacenamiento-ingesta/05-recursos/practica-local-medallion/generar_datos_turismo.py
```

El script crea:

```text
datos/practica_medallion/raw/
```

## Estructura de carpetas de trabajo

Crea esta estructura:

```text
datos/practica_medallion/
├── raw/
├── bronze/
├── silver/
└── gold/
```

La carpeta `raw/` contiene las fuentes originales. Las demás las generas durante la práctica.

## Fase 1 — Ingesta raw

Comprueba los archivos generados:

```bash
find datos/practica_medallion/raw -type f -maxdepth 1
```

Responde:

1. ¿Qué fuentes son estructuradas?
2. ¿Qué fuente tiene estructura semiestructurada?
3. ¿Qué campos podrían dar problemas de calidad?
4. ¿Qué campos permiten cruzar fuentes?

## Fase 2 — Bronze

Bronze debe conservar los datos de entrada con mínima transformación.

Tarea:

1. Lee cada fuente.
2. Convierte cada una a Parquet.
3. Guarda en:

```text
datos/practica_medallion/bronze/ventas/
datos/practica_medallion/bronze/reservas/
datos/practica_medallion/bronze/meteo/
datos/practica_medallion/bronze/zonas/
```

Ejemplo orientativo:

```python
from pathlib import Path
import pandas as pd

base = Path('datos/practica_medallion')
raw = base / 'raw'
bronze = base / 'bronze'

ventas = pd.read_csv(raw / 'ventas.csv')
ventas.to_parquet(bronze / 'ventas' / 'ventas.parquet', index=False)
```

OJO: tendrás que crear las carpetas antes de escribir.

### Evidencia Bronze

Entrega una tabla:

| Fuente | Filas | Columnas | Formato original | Formato Bronze |
| ------ | ----: | -------: | ---------------- | -------------- |

## Fase 3 — Silver

Silver debe limpiar, tipar y cruzar datos.

Tareas mínimas:

1. Convertir fechas a tipo fecha.
2. Eliminar o marcar ventas con importe negativo.
3. Normalizar nombres de zona.
4. Cruzar ventas con catálogo de zonas.
5. Cruzar ventas agregadas con meteorología por fecha.
6. Crear columnas derivadas:
   - `importe_total`
   - `unidades_totales`
   - `temperatura_media`
   - `lluvia_total`

Guarda como:

```text
datos/practica_medallion/silver/actividad_diaria/actividad_diaria.parquet
```

### Reglas de calidad obligatorias

Documenta al menos estas reglas:

| Regla | Acción |
| ----- | ------ |
| fecha nula | rechazar o marcar |
| zona desconocida | marcar como `zona_no_catalogada` |
| importe negativo | excluir de métricas Gold y registrar incidencia |
| unidades menores que 0 | excluir de métricas Gold y registrar incidencia |
| reserva sin zona | marcar incidencia |

## Fase 4 — Gold

Gold debe contener datos listos para consulta.

Crea al menos estos datasets:

```text
datos/practica_medallion/gold/kpis_diarios/kpis_diarios.parquet
datos/practica_medallion/gold/kpis_zona/kpis_zona.parquet
```

KPIs mínimos:

| KPI | Descripción |
| --- | ----------- |
| `ventas_totales` | suma de importes válidos |
| `unidades_totales` | suma de unidades válidas |
| `reservas_totales` | número de reservas |
| `ocupacion_media` | ocupación media diaria o por zona |
| `temperatura_media` | temperatura media asociada |
| `dias_lluvia` | días con lluvia |

## Fase 5 — Consulta con DuckDB

Consulta los Parquet directamente:

```python
import duckdb

con = duckdb.connect()

con.sql("""
SELECT *
FROM 'datos/practica_medallion/gold/kpis_diarios/kpis_diarios.parquet'
ORDER BY fecha
LIMIT 10
""").show()
```

Consultas obligatorias:

1. Top 5 días por ventas.
2. Ventas por zona.
3. Relación entre lluvia y ventas.
4. Días con alta ocupación y baja venta.
5. Incidencias detectadas en Silver.

## Fase 6 — Ampliación con Spark/PySpark

Repite una parte del pipeline con Spark:

- leer Bronze Parquet;
- crear Silver con transformaciones básicas;
- generar un Gold simple;
- comparar dificultad, rendimiento y coste de uso frente a DuckDB.

No se trata de demostrar que Spark “siempre es mejor”. Eso es falso. Se trata de justificar cuándo merece la pena.

## Entregable

Entrega un documento Markdown con esta estructura:

```md
# Práctica UD2 — Pipeline local Medallion

## 1. Descripción del pipeline

## 2. Estructura Bronze/Silver/Gold

## 3. Reglas de calidad aplicadas

## 4. Consultas DuckDB y resultados

## 5. Comparación DuckDB vs Spark/PySpark

## 6. Coste, calidad y viabilidad

## 7. Problemas encontrados

## 8. Conclusión técnica
```

Incluye capturas sólo si aportan evidencia. No quiero decoración: quiero decisiones técnicas.

## Rúbrica rápida

| Criterio | Peso |
| -------- | ---: |
| Pipeline Bronze/Silver/Gold reproducible | 25% |
| Limpieza, tipado y reglas de calidad | 20% |
| Uso correcto de Parquet y DuckDB | 20% |
| Consultas técnicas y análisis de resultados | 15% |
| Justificación coste/calidad/viabilidad | 10% |
| Comparación opcional con Spark/PySpark | 10% |

## Cierre conceptual

Esta práctica conecta tres ideas clave:

1. **Arquitectura**: Bronze/Silver/Gold no es teoría; organiza responsabilidades.
2. **Formato**: Parquet no es una moda; mejora almacenamiento y lectura analítica.
3. **Motor**: DuckDB y Spark resuelven problemas distintos según tamaño, infraestructura y coste.

Si entiendes esto, estás pensando como alguien que diseña sistemas de datos, no como alguien que sólo ejecuta notebooks.

## Referencias de apoyo

- Aitor Medrano — Formatos de datos: https://aitor-medrano.github.io/iabd/de/formatos.html
- Aitor Medrano — Apache Spark: https://aitor-medrano.github.io/iabd/spark/spark.html
- Aitor Medrano — Arquitecturas Big Data: https://aitor-medrano.github.io/iabd/de/arq.html
- DuckDB Documentation: https://duckdb.org/docs/
- Apache Spark Documentation: https://spark.apache.org/docs/latest/
