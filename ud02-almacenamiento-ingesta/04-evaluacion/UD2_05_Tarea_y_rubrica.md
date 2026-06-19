# UD2 · Tarea guiada y rúbrica (Ingesta e Integración)

> **RA/CE**: RA1.c (combinar fuentes), RA3.a (extraer y almacenar),
> RA3.d (sistemas eficientes, seguros y normativa), RA4.e (procesar automáticamente).

> **Problema:** necesitas **unificar** turismo (CSV) y ventas (API) con **calidad mínima** y **publicación D+1** hacia Parquet/BI o Postgres.

## Objetivo
Pipeline reproducible: **ingesta → raw Parquet → integración/curado → (opcional) Postgres** con linaje y RGPD.

## Entregables
- `/ingest` con scripts o config Airbyte + `.env.example`
- `/data_lake/raw/` y `/data_lake/curated/parquet/` (particionado)  
- `integrate/merge_curate.sql` (DuckDB) o notebook equivalente  
- `README_RGPD.md` (búsqueda de datos personales/identificadores y anonimización completada: por ausencia de identificadores o por medidas aplicadas)  
- Diagrama de **linaje** (mermaid/png)  
- (Opc.) **carga a Postgres** (`schema.sql` + comando de carga)

## Rúbrica (/10)
- (2) Ingesta correcta (2 fuentes) e idempotente  
- (2) Curado/Integración (joins correctos + reglas de calidad)  
- (2) Parquet/particionado + evidencia de lectura  
- (2) Linaje claro + logs/capturas  
- (1) RGPD (búsqueda de identificadores + anonimización completada)  
- (1) (Opc.) Carga a Postgres/BI operativa

## Checklist
- [ ] `.env` sin secretos en repo  
- [ ] Reprocesado re-escribe solo particiones afectadas  
- [ ] Consultas DuckDB sobre Parquet OK  
- [ ] Linaje y RGPD actualizados
- [ ] No se publican datos que permitan identificar directa o indirectamente a una persona
