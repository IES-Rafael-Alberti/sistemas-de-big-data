# Guía docente — UD1 · Parte 5 · Ingesta de datos

## Propósito de la actividad
Consolidar los fundamentos de **ingesta y preparación de datos** antes de entrar en la UD2 (pipelines completos).  
El alumnado debe comprender el flujo *fuente → raw → curated → BI/ML*, las reglas de calidad y el porqué de cada decisión.

## Competencias / RA asociados
- **RA1:** aplicar técnicas de análisis e integración de datos (a, b, d, g).  
- **RA3:** gestionar y almacenar datos facilitando búsquedas y análisis (a–c).

## Objetivos específicos
1. Comprender los modos de ingesta (batch, micro-batch, streaming).  
2. Diferenciar ETL vs ELT y sus implicaciones.  
3. Practicar validaciones básicas de calidad (nulos, dominios, tipos, duplicados).  
4. Exportar datasets en formato **Parquet particionado**.  
5. Documentar y justificar decisiones de limpieza.

## Plan de aula
| Sesión | Actividad principal | Duración | Resultado |
|--------:|--------------------|----------:|------------|
| 1 | Explicación teórica + demostración (ingesta CSV → Parquet) | 45 min | Comprensión de ETL/ELT |
| 2 | Mini-práctica P5 individual o en parejas | 60 min | Dataset limpio y particionado |
| 3 | Puesta en común y revisión de informes | 30 min | Retroalimentación colectiva |

## Entregables esperados
- `ingesta_<dataset>.py` o `.ipynb`  
- `README_ingesta.md` rellenado  
- Carpeta `data_lake/curated/<dataset>/` con subcarpetas `anio=YYYY/mes=MM/`

## Rúbrica orientativa (/10)
| Criterio | Descripción | Peso |
|-----------|--------------|------|
| **1. Limpieza y validación** | Tratamiento correcto de nulos, tipos, rangos | 4 |
| **2. Exportación** | Parquet particionado y legible | 3 |
| **3. Documentación** | README completo y coherente | 2 |
| **4. Claridad del código** | Comentarios y reproducibilidad | 1 |

## Extensiones opcionales
- Ingesta desde **API pública** (paginación y rate limit).  
- Comparativa CSV vs Parquet → tiempo y tamaño.  
- (Avanzado) Ingesta incremental por `updated_at`.

## Evaluación y realimentación
- Revisión automática parcial (comprobación de archivos).  
- Revisión manual centrada en calidad de datos y documentación.  
- Retroalimentación cualitativa con ejemplos de buenas prácticas.

## Conexiones con UD2 y otros módulos
- En **UD2** se reutiliza el dataset para construir pipelines (Airbyte, MinIO, Postgres).  
- En **SBD Aplicado**, se integrará con **Spark** y **Superset/Metabase** para BI.

## Material de apoyo
- Archivos `.org` y `.pptx` originales de la unidad.  
- Librerías recomendadas: `pandas`, `pyarrow`, `duckdb`.  
- Lecturas complementarias:
  - *Designing Data-Intensive Applications* — Kleppmann (2017)  
  - *Data Pipelines Pocket Reference* — Hembree (O’Reilly 2022)

---

📘 **Uso:** coloca este documento junto con  
`Parte5_Ingesta.md`, `README_ingesta.md`, `ingesta_base.py`  
para tener la carpeta del laboratorio completa.

