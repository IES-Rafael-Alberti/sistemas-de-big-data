---
title: "Laboratorio de Grafana — Configuración y Arranque"
author: "José MSA"
date: "2026-02-05"
output:
  pdf_document:
    latex_engine: xelatex
    toc: true
    toc_depth: 2
    number_sections: false
    fig_caption: true
  word_document:
    toc: true
    toc_depth: '2'
  html_document:
    toc: true
    toc_depth: '2'
    df_print: paged
    keep_tex: false
mainfont: DejaVu Sans
monofont: DejaVu Sans Mono
header-includes:
- \usepackage{fontspec}
- \setmonofont{DejaVu Sans Mono}
- \usepackage{needspace}
---

## 0. `docker-compose.yml` — Laboratorio Grafana

Este `docker-compose.yml` levanta:

* **Prometheus** → recoge métricas (series temporales)
* **Grafana** → visualiza métricas
* **metrics-generator** → simula un sistema real generando métricas

---

###  Estructura recomendada

```text
grafana-lab/
├── docker-compose.yml
├── prometheus/
│   └── prometheus.yml
└── metrics-generator/
    └── app.py
```

---

## 1. `docker-compose.yml`

```yaml
version: "3.8"

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
    ports:
      - "9090:9090"
    networks:
      - grafana_net

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus
    networks:
      - grafana_net

  metrics-generator:
    image: python:3.11-slim
    container_name: metrics-generator
    volumes:
      - ./metrics-generator:/app
    working_dir: /app
    command: python app.py
    networks:
      - grafana_net

networks:
  grafana_net:
    driver: bridge
```

---

## 2. Configuración de Prometheus

###  `prometheus/prometheus.yml`

```yaml
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: "metrics-generator"
    static_configs:
      - targets: ["metrics-generator:8000"]
```

Esto indica a Prometheus que:

* recoja métricas cada 5 segundos,
* consulte al generador de métricas en el puerto 8000.

---

## 3. Generador simple de métricas

### `metrics-generator/app.py`

Este script simula un servicio que expone métricas tipo Prometheus.

```python
from http.server import BaseHTTPRequestHandler, HTTPServer
import random
import time

class MetricsHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/metrics":
            cpu = random.uniform(10, 90)
            requests = random.randint(50, 300)

            metrics = f"""
# HELP fake_cpu_usage CPU usage percentage
# TYPE fake_cpu_usage gauge
fake_cpu_usage {cpu}

# HELP fake_requests_total Number of requests
# TYPE fake_requests_total counter
fake_requests_total {requests}
"""
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(metrics.encode())
        else:
            self.send_response(404)
            self.end_headers()

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8000), MetricsHandler)
    print("Metrics generator running on port 8000")
    server.serve_forever()
```

---

## 4. Arranque del laboratorio

Desde el directorio `grafana-lab`:

```bash
docker compose up -d
```

(o con Podman)

```bash
podman-compose up -d
```

---

## 5. Comprobaciones rápidas

* Prometheus: [http://localhost:9090](http://localhost:9090)
  → Status → Targets → debe aparecer `metrics-generator` **UP**

* Grafana: [http://localhost:3000](http://localhost:3000)

  * usuario: `admin`
  * contraseña: `admin`

---

## 6. Configuracion de la fuente de datos en Grafana

Antes de crear paneles y dashboards, es necesario configurar la fuente de datos desde la que Grafana obtendra las metricas.

En este laboratorio se utilizara **Prometheus** como fuente de datos.



### Pasos para anadir Prometheus como Data Source

1. Accede a Grafana desde el navegador, [http://localhost:3000](http://localhost:3000)

2. Inicia sesion con las credenciales configuradas:

- Usuario: admin
- Contrasena: admin

3. En el menu lateral izquierdo, accede a:

`Connections -> Data sources`

4. Pulsa el boton **Add data source**.

5. Selecciona **Prometheus** como tipo de fuente de datos.

6. En el campo **URL**, introduce, [http://prometheus:9090](http://prometheus:9090)

(Esta URL funciona porque Grafana y Prometheus estan en la misma red Docker).

7. No es necesario modificar el resto de opciones.

8. Pulsa **Save & test**.

9. Comprueba que aparece el mensaje indicando que la conexion es correcta.

---

### Resultado esperado

Tras completar estos pasos:

- Grafana queda conectado a Prometheus.
- Las metricas generadas por el script Python ya pueden utilizarse en paneles.
- Se puede continuar con la creacion de visualizaciones.

---

### Nota tecnica

Si la conexion falla, comprueba:

- que los contenedores estan levantados,
- que Prometheus aparece como servicio activo,
- que la URL es exactamente [http://prometheus:9090](http://prometheus:9090)

---

## 7. Creacion de paneles en Grafana

Una vez configurada la fuente de datos Prometheus, el siguiente paso es crear paneles que permitan visualizar las metricas generadas por el script Python.

El servicio de generacion de metricas expone, al menos, las siguientes metricas:

- fake_cpu_usage
- fake_requests_total

Estas metricas simulan el comportamiento de un sistema real y se utilizan para construir los paneles.

---

## Panel 1 - Uso simulado de CPU

### Objetivo
Visualizar la evolucion temporal del uso de CPU simulado.

### Pasos

1. En Grafana, pulsa "Create" -> "Dashboard".
2. Pulsa "Add new panel".
3. Selecciona la fuente de datos Prometheus.
4. En el campo de consulta, escribe: **fake_cpu_usage**

5. Selecciona un tipo de visualizacion "Time series".
6. Ajusta el rango temporal (por ejemplo ultimos 5 o 15 minutos).
7. Asigna un titulo al panel, por ejemplo: **Uso simulado de CPU**
8. Guarda el panel.

### Interpretacion
Este panel muestra como varia el uso de CPU a lo largo del tiempo y permite detectar picos o comportamientos anormales.

---

## Panel 2 - Numero de peticiones simuladas

### Objetivo
Visualizar el numero de peticiones generadas por el sistema.

### Pasos

1. Anade un nuevo panel al dashboard.
2. Selecciona Prometheus como fuente de datos.
3. Introduce la siguiente consulta: **fake_requests_total**
4. Selecciona visualizacion "Time series" o "Stat".
5. Asigna un titulo adecuado, por ejemplo: **Peticiones simuladas**
6. Guarda el panel.

### Interpretacion
Este panel permite observar la carga del sistema en terminos de peticiones.

---

## Panel 3 - Comparacion de metricas (opcional)

### Objetivo
Comparar varias metricas en un mismo panel.

### Pasos

1. Crea un nuevo panel.
2. Anade dos consultas:
   - Consulta A: fake_cpu_usage
   - Consulta B: fake_requests_total
3. Ajusta las unidades y leyendas.
4. Asigna un titulo como: **Comparacion de carga del sistema**.
Este panel permite observar relaciones entre carga y uso de recursos.

---

## Dashboard final

El dashboard final debe contener al menos:

- un panel de uso de CPU,
- un panel de peticiones,
- los paneles organizados de forma clara y legible.

El objetivo del dashboard es permitir una **vision rapida del estado del sistema**.

---

## Nota importante

No se evaluara la estetica avanzada del dashboard, sino:

- la correccion de las metricas usadas,
- la coherencia de los paneles,
- la interpretacion de la informacion mostrada.

---
## 8. Justificación

Este entorno permite ver claramente:

* qué son **métricas**,
* cómo se recogen (scraping),
* cómo se visualizan,
* por qué Grafana **no sustituye** a Kibana.

Es simple, pero **conceptualmente muy potente**.


