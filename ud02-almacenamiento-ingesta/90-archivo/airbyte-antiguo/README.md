# Material Airbyte archivado

Este material usaba **Airbyte** (versiones 0.50.50 y anteriores) como herramienta
ELT principal. Se ha reemplazado por **dlt** como Ruta A de la práctica de
integración (ver `03-practicas/Tareas/005/00-Integracion_y_calidad/`).

## Contenido

| Archivo | Original |
|---------|----------|
| `005-IntegracionTransferenciaDatos-II_Actividades.md` | Tasks/005/ (II - Airbyte Cloud) |
| `005-IntegracionTransferenciaDatos-III_ActividadAmpliada.md` | Tasks/005/ (III - Airbyte + Redpanda) |
| `005-IntegracionTransferenciaDatos-IV-EC2.md` | Tasks/005/ (IV - EC2 annex) |
| `historico/` | Tasks/005/_profesor/historico/ (versiones descartadas) |

## Razón del archivado

- Airbyte 0.50.50 está deprecado. La versión 1.0+ requiere Kubernetes.
- dlt (`pip install dlt`) es más ligero, Python-nativo y didáctico.
- La práctica consolidada (`00-Integracion_y_calidad/`) ahora usa dlt como Ruta A.

## Material que se conserva en Tareas/005

- `00-Integracion_y_calidad/` — práctica consolidada (Ruta A: dlt, Ruta B: Python + DuckDB)
- `_profesor/operativa/airbyte_docker_compose.md` — documentación de la alternativa Airbyte (referencia)
- `_profesor/operativa/ec2-airbyte.txt` — notas de despliegue Airbyte en EC2
- `_profesor/redpanda-python/` — scripts de Redpanda (todavía válidos)
