#!/usr/bin/env bash
set -euo pipefail
LAB_DIR="lab_kibana_observabilidad"
mkdir -p "$LAB_DIR"/{logstash/pipeline,data,es,scripts}
cat > "$LAB_DIR/docker-compose.yml" <<'YAML'
version: "3.9"
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.13.4
    container_name: es-single
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - ES_JAVA_OPTS=-Xms2g -Xmx2g
    ports:
      - "9200:9200"
    volumes:
      - esdata:/usr/share/elasticsearch/data
  kibana:
    image: docker.elastic.co/kibana/kibana:8.13.4
    container_name: kibana
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
  logstash:
    image: docker.elastic.co/logstash/logstash:8.13.4
    container_name: logstash
    environment:
      - LS_JAVA_OPTS=-Xms1g -Xmx1g
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline:ro
      - ./data:/data
    depends_on:
      - elasticsearch
volumes:
  esdata:

YAML
cat > "$LAB_DIR/logstash/pipeline/logstash.conf" <<'CONF'
input {
  file {
    path => "/data/logs.csv"
    start_position => "beginning"
    sincedb_path => "/usr/share/logstash/sincedb.db"
    mode => "read"
  }
}
filter {
  csv {
    separator => ","
    autodetect_column_names => false
    columns => ["@timestamp","host","service","level","message","latency_ms","lat","lon"]
  }
  mutate { convert => {"latency_ms" => "integer" "lat" => "float" "lon" => "float"} }
  date { match => ["@timestamp", "ISO8601"] target => "@timestamp" }
  mutate { add_field => { "location" => "%{lat},%{lon}" } }
}
output {
  elasticsearch { hosts => ["http://elasticsearch:9200"] index => "logs-sim-%{+YYYY.MM.dd}" }
  stdout { codec => rubydebug }
}

CONF
cat > "$LAB_DIR/es/es_index_template.json" <<'JSON'
{
  "index_patterns": [
    "logs-sim-*"
  ],
  "template": {
    "mappings": {
      "properties": {
        "location": {
          "type": "geo_point"
        },
        "latency_ms": {
          "type": "integer"
        },
        "@timestamp": {
          "type": "date"
        }
      }
    }
  },
  "priority": 500
}
JSON
cat > "$LAB_DIR/scripts/devtools_template.md" <<'MD'
# Dev Tools — crear plantilla de índice
PUT _index_template/logs_sim_template
{
  "index_patterns": ["logs-sim-*"],
  "template": {
    "mappings": {
      "properties": {
        "location": { "type": "geo_point" },
        "latency_ms": { "type": "integer" },
        "@timestamp": { "type": "date" }
      }
    }
  },
  "priority": 500
}

# Si ya indexaste datos antes de crear la plantilla:
DELETE logs-sim-*

MD
cat > "$LAB_DIR/scripts/load_template.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
curl -sS -X PUT "http://localhost:9200/_index_template/logs_sim_template" -H "Content-Type: application/json" --data-binary @es/es_index_template.json
echo -e "\nPlantilla cargada."
SH
chmod +x "$LAB_DIR/scripts/load_template.sh"
cat > "$LAB_DIR/scripts/append_logs.py" <<'PY'
import argparse, random, time
from datetime import datetime, timezone
parser = argparse.ArgumentParser()
parser.add_argument("--file", default="data/logs.csv")
parser.add_argument("--n", type=int, default=200)
parser.add_argument("--period", type=float, default=0.5)
args = parser.parse_args()
hosts = ["app-1","app-2","web-1","web-2","db-1"]
services = ["auth","checkout","search","ingest"]
levels = ["INFO","INFO","INFO","WARN","ERROR"]
messages = ["request completed","db query executed","cache miss","timeout waiting upstream","login succeeded","login failed","validation error","publish event","consume event"]
with open(args.file, "a", encoding="utf-8") as f:
    for _ in range(args.n):
        ts = datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00","Z")
        row = f'{ts},{random.choice(hosts)},{random.choice(services)},{random.choice(levels)},"{random.choice(messages)}",{max(1,int(random.gauss(100,30)))},{40.4168+random.uniform(-0.25,0.25):.6f},{-3.7038+random.uniform(-0.25,0.25):.6f}\n'
        f.write(row); f.flush(); time.sleep(args.period)
print("Listo.")

PY
cat > "$LAB_DIR/README.md" <<'MD'
# Lab (extra) — Observabilidad con **Kibana** (plug & play)

**Objetivo:** Visualizar logs/series temporales con **Kibana** a partir de datos de ejemplo enviados a **Elasticsearch** mediante **Logstash**.  
**Duración sugerida:** 3 h (no sustituye contenidos; extra opcional).

## Requisitos
- **Docker** y **Docker Compose**
- 4–6 GB RAM libre recomendado
- Puertos **9200** (ES) y **5601** (Kibana)

## Pasos
1) Levanta el stack:
```bash
docker compose up -d
```
2) Crea la **plantilla de índice** (antes de indexar):
- Kibana → **Dev Tools**: copia `scripts/devtools_template.md` y ejecuta  
  *o*  
- `./scripts/load_template.sh` (requiere `curl`)
3) Abre **Kibana**: <http://localhost:5601> → **Stack Management → Data Views**  
   Crea `logs-sim-*` con **@timestamp** como campo de tiempo.
4) Explora en **Discover** y construye un **Dashboard** (4–6 visualizaciones):  
   - Líneas: `avg(latency_ms)` por tiempo, dividido por `service`  
   - Barras apiladas: número de eventos por `level` y `service`  
   - Tabla: top `host` por nº de eventos (+ `avg(latency_ms)`)  
   - Mapa: campo `location` (geo_point)

### Simular “ingesta en vivo” (opcional)
```bash
python3 scripts/append_logs.py --n 200 --period 0.5
```
Activa **Auto-refresh** en el dashboard.

## Estructura
- `docker-compose.yml`
- `data/` → `logs.csv` (dataset) y `logs.ndjson`
- `es/es_index_template.json` → mapping de `location` como `geo_point`
- `logstash/pipeline/logstash.conf` → pipeline de ingestión
- `scripts/` → plantilla Dev Tools, script `curl`, simulador de apéndice

## Parar y limpiar
```bash
docker compose down -v
```

MD
# CSV synthetic data
cat > "$LAB_DIR/data/logs.csv" <<'CSV'
@timestamp,host,service,level,message,latency_ms,lat,lon
2025-09-14T19:12:05Z,db-1,auth,INFO,login failed,63,40.225731,-3.80111
2025-09-14T19:18:05Z,app-2,ingest,ERROR,validation error,85,40.361218,-3.601432
2025-09-14T19:19:05Z,app-1,checkout,WARN,request completed,121,40.568985,-3.542172
2025-09-14T19:37:05Z,app-2,auth,INFO,request completed,53,40.648932,-3.867913
2025-09-14T19:38:05Z,app-1,auth,INFO,consume event,63,40.591223,-3.527864
2025-09-14T19:44:05Z,db-1,checkout,INFO,login failed,99,40.639461,-3.616474
2025-09-14T19:45:05Z,web-2,checkout,INFO,publish event,96,40.207161,-3.950188
2025-09-14T19:52:05Z,app-1,search,INFO,validation error,121,40.225554,-3.6887
2025-09-14T19:52:05Z,app-1,auth,ERROR,consume event,134,40.511127,-3.486854
2025-09-14T19:58:05Z,db-1,auth,ERROR,login succeeded,112,40.632678,-3.902007
2025-09-14T20:01:05Z,web-2,checkout,INFO,consume event,99,40.17631,-3.665598
2025-09-14T20:01:05Z,web-1,search,INFO,request completed,79,40.578766,-3.84416
2025-09-14T20:03:05Z,app-2,auth,WARN,cache miss,94,40.340205,-3.794041
2025-09-14T20:07:05Z,db-1,checkout,WARN,login failed,109,40.63254,-3.907237
2025-09-14T20:13:05Z,web-2,auth,INFO,request completed,89,40.446429,-3.806342
2025-09-14T20:42:05Z,app-2,search,WARN,login failed,132,40.233486,-3.747427
2025-09-14T20:44:05Z,db-1,ingest,INFO,login succeeded,96,40.28562,-3.892876
2025-09-14T20:53:05Z,app-2,auth,INFO,login succeeded,104,40.478959,-3.661118
2025-09-14T21:30:05Z,web-2,auth,INFO,cache miss,133,40.524232,-3.855942
2025-09-14T21:36:05Z,web-2,checkout,ERROR,db query executed,124,40.599097,-3.57803
2025-09-14T21:38:05Z,app-2,checkout,INFO,login failed,83,40.554172,-3.730335
2025-09-14T21:45:05Z,web-1,auth,INFO,db query executed,78,40.189531,-3.633073
2025-09-14T21:46:05Z,db-1,auth,INFO,validation error,135,40.351615,-3.767384
2025-09-14T22:12:05Z,app-2,search,INFO,login failed,65,40.609507,-3.71558
2025-09-14T22:20:05Z,db-1,checkout,INFO,cache miss,101,40.539787,-3.890085
2025-09-14T22:25:05Z,app-2,search,INFO,cache miss,133,40.625173,-3.798684
2025-09-14T22:42:05Z,app-2,auth,ERROR,publish event,167,40.267532,-3.888555
2025-09-14T23:06:05Z,web-2,checkout,INFO,request completed,111,40.655329,-3.717015
2025-09-14T23:12:05Z,app-1,auth,INFO,publish event,65,40.436443,-3.9532
2025-09-14T23:38:05Z,app-1,ingest,INFO,publish event,118,40.489295,-3.923059
2025-09-14T23:57:05Z,app-1,ingest,WARN,login succeeded,78,40.307912,-3.912493
2025-09-14T23:59:05Z,db-1,search,WARN,request completed,92,40.20915,-3.503232
2025-09-15T00:11:05Z,app-2,search,INFO,timeout waiting upstream,100,40.245649,-3.908099
2025-09-15T00:13:05Z,db-1,checkout,ERROR,validation error,111,40.392057,-3.732439
2025-09-15T00:27:05Z,web-1,auth,ERROR,validation error,59,40.206039,-3.925839
2025-09-15T00:45:05Z,app-2,auth,INFO,db query executed,107,40.59502,-3.888846
2025-09-15T01:02:05Z,app-2,search,INFO,db query executed,143,40.303747,-3.575025
2025-09-15T01:12:05Z,web-1,checkout,INFO,validation error,114,40.196773,-3.767311
2025-09-15T01:45:05Z,web-2,auth,INFO,db query executed,110,40.276119,-3.701122
2025-09-15T01:48:05Z,app-2,ingest,INFO,login succeeded,80,40.522535,-3.871803
2025-09-15T02:03:05Z,app-2,ingest,INFO,cache miss,142,40.378846,-3.696674
2025-09-15T02:12:05Z,app-1,ingest,WARN,consume event,119,40.234118,-3.704386
2025-09-15T02:17:05Z,web-2,search,ERROR,request completed,61,40.640595,-3.849906
2025-09-15T02:21:05Z,db-1,checkout,ERROR,timeout waiting upstream,147,40.196237,-3.9201
2025-09-15T02:22:05Z,db-1,ingest,INFO,publish event,33,40.511309,-3.47989
2025-09-15T02:37:05Z,app-2,search,INFO,login failed,51,40.290386,-3.63907
2025-09-15T02:39:05Z,web-2,ingest,ERROR,login succeeded,63,40.571803,-3.848266
2025-09-15T02:42:05Z,app-1,search,INFO,publish event,59,40.519794,-3.805078
2025-09-15T02:43:05Z,db-1,ingest,WARN,cache miss,102,40.530686,-3.622789
2025-09-15T02:44:05Z,db-1,search,INFO,cache miss,112,40.582235,-3.908604
2025-09-15T02:52:05Z,app-2,checkout,INFO,cache miss,80,40.561122,-3.655809
2025-09-15T03:04:05Z,web-1,auth,INFO,timeout waiting upstream,105,40.609491,-3.594382
2025-09-15T03:14:05Z,web-2,ingest,ERROR,timeout waiting upstream,93,40.41851,-3.601485
2025-09-15T03:20:05Z,app-1,checkout,INFO,cache miss,75,40.227168,-3.774656
2025-09-15T03:38:05Z,db-1,auth,WARN,timeout waiting upstream,39,40.357635,-3.804622
2025-09-15T03:45:05Z,app-2,checkout,WARN,login succeeded,56,40.616254,-3.721173
2025-09-15T04:30:05Z,app-1,search,WARN,cache miss,71,40.408021,-3.505191
2025-09-15T04:35:05Z,app-2,checkout,INFO,login failed,120,40.615767,-3.702017
2025-09-15T04:38:05Z,app-1,ingest,ERROR,cache miss,127,40.599533,-3.840011
2025-09-15T04:55:05Z,web-2,checkout,INFO,consume event,95,40.436639,-3.626846
2025-09-15T05:04:05Z,app-2,auth,INFO,db query executed,55,40.488999,-3.495359
2025-09-15T05:09:05Z,app-2,checkout,WARN,db query executed,102,40.176839,-3.823236
2025-09-15T05:30:05Z,web-1,checkout,ERROR,validation error,94,40.611298,-3.681011
2025-09-15T05:31:05Z,app-2,auth,ERROR,validation error,62,40.418038,-3.756942
2025-09-15T05:32:05Z,app-1,ingest,WARN,consume event,77,40.450243,-3.769956
2025-09-15T05:32:05Z,db-1,checkout,INFO,consume event,96,40.428352,-3.60351
2025-09-15T05:33:05Z,web-1,ingest,WARN,db query executed,109,40.367579,-3.785044
2025-09-15T05:55:05Z,db-1,auth,INFO,validation error,8,40.311692,-3.756639
2025-09-15T05:55:05Z,app-2,ingest,INFO,validation error,112,40.398332,-3.614022
2025-09-15T05:57:05Z,app-2,checkout,INFO,consume event,101,40.29518,-3.577266
2025-09-15T05:58:05Z,app-2,checkout,INFO,validation error,69,40.167582,-3.777392
2025-09-15T06:00:05Z,app-1,checkout,INFO,db query executed,56,40.339057,-3.51482
2025-09-15T06:06:05Z,app-2,ingest,INFO,login failed,115,40.184145,-3.795328
2025-09-15T06:07:05Z,web-1,ingest,INFO,consume event,76,40.306933,-3.842754
2025-09-15T06:16:05Z,web-2,checkout,WARN,login succeeded,91,40.657371,-3.787228
2025-09-15T06:20:05Z,app-2,ingest,INFO,db query executed,92,40.236512,-3.67832
2025-09-15T06:34:05Z,web-1,checkout,INFO,validation error,133,40.455258,-3.952961
2025-09-15T06:35:05Z,app-2,ingest,ERROR,timeout waiting upstream,81,40.219413,-3.695574
2025-09-15T06:36:05Z,db-1,ingest,ERROR,consume event,124,40.540948,-3.502027
2025-09-15T06:49:05Z,web-1,search,INFO,request completed,128,40.655772,-3.624685
2025-09-15T07:10:05Z,web-2,checkout,INFO,consume event,111,40.42983,-3.700136
2025-09-15T07:14:05Z,app-2,auth,INFO,consume event,114,40.490353,-3.640486
2025-09-15T07:22:05Z,app-2,search,INFO,request completed,146,40.433271,-3.827339
2025-09-15T07:24:05Z,app-2,ingest,ERROR,login failed,97,40.650054,-3.632953
2025-09-15T07:26:05Z,app-2,auth,ERROR,db query executed,74,40.376412,-3.661964
2025-09-15T07:30:05Z,web-2,auth,INFO,request completed,110,40.218132,-3.529985
2025-09-15T07:33:05Z,web-2,ingest,WARN,request completed,111,40.535445,-3.809844
2025-09-15T07:39:05Z,web-2,ingest,WARN,consume event,110,40.593976,-3.700457
2025-09-15T07:42:05Z,app-1,checkout,INFO,timeout waiting upstream,70,40.585288,-3.829055
2025-09-15T07:46:05Z,web-1,search,INFO,db query executed,100,40.537058,-3.722361
2025-09-15T08:06:05Z,web-1,checkout,INFO,db query executed,144,40.536484,-3.597846
2025-09-15T08:09:05Z,db-1,checkout,ERROR,timeout waiting upstream,146,40.282256,-3.940758
2025-09-15T08:25:05Z,app-2,auth,INFO,login succeeded,87,40.204657,-3.727078
2025-09-15T08:48:05Z,web-1,search,WARN,timeout waiting upstream,55,40.408034,-3.768694
2025-09-15T08:53:05Z,app-1,auth,WARN,cache miss,112,40.296878,-3.790124
2025-09-15T08:56:05Z,app-1,auth,ERROR,consume event,111,40.249069,-3.526557
2025-09-15T08:59:05Z,web-2,search,INFO,publish event,47,40.38773,-3.770908
2025-09-15T09:01:05Z,app-2,checkout,ERROR,request completed,121,40.643302,-3.722989
2025-09-15T09:14:05Z,db-1,ingest,INFO,validation error,97,40.572297,-3.646866
2025-09-15T09:27:05Z,web-2,ingest,ERROR,login succeeded,88,40.605539,-3.742607
2025-09-15T09:32:05Z,db-1,search,INFO,cache miss,64,40.314059,-3.864946
2025-09-15T09:41:05Z,web-1,checkout,INFO,publish event,121,40.370948,-3.883911
2025-09-15T09:44:05Z,web-2,checkout,ERROR,login succeeded,69,40.513268,-3.93031
2025-09-15T10:03:05Z,web-2,auth,WARN,request completed,97,40.59373,-3.7923
2025-09-15T10:07:05Z,web-2,ingest,INFO,validation error,86,40.495454,-3.756009
2025-09-15T10:11:05Z,db-1,auth,INFO,consume event,84,40.237578,-3.601623
2025-09-15T10:31:05Z,web-1,ingest,INFO,request completed,49,40.511425,-3.774716
2025-09-15T10:45:05Z,app-2,auth,INFO,cache miss,97,40.194332,-3.77929
2025-09-15T10:49:05Z,db-1,checkout,WARN,timeout waiting upstream,99,40.206335,-3.728907
2025-09-15T10:54:05Z,app-2,search,INFO,timeout waiting upstream,125,40.577701,-3.551277
2025-09-15T11:11:05Z,db-1,checkout,INFO,publish event,142,40.227527,-3.922965
2025-09-15T11:13:05Z,web-2,checkout,INFO,cache miss,116,40.582942,-3.809068
2025-09-15T11:14:05Z,web-2,checkout,INFO,login succeeded,102,40.534669,-3.923321
2025-09-15T11:28:05Z,web-2,search,INFO,login failed,127,40.553897,-3.754735
2025-09-15T11:34:05Z,app-1,auth,INFO,db query executed,101,40.619453,-3.880126
2025-09-15T11:34:05Z,app-2,auth,ERROR,cache miss,47,40.437603,-3.726761
2025-09-15T11:53:05Z,db-1,search,INFO,login succeeded,115,40.269523,-3.650337
2025-09-15T11:54:05Z,db-1,ingest,INFO,cache miss,116,40.264896,-3.838791
2025-09-15T11:55:05Z,app-1,search,WARN,publish event,131,40.48989,-3.729637
2025-09-15T12:01:05Z,web-2,checkout,INFO,timeout waiting upstream,111,40.374928,-3.593656
2025-09-15T12:19:05Z,app-2,search,INFO,login failed,98,40.469157,-3.834674
2025-09-15T12:26:05Z,app-2,ingest,WARN,timeout waiting upstream,91,40.373707,-3.54009
2025-09-15T12:27:05Z,db-1,checkout,INFO,validation error,114,40.418232,-3.519694
2025-09-15T12:37:05Z,web-2,auth,INFO,login succeeded,76,40.488126,-3.555201
2025-09-15T12:42:05Z,web-1,search,WARN,login succeeded,92,40.527442,-3.796026
2025-09-15T12:54:05Z,app-1,search,INFO,login succeeded,44,40.215901,-3.591005
2025-09-15T13:07:05Z,app-1,auth,ERROR,login failed,108,40.221649,-3.812695
2025-09-15T13:19:05Z,web-2,checkout,WARN,login failed,95,40.284053,-3.947425
2025-09-15T13:35:05Z,db-1,ingest,INFO,validation error,76,40.294382,-3.83376
2025-09-15T13:47:05Z,app-2,ingest,WARN,login failed,85,40.392243,-3.864361
2025-09-15T13:51:05Z,db-1,search,INFO,publish event,77,40.614789,-3.468997
2025-09-15T14:20:05Z,db-1,ingest,INFO,validation error,89,40.5545,-3.513313
2025-09-15T14:25:05Z,web-2,checkout,INFO,validation error,77,40.298448,-3.721271
2025-09-15T14:33:05Z,web-1,search,WARN,login succeeded,86,40.600631,-3.65446
2025-09-15T14:36:05Z,web-2,ingest,INFO,timeout waiting upstream,75,40.657187,-3.834397
2025-09-15T14:49:05Z,web-2,ingest,INFO,timeout waiting upstream,114,40.551698,-3.480769
2025-09-15T15:08:05Z,web-2,checkout,ERROR,request completed,129,40.376116,-3.686043
2025-09-15T15:13:05Z,app-1,search,WARN,db query executed,66,40.447742,-3.841646
2025-09-15T15:23:05Z,web-2,auth,INFO,request completed,55,40.219763,-3.9269
2025-09-15T15:23:05Z,web-1,ingest,INFO,consume event,49,40.255318,-3.655008
2025-09-15T15:23:05Z,web-1,ingest,INFO,db query executed,84,40.417196,-3.466638
2025-09-15T15:25:05Z,app-2,checkout,ERROR,validation error,137,40.187696,-3.547478
2025-09-15T15:30:05Z,web-1,search,INFO,timeout waiting upstream,124,40.441631,-3.708326
2025-09-15T15:44:05Z,app-2,search,INFO,cache miss,129,40.230474,-3.464438
2025-09-15T15:45:05Z,app-2,ingest,INFO,publish event,106,40.215265,-3.738274
2025-09-15T15:45:05Z,db-1,search,ERROR,request completed,142,40.618593,-3.686283
2025-09-15T15:47:05Z,app-1,search,INFO,publish event,94,40.535813,-3.669379
2025-09-15T15:55:05Z,web-1,search,INFO,db query executed,79,40.474639,-3.660385
2025-09-15T15:55:05Z,app-2,auth,INFO,publish event,141,40.240883,-3.74286
2025-09-15T15:58:05Z,web-2,auth,ERROR,validation error,169,40.264025,-3.794921
2025-09-15T16:06:05Z,db-1,search,WARN,validation error,52,40.545537,-3.473181
2025-09-15T16:11:05Z,web-1,search,ERROR,request completed,93,40.236367,-3.465178
2025-09-15T16:15:05Z,app-2,checkout,WARN,login succeeded,108,40.236948,-3.79651
2025-09-15T16:19:05Z,app-1,auth,INFO,consume event,91,40.592448,-3.716442
2025-09-15T16:28:05Z,db-1,checkout,INFO,db query executed,86,40.268399,-3.54977
2025-09-15T16:31:05Z,web-1,ingest,ERROR,db query executed,133,40.321885,-3.735057
2025-09-15T16:34:05Z,app-1,ingest,INFO,consume event,66,40.313389,-3.63948
2025-09-15T16:40:05Z,app-2,checkout,INFO,publish event,120,40.30505,-3.659007
2025-09-15T16:55:05Z,app-1,checkout,INFO,login succeeded,94,40.530354,-3.837395
2025-09-15T17:00:05Z,web-1,auth,WARN,login succeeded,124,40.490696,-3.865491
2025-09-15T17:00:05Z,web-2,search,ERROR,login succeeded,132,40.605047,-3.863232
2025-09-15T17:17:05Z,web-2,search,WARN,consume event,111,40.482381,-3.493335
2025-09-15T17:18:05Z,db-1,search,WARN,request completed,146,40.412537,-3.486876
2025-09-15T17:35:05Z,app-2,ingest,WARN,publish event,126,40.298113,-3.688579
2025-09-15T17:37:05Z,app-1,ingest,INFO,timeout waiting upstream,142,40.52388,-3.602504
2025-09-15T17:45:05Z,db-1,search,WARN,login failed,128,40.566752,-3.481117
2025-09-15T17:46:05Z,app-2,auth,INFO,timeout waiting upstream,101,40.610628,-3.731685
2025-09-15T17:55:05Z,web-1,ingest,ERROR,login succeeded,30,40.334284,-3.820256
2025-09-15T17:57:05Z,db-1,search,WARN,consume event,41,40.389757,-3.874221
2025-09-15T17:58:05Z,web-2,ingest,INFO,publish event,108,40.414443,-3.912254
2025-09-15T17:59:05Z,web-2,ingest,INFO,login failed,112,40.317724,-3.551737
2025-09-15T18:10:05Z,app-1,ingest,ERROR,publish event,146,40.621891,-3.607891
2025-09-15T18:44:05Z,app-1,search,INFO,cache miss,100,40.360219,-3.534313
2025-09-15T18:51:05Z,web-1,search,INFO,consume event,17,40.363686,-3.88835
2025-09-15T18:54:05Z,db-1,ingest,INFO,consume event,101,40.523274,-3.754304
2025-09-15T19:15:05Z,app-1,ingest,ERROR,login failed,137,40.175915,-3.799367
2025-09-15T19:33:05Z,web-1,auth,ERROR,validation error,126,40.624005,-3.746543
2025-09-15T19:34:05Z,web-1,ingest,INFO,timeout waiting upstream,85,40.466711,-3.567205
2025-09-15T19:44:05Z,db-1,search,INFO,timeout waiting upstream,91,40.317934,-3.599791
2025-09-15T19:47:05Z,web-1,ingest,WARN,cache miss,94,40.435764,-3.833316
2025-09-15T19:53:05Z,db-1,checkout,INFO,login failed,93,40.625768,-3.760092
2025-09-15T19:58:05Z,db-1,auth,INFO,login succeeded,89,40.515153,-3.889333
2025-09-15T20:02:05Z,app-2,checkout,INFO,login failed,119,40.643042,-3.742439
2025-09-15T20:11:05Z,db-1,search,INFO,login failed,136,40.301182,-3.510593
2025-09-15T20:14:05Z,web-1,search,INFO,login failed,102,40.502645,-3.803801
2025-09-15T20:14:05Z,app-2,auth,INFO,login succeeded,125,40.409763,-3.558198
2025-09-15T20:31:05Z,web-2,checkout,ERROR,publish event,112,40.531809,-3.585711
2025-09-15T20:50:05Z,app-1,checkout,WARN,consume event,87,40.277399,-3.847123
2025-09-15T21:03:05Z,web-1,ingest,WARN,consume event,63,40.603573,-3.593024
2025-09-15T21:04:05Z,db-1,checkout,INFO,validation error,125,40.171394,-3.527619
2025-09-15T21:05:05Z,web-2,auth,ERROR,consume event,119,40.557643,-3.897541
2025-09-15T21:18:05Z,web-1,auth,INFO,timeout waiting upstream,159,40.484329,-3.678379
2025-09-15T21:49:05Z,app-2,ingest,WARN,db query executed,97,40.556166,-3.484879
2025-09-15T21:59:05Z,web-2,search,INFO,publish event,116,40.170099,-3.512783
2025-09-15T22:03:05Z,app-2,checkout,INFO,publish event,54,40.224718,-3.798309
2025-09-15T22:15:05Z,web-1,ingest,INFO,validation error,146,40.289301,-3.894399
2025-09-15T22:26:05Z,web-2,ingest,INFO,publish event,171,40.419522,-3.470457
2025-09-15T22:26:05Z,web-2,search,INFO,publish event,98,40.460795,-3.460918
2025-09-15T22:28:05Z,app-1,ingest,WARN,request completed,110,40.545022,-3.641096
2025-09-15T22:40:05Z,app-1,auth,INFO,consume event,103,40.433403,-3.640333
2025-09-15T22:51:05Z,db-1,auth,INFO,publish event,50,40.638835,-3.769134
2025-09-15T23:06:05Z,web-1,search,ERROR,timeout waiting upstream,93,40.267245,-3.641716
2025-09-15T23:07:05Z,db-1,search,WARN,publish event,69,40.569052,-3.79529
2025-09-15T23:16:05Z,db-1,checkout,WARN,consume event,62,40.622926,-3.671054
2025-09-15T23:20:05Z,db-1,checkout,WARN,cache miss,98,40.32498,-3.559908
2025-09-15T23:44:05Z,app-2,search,INFO,cache miss,101,40.265436,-3.652601
2025-09-15T23:53:05Z,web-2,search,INFO,db query executed,116,40.457095,-3.462025
2025-09-16T00:02:05Z,web-1,ingest,WARN,publish event,101,40.358593,-3.492866
2025-09-16T00:12:05Z,app-2,auth,INFO,validation error,137,40.336738,-3.559941
2025-09-16T00:22:05Z,db-1,auth,INFO,cache miss,99,40.465423,-3.876674
2025-09-16T00:22:05Z,app-2,search,ERROR,publish event,116,40.522493,-3.473898
2025-09-16T00:23:05Z,db-1,auth,WARN,publish event,98,40.188567,-3.760359
2025-09-16T00:25:05Z,web-1,auth,INFO,db query executed,98,40.391168,-3.667582
2025-09-16T00:50:05Z,web-2,checkout,INFO,login failed,117,40.554808,-3.834407
2025-09-16T00:50:05Z,web-1,auth,WARN,publish event,160,40.484593,-3.539446
2025-09-16T00:54:05Z,web-2,search,INFO,publish event,97,40.432906,-3.748131
2025-09-16T01:09:05Z,web-1,search,ERROR,consume event,150,40.662156,-3.513737
2025-09-16T01:16:05Z,web-2,checkout,ERROR,db query executed,129,40.255511,-3.502996
2025-09-16T01:25:05Z,db-1,search,INFO,timeout waiting upstream,97,40.314982,-3.819543
2025-09-16T01:26:05Z,web-2,search,WARN,cache miss,92,40.211624,-3.598672
2025-09-16T01:42:05Z,web-1,checkout,ERROR,login succeeded,87,40.348467,-3.735804
2025-09-16T02:17:05Z,db-1,ingest,ERROR,login succeeded,87,40.533767,-3.577569
2025-09-16T02:20:05Z,app-2,search,INFO,publish event,124,40.647664,-3.895765
2025-09-16T02:20:05Z,db-1,ingest,WARN,db query executed,48,40.534067,-3.651943
2025-09-16T02:23:05Z,db-1,search,INFO,validation error,81,40.597682,-3.932649
2025-09-16T02:54:05Z,web-1,ingest,INFO,login failed,143,40.239844,-3.820548
2025-09-16T03:05:05Z,app-2,checkout,INFO,consume event,127,40.371678,-3.873613
2025-09-16T03:06:05Z,web-2,auth,ERROR,publish event,99,40.285739,-3.659369
2025-09-16T03:17:05Z,app-1,checkout,INFO,login succeeded,195,40.367814,-3.840857
2025-09-16T03:43:05Z,app-2,search,INFO,request completed,87,40.631027,-3.786279
2025-09-16T03:44:05Z,db-1,auth,ERROR,db query executed,124,40.300744,-3.682247
2025-09-16T03:50:05Z,web-2,ingest,WARN,publish event,101,40.41115,-3.912465
2025-09-16T04:00:05Z,web-2,auth,INFO,consume event,98,40.466557,-3.695893
2025-09-16T04:03:05Z,web-2,checkout,WARN,timeout waiting upstream,155,40.466841,-3.456196
2025-09-16T04:05:05Z,app-1,search,ERROR,login failed,16,40.231686,-3.511677
2025-09-16T04:20:05Z,app-2,auth,INFO,validation error,95,40.558133,-3.773238
2025-09-16T04:21:05Z,web-2,search,ERROR,validation error,132,40.217514,-3.714055
2025-09-16T04:35:05Z,db-1,search,INFO,publish event,92,40.185782,-3.925716
2025-09-16T04:38:05Z,app-1,checkout,INFO,db query executed,120,40.589552,-3.747272
2025-09-16T04:44:05Z,app-1,checkout,INFO,cache miss,97,40.635937,-3.89102
2025-09-16T04:57:05Z,app-1,auth,ERROR,login succeeded,68,40.258982,-3.928112
2025-09-16T05:02:05Z,web-2,checkout,INFO,cache miss,155,40.236779,-3.680527
2025-09-16T05:02:05Z,app-1,search,ERROR,login succeeded,50,40.27906,-3.55819
2025-09-16T05:12:05Z,web-1,ingest,INFO,validation error,127,40.369233,-3.932887
2025-09-16T05:13:05Z,db-1,search,INFO,login failed,101,40.277161,-3.594877
2025-09-16T05:22:05Z,db-1,ingest,INFO,request completed,74,40.51194,-3.845165
2025-09-16T05:29:05Z,app-1,ingest,ERROR,request completed,78,40.288141,-3.629407
2025-09-16T05:31:05Z,app-1,auth,ERROR,login failed,108,40.407388,-3.798949
2025-09-16T05:34:05Z,app-1,auth,INFO,login succeeded,101,40.450478,-3.914421
2025-09-16T05:34:05Z,web-1,auth,WARN,validation error,86,40.534632,-3.832624
2025-09-16T05:35:05Z,db-1,checkout,WARN,publish event,94,40.313918,-3.751599
2025-09-16T05:57:05Z,web-1,search,INFO,timeout waiting upstream,133,40.616859,-3.794907
2025-09-16T06:01:05Z,db-1,auth,INFO,db query executed,132,40.236801,-3.684491
2025-09-16T06:05:05Z,web-2,checkout,INFO,cache miss,108,40.487921,-3.745872
2025-09-16T06:05:05Z,web-1,search,WARN,login succeeded,43,40.210618,-3.886243
2025-09-16T06:07:05Z,app-1,ingest,INFO,consume event,126,40.320818,-3.750903
2025-09-16T06:17:05Z,app-1,checkout,INFO,publish event,122,40.640224,-3.871237
2025-09-16T06:32:05Z,db-1,auth,INFO,timeout waiting upstream,31,40.527502,-3.657447
2025-09-16T06:37:05Z,app-1,checkout,ERROR,db query executed,79,40.592523,-3.814876
2025-09-16T06:38:05Z,app-1,auth,ERROR,timeout waiting upstream,93,40.173637,-3.749805
2025-09-16T06:58:05Z,db-1,search,INFO,cache miss,37,40.551541,-3.904674
2025-09-16T06:58:05Z,web-2,ingest,ERROR,login succeeded,90,40.634111,-3.814336
2025-09-16T07:08:05Z,app-2,checkout,INFO,cache miss,89,40.374792,-3.456916
2025-09-16T07:20:05Z,web-2,search,ERROR,db query executed,79,40.549729,-3.498757
2025-09-16T07:21:05Z,app-1,search,INFO,login succeeded,65,40.646212,-3.908467
2025-09-16T07:58:05Z,web-2,search,ERROR,request completed,85,40.331513,-3.931877
2025-09-16T08:15:05Z,web-2,checkout,ERROR,cache miss,73,40.49043,-3.74835
2025-09-16T08:24:05Z,web-2,checkout,INFO,cache miss,144,40.514885,-3.924477
2025-09-16T08:32:05Z,app-1,auth,WARN,publish event,106,40.203841,-3.639077
2025-09-16T08:34:05Z,web-1,checkout,INFO,login succeeded,119,40.314541,-3.929936
2025-09-16T09:00:05Z,app-1,search,ERROR,request completed,110,40.196055,-3.793959
2025-09-16T09:05:05Z,web-2,ingest,WARN,db query executed,97,40.607884,-3.814744
2025-09-16T09:06:05Z,web-1,checkout,INFO,publish event,85,40.428131,-3.615541
2025-09-16T09:12:05Z,app-1,search,WARN,publish event,39,40.589683,-3.812671
2025-09-16T09:14:05Z,db-1,ingest,INFO,request completed,84,40.659891,-3.475026
2025-09-16T09:19:05Z,db-1,auth,INFO,login failed,38,40.473651,-3.643234
2025-09-16T09:20:05Z,db-1,checkout,WARN,login succeeded,53,40.206278,-3.502411
2025-09-16T09:21:05Z,app-2,search,ERROR,timeout waiting upstream,114,40.418038,-3.611382
2025-09-16T09:22:05Z,web-2,search,INFO,login succeeded,129,40.549707,-3.69315
2025-09-16T09:29:05Z,app-1,auth,INFO,db query executed,121,40.382738,-3.581506
2025-09-16T09:30:05Z,app-2,checkout,INFO,cache miss,94,40.262653,-3.678552
2025-09-16T09:41:05Z,app-1,checkout,WARN,login succeeded,101,40.470424,-3.579837
2025-09-16T09:43:05Z,web-1,auth,INFO,login succeeded,67,40.599699,-3.787838
2025-09-16T09:47:05Z,db-1,auth,INFO,validation error,1,40.218764,-3.644749
2025-09-16T10:12:05Z,db-1,ingest,INFO,db query executed,97,40.471314,-3.591553
2025-09-16T10:17:05Z,db-1,search,INFO,cache miss,84,40.416185,-3.848534
2025-09-16T10:29:05Z,web-1,auth,INFO,validation error,115,40.349689,-3.752173
2025-09-16T10:54:05Z,app-1,search,INFO,db query executed,107,40.317623,-3.948664
2025-09-16T10:55:05Z,app-2,search,ERROR,publish event,76,40.357736,-3.69007
2025-09-16T11:01:05Z,db-1,search,INFO,validation error,52,40.628706,-3.839418
2025-09-16T11:11:05Z,db-1,search,ERROR,request completed,93,40.609194,-3.578361
2025-09-16T11:22:05Z,db-1,search,ERROR,login failed,76,40.24794,-3.726649
2025-09-16T11:23:05Z,web-1,ingest,ERROR,request completed,70,40.427935,-3.771663
2025-09-16T11:26:05Z,web-2,auth,WARN,request completed,16,40.447227,-3.72492
2025-09-16T11:31:05Z,app-2,ingest,INFO,publish event,75,40.498121,-3.833349
2025-09-16T11:37:05Z,app-1,search,WARN,timeout waiting upstream,106,40.639492,-3.521718
2025-09-16T12:02:05Z,app-1,auth,WARN,login succeeded,107,40.498291,-3.497366
2025-09-16T12:07:05Z,web-2,checkout,INFO,db query executed,84,40.185292,-3.853005
2025-09-16T12:08:05Z,app-1,checkout,INFO,publish event,79,40.23347,-3.721478
2025-09-16T12:19:05Z,web-1,ingest,INFO,consume event,136,40.547041,-3.831237
2025-09-16T13:08:05Z,web-2,ingest,INFO,login failed,135,40.478595,-3.760182
2025-09-16T13:09:05Z,app-1,checkout,WARN,validation error,67,40.507521,-3.797745
2025-09-16T13:13:05Z,db-1,search,WARN,validation error,109,40.427337,-3.671329
2025-09-16T13:17:05Z,web-1,search,INFO,db query executed,163,40.259879,-3.776534
2025-09-16T13:42:05Z,web-2,auth,WARN,db query executed,80,40.29571,-3.762463
2025-09-16T14:03:05Z,app-2,search,INFO,db query executed,57,40.255212,-3.636551
2025-09-16T14:10:05Z,app-1,auth,ERROR,db query executed,91,40.578605,-3.932815
2025-09-16T14:12:05Z,app-2,checkout,INFO,login failed,104,40.248051,-3.458492
2025-09-16T14:21:05Z,app-1,search,INFO,login succeeded,77,40.365271,-3.492263
2025-09-16T14:23:05Z,web-1,search,WARN,cache miss,83,40.475668,-3.737762
2025-09-16T14:25:05Z,web-1,search,INFO,timeout waiting upstream,115,40.550508,-3.653824
2025-09-16T14:28:05Z,db-1,ingest,ERROR,cache miss,69,40.576836,-3.761443
2025-09-16T14:48:05Z,app-1,search,INFO,login failed,170,40.224761,-3.567526
2025-09-16T14:50:05Z,web-2,search,ERROR,request completed,139,40.213371,-3.467725
2025-09-16T14:50:05Z,web-1,search,WARN,login succeeded,85,40.542805,-3.537838
2025-09-16T14:55:05Z,db-1,ingest,INFO,consume event,138,40.40081,-3.857394
2025-09-16T15:01:05Z,app-1,checkout,INFO,timeout waiting upstream,121,40.379369,-3.681519
2025-09-16T15:06:05Z,web-2,auth,INFO,timeout waiting upstream,121,40.557861,-3.809819
2025-09-16T15:14:05Z,db-1,checkout,INFO,consume event,125,40.273276,-3.472741
2025-09-16T15:16:05Z,web-1,checkout,INFO,request completed,107,40.565873,-3.5819
2025-09-16T15:21:05Z,web-1,ingest,INFO,login failed,84,40.176498,-3.928984
2025-09-16T15:28:05Z,web-1,ingest,WARN,cache miss,103,40.547776,-3.701418
2025-09-16T15:40:05Z,web-2,auth,INFO,consume event,90,40.435735,-3.461885
2025-09-16T15:50:05Z,db-1,auth,INFO,request completed,80,40.358772,-3.673009
2025-09-16T15:51:05Z,app-2,search,ERROR,publish event,93,40.209669,-3.719359
2025-09-16T15:54:05Z,app-2,ingest,ERROR,validation error,120,40.334998,-3.706647
2025-09-16T15:56:05Z,web-1,search,ERROR,cache miss,124,40.449576,-3.771553
2025-09-16T15:58:05Z,app-1,search,INFO,consume event,94,40.520611,-3.458307
2025-09-16T16:26:05Z,db-1,ingest,INFO,request completed,118,40.211609,-3.67669
2025-09-16T17:05:05Z,db-1,auth,INFO,request completed,82,40.275435,-3.521935
2025-09-16T17:08:05Z,web-1,checkout,INFO,cache miss,102,40.549498,-3.947696
2025-09-16T17:14:05Z,app-1,ingest,INFO,request completed,107,40.633247,-3.621497
2025-09-16T17:26:05Z,app-1,search,WARN,login failed,56,40.572735,-3.461902
2025-09-16T17:34:05Z,app-2,search,INFO,login failed,20,40.346137,-3.75473
2025-09-16T17:35:05Z,app-2,checkout,INFO,request completed,124,40.384724,-3.473929
2025-09-16T17:40:05Z,app-2,search,INFO,publish event,89,40.244057,-3.925862
2025-09-16T17:41:05Z,web-2,ingest,INFO,cache miss,127,40.378716,-3.505586
2025-09-16T17:46:05Z,app-2,ingest,INFO,validation error,101,40.261192,-3.918995
2025-09-16T18:00:05Z,app-2,search,ERROR,consume event,116,40.536025,-3.855565
2025-09-16T18:17:05Z,app-1,auth,WARN,login succeeded,61,40.191132,-3.765102
2025-09-16T18:20:05Z,app-1,checkout,ERROR,publish event,135,40.212271,-3.698612
2025-09-16T18:29:05Z,web-2,auth,WARN,timeout waiting upstream,165,40.607874,-3.802867
2025-09-16T18:40:05Z,web-1,checkout,INFO,request completed,139,40.613144,-3.687651
2025-09-16T18:52:05Z,app-2,checkout,INFO,consume event,39,40.488539,-3.848041
2025-09-16T19:01:05Z,app-2,checkout,INFO,validation error,162,40.52141,-3.898467
2025-09-16T19:06:05Z,app-1,checkout,INFO,login failed,126,40.380884,-3.645724
2025-09-16T19:24:05Z,app-2,checkout,INFO,timeout waiting upstream,74,40.179482,-3.455608
2025-09-16T19:27:05Z,db-1,ingest,ERROR,validation error,101,40.367224,-3.818053
2025-09-16T19:32:05Z,app-1,checkout,WARN,login failed,76,40.632036,-3.746352
2025-09-16T19:52:05Z,app-1,checkout,INFO,timeout waiting upstream,128,40.40142,-3.734745
2025-09-16T19:54:05Z,web-2,auth,INFO,cache miss,156,40.303156,-3.939229
2025-09-16T19:58:05Z,app-2,checkout,ERROR,publish event,112,40.39567,-3.856723
2025-09-16T19:58:05Z,web-2,auth,WARN,login failed,96,40.370974,-3.793271
2025-09-16T20:13:05Z,web-1,auth,INFO,validation error,107,40.348456,-3.553252
2025-09-16T20:17:05Z,app-1,search,WARN,validation error,66,40.508238,-3.933291
2025-09-16T20:27:05Z,web-2,auth,INFO,consume event,81,40.278915,-3.610682
2025-09-16T20:38:05Z,app-2,ingest,INFO,validation error,110,40.380499,-3.912184
2025-09-16T20:43:05Z,web-2,ingest,INFO,validation error,92,40.274158,-3.860224
2025-09-16T20:46:05Z,app-2,search,INFO,login failed,115,40.60264,-3.536398
2025-09-16T20:47:05Z,db-1,search,INFO,validation error,58,40.36795,-3.641318
2025-09-16T21:05:05Z,web-2,ingest,ERROR,consume event,108,40.36664,-3.697122
2025-09-16T21:10:05Z,db-1,ingest,INFO,request completed,45,40.515621,-3.739322
2025-09-16T21:14:05Z,app-2,auth,WARN,login succeeded,109,40.452472,-3.828502
2025-09-16T21:25:05Z,app-2,auth,INFO,consume event,111,40.430028,-3.546193
2025-09-16T21:52:05Z,app-2,checkout,ERROR,cache miss,100,40.598883,-3.456671
2025-09-16T21:54:05Z,web-2,ingest,WARN,consume event,107,40.181681,-3.881008
2025-09-16T21:59:05Z,web-1,search,INFO,cache miss,117,40.458793,-3.826292
2025-09-16T22:00:05Z,db-1,ingest,INFO,timeout waiting upstream,116,40.413558,-3.575909
2025-09-16T22:12:05Z,db-1,auth,INFO,db query executed,82,40.639325,-3.60829
2025-09-16T22:32:05Z,web-2,checkout,ERROR,publish event,108,40.474958,-3.79758
2025-09-16T22:33:05Z,app-2,ingest,WARN,db query executed,58,40.528953,-3.885154
2025-09-16T22:35:05Z,app-1,checkout,INFO,request completed,106,40.356976,-3.691314
2025-09-16T23:01:05Z,web-2,search,ERROR,login succeeded,155,40.544951,-3.553308
2025-09-16T23:12:05Z,web-2,ingest,WARN,login succeeded,134,40.274584,-3.697627
2025-09-16T23:20:05Z,web-2,ingest,INFO,db query executed,81,40.197106,-3.589693
2025-09-16T23:30:05Z,web-1,auth,INFO,login failed,80,40.430141,-3.892445
2025-09-16T23:30:05Z,app-1,search,ERROR,login succeeded,83,40.342623,-3.664841
2025-09-17T00:02:05Z,db-1,auth,INFO,publish event,73,40.463633,-3.727797
2025-09-17T00:04:05Z,web-1,checkout,WARN,db query executed,111,40.297893,-3.933887
2025-09-17T00:12:05Z,web-1,ingest,WARN,validation error,106,40.354623,-3.612435
2025-09-17T00:31:05Z,db-1,auth,INFO,timeout waiting upstream,169,40.200445,-3.656828
2025-09-17T00:38:05Z,app-2,ingest,INFO,validation error,58,40.402603,-3.529612
2025-09-17T00:42:05Z,web-2,ingest,INFO,timeout waiting upstream,56,40.338384,-3.597115
2025-09-17T00:44:05Z,web-2,auth,WARN,timeout waiting upstream,113,40.3829,-3.598964
2025-09-17T00:49:05Z,app-2,checkout,INFO,login failed,107,40.261717,-3.874129
2025-09-17T01:05:05Z,app-2,ingest,INFO,request completed,117,40.663966,-3.920438
2025-09-17T01:09:05Z,app-2,checkout,ERROR,cache miss,23,40.409182,-3.724944
2025-09-17T01:10:05Z,web-1,ingest,INFO,cache miss,66,40.26581,-3.862808
2025-09-17T01:17:05Z,app-1,checkout,WARN,db query executed,59,40.610484,-3.940819
2025-09-17T01:25:05Z,web-1,auth,ERROR,login succeeded,89,40.43131,-3.58665
2025-09-17T01:28:05Z,app-1,checkout,WARN,login failed,95,40.299808,-3.5962
2025-09-17T01:40:05Z,web-1,checkout,INFO,consume event,117,40.377661,-3.839709
2025-09-17T01:42:05Z,web-1,auth,INFO,login failed,142,40.338164,-3.850891
2025-09-17T02:14:05Z,web-2,checkout,WARN,cache miss,91,40.272228,-3.586619
2025-09-17T02:22:05Z,web-1,search,INFO,login succeeded,131,40.510227,-3.835735
2025-09-17T02:29:05Z,app-2,checkout,ERROR,request completed,80,40.464936,-3.595201
2025-09-17T02:34:05Z,db-1,ingest,INFO,db query executed,117,40.615096,-3.883793
2025-09-17T02:41:05Z,web-2,auth,INFO,login succeeded,97,40.600966,-3.691391
2025-09-17T02:49:05Z,db-1,checkout,ERROR,cache miss,78,40.478406,-3.698398
2025-09-17T02:50:05Z,app-1,ingest,INFO,cache miss,102,40.402149,-3.766645
2025-09-17T03:05:05Z,web-1,auth,INFO,consume event,53,40.496246,-3.931911
2025-09-17T03:15:05Z,app-1,search,ERROR,timeout waiting upstream,78,40.260572,-3.488692
2025-09-17T03:29:05Z,web-1,auth,WARN,consume event,113,40.354152,-3.479445
2025-09-17T03:42:05Z,app-1,search,INFO,publish event,27,40.221958,-3.885844
2025-09-17T03:53:05Z,web-1,auth,ERROR,publish event,63,40.188532,-3.59319
2025-09-17T03:55:05Z,web-2,auth,ERROR,timeout waiting upstream,138,40.558241,-3.882616
2025-09-17T04:01:05Z,db-1,checkout,INFO,cache miss,154,40.607508,-3.941407
2025-09-17T04:03:05Z,app-1,search,INFO,publish event,161,40.402346,-3.747319
2025-09-17T04:35:05Z,app-2,ingest,INFO,consume event,134,40.180283,-3.75679
2025-09-17T05:27:05Z,web-1,auth,INFO,login failed,108,40.609142,-3.632374
2025-09-17T05:33:05Z,db-1,ingest,ERROR,request completed,107,40.614551,-3.685347
2025-09-17T05:35:05Z,db-1,search,ERROR,request completed,128,40.639658,-3.543686
2025-09-17T05:42:05Z,web-1,ingest,ERROR,validation error,135,40.240487,-3.726483
2025-09-17T05:52:05Z,web-1,ingest,INFO,request completed,117,40.540227,-3.674803
2025-09-17T05:52:05Z,app-2,checkout,INFO,db query executed,103,40.568855,-3.605844
2025-09-17T05:57:05Z,app-2,ingest,INFO,request completed,120,40.292103,-3.59925
2025-09-17T06:04:05Z,app-1,auth,INFO,cache miss,76,40.490384,-3.476584
2025-09-17T06:07:05Z,web-2,auth,INFO,validation error,91,40.643596,-3.610389
2025-09-17T06:15:05Z,web-1,search,WARN,timeout waiting upstream,88,40.559733,-3.771292
2025-09-17T06:24:05Z,db-1,auth,ERROR,timeout waiting upstream,112,40.380236,-3.607882
2025-09-17T06:28:05Z,db-1,search,INFO,validation error,137,40.394193,-3.617386
2025-09-17T06:33:05Z,db-1,auth,INFO,consume event,133,40.666515,-3.470557
2025-09-17T06:41:05Z,web-2,search,ERROR,cache miss,83,40.512697,-3.556137
2025-09-17T06:44:05Z,db-1,search,INFO,validation error,129,40.180894,-3.488387
2025-09-17T06:50:05Z,app-1,search,ERROR,consume event,62,40.496719,-3.670946
2025-09-17T06:56:05Z,web-1,ingest,INFO,publish event,72,40.596554,-3.466687
2025-09-17T07:00:05Z,app-2,ingest,INFO,validation error,56,40.213646,-3.863043
2025-09-17T07:01:05Z,web-1,auth,WARN,login succeeded,122,40.489758,-3.520823
2025-09-17T07:18:05Z,app-1,auth,WARN,cache miss,101,40.324304,-3.553392
2025-09-17T07:42:05Z,app-2,ingest,INFO,login failed,124,40.630113,-3.535067
2025-09-17T07:44:05Z,db-1,auth,INFO,consume event,72,40.182274,-3.537758
2025-09-17T07:50:05Z,app-1,ingest,INFO,timeout waiting upstream,124,40.614649,-3.82876
2025-09-17T07:58:05Z,app-2,auth,INFO,consume event,62,40.573392,-3.618742
2025-09-17T08:07:05Z,web-1,ingest,ERROR,validation error,79,40.655691,-3.793559
2025-09-17T08:23:05Z,web-1,ingest,INFO,validation error,129,40.515096,-3.588547
2025-09-17T08:30:05Z,web-2,checkout,WARN,timeout waiting upstream,95,40.361229,-3.619363
2025-09-17T08:31:05Z,app-1,search,INFO,validation error,82,40.613306,-3.824833
2025-09-17T08:52:05Z,web-2,search,ERROR,validation error,58,40.609507,-3.626339
2025-09-17T08:53:05Z,app-2,search,INFO,login failed,144,40.200557,-3.944976
2025-09-17T09:01:05Z,db-1,search,WARN,consume event,48,40.398934,-3.792888
2025-09-17T09:28:05Z,app-2,ingest,INFO,login failed,70,40.614172,-3.907179
2025-09-17T09:37:05Z,web-1,checkout,INFO,login succeeded,93,40.195527,-3.694534
2025-09-17T09:57:05Z,app-2,auth,WARN,request completed,109,40.286648,-3.51853
2025-09-17T10:09:05Z,web-2,ingest,ERROR,db query executed,140,40.336608,-3.485008
2025-09-17T10:16:05Z,web-1,checkout,INFO,publish event,99,40.642552,-3.618499
2025-09-17T10:25:05Z,app-2,ingest,INFO,login failed,98,40.572504,-3.760761
2025-09-17T10:27:05Z,db-1,auth,ERROR,cache miss,102,40.506331,-3.479388
2025-09-17T10:35:05Z,app-1,checkout,WARN,timeout waiting upstream,106,40.299612,-3.915856
2025-09-17T10:37:05Z,db-1,checkout,WARN,timeout waiting upstream,127,40.453249,-3.740568
2025-09-17T10:41:05Z,web-1,checkout,WARN,timeout waiting upstream,49,40.328932,-3.851841
2025-09-17T10:48:05Z,app-1,auth,INFO,validation error,104,40.53561,-3.937045
2025-09-17T10:48:05Z,web-2,ingest,INFO,consume event,146,40.268344,-3.519375
2025-09-17T10:50:05Z,web-2,auth,ERROR,validation error,104,40.496662,-3.948497
2025-09-17T10:58:05Z,web-1,ingest,INFO,cache miss,137,40.457043,-3.823654
2025-09-17T11:07:05Z,web-1,ingest,ERROR,consume event,39,40.56026,-3.693475
2025-09-17T11:10:05Z,app-2,checkout,INFO,db query executed,60,40.262192,-3.733281
2025-09-17T11:11:05Z,web-1,checkout,ERROR,consume event,96,40.433845,-3.918832
2025-09-17T11:28:05Z,app-2,search,INFO,login failed,69,40.623823,-3.828917
2025-09-17T11:28:05Z,app-2,search,WARN,consume event,114,40.583663,-3.801863
2025-09-17T11:31:05Z,app-1,checkout,INFO,login succeeded,110,40.440984,-3.92082
2025-09-17T11:36:05Z,web-2,checkout,INFO,publish event,121,40.388894,-3.667283
2025-09-17T11:38:05Z,web-1,auth,ERROR,login succeeded,79,40.354964,-3.500179
2025-09-17T11:51:05Z,db-1,ingest,INFO,db query executed,104,40.504356,-3.785816
2025-09-17T12:06:05Z,web-1,checkout,WARN,consume event,84,40.552795,-3.593338
2025-09-17T12:29:05Z,web-2,checkout,ERROR,validation error,135,40.565828,-3.597246
2025-09-17T12:30:05Z,web-2,checkout,INFO,timeout waiting upstream,141,40.591947,-3.653594
2025-09-17T12:48:05Z,db-1,search,INFO,db query executed,73,40.305042,-3.791231
2025-09-17T12:53:05Z,app-1,checkout,INFO,login succeeded,92,40.557058,-3.691657
2025-09-17T12:54:05Z,db-1,ingest,WARN,publish event,96,40.627393,-3.661809
2025-09-17T12:55:05Z,app-2,auth,INFO,request completed,77,40.288324,-3.643299
2025-09-17T13:01:05Z,web-2,ingest,INFO,timeout waiting upstream,54,40.279149,-3.784757
2025-09-17T13:03:05Z,web-1,auth,INFO,db query executed,72,40.480928,-3.568049
2025-09-17T13:06:05Z,web-2,ingest,INFO,db query executed,103,40.371194,-3.934387
2025-09-17T13:07:05Z,app-1,search,ERROR,timeout waiting upstream,114,40.175758,-3.951738
2025-09-17T13:08:05Z,web-2,ingest,INFO,cache miss,73,40.218009,-3.876523
2025-09-17T13:14:05Z,app-2,auth,ERROR,consume event,58,40.372204,-3.516996
2025-09-17T13:17:05Z,web-2,auth,ERROR,db query executed,105,40.419514,-3.635192
2025-09-17T13:19:05Z,app-2,ingest,INFO,db query executed,117,40.239016,-3.491722
2025-09-17T13:20:05Z,web-1,ingest,INFO,publish event,106,40.454746,-3.839517
2025-09-17T13:24:05Z,web-2,auth,ERROR,cache miss,70,40.49158,-3.828994
2025-09-17T13:29:05Z,web-2,ingest,INFO,timeout waiting upstream,80,40.549654,-3.490727
2025-09-17T13:40:05Z,app-1,checkout,INFO,login succeeded,126,40.355384,-3.651315
2025-09-17T14:17:05Z,app-1,checkout,INFO,timeout waiting upstream,43,40.596151,-3.742769
2025-09-17T14:18:05Z,app-1,auth,ERROR,login failed,83,40.371848,-3.87138
2025-09-17T14:21:05Z,app-1,ingest,INFO,cache miss,96,40.531893,-3.690596
2025-09-17T14:24:05Z,web-1,auth,WARN,login succeeded,90,40.565177,-3.591138
2025-09-17T14:31:05Z,app-2,auth,INFO,consume event,112,40.384379,-3.493805
2025-09-17T14:34:05Z,web-1,auth,ERROR,request completed,85,40.587536,-3.622688
2025-09-17T14:37:05Z,web-1,checkout,WARN,cache miss,112,40.487588,-3.615231
2025-09-17T14:49:05Z,db-1,auth,WARN,consume event,106,40.534794,-3.626964
2025-09-17T15:05:05Z,db-1,search,INFO,login succeeded,161,40.650492,-3.806229
2025-09-17T15:28:05Z,web-2,checkout,ERROR,login succeeded,77,40.221147,-3.734514
2025-09-17T15:43:05Z,web-1,search,WARN,timeout waiting upstream,111,40.32672,-3.930022
2025-09-17T15:47:05Z,web-2,auth,INFO,timeout waiting upstream,77,40.167898,-3.776231
2025-09-17T16:12:05Z,db-1,ingest,ERROR,validation error,116,40.600973,-3.639802
2025-09-17T16:14:05Z,db-1,checkout,INFO,request completed,72,40.659411,-3.526141
2025-09-17T16:21:05Z,web-1,auth,INFO,login failed,70,40.395273,-3.585713
2025-09-17T16:25:05Z,web-1,search,INFO,request completed,106,40.37268,-3.778255
2025-09-17T16:32:05Z,web-2,search,INFO,login succeeded,104,40.425286,-3.735912
2025-09-17T16:37:05Z,web-2,checkout,ERROR,timeout waiting upstream,118,40.308029,-3.579173
2025-09-17T16:37:05Z,web-2,checkout,INFO,cache miss,107,40.174654,-3.59313
2025-09-17T16:38:05Z,app-1,auth,INFO,validation error,103,40.655106,-3.903998
2025-09-17T16:50:05Z,app-2,search,WARN,publish event,121,40.389479,-3.566417
2025-09-17T17:01:05Z,db-1,auth,INFO,cache miss,82,40.660803,-3.512987
2025-09-17T17:04:05Z,web-1,checkout,INFO,cache miss,126,40.182847,-3.669467
2025-09-17T17:04:05Z,db-1,auth,INFO,publish event,57,40.626999,-3.897331
2025-09-17T17:10:05Z,app-1,ingest,INFO,validation error,57,40.579224,-3.706443
2025-09-17T17:10:05Z,app-2,search,INFO,cache miss,86,40.299484,-3.890421
2025-09-17T17:18:05Z,web-1,checkout,INFO,publish event,109,40.321137,-3.78235
2025-09-17T17:46:05Z,web-1,auth,INFO,publish event,83,40.602071,-3.752896
2025-09-17T17:47:05Z,app-1,search,INFO,consume event,92,40.263707,-3.639785
2025-09-17T18:09:05Z,web-1,checkout,WARN,validation error,146,40.509681,-3.752116
2025-09-17T18:26:05Z,app-1,checkout,INFO,request completed,84,40.433937,-3.870815
2025-09-17T18:27:05Z,app-2,search,INFO,timeout waiting upstream,79,40.534515,-3.517429
2025-09-17T18:47:05Z,app-2,checkout,ERROR,login succeeded,43,40.505682,-3.593336
2025-09-17T18:53:05Z,db-1,auth,INFO,publish event,108,40.392757,-3.925355
2025-09-17T18:54:05Z,web-1,search,INFO,consume event,125,40.304739,-3.922795
2025-09-17T19:17:05Z,web-1,auth,INFO,request completed,63,40.651351,-3.511524
2025-09-17T19:48:05Z,db-1,checkout,ERROR,db query executed,60,40.220291,-3.675725
2025-09-17T19:53:05Z,web-2,auth,WARN,publish event,89,40.571893,-3.896257
2025-09-17T19:54:05Z,web-1,search,INFO,publish event,92,40.611663,-3.654976
2025-09-17T20:07:05Z,db-1,search,INFO,db query executed,158,40.298819,-3.886994
2025-09-17T20:41:05Z,web-2,checkout,INFO,consume event,139,40.447626,-3.794242
2025-09-17T20:44:05Z,web-2,auth,INFO,publish event,74,40.277059,-3.461577
2025-09-17T20:44:05Z,db-1,ingest,WARN,cache miss,88,40.296331,-3.610471
2025-09-17T20:46:05Z,app-1,search,INFO,request completed,114,40.317484,-3.580725
2025-09-17T20:46:05Z,app-2,auth,ERROR,publish event,73,40.649124,-3.616539
2025-09-17T20:55:05Z,app-1,auth,INFO,publish event,130,40.551286,-3.570886
2025-09-17T20:59:05Z,app-1,auth,ERROR,consume event,87,40.313892,-3.769189
2025-09-17T21:03:05Z,db-1,search,WARN,login succeeded,111,40.27631,-3.505918
2025-09-17T21:06:05Z,app-2,ingest,ERROR,cache miss,91,40.247277,-3.843406
2025-09-17T21:06:05Z,app-2,search,WARN,consume event,135,40.654533,-3.686979
2025-09-17T21:16:05Z,web-2,ingest,ERROR,validation error,49,40.571024,-3.842025
2025-09-17T21:19:05Z,app-1,checkout,INFO,consume event,123,40.254027,-3.873732
2025-09-17T21:23:05Z,web-1,ingest,ERROR,consume event,117,40.318841,-3.887823
2025-09-17T21:35:05Z,app-2,search,INFO,db query executed,110,40.23798,-3.840513
2025-09-17T22:06:05Z,app-1,search,WARN,cache miss,86,40.393662,-3.476892
2025-09-17T22:10:05Z,web-2,checkout,WARN,request completed,116,40.295389,-3.896478
2025-09-17T22:12:05Z,db-1,checkout,INFO,timeout waiting upstream,117,40.177546,-3.532359
2025-09-17T22:17:05Z,app-2,search,INFO,db query executed,80,40.422042,-3.896787
2025-09-17T22:30:05Z,app-1,ingest,INFO,cache miss,62,40.543876,-3.840993
2025-09-17T22:35:05Z,app-1,auth,INFO,cache miss,84,40.229714,-3.837463
2025-09-17T22:36:05Z,db-1,auth,INFO,db query executed,81,40.360082,-3.827802
2025-09-17T22:52:05Z,web-2,search,INFO,consume event,137,40.563351,-3.571686
2025-09-17T22:52:05Z,web-2,ingest,INFO,db query executed,111,40.325239,-3.808122
2025-09-17T23:05:05Z,web-1,search,INFO,timeout waiting upstream,141,40.356018,-3.925179
2025-09-17T23:20:05Z,app-1,checkout,INFO,timeout waiting upstream,99,40.560845,-3.788141
2025-09-17T23:26:05Z,app-2,checkout,INFO,login succeeded,98,40.625498,-3.717573
2025-09-17T23:36:05Z,app-1,auth,INFO,validation error,164,40.265238,-3.789188
2025-09-17T23:41:05Z,web-1,ingest,WARN,db query executed,114,40.49319,-3.652649
2025-09-17T23:42:05Z,db-1,ingest,INFO,db query executed,95,40.254744,-3.561054
2025-09-17T23:42:05Z,web-1,checkout,INFO,publish event,102,40.194016,-3.787006
2025-09-18T00:05:05Z,db-1,auth,INFO,validation error,98,40.543244,-3.604773
2025-09-18T00:06:05Z,app-2,ingest,INFO,request completed,77,40.16948,-3.701529
2025-09-18T00:08:05Z,web-2,auth,INFO,login succeeded,72,40.467858,-3.547086
2025-09-18T00:12:05Z,app-2,auth,INFO,consume event,140,40.336074,-3.632402
2025-09-18T00:17:05Z,web-2,checkout,INFO,cache miss,91,40.560487,-3.899752
2025-09-18T00:22:05Z,web-1,search,INFO,timeout waiting upstream,96,40.641954,-3.64466
2025-09-18T00:44:05Z,web-1,ingest,WARN,request completed,59,40.489626,-3.713052
2025-09-18T00:44:05Z,web-2,checkout,INFO,cache miss,136,40.55363,-3.641117
2025-09-18T00:49:05Z,db-1,ingest,WARN,timeout waiting upstream,96,40.641146,-3.921945
2025-09-18T01:46:05Z,web-2,auth,INFO,cache miss,98,40.481878,-3.55829
2025-09-18T01:47:05Z,web-2,checkout,INFO,cache miss,105,40.560056,-3.51557
2025-09-18T01:52:05Z,app-1,search,WARN,publish event,143,40.280869,-3.677281
2025-09-18T01:54:05Z,web-1,ingest,INFO,timeout waiting upstream,123,40.204144,-3.852444
2025-09-18T01:59:05Z,web-2,checkout,INFO,timeout waiting upstream,104,40.215832,-3.584926
2025-09-18T02:12:05Z,web-2,search,WARN,consume event,89,40.51769,-3.527404
2025-09-18T02:14:05Z,app-2,ingest,INFO,login failed,108,40.60696,-3.603208
2025-09-18T02:17:05Z,web-2,ingest,INFO,db query executed,118,40.645639,-3.557444
2025-09-18T02:43:05Z,web-2,checkout,WARN,validation error,97,40.21444,-3.924424
2025-09-18T02:44:05Z,web-1,checkout,WARN,db query executed,58,40.564965,-3.65809
2025-09-18T02:46:05Z,app-2,auth,ERROR,consume event,124,40.316207,-3.773587
2025-09-18T02:50:05Z,web-1,search,ERROR,cache miss,68,40.33867,-3.612524
2025-09-18T02:54:05Z,app-2,checkout,WARN,publish event,57,40.49139,-3.866699
2025-09-18T03:01:05Z,app-1,search,INFO,login failed,90,40.409068,-3.584198
2025-09-18T03:10:05Z,web-1,checkout,WARN,login failed,93,40.174737,-3.607877
2025-09-18T03:26:05Z,app-2,search,INFO,consume event,104,40.197279,-3.47954
2025-09-18T03:33:05Z,app-2,search,INFO,validation error,157,40.537426,-3.94569
2025-09-18T03:43:05Z,web-1,auth,ERROR,consume event,93,40.245553,-3.599018
2025-09-18T04:34:05Z,db-1,ingest,WARN,timeout waiting upstream,160,40.635286,-3.772301
2025-09-18T04:36:05Z,app-1,ingest,INFO,consume event,83,40.169749,-3.593657
2025-09-18T04:37:05Z,web-2,checkout,INFO,login failed,100,40.536708,-3.735738
2025-09-18T04:39:05Z,app-1,auth,WARN,db query executed,130,40.20343,-3.847223
2025-09-18T04:43:05Z,app-2,search,INFO,publish event,92,40.308496,-3.58027
2025-09-18T04:47:05Z,web-2,search,INFO,consume event,100,40.596051,-3.929945
2025-09-18T04:50:05Z,db-1,auth,INFO,login failed,95,40.566568,-3.509785
2025-09-18T04:51:05Z,web-2,auth,INFO,timeout waiting upstream,129,40.417125,-3.724807
2025-09-18T05:00:05Z,app-1,search,ERROR,consume event,98,40.444962,-3.490839
2025-09-18T05:07:05Z,app-1,search,WARN,db query executed,77,40.392753,-3.478437
2025-09-18T05:20:05Z,web-1,auth,INFO,consume event,86,40.368769,-3.63186
2025-09-18T05:21:05Z,app-1,auth,ERROR,publish event,110,40.418225,-3.52744
2025-09-18T05:25:05Z,web-1,ingest,INFO,validation error,102,40.273854,-3.816526
2025-09-18T05:30:05Z,app-2,ingest,WARN,timeout waiting upstream,52,40.38614,-3.527328
2025-09-18T05:32:05Z,db-1,search,ERROR,consume event,54,40.498108,-3.931432
2025-09-18T05:40:05Z,app-1,search,INFO,login failed,107,40.432938,-3.567406
2025-09-18T05:41:05Z,db-1,search,WARN,consume event,129,40.457315,-3.611776
2025-09-18T05:44:05Z,db-1,search,INFO,request completed,95,40.180746,-3.555501
2025-09-18T05:54:05Z,web-1,auth,INFO,cache miss,122,40.503784,-3.817749
2025-09-18T06:04:05Z,app-1,search,INFO,timeout waiting upstream,138,40.276364,-3.887016
2025-09-18T06:14:05Z,web-2,ingest,INFO,timeout waiting upstream,129,40.238661,-3.50595
2025-09-18T06:37:05Z,web-1,search,INFO,cache miss,126,40.367192,-3.882863
2025-09-18T06:52:05Z,app-1,ingest,ERROR,timeout waiting upstream,36,40.389786,-3.907559
2025-09-18T07:17:05Z,db-1,ingest,INFO,consume event,84,40.34125,-3.667721
2025-09-18T07:18:05Z,app-2,search,INFO,publish event,72,40.352751,-3.809727
2025-09-18T07:18:05Z,web-2,ingest,INFO,publish event,94,40.601819,-3.77752
2025-09-18T07:26:05Z,web-2,ingest,ERROR,cache miss,126,40.442076,-3.886635
2025-09-18T07:44:05Z,app-1,search,INFO,request completed,91,40.495684,-3.742563
2025-09-18T07:45:05Z,app-2,ingest,ERROR,request completed,141,40.65501,-3.72192
2025-09-18T07:55:05Z,db-1,auth,INFO,login failed,128,40.651,-3.755678
2025-09-18T08:00:05Z,app-1,checkout,ERROR,db query executed,117,40.359466,-3.85724
2025-09-18T08:04:05Z,app-2,checkout,ERROR,request completed,91,40.666431,-3.774407
2025-09-18T08:30:05Z,web-2,checkout,WARN,login succeeded,94,40.393572,-3.609493
2025-09-18T08:45:05Z,web-2,search,INFO,login failed,82,40.429498,-3.475306
2025-09-18T08:47:05Z,web-1,search,INFO,consume event,51,40.173249,-3.694715
2025-09-18T09:01:05Z,db-1,checkout,ERROR,cache miss,98,40.393602,-3.766227
2025-09-18T09:16:05Z,web-1,search,WARN,db query executed,103,40.199263,-3.718392
2025-09-18T09:17:05Z,db-1,search,ERROR,consume event,53,40.316695,-3.545926
2025-09-18T09:18:05Z,web-2,search,WARN,login succeeded,109,40.408404,-3.835197
2025-09-18T09:31:05Z,db-1,checkout,INFO,login failed,160,40.564412,-3.861355
2025-09-18T09:36:05Z,web-1,auth,ERROR,consume event,44,40.237487,-3.932913
2025-09-18T09:37:05Z,app-1,ingest,INFO,db query executed,90,40.365248,-3.533895
2025-09-18T09:43:05Z,web-1,checkout,WARN,login failed,61,40.634043,-3.592968
2025-09-18T10:32:05Z,web-1,checkout,INFO,login succeeded,87,40.530286,-3.671947
2025-09-18T11:16:05Z,db-1,search,INFO,request completed,127,40.577719,-3.582545
2025-09-18T11:39:05Z,web-1,checkout,INFO,consume event,58,40.521976,-3.573412
2025-09-18T11:41:05Z,app-1,search,INFO,login failed,138,40.540469,-3.846807
2025-09-18T11:57:05Z,web-1,auth,INFO,publish event,99,40.356904,-3.601964
2025-09-18T12:00:05Z,app-2,auth,INFO,publish event,90,40.303451,-3.828356
2025-09-18T12:11:05Z,web-2,auth,WARN,login succeeded,122,40.516667,-3.482462
2025-09-18T12:24:05Z,app-1,ingest,WARN,login failed,104,40.644104,-3.551492
2025-09-18T12:27:05Z,db-1,checkout,INFO,publish event,111,40.639418,-3.459974
2025-09-18T12:33:05Z,web-1,search,INFO,db query executed,87,40.536143,-3.528633
2025-09-18T12:34:05Z,web-2,search,INFO,consume event,97,40.454371,-3.642178
2025-09-18T12:36:05Z,app-1,auth,ERROR,consume event,70,40.643916,-3.584339
2025-09-18T12:55:05Z,web-2,checkout,WARN,login succeeded,130,40.473367,-3.926527
2025-09-18T13:11:05Z,web-2,checkout,ERROR,timeout waiting upstream,123,40.321534,-3.549488
2025-09-18T13:12:05Z,app-1,checkout,WARN,validation error,102,40.538762,-3.503301
2025-09-18T13:16:05Z,web-1,search,INFO,publish event,147,40.603951,-3.910001
2025-09-18T13:19:05Z,db-1,auth,ERROR,cache miss,125,40.316967,-3.842857
2025-09-18T13:38:05Z,db-1,checkout,INFO,db query executed,121,40.322489,-3.507678
2025-09-18T13:43:05Z,app-2,ingest,INFO,validation error,101,40.654864,-3.836057
2025-09-18T13:58:05Z,app-1,search,INFO,cache miss,118,40.260724,-3.882039
2025-09-18T13:59:05Z,db-1,search,ERROR,db query executed,114,40.640055,-3.759018
2025-09-18T14:13:05Z,web-1,checkout,INFO,login succeeded,107,40.65686,-3.470152
2025-09-18T14:17:05Z,app-1,ingest,ERROR,login failed,123,40.550221,-3.453997
2025-09-18T14:22:05Z,app-2,auth,WARN,publish event,55,40.276727,-3.806219
2025-09-18T14:31:05Z,app-2,ingest,INFO,db query executed,111,40.474243,-3.870083
2025-09-18T14:34:05Z,web-2,checkout,INFO,timeout waiting upstream,83,40.490439,-3.704354
2025-09-18T14:37:05Z,app-2,search,INFO,consume event,66,40.636308,-3.662169
2025-09-18T14:41:05Z,web-2,auth,ERROR,db query executed,101,40.498668,-3.619441
2025-09-18T15:08:05Z,db-1,checkout,INFO,publish event,102,40.615053,-3.796848
2025-09-18T15:15:05Z,db-1,search,INFO,cache miss,125,40.594369,-3.563399
2025-09-18T15:17:05Z,app-2,checkout,ERROR,login succeeded,104,40.600024,-3.887898
2025-09-18T15:23:05Z,web-1,search,INFO,cache miss,103,40.425447,-3.833649
2025-09-18T15:25:05Z,app-1,search,INFO,timeout waiting upstream,86,40.405749,-3.617398
2025-09-18T15:26:05Z,app-1,auth,INFO,cache miss,84,40.537415,-3.67796
2025-09-18T15:31:05Z,web-2,search,INFO,cache miss,142,40.557166,-3.815156
2025-09-18T15:33:05Z,db-1,auth,ERROR,timeout waiting upstream,73,40.209606,-3.593763
2025-09-18T15:36:05Z,db-1,auth,WARN,timeout waiting upstream,108,40.558538,-3.716165
2025-09-18T15:38:05Z,app-2,ingest,INFO,db query executed,60,40.232043,-3.582506
2025-09-18T15:47:05Z,app-2,auth,INFO,publish event,127,40.570583,-3.690872
2025-09-18T15:48:05Z,web-2,ingest,INFO,publish event,99,40.505398,-3.541645
2025-09-18T16:02:05Z,app-1,auth,ERROR,publish event,132,40.55467,-3.838741
2025-09-18T16:10:05Z,app-1,search,INFO,db query executed,98,40.352722,-3.5019
2025-09-18T16:14:05Z,app-2,checkout,INFO,cache miss,120,40.472791,-3.820369
2025-09-18T16:14:05Z,db-1,search,INFO,timeout waiting upstream,125,40.54773,-3.893185
2025-09-18T16:45:05Z,web-1,search,WARN,timeout waiting upstream,111,40.311598,-3.635354
2025-09-18T16:55:05Z,app-1,search,INFO,consume event,95,40.278393,-3.695913
2025-09-18T17:18:05Z,web-2,checkout,INFO,timeout waiting upstream,162,40.659614,-3.520235
2025-09-18T17:24:05Z,db-1,auth,INFO,publish event,67,40.305878,-3.455327
2025-09-18T17:39:05Z,web-1,auth,INFO,login succeeded,82,40.322275,-3.532377
2025-09-18T17:57:05Z,db-1,ingest,INFO,publish event,118,40.557287,-3.484415
2025-09-18T17:57:05Z,db-1,auth,INFO,request completed,120,40.422571,-3.535558
2025-09-18T18:00:05Z,web-2,auth,INFO,validation error,115,40.396299,-3.832196
2025-09-18T18:02:05Z,app-1,search,INFO,publish event,121,40.408971,-3.78758
2025-09-18T18:05:05Z,app-1,checkout,ERROR,timeout waiting upstream,115,40.661562,-3.6338
2025-09-18T18:05:05Z,web-1,search,ERROR,request completed,98,40.297577,-3.774024
2025-09-18T18:14:05Z,app-2,search,WARN,request completed,29,40.41214,-3.735771
2025-09-18T18:34:05Z,app-2,search,INFO,timeout waiting upstream,88,40.583672,-3.60203
2025-09-18T18:48:05Z,db-1,ingest,INFO,timeout waiting upstream,123,40.306303,-3.80455
2025-09-18T18:52:05Z,web-2,ingest,ERROR,publish event,41,40.185533,-3.816093
2025-09-18T18:54:05Z,db-1,ingest,INFO,request completed,120,40.212949,-3.742012
2025-09-18T19:04:05Z,db-1,checkout,ERROR,db query executed,117,40.486275,-3.649315
2025-09-18T19:07:05Z,app-1,auth,INFO,consume event,50,40.482613,-3.547479
2025-09-18T19:11:05Z,app-1,ingest,INFO,consume event,141,40.549069,-3.498823
2025-09-18T19:24:05Z,db-1,ingest,INFO,db query executed,103,40.504218,-3.718062
2025-09-18T19:31:05Z,web-1,ingest,INFO,login succeeded,62,40.266889,-3.885936
2025-09-18T19:34:05Z,web-1,ingest,WARN,db query executed,71,40.568208,-3.592593
2025-09-18T19:46:05Z,web-1,checkout,INFO,consume event,110,40.38211,-3.645019
2025-09-18T19:49:05Z,app-2,search,INFO,timeout waiting upstream,124,40.363547,-3.76514
2025-09-18T19:50:05Z,db-1,search,WARN,db query executed,74,40.402068,-3.520603
2025-09-18T20:03:05Z,app-2,search,INFO,request completed,86,40.428458,-3.574653
2025-09-18T20:32:05Z,web-1,ingest,INFO,login failed,114,40.393442,-3.938668
2025-09-18T20:38:05Z,web-2,auth,ERROR,login succeeded,104,40.363223,-3.88517
2025-09-18T21:01:05Z,web-1,auth,ERROR,validation error,119,40.451332,-3.845081
2025-09-18T21:13:05Z,web-1,auth,INFO,login succeeded,115,40.624745,-3.638124
2025-09-18T21:20:05Z,app-1,auth,INFO,consume event,127,40.168084,-3.524455
2025-09-18T21:37:05Z,web-1,ingest,WARN,validation error,91,40.166898,-3.936469
2025-09-18T21:59:05Z,app-2,auth,INFO,request completed,141,40.663957,-3.723167
2025-09-18T22:02:05Z,db-1,search,INFO,publish event,89,40.384863,-3.71239
2025-09-18T22:06:05Z,app-1,ingest,INFO,consume event,169,40.278911,-3.919491
2025-09-18T22:06:05Z,web-2,search,INFO,login succeeded,123,40.222564,-3.619326
2025-09-18T22:57:05Z,db-1,auth,WARN,login failed,120,40.406642,-3.563082
2025-09-18T22:58:05Z,db-1,ingest,WARN,cache miss,115,40.38628,-3.776799
2025-09-18T23:03:05Z,app-2,search,INFO,cache miss,128,40.319858,-3.921156
2025-09-18T23:04:05Z,db-1,checkout,ERROR,consume event,112,40.374392,-3.901043
2025-09-18T23:23:05Z,app-2,search,ERROR,db query executed,123,40.621995,-3.92105
2025-09-18T23:24:05Z,web-1,auth,WARN,login succeeded,130,40.341088,-3.545436
2025-09-18T23:25:05Z,db-1,auth,ERROR,publish event,73,40.430887,-3.772908
2025-09-18T23:27:05Z,web-2,checkout,WARN,db query executed,151,40.517372,-3.702633
2025-09-18T23:38:05Z,app-2,search,WARN,timeout waiting upstream,79,40.612711,-3.657914
2025-09-18T23:39:05Z,web-2,checkout,WARN,db query executed,124,40.234545,-3.950416
2025-09-19T00:07:05Z,web-2,checkout,ERROR,timeout waiting upstream,122,40.31835,-3.665589
2025-09-19T00:27:05Z,app-1,checkout,ERROR,cache miss,123,40.612199,-3.880367
2025-09-19T00:33:05Z,web-1,search,WARN,consume event,101,40.432261,-3.741048
2025-09-19T00:42:05Z,db-1,checkout,WARN,cache miss,128,40.23622,-3.803234
2025-09-19T00:47:05Z,app-1,checkout,INFO,request completed,121,40.403002,-3.613204
2025-09-19T01:27:05Z,app-1,checkout,ERROR,request completed,121,40.631595,-3.549627
2025-09-19T01:40:05Z,web-1,ingest,INFO,login succeeded,102,40.613313,-3.913511
2025-09-19T01:50:05Z,app-1,checkout,INFO,validation error,130,40.194314,-3.62076
2025-09-19T01:52:05Z,app-1,checkout,INFO,request completed,101,40.39888,-3.673887
2025-09-19T01:52:05Z,web-2,ingest,INFO,consume event,78,40.649277,-3.547911
2025-09-19T01:53:05Z,web-2,ingest,INFO,db query executed,118,40.434827,-3.637823
2025-09-19T02:21:05Z,app-1,ingest,INFO,publish event,127,40.456267,-3.911033
2025-09-19T02:21:05Z,db-1,search,WARN,consume event,93,40.185733,-3.712166
2025-09-19T02:27:05Z,app-2,ingest,WARN,publish event,106,40.196118,-3.764313
2025-09-19T02:28:05Z,app-1,auth,WARN,login succeeded,124,40.628353,-3.509899
2025-09-19T02:51:05Z,web-1,checkout,INFO,cache miss,122,40.404368,-3.528931
2025-09-19T03:10:05Z,app-1,search,ERROR,db query executed,100,40.559407,-3.801494
2025-09-19T03:44:05Z,db-1,checkout,INFO,login failed,107,40.286428,-3.953656
2025-09-19T03:48:05Z,app-2,search,WARN,publish event,129,40.192628,-3.898773
2025-09-19T03:52:05Z,web-2,search,INFO,publish event,88,40.19184,-3.547211
2025-09-19T04:17:05Z,app-2,ingest,INFO,cache miss,88,40.529312,-3.897378
2025-09-19T04:52:05Z,app-1,ingest,INFO,db query executed,102,40.388639,-3.606799
2025-09-19T05:12:05Z,db-1,checkout,WARN,validation error,79,40.370367,-3.900568
2025-09-19T05:13:05Z,web-1,auth,INFO,db query executed,123,40.209654,-3.781904
2025-09-19T05:14:05Z,web-2,auth,ERROR,login succeeded,130,40.181277,-3.817165
2025-09-19T05:19:05Z,web-1,auth,INFO,db query executed,75,40.404803,-3.635426
2025-09-19T05:21:05Z,app-2,ingest,ERROR,request completed,108,40.455769,-3.530398
2025-09-19T05:27:05Z,web-1,checkout,WARN,request completed,118,40.447993,-3.469907
2025-09-19T05:38:05Z,app-1,ingest,INFO,cache miss,74,40.415988,-3.595498
2025-09-19T05:44:05Z,app-2,checkout,INFO,consume event,156,40.251292,-3.770504
2025-09-19T06:18:05Z,app-2,checkout,WARN,login failed,131,40.509943,-3.485013
2025-09-19T06:30:05Z,db-1,auth,ERROR,login succeeded,109,40.395821,-3.471787
2025-09-19T06:37:05Z,app-2,auth,WARN,publish event,112,40.232416,-3.94511
2025-09-19T06:49:05Z,app-2,search,WARN,login failed,95,40.582889,-3.829671
2025-09-19T07:05:05Z,db-1,ingest,INFO,cache miss,88,40.25485,-3.65754
2025-09-19T07:34:05Z,app-2,auth,INFO,cache miss,76,40.474586,-3.73022
2025-09-19T07:37:05Z,web-1,auth,WARN,publish event,119,40.195548,-3.950854
2025-09-19T07:58:05Z,db-1,search,INFO,db query executed,100,40.353908,-3.935102
2025-09-19T08:00:05Z,db-1,search,INFO,cache miss,95,40.441724,-3.823463
2025-09-19T08:15:05Z,db-1,search,INFO,request completed,110,40.307478,-3.655041
2025-09-19T08:30:05Z,web-1,ingest,INFO,timeout waiting upstream,117,40.314696,-3.55974
2025-09-19T08:47:05Z,app-2,ingest,INFO,validation error,105,40.661739,-3.772391
2025-09-19T08:54:05Z,app-2,ingest,INFO,db query executed,77,40.224243,-3.814516
2025-09-19T09:08:05Z,app-2,search,ERROR,publish event,131,40.478321,-3.457649
2025-09-19T09:12:05Z,app-2,auth,INFO,validation error,107,40.631302,-3.79055
2025-09-19T09:19:05Z,app-2,ingest,INFO,timeout waiting upstream,66,40.444511,-3.532136
2025-09-19T09:22:05Z,web-1,auth,INFO,timeout waiting upstream,68,40.253707,-3.916268
2025-09-19T09:25:05Z,db-1,search,INFO,login succeeded,146,40.303307,-3.622661
2025-09-19T09:26:05Z,app-2,ingest,INFO,timeout waiting upstream,54,40.654912,-3.566197
2025-09-19T09:27:05Z,web-2,auth,INFO,login failed,82,40.441082,-3.83523
2025-09-19T09:29:05Z,app-2,auth,INFO,publish event,72,40.530498,-3.804249
2025-09-19T09:36:05Z,web-2,search,WARN,publish event,80,40.403393,-3.50321
2025-09-19T09:41:05Z,web-2,checkout,ERROR,consume event,102,40.397501,-3.557843
2025-09-19T09:43:05Z,app-2,checkout,INFO,login failed,84,40.529779,-3.665959
2025-09-19T09:45:05Z,web-2,search,INFO,validation error,92,40.318216,-3.827459
2025-09-19T10:10:05Z,web-1,auth,INFO,db query executed,113,40.651087,-3.716594
2025-09-19T10:18:05Z,web-2,search,WARN,login succeeded,108,40.593041,-3.90859
2025-09-19T10:22:05Z,db-1,auth,WARN,request completed,141,40.541668,-3.763222
2025-09-19T10:23:05Z,db-1,ingest,WARN,request completed,80,40.485552,-3.948151
2025-09-19T10:32:05Z,db-1,search,WARN,publish event,78,40.625751,-3.513024
2025-09-19T10:32:05Z,web-1,ingest,ERROR,request completed,151,40.5079,-3.716751
2025-09-19T10:32:05Z,app-2,checkout,INFO,login failed,100,40.244798,-3.900455
2025-09-19T10:34:05Z,app-2,auth,ERROR,login failed,68,40.43294,-3.655371
2025-09-19T10:48:05Z,web-1,auth,ERROR,db query executed,111,40.349697,-3.855263
2025-09-19T10:50:05Z,web-1,search,ERROR,login succeeded,107,40.626051,-3.485462
2025-09-19T11:09:05Z,web-2,checkout,ERROR,login failed,104,40.433625,-3.77417
2025-09-19T11:45:05Z,app-2,search,ERROR,cache miss,132,40.381832,-3.499299
2025-09-19T11:48:05Z,app-1,ingest,ERROR,request completed,119,40.243839,-3.783742
2025-09-19T11:54:05Z,app-2,search,INFO,timeout waiting upstream,113,40.212493,-3.742959
2025-09-19T12:00:05Z,web-1,ingest,INFO,login failed,85,40.387488,-3.701154
2025-09-19T12:03:05Z,web-1,search,INFO,login succeeded,133,40.316942,-3.678803
2025-09-19T12:12:05Z,db-1,ingest,INFO,publish event,154,40.221015,-3.683484
2025-09-19T12:23:05Z,web-2,checkout,INFO,publish event,73,40.459346,-3.92663
2025-09-19T12:31:05Z,app-1,search,INFO,consume event,29,40.365912,-3.546097
2025-09-19T12:38:05Z,db-1,ingest,ERROR,request completed,115,40.33332,-3.716928
2025-09-19T12:53:05Z,db-1,auth,WARN,cache miss,145,40.5161,-3.905169
2025-09-19T13:11:05Z,web-1,ingest,INFO,login failed,98,40.478378,-3.622106
2025-09-19T13:18:05Z,web-1,search,INFO,login succeeded,106,40.262121,-3.651783
2025-09-19T13:27:05Z,db-1,checkout,INFO,db query executed,96,40.509169,-3.665791
2025-09-19T13:38:05Z,app-2,checkout,INFO,login failed,97,40.261478,-3.715937
2025-09-19T13:43:05Z,app-2,auth,INFO,publish event,107,40.503331,-3.679427
2025-09-19T14:07:05Z,db-1,checkout,ERROR,login succeeded,102,40.344496,-3.7131
2025-09-19T14:08:05Z,app-1,auth,INFO,publish event,100,40.47953,-3.894837
2025-09-19T14:09:05Z,web-1,ingest,INFO,db query executed,107,40.423723,-3.765201
2025-09-19T14:15:05Z,app-2,ingest,WARN,consume event,95,40.330763,-3.753383
2025-09-19T14:15:05Z,web-2,search,INFO,db query executed,145,40.650245,-3.814238
2025-09-19T14:25:05Z,web-1,ingest,INFO,cache miss,86,40.207774,-3.922703
2025-09-19T14:36:05Z,web-1,ingest,WARN,db query executed,112,40.313363,-3.764936
2025-09-19T14:53:05Z,app-1,auth,INFO,request completed,110,40.49167,-3.735906
2025-09-19T15:10:05Z,app-1,ingest,INFO,timeout waiting upstream,77,40.487652,-3.655227
2025-09-19T15:12:05Z,app-2,ingest,INFO,login failed,33,40.289075,-3.930702
2025-09-19T15:13:05Z,app-1,auth,ERROR,login failed,31,40.636942,-3.468554
2025-09-19T15:14:05Z,db-1,checkout,ERROR,validation error,114,40.27369,-3.775512
2025-09-19T15:22:05Z,app-1,auth,INFO,consume event,105,40.489136,-3.747954
2025-09-19T15:29:05Z,web-2,search,INFO,timeout waiting upstream,85,40.416591,-3.656835
2025-09-19T15:30:05Z,web-2,ingest,WARN,timeout waiting upstream,125,40.361662,-3.764621
2025-09-19T15:57:05Z,app-2,search,ERROR,db query executed,83,40.331912,-3.897131
2025-09-19T15:59:05Z,web-2,ingest,INFO,consume event,98,40.37905,-3.738496
2025-09-19T16:28:05Z,app-2,checkout,ERROR,publish event,147,40.638478,-3.863597
2025-09-19T16:44:05Z,app-1,checkout,ERROR,timeout waiting upstream,96,40.631114,-3.697402
2025-09-19T16:44:05Z,db-1,auth,ERROR,request completed,106,40.575798,-3.929543
2025-09-19T17:00:05Z,web-1,checkout,ERROR,validation error,85,40.358655,-3.860923
2025-09-19T17:13:05Z,app-2,checkout,INFO,timeout waiting upstream,88,40.225259,-3.456913
2025-09-19T17:14:05Z,web-2,auth,INFO,validation error,94,40.605178,-3.804976
2025-09-19T17:31:05Z,app-2,checkout,INFO,db query executed,105,40.661999,-3.489251
2025-09-19T17:37:05Z,db-1,auth,INFO,db query executed,139,40.577662,-3.534993
2025-09-19T17:37:05Z,db-1,checkout,WARN,request completed,61,40.285565,-3.731701
2025-09-19T17:43:05Z,db-1,search,INFO,db query executed,112,40.206834,-3.62334
2025-09-19T17:49:05Z,app-2,checkout,INFO,validation error,124,40.476655,-3.833385
2025-09-19T17:52:05Z,web-1,auth,INFO,db query executed,60,40.172781,-3.904951
2025-09-19T18:23:05Z,web-1,auth,ERROR,timeout waiting upstream,126,40.392363,-3.751576
2025-09-19T18:32:05Z,web-1,auth,INFO,cache miss,100,40.460105,-3.495188
2025-09-19T18:36:05Z,web-1,auth,ERROR,validation error,121,40.172405,-3.817174
2025-09-19T18:42:05Z,db-1,search,INFO,publish event,76,40.36134,-3.571794
2025-09-19T18:51:05Z,app-2,auth,INFO,login failed,56,40.309332,-3.736464
2025-09-19T19:02:05Z,app-1,auth,INFO,request completed,127,40.248716,-3.477292
2025-09-19T19:08:05Z,db-1,auth,ERROR,timeout waiting upstream,117,40.436617,-3.629281
2025-09-19T19:10:05Z,web-2,ingest,INFO,login failed,124,40.637593,-3.618129
2025-09-19T19:16:05Z,web-2,auth,ERROR,publish event,105,40.324626,-3.949591
2025-09-19T19:27:05Z,web-1,checkout,INFO,timeout waiting upstream,124,40.562833,-3.835432
2025-09-19T19:34:05Z,db-1,checkout,INFO,consume event,142,40.322531,-3.592963
2025-09-19T19:34:05Z,app-2,auth,WARN,login failed,76,40.418855,-3.761469
2025-09-19T19:35:05Z,app-1,ingest,INFO,request completed,94,40.361393,-3.724412
2025-09-19T20:04:05Z,web-1,ingest,WARN,cache miss,90,40.661598,-3.889231
2025-09-19T20:12:05Z,app-1,ingest,WARN,login failed,116,40.449728,-3.52482
2025-09-19T20:39:05Z,app-1,search,ERROR,login failed,107,40.213494,-3.4778
2025-09-19T20:55:05Z,app-1,search,INFO,login failed,117,40.368945,-3.837365
2025-09-19T21:00:05Z,web-2,auth,INFO,db query executed,30,40.553672,-3.74488
2025-09-19T21:01:05Z,web-1,search,INFO,login succeeded,134,40.616878,-3.54621
2025-09-19T21:02:05Z,db-1,search,ERROR,timeout waiting upstream,30,40.429808,-3.668406
2025-09-19T21:06:05Z,web-1,checkout,WARN,timeout waiting upstream,107,40.216784,-3.530117
2025-09-19T21:12:05Z,web-1,ingest,ERROR,db query executed,103,40.221085,-3.852626
2025-09-19T21:23:05Z,app-1,ingest,ERROR,db query executed,96,40.574612,-3.79246
2025-09-19T21:34:05Z,web-1,checkout,ERROR,validation error,126,40.466479,-3.671998
2025-09-19T21:42:05Z,db-1,checkout,WARN,cache miss,50,40.256373,-3.479444
2025-09-19T21:48:05Z,app-1,ingest,INFO,timeout waiting upstream,88,40.214392,-3.847089
2025-09-19T21:50:05Z,app-1,ingest,INFO,timeout waiting upstream,88,40.420265,-3.678552
2025-09-19T21:56:05Z,web-1,ingest,INFO,consume event,126,40.56591,-3.927189
2025-09-19T22:00:05Z,web-1,auth,INFO,publish event,111,40.242049,-3.851672
2025-09-19T22:07:05Z,web-2,auth,WARN,request completed,77,40.618056,-3.924895
2025-09-19T22:24:05Z,web-2,ingest,INFO,login succeeded,68,40.505063,-3.4837
2025-09-19T22:44:05Z,app-2,checkout,INFO,request completed,105,40.48739,-3.516742
2025-09-19T23:03:05Z,web-1,search,INFO,request completed,135,40.512097,-3.80623
2025-09-19T23:13:05Z,app-2,ingest,INFO,db query executed,66,40.56671,-3.59664
2025-09-19T23:18:05Z,app-1,checkout,ERROR,publish event,110,40.556058,-3.770636
2025-09-19T23:24:05Z,app-1,checkout,INFO,login succeeded,48,40.53533,-3.571775
2025-09-19T23:24:05Z,web-2,search,INFO,cache miss,139,40.274457,-3.572053
2025-09-19T23:28:05Z,app-1,ingest,ERROR,publish event,114,40.25743,-3.763925
2025-09-19T23:31:05Z,app-1,ingest,INFO,validation error,60,40.545657,-3.758268
2025-09-19T23:34:05Z,web-2,ingest,INFO,login failed,111,40.382374,-3.463697
2025-09-19T23:48:05Z,db-1,ingest,INFO,login failed,116,40.441841,-3.455375
2025-09-19T23:50:05Z,web-2,ingest,WARN,publish event,111,40.323091,-3.594619
2025-09-20T00:00:05Z,app-1,search,WARN,login failed,85,40.266955,-3.946117
2025-09-20T00:00:05Z,app-1,auth,INFO,db query executed,62,40.284402,-3.893857
2025-09-20T00:11:05Z,db-1,checkout,ERROR,consume event,124,40.594302,-3.910563
2025-09-20T00:18:05Z,db-1,checkout,INFO,validation error,116,40.314289,-3.636777
2025-09-20T00:32:05Z,app-2,checkout,WARN,login succeeded,145,40.65405,-3.600049
2025-09-20T00:39:05Z,web-2,auth,INFO,publish event,128,40.385478,-3.500196
2025-09-20T00:45:05Z,app-1,auth,WARN,login failed,113,40.611613,-3.828872
2025-09-20T00:53:05Z,web-1,ingest,INFO,request completed,79,40.180386,-3.924549
2025-09-20T00:54:05Z,web-2,ingest,INFO,publish event,85,40.66215,-3.714183
2025-09-20T00:54:05Z,app-1,search,WARN,validation error,119,40.534745,-3.49295
2025-09-20T00:56:05Z,web-1,search,WARN,db query executed,101,40.493706,-3.507457
2025-09-20T01:10:05Z,web-2,search,WARN,consume event,143,40.567797,-3.540998
2025-09-20T01:11:05Z,app-2,auth,INFO,validation error,76,40.301789,-3.650983
2025-09-20T01:13:05Z,web-2,checkout,ERROR,login succeeded,147,40.474756,-3.493991
2025-09-20T01:15:05Z,web-1,checkout,ERROR,consume event,81,40.626047,-3.654328
2025-09-20T01:27:05Z,web-2,auth,INFO,consume event,53,40.649477,-3.787803
2025-09-20T01:43:05Z,web-2,search,INFO,login succeeded,101,40.558064,-3.835702
2025-09-20T01:48:05Z,app-2,ingest,INFO,timeout waiting upstream,127,40.198914,-3.75
2025-09-20T01:51:05Z,app-1,ingest,INFO,login failed,147,40.376922,-3.560937
2025-09-20T02:00:05Z,app-2,checkout,INFO,request completed,134,40.376591,-3.799041
2025-09-20T02:08:05Z,app-2,auth,INFO,db query executed,113,40.606868,-3.514853
2025-09-20T02:09:05Z,web-1,checkout,INFO,request completed,52,40.65232,-3.57738
2025-09-20T02:09:05Z,web-2,auth,INFO,validation error,1,40.591495,-3.695297
2025-09-20T02:17:05Z,db-1,auth,INFO,consume event,109,40.320929,-3.504309
2025-09-20T02:18:05Z,web-1,checkout,INFO,request completed,112,40.541279,-3.669196
2025-09-20T02:19:05Z,db-1,auth,WARN,request completed,132,40.551103,-3.93699
2025-09-20T02:24:05Z,app-1,checkout,INFO,request completed,64,40.401924,-3.872023
2025-09-20T02:24:05Z,web-1,ingest,INFO,login succeeded,163,40.233741,-3.703238
2025-09-20T02:37:05Z,db-1,search,INFO,db query executed,132,40.442827,-3.525488
2025-09-20T02:39:05Z,app-2,checkout,INFO,validation error,49,40.622369,-3.636836
2025-09-20T02:40:05Z,web-1,auth,INFO,db query executed,88,40.332738,-3.583794
2025-09-20T02:41:05Z,web-2,ingest,INFO,request completed,166,40.256616,-3.927564
2025-09-20T03:03:05Z,web-1,checkout,WARN,publish event,126,40.480706,-3.766214
2025-09-20T03:04:05Z,web-2,search,INFO,timeout waiting upstream,101,40.298979,-3.836791
2025-09-20T03:15:05Z,app-1,search,WARN,validation error,74,40.318474,-3.580995
2025-09-20T03:18:05Z,app-1,search,INFO,db query executed,129,40.255924,-3.617755
2025-09-20T03:21:05Z,db-1,checkout,INFO,db query executed,31,40.225994,-3.795001
2025-09-20T03:37:05Z,web-2,auth,INFO,cache miss,64,40.591521,-3.615283
2025-09-20T03:43:05Z,db-1,ingest,INFO,validation error,120,40.28559,-3.580925
2025-09-20T03:53:05Z,db-1,checkout,INFO,login succeeded,146,40.263114,-3.767729
2025-09-20T03:59:05Z,web-1,checkout,INFO,consume event,134,40.436289,-3.580293
2025-09-20T04:11:05Z,db-1,ingest,INFO,login succeeded,98,40.611329,-3.846009
2025-09-20T04:16:05Z,app-1,checkout,INFO,timeout waiting upstream,115,40.380368,-3.880112
2025-09-20T04:18:05Z,web-1,search,INFO,publish event,119,40.558935,-3.693243
2025-09-20T04:37:05Z,app-2,auth,ERROR,consume event,133,40.581291,-3.478963
2025-09-20T04:42:05Z,web-2,search,INFO,cache miss,115,40.586048,-3.650306
2025-09-20T04:53:05Z,db-1,auth,INFO,timeout waiting upstream,25,40.318416,-3.459609
2025-09-20T05:04:05Z,app-1,auth,ERROR,login succeeded,147,40.291069,-3.727841
2025-09-20T05:06:05Z,web-2,ingest,ERROR,request completed,104,40.274627,-3.87904
2025-09-20T05:08:05Z,web-2,checkout,INFO,publish event,99,40.480453,-3.76136
2025-09-20T05:12:05Z,app-2,search,INFO,publish event,86,40.644345,-3.819645
2025-09-20T05:17:05Z,app-1,checkout,WARN,cache miss,128,40.559841,-3.553373
2025-09-20T05:21:05Z,db-1,search,INFO,login succeeded,94,40.665221,-3.480892
2025-09-20T05:26:05Z,app-2,checkout,INFO,request completed,71,40.371095,-3.469392
2025-09-20T05:27:05Z,app-1,checkout,WARN,publish event,115,40.405524,-3.854072
2025-09-20T05:32:05Z,web-2,auth,ERROR,db query executed,62,40.308153,-3.56142
2025-09-20T05:39:05Z,app-1,auth,INFO,publish event,127,40.232506,-3.498986
2025-09-20T05:43:05Z,web-1,ingest,WARN,publish event,134,40.287947,-3.478791
2025-09-20T05:46:05Z,web-1,search,WARN,consume event,167,40.640279,-3.715266
2025-09-20T05:49:05Z,web-1,search,ERROR,timeout waiting upstream,147,40.406305,-3.864981
2025-09-20T05:50:05Z,app-1,ingest,INFO,login succeeded,95,40.245711,-3.695617
2025-09-20T05:55:05Z,db-1,ingest,INFO,login failed,148,40.549969,-3.65346
2025-09-20T05:58:05Z,web-2,auth,INFO,cache miss,89,40.517513,-3.887455
2025-09-20T06:00:05Z,web-1,checkout,INFO,login succeeded,85,40.347382,-3.635676
2025-09-20T06:12:05Z,web-1,auth,WARN,publish event,65,40.411846,-3.670449
2025-09-20T06:19:05Z,web-1,auth,INFO,consume event,113,40.272115,-3.78236
2025-09-20T06:27:05Z,web-1,ingest,INFO,timeout waiting upstream,133,40.572804,-3.944238
2025-09-20T06:41:05Z,web-1,auth,INFO,timeout waiting upstream,108,40.434097,-3.9531
2025-09-20T06:48:05Z,db-1,search,INFO,login succeeded,114,40.254107,-3.657915
2025-09-20T06:52:05Z,app-2,auth,INFO,login succeeded,41,40.470972,-3.482298
2025-09-20T06:54:05Z,web-1,auth,WARN,request completed,77,40.366064,-3.736554
2025-09-20T07:23:05Z,app-2,ingest,ERROR,timeout waiting upstream,93,40.410731,-3.627676
2025-09-20T07:28:05Z,db-1,ingest,INFO,publish event,111,40.405983,-3.586214
2025-09-20T07:29:05Z,web-2,checkout,WARN,db query executed,45,40.351447,-3.690672
2025-09-20T07:33:05Z,app-2,auth,INFO,db query executed,86,40.452306,-3.53565
2025-09-20T07:34:05Z,db-1,ingest,ERROR,publish event,81,40.471503,-3.599506
2025-09-20T08:26:05Z,web-1,auth,INFO,consume event,127,40.312868,-3.481755
2025-09-20T08:28:05Z,app-2,checkout,INFO,request completed,69,40.329401,-3.715723
2025-09-20T08:32:05Z,app-1,ingest,INFO,validation error,176,40.26776,-3.542518
2025-09-20T08:33:05Z,app-2,search,ERROR,request completed,102,40.505955,-3.78273
2025-09-20T08:46:05Z,app-2,checkout,INFO,validation error,158,40.512209,-3.561785
2025-09-20T08:49:05Z,web-1,auth,ERROR,cache miss,66,40.2524,-3.64156
2025-09-20T08:55:05Z,web-2,search,INFO,publish event,137,40.171482,-3.582228
2025-09-20T08:58:05Z,web-1,search,WARN,login failed,79,40.230444,-3.743577
2025-09-20T09:00:05Z,web-2,checkout,INFO,validation error,149,40.542589,-3.779511
2025-09-20T09:00:05Z,web-1,ingest,WARN,publish event,140,40.614119,-3.760478
2025-09-20T09:05:05Z,db-1,checkout,INFO,cache miss,136,40.279535,-3.480058
2025-09-20T09:06:05Z,app-2,auth,INFO,cache miss,132,40.323948,-3.934228
2025-09-20T09:15:05Z,app-1,auth,WARN,login failed,138,40.209453,-3.60016
2025-09-20T09:22:05Z,db-1,ingest,INFO,validation error,93,40.305284,-3.911676
2025-09-20T09:38:05Z,web-1,ingest,WARN,timeout waiting upstream,97,40.480986,-3.886496
2025-09-20T09:40:05Z,web-1,search,ERROR,validation error,42,40.429123,-3.605885
2025-09-20T09:40:05Z,db-1,checkout,WARN,validation error,170,40.170733,-3.473426
2025-09-20T09:41:05Z,web-2,search,ERROR,db query executed,109,40.207332,-3.53845
2025-09-20T09:49:05Z,app-1,ingest,WARN,cache miss,165,40.244827,-3.468725
2025-09-20T09:56:05Z,db-1,auth,INFO,consume event,130,40.380989,-3.768515
2025-09-20T09:58:05Z,app-1,checkout,INFO,timeout waiting upstream,49,40.359324,-3.896259
2025-09-20T10:02:05Z,db-1,checkout,WARN,login succeeded,102,40.663631,-3.561357
2025-09-20T10:04:05Z,web-2,checkout,WARN,db query executed,101,40.569778,-3.902199
2025-09-20T10:08:05Z,app-1,checkout,INFO,publish event,110,40.44009,-3.782351
2025-09-20T10:26:05Z,app-2,ingest,WARN,db query executed,73,40.537516,-3.507586
2025-09-20T10:28:05Z,web-2,ingest,INFO,validation error,105,40.388078,-3.935809
2025-09-20T10:28:05Z,app-2,checkout,INFO,consume event,100,40.24087,-3.511999
2025-09-20T10:34:05Z,db-1,ingest,INFO,db query executed,108,40.351593,-3.809005
2025-09-20T10:43:05Z,app-2,ingest,ERROR,cache miss,98,40.202817,-3.58607
2025-09-20T10:52:05Z,web-1,checkout,INFO,login succeeded,123,40.22403,-3.474651
2025-09-20T11:08:05Z,app-1,checkout,WARN,publish event,78,40.649702,-3.652856
2025-09-20T11:11:05Z,app-2,checkout,WARN,publish event,41,40.459413,-3.853131
2025-09-20T11:24:05Z,web-1,auth,INFO,db query executed,78,40.260878,-3.482796
2025-09-20T11:25:05Z,web-2,checkout,INFO,request completed,99,40.629588,-3.684574
2025-09-20T11:27:05Z,web-1,ingest,WARN,publish event,141,40.614239,-3.821298
2025-09-20T11:43:05Z,app-2,search,INFO,request completed,81,40.631244,-3.665902
2025-09-20T11:52:05Z,web-1,ingest,ERROR,login failed,64,40.465285,-3.648146
2025-09-20T12:01:05Z,app-1,checkout,WARN,consume event,94,40.360294,-3.672964
2025-09-20T12:14:05Z,web-1,checkout,WARN,login succeeded,99,40.335356,-3.806288
2025-09-20T12:16:05Z,app-2,auth,INFO,db query executed,132,40.268667,-3.811742
2025-09-20T12:16:05Z,web-2,ingest,INFO,login failed,131,40.262045,-3.781538
2025-09-20T12:35:05Z,app-1,search,INFO,timeout waiting upstream,108,40.537134,-3.681117
2025-09-20T12:42:05Z,db-1,search,INFO,login failed,87,40.459808,-3.785519
2025-09-20T12:53:05Z,web-2,checkout,INFO,timeout waiting upstream,133,40.196291,-3.862435
2025-09-20T13:03:05Z,app-2,checkout,WARN,db query executed,99,40.359184,-3.655856
2025-09-20T13:09:05Z,app-2,checkout,INFO,consume event,70,40.306073,-3.828897
2025-09-20T13:53:05Z,app-2,ingest,ERROR,login succeeded,114,40.297451,-3.685748
2025-09-20T13:54:05Z,app-1,auth,INFO,publish event,84,40.233054,-3.860104
2025-09-20T13:57:05Z,app-1,ingest,ERROR,timeout waiting upstream,104,40.198355,-3.852479
2025-09-20T14:12:05Z,app-2,auth,INFO,login failed,113,40.387559,-3.700852
2025-09-20T14:24:05Z,app-1,search,INFO,validation error,92,40.247252,-3.916299
2025-09-20T14:26:05Z,app-2,search,WARN,publish event,82,40.573583,-3.678752
2025-09-20T14:30:05Z,db-1,checkout,INFO,publish event,86,40.180219,-3.854301
2025-09-20T14:37:05Z,web-2,search,INFO,login succeeded,99,40.476499,-3.925359
2025-09-20T15:05:05Z,app-1,ingest,INFO,login failed,123,40.570364,-3.588934
2025-09-20T15:11:05Z,db-1,checkout,INFO,db query executed,79,40.466734,-3.463092
2025-09-20T15:19:05Z,web-2,ingest,INFO,db query executed,102,40.431348,-3.504545
2025-09-20T15:20:05Z,web-1,checkout,INFO,validation error,93,40.515398,-3.592781
2025-09-20T15:22:05Z,app-1,checkout,WARN,db query executed,89,40.394902,-3.76898
2025-09-20T15:25:05Z,web-2,search,WARN,login failed,56,40.248127,-3.776165
2025-09-20T15:28:05Z,app-1,auth,INFO,request completed,73,40.18773,-3.848266
2025-09-20T15:35:05Z,web-2,auth,ERROR,publish event,116,40.602266,-3.468822
2025-09-20T15:43:05Z,web-1,checkout,ERROR,validation error,114,40.594954,-3.855768
2025-09-20T15:48:05Z,app-1,auth,WARN,request completed,129,40.506402,-3.877432
2025-09-20T15:52:05Z,db-1,checkout,INFO,cache miss,79,40.258134,-3.569648
2025-09-20T15:53:05Z,app-2,search,INFO,cache miss,120,40.228292,-3.852855
2025-09-20T15:58:05Z,app-2,auth,INFO,login succeeded,58,40.391727,-3.786472
2025-09-20T16:09:05Z,web-1,ingest,WARN,timeout waiting upstream,96,40.264263,-3.785097
2025-09-20T16:10:05Z,app-2,checkout,INFO,publish event,103,40.5312,-3.65131
2025-09-20T16:20:05Z,web-2,checkout,INFO,consume event,52,40.548259,-3.862266
2025-09-20T16:35:05Z,web-2,search,INFO,consume event,62,40.636274,-3.576317
2025-09-20T16:38:05Z,app-1,checkout,ERROR,timeout waiting upstream,111,40.21219,-3.530869
2025-09-20T16:41:05Z,app-1,ingest,WARN,timeout waiting upstream,94,40.313581,-3.70485
2025-09-20T16:52:05Z,db-1,search,ERROR,consume event,100,40.276438,-3.568634
2025-09-20T16:57:05Z,db-1,auth,INFO,timeout waiting upstream,137,40.450192,-3.818252
2025-09-20T16:57:05Z,app-2,checkout,WARN,login failed,103,40.358587,-3.730432
2025-09-20T16:59:05Z,web-2,checkout,WARN,login failed,77,40.241127,-3.540581
2025-09-20T17:10:05Z,db-1,checkout,WARN,publish event,105,40.666777,-3.602432
2025-09-20T17:11:05Z,db-1,checkout,ERROR,login failed,90,40.603022,-3.540389
2025-09-20T17:34:05Z,web-1,ingest,INFO,validation error,116,40.611677,-3.875248
2025-09-20T17:36:05Z,web-2,search,INFO,consume event,99,40.632498,-3.715522
2025-09-20T17:37:05Z,web-1,search,INFO,db query executed,37,40.302717,-3.760942
2025-09-20T17:53:05Z,web-1,auth,INFO,publish event,99,40.192119,-3.491734
2025-09-20T17:53:05Z,db-1,auth,ERROR,login failed,129,40.303482,-3.670586
2025-09-20T18:16:05Z,web-2,search,ERROR,request completed,69,40.57007,-3.646782
2025-09-20T18:30:05Z,web-2,auth,INFO,consume event,117,40.666211,-3.51466
2025-09-20T18:31:05Z,web-2,ingest,INFO,publish event,76,40.350462,-3.8938
2025-09-20T18:37:05Z,app-2,ingest,INFO,validation error,73,40.537272,-3.574053
2025-09-20T18:39:05Z,db-1,search,WARN,publish event,92,40.486713,-3.692257
2025-09-20T18:41:05Z,app-1,ingest,INFO,db query executed,102,40.528588,-3.50141
2025-09-20T18:42:05Z,web-2,checkout,INFO,cache miss,139,40.466996,-3.879174
2025-09-20T18:42:05Z,web-1,search,INFO,cache miss,110,40.601228,-3.840917
2025-09-20T18:43:05Z,app-1,search,INFO,login succeeded,99,40.365785,-3.79975
2025-09-20T18:46:05Z,web-1,ingest,INFO,login succeeded,110,40.271642,-3.607212
2025-09-20T18:56:05Z,web-2,auth,INFO,validation error,68,40.364683,-3.798663
2025-09-20T18:57:05Z,web-2,ingest,INFO,db query executed,149,40.175685,-3.75208
2025-09-20T18:57:05Z,app-2,ingest,WARN,validation error,69,40.169135,-3.686909
2025-09-20T19:15:05Z,web-1,ingest,INFO,db query executed,93,40.484138,-3.915453
2025-09-20T19:22:05Z,web-1,ingest,WARN,validation error,93,40.577861,-3.93839
2025-09-20T19:24:05Z,db-1,ingest,INFO,login failed,111,40.318755,-3.642441
2025-09-20T19:47:05Z,app-1,checkout,INFO,cache miss,72,40.4903,-3.931652
2025-09-20T19:53:05Z,app-1,search,INFO,consume event,138,40.49588,-3.829631
2025-09-20T19:58:05Z,web-2,search,INFO,timeout waiting upstream,85,40.535597,-3.73222
2025-09-20T19:59:05Z,app-1,search,WARN,cache miss,62,40.273667,-3.697964
2025-09-20T20:03:05Z,web-1,ingest,ERROR,login failed,88,40.281889,-3.933229
2025-09-20T20:03:05Z,db-1,search,INFO,request completed,119,40.489793,-3.549151
2025-09-20T20:06:05Z,web-1,ingest,INFO,timeout waiting upstream,110,40.169535,-3.581977
2025-09-20T20:26:05Z,app-1,ingest,ERROR,timeout waiting upstream,138,40.453115,-3.816938
2025-09-20T20:29:05Z,web-1,auth,INFO,timeout waiting upstream,109,40.185941,-3.853647
2025-09-20T20:35:05Z,web-1,checkout,WARN,cache miss,121,40.536628,-3.795461
2025-09-20T20:46:05Z,web-1,ingest,WARN,db query executed,80,40.533939,-3.806869
2025-09-20T21:08:05Z,app-2,checkout,WARN,db query executed,105,40.214577,-3.485403
2025-09-20T21:17:05Z,web-2,checkout,ERROR,publish event,93,40.592865,-3.708077
2025-09-20T21:34:05Z,web-2,auth,ERROR,request completed,116,40.324508,-3.504739
2025-09-20T21:35:05Z,web-2,search,WARN,cache miss,131,40.600929,-3.63351
2025-09-20T21:38:05Z,db-1,search,INFO,validation error,156,40.433988,-3.950876
2025-09-20T21:43:05Z,app-2,checkout,ERROR,publish event,105,40.171443,-3.606001
2025-09-20T21:46:05Z,app-1,ingest,WARN,request completed,102,40.496694,-3.657212
2025-09-20T21:55:05Z,web-1,ingest,INFO,publish event,121,40.454916,-3.499972
2025-09-20T22:06:05Z,app-1,auth,ERROR,validation error,69,40.37331,-3.721472
2025-09-20T22:22:05Z,app-1,ingest,ERROR,login succeeded,133,40.514152,-3.515141
2025-09-20T22:24:05Z,web-2,auth,INFO,consume event,109,40.584814,-3.469302
2025-09-20T22:25:05Z,app-2,ingest,WARN,publish event,116,40.507367,-3.512776
2025-09-20T22:34:05Z,web-2,search,INFO,validation error,101,40.491718,-3.527917
2025-09-20T22:41:05Z,web-1,auth,INFO,login failed,73,40.174629,-3.850221
2025-09-20T22:46:05Z,web-2,checkout,WARN,db query executed,1,40.572057,-3.470019
2025-09-20T22:51:05Z,web-1,auth,ERROR,db query executed,118,40.238001,-3.733596
2025-09-20T22:55:05Z,web-2,ingest,ERROR,login succeeded,119,40.472322,-3.889468
2025-09-20T23:06:05Z,web-2,ingest,ERROR,timeout waiting upstream,103,40.525973,-3.761811
2025-09-20T23:14:05Z,db-1,search,INFO,db query executed,89,40.568271,-3.475445
2025-09-20T23:18:05Z,app-2,auth,WARN,login failed,89,40.185743,-3.917176
2025-09-20T23:37:05Z,web-1,ingest,WARN,validation error,126,40.286088,-3.831954
2025-09-20T23:51:05Z,db-1,checkout,INFO,validation error,93,40.643878,-3.544812
2025-09-21T00:15:05Z,app-1,search,ERROR,login failed,73,40.340538,-3.546043
2025-09-21T00:19:05Z,db-1,auth,ERROR,cache miss,55,40.48084,-3.878113
2025-09-21T00:58:05Z,web-1,search,INFO,db query executed,123,40.550573,-3.704012
2025-09-21T01:02:05Z,web-1,ingest,WARN,consume event,117,40.372198,-3.749083
2025-09-21T01:04:05Z,app-2,ingest,INFO,db query executed,85,40.645928,-3.915326
2025-09-21T01:42:05Z,db-1,ingest,INFO,consume event,79,40.243866,-3.812235
2025-09-21T01:43:05Z,db-1,auth,INFO,login failed,112,40.560246,-3.803125
2025-09-21T01:50:05Z,app-1,auth,WARN,validation error,82,40.57083,-3.657535
2025-09-21T01:57:05Z,web-2,ingest,INFO,request completed,97,40.255765,-3.919101
2025-09-21T01:59:05Z,app-2,checkout,ERROR,login failed,99,40.665861,-3.714615
2025-09-21T02:06:05Z,db-1,checkout,WARN,validation error,87,40.506451,-3.555517
2025-09-21T02:13:05Z,web-2,checkout,ERROR,request completed,86,40.53549,-3.940151
2025-09-21T02:23:05Z,web-2,ingest,WARN,db query executed,34,40.203545,-3.913405
2025-09-21T02:25:05Z,app-1,ingest,INFO,db query executed,102,40.567994,-3.926406
2025-09-21T02:26:05Z,web-1,ingest,ERROR,validation error,102,40.199529,-3.939347
2025-09-21T02:29:05Z,web-2,search,ERROR,validation error,101,40.378588,-3.752661
2025-09-21T02:38:05Z,app-2,search,WARN,login succeeded,145,40.267806,-3.765926
2025-09-21T03:29:05Z,db-1,ingest,INFO,cache miss,92,40.665535,-3.824087
2025-09-21T03:35:05Z,app-2,search,INFO,login failed,112,40.455537,-3.567531
2025-09-21T03:48:05Z,web-2,checkout,ERROR,validation error,90,40.397989,-3.550342
2025-09-21T03:58:05Z,db-1,checkout,ERROR,consume event,112,40.305764,-3.942526
2025-09-21T04:02:05Z,app-1,checkout,INFO,timeout waiting upstream,95,40.550475,-3.57172
2025-09-21T04:04:05Z,app-2,search,ERROR,validation error,72,40.348228,-3.547675
2025-09-21T04:06:05Z,web-1,auth,WARN,db query executed,116,40.314075,-3.62279
2025-09-21T04:14:05Z,app-2,checkout,INFO,login failed,99,40.371396,-3.669098
2025-09-21T04:14:05Z,app-2,checkout,ERROR,validation error,81,40.481691,-3.921492
2025-09-21T04:20:05Z,app-1,ingest,INFO,db query executed,72,40.644229,-3.755448
2025-09-21T04:21:05Z,app-2,checkout,ERROR,login succeeded,119,40.445837,-3.745713
2025-09-21T04:33:05Z,db-1,checkout,WARN,consume event,90,40.615232,-3.893658
2025-09-21T04:46:05Z,app-2,auth,INFO,validation error,123,40.329057,-3.87012
2025-09-21T04:54:05Z,app-2,search,ERROR,cache miss,126,40.630636,-3.734742
2025-09-21T04:55:05Z,app-1,ingest,INFO,publish event,89,40.476367,-3.771014
2025-09-21T05:37:05Z,web-1,search,INFO,request completed,137,40.642848,-3.526499
2025-09-21T05:46:05Z,app-1,auth,WARN,request completed,86,40.228919,-3.524974
2025-09-21T05:49:05Z,app-1,ingest,WARN,validation error,94,40.228598,-3.827431
2025-09-21T06:04:05Z,app-2,search,INFO,publish event,140,40.247195,-3.686142
2025-09-21T06:10:05Z,web-1,ingest,ERROR,publish event,101,40.324921,-3.757871
2025-09-21T06:15:05Z,db-1,search,INFO,consume event,88,40.192011,-3.480666
2025-09-21T06:23:05Z,db-1,search,ERROR,publish event,172,40.236728,-3.708579
2025-09-21T06:27:05Z,web-2,auth,WARN,login succeeded,91,40.553564,-3.798451
2025-09-21T06:30:05Z,web-1,search,WARN,consume event,121,40.464985,-3.784882
2025-09-21T06:35:05Z,db-1,auth,INFO,validation error,63,40.423544,-3.916307
2025-09-21T06:38:05Z,web-2,auth,ERROR,consume event,117,40.264128,-3.677189
2025-09-21T06:58:05Z,db-1,auth,INFO,publish event,138,40.611393,-3.902249
2025-09-21T07:03:05Z,app-2,checkout,INFO,login succeeded,107,40.238118,-3.640108
2025-09-21T07:28:05Z,web-2,checkout,INFO,timeout waiting upstream,79,40.51341,-3.720532
2025-09-21T07:47:05Z,web-2,checkout,INFO,publish event,126,40.417484,-3.474939
2025-09-21T07:50:05Z,app-1,auth,INFO,timeout waiting upstream,94,40.470061,-3.738346
2025-09-21T08:00:05Z,app-1,checkout,INFO,request completed,123,40.477468,-3.834528
2025-09-21T08:06:05Z,web-1,auth,ERROR,login succeeded,111,40.438975,-3.866875
2025-09-21T08:06:05Z,web-1,checkout,INFO,db query executed,112,40.343639,-3.673858
2025-09-21T08:06:05Z,web-1,ingest,INFO,validation error,121,40.295095,-3.591812
2025-09-21T08:12:05Z,app-1,checkout,ERROR,consume event,104,40.620316,-3.802206
2025-09-21T08:13:05Z,web-1,search,INFO,validation error,99,40.545902,-3.930855
2025-09-21T08:15:05Z,web-2,checkout,INFO,validation error,133,40.346431,-3.911369
2025-09-21T08:16:05Z,db-1,ingest,ERROR,request completed,111,40.608999,-3.566961
2025-09-21T08:25:05Z,web-2,checkout,INFO,publish event,67,40.602462,-3.842338
2025-09-21T08:33:05Z,app-1,ingest,INFO,login failed,83,40.384997,-3.461682
2025-09-21T08:38:05Z,app-2,ingest,INFO,cache miss,92,40.547047,-3.693364
2025-09-21T08:47:05Z,web-2,search,ERROR,request completed,92,40.220857,-3.53574
2025-09-21T08:48:05Z,app-2,ingest,INFO,request completed,82,40.665386,-3.755303
2025-09-21T08:50:05Z,web-1,ingest,INFO,db query executed,86,40.2842,-3.685027
2025-09-21T08:57:05Z,web-1,ingest,ERROR,timeout waiting upstream,80,40.170368,-3.461668
2025-09-21T08:58:05Z,app-2,checkout,INFO,timeout waiting upstream,96,40.645511,-3.652728
2025-09-21T09:00:05Z,app-2,checkout,INFO,publish event,130,40.598384,-3.75585
2025-09-21T09:12:05Z,db-1,auth,INFO,login succeeded,93,40.611855,-3.672634
2025-09-21T09:31:05Z,db-1,checkout,INFO,publish event,140,40.652882,-3.54957
2025-09-21T09:34:05Z,web-1,auth,INFO,login succeeded,43,40.240484,-3.830093
2025-09-21T09:37:05Z,db-1,search,INFO,consume event,84,40.661968,-3.892068
2025-09-21T10:25:05Z,web-1,auth,ERROR,timeout waiting upstream,102,40.306039,-3.711093
2025-09-21T10:29:05Z,app-2,ingest,ERROR,validation error,66,40.369816,-3.736205
2025-09-21T10:34:05Z,app-2,search,INFO,login succeeded,103,40.55717,-3.670975
2025-09-21T10:37:05Z,app-1,checkout,WARN,validation error,71,40.393623,-3.875095
2025-09-21T10:39:05Z,app-2,search,WARN,publish event,124,40.255592,-3.51856
2025-09-21T10:46:05Z,web-1,checkout,ERROR,cache miss,83,40.4167,-3.624376
2025-09-21T10:59:05Z,web-1,ingest,INFO,consume event,137,40.198736,-3.597638
2025-09-21T11:05:05Z,app-1,search,INFO,login succeeded,79,40.288899,-3.747774
2025-09-21T11:18:05Z,db-1,auth,INFO,login failed,81,40.341238,-3.582771
2025-09-21T11:30:05Z,web-2,auth,INFO,timeout waiting upstream,80,40.595356,-3.63011
2025-09-21T11:39:05Z,web-1,ingest,INFO,validation error,84,40.342435,-3.62318
2025-09-21T11:43:05Z,db-1,ingest,INFO,timeout waiting upstream,92,40.252056,-3.639287
2025-09-21T11:45:05Z,db-1,checkout,ERROR,validation error,107,40.571515,-3.950551
2025-09-21T11:54:05Z,web-2,search,ERROR,timeout waiting upstream,103,40.52345,-3.657357
2025-09-21T11:56:05Z,app-1,checkout,ERROR,request completed,63,40.666586,-3.617659
2025-09-21T12:13:05Z,db-1,search,ERROR,db query executed,92,40.644384,-3.682883
2025-09-21T12:15:05Z,db-1,search,ERROR,consume event,91,40.615941,-3.857544
2025-09-21T12:23:05Z,web-1,checkout,INFO,publish event,76,40.628907,-3.837055
2025-09-21T12:48:05Z,web-1,ingest,ERROR,cache miss,69,40.535655,-3.943059
2025-09-21T13:03:05Z,web-2,search,INFO,timeout waiting upstream,102,40.455956,-3.931155
2025-09-21T13:07:05Z,app-1,checkout,ERROR,login succeeded,84,40.245303,-3.78041
2025-09-21T13:10:05Z,app-1,search,INFO,cache miss,104,40.581709,-3.676696
2025-09-21T13:18:05Z,web-1,checkout,ERROR,publish event,79,40.582813,-3.493915
2025-09-21T13:36:05Z,web-2,ingest,INFO,consume event,125,40.585372,-3.684309
2025-09-21T13:39:05Z,db-1,ingest,WARN,request completed,74,40.638171,-3.804494
2025-09-21T13:52:05Z,web-2,auth,INFO,validation error,57,40.375647,-3.896213
2025-09-21T13:54:05Z,web-1,auth,INFO,publish event,73,40.407634,-3.844118
2025-09-21T13:58:05Z,web-2,auth,INFO,cache miss,118,40.515063,-3.818159
2025-09-21T14:25:05Z,db-1,search,ERROR,login succeeded,95,40.175371,-3.547221
2025-09-21T14:31:05Z,app-1,search,INFO,login failed,72,40.560689,-3.932393
2025-09-21T14:48:05Z,app-2,checkout,INFO,publish event,120,40.624021,-3.605987
2025-09-21T15:01:05Z,web-1,checkout,INFO,timeout waiting upstream,113,40.584493,-3.621746
2025-09-21T15:04:05Z,app-2,auth,INFO,db query executed,82,40.462321,-3.5449
2025-09-21T15:18:05Z,app-1,auth,ERROR,login failed,107,40.236415,-3.573964
2025-09-21T15:22:05Z,app-2,auth,ERROR,db query executed,82,40.545423,-3.643917
2025-09-21T15:25:05Z,app-2,ingest,INFO,publish event,103,40.44581,-3.484678
2025-09-21T15:30:05Z,db-1,auth,INFO,validation error,127,40.266751,-3.578707
2025-09-21T15:36:05Z,web-2,checkout,INFO,login failed,87,40.212165,-3.713909
2025-09-21T15:38:05Z,app-2,auth,WARN,login failed,87,40.63238,-3.525057
2025-09-21T15:46:05Z,db-1,auth,WARN,validation error,155,40.548523,-3.631559
2025-09-21T15:52:05Z,web-2,auth,INFO,consume event,84,40.187391,-3.683835
2025-09-21T16:03:05Z,web-2,ingest,ERROR,publish event,75,40.343257,-3.46492
2025-09-21T16:04:05Z,web-2,checkout,WARN,publish event,112,40.424306,-3.454823
2025-09-21T16:17:05Z,db-1,auth,INFO,login failed,72,40.324202,-3.462828
2025-09-21T16:18:05Z,app-1,ingest,INFO,validation error,150,40.228552,-3.690562
2025-09-21T16:30:05Z,web-2,search,ERROR,timeout waiting upstream,103,40.565184,-3.679694
2025-09-21T17:01:05Z,web-2,search,WARN,publish event,54,40.545256,-3.651614
2025-09-21T17:03:05Z,db-1,auth,ERROR,request completed,85,40.568944,-3.749377
2025-09-21T17:15:05Z,web-2,auth,INFO,consume event,67,40.605399,-3.478305
2025-09-21T17:15:05Z,web-2,checkout,INFO,db query executed,90,40.520385,-3.949229
2025-09-21T17:19:05Z,app-1,search,INFO,validation error,93,40.181359,-3.865985
2025-09-21T17:34:05Z,web-2,search,INFO,consume event,112,40.316401,-3.620339
2025-09-21T17:42:05Z,web-2,search,INFO,cache miss,103,40.454939,-3.874582
2025-09-21T18:03:05Z,app-1,search,WARN,consume event,98,40.378864,-3.764162
2025-09-21T18:16:05Z,web-2,ingest,ERROR,publish event,94,40.520278,-3.602306
2025-09-21T18:26:05Z,db-1,ingest,INFO,request completed,85,40.614434,-3.60215
2025-09-21T18:30:05Z,db-1,ingest,ERROR,request completed,133,40.257841,-3.794692
2025-09-21T18:36:05Z,web-2,search,INFO,timeout waiting upstream,147,40.431707,-3.834716

CSV
cat > "$LAB_DIR/data/logs.ndjson" <<'JSONL'
{"@timestamp": "2025-09-14T19:12:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 63, "lat": 40.225731, "lon": -3.80111}
{"@timestamp": "2025-09-14T19:18:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "validation error", "latency_ms": 85, "lat": 40.361218, "lon": -3.601432}
{"@timestamp": "2025-09-14T19:19:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "request completed", "latency_ms": 121, "lat": 40.568985, "lon": -3.542172}
{"@timestamp": "2025-09-14T19:37:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 53, "lat": 40.648932, "lon": -3.867913}
{"@timestamp": "2025-09-14T19:38:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 63, "lat": 40.591223, "lon": -3.527864}
{"@timestamp": "2025-09-14T19:44:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 99, "lat": 40.639461, "lon": -3.616474}
{"@timestamp": "2025-09-14T19:45:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 96, "lat": 40.207161, "lon": -3.950188}
{"@timestamp": "2025-09-14T19:52:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 121, "lat": 40.225554, "lon": -3.6887}
{"@timestamp": "2025-09-14T19:52:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 134, "lat": 40.511127, "lon": -3.486854}
{"@timestamp": "2025-09-14T19:58:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "login succeeded", "latency_ms": 112, "lat": 40.632678, "lon": -3.902007}
{"@timestamp": "2025-09-14T20:01:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 99, "lat": 40.17631, "lon": -3.665598}
{"@timestamp": "2025-09-14T20:01:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 79, "lat": 40.578766, "lon": -3.84416}
{"@timestamp": "2025-09-14T20:03:05Z", "host": "app-2", "service": "auth", "level": "WARN", "message": "cache miss", "latency_ms": 94, "lat": 40.340205, "lon": -3.794041}
{"@timestamp": "2025-09-14T20:07:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "login failed", "latency_ms": 109, "lat": 40.63254, "lon": -3.907237}
{"@timestamp": "2025-09-14T20:13:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 89, "lat": 40.446429, "lon": -3.806342}
{"@timestamp": "2025-09-14T20:42:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "login failed", "latency_ms": 132, "lat": 40.233486, "lon": -3.747427}
{"@timestamp": "2025-09-14T20:44:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "login succeeded", "latency_ms": 96, "lat": 40.28562, "lon": -3.892876}
{"@timestamp": "2025-09-14T20:53:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 104, "lat": 40.478959, "lon": -3.661118}
{"@timestamp": "2025-09-14T21:30:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 133, "lat": 40.524232, "lon": -3.855942}
{"@timestamp": "2025-09-14T21:36:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "db query executed", "latency_ms": 124, "lat": 40.599097, "lon": -3.57803}
{"@timestamp": "2025-09-14T21:38:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 83, "lat": 40.554172, "lon": -3.730335}
{"@timestamp": "2025-09-14T21:45:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 78, "lat": 40.189531, "lon": -3.633073}
{"@timestamp": "2025-09-14T21:46:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 135, "lat": 40.351615, "lon": -3.767384}
{"@timestamp": "2025-09-14T22:12:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 65, "lat": 40.609507, "lon": -3.71558}
{"@timestamp": "2025-09-14T22:20:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 101, "lat": 40.539787, "lon": -3.890085}
{"@timestamp": "2025-09-14T22:25:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 133, "lat": 40.625173, "lon": -3.798684}
{"@timestamp": "2025-09-14T22:42:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "publish event", "latency_ms": 167, "lat": 40.267532, "lon": -3.888555}
{"@timestamp": "2025-09-14T23:06:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 111, "lat": 40.655329, "lon": -3.717015}
{"@timestamp": "2025-09-14T23:12:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 65, "lat": 40.436443, "lon": -3.9532}
{"@timestamp": "2025-09-14T23:38:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 118, "lat": 40.489295, "lon": -3.923059}
{"@timestamp": "2025-09-14T23:57:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "login succeeded", "latency_ms": 78, "lat": 40.307912, "lon": -3.912493}
{"@timestamp": "2025-09-14T23:59:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "request completed", "latency_ms": 92, "lat": 40.20915, "lon": -3.503232}
{"@timestamp": "2025-09-15T00:11:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 100, "lat": 40.245649, "lon": -3.908099}
{"@timestamp": "2025-09-15T00:13:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 111, "lat": 40.392057, "lon": -3.732439}
{"@timestamp": "2025-09-15T00:27:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "validation error", "latency_ms": 59, "lat": 40.206039, "lon": -3.925839}
{"@timestamp": "2025-09-15T00:45:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 107, "lat": 40.59502, "lon": -3.888846}
{"@timestamp": "2025-09-15T01:02:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 143, "lat": 40.303747, "lon": -3.575025}
{"@timestamp": "2025-09-15T01:12:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 114, "lat": 40.196773, "lon": -3.767311}
{"@timestamp": "2025-09-15T01:45:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 110, "lat": 40.276119, "lon": -3.701122}
{"@timestamp": "2025-09-15T01:48:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "login succeeded", "latency_ms": 80, "lat": 40.522535, "lon": -3.871803}
{"@timestamp": "2025-09-15T02:03:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 142, "lat": 40.378846, "lon": -3.696674}
{"@timestamp": "2025-09-15T02:12:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "consume event", "latency_ms": 119, "lat": 40.234118, "lon": -3.704386}
{"@timestamp": "2025-09-15T02:17:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 61, "lat": 40.640595, "lon": -3.849906}
{"@timestamp": "2025-09-15T02:21:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 147, "lat": 40.196237, "lon": -3.9201}
{"@timestamp": "2025-09-15T02:22:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 33, "lat": 40.511309, "lon": -3.47989}
{"@timestamp": "2025-09-15T02:37:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 51, "lat": 40.290386, "lon": -3.63907}
{"@timestamp": "2025-09-15T02:39:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "login succeeded", "latency_ms": 63, "lat": 40.571803, "lon": -3.848266}
{"@timestamp": "2025-09-15T02:42:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 59, "lat": 40.519794, "lon": -3.805078}
{"@timestamp": "2025-09-15T02:43:05Z", "host": "db-1", "service": "ingest", "level": "WARN", "message": "cache miss", "latency_ms": 102, "lat": 40.530686, "lon": -3.622789}
{"@timestamp": "2025-09-15T02:44:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 112, "lat": 40.582235, "lon": -3.908604}
{"@timestamp": "2025-09-15T02:52:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 80, "lat": 40.561122, "lon": -3.655809}
{"@timestamp": "2025-09-15T03:04:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 105, "lat": 40.609491, "lon": -3.594382}
{"@timestamp": "2025-09-15T03:14:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 93, "lat": 40.41851, "lon": -3.601485}
{"@timestamp": "2025-09-15T03:20:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 75, "lat": 40.227168, "lon": -3.774656}
{"@timestamp": "2025-09-15T03:38:05Z", "host": "db-1", "service": "auth", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 39, "lat": 40.357635, "lon": -3.804622}
{"@timestamp": "2025-09-15T03:45:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 56, "lat": 40.616254, "lon": -3.721173}
{"@timestamp": "2025-09-15T04:30:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "cache miss", "latency_ms": 71, "lat": 40.408021, "lon": -3.505191}
{"@timestamp": "2025-09-15T04:35:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 120, "lat": 40.615767, "lon": -3.702017}
{"@timestamp": "2025-09-15T04:38:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "cache miss", "latency_ms": 127, "lat": 40.599533, "lon": -3.840011}
{"@timestamp": "2025-09-15T04:55:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 95, "lat": 40.436639, "lon": -3.626846}
{"@timestamp": "2025-09-15T05:04:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 55, "lat": 40.488999, "lon": -3.495359}
{"@timestamp": "2025-09-15T05:09:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 102, "lat": 40.176839, "lon": -3.823236}
{"@timestamp": "2025-09-15T05:30:05Z", "host": "web-1", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 94, "lat": 40.611298, "lon": -3.681011}
{"@timestamp": "2025-09-15T05:31:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "validation error", "latency_ms": 62, "lat": 40.418038, "lon": -3.756942}
{"@timestamp": "2025-09-15T05:32:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "consume event", "latency_ms": 77, "lat": 40.450243, "lon": -3.769956}
{"@timestamp": "2025-09-15T05:32:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 96, "lat": 40.428352, "lon": -3.60351}
{"@timestamp": "2025-09-15T05:33:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 109, "lat": 40.367579, "lon": -3.785044}
{"@timestamp": "2025-09-15T05:55:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 8, "lat": 40.311692, "lon": -3.756639}
{"@timestamp": "2025-09-15T05:55:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 112, "lat": 40.398332, "lon": -3.614022}
{"@timestamp": "2025-09-15T05:57:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 101, "lat": 40.29518, "lon": -3.577266}
{"@timestamp": "2025-09-15T05:58:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 69, "lat": 40.167582, "lon": -3.777392}
{"@timestamp": "2025-09-15T06:00:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 56, "lat": 40.339057, "lon": -3.51482}
{"@timestamp": "2025-09-15T06:06:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 115, "lat": 40.184145, "lon": -3.795328}
{"@timestamp": "2025-09-15T06:07:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 76, "lat": 40.306933, "lon": -3.842754}
{"@timestamp": "2025-09-15T06:16:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 91, "lat": 40.657371, "lon": -3.787228}
{"@timestamp": "2025-09-15T06:20:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 92, "lat": 40.236512, "lon": -3.67832}
{"@timestamp": "2025-09-15T06:34:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 133, "lat": 40.455258, "lon": -3.952961}
{"@timestamp": "2025-09-15T06:35:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 81, "lat": 40.219413, "lon": -3.695574}
{"@timestamp": "2025-09-15T06:36:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "consume event", "latency_ms": 124, "lat": 40.540948, "lon": -3.502027}
{"@timestamp": "2025-09-15T06:49:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 128, "lat": 40.655772, "lon": -3.624685}
{"@timestamp": "2025-09-15T07:10:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 111, "lat": 40.42983, "lon": -3.700136}
{"@timestamp": "2025-09-15T07:14:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 114, "lat": 40.490353, "lon": -3.640486}
{"@timestamp": "2025-09-15T07:22:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 146, "lat": 40.433271, "lon": -3.827339}
{"@timestamp": "2025-09-15T07:24:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "login failed", "latency_ms": 97, "lat": 40.650054, "lon": -3.632953}
{"@timestamp": "2025-09-15T07:26:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "db query executed", "latency_ms": 74, "lat": 40.376412, "lon": -3.661964}
{"@timestamp": "2025-09-15T07:30:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 110, "lat": 40.218132, "lon": -3.529985}
{"@timestamp": "2025-09-15T07:33:05Z", "host": "web-2", "service": "ingest", "level": "WARN", "message": "request completed", "latency_ms": 111, "lat": 40.535445, "lon": -3.809844}
{"@timestamp": "2025-09-15T07:39:05Z", "host": "web-2", "service": "ingest", "level": "WARN", "message": "consume event", "latency_ms": 110, "lat": 40.593976, "lon": -3.700457}
{"@timestamp": "2025-09-15T07:42:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 70, "lat": 40.585288, "lon": -3.829055}
{"@timestamp": "2025-09-15T07:46:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 100, "lat": 40.537058, "lon": -3.722361}
{"@timestamp": "2025-09-15T08:06:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 144, "lat": 40.536484, "lon": -3.597846}
{"@timestamp": "2025-09-15T08:09:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 146, "lat": 40.282256, "lon": -3.940758}
{"@timestamp": "2025-09-15T08:25:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 87, "lat": 40.204657, "lon": -3.727078}
{"@timestamp": "2025-09-15T08:48:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 55, "lat": 40.408034, "lon": -3.768694}
{"@timestamp": "2025-09-15T08:53:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "cache miss", "latency_ms": 112, "lat": 40.296878, "lon": -3.790124}
{"@timestamp": "2025-09-15T08:56:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 111, "lat": 40.249069, "lon": -3.526557}
{"@timestamp": "2025-09-15T08:59:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 47, "lat": 40.38773, "lon": -3.770908}
{"@timestamp": "2025-09-15T09:01:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "request completed", "latency_ms": 121, "lat": 40.643302, "lon": -3.722989}
{"@timestamp": "2025-09-15T09:14:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 97, "lat": 40.572297, "lon": -3.646866}
{"@timestamp": "2025-09-15T09:27:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "login succeeded", "latency_ms": 88, "lat": 40.605539, "lon": -3.742607}
{"@timestamp": "2025-09-15T09:32:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 64, "lat": 40.314059, "lon": -3.864946}
{"@timestamp": "2025-09-15T09:41:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 121, "lat": 40.370948, "lon": -3.883911}
{"@timestamp": "2025-09-15T09:44:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "login succeeded", "latency_ms": 69, "lat": 40.513268, "lon": -3.93031}
{"@timestamp": "2025-09-15T10:03:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "request completed", "latency_ms": 97, "lat": 40.59373, "lon": -3.7923}
{"@timestamp": "2025-09-15T10:07:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 86, "lat": 40.495454, "lon": -3.756009}
{"@timestamp": "2025-09-15T10:11:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 84, "lat": 40.237578, "lon": -3.601623}
{"@timestamp": "2025-09-15T10:31:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 49, "lat": 40.511425, "lon": -3.774716}
{"@timestamp": "2025-09-15T10:45:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 97, "lat": 40.194332, "lon": -3.77929}
{"@timestamp": "2025-09-15T10:49:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 99, "lat": 40.206335, "lon": -3.728907}
{"@timestamp": "2025-09-15T10:54:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 125, "lat": 40.577701, "lon": -3.551277}
{"@timestamp": "2025-09-15T11:11:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 142, "lat": 40.227527, "lon": -3.922965}
{"@timestamp": "2025-09-15T11:13:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 116, "lat": 40.582942, "lon": -3.809068}
{"@timestamp": "2025-09-15T11:14:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 102, "lat": 40.534669, "lon": -3.923321}
{"@timestamp": "2025-09-15T11:28:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 127, "lat": 40.553897, "lon": -3.754735}
{"@timestamp": "2025-09-15T11:34:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 101, "lat": 40.619453, "lon": -3.880126}
{"@timestamp": "2025-09-15T11:34:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "cache miss", "latency_ms": 47, "lat": 40.437603, "lon": -3.726761}
{"@timestamp": "2025-09-15T11:53:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 115, "lat": 40.269523, "lon": -3.650337}
{"@timestamp": "2025-09-15T11:54:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 116, "lat": 40.264896, "lon": -3.838791}
{"@timestamp": "2025-09-15T11:55:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 131, "lat": 40.48989, "lon": -3.729637}
{"@timestamp": "2025-09-15T12:01:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 111, "lat": 40.374928, "lon": -3.593656}
{"@timestamp": "2025-09-15T12:19:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 98, "lat": 40.469157, "lon": -3.834674}
{"@timestamp": "2025-09-15T12:26:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 91, "lat": 40.373707, "lon": -3.54009}
{"@timestamp": "2025-09-15T12:27:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 114, "lat": 40.418232, "lon": -3.519694}
{"@timestamp": "2025-09-15T12:37:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 76, "lat": 40.488126, "lon": -3.555201}
{"@timestamp": "2025-09-15T12:42:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "login succeeded", "latency_ms": 92, "lat": 40.527442, "lon": -3.796026}
{"@timestamp": "2025-09-15T12:54:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 44, "lat": 40.215901, "lon": -3.591005}
{"@timestamp": "2025-09-15T13:07:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "login failed", "latency_ms": 108, "lat": 40.221649, "lon": -3.812695}
{"@timestamp": "2025-09-15T13:19:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "login failed", "latency_ms": 95, "lat": 40.284053, "lon": -3.947425}
{"@timestamp": "2025-09-15T13:35:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 76, "lat": 40.294382, "lon": -3.83376}
{"@timestamp": "2025-09-15T13:47:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "login failed", "latency_ms": 85, "lat": 40.392243, "lon": -3.864361}
{"@timestamp": "2025-09-15T13:51:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 77, "lat": 40.614789, "lon": -3.468997}
{"@timestamp": "2025-09-15T14:20:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 89, "lat": 40.5545, "lon": -3.513313}
{"@timestamp": "2025-09-15T14:25:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 77, "lat": 40.298448, "lon": -3.721271}
{"@timestamp": "2025-09-15T14:33:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "login succeeded", "latency_ms": 86, "lat": 40.600631, "lon": -3.65446}
{"@timestamp": "2025-09-15T14:36:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 75, "lat": 40.657187, "lon": -3.834397}
{"@timestamp": "2025-09-15T14:49:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 114, "lat": 40.551698, "lon": -3.480769}
{"@timestamp": "2025-09-15T15:08:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "request completed", "latency_ms": 129, "lat": 40.376116, "lon": -3.686043}
{"@timestamp": "2025-09-15T15:13:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "db query executed", "latency_ms": 66, "lat": 40.447742, "lon": -3.841646}
{"@timestamp": "2025-09-15T15:23:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 55, "lat": 40.219763, "lon": -3.9269}
{"@timestamp": "2025-09-15T15:23:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 49, "lat": 40.255318, "lon": -3.655008}
{"@timestamp": "2025-09-15T15:23:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 84, "lat": 40.417196, "lon": -3.466638}
{"@timestamp": "2025-09-15T15:25:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 137, "lat": 40.187696, "lon": -3.547478}
{"@timestamp": "2025-09-15T15:30:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 124, "lat": 40.441631, "lon": -3.708326}
{"@timestamp": "2025-09-15T15:44:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 129, "lat": 40.230474, "lon": -3.464438}
{"@timestamp": "2025-09-15T15:45:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 106, "lat": 40.215265, "lon": -3.738274}
{"@timestamp": "2025-09-15T15:45:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 142, "lat": 40.618593, "lon": -3.686283}
{"@timestamp": "2025-09-15T15:47:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 94, "lat": 40.535813, "lon": -3.669379}
{"@timestamp": "2025-09-15T15:55:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 79, "lat": 40.474639, "lon": -3.660385}
{"@timestamp": "2025-09-15T15:55:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 141, "lat": 40.240883, "lon": -3.74286}
{"@timestamp": "2025-09-15T15:58:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "validation error", "latency_ms": 169, "lat": 40.264025, "lon": -3.794921}
{"@timestamp": "2025-09-15T16:06:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "validation error", "latency_ms": 52, "lat": 40.545537, "lon": -3.473181}
{"@timestamp": "2025-09-15T16:11:05Z", "host": "web-1", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 93, "lat": 40.236367, "lon": -3.465178}
{"@timestamp": "2025-09-15T16:15:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 108, "lat": 40.236948, "lon": -3.79651}
{"@timestamp": "2025-09-15T16:19:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 91, "lat": 40.592448, "lon": -3.716442}
{"@timestamp": "2025-09-15T16:28:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 86, "lat": 40.268399, "lon": -3.54977}
{"@timestamp": "2025-09-15T16:31:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "db query executed", "latency_ms": 133, "lat": 40.321885, "lon": -3.735057}
{"@timestamp": "2025-09-15T16:34:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 66, "lat": 40.313389, "lon": -3.63948}
{"@timestamp": "2025-09-15T16:40:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 120, "lat": 40.30505, "lon": -3.659007}
{"@timestamp": "2025-09-15T16:55:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 94, "lat": 40.530354, "lon": -3.837395}
{"@timestamp": "2025-09-15T17:00:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 124, "lat": 40.490696, "lon": -3.865491}
{"@timestamp": "2025-09-15T17:00:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "login succeeded", "latency_ms": 132, "lat": 40.605047, "lon": -3.863232}
{"@timestamp": "2025-09-15T17:17:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 111, "lat": 40.482381, "lon": -3.493335}
{"@timestamp": "2025-09-15T17:18:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "request completed", "latency_ms": 146, "lat": 40.412537, "lon": -3.486876}
{"@timestamp": "2025-09-15T17:35:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 126, "lat": 40.298113, "lon": -3.688579}
{"@timestamp": "2025-09-15T17:37:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 142, "lat": 40.52388, "lon": -3.602504}
{"@timestamp": "2025-09-15T17:45:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "login failed", "latency_ms": 128, "lat": 40.566752, "lon": -3.481117}
{"@timestamp": "2025-09-15T17:46:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 101, "lat": 40.610628, "lon": -3.731685}
{"@timestamp": "2025-09-15T17:55:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "login succeeded", "latency_ms": 30, "lat": 40.334284, "lon": -3.820256}
{"@timestamp": "2025-09-15T17:57:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 41, "lat": 40.389757, "lon": -3.874221}
{"@timestamp": "2025-09-15T17:58:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 108, "lat": 40.414443, "lon": -3.912254}
{"@timestamp": "2025-09-15T17:59:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 112, "lat": 40.317724, "lon": -3.551737}
{"@timestamp": "2025-09-15T18:10:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "publish event", "latency_ms": 146, "lat": 40.621891, "lon": -3.607891}
{"@timestamp": "2025-09-15T18:44:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 100, "lat": 40.360219, "lon": -3.534313}
{"@timestamp": "2025-09-15T18:51:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 17, "lat": 40.363686, "lon": -3.88835}
{"@timestamp": "2025-09-15T18:54:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 101, "lat": 40.523274, "lon": -3.754304}
{"@timestamp": "2025-09-15T19:15:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "login failed", "latency_ms": 137, "lat": 40.175915, "lon": -3.799367}
{"@timestamp": "2025-09-15T19:33:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "validation error", "latency_ms": 126, "lat": 40.624005, "lon": -3.746543}
{"@timestamp": "2025-09-15T19:34:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 85, "lat": 40.466711, "lon": -3.567205}
{"@timestamp": "2025-09-15T19:44:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 91, "lat": 40.317934, "lon": -3.599791}
{"@timestamp": "2025-09-15T19:47:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "cache miss", "latency_ms": 94, "lat": 40.435764, "lon": -3.833316}
{"@timestamp": "2025-09-15T19:53:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 93, "lat": 40.625768, "lon": -3.760092}
{"@timestamp": "2025-09-15T19:58:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 89, "lat": 40.515153, "lon": -3.889333}
{"@timestamp": "2025-09-15T20:02:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 119, "lat": 40.643042, "lon": -3.742439}
{"@timestamp": "2025-09-15T20:11:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 136, "lat": 40.301182, "lon": -3.510593}
{"@timestamp": "2025-09-15T20:14:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 102, "lat": 40.502645, "lon": -3.803801}
{"@timestamp": "2025-09-15T20:14:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 125, "lat": 40.409763, "lon": -3.558198}
{"@timestamp": "2025-09-15T20:31:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "publish event", "latency_ms": 112, "lat": 40.531809, "lon": -3.585711}
{"@timestamp": "2025-09-15T20:50:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "consume event", "latency_ms": 87, "lat": 40.277399, "lon": -3.847123}
{"@timestamp": "2025-09-15T21:03:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "consume event", "latency_ms": 63, "lat": 40.603573, "lon": -3.593024}
{"@timestamp": "2025-09-15T21:04:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 125, "lat": 40.171394, "lon": -3.527619}
{"@timestamp": "2025-09-15T21:05:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 119, "lat": 40.557643, "lon": -3.897541}
{"@timestamp": "2025-09-15T21:18:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 159, "lat": 40.484329, "lon": -3.678379}
{"@timestamp": "2025-09-15T21:49:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 97, "lat": 40.556166, "lon": -3.484879}
{"@timestamp": "2025-09-15T21:59:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 116, "lat": 40.170099, "lon": -3.512783}
{"@timestamp": "2025-09-15T22:03:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 54, "lat": 40.224718, "lon": -3.798309}
{"@timestamp": "2025-09-15T22:15:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 146, "lat": 40.289301, "lon": -3.894399}
{"@timestamp": "2025-09-15T22:26:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 171, "lat": 40.419522, "lon": -3.470457}
{"@timestamp": "2025-09-15T22:26:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 98, "lat": 40.460795, "lon": -3.460918}
{"@timestamp": "2025-09-15T22:28:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "request completed", "latency_ms": 110, "lat": 40.545022, "lon": -3.641096}
{"@timestamp": "2025-09-15T22:40:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 103, "lat": 40.433403, "lon": -3.640333}
{"@timestamp": "2025-09-15T22:51:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 50, "lat": 40.638835, "lon": -3.769134}
{"@timestamp": "2025-09-15T23:06:05Z", "host": "web-1", "service": "search", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 93, "lat": 40.267245, "lon": -3.641716}
{"@timestamp": "2025-09-15T23:07:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 69, "lat": 40.569052, "lon": -3.79529}
{"@timestamp": "2025-09-15T23:16:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "consume event", "latency_ms": 62, "lat": 40.622926, "lon": -3.671054}
{"@timestamp": "2025-09-15T23:20:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "cache miss", "latency_ms": 98, "lat": 40.32498, "lon": -3.559908}
{"@timestamp": "2025-09-15T23:44:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 101, "lat": 40.265436, "lon": -3.652601}
{"@timestamp": "2025-09-15T23:53:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 116, "lat": 40.457095, "lon": -3.462025}
{"@timestamp": "2025-09-16T00:02:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 101, "lat": 40.358593, "lon": -3.492866}
{"@timestamp": "2025-09-16T00:12:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 137, "lat": 40.336738, "lon": -3.559941}
{"@timestamp": "2025-09-16T00:22:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 99, "lat": 40.465423, "lon": -3.876674}
{"@timestamp": "2025-09-16T00:22:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "publish event", "latency_ms": 116, "lat": 40.522493, "lon": -3.473898}
{"@timestamp": "2025-09-16T00:23:05Z", "host": "db-1", "service": "auth", "level": "WARN", "message": "publish event", "latency_ms": 98, "lat": 40.188567, "lon": -3.760359}
{"@timestamp": "2025-09-16T00:25:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 98, "lat": 40.391168, "lon": -3.667582}
{"@timestamp": "2025-09-16T00:50:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 117, "lat": 40.554808, "lon": -3.834407}
{"@timestamp": "2025-09-16T00:50:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "publish event", "latency_ms": 160, "lat": 40.484593, "lon": -3.539446}
{"@timestamp": "2025-09-16T00:54:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 97, "lat": 40.432906, "lon": -3.748131}
{"@timestamp": "2025-09-16T01:09:05Z", "host": "web-1", "service": "search", "level": "ERROR", "message": "consume event", "latency_ms": 150, "lat": 40.662156, "lon": -3.513737}
{"@timestamp": "2025-09-16T01:16:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "db query executed", "latency_ms": 129, "lat": 40.255511, "lon": -3.502996}
{"@timestamp": "2025-09-16T01:25:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 97, "lat": 40.314982, "lon": -3.819543}
{"@timestamp": "2025-09-16T01:26:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "cache miss", "latency_ms": 92, "lat": 40.211624, "lon": -3.598672}
{"@timestamp": "2025-09-16T01:42:05Z", "host": "web-1", "service": "checkout", "level": "ERROR", "message": "login succeeded", "latency_ms": 87, "lat": 40.348467, "lon": -3.735804}
{"@timestamp": "2025-09-16T02:17:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "login succeeded", "latency_ms": 87, "lat": 40.533767, "lon": -3.577569}
{"@timestamp": "2025-09-16T02:20:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 124, "lat": 40.647664, "lon": -3.895765}
{"@timestamp": "2025-09-16T02:20:05Z", "host": "db-1", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 48, "lat": 40.534067, "lon": -3.651943}
{"@timestamp": "2025-09-16T02:23:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 81, "lat": 40.597682, "lon": -3.932649}
{"@timestamp": "2025-09-16T02:54:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 143, "lat": 40.239844, "lon": -3.820548}
{"@timestamp": "2025-09-16T03:05:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 127, "lat": 40.371678, "lon": -3.873613}
{"@timestamp": "2025-09-16T03:06:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "publish event", "latency_ms": 99, "lat": 40.285739, "lon": -3.659369}
{"@timestamp": "2025-09-16T03:17:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 195, "lat": 40.367814, "lon": -3.840857}
{"@timestamp": "2025-09-16T03:43:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 87, "lat": 40.631027, "lon": -3.786279}
{"@timestamp": "2025-09-16T03:44:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "db query executed", "latency_ms": 124, "lat": 40.300744, "lon": -3.682247}
{"@timestamp": "2025-09-16T03:50:05Z", "host": "web-2", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 101, "lat": 40.41115, "lon": -3.912465}
{"@timestamp": "2025-09-16T04:00:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 98, "lat": 40.466557, "lon": -3.695893}
{"@timestamp": "2025-09-16T04:03:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 155, "lat": 40.466841, "lon": -3.456196}
{"@timestamp": "2025-09-16T04:05:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "login failed", "latency_ms": 16, "lat": 40.231686, "lon": -3.511677}
{"@timestamp": "2025-09-16T04:20:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 95, "lat": 40.558133, "lon": -3.773238}
{"@timestamp": "2025-09-16T04:21:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "validation error", "latency_ms": 132, "lat": 40.217514, "lon": -3.714055}
{"@timestamp": "2025-09-16T04:35:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 92, "lat": 40.185782, "lon": -3.925716}
{"@timestamp": "2025-09-16T04:38:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 120, "lat": 40.589552, "lon": -3.747272}
{"@timestamp": "2025-09-16T04:44:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 97, "lat": 40.635937, "lon": -3.89102}
{"@timestamp": "2025-09-16T04:57:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "login succeeded", "latency_ms": 68, "lat": 40.258982, "lon": -3.928112}
{"@timestamp": "2025-09-16T05:02:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 155, "lat": 40.236779, "lon": -3.680527}
{"@timestamp": "2025-09-16T05:02:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "login succeeded", "latency_ms": 50, "lat": 40.27906, "lon": -3.55819}
{"@timestamp": "2025-09-16T05:12:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 127, "lat": 40.369233, "lon": -3.932887}
{"@timestamp": "2025-09-16T05:13:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 101, "lat": 40.277161, "lon": -3.594877}
{"@timestamp": "2025-09-16T05:22:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 74, "lat": 40.51194, "lon": -3.845165}
{"@timestamp": "2025-09-16T05:29:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 78, "lat": 40.288141, "lon": -3.629407}
{"@timestamp": "2025-09-16T05:31:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "login failed", "latency_ms": 108, "lat": 40.407388, "lon": -3.798949}
{"@timestamp": "2025-09-16T05:34:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 101, "lat": 40.450478, "lon": -3.914421}
{"@timestamp": "2025-09-16T05:34:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "validation error", "latency_ms": 86, "lat": 40.534632, "lon": -3.832624}
{"@timestamp": "2025-09-16T05:35:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "publish event", "latency_ms": 94, "lat": 40.313918, "lon": -3.751599}
{"@timestamp": "2025-09-16T05:57:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 133, "lat": 40.616859, "lon": -3.794907}
{"@timestamp": "2025-09-16T06:01:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 132, "lat": 40.236801, "lon": -3.684491}
{"@timestamp": "2025-09-16T06:05:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 108, "lat": 40.487921, "lon": -3.745872}
{"@timestamp": "2025-09-16T06:05:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "login succeeded", "latency_ms": 43, "lat": 40.210618, "lon": -3.886243}
{"@timestamp": "2025-09-16T06:07:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 126, "lat": 40.320818, "lon": -3.750903}
{"@timestamp": "2025-09-16T06:17:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 122, "lat": 40.640224, "lon": -3.871237}
{"@timestamp": "2025-09-16T06:32:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 31, "lat": 40.527502, "lon": -3.657447}
{"@timestamp": "2025-09-16T06:37:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "db query executed", "latency_ms": 79, "lat": 40.592523, "lon": -3.814876}
{"@timestamp": "2025-09-16T06:38:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 93, "lat": 40.173637, "lon": -3.749805}
{"@timestamp": "2025-09-16T06:58:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 37, "lat": 40.551541, "lon": -3.904674}
{"@timestamp": "2025-09-16T06:58:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "login succeeded", "latency_ms": 90, "lat": 40.634111, "lon": -3.814336}
{"@timestamp": "2025-09-16T07:08:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 89, "lat": 40.374792, "lon": -3.456916}
{"@timestamp": "2025-09-16T07:20:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "db query executed", "latency_ms": 79, "lat": 40.549729, "lon": -3.498757}
{"@timestamp": "2025-09-16T07:21:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 65, "lat": 40.646212, "lon": -3.908467}
{"@timestamp": "2025-09-16T07:58:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 85, "lat": 40.331513, "lon": -3.931877}
{"@timestamp": "2025-09-16T08:15:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "cache miss", "latency_ms": 73, "lat": 40.49043, "lon": -3.74835}
{"@timestamp": "2025-09-16T08:24:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 144, "lat": 40.514885, "lon": -3.924477}
{"@timestamp": "2025-09-16T08:32:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "publish event", "latency_ms": 106, "lat": 40.203841, "lon": -3.639077}
{"@timestamp": "2025-09-16T08:34:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 119, "lat": 40.314541, "lon": -3.929936}
{"@timestamp": "2025-09-16T09:00:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 110, "lat": 40.196055, "lon": -3.793959}
{"@timestamp": "2025-09-16T09:05:05Z", "host": "web-2", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 97, "lat": 40.607884, "lon": -3.814744}
{"@timestamp": "2025-09-16T09:06:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 85, "lat": 40.428131, "lon": -3.615541}
{"@timestamp": "2025-09-16T09:12:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 39, "lat": 40.589683, "lon": -3.812671}
{"@timestamp": "2025-09-16T09:14:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 84, "lat": 40.659891, "lon": -3.475026}
{"@timestamp": "2025-09-16T09:19:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 38, "lat": 40.473651, "lon": -3.643234}
{"@timestamp": "2025-09-16T09:20:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 53, "lat": 40.206278, "lon": -3.502411}
{"@timestamp": "2025-09-16T09:21:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 114, "lat": 40.418038, "lon": -3.611382}
{"@timestamp": "2025-09-16T09:22:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 129, "lat": 40.549707, "lon": -3.69315}
{"@timestamp": "2025-09-16T09:29:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 121, "lat": 40.382738, "lon": -3.581506}
{"@timestamp": "2025-09-16T09:30:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 94, "lat": 40.262653, "lon": -3.678552}
{"@timestamp": "2025-09-16T09:41:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 101, "lat": 40.470424, "lon": -3.579837}
{"@timestamp": "2025-09-16T09:43:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 67, "lat": 40.599699, "lon": -3.787838}
{"@timestamp": "2025-09-16T09:47:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 1, "lat": 40.218764, "lon": -3.644749}
{"@timestamp": "2025-09-16T10:12:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 97, "lat": 40.471314, "lon": -3.591553}
{"@timestamp": "2025-09-16T10:17:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 84, "lat": 40.416185, "lon": -3.848534}
{"@timestamp": "2025-09-16T10:29:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 115, "lat": 40.349689, "lon": -3.752173}
{"@timestamp": "2025-09-16T10:54:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 107, "lat": 40.317623, "lon": -3.948664}
{"@timestamp": "2025-09-16T10:55:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "publish event", "latency_ms": 76, "lat": 40.357736, "lon": -3.69007}
{"@timestamp": "2025-09-16T11:01:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 52, "lat": 40.628706, "lon": -3.839418}
{"@timestamp": "2025-09-16T11:11:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 93, "lat": 40.609194, "lon": -3.578361}
{"@timestamp": "2025-09-16T11:22:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "login failed", "latency_ms": 76, "lat": 40.24794, "lon": -3.726649}
{"@timestamp": "2025-09-16T11:23:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 70, "lat": 40.427935, "lon": -3.771663}
{"@timestamp": "2025-09-16T11:26:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "request completed", "latency_ms": 16, "lat": 40.447227, "lon": -3.72492}
{"@timestamp": "2025-09-16T11:31:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 75, "lat": 40.498121, "lon": -3.833349}
{"@timestamp": "2025-09-16T11:37:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 106, "lat": 40.639492, "lon": -3.521718}
{"@timestamp": "2025-09-16T12:02:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 107, "lat": 40.498291, "lon": -3.497366}
{"@timestamp": "2025-09-16T12:07:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 84, "lat": 40.185292, "lon": -3.853005}
{"@timestamp": "2025-09-16T12:08:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 79, "lat": 40.23347, "lon": -3.721478}
{"@timestamp": "2025-09-16T12:19:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 136, "lat": 40.547041, "lon": -3.831237}
{"@timestamp": "2025-09-16T13:08:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 135, "lat": 40.478595, "lon": -3.760182}
{"@timestamp": "2025-09-16T13:09:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "validation error", "latency_ms": 67, "lat": 40.507521, "lon": -3.797745}
{"@timestamp": "2025-09-16T13:13:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "validation error", "latency_ms": 109, "lat": 40.427337, "lon": -3.671329}
{"@timestamp": "2025-09-16T13:17:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 163, "lat": 40.259879, "lon": -3.776534}
{"@timestamp": "2025-09-16T13:42:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "db query executed", "latency_ms": 80, "lat": 40.29571, "lon": -3.762463}
{"@timestamp": "2025-09-16T14:03:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 57, "lat": 40.255212, "lon": -3.636551}
{"@timestamp": "2025-09-16T14:10:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "db query executed", "latency_ms": 91, "lat": 40.578605, "lon": -3.932815}
{"@timestamp": "2025-09-16T14:12:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 104, "lat": 40.248051, "lon": -3.458492}
{"@timestamp": "2025-09-16T14:21:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 77, "lat": 40.365271, "lon": -3.492263}
{"@timestamp": "2025-09-16T14:23:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "cache miss", "latency_ms": 83, "lat": 40.475668, "lon": -3.737762}
{"@timestamp": "2025-09-16T14:25:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 115, "lat": 40.550508, "lon": -3.653824}
{"@timestamp": "2025-09-16T14:28:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "cache miss", "latency_ms": 69, "lat": 40.576836, "lon": -3.761443}
{"@timestamp": "2025-09-16T14:48:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 170, "lat": 40.224761, "lon": -3.567526}
{"@timestamp": "2025-09-16T14:50:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 139, "lat": 40.213371, "lon": -3.467725}
{"@timestamp": "2025-09-16T14:50:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "login succeeded", "latency_ms": 85, "lat": 40.542805, "lon": -3.537838}
{"@timestamp": "2025-09-16T14:55:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 138, "lat": 40.40081, "lon": -3.857394}
{"@timestamp": "2025-09-16T15:01:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 121, "lat": 40.379369, "lon": -3.681519}
{"@timestamp": "2025-09-16T15:06:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 121, "lat": 40.557861, "lon": -3.809819}
{"@timestamp": "2025-09-16T15:14:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 125, "lat": 40.273276, "lon": -3.472741}
{"@timestamp": "2025-09-16T15:16:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 107, "lat": 40.565873, "lon": -3.5819}
{"@timestamp": "2025-09-16T15:21:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 84, "lat": 40.176498, "lon": -3.928984}
{"@timestamp": "2025-09-16T15:28:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "cache miss", "latency_ms": 103, "lat": 40.547776, "lon": -3.701418}
{"@timestamp": "2025-09-16T15:40:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 90, "lat": 40.435735, "lon": -3.461885}
{"@timestamp": "2025-09-16T15:50:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 80, "lat": 40.358772, "lon": -3.673009}
{"@timestamp": "2025-09-16T15:51:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "publish event", "latency_ms": 93, "lat": 40.209669, "lon": -3.719359}
{"@timestamp": "2025-09-16T15:54:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "validation error", "latency_ms": 120, "lat": 40.334998, "lon": -3.706647}
{"@timestamp": "2025-09-16T15:56:05Z", "host": "web-1", "service": "search", "level": "ERROR", "message": "cache miss", "latency_ms": 124, "lat": 40.449576, "lon": -3.771553}
{"@timestamp": "2025-09-16T15:58:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 94, "lat": 40.520611, "lon": -3.458307}
{"@timestamp": "2025-09-16T16:26:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 118, "lat": 40.211609, "lon": -3.67669}
{"@timestamp": "2025-09-16T17:05:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 82, "lat": 40.275435, "lon": -3.521935}
{"@timestamp": "2025-09-16T17:08:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 102, "lat": 40.549498, "lon": -3.947696}
{"@timestamp": "2025-09-16T17:14:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 107, "lat": 40.633247, "lon": -3.621497}
{"@timestamp": "2025-09-16T17:26:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "login failed", "latency_ms": 56, "lat": 40.572735, "lon": -3.461902}
{"@timestamp": "2025-09-16T17:34:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 20, "lat": 40.346137, "lon": -3.75473}
{"@timestamp": "2025-09-16T17:35:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 124, "lat": 40.384724, "lon": -3.473929}
{"@timestamp": "2025-09-16T17:40:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 89, "lat": 40.244057, "lon": -3.925862}
{"@timestamp": "2025-09-16T17:41:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 127, "lat": 40.378716, "lon": -3.505586}
{"@timestamp": "2025-09-16T17:46:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 101, "lat": 40.261192, "lon": -3.918995}
{"@timestamp": "2025-09-16T18:00:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "consume event", "latency_ms": 116, "lat": 40.536025, "lon": -3.855565}
{"@timestamp": "2025-09-16T18:17:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 61, "lat": 40.191132, "lon": -3.765102}
{"@timestamp": "2025-09-16T18:20:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "publish event", "latency_ms": 135, "lat": 40.212271, "lon": -3.698612}
{"@timestamp": "2025-09-16T18:29:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 165, "lat": 40.607874, "lon": -3.802867}
{"@timestamp": "2025-09-16T18:40:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 139, "lat": 40.613144, "lon": -3.687651}
{"@timestamp": "2025-09-16T18:52:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 39, "lat": 40.488539, "lon": -3.848041}
{"@timestamp": "2025-09-16T19:01:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 162, "lat": 40.52141, "lon": -3.898467}
{"@timestamp": "2025-09-16T19:06:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 126, "lat": 40.380884, "lon": -3.645724}
{"@timestamp": "2025-09-16T19:24:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 74, "lat": 40.179482, "lon": -3.455608}
{"@timestamp": "2025-09-16T19:27:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "validation error", "latency_ms": 101, "lat": 40.367224, "lon": -3.818053}
{"@timestamp": "2025-09-16T19:32:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "login failed", "latency_ms": 76, "lat": 40.632036, "lon": -3.746352}
{"@timestamp": "2025-09-16T19:52:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 128, "lat": 40.40142, "lon": -3.734745}
{"@timestamp": "2025-09-16T19:54:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 156, "lat": 40.303156, "lon": -3.939229}
{"@timestamp": "2025-09-16T19:58:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "publish event", "latency_ms": 112, "lat": 40.39567, "lon": -3.856723}
{"@timestamp": "2025-09-16T19:58:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "login failed", "latency_ms": 96, "lat": 40.370974, "lon": -3.793271}
{"@timestamp": "2025-09-16T20:13:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 107, "lat": 40.348456, "lon": -3.553252}
{"@timestamp": "2025-09-16T20:17:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "validation error", "latency_ms": 66, "lat": 40.508238, "lon": -3.933291}
{"@timestamp": "2025-09-16T20:27:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 81, "lat": 40.278915, "lon": -3.610682}
{"@timestamp": "2025-09-16T20:38:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 110, "lat": 40.380499, "lon": -3.912184}
{"@timestamp": "2025-09-16T20:43:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 92, "lat": 40.274158, "lon": -3.860224}
{"@timestamp": "2025-09-16T20:46:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 115, "lat": 40.60264, "lon": -3.536398}
{"@timestamp": "2025-09-16T20:47:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 58, "lat": 40.36795, "lon": -3.641318}
{"@timestamp": "2025-09-16T21:05:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "consume event", "latency_ms": 108, "lat": 40.36664, "lon": -3.697122}
{"@timestamp": "2025-09-16T21:10:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 45, "lat": 40.515621, "lon": -3.739322}
{"@timestamp": "2025-09-16T21:14:05Z", "host": "app-2", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 109, "lat": 40.452472, "lon": -3.828502}
{"@timestamp": "2025-09-16T21:25:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 111, "lat": 40.430028, "lon": -3.546193}
{"@timestamp": "2025-09-16T21:52:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "cache miss", "latency_ms": 100, "lat": 40.598883, "lon": -3.456671}
{"@timestamp": "2025-09-16T21:54:05Z", "host": "web-2", "service": "ingest", "level": "WARN", "message": "consume event", "latency_ms": 107, "lat": 40.181681, "lon": -3.881008}
{"@timestamp": "2025-09-16T21:59:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 117, "lat": 40.458793, "lon": -3.826292}
{"@timestamp": "2025-09-16T22:00:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 116, "lat": 40.413558, "lon": -3.575909}
{"@timestamp": "2025-09-16T22:12:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 82, "lat": 40.639325, "lon": -3.60829}
{"@timestamp": "2025-09-16T22:32:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "publish event", "latency_ms": 108, "lat": 40.474958, "lon": -3.79758}
{"@timestamp": "2025-09-16T22:33:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 58, "lat": 40.528953, "lon": -3.885154}
{"@timestamp": "2025-09-16T22:35:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 106, "lat": 40.356976, "lon": -3.691314}
{"@timestamp": "2025-09-16T23:01:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "login succeeded", "latency_ms": 155, "lat": 40.544951, "lon": -3.553308}
{"@timestamp": "2025-09-16T23:12:05Z", "host": "web-2", "service": "ingest", "level": "WARN", "message": "login succeeded", "latency_ms": 134, "lat": 40.274584, "lon": -3.697627}
{"@timestamp": "2025-09-16T23:20:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 81, "lat": 40.197106, "lon": -3.589693}
{"@timestamp": "2025-09-16T23:30:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 80, "lat": 40.430141, "lon": -3.892445}
{"@timestamp": "2025-09-16T23:30:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "login succeeded", "latency_ms": 83, "lat": 40.342623, "lon": -3.664841}
{"@timestamp": "2025-09-17T00:02:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 73, "lat": 40.463633, "lon": -3.727797}
{"@timestamp": "2025-09-17T00:04:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 111, "lat": 40.297893, "lon": -3.933887}
{"@timestamp": "2025-09-17T00:12:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "validation error", "latency_ms": 106, "lat": 40.354623, "lon": -3.612435}
{"@timestamp": "2025-09-17T00:31:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 169, "lat": 40.200445, "lon": -3.656828}
{"@timestamp": "2025-09-17T00:38:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 58, "lat": 40.402603, "lon": -3.529612}
{"@timestamp": "2025-09-17T00:42:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 56, "lat": 40.338384, "lon": -3.597115}
{"@timestamp": "2025-09-17T00:44:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 113, "lat": 40.3829, "lon": -3.598964}
{"@timestamp": "2025-09-17T00:49:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 107, "lat": 40.261717, "lon": -3.874129}
{"@timestamp": "2025-09-17T01:05:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 117, "lat": 40.663966, "lon": -3.920438}
{"@timestamp": "2025-09-17T01:09:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "cache miss", "latency_ms": 23, "lat": 40.409182, "lon": -3.724944}
{"@timestamp": "2025-09-17T01:10:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 66, "lat": 40.26581, "lon": -3.862808}
{"@timestamp": "2025-09-17T01:17:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 59, "lat": 40.610484, "lon": -3.940819}
{"@timestamp": "2025-09-17T01:25:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "login succeeded", "latency_ms": 89, "lat": 40.43131, "lon": -3.58665}
{"@timestamp": "2025-09-17T01:28:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "login failed", "latency_ms": 95, "lat": 40.299808, "lon": -3.5962}
{"@timestamp": "2025-09-17T01:40:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 117, "lat": 40.377661, "lon": -3.839709}
{"@timestamp": "2025-09-17T01:42:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 142, "lat": 40.338164, "lon": -3.850891}
{"@timestamp": "2025-09-17T02:14:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "cache miss", "latency_ms": 91, "lat": 40.272228, "lon": -3.586619}
{"@timestamp": "2025-09-17T02:22:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 131, "lat": 40.510227, "lon": -3.835735}
{"@timestamp": "2025-09-17T02:29:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "request completed", "latency_ms": 80, "lat": 40.464936, "lon": -3.595201}
{"@timestamp": "2025-09-17T02:34:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 117, "lat": 40.615096, "lon": -3.883793}
{"@timestamp": "2025-09-17T02:41:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 97, "lat": 40.600966, "lon": -3.691391}
{"@timestamp": "2025-09-17T02:49:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "cache miss", "latency_ms": 78, "lat": 40.478406, "lon": -3.698398}
{"@timestamp": "2025-09-17T02:50:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 102, "lat": 40.402149, "lon": -3.766645}
{"@timestamp": "2025-09-17T03:05:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 53, "lat": 40.496246, "lon": -3.931911}
{"@timestamp": "2025-09-17T03:15:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 78, "lat": 40.260572, "lon": -3.488692}
{"@timestamp": "2025-09-17T03:29:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "consume event", "latency_ms": 113, "lat": 40.354152, "lon": -3.479445}
{"@timestamp": "2025-09-17T03:42:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 27, "lat": 40.221958, "lon": -3.885844}
{"@timestamp": "2025-09-17T03:53:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "publish event", "latency_ms": 63, "lat": 40.188532, "lon": -3.59319}
{"@timestamp": "2025-09-17T03:55:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 138, "lat": 40.558241, "lon": -3.882616}
{"@timestamp": "2025-09-17T04:01:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 154, "lat": 40.607508, "lon": -3.941407}
{"@timestamp": "2025-09-17T04:03:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 161, "lat": 40.402346, "lon": -3.747319}
{"@timestamp": "2025-09-17T04:35:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 134, "lat": 40.180283, "lon": -3.75679}
{"@timestamp": "2025-09-17T05:27:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 108, "lat": 40.609142, "lon": -3.632374}
{"@timestamp": "2025-09-17T05:33:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 107, "lat": 40.614551, "lon": -3.685347}
{"@timestamp": "2025-09-17T05:35:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 128, "lat": 40.639658, "lon": -3.543686}
{"@timestamp": "2025-09-17T05:42:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "validation error", "latency_ms": 135, "lat": 40.240487, "lon": -3.726483}
{"@timestamp": "2025-09-17T05:52:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 117, "lat": 40.540227, "lon": -3.674803}
{"@timestamp": "2025-09-17T05:52:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 103, "lat": 40.568855, "lon": -3.605844}
{"@timestamp": "2025-09-17T05:57:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 120, "lat": 40.292103, "lon": -3.59925}
{"@timestamp": "2025-09-17T06:04:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 76, "lat": 40.490384, "lon": -3.476584}
{"@timestamp": "2025-09-17T06:07:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 91, "lat": 40.643596, "lon": -3.610389}
{"@timestamp": "2025-09-17T06:15:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 88, "lat": 40.559733, "lon": -3.771292}
{"@timestamp": "2025-09-17T06:24:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 112, "lat": 40.380236, "lon": -3.607882}
{"@timestamp": "2025-09-17T06:28:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 137, "lat": 40.394193, "lon": -3.617386}
{"@timestamp": "2025-09-17T06:33:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 133, "lat": 40.666515, "lon": -3.470557}
{"@timestamp": "2025-09-17T06:41:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "cache miss", "latency_ms": 83, "lat": 40.512697, "lon": -3.556137}
{"@timestamp": "2025-09-17T06:44:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 129, "lat": 40.180894, "lon": -3.488387}
{"@timestamp": "2025-09-17T06:50:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "consume event", "latency_ms": 62, "lat": 40.496719, "lon": -3.670946}
{"@timestamp": "2025-09-17T06:56:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 72, "lat": 40.596554, "lon": -3.466687}
{"@timestamp": "2025-09-17T07:00:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 56, "lat": 40.213646, "lon": -3.863043}
{"@timestamp": "2025-09-17T07:01:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 122, "lat": 40.489758, "lon": -3.520823}
{"@timestamp": "2025-09-17T07:18:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "cache miss", "latency_ms": 101, "lat": 40.324304, "lon": -3.553392}
{"@timestamp": "2025-09-17T07:42:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 124, "lat": 40.630113, "lon": -3.535067}
{"@timestamp": "2025-09-17T07:44:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 72, "lat": 40.182274, "lon": -3.537758}
{"@timestamp": "2025-09-17T07:50:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 124, "lat": 40.614649, "lon": -3.82876}
{"@timestamp": "2025-09-17T07:58:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 62, "lat": 40.573392, "lon": -3.618742}
{"@timestamp": "2025-09-17T08:07:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "validation error", "latency_ms": 79, "lat": 40.655691, "lon": -3.793559}
{"@timestamp": "2025-09-17T08:23:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 129, "lat": 40.515096, "lon": -3.588547}
{"@timestamp": "2025-09-17T08:30:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 95, "lat": 40.361229, "lon": -3.619363}
{"@timestamp": "2025-09-17T08:31:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 82, "lat": 40.613306, "lon": -3.824833}
{"@timestamp": "2025-09-17T08:52:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "validation error", "latency_ms": 58, "lat": 40.609507, "lon": -3.626339}
{"@timestamp": "2025-09-17T08:53:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 144, "lat": 40.200557, "lon": -3.944976}
{"@timestamp": "2025-09-17T09:01:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 48, "lat": 40.398934, "lon": -3.792888}
{"@timestamp": "2025-09-17T09:28:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 70, "lat": 40.614172, "lon": -3.907179}
{"@timestamp": "2025-09-17T09:37:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 93, "lat": 40.195527, "lon": -3.694534}
{"@timestamp": "2025-09-17T09:57:05Z", "host": "app-2", "service": "auth", "level": "WARN", "message": "request completed", "latency_ms": 109, "lat": 40.286648, "lon": -3.51853}
{"@timestamp": "2025-09-17T10:09:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "db query executed", "latency_ms": 140, "lat": 40.336608, "lon": -3.485008}
{"@timestamp": "2025-09-17T10:16:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 99, "lat": 40.642552, "lon": -3.618499}
{"@timestamp": "2025-09-17T10:25:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 98, "lat": 40.572504, "lon": -3.760761}
{"@timestamp": "2025-09-17T10:27:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "cache miss", "latency_ms": 102, "lat": 40.506331, "lon": -3.479388}
{"@timestamp": "2025-09-17T10:35:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 106, "lat": 40.299612, "lon": -3.915856}
{"@timestamp": "2025-09-17T10:37:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 127, "lat": 40.453249, "lon": -3.740568}
{"@timestamp": "2025-09-17T10:41:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 49, "lat": 40.328932, "lon": -3.851841}
{"@timestamp": "2025-09-17T10:48:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 104, "lat": 40.53561, "lon": -3.937045}
{"@timestamp": "2025-09-17T10:48:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 146, "lat": 40.268344, "lon": -3.519375}
{"@timestamp": "2025-09-17T10:50:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "validation error", "latency_ms": 104, "lat": 40.496662, "lon": -3.948497}
{"@timestamp": "2025-09-17T10:58:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 137, "lat": 40.457043, "lon": -3.823654}
{"@timestamp": "2025-09-17T11:07:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "consume event", "latency_ms": 39, "lat": 40.56026, "lon": -3.693475}
{"@timestamp": "2025-09-17T11:10:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 60, "lat": 40.262192, "lon": -3.733281}
{"@timestamp": "2025-09-17T11:11:05Z", "host": "web-1", "service": "checkout", "level": "ERROR", "message": "consume event", "latency_ms": 96, "lat": 40.433845, "lon": -3.918832}
{"@timestamp": "2025-09-17T11:28:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 69, "lat": 40.623823, "lon": -3.828917}
{"@timestamp": "2025-09-17T11:28:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 114, "lat": 40.583663, "lon": -3.801863}
{"@timestamp": "2025-09-17T11:31:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 110, "lat": 40.440984, "lon": -3.92082}
{"@timestamp": "2025-09-17T11:36:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 121, "lat": 40.388894, "lon": -3.667283}
{"@timestamp": "2025-09-17T11:38:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "login succeeded", "latency_ms": 79, "lat": 40.354964, "lon": -3.500179}
{"@timestamp": "2025-09-17T11:51:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 104, "lat": 40.504356, "lon": -3.785816}
{"@timestamp": "2025-09-17T12:06:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "consume event", "latency_ms": 84, "lat": 40.552795, "lon": -3.593338}
{"@timestamp": "2025-09-17T12:29:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 135, "lat": 40.565828, "lon": -3.597246}
{"@timestamp": "2025-09-17T12:30:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 141, "lat": 40.591947, "lon": -3.653594}
{"@timestamp": "2025-09-17T12:48:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 73, "lat": 40.305042, "lon": -3.791231}
{"@timestamp": "2025-09-17T12:53:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 92, "lat": 40.557058, "lon": -3.691657}
{"@timestamp": "2025-09-17T12:54:05Z", "host": "db-1", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 96, "lat": 40.627393, "lon": -3.661809}
{"@timestamp": "2025-09-17T12:55:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 77, "lat": 40.288324, "lon": -3.643299}
{"@timestamp": "2025-09-17T13:01:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 54, "lat": 40.279149, "lon": -3.784757}
{"@timestamp": "2025-09-17T13:03:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 72, "lat": 40.480928, "lon": -3.568049}
{"@timestamp": "2025-09-17T13:06:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 103, "lat": 40.371194, "lon": -3.934387}
{"@timestamp": "2025-09-17T13:07:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 114, "lat": 40.175758, "lon": -3.951738}
{"@timestamp": "2025-09-17T13:08:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 73, "lat": 40.218009, "lon": -3.876523}
{"@timestamp": "2025-09-17T13:14:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 58, "lat": 40.372204, "lon": -3.516996}
{"@timestamp": "2025-09-17T13:17:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "db query executed", "latency_ms": 105, "lat": 40.419514, "lon": -3.635192}
{"@timestamp": "2025-09-17T13:19:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 117, "lat": 40.239016, "lon": -3.491722}
{"@timestamp": "2025-09-17T13:20:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 106, "lat": 40.454746, "lon": -3.839517}
{"@timestamp": "2025-09-17T13:24:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "cache miss", "latency_ms": 70, "lat": 40.49158, "lon": -3.828994}
{"@timestamp": "2025-09-17T13:29:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 80, "lat": 40.549654, "lon": -3.490727}
{"@timestamp": "2025-09-17T13:40:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 126, "lat": 40.355384, "lon": -3.651315}
{"@timestamp": "2025-09-17T14:17:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 43, "lat": 40.596151, "lon": -3.742769}
{"@timestamp": "2025-09-17T14:18:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "login failed", "latency_ms": 83, "lat": 40.371848, "lon": -3.87138}
{"@timestamp": "2025-09-17T14:21:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 96, "lat": 40.531893, "lon": -3.690596}
{"@timestamp": "2025-09-17T14:24:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 90, "lat": 40.565177, "lon": -3.591138}
{"@timestamp": "2025-09-17T14:31:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 112, "lat": 40.384379, "lon": -3.493805}
{"@timestamp": "2025-09-17T14:34:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "request completed", "latency_ms": 85, "lat": 40.587536, "lon": -3.622688}
{"@timestamp": "2025-09-17T14:37:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "cache miss", "latency_ms": 112, "lat": 40.487588, "lon": -3.615231}
{"@timestamp": "2025-09-17T14:49:05Z", "host": "db-1", "service": "auth", "level": "WARN", "message": "consume event", "latency_ms": 106, "lat": 40.534794, "lon": -3.626964}
{"@timestamp": "2025-09-17T15:05:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 161, "lat": 40.650492, "lon": -3.806229}
{"@timestamp": "2025-09-17T15:28:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "login succeeded", "latency_ms": 77, "lat": 40.221147, "lon": -3.734514}
{"@timestamp": "2025-09-17T15:43:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 111, "lat": 40.32672, "lon": -3.930022}
{"@timestamp": "2025-09-17T15:47:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 77, "lat": 40.167898, "lon": -3.776231}
{"@timestamp": "2025-09-17T16:12:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "validation error", "latency_ms": 116, "lat": 40.600973, "lon": -3.639802}
{"@timestamp": "2025-09-17T16:14:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 72, "lat": 40.659411, "lon": -3.526141}
{"@timestamp": "2025-09-17T16:21:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 70, "lat": 40.395273, "lon": -3.585713}
{"@timestamp": "2025-09-17T16:25:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 106, "lat": 40.37268, "lon": -3.778255}
{"@timestamp": "2025-09-17T16:32:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 104, "lat": 40.425286, "lon": -3.735912}
{"@timestamp": "2025-09-17T16:37:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 118, "lat": 40.308029, "lon": -3.579173}
{"@timestamp": "2025-09-17T16:37:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 107, "lat": 40.174654, "lon": -3.59313}
{"@timestamp": "2025-09-17T16:38:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 103, "lat": 40.655106, "lon": -3.903998}
{"@timestamp": "2025-09-17T16:50:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 121, "lat": 40.389479, "lon": -3.566417}
{"@timestamp": "2025-09-17T17:01:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 82, "lat": 40.660803, "lon": -3.512987}
{"@timestamp": "2025-09-17T17:04:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 126, "lat": 40.182847, "lon": -3.669467}
{"@timestamp": "2025-09-17T17:04:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 57, "lat": 40.626999, "lon": -3.897331}
{"@timestamp": "2025-09-17T17:10:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 57, "lat": 40.579224, "lon": -3.706443}
{"@timestamp": "2025-09-17T17:10:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 86, "lat": 40.299484, "lon": -3.890421}
{"@timestamp": "2025-09-17T17:18:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 109, "lat": 40.321137, "lon": -3.78235}
{"@timestamp": "2025-09-17T17:46:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 83, "lat": 40.602071, "lon": -3.752896}
{"@timestamp": "2025-09-17T17:47:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 92, "lat": 40.263707, "lon": -3.639785}
{"@timestamp": "2025-09-17T18:09:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "validation error", "latency_ms": 146, "lat": 40.509681, "lon": -3.752116}
{"@timestamp": "2025-09-17T18:26:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 84, "lat": 40.433937, "lon": -3.870815}
{"@timestamp": "2025-09-17T18:27:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 79, "lat": 40.534515, "lon": -3.517429}
{"@timestamp": "2025-09-17T18:47:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "login succeeded", "latency_ms": 43, "lat": 40.505682, "lon": -3.593336}
{"@timestamp": "2025-09-17T18:53:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 108, "lat": 40.392757, "lon": -3.925355}
{"@timestamp": "2025-09-17T18:54:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 125, "lat": 40.304739, "lon": -3.922795}
{"@timestamp": "2025-09-17T19:17:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 63, "lat": 40.651351, "lon": -3.511524}
{"@timestamp": "2025-09-17T19:48:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "db query executed", "latency_ms": 60, "lat": 40.220291, "lon": -3.675725}
{"@timestamp": "2025-09-17T19:53:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "publish event", "latency_ms": 89, "lat": 40.571893, "lon": -3.896257}
{"@timestamp": "2025-09-17T19:54:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 92, "lat": 40.611663, "lon": -3.654976}
{"@timestamp": "2025-09-17T20:07:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 158, "lat": 40.298819, "lon": -3.886994}
{"@timestamp": "2025-09-17T20:41:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 139, "lat": 40.447626, "lon": -3.794242}
{"@timestamp": "2025-09-17T20:44:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 74, "lat": 40.277059, "lon": -3.461577}
{"@timestamp": "2025-09-17T20:44:05Z", "host": "db-1", "service": "ingest", "level": "WARN", "message": "cache miss", "latency_ms": 88, "lat": 40.296331, "lon": -3.610471}
{"@timestamp": "2025-09-17T20:46:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 114, "lat": 40.317484, "lon": -3.580725}
{"@timestamp": "2025-09-17T20:46:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "publish event", "latency_ms": 73, "lat": 40.649124, "lon": -3.616539}
{"@timestamp": "2025-09-17T20:55:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 130, "lat": 40.551286, "lon": -3.570886}
{"@timestamp": "2025-09-17T20:59:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 87, "lat": 40.313892, "lon": -3.769189}
{"@timestamp": "2025-09-17T21:03:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "login succeeded", "latency_ms": 111, "lat": 40.27631, "lon": -3.505918}
{"@timestamp": "2025-09-17T21:06:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "cache miss", "latency_ms": 91, "lat": 40.247277, "lon": -3.843406}
{"@timestamp": "2025-09-17T21:06:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 135, "lat": 40.654533, "lon": -3.686979}
{"@timestamp": "2025-09-17T21:16:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "validation error", "latency_ms": 49, "lat": 40.571024, "lon": -3.842025}
{"@timestamp": "2025-09-17T21:19:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 123, "lat": 40.254027, "lon": -3.873732}
{"@timestamp": "2025-09-17T21:23:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "consume event", "latency_ms": 117, "lat": 40.318841, "lon": -3.887823}
{"@timestamp": "2025-09-17T21:35:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 110, "lat": 40.23798, "lon": -3.840513}
{"@timestamp": "2025-09-17T22:06:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "cache miss", "latency_ms": 86, "lat": 40.393662, "lon": -3.476892}
{"@timestamp": "2025-09-17T22:10:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "request completed", "latency_ms": 116, "lat": 40.295389, "lon": -3.896478}
{"@timestamp": "2025-09-17T22:12:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 117, "lat": 40.177546, "lon": -3.532359}
{"@timestamp": "2025-09-17T22:17:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 80, "lat": 40.422042, "lon": -3.896787}
{"@timestamp": "2025-09-17T22:30:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 62, "lat": 40.543876, "lon": -3.840993}
{"@timestamp": "2025-09-17T22:35:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 84, "lat": 40.229714, "lon": -3.837463}
{"@timestamp": "2025-09-17T22:36:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 81, "lat": 40.360082, "lon": -3.827802}
{"@timestamp": "2025-09-17T22:52:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 137, "lat": 40.563351, "lon": -3.571686}
{"@timestamp": "2025-09-17T22:52:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 111, "lat": 40.325239, "lon": -3.808122}
{"@timestamp": "2025-09-17T23:05:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 141, "lat": 40.356018, "lon": -3.925179}
{"@timestamp": "2025-09-17T23:20:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 99, "lat": 40.560845, "lon": -3.788141}
{"@timestamp": "2025-09-17T23:26:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 98, "lat": 40.625498, "lon": -3.717573}
{"@timestamp": "2025-09-17T23:36:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 164, "lat": 40.265238, "lon": -3.789188}
{"@timestamp": "2025-09-17T23:41:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 114, "lat": 40.49319, "lon": -3.652649}
{"@timestamp": "2025-09-17T23:42:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 95, "lat": 40.254744, "lon": -3.561054}
{"@timestamp": "2025-09-17T23:42:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 102, "lat": 40.194016, "lon": -3.787006}
{"@timestamp": "2025-09-18T00:05:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 98, "lat": 40.543244, "lon": -3.604773}
{"@timestamp": "2025-09-18T00:06:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 77, "lat": 40.16948, "lon": -3.701529}
{"@timestamp": "2025-09-18T00:08:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 72, "lat": 40.467858, "lon": -3.547086}
{"@timestamp": "2025-09-18T00:12:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 140, "lat": 40.336074, "lon": -3.632402}
{"@timestamp": "2025-09-18T00:17:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 91, "lat": 40.560487, "lon": -3.899752}
{"@timestamp": "2025-09-18T00:22:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 96, "lat": 40.641954, "lon": -3.64466}
{"@timestamp": "2025-09-18T00:44:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "request completed", "latency_ms": 59, "lat": 40.489626, "lon": -3.713052}
{"@timestamp": "2025-09-18T00:44:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 136, "lat": 40.55363, "lon": -3.641117}
{"@timestamp": "2025-09-18T00:49:05Z", "host": "db-1", "service": "ingest", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 96, "lat": 40.641146, "lon": -3.921945}
{"@timestamp": "2025-09-18T01:46:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 98, "lat": 40.481878, "lon": -3.55829}
{"@timestamp": "2025-09-18T01:47:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 105, "lat": 40.560056, "lon": -3.51557}
{"@timestamp": "2025-09-18T01:52:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 143, "lat": 40.280869, "lon": -3.677281}
{"@timestamp": "2025-09-18T01:54:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 123, "lat": 40.204144, "lon": -3.852444}
{"@timestamp": "2025-09-18T01:59:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 104, "lat": 40.215832, "lon": -3.584926}
{"@timestamp": "2025-09-18T02:12:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 89, "lat": 40.51769, "lon": -3.527404}
{"@timestamp": "2025-09-18T02:14:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 108, "lat": 40.60696, "lon": -3.603208}
{"@timestamp": "2025-09-18T02:17:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 118, "lat": 40.645639, "lon": -3.557444}
{"@timestamp": "2025-09-18T02:43:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "validation error", "latency_ms": 97, "lat": 40.21444, "lon": -3.924424}
{"@timestamp": "2025-09-18T02:44:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 58, "lat": 40.564965, "lon": -3.65809}
{"@timestamp": "2025-09-18T02:46:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 124, "lat": 40.316207, "lon": -3.773587}
{"@timestamp": "2025-09-18T02:50:05Z", "host": "web-1", "service": "search", "level": "ERROR", "message": "cache miss", "latency_ms": 68, "lat": 40.33867, "lon": -3.612524}
{"@timestamp": "2025-09-18T02:54:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "publish event", "latency_ms": 57, "lat": 40.49139, "lon": -3.866699}
{"@timestamp": "2025-09-18T03:01:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 90, "lat": 40.409068, "lon": -3.584198}
{"@timestamp": "2025-09-18T03:10:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "login failed", "latency_ms": 93, "lat": 40.174737, "lon": -3.607877}
{"@timestamp": "2025-09-18T03:26:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 104, "lat": 40.197279, "lon": -3.47954}
{"@timestamp": "2025-09-18T03:33:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 157, "lat": 40.537426, "lon": -3.94569}
{"@timestamp": "2025-09-18T03:43:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 93, "lat": 40.245553, "lon": -3.599018}
{"@timestamp": "2025-09-18T04:34:05Z", "host": "db-1", "service": "ingest", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 160, "lat": 40.635286, "lon": -3.772301}
{"@timestamp": "2025-09-18T04:36:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 83, "lat": 40.169749, "lon": -3.593657}
{"@timestamp": "2025-09-18T04:37:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 100, "lat": 40.536708, "lon": -3.735738}
{"@timestamp": "2025-09-18T04:39:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "db query executed", "latency_ms": 130, "lat": 40.20343, "lon": -3.847223}
{"@timestamp": "2025-09-18T04:43:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 92, "lat": 40.308496, "lon": -3.58027}
{"@timestamp": "2025-09-18T04:47:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 100, "lat": 40.596051, "lon": -3.929945}
{"@timestamp": "2025-09-18T04:50:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 95, "lat": 40.566568, "lon": -3.509785}
{"@timestamp": "2025-09-18T04:51:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 129, "lat": 40.417125, "lon": -3.724807}
{"@timestamp": "2025-09-18T05:00:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "consume event", "latency_ms": 98, "lat": 40.444962, "lon": -3.490839}
{"@timestamp": "2025-09-18T05:07:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "db query executed", "latency_ms": 77, "lat": 40.392753, "lon": -3.478437}
{"@timestamp": "2025-09-18T05:20:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 86, "lat": 40.368769, "lon": -3.63186}
{"@timestamp": "2025-09-18T05:21:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "publish event", "latency_ms": 110, "lat": 40.418225, "lon": -3.52744}
{"@timestamp": "2025-09-18T05:25:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 102, "lat": 40.273854, "lon": -3.816526}
{"@timestamp": "2025-09-18T05:30:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 52, "lat": 40.38614, "lon": -3.527328}
{"@timestamp": "2025-09-18T05:32:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "consume event", "latency_ms": 54, "lat": 40.498108, "lon": -3.931432}
{"@timestamp": "2025-09-18T05:40:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 107, "lat": 40.432938, "lon": -3.567406}
{"@timestamp": "2025-09-18T05:41:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 129, "lat": 40.457315, "lon": -3.611776}
{"@timestamp": "2025-09-18T05:44:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 95, "lat": 40.180746, "lon": -3.555501}
{"@timestamp": "2025-09-18T05:54:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 122, "lat": 40.503784, "lon": -3.817749}
{"@timestamp": "2025-09-18T06:04:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 138, "lat": 40.276364, "lon": -3.887016}
{"@timestamp": "2025-09-18T06:14:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 129, "lat": 40.238661, "lon": -3.50595}
{"@timestamp": "2025-09-18T06:37:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 126, "lat": 40.367192, "lon": -3.882863}
{"@timestamp": "2025-09-18T06:52:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 36, "lat": 40.389786, "lon": -3.907559}
{"@timestamp": "2025-09-18T07:17:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 84, "lat": 40.34125, "lon": -3.667721}
{"@timestamp": "2025-09-18T07:18:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 72, "lat": 40.352751, "lon": -3.809727}
{"@timestamp": "2025-09-18T07:18:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 94, "lat": 40.601819, "lon": -3.77752}
{"@timestamp": "2025-09-18T07:26:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "cache miss", "latency_ms": 126, "lat": 40.442076, "lon": -3.886635}
{"@timestamp": "2025-09-18T07:44:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 91, "lat": 40.495684, "lon": -3.742563}
{"@timestamp": "2025-09-18T07:45:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 141, "lat": 40.65501, "lon": -3.72192}
{"@timestamp": "2025-09-18T07:55:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 128, "lat": 40.651, "lon": -3.755678}
{"@timestamp": "2025-09-18T08:00:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "db query executed", "latency_ms": 117, "lat": 40.359466, "lon": -3.85724}
{"@timestamp": "2025-09-18T08:04:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "request completed", "latency_ms": 91, "lat": 40.666431, "lon": -3.774407}
{"@timestamp": "2025-09-18T08:30:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 94, "lat": 40.393572, "lon": -3.609493}
{"@timestamp": "2025-09-18T08:45:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 82, "lat": 40.429498, "lon": -3.475306}
{"@timestamp": "2025-09-18T08:47:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 51, "lat": 40.173249, "lon": -3.694715}
{"@timestamp": "2025-09-18T09:01:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "cache miss", "latency_ms": 98, "lat": 40.393602, "lon": -3.766227}
{"@timestamp": "2025-09-18T09:16:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "db query executed", "latency_ms": 103, "lat": 40.199263, "lon": -3.718392}
{"@timestamp": "2025-09-18T09:17:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "consume event", "latency_ms": 53, "lat": 40.316695, "lon": -3.545926}
{"@timestamp": "2025-09-18T09:18:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "login succeeded", "latency_ms": 109, "lat": 40.408404, "lon": -3.835197}
{"@timestamp": "2025-09-18T09:31:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 160, "lat": 40.564412, "lon": -3.861355}
{"@timestamp": "2025-09-18T09:36:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 44, "lat": 40.237487, "lon": -3.932913}
{"@timestamp": "2025-09-18T09:37:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 90, "lat": 40.365248, "lon": -3.533895}
{"@timestamp": "2025-09-18T09:43:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "login failed", "latency_ms": 61, "lat": 40.634043, "lon": -3.592968}
{"@timestamp": "2025-09-18T10:32:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 87, "lat": 40.530286, "lon": -3.671947}
{"@timestamp": "2025-09-18T11:16:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 127, "lat": 40.577719, "lon": -3.582545}
{"@timestamp": "2025-09-18T11:39:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 58, "lat": 40.521976, "lon": -3.573412}
{"@timestamp": "2025-09-18T11:41:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 138, "lat": 40.540469, "lon": -3.846807}
{"@timestamp": "2025-09-18T11:57:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 99, "lat": 40.356904, "lon": -3.601964}
{"@timestamp": "2025-09-18T12:00:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 90, "lat": 40.303451, "lon": -3.828356}
{"@timestamp": "2025-09-18T12:11:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 122, "lat": 40.516667, "lon": -3.482462}
{"@timestamp": "2025-09-18T12:24:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "login failed", "latency_ms": 104, "lat": 40.644104, "lon": -3.551492}
{"@timestamp": "2025-09-18T12:27:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 111, "lat": 40.639418, "lon": -3.459974}
{"@timestamp": "2025-09-18T12:33:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 87, "lat": 40.536143, "lon": -3.528633}
{"@timestamp": "2025-09-18T12:34:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 97, "lat": 40.454371, "lon": -3.642178}
{"@timestamp": "2025-09-18T12:36:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 70, "lat": 40.643916, "lon": -3.584339}
{"@timestamp": "2025-09-18T12:55:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 130, "lat": 40.473367, "lon": -3.926527}
{"@timestamp": "2025-09-18T13:11:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 123, "lat": 40.321534, "lon": -3.549488}
{"@timestamp": "2025-09-18T13:12:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "validation error", "latency_ms": 102, "lat": 40.538762, "lon": -3.503301}
{"@timestamp": "2025-09-18T13:16:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 147, "lat": 40.603951, "lon": -3.910001}
{"@timestamp": "2025-09-18T13:19:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "cache miss", "latency_ms": 125, "lat": 40.316967, "lon": -3.842857}
{"@timestamp": "2025-09-18T13:38:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 121, "lat": 40.322489, "lon": -3.507678}
{"@timestamp": "2025-09-18T13:43:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 101, "lat": 40.654864, "lon": -3.836057}
{"@timestamp": "2025-09-18T13:58:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 118, "lat": 40.260724, "lon": -3.882039}
{"@timestamp": "2025-09-18T13:59:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "db query executed", "latency_ms": 114, "lat": 40.640055, "lon": -3.759018}
{"@timestamp": "2025-09-18T14:13:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 107, "lat": 40.65686, "lon": -3.470152}
{"@timestamp": "2025-09-18T14:17:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "login failed", "latency_ms": 123, "lat": 40.550221, "lon": -3.453997}
{"@timestamp": "2025-09-18T14:22:05Z", "host": "app-2", "service": "auth", "level": "WARN", "message": "publish event", "latency_ms": 55, "lat": 40.276727, "lon": -3.806219}
{"@timestamp": "2025-09-18T14:31:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 111, "lat": 40.474243, "lon": -3.870083}
{"@timestamp": "2025-09-18T14:34:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 83, "lat": 40.490439, "lon": -3.704354}
{"@timestamp": "2025-09-18T14:37:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 66, "lat": 40.636308, "lon": -3.662169}
{"@timestamp": "2025-09-18T14:41:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "db query executed", "latency_ms": 101, "lat": 40.498668, "lon": -3.619441}
{"@timestamp": "2025-09-18T15:08:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 102, "lat": 40.615053, "lon": -3.796848}
{"@timestamp": "2025-09-18T15:15:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 125, "lat": 40.594369, "lon": -3.563399}
{"@timestamp": "2025-09-18T15:17:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "login succeeded", "latency_ms": 104, "lat": 40.600024, "lon": -3.887898}
{"@timestamp": "2025-09-18T15:23:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 103, "lat": 40.425447, "lon": -3.833649}
{"@timestamp": "2025-09-18T15:25:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 86, "lat": 40.405749, "lon": -3.617398}
{"@timestamp": "2025-09-18T15:26:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 84, "lat": 40.537415, "lon": -3.67796}
{"@timestamp": "2025-09-18T15:31:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 142, "lat": 40.557166, "lon": -3.815156}
{"@timestamp": "2025-09-18T15:33:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 73, "lat": 40.209606, "lon": -3.593763}
{"@timestamp": "2025-09-18T15:36:05Z", "host": "db-1", "service": "auth", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 108, "lat": 40.558538, "lon": -3.716165}
{"@timestamp": "2025-09-18T15:38:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 60, "lat": 40.232043, "lon": -3.582506}
{"@timestamp": "2025-09-18T15:47:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 127, "lat": 40.570583, "lon": -3.690872}
{"@timestamp": "2025-09-18T15:48:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 99, "lat": 40.505398, "lon": -3.541645}
{"@timestamp": "2025-09-18T16:02:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "publish event", "latency_ms": 132, "lat": 40.55467, "lon": -3.838741}
{"@timestamp": "2025-09-18T16:10:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 98, "lat": 40.352722, "lon": -3.5019}
{"@timestamp": "2025-09-18T16:14:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 120, "lat": 40.472791, "lon": -3.820369}
{"@timestamp": "2025-09-18T16:14:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 125, "lat": 40.54773, "lon": -3.893185}
{"@timestamp": "2025-09-18T16:45:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 111, "lat": 40.311598, "lon": -3.635354}
{"@timestamp": "2025-09-18T16:55:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 95, "lat": 40.278393, "lon": -3.695913}
{"@timestamp": "2025-09-18T17:18:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 162, "lat": 40.659614, "lon": -3.520235}
{"@timestamp": "2025-09-18T17:24:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 67, "lat": 40.305878, "lon": -3.455327}
{"@timestamp": "2025-09-18T17:39:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 82, "lat": 40.322275, "lon": -3.532377}
{"@timestamp": "2025-09-18T17:57:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 118, "lat": 40.557287, "lon": -3.484415}
{"@timestamp": "2025-09-18T17:57:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 120, "lat": 40.422571, "lon": -3.535558}
{"@timestamp": "2025-09-18T18:00:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 115, "lat": 40.396299, "lon": -3.832196}
{"@timestamp": "2025-09-18T18:02:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 121, "lat": 40.408971, "lon": -3.78758}
{"@timestamp": "2025-09-18T18:05:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 115, "lat": 40.661562, "lon": -3.6338}
{"@timestamp": "2025-09-18T18:05:05Z", "host": "web-1", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 98, "lat": 40.297577, "lon": -3.774024}
{"@timestamp": "2025-09-18T18:14:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "request completed", "latency_ms": 29, "lat": 40.41214, "lon": -3.735771}
{"@timestamp": "2025-09-18T18:34:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 88, "lat": 40.583672, "lon": -3.60203}
{"@timestamp": "2025-09-18T18:48:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 123, "lat": 40.306303, "lon": -3.80455}
{"@timestamp": "2025-09-18T18:52:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "publish event", "latency_ms": 41, "lat": 40.185533, "lon": -3.816093}
{"@timestamp": "2025-09-18T18:54:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 120, "lat": 40.212949, "lon": -3.742012}
{"@timestamp": "2025-09-18T19:04:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "db query executed", "latency_ms": 117, "lat": 40.486275, "lon": -3.649315}
{"@timestamp": "2025-09-18T19:07:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 50, "lat": 40.482613, "lon": -3.547479}
{"@timestamp": "2025-09-18T19:11:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 141, "lat": 40.549069, "lon": -3.498823}
{"@timestamp": "2025-09-18T19:24:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 103, "lat": 40.504218, "lon": -3.718062}
{"@timestamp": "2025-09-18T19:31:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "login succeeded", "latency_ms": 62, "lat": 40.266889, "lon": -3.885936}
{"@timestamp": "2025-09-18T19:34:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 71, "lat": 40.568208, "lon": -3.592593}
{"@timestamp": "2025-09-18T19:46:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 110, "lat": 40.38211, "lon": -3.645019}
{"@timestamp": "2025-09-18T19:49:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 124, "lat": 40.363547, "lon": -3.76514}
{"@timestamp": "2025-09-18T19:50:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "db query executed", "latency_ms": 74, "lat": 40.402068, "lon": -3.520603}
{"@timestamp": "2025-09-18T20:03:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 86, "lat": 40.428458, "lon": -3.574653}
{"@timestamp": "2025-09-18T20:32:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 114, "lat": 40.393442, "lon": -3.938668}
{"@timestamp": "2025-09-18T20:38:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "login succeeded", "latency_ms": 104, "lat": 40.363223, "lon": -3.88517}
{"@timestamp": "2025-09-18T21:01:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "validation error", "latency_ms": 119, "lat": 40.451332, "lon": -3.845081}
{"@timestamp": "2025-09-18T21:13:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 115, "lat": 40.624745, "lon": -3.638124}
{"@timestamp": "2025-09-18T21:20:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 127, "lat": 40.168084, "lon": -3.524455}
{"@timestamp": "2025-09-18T21:37:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "validation error", "latency_ms": 91, "lat": 40.166898, "lon": -3.936469}
{"@timestamp": "2025-09-18T21:59:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 141, "lat": 40.663957, "lon": -3.723167}
{"@timestamp": "2025-09-18T22:02:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 89, "lat": 40.384863, "lon": -3.71239}
{"@timestamp": "2025-09-18T22:06:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 169, "lat": 40.278911, "lon": -3.919491}
{"@timestamp": "2025-09-18T22:06:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 123, "lat": 40.222564, "lon": -3.619326}
{"@timestamp": "2025-09-18T22:57:05Z", "host": "db-1", "service": "auth", "level": "WARN", "message": "login failed", "latency_ms": 120, "lat": 40.406642, "lon": -3.563082}
{"@timestamp": "2025-09-18T22:58:05Z", "host": "db-1", "service": "ingest", "level": "WARN", "message": "cache miss", "latency_ms": 115, "lat": 40.38628, "lon": -3.776799}
{"@timestamp": "2025-09-18T23:03:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 128, "lat": 40.319858, "lon": -3.921156}
{"@timestamp": "2025-09-18T23:04:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "consume event", "latency_ms": 112, "lat": 40.374392, "lon": -3.901043}
{"@timestamp": "2025-09-18T23:23:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "db query executed", "latency_ms": 123, "lat": 40.621995, "lon": -3.92105}
{"@timestamp": "2025-09-18T23:24:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 130, "lat": 40.341088, "lon": -3.545436}
{"@timestamp": "2025-09-18T23:25:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "publish event", "latency_ms": 73, "lat": 40.430887, "lon": -3.772908}
{"@timestamp": "2025-09-18T23:27:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 151, "lat": 40.517372, "lon": -3.702633}
{"@timestamp": "2025-09-18T23:38:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 79, "lat": 40.612711, "lon": -3.657914}
{"@timestamp": "2025-09-18T23:39:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 124, "lat": 40.234545, "lon": -3.950416}
{"@timestamp": "2025-09-19T00:07:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 122, "lat": 40.31835, "lon": -3.665589}
{"@timestamp": "2025-09-19T00:27:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "cache miss", "latency_ms": 123, "lat": 40.612199, "lon": -3.880367}
{"@timestamp": "2025-09-19T00:33:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 101, "lat": 40.432261, "lon": -3.741048}
{"@timestamp": "2025-09-19T00:42:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "cache miss", "latency_ms": 128, "lat": 40.23622, "lon": -3.803234}
{"@timestamp": "2025-09-19T00:47:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 121, "lat": 40.403002, "lon": -3.613204}
{"@timestamp": "2025-09-19T01:27:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "request completed", "latency_ms": 121, "lat": 40.631595, "lon": -3.549627}
{"@timestamp": "2025-09-19T01:40:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "login succeeded", "latency_ms": 102, "lat": 40.613313, "lon": -3.913511}
{"@timestamp": "2025-09-19T01:50:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 130, "lat": 40.194314, "lon": -3.62076}
{"@timestamp": "2025-09-19T01:52:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 101, "lat": 40.39888, "lon": -3.673887}
{"@timestamp": "2025-09-19T01:52:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 78, "lat": 40.649277, "lon": -3.547911}
{"@timestamp": "2025-09-19T01:53:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 118, "lat": 40.434827, "lon": -3.637823}
{"@timestamp": "2025-09-19T02:21:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 127, "lat": 40.456267, "lon": -3.911033}
{"@timestamp": "2025-09-19T02:21:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 93, "lat": 40.185733, "lon": -3.712166}
{"@timestamp": "2025-09-19T02:27:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 106, "lat": 40.196118, "lon": -3.764313}
{"@timestamp": "2025-09-19T02:28:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 124, "lat": 40.628353, "lon": -3.509899}
{"@timestamp": "2025-09-19T02:51:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 122, "lat": 40.404368, "lon": -3.528931}
{"@timestamp": "2025-09-19T03:10:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "db query executed", "latency_ms": 100, "lat": 40.559407, "lon": -3.801494}
{"@timestamp": "2025-09-19T03:44:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 107, "lat": 40.286428, "lon": -3.953656}
{"@timestamp": "2025-09-19T03:48:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 129, "lat": 40.192628, "lon": -3.898773}
{"@timestamp": "2025-09-19T03:52:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 88, "lat": 40.19184, "lon": -3.547211}
{"@timestamp": "2025-09-19T04:17:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 88, "lat": 40.529312, "lon": -3.897378}
{"@timestamp": "2025-09-19T04:52:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 102, "lat": 40.388639, "lon": -3.606799}
{"@timestamp": "2025-09-19T05:12:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "validation error", "latency_ms": 79, "lat": 40.370367, "lon": -3.900568}
{"@timestamp": "2025-09-19T05:13:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 123, "lat": 40.209654, "lon": -3.781904}
{"@timestamp": "2025-09-19T05:14:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "login succeeded", "latency_ms": 130, "lat": 40.181277, "lon": -3.817165}
{"@timestamp": "2025-09-19T05:19:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 75, "lat": 40.404803, "lon": -3.635426}
{"@timestamp": "2025-09-19T05:21:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 108, "lat": 40.455769, "lon": -3.530398}
{"@timestamp": "2025-09-19T05:27:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "request completed", "latency_ms": 118, "lat": 40.447993, "lon": -3.469907}
{"@timestamp": "2025-09-19T05:38:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 74, "lat": 40.415988, "lon": -3.595498}
{"@timestamp": "2025-09-19T05:44:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 156, "lat": 40.251292, "lon": -3.770504}
{"@timestamp": "2025-09-19T06:18:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "login failed", "latency_ms": 131, "lat": 40.509943, "lon": -3.485013}
{"@timestamp": "2025-09-19T06:30:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "login succeeded", "latency_ms": 109, "lat": 40.395821, "lon": -3.471787}
{"@timestamp": "2025-09-19T06:37:05Z", "host": "app-2", "service": "auth", "level": "WARN", "message": "publish event", "latency_ms": 112, "lat": 40.232416, "lon": -3.94511}
{"@timestamp": "2025-09-19T06:49:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "login failed", "latency_ms": 95, "lat": 40.582889, "lon": -3.829671}
{"@timestamp": "2025-09-19T07:05:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 88, "lat": 40.25485, "lon": -3.65754}
{"@timestamp": "2025-09-19T07:34:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 76, "lat": 40.474586, "lon": -3.73022}
{"@timestamp": "2025-09-19T07:37:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "publish event", "latency_ms": 119, "lat": 40.195548, "lon": -3.950854}
{"@timestamp": "2025-09-19T07:58:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 100, "lat": 40.353908, "lon": -3.935102}
{"@timestamp": "2025-09-19T08:00:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 95, "lat": 40.441724, "lon": -3.823463}
{"@timestamp": "2025-09-19T08:15:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 110, "lat": 40.307478, "lon": -3.655041}
{"@timestamp": "2025-09-19T08:30:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 117, "lat": 40.314696, "lon": -3.55974}
{"@timestamp": "2025-09-19T08:47:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 105, "lat": 40.661739, "lon": -3.772391}
{"@timestamp": "2025-09-19T08:54:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 77, "lat": 40.224243, "lon": -3.814516}
{"@timestamp": "2025-09-19T09:08:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "publish event", "latency_ms": 131, "lat": 40.478321, "lon": -3.457649}
{"@timestamp": "2025-09-19T09:12:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 107, "lat": 40.631302, "lon": -3.79055}
{"@timestamp": "2025-09-19T09:19:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 66, "lat": 40.444511, "lon": -3.532136}
{"@timestamp": "2025-09-19T09:22:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 68, "lat": 40.253707, "lon": -3.916268}
{"@timestamp": "2025-09-19T09:25:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 146, "lat": 40.303307, "lon": -3.622661}
{"@timestamp": "2025-09-19T09:26:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 54, "lat": 40.654912, "lon": -3.566197}
{"@timestamp": "2025-09-19T09:27:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 82, "lat": 40.441082, "lon": -3.83523}
{"@timestamp": "2025-09-19T09:29:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 72, "lat": 40.530498, "lon": -3.804249}
{"@timestamp": "2025-09-19T09:36:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 80, "lat": 40.403393, "lon": -3.50321}
{"@timestamp": "2025-09-19T09:41:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "consume event", "latency_ms": 102, "lat": 40.397501, "lon": -3.557843}
{"@timestamp": "2025-09-19T09:43:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 84, "lat": 40.529779, "lon": -3.665959}
{"@timestamp": "2025-09-19T09:45:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 92, "lat": 40.318216, "lon": -3.827459}
{"@timestamp": "2025-09-19T10:10:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 113, "lat": 40.651087, "lon": -3.716594}
{"@timestamp": "2025-09-19T10:18:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "login succeeded", "latency_ms": 108, "lat": 40.593041, "lon": -3.90859}
{"@timestamp": "2025-09-19T10:22:05Z", "host": "db-1", "service": "auth", "level": "WARN", "message": "request completed", "latency_ms": 141, "lat": 40.541668, "lon": -3.763222}
{"@timestamp": "2025-09-19T10:23:05Z", "host": "db-1", "service": "ingest", "level": "WARN", "message": "request completed", "latency_ms": 80, "lat": 40.485552, "lon": -3.948151}
{"@timestamp": "2025-09-19T10:32:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 78, "lat": 40.625751, "lon": -3.513024}
{"@timestamp": "2025-09-19T10:32:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 151, "lat": 40.5079, "lon": -3.716751}
{"@timestamp": "2025-09-19T10:32:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 100, "lat": 40.244798, "lon": -3.900455}
{"@timestamp": "2025-09-19T10:34:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "login failed", "latency_ms": 68, "lat": 40.43294, "lon": -3.655371}
{"@timestamp": "2025-09-19T10:48:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "db query executed", "latency_ms": 111, "lat": 40.349697, "lon": -3.855263}
{"@timestamp": "2025-09-19T10:50:05Z", "host": "web-1", "service": "search", "level": "ERROR", "message": "login succeeded", "latency_ms": 107, "lat": 40.626051, "lon": -3.485462}
{"@timestamp": "2025-09-19T11:09:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "login failed", "latency_ms": 104, "lat": 40.433625, "lon": -3.77417}
{"@timestamp": "2025-09-19T11:45:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "cache miss", "latency_ms": 132, "lat": 40.381832, "lon": -3.499299}
{"@timestamp": "2025-09-19T11:48:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 119, "lat": 40.243839, "lon": -3.783742}
{"@timestamp": "2025-09-19T11:54:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 113, "lat": 40.212493, "lon": -3.742959}
{"@timestamp": "2025-09-19T12:00:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 85, "lat": 40.387488, "lon": -3.701154}
{"@timestamp": "2025-09-19T12:03:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 133, "lat": 40.316942, "lon": -3.678803}
{"@timestamp": "2025-09-19T12:12:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 154, "lat": 40.221015, "lon": -3.683484}
{"@timestamp": "2025-09-19T12:23:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 73, "lat": 40.459346, "lon": -3.92663}
{"@timestamp": "2025-09-19T12:31:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 29, "lat": 40.365912, "lon": -3.546097}
{"@timestamp": "2025-09-19T12:38:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 115, "lat": 40.33332, "lon": -3.716928}
{"@timestamp": "2025-09-19T12:53:05Z", "host": "db-1", "service": "auth", "level": "WARN", "message": "cache miss", "latency_ms": 145, "lat": 40.5161, "lon": -3.905169}
{"@timestamp": "2025-09-19T13:11:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 98, "lat": 40.478378, "lon": -3.622106}
{"@timestamp": "2025-09-19T13:18:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 106, "lat": 40.262121, "lon": -3.651783}
{"@timestamp": "2025-09-19T13:27:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 96, "lat": 40.509169, "lon": -3.665791}
{"@timestamp": "2025-09-19T13:38:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 97, "lat": 40.261478, "lon": -3.715937}
{"@timestamp": "2025-09-19T13:43:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 107, "lat": 40.503331, "lon": -3.679427}
{"@timestamp": "2025-09-19T14:07:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "login succeeded", "latency_ms": 102, "lat": 40.344496, "lon": -3.7131}
{"@timestamp": "2025-09-19T14:08:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 100, "lat": 40.47953, "lon": -3.894837}
{"@timestamp": "2025-09-19T14:09:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 107, "lat": 40.423723, "lon": -3.765201}
{"@timestamp": "2025-09-19T14:15:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "consume event", "latency_ms": 95, "lat": 40.330763, "lon": -3.753383}
{"@timestamp": "2025-09-19T14:15:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 145, "lat": 40.650245, "lon": -3.814238}
{"@timestamp": "2025-09-19T14:25:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 86, "lat": 40.207774, "lon": -3.922703}
{"@timestamp": "2025-09-19T14:36:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 112, "lat": 40.313363, "lon": -3.764936}
{"@timestamp": "2025-09-19T14:53:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 110, "lat": 40.49167, "lon": -3.735906}
{"@timestamp": "2025-09-19T15:10:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 77, "lat": 40.487652, "lon": -3.655227}
{"@timestamp": "2025-09-19T15:12:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 33, "lat": 40.289075, "lon": -3.930702}
{"@timestamp": "2025-09-19T15:13:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "login failed", "latency_ms": 31, "lat": 40.636942, "lon": -3.468554}
{"@timestamp": "2025-09-19T15:14:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 114, "lat": 40.27369, "lon": -3.775512}
{"@timestamp": "2025-09-19T15:22:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 105, "lat": 40.489136, "lon": -3.747954}
{"@timestamp": "2025-09-19T15:29:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 85, "lat": 40.416591, "lon": -3.656835}
{"@timestamp": "2025-09-19T15:30:05Z", "host": "web-2", "service": "ingest", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 125, "lat": 40.361662, "lon": -3.764621}
{"@timestamp": "2025-09-19T15:57:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "db query executed", "latency_ms": 83, "lat": 40.331912, "lon": -3.897131}
{"@timestamp": "2025-09-19T15:59:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 98, "lat": 40.37905, "lon": -3.738496}
{"@timestamp": "2025-09-19T16:28:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "publish event", "latency_ms": 147, "lat": 40.638478, "lon": -3.863597}
{"@timestamp": "2025-09-19T16:44:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 96, "lat": 40.631114, "lon": -3.697402}
{"@timestamp": "2025-09-19T16:44:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "request completed", "latency_ms": 106, "lat": 40.575798, "lon": -3.929543}
{"@timestamp": "2025-09-19T17:00:05Z", "host": "web-1", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 85, "lat": 40.358655, "lon": -3.860923}
{"@timestamp": "2025-09-19T17:13:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 88, "lat": 40.225259, "lon": -3.456913}
{"@timestamp": "2025-09-19T17:14:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 94, "lat": 40.605178, "lon": -3.804976}
{"@timestamp": "2025-09-19T17:31:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 105, "lat": 40.661999, "lon": -3.489251}
{"@timestamp": "2025-09-19T17:37:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 139, "lat": 40.577662, "lon": -3.534993}
{"@timestamp": "2025-09-19T17:37:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "request completed", "latency_ms": 61, "lat": 40.285565, "lon": -3.731701}
{"@timestamp": "2025-09-19T17:43:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 112, "lat": 40.206834, "lon": -3.62334}
{"@timestamp": "2025-09-19T17:49:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 124, "lat": 40.476655, "lon": -3.833385}
{"@timestamp": "2025-09-19T17:52:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 60, "lat": 40.172781, "lon": -3.904951}
{"@timestamp": "2025-09-19T18:23:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 126, "lat": 40.392363, "lon": -3.751576}
{"@timestamp": "2025-09-19T18:32:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 100, "lat": 40.460105, "lon": -3.495188}
{"@timestamp": "2025-09-19T18:36:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "validation error", "latency_ms": 121, "lat": 40.172405, "lon": -3.817174}
{"@timestamp": "2025-09-19T18:42:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 76, "lat": 40.36134, "lon": -3.571794}
{"@timestamp": "2025-09-19T18:51:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 56, "lat": 40.309332, "lon": -3.736464}
{"@timestamp": "2025-09-19T19:02:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 127, "lat": 40.248716, "lon": -3.477292}
{"@timestamp": "2025-09-19T19:08:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 117, "lat": 40.436617, "lon": -3.629281}
{"@timestamp": "2025-09-19T19:10:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 124, "lat": 40.637593, "lon": -3.618129}
{"@timestamp": "2025-09-19T19:16:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "publish event", "latency_ms": 105, "lat": 40.324626, "lon": -3.949591}
{"@timestamp": "2025-09-19T19:27:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 124, "lat": 40.562833, "lon": -3.835432}
{"@timestamp": "2025-09-19T19:34:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 142, "lat": 40.322531, "lon": -3.592963}
{"@timestamp": "2025-09-19T19:34:05Z", "host": "app-2", "service": "auth", "level": "WARN", "message": "login failed", "latency_ms": 76, "lat": 40.418855, "lon": -3.761469}
{"@timestamp": "2025-09-19T19:35:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 94, "lat": 40.361393, "lon": -3.724412}
{"@timestamp": "2025-09-19T20:04:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "cache miss", "latency_ms": 90, "lat": 40.661598, "lon": -3.889231}
{"@timestamp": "2025-09-19T20:12:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "login failed", "latency_ms": 116, "lat": 40.449728, "lon": -3.52482}
{"@timestamp": "2025-09-19T20:39:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "login failed", "latency_ms": 107, "lat": 40.213494, "lon": -3.4778}
{"@timestamp": "2025-09-19T20:55:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 117, "lat": 40.368945, "lon": -3.837365}
{"@timestamp": "2025-09-19T21:00:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 30, "lat": 40.553672, "lon": -3.74488}
{"@timestamp": "2025-09-19T21:01:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 134, "lat": 40.616878, "lon": -3.54621}
{"@timestamp": "2025-09-19T21:02:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 30, "lat": 40.429808, "lon": -3.668406}
{"@timestamp": "2025-09-19T21:06:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 107, "lat": 40.216784, "lon": -3.530117}
{"@timestamp": "2025-09-19T21:12:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "db query executed", "latency_ms": 103, "lat": 40.221085, "lon": -3.852626}
{"@timestamp": "2025-09-19T21:23:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "db query executed", "latency_ms": 96, "lat": 40.574612, "lon": -3.79246}
{"@timestamp": "2025-09-19T21:34:05Z", "host": "web-1", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 126, "lat": 40.466479, "lon": -3.671998}
{"@timestamp": "2025-09-19T21:42:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "cache miss", "latency_ms": 50, "lat": 40.256373, "lon": -3.479444}
{"@timestamp": "2025-09-19T21:48:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 88, "lat": 40.214392, "lon": -3.847089}
{"@timestamp": "2025-09-19T21:50:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 88, "lat": 40.420265, "lon": -3.678552}
{"@timestamp": "2025-09-19T21:56:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 126, "lat": 40.56591, "lon": -3.927189}
{"@timestamp": "2025-09-19T22:00:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 111, "lat": 40.242049, "lon": -3.851672}
{"@timestamp": "2025-09-19T22:07:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "request completed", "latency_ms": 77, "lat": 40.618056, "lon": -3.924895}
{"@timestamp": "2025-09-19T22:24:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "login succeeded", "latency_ms": 68, "lat": 40.505063, "lon": -3.4837}
{"@timestamp": "2025-09-19T22:44:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 105, "lat": 40.48739, "lon": -3.516742}
{"@timestamp": "2025-09-19T23:03:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 135, "lat": 40.512097, "lon": -3.80623}
{"@timestamp": "2025-09-19T23:13:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 66, "lat": 40.56671, "lon": -3.59664}
{"@timestamp": "2025-09-19T23:18:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "publish event", "latency_ms": 110, "lat": 40.556058, "lon": -3.770636}
{"@timestamp": "2025-09-19T23:24:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 48, "lat": 40.53533, "lon": -3.571775}
{"@timestamp": "2025-09-19T23:24:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 139, "lat": 40.274457, "lon": -3.572053}
{"@timestamp": "2025-09-19T23:28:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "publish event", "latency_ms": 114, "lat": 40.25743, "lon": -3.763925}
{"@timestamp": "2025-09-19T23:31:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 60, "lat": 40.545657, "lon": -3.758268}
{"@timestamp": "2025-09-19T23:34:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 111, "lat": 40.382374, "lon": -3.463697}
{"@timestamp": "2025-09-19T23:48:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 116, "lat": 40.441841, "lon": -3.455375}
{"@timestamp": "2025-09-19T23:50:05Z", "host": "web-2", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 111, "lat": 40.323091, "lon": -3.594619}
{"@timestamp": "2025-09-20T00:00:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "login failed", "latency_ms": 85, "lat": 40.266955, "lon": -3.946117}
{"@timestamp": "2025-09-20T00:00:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 62, "lat": 40.284402, "lon": -3.893857}
{"@timestamp": "2025-09-20T00:11:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "consume event", "latency_ms": 124, "lat": 40.594302, "lon": -3.910563}
{"@timestamp": "2025-09-20T00:18:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 116, "lat": 40.314289, "lon": -3.636777}
{"@timestamp": "2025-09-20T00:32:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 145, "lat": 40.65405, "lon": -3.600049}
{"@timestamp": "2025-09-20T00:39:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 128, "lat": 40.385478, "lon": -3.500196}
{"@timestamp": "2025-09-20T00:45:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "login failed", "latency_ms": 113, "lat": 40.611613, "lon": -3.828872}
{"@timestamp": "2025-09-20T00:53:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 79, "lat": 40.180386, "lon": -3.924549}
{"@timestamp": "2025-09-20T00:54:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 85, "lat": 40.66215, "lon": -3.714183}
{"@timestamp": "2025-09-20T00:54:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "validation error", "latency_ms": 119, "lat": 40.534745, "lon": -3.49295}
{"@timestamp": "2025-09-20T00:56:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "db query executed", "latency_ms": 101, "lat": 40.493706, "lon": -3.507457}
{"@timestamp": "2025-09-20T01:10:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 143, "lat": 40.567797, "lon": -3.540998}
{"@timestamp": "2025-09-20T01:11:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 76, "lat": 40.301789, "lon": -3.650983}
{"@timestamp": "2025-09-20T01:13:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "login succeeded", "latency_ms": 147, "lat": 40.474756, "lon": -3.493991}
{"@timestamp": "2025-09-20T01:15:05Z", "host": "web-1", "service": "checkout", "level": "ERROR", "message": "consume event", "latency_ms": 81, "lat": 40.626047, "lon": -3.654328}
{"@timestamp": "2025-09-20T01:27:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 53, "lat": 40.649477, "lon": -3.787803}
{"@timestamp": "2025-09-20T01:43:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 101, "lat": 40.558064, "lon": -3.835702}
{"@timestamp": "2025-09-20T01:48:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 127, "lat": 40.198914, "lon": -3.75}
{"@timestamp": "2025-09-20T01:51:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 147, "lat": 40.376922, "lon": -3.560937}
{"@timestamp": "2025-09-20T02:00:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 134, "lat": 40.376591, "lon": -3.799041}
{"@timestamp": "2025-09-20T02:08:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 113, "lat": 40.606868, "lon": -3.514853}
{"@timestamp": "2025-09-20T02:09:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 52, "lat": 40.65232, "lon": -3.57738}
{"@timestamp": "2025-09-20T02:09:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 1, "lat": 40.591495, "lon": -3.695297}
{"@timestamp": "2025-09-20T02:17:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 109, "lat": 40.320929, "lon": -3.504309}
{"@timestamp": "2025-09-20T02:18:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 112, "lat": 40.541279, "lon": -3.669196}
{"@timestamp": "2025-09-20T02:19:05Z", "host": "db-1", "service": "auth", "level": "WARN", "message": "request completed", "latency_ms": 132, "lat": 40.551103, "lon": -3.93699}
{"@timestamp": "2025-09-20T02:24:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 64, "lat": 40.401924, "lon": -3.872023}
{"@timestamp": "2025-09-20T02:24:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "login succeeded", "latency_ms": 163, "lat": 40.233741, "lon": -3.703238}
{"@timestamp": "2025-09-20T02:37:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 132, "lat": 40.442827, "lon": -3.525488}
{"@timestamp": "2025-09-20T02:39:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 49, "lat": 40.622369, "lon": -3.636836}
{"@timestamp": "2025-09-20T02:40:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 88, "lat": 40.332738, "lon": -3.583794}
{"@timestamp": "2025-09-20T02:41:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 166, "lat": 40.256616, "lon": -3.927564}
{"@timestamp": "2025-09-20T03:03:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "publish event", "latency_ms": 126, "lat": 40.480706, "lon": -3.766214}
{"@timestamp": "2025-09-20T03:04:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 101, "lat": 40.298979, "lon": -3.836791}
{"@timestamp": "2025-09-20T03:15:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "validation error", "latency_ms": 74, "lat": 40.318474, "lon": -3.580995}
{"@timestamp": "2025-09-20T03:18:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 129, "lat": 40.255924, "lon": -3.617755}
{"@timestamp": "2025-09-20T03:21:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 31, "lat": 40.225994, "lon": -3.795001}
{"@timestamp": "2025-09-20T03:37:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 64, "lat": 40.591521, "lon": -3.615283}
{"@timestamp": "2025-09-20T03:43:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 120, "lat": 40.28559, "lon": -3.580925}
{"@timestamp": "2025-09-20T03:53:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 146, "lat": 40.263114, "lon": -3.767729}
{"@timestamp": "2025-09-20T03:59:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 134, "lat": 40.436289, "lon": -3.580293}
{"@timestamp": "2025-09-20T04:11:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "login succeeded", "latency_ms": 98, "lat": 40.611329, "lon": -3.846009}
{"@timestamp": "2025-09-20T04:16:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 115, "lat": 40.380368, "lon": -3.880112}
{"@timestamp": "2025-09-20T04:18:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 119, "lat": 40.558935, "lon": -3.693243}
{"@timestamp": "2025-09-20T04:37:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 133, "lat": 40.581291, "lon": -3.478963}
{"@timestamp": "2025-09-20T04:42:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 115, "lat": 40.586048, "lon": -3.650306}
{"@timestamp": "2025-09-20T04:53:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 25, "lat": 40.318416, "lon": -3.459609}
{"@timestamp": "2025-09-20T05:04:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "login succeeded", "latency_ms": 147, "lat": 40.291069, "lon": -3.727841}
{"@timestamp": "2025-09-20T05:06:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 104, "lat": 40.274627, "lon": -3.87904}
{"@timestamp": "2025-09-20T05:08:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 99, "lat": 40.480453, "lon": -3.76136}
{"@timestamp": "2025-09-20T05:12:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 86, "lat": 40.644345, "lon": -3.819645}
{"@timestamp": "2025-09-20T05:17:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "cache miss", "latency_ms": 128, "lat": 40.559841, "lon": -3.553373}
{"@timestamp": "2025-09-20T05:21:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 94, "lat": 40.665221, "lon": -3.480892}
{"@timestamp": "2025-09-20T05:26:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 71, "lat": 40.371095, "lon": -3.469392}
{"@timestamp": "2025-09-20T05:27:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "publish event", "latency_ms": 115, "lat": 40.405524, "lon": -3.854072}
{"@timestamp": "2025-09-20T05:32:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "db query executed", "latency_ms": 62, "lat": 40.308153, "lon": -3.56142}
{"@timestamp": "2025-09-20T05:39:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 127, "lat": 40.232506, "lon": -3.498986}
{"@timestamp": "2025-09-20T05:43:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 134, "lat": 40.287947, "lon": -3.478791}
{"@timestamp": "2025-09-20T05:46:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 167, "lat": 40.640279, "lon": -3.715266}
{"@timestamp": "2025-09-20T05:49:05Z", "host": "web-1", "service": "search", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 147, "lat": 40.406305, "lon": -3.864981}
{"@timestamp": "2025-09-20T05:50:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "login succeeded", "latency_ms": 95, "lat": 40.245711, "lon": -3.695617}
{"@timestamp": "2025-09-20T05:55:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 148, "lat": 40.549969, "lon": -3.65346}
{"@timestamp": "2025-09-20T05:58:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 89, "lat": 40.517513, "lon": -3.887455}
{"@timestamp": "2025-09-20T06:00:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 85, "lat": 40.347382, "lon": -3.635676}
{"@timestamp": "2025-09-20T06:12:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "publish event", "latency_ms": 65, "lat": 40.411846, "lon": -3.670449}
{"@timestamp": "2025-09-20T06:19:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 113, "lat": 40.272115, "lon": -3.78236}
{"@timestamp": "2025-09-20T06:27:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 133, "lat": 40.572804, "lon": -3.944238}
{"@timestamp": "2025-09-20T06:41:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 108, "lat": 40.434097, "lon": -3.9531}
{"@timestamp": "2025-09-20T06:48:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 114, "lat": 40.254107, "lon": -3.657915}
{"@timestamp": "2025-09-20T06:52:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 41, "lat": 40.470972, "lon": -3.482298}
{"@timestamp": "2025-09-20T06:54:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "request completed", "latency_ms": 77, "lat": 40.366064, "lon": -3.736554}
{"@timestamp": "2025-09-20T07:23:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 93, "lat": 40.410731, "lon": -3.627676}
{"@timestamp": "2025-09-20T07:28:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 111, "lat": 40.405983, "lon": -3.586214}
{"@timestamp": "2025-09-20T07:29:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 45, "lat": 40.351447, "lon": -3.690672}
{"@timestamp": "2025-09-20T07:33:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 86, "lat": 40.452306, "lon": -3.53565}
{"@timestamp": "2025-09-20T07:34:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "publish event", "latency_ms": 81, "lat": 40.471503, "lon": -3.599506}
{"@timestamp": "2025-09-20T08:26:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 127, "lat": 40.312868, "lon": -3.481755}
{"@timestamp": "2025-09-20T08:28:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 69, "lat": 40.329401, "lon": -3.715723}
{"@timestamp": "2025-09-20T08:32:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 176, "lat": 40.26776, "lon": -3.542518}
{"@timestamp": "2025-09-20T08:33:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 102, "lat": 40.505955, "lon": -3.78273}
{"@timestamp": "2025-09-20T08:46:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 158, "lat": 40.512209, "lon": -3.561785}
{"@timestamp": "2025-09-20T08:49:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "cache miss", "latency_ms": 66, "lat": 40.2524, "lon": -3.64156}
{"@timestamp": "2025-09-20T08:55:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 137, "lat": 40.171482, "lon": -3.582228}
{"@timestamp": "2025-09-20T08:58:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "login failed", "latency_ms": 79, "lat": 40.230444, "lon": -3.743577}
{"@timestamp": "2025-09-20T09:00:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 149, "lat": 40.542589, "lon": -3.779511}
{"@timestamp": "2025-09-20T09:00:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 140, "lat": 40.614119, "lon": -3.760478}
{"@timestamp": "2025-09-20T09:05:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 136, "lat": 40.279535, "lon": -3.480058}
{"@timestamp": "2025-09-20T09:06:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 132, "lat": 40.323948, "lon": -3.934228}
{"@timestamp": "2025-09-20T09:15:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "login failed", "latency_ms": 138, "lat": 40.209453, "lon": -3.60016}
{"@timestamp": "2025-09-20T09:22:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 93, "lat": 40.305284, "lon": -3.911676}
{"@timestamp": "2025-09-20T09:38:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 97, "lat": 40.480986, "lon": -3.886496}
{"@timestamp": "2025-09-20T09:40:05Z", "host": "web-1", "service": "search", "level": "ERROR", "message": "validation error", "latency_ms": 42, "lat": 40.429123, "lon": -3.605885}
{"@timestamp": "2025-09-20T09:40:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "validation error", "latency_ms": 170, "lat": 40.170733, "lon": -3.473426}
{"@timestamp": "2025-09-20T09:41:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "db query executed", "latency_ms": 109, "lat": 40.207332, "lon": -3.53845}
{"@timestamp": "2025-09-20T09:49:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "cache miss", "latency_ms": 165, "lat": 40.244827, "lon": -3.468725}
{"@timestamp": "2025-09-20T09:56:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 130, "lat": 40.380989, "lon": -3.768515}
{"@timestamp": "2025-09-20T09:58:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 49, "lat": 40.359324, "lon": -3.896259}
{"@timestamp": "2025-09-20T10:02:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 102, "lat": 40.663631, "lon": -3.561357}
{"@timestamp": "2025-09-20T10:04:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 101, "lat": 40.569778, "lon": -3.902199}
{"@timestamp": "2025-09-20T10:08:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 110, "lat": 40.44009, "lon": -3.782351}
{"@timestamp": "2025-09-20T10:26:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 73, "lat": 40.537516, "lon": -3.507586}
{"@timestamp": "2025-09-20T10:28:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 105, "lat": 40.388078, "lon": -3.935809}
{"@timestamp": "2025-09-20T10:28:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 100, "lat": 40.24087, "lon": -3.511999}
{"@timestamp": "2025-09-20T10:34:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 108, "lat": 40.351593, "lon": -3.809005}
{"@timestamp": "2025-09-20T10:43:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "cache miss", "latency_ms": 98, "lat": 40.202817, "lon": -3.58607}
{"@timestamp": "2025-09-20T10:52:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 123, "lat": 40.22403, "lon": -3.474651}
{"@timestamp": "2025-09-20T11:08:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "publish event", "latency_ms": 78, "lat": 40.649702, "lon": -3.652856}
{"@timestamp": "2025-09-20T11:11:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "publish event", "latency_ms": 41, "lat": 40.459413, "lon": -3.853131}
{"@timestamp": "2025-09-20T11:24:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 78, "lat": 40.260878, "lon": -3.482796}
{"@timestamp": "2025-09-20T11:25:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 99, "lat": 40.629588, "lon": -3.684574}
{"@timestamp": "2025-09-20T11:27:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 141, "lat": 40.614239, "lon": -3.821298}
{"@timestamp": "2025-09-20T11:43:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 81, "lat": 40.631244, "lon": -3.665902}
{"@timestamp": "2025-09-20T11:52:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "login failed", "latency_ms": 64, "lat": 40.465285, "lon": -3.648146}
{"@timestamp": "2025-09-20T12:01:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "consume event", "latency_ms": 94, "lat": 40.360294, "lon": -3.672964}
{"@timestamp": "2025-09-20T12:14:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "login succeeded", "latency_ms": 99, "lat": 40.335356, "lon": -3.806288}
{"@timestamp": "2025-09-20T12:16:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 132, "lat": 40.268667, "lon": -3.811742}
{"@timestamp": "2025-09-20T12:16:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 131, "lat": 40.262045, "lon": -3.781538}
{"@timestamp": "2025-09-20T12:35:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 108, "lat": 40.537134, "lon": -3.681117}
{"@timestamp": "2025-09-20T12:42:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 87, "lat": 40.459808, "lon": -3.785519}
{"@timestamp": "2025-09-20T12:53:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 133, "lat": 40.196291, "lon": -3.862435}
{"@timestamp": "2025-09-20T13:03:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 99, "lat": 40.359184, "lon": -3.655856}
{"@timestamp": "2025-09-20T13:09:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 70, "lat": 40.306073, "lon": -3.828897}
{"@timestamp": "2025-09-20T13:53:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "login succeeded", "latency_ms": 114, "lat": 40.297451, "lon": -3.685748}
{"@timestamp": "2025-09-20T13:54:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 84, "lat": 40.233054, "lon": -3.860104}
{"@timestamp": "2025-09-20T13:57:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 104, "lat": 40.198355, "lon": -3.852479}
{"@timestamp": "2025-09-20T14:12:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 113, "lat": 40.387559, "lon": -3.700852}
{"@timestamp": "2025-09-20T14:24:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 92, "lat": 40.247252, "lon": -3.916299}
{"@timestamp": "2025-09-20T14:26:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 82, "lat": 40.573583, "lon": -3.678752}
{"@timestamp": "2025-09-20T14:30:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 86, "lat": 40.180219, "lon": -3.854301}
{"@timestamp": "2025-09-20T14:37:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 99, "lat": 40.476499, "lon": -3.925359}
{"@timestamp": "2025-09-20T15:05:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 123, "lat": 40.570364, "lon": -3.588934}
{"@timestamp": "2025-09-20T15:11:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 79, "lat": 40.466734, "lon": -3.463092}
{"@timestamp": "2025-09-20T15:19:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 102, "lat": 40.431348, "lon": -3.504545}
{"@timestamp": "2025-09-20T15:20:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 93, "lat": 40.515398, "lon": -3.592781}
{"@timestamp": "2025-09-20T15:22:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 89, "lat": 40.394902, "lon": -3.76898}
{"@timestamp": "2025-09-20T15:25:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "login failed", "latency_ms": 56, "lat": 40.248127, "lon": -3.776165}
{"@timestamp": "2025-09-20T15:28:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "request completed", "latency_ms": 73, "lat": 40.18773, "lon": -3.848266}
{"@timestamp": "2025-09-20T15:35:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "publish event", "latency_ms": 116, "lat": 40.602266, "lon": -3.468822}
{"@timestamp": "2025-09-20T15:43:05Z", "host": "web-1", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 114, "lat": 40.594954, "lon": -3.855768}
{"@timestamp": "2025-09-20T15:48:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "request completed", "latency_ms": 129, "lat": 40.506402, "lon": -3.877432}
{"@timestamp": "2025-09-20T15:52:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 79, "lat": 40.258134, "lon": -3.569648}
{"@timestamp": "2025-09-20T15:53:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 120, "lat": 40.228292, "lon": -3.852855}
{"@timestamp": "2025-09-20T15:58:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 58, "lat": 40.391727, "lon": -3.786472}
{"@timestamp": "2025-09-20T16:09:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 96, "lat": 40.264263, "lon": -3.785097}
{"@timestamp": "2025-09-20T16:10:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 103, "lat": 40.5312, "lon": -3.65131}
{"@timestamp": "2025-09-20T16:20:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "consume event", "latency_ms": 52, "lat": 40.548259, "lon": -3.862266}
{"@timestamp": "2025-09-20T16:35:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 62, "lat": 40.636274, "lon": -3.576317}
{"@timestamp": "2025-09-20T16:38:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 111, "lat": 40.21219, "lon": -3.530869}
{"@timestamp": "2025-09-20T16:41:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "timeout waiting upstream", "latency_ms": 94, "lat": 40.313581, "lon": -3.70485}
{"@timestamp": "2025-09-20T16:52:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "consume event", "latency_ms": 100, "lat": 40.276438, "lon": -3.568634}
{"@timestamp": "2025-09-20T16:57:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 137, "lat": 40.450192, "lon": -3.818252}
{"@timestamp": "2025-09-20T16:57:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "login failed", "latency_ms": 103, "lat": 40.358587, "lon": -3.730432}
{"@timestamp": "2025-09-20T16:59:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "login failed", "latency_ms": 77, "lat": 40.241127, "lon": -3.540581}
{"@timestamp": "2025-09-20T17:10:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "publish event", "latency_ms": 105, "lat": 40.666777, "lon": -3.602432}
{"@timestamp": "2025-09-20T17:11:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "login failed", "latency_ms": 90, "lat": 40.603022, "lon": -3.540389}
{"@timestamp": "2025-09-20T17:34:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 116, "lat": 40.611677, "lon": -3.875248}
{"@timestamp": "2025-09-20T17:36:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 99, "lat": 40.632498, "lon": -3.715522}
{"@timestamp": "2025-09-20T17:37:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 37, "lat": 40.302717, "lon": -3.760942}
{"@timestamp": "2025-09-20T17:53:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 99, "lat": 40.192119, "lon": -3.491734}
{"@timestamp": "2025-09-20T17:53:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "login failed", "latency_ms": 129, "lat": 40.303482, "lon": -3.670586}
{"@timestamp": "2025-09-20T18:16:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 69, "lat": 40.57007, "lon": -3.646782}
{"@timestamp": "2025-09-20T18:30:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 117, "lat": 40.666211, "lon": -3.51466}
{"@timestamp": "2025-09-20T18:31:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 76, "lat": 40.350462, "lon": -3.8938}
{"@timestamp": "2025-09-20T18:37:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 73, "lat": 40.537272, "lon": -3.574053}
{"@timestamp": "2025-09-20T18:39:05Z", "host": "db-1", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 92, "lat": 40.486713, "lon": -3.692257}
{"@timestamp": "2025-09-20T18:41:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 102, "lat": 40.528588, "lon": -3.50141}
{"@timestamp": "2025-09-20T18:42:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 139, "lat": 40.466996, "lon": -3.879174}
{"@timestamp": "2025-09-20T18:42:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 110, "lat": 40.601228, "lon": -3.840917}
{"@timestamp": "2025-09-20T18:43:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 99, "lat": 40.365785, "lon": -3.79975}
{"@timestamp": "2025-09-20T18:46:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "login succeeded", "latency_ms": 110, "lat": 40.271642, "lon": -3.607212}
{"@timestamp": "2025-09-20T18:56:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 68, "lat": 40.364683, "lon": -3.798663}
{"@timestamp": "2025-09-20T18:57:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 149, "lat": 40.175685, "lon": -3.75208}
{"@timestamp": "2025-09-20T18:57:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "validation error", "latency_ms": 69, "lat": 40.169135, "lon": -3.686909}
{"@timestamp": "2025-09-20T19:15:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 93, "lat": 40.484138, "lon": -3.915453}
{"@timestamp": "2025-09-20T19:22:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "validation error", "latency_ms": 93, "lat": 40.577861, "lon": -3.93839}
{"@timestamp": "2025-09-20T19:24:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 111, "lat": 40.318755, "lon": -3.642441}
{"@timestamp": "2025-09-20T19:47:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "cache miss", "latency_ms": 72, "lat": 40.4903, "lon": -3.931652}
{"@timestamp": "2025-09-20T19:53:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 138, "lat": 40.49588, "lon": -3.829631}
{"@timestamp": "2025-09-20T19:58:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 85, "lat": 40.535597, "lon": -3.73222}
{"@timestamp": "2025-09-20T19:59:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "cache miss", "latency_ms": 62, "lat": 40.273667, "lon": -3.697964}
{"@timestamp": "2025-09-20T20:03:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "login failed", "latency_ms": 88, "lat": 40.281889, "lon": -3.933229}
{"@timestamp": "2025-09-20T20:03:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 119, "lat": 40.489793, "lon": -3.549151}
{"@timestamp": "2025-09-20T20:06:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 110, "lat": 40.169535, "lon": -3.581977}
{"@timestamp": "2025-09-20T20:26:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 138, "lat": 40.453115, "lon": -3.816938}
{"@timestamp": "2025-09-20T20:29:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 109, "lat": 40.185941, "lon": -3.853647}
{"@timestamp": "2025-09-20T20:35:05Z", "host": "web-1", "service": "checkout", "level": "WARN", "message": "cache miss", "latency_ms": 121, "lat": 40.536628, "lon": -3.795461}
{"@timestamp": "2025-09-20T20:46:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 80, "lat": 40.533939, "lon": -3.806869}
{"@timestamp": "2025-09-20T21:08:05Z", "host": "app-2", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 105, "lat": 40.214577, "lon": -3.485403}
{"@timestamp": "2025-09-20T21:17:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "publish event", "latency_ms": 93, "lat": 40.592865, "lon": -3.708077}
{"@timestamp": "2025-09-20T21:34:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "request completed", "latency_ms": 116, "lat": 40.324508, "lon": -3.504739}
{"@timestamp": "2025-09-20T21:35:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "cache miss", "latency_ms": 131, "lat": 40.600929, "lon": -3.63351}
{"@timestamp": "2025-09-20T21:38:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 156, "lat": 40.433988, "lon": -3.950876}
{"@timestamp": "2025-09-20T21:43:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "publish event", "latency_ms": 105, "lat": 40.171443, "lon": -3.606001}
{"@timestamp": "2025-09-20T21:46:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "request completed", "latency_ms": 102, "lat": 40.496694, "lon": -3.657212}
{"@timestamp": "2025-09-20T21:55:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 121, "lat": 40.454916, "lon": -3.499972}
{"@timestamp": "2025-09-20T22:06:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "validation error", "latency_ms": 69, "lat": 40.37331, "lon": -3.721472}
{"@timestamp": "2025-09-20T22:22:05Z", "host": "app-1", "service": "ingest", "level": "ERROR", "message": "login succeeded", "latency_ms": 133, "lat": 40.514152, "lon": -3.515141}
{"@timestamp": "2025-09-20T22:24:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 109, "lat": 40.584814, "lon": -3.469302}
{"@timestamp": "2025-09-20T22:25:05Z", "host": "app-2", "service": "ingest", "level": "WARN", "message": "publish event", "latency_ms": 116, "lat": 40.507367, "lon": -3.512776}
{"@timestamp": "2025-09-20T22:34:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 101, "lat": 40.491718, "lon": -3.527917}
{"@timestamp": "2025-09-20T22:41:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 73, "lat": 40.174629, "lon": -3.850221}
{"@timestamp": "2025-09-20T22:46:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "db query executed", "latency_ms": 1, "lat": 40.572057, "lon": -3.470019}
{"@timestamp": "2025-09-20T22:51:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "db query executed", "latency_ms": 118, "lat": 40.238001, "lon": -3.733596}
{"@timestamp": "2025-09-20T22:55:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "login succeeded", "latency_ms": 119, "lat": 40.472322, "lon": -3.889468}
{"@timestamp": "2025-09-20T23:06:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 103, "lat": 40.525973, "lon": -3.761811}
{"@timestamp": "2025-09-20T23:14:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 89, "lat": 40.568271, "lon": -3.475445}
{"@timestamp": "2025-09-20T23:18:05Z", "host": "app-2", "service": "auth", "level": "WARN", "message": "login failed", "latency_ms": 89, "lat": 40.185743, "lon": -3.917176}
{"@timestamp": "2025-09-20T23:37:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "validation error", "latency_ms": 126, "lat": 40.286088, "lon": -3.831954}
{"@timestamp": "2025-09-20T23:51:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 93, "lat": 40.643878, "lon": -3.544812}
{"@timestamp": "2025-09-21T00:15:05Z", "host": "app-1", "service": "search", "level": "ERROR", "message": "login failed", "latency_ms": 73, "lat": 40.340538, "lon": -3.546043}
{"@timestamp": "2025-09-21T00:19:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "cache miss", "latency_ms": 55, "lat": 40.48084, "lon": -3.878113}
{"@timestamp": "2025-09-21T00:58:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "db query executed", "latency_ms": 123, "lat": 40.550573, "lon": -3.704012}
{"@timestamp": "2025-09-21T01:02:05Z", "host": "web-1", "service": "ingest", "level": "WARN", "message": "consume event", "latency_ms": 117, "lat": 40.372198, "lon": -3.749083}
{"@timestamp": "2025-09-21T01:04:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 85, "lat": 40.645928, "lon": -3.915326}
{"@timestamp": "2025-09-21T01:42:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 79, "lat": 40.243866, "lon": -3.812235}
{"@timestamp": "2025-09-21T01:43:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 112, "lat": 40.560246, "lon": -3.803125}
{"@timestamp": "2025-09-21T01:50:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "validation error", "latency_ms": 82, "lat": 40.57083, "lon": -3.657535}
{"@timestamp": "2025-09-21T01:57:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 97, "lat": 40.255765, "lon": -3.919101}
{"@timestamp": "2025-09-21T01:59:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "login failed", "latency_ms": 99, "lat": 40.665861, "lon": -3.714615}
{"@timestamp": "2025-09-21T02:06:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "validation error", "latency_ms": 87, "lat": 40.506451, "lon": -3.555517}
{"@timestamp": "2025-09-21T02:13:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "request completed", "latency_ms": 86, "lat": 40.53549, "lon": -3.940151}
{"@timestamp": "2025-09-21T02:23:05Z", "host": "web-2", "service": "ingest", "level": "WARN", "message": "db query executed", "latency_ms": 34, "lat": 40.203545, "lon": -3.913405}
{"@timestamp": "2025-09-21T02:25:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 102, "lat": 40.567994, "lon": -3.926406}
{"@timestamp": "2025-09-21T02:26:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "validation error", "latency_ms": 102, "lat": 40.199529, "lon": -3.939347}
{"@timestamp": "2025-09-21T02:29:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "validation error", "latency_ms": 101, "lat": 40.378588, "lon": -3.752661}
{"@timestamp": "2025-09-21T02:38:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "login succeeded", "latency_ms": 145, "lat": 40.267806, "lon": -3.765926}
{"@timestamp": "2025-09-21T03:29:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 92, "lat": 40.665535, "lon": -3.824087}
{"@timestamp": "2025-09-21T03:35:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 112, "lat": 40.455537, "lon": -3.567531}
{"@timestamp": "2025-09-21T03:48:05Z", "host": "web-2", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 90, "lat": 40.397989, "lon": -3.550342}
{"@timestamp": "2025-09-21T03:58:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "consume event", "latency_ms": 112, "lat": 40.305764, "lon": -3.942526}
{"@timestamp": "2025-09-21T04:02:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 95, "lat": 40.550475, "lon": -3.57172}
{"@timestamp": "2025-09-21T04:04:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "validation error", "latency_ms": 72, "lat": 40.348228, "lon": -3.547675}
{"@timestamp": "2025-09-21T04:06:05Z", "host": "web-1", "service": "auth", "level": "WARN", "message": "db query executed", "latency_ms": 116, "lat": 40.314075, "lon": -3.62279}
{"@timestamp": "2025-09-21T04:14:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 99, "lat": 40.371396, "lon": -3.669098}
{"@timestamp": "2025-09-21T04:14:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 81, "lat": 40.481691, "lon": -3.921492}
{"@timestamp": "2025-09-21T04:20:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 72, "lat": 40.644229, "lon": -3.755448}
{"@timestamp": "2025-09-21T04:21:05Z", "host": "app-2", "service": "checkout", "level": "ERROR", "message": "login succeeded", "latency_ms": 119, "lat": 40.445837, "lon": -3.745713}
{"@timestamp": "2025-09-21T04:33:05Z", "host": "db-1", "service": "checkout", "level": "WARN", "message": "consume event", "latency_ms": 90, "lat": 40.615232, "lon": -3.893658}
{"@timestamp": "2025-09-21T04:46:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 123, "lat": 40.329057, "lon": -3.87012}
{"@timestamp": "2025-09-21T04:54:05Z", "host": "app-2", "service": "search", "level": "ERROR", "message": "cache miss", "latency_ms": 126, "lat": 40.630636, "lon": -3.734742}
{"@timestamp": "2025-09-21T04:55:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 89, "lat": 40.476367, "lon": -3.771014}
{"@timestamp": "2025-09-21T05:37:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "request completed", "latency_ms": 137, "lat": 40.642848, "lon": -3.526499}
{"@timestamp": "2025-09-21T05:46:05Z", "host": "app-1", "service": "auth", "level": "WARN", "message": "request completed", "latency_ms": 86, "lat": 40.228919, "lon": -3.524974}
{"@timestamp": "2025-09-21T05:49:05Z", "host": "app-1", "service": "ingest", "level": "WARN", "message": "validation error", "latency_ms": 94, "lat": 40.228598, "lon": -3.827431}
{"@timestamp": "2025-09-21T06:04:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "publish event", "latency_ms": 140, "lat": 40.247195, "lon": -3.686142}
{"@timestamp": "2025-09-21T06:10:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "publish event", "latency_ms": 101, "lat": 40.324921, "lon": -3.757871}
{"@timestamp": "2025-09-21T06:15:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 88, "lat": 40.192011, "lon": -3.480666}
{"@timestamp": "2025-09-21T06:23:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "publish event", "latency_ms": 172, "lat": 40.236728, "lon": -3.708579}
{"@timestamp": "2025-09-21T06:27:05Z", "host": "web-2", "service": "auth", "level": "WARN", "message": "login succeeded", "latency_ms": 91, "lat": 40.553564, "lon": -3.798451}
{"@timestamp": "2025-09-21T06:30:05Z", "host": "web-1", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 121, "lat": 40.464985, "lon": -3.784882}
{"@timestamp": "2025-09-21T06:35:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 63, "lat": 40.423544, "lon": -3.916307}
{"@timestamp": "2025-09-21T06:38:05Z", "host": "web-2", "service": "auth", "level": "ERROR", "message": "consume event", "latency_ms": 117, "lat": 40.264128, "lon": -3.677189}
{"@timestamp": "2025-09-21T06:58:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 138, "lat": 40.611393, "lon": -3.902249}
{"@timestamp": "2025-09-21T07:03:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "login succeeded", "latency_ms": 107, "lat": 40.238118, "lon": -3.640108}
{"@timestamp": "2025-09-21T07:28:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 79, "lat": 40.51341, "lon": -3.720532}
{"@timestamp": "2025-09-21T07:47:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 126, "lat": 40.417484, "lon": -3.474939}
{"@timestamp": "2025-09-21T07:50:05Z", "host": "app-1", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 94, "lat": 40.470061, "lon": -3.738346}
{"@timestamp": "2025-09-21T08:00:05Z", "host": "app-1", "service": "checkout", "level": "INFO", "message": "request completed", "latency_ms": 123, "lat": 40.477468, "lon": -3.834528}
{"@timestamp": "2025-09-21T08:06:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "login succeeded", "latency_ms": 111, "lat": 40.438975, "lon": -3.866875}
{"@timestamp": "2025-09-21T08:06:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 112, "lat": 40.343639, "lon": -3.673858}
{"@timestamp": "2025-09-21T08:06:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 121, "lat": 40.295095, "lon": -3.591812}
{"@timestamp": "2025-09-21T08:12:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "consume event", "latency_ms": 104, "lat": 40.620316, "lon": -3.802206}
{"@timestamp": "2025-09-21T08:13:05Z", "host": "web-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 99, "lat": 40.545902, "lon": -3.930855}
{"@timestamp": "2025-09-21T08:15:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "validation error", "latency_ms": 133, "lat": 40.346431, "lon": -3.911369}
{"@timestamp": "2025-09-21T08:16:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 111, "lat": 40.608999, "lon": -3.566961}
{"@timestamp": "2025-09-21T08:25:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 67, "lat": 40.602462, "lon": -3.842338}
{"@timestamp": "2025-09-21T08:33:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "login failed", "latency_ms": 83, "lat": 40.384997, "lon": -3.461682}
{"@timestamp": "2025-09-21T08:38:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "cache miss", "latency_ms": 92, "lat": 40.547047, "lon": -3.693364}
{"@timestamp": "2025-09-21T08:47:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "request completed", "latency_ms": 92, "lat": 40.220857, "lon": -3.53574}
{"@timestamp": "2025-09-21T08:48:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 82, "lat": 40.665386, "lon": -3.755303}
{"@timestamp": "2025-09-21T08:50:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "db query executed", "latency_ms": 86, "lat": 40.2842, "lon": -3.685027}
{"@timestamp": "2025-09-21T08:57:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 80, "lat": 40.170368, "lon": -3.461668}
{"@timestamp": "2025-09-21T08:58:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 96, "lat": 40.645511, "lon": -3.652728}
{"@timestamp": "2025-09-21T09:00:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 130, "lat": 40.598384, "lon": -3.75585}
{"@timestamp": "2025-09-21T09:12:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 93, "lat": 40.611855, "lon": -3.672634}
{"@timestamp": "2025-09-21T09:31:05Z", "host": "db-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 140, "lat": 40.652882, "lon": -3.54957}
{"@timestamp": "2025-09-21T09:34:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "login succeeded", "latency_ms": 43, "lat": 40.240484, "lon": -3.830093}
{"@timestamp": "2025-09-21T09:37:05Z", "host": "db-1", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 84, "lat": 40.661968, "lon": -3.892068}
{"@timestamp": "2025-09-21T10:25:05Z", "host": "web-1", "service": "auth", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 102, "lat": 40.306039, "lon": -3.711093}
{"@timestamp": "2025-09-21T10:29:05Z", "host": "app-2", "service": "ingest", "level": "ERROR", "message": "validation error", "latency_ms": 66, "lat": 40.369816, "lon": -3.736205}
{"@timestamp": "2025-09-21T10:34:05Z", "host": "app-2", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 103, "lat": 40.55717, "lon": -3.670975}
{"@timestamp": "2025-09-21T10:37:05Z", "host": "app-1", "service": "checkout", "level": "WARN", "message": "validation error", "latency_ms": 71, "lat": 40.393623, "lon": -3.875095}
{"@timestamp": "2025-09-21T10:39:05Z", "host": "app-2", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 124, "lat": 40.255592, "lon": -3.51856}
{"@timestamp": "2025-09-21T10:46:05Z", "host": "web-1", "service": "checkout", "level": "ERROR", "message": "cache miss", "latency_ms": 83, "lat": 40.4167, "lon": -3.624376}
{"@timestamp": "2025-09-21T10:59:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 137, "lat": 40.198736, "lon": -3.597638}
{"@timestamp": "2025-09-21T11:05:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login succeeded", "latency_ms": 79, "lat": 40.288899, "lon": -3.747774}
{"@timestamp": "2025-09-21T11:18:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 81, "lat": 40.341238, "lon": -3.582771}
{"@timestamp": "2025-09-21T11:30:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 80, "lat": 40.595356, "lon": -3.63011}
{"@timestamp": "2025-09-21T11:39:05Z", "host": "web-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 84, "lat": 40.342435, "lon": -3.62318}
{"@timestamp": "2025-09-21T11:43:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 92, "lat": 40.252056, "lon": -3.639287}
{"@timestamp": "2025-09-21T11:45:05Z", "host": "db-1", "service": "checkout", "level": "ERROR", "message": "validation error", "latency_ms": 107, "lat": 40.571515, "lon": -3.950551}
{"@timestamp": "2025-09-21T11:54:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 103, "lat": 40.52345, "lon": -3.657357}
{"@timestamp": "2025-09-21T11:56:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "request completed", "latency_ms": 63, "lat": 40.666586, "lon": -3.617659}
{"@timestamp": "2025-09-21T12:13:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "db query executed", "latency_ms": 92, "lat": 40.644384, "lon": -3.682883}
{"@timestamp": "2025-09-21T12:15:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "consume event", "latency_ms": 91, "lat": 40.615941, "lon": -3.857544}
{"@timestamp": "2025-09-21T12:23:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 76, "lat": 40.628907, "lon": -3.837055}
{"@timestamp": "2025-09-21T12:48:05Z", "host": "web-1", "service": "ingest", "level": "ERROR", "message": "cache miss", "latency_ms": 69, "lat": 40.535655, "lon": -3.943059}
{"@timestamp": "2025-09-21T13:03:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 102, "lat": 40.455956, "lon": -3.931155}
{"@timestamp": "2025-09-21T13:07:05Z", "host": "app-1", "service": "checkout", "level": "ERROR", "message": "login succeeded", "latency_ms": 84, "lat": 40.245303, "lon": -3.78041}
{"@timestamp": "2025-09-21T13:10:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 104, "lat": 40.581709, "lon": -3.676696}
{"@timestamp": "2025-09-21T13:18:05Z", "host": "web-1", "service": "checkout", "level": "ERROR", "message": "publish event", "latency_ms": 79, "lat": 40.582813, "lon": -3.493915}
{"@timestamp": "2025-09-21T13:36:05Z", "host": "web-2", "service": "ingest", "level": "INFO", "message": "consume event", "latency_ms": 125, "lat": 40.585372, "lon": -3.684309}
{"@timestamp": "2025-09-21T13:39:05Z", "host": "db-1", "service": "ingest", "level": "WARN", "message": "request completed", "latency_ms": 74, "lat": 40.638171, "lon": -3.804494}
{"@timestamp": "2025-09-21T13:52:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 57, "lat": 40.375647, "lon": -3.896213}
{"@timestamp": "2025-09-21T13:54:05Z", "host": "web-1", "service": "auth", "level": "INFO", "message": "publish event", "latency_ms": 73, "lat": 40.407634, "lon": -3.844118}
{"@timestamp": "2025-09-21T13:58:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "cache miss", "latency_ms": 118, "lat": 40.515063, "lon": -3.818159}
{"@timestamp": "2025-09-21T14:25:05Z", "host": "db-1", "service": "search", "level": "ERROR", "message": "login succeeded", "latency_ms": 95, "lat": 40.175371, "lon": -3.547221}
{"@timestamp": "2025-09-21T14:31:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "login failed", "latency_ms": 72, "lat": 40.560689, "lon": -3.932393}
{"@timestamp": "2025-09-21T14:48:05Z", "host": "app-2", "service": "checkout", "level": "INFO", "message": "publish event", "latency_ms": 120, "lat": 40.624021, "lon": -3.605987}
{"@timestamp": "2025-09-21T15:01:05Z", "host": "web-1", "service": "checkout", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 113, "lat": 40.584493, "lon": -3.621746}
{"@timestamp": "2025-09-21T15:04:05Z", "host": "app-2", "service": "auth", "level": "INFO", "message": "db query executed", "latency_ms": 82, "lat": 40.462321, "lon": -3.5449}
{"@timestamp": "2025-09-21T15:18:05Z", "host": "app-1", "service": "auth", "level": "ERROR", "message": "login failed", "latency_ms": 107, "lat": 40.236415, "lon": -3.573964}
{"@timestamp": "2025-09-21T15:22:05Z", "host": "app-2", "service": "auth", "level": "ERROR", "message": "db query executed", "latency_ms": 82, "lat": 40.545423, "lon": -3.643917}
{"@timestamp": "2025-09-21T15:25:05Z", "host": "app-2", "service": "ingest", "level": "INFO", "message": "publish event", "latency_ms": 103, "lat": 40.44581, "lon": -3.484678}
{"@timestamp": "2025-09-21T15:30:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "validation error", "latency_ms": 127, "lat": 40.266751, "lon": -3.578707}
{"@timestamp": "2025-09-21T15:36:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "login failed", "latency_ms": 87, "lat": 40.212165, "lon": -3.713909}
{"@timestamp": "2025-09-21T15:38:05Z", "host": "app-2", "service": "auth", "level": "WARN", "message": "login failed", "latency_ms": 87, "lat": 40.63238, "lon": -3.525057}
{"@timestamp": "2025-09-21T15:46:05Z", "host": "db-1", "service": "auth", "level": "WARN", "message": "validation error", "latency_ms": 155, "lat": 40.548523, "lon": -3.631559}
{"@timestamp": "2025-09-21T15:52:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 84, "lat": 40.187391, "lon": -3.683835}
{"@timestamp": "2025-09-21T16:03:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "publish event", "latency_ms": 75, "lat": 40.343257, "lon": -3.46492}
{"@timestamp": "2025-09-21T16:04:05Z", "host": "web-2", "service": "checkout", "level": "WARN", "message": "publish event", "latency_ms": 112, "lat": 40.424306, "lon": -3.454823}
{"@timestamp": "2025-09-21T16:17:05Z", "host": "db-1", "service": "auth", "level": "INFO", "message": "login failed", "latency_ms": 72, "lat": 40.324202, "lon": -3.462828}
{"@timestamp": "2025-09-21T16:18:05Z", "host": "app-1", "service": "ingest", "level": "INFO", "message": "validation error", "latency_ms": 150, "lat": 40.228552, "lon": -3.690562}
{"@timestamp": "2025-09-21T16:30:05Z", "host": "web-2", "service": "search", "level": "ERROR", "message": "timeout waiting upstream", "latency_ms": 103, "lat": 40.565184, "lon": -3.679694}
{"@timestamp": "2025-09-21T17:01:05Z", "host": "web-2", "service": "search", "level": "WARN", "message": "publish event", "latency_ms": 54, "lat": 40.545256, "lon": -3.651614}
{"@timestamp": "2025-09-21T17:03:05Z", "host": "db-1", "service": "auth", "level": "ERROR", "message": "request completed", "latency_ms": 85, "lat": 40.568944, "lon": -3.749377}
{"@timestamp": "2025-09-21T17:15:05Z", "host": "web-2", "service": "auth", "level": "INFO", "message": "consume event", "latency_ms": 67, "lat": 40.605399, "lon": -3.478305}
{"@timestamp": "2025-09-21T17:15:05Z", "host": "web-2", "service": "checkout", "level": "INFO", "message": "db query executed", "latency_ms": 90, "lat": 40.520385, "lon": -3.949229}
{"@timestamp": "2025-09-21T17:19:05Z", "host": "app-1", "service": "search", "level": "INFO", "message": "validation error", "latency_ms": 93, "lat": 40.181359, "lon": -3.865985}
{"@timestamp": "2025-09-21T17:34:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "consume event", "latency_ms": 112, "lat": 40.316401, "lon": -3.620339}
{"@timestamp": "2025-09-21T17:42:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "cache miss", "latency_ms": 103, "lat": 40.454939, "lon": -3.874582}
{"@timestamp": "2025-09-21T18:03:05Z", "host": "app-1", "service": "search", "level": "WARN", "message": "consume event", "latency_ms": 98, "lat": 40.378864, "lon": -3.764162}
{"@timestamp": "2025-09-21T18:16:05Z", "host": "web-2", "service": "ingest", "level": "ERROR", "message": "publish event", "latency_ms": 94, "lat": 40.520278, "lon": -3.602306}
{"@timestamp": "2025-09-21T18:26:05Z", "host": "db-1", "service": "ingest", "level": "INFO", "message": "request completed", "latency_ms": 85, "lat": 40.614434, "lon": -3.60215}
{"@timestamp": "2025-09-21T18:30:05Z", "host": "db-1", "service": "ingest", "level": "ERROR", "message": "request completed", "latency_ms": 133, "lat": 40.257841, "lon": -3.794692}
{"@timestamp": "2025-09-21T18:36:05Z", "host": "web-2", "service": "search", "level": "INFO", "message": "timeout waiting upstream", "latency_ms": 147, "lat": 40.431707, "lon": -3.834716}

JSONL
echo "Lab creado en $LAB_DIR"
