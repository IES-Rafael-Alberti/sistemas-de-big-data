# Práctica de aula · Primera carga con dlt y DuckDB

**Carácter:** formativa, sin entrega ni rúbrica nueva. **Estado:** comprobada
en una carpeta temporal con `sbd-lab` en el equipo docente; pendiente de
comprobar en el entorno del aula.

## Situación

Un servicio web nos entrega tres eventos sintéticos. Cada registro es una
petición: `evento_id` identifica el evento y `duracion_ms` es el tiempo de
respuesta en milisegundos. Queremos cargar el lote y comprobar su contenido.
El origen son datos incluidos en el script: no hay API ni red durante la carga.

## Preparación

Trabaja en una **carpeta nueva y propia**, distinta de cualquier práctica en
curso. Python debe tener las bibliotecas `dlt` y `duckdb`; el profesor comprobará
el entorno antes de clase. Si faltan, pide indicaciones antes de instalar.
El ejemplo crea una base de datos y estado de dlt; no lo ejecutes en una carpeta
con datos que quieras conservar sin comprobar las rutas.

La comprobación docente usó el entorno Conda `sbd-lab`: Python 3.12.16,
dlt 1.30.0 y DuckDB 1.5.6 tanto para Python como para la CLI. Se verificó que
ambas interfaces leen la base de la práctica. Sigue pendiente comprobar el
entorno del aula.

### Entorno Conda reproducible

`environment.yml`, junto a este README, declara las versiones principales
comprobadas y usa únicamente `conda-forge`. No es un archivo de bloqueo completo:
las dependencias indirectas pueden variar y hay que comprobar el entorno después
de crearlo. No se necesita instalar paquetes con pip.

Si **no existe** `sbd-lab`, desde la carpeta de esta práctica se puede crear con:

```bash
conda env create -f environment.yml
conda activate sbd-lab
```

Si `sbd-lab` **ya existe**, no ejecutar automáticamente `conda env create` ni
actualizarlo a ciegas: consultar primero sus versiones y dependencias. El
profesor decidirá cómo armonizarlo sin perjudicar otras prácticas.

## 1. Crear la carga

Crea `primera_carga.py` en tu carpeta de trabajo:

```python
import dlt

eventos = [
    {"evento_id": "e01", "duracion_ms": 120},
    {"evento_id": "e02", "duracion_ms": 340},
    {"evento_id": "e03", "duracion_ms": 280},
]

pipeline = dlt.pipeline(
    pipeline_name="ejemplo_eventos_ud2",
    destination="duckdb",
    dataset_name="bronze",
)
info = pipeline.run(eventos, table_name="eventos", write_disposition="replace")
print(info)
```

Antes de ejecutarlo, predice cuántas filas debería tener la tabla. Ejecuta
`python primera_carga.py` y lee el resultado de la carga. Usamos `replace`
deliberadamente para **este lote de demostración**, no como recomendación
universal: reemplaza el contenido previo de esa tabla.

## 2. Comprobar y modificar

Crea `consultar.py` en la misma carpeta:

```python
import duckdb

with duckdb.connect("ejemplo_eventos_ud2.duckdb") as conexion:
    print(conexion.execute(
        "SELECT evento_id, duracion_ms FROM bronze.eventos ORDER BY evento_id"
    ).fetchall())
```

Ejecuta `python consultar.py`. Se esperan tres eventos. Vuelve a ejecutar la
carga y la consulta: ¿siguen siendo tres? Después añade un cuarto evento a tu
script, ejecuta y comprueba de nuevo. Explica qué sucedería si ese reemplazo se
aplicase a una tabla que contiene otros lotes que interesa conservar.

## 3. Interpretar

Anota fuente, destino, modo de escritura, resultado de cada ejecución y una
limitación. **No hemos implementado una carga incremental ni demostrado
idempotencia general**: hemos observado el reemplazo de una tabla en un caso
pequeño. El ejercicio posterior de integración se tratará por separado.

Si falla el entorno, registra el mensaje y sigue la secuencia con los tres
registros en papel. No presentes una salida prevista como ejecución realizada.
