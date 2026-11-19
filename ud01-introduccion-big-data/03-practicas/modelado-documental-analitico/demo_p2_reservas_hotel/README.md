# Demo docente P2: reservas de hotel

Demo independiente: no modifica `lab_p2_modelado_documental_analitico`. Datos ficticios, anonimizados y reproducibles (semilla `20261029`), con 24 reservas, 3 hoteles, 4 canales, extras y estados coherentes.

```bash
cd ud01-introduccion-big-data/03-practicas/modelado-documental-analitico/demo_p2_reservas_hotel
mamba run -n sbd-lab python genera_demo.py
mamba run -n sbd-lab duckdb -no-agent -c ".read demo_duckdb.sql"
```

Se crean `data/reservas.ndjson` (documentos anidados), `data/reservas_elementos.csv` (una fila por habitación/extra) y `data/reservas_elementos.parquet`. DuckDB muestra conteo, estados, ingresos por canal y estancia por ciudad.

MongoDB opcional:
```bash
docker run -d --name sbd-demo-mongo -p 27017:27017 mongo:6
docker cp data/reservas.ndjson sbd-demo-mongo:/tmp/reservas.ndjson
docker exec sbd-demo-mongo mongoimport --db sbd_demo --collection reservas --drop --file /tmp/reservas.ndjson
docker exec -i sbd-demo-mongo mongosh < demo_mongodb.js
```
El script recupera una reserva y agrega ingresos por canal/mes. La práctica real deja al alumnado decidir el modelado; esta demo ofrece un ejemplo pequeño para la explicación docente, sin resolver ni contaminar sus datos.

La misma consulta desde Python, usando PyMongo:

```bash
mamba install -n sbd-lab -c conda-forge pymongo --yes
mamba run -n sbd-lab python demo_mongodb_python.py
```

Para eliminar el contenedor al terminar:

```bash
docker rm -f sbd-demo-mongo
```
