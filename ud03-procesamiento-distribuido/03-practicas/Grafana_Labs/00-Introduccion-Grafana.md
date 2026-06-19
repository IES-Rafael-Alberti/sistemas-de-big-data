---
title: "Grafana - Introducción y comparativa con Kibana"
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
mainfont: DejaVu Sans Mono
monofont: DejaVu Sans Mono
header-includes:
- \usepackage{fontspec}
- \setmonofont{DejaVu Sans Mono}
- \usepackage{needspace}
editor_options: 
  markdown: 
    wrap: 72
---

# Grafana

# Introducción a Grafana

## ¿Qué es Grafana?

**Grafana** es una plataforma open-source de visualización y análisis de datos que permite crear dashboards interactivos y gráficos a partir de múltiples fuentes de datos. Es ampliamente utilizada para monitoreo, observabilidad y análisis de métricas en tiempo real.

## Características principales

### 1. Multiplataforma de datos

-   Se conecta a **múltiples fuentes de datos** simultáneamente: Prometheus, InfluxDB, Elasticsearch, MySQL, PostgreSQL, CloudWatch, y más de 100 integraciones
-   Permite combinar datos de diferentes orígenes en un mismo dashboard

### 2. Visualizaciones potentes

-   Gran variedad de tipos de gráficos: líneas, barras, gauges, mapas de calor, tablas, gráficos de series temporales
-   Paneles personalizables y reutilizables
-   Soporte para plugins que amplían las capacidades de visualización

### 3. Alertas y notificaciones

-   Sistema de alertas configurable basado en umbrales y condiciones
-   Notificaciones a múltiples canales: email, Slack, PagerDuty, webhooks, etc.
-   Gestión centralizada de reglas de alertas

### 4. Dashboards dinámicos

-   Variables y plantillas para crear dashboards reutilizables
-   Filtros interactivos y drill-downs
-   Anotaciones para marcar eventos importantes
-   Compartición y exportación de dashboards

### 5. Control de acceso

-   Gestión de usuarios y equipos
-   Permisos granulares por dashboard y fuente de datos
-   Integración con sistemas de autenticación (LDAP, OAuth, SAML)

## Casos de uso comunes

1.  **Monitoreo de infraestructura**: Métricas de servidores, contenedores, servicios cloud
2.  **Observabilidad de aplicaciones**: Performance, logs, traces (APM)
3.  **IoT y sensores**: Visualización de datos de dispositivos en tiempo real
4.  **Business Intelligence**: KPIs y métricas de negocio
5.  **DevOps y SRE**: Monitoreo de pipelines, deployments y SLOs

## Arquitectura básica

\needspace{10\baselineskip}

``` text
┌─────────────┐
│  Usuarios   │
└──────┬──────┘
       │
┌──────▼──────────────┐
│   Grafana Server    │
│  (Visualización)    │
└──────┬──────────────┘
       │
       ├─────────┬─────────┬─────────┐
       │         │         │         │
┌──────▼───┐ ┌──▼────┐ ┌──▼─────┐ ┌─▼──────────┐
│Prometheus│ │InfluxDB│ │MySQL   │ │Elasticsearch│
└──────────┘ └────────┘ └────────┘ └────────────┘
```

## Ejemplo de consulta básica

En Grafana, las consultas dependen de la fuente de datos. Ejemplo con Prometheus:

``` promql
rate(http_requests_total[5m])
```

## Instalación rápida con Docker

``` bash
docker run -d -p 3000:3000 --name=grafana grafana/grafana
```

Accede a `http://localhost:3000` (usuario/contraseña por defecto: admin/admin)

***

# Comparativa: Grafana vs Kibana

## Tabla comparativa

| Aspecto | Grafana | Kibana |
|-------------------------|-------------------------|----------------------|
| **Propósito principal** | Visualización multi-fuente y monitoreo de métricas | Visualización y análisis de datos en Elasticsearch |
| **Fuentes de datos** | Múltiples (100+): Prometheus, InfluxDB, MySQL, PostgreSQL, Elasticsearch, etc. | Principalmente Elasticsearch (parte del stack ELK) |
| **Ecosistema** | Independiente, agnóstico de fuente de datos | Integrado en el stack Elastic (Elasticsearch, Logstash, Kibana) |
| **Enfoque principal** | Métricas de series temporales y monitoreo | Búsqueda y análisis de logs |
| **Curva de aprendizaje** | Moderada, interfaz intuitiva | Moderada-Alta, más compleja inicialmente |
| **Consultas** | Depende de la fuente (PromQL, SQL, etc.) | KQL (Kibana Query Language) o Lucene |
| **Alertas** | Sistema de alertas nativo y robusto | Alertas disponibles (más limitadas en versión gratuita) |
| **Plugins** | Amplio ecosistema de plugins comunitarios | Plugins disponibles, más limitados |
| **Licencia** | Open-source (AGPL v3), versión Enterprise disponible | Open-source con funciones premium (Elastic License) |
| **Mejor para** | Monitoreo de infraestructura, IoT, métricas multi-origen | Análisis de logs, búsqueda full-text, APM |

## Diferencias clave

### 1. Filosofía de diseño

**Kibana**:

-   Diseñado específicamente para el ecosistema Elastic
-   Excelente para exploración y análisis de logs
-   Búsqueda y descubrimiento de datos como prioridad
-   Parte de una solución completa (ELK/Elastic Stack

**Grafana**:

-   Diseñado como herramienta de visualización universal
-   Prioriza la visualización de métricas y series temporales
-   Agnóstico de la fuente de datos
-   Se integra en arquitecturas existentes sin dependencias

### 2. Casos de uso ideales

**Usa Kibana si**:

-   Ya tienes Elasticsearch como fuente de datos principal
-   Necesitas análisis profundo de logs y eventos
-   Requieres búsquedas complejas en texto
-   Trabajas principalmente con el stack ELK
-   Necesitas capacidades de APM integradas con Elastic

**Usa Grafana si**:

-   Tienes múltiples fuentes de datos que visualizar
-   Tu enfoque principal es monitoreo de métricas
-   Usas Prometheus, InfluxDB u otras bases de datos de series temporales
-   Necesitas dashboards unificados de diferentes sistemas
-   Quieres flexibilidad para cambiar fuentes de datos

### 3. Visualizaciones

**Kibana**:

-   Excelente para visualizaciones basadas en agregaciones de Elasticsearch
-   Mapas geográficos avanzados
-   Visualizaciones de logs y eventos
-   Canvas para diseños personalizados

**Grafana**:

-   Especializado en gráficos de series temporales
-   Mayor variedad de tipos de gráficos para métricas
-   Paneles más orientados a monitoreo en tiempo real
-   Mejor soporte para gauges y métricas instantáneas

### 4. Rendimiento

**Kibana**:

-   Rendimiento ligado a Elasticsearch
-   Puede ser más lento con grandes volúmenes de datos históricos
-   Optimizado para búsquedas y agregaciones

**Grafana**:

-   Generalmente más rápido para métricas de series temporales
-   Rendimiento depende de la fuente de datos configurada
-   Optimizado para consultas de monitoreo

## ¿Pueden usarse juntos?

**¡Sí!** Muchas organizaciones usan ambos:

-   **Grafana** puede conectarse a Elasticsearch como fuente de datos
-   Puedes tener **Kibana** para análisis de logs y **Grafana** para dashboards de monitoreo
-   Arquitectura común: Logs en Kibana, métricas en Grafana

\needspace{14\baselineskip}

``` text
┌──────────────────────────────────────┐
│         Equipo de Operaciones        │
└────────┬─────────────────┬───────────┘
         │                 │
    ┌────▼─────┐     ┌─────▼──────┐
    │  Kibana  │     │  Grafana   │
    │  (Logs)  │     │ (Métricas) │
    └────┬─────┘     └─────┬──────┘
         │                 │
    ┌────▼─────────┐  ┌────▼──────────┐
    │Elasticsearch │  │  Prometheus   │
    │   (Logs)     │  │  (Métricas)   │
└──────────────┘  └───────────────┘
```

## Resumen

Cuando ya se conoce **Kibana**, se puede pensa **Grafana** como:

[OK] **Similar a Kibana en**: Crear dashboards, visualizaciones, alertas, trabajo en equipo

[Cambio] **Diferente de Kibana en**:

-   No está atado a Elasticsearch
-   Puede conectarse a docenas de fuentes simultáneamente
-   Más enfocado en métricas que en logs
-   Mejor para monitoreo de infraestructura y series temporales

[Clave] **Ventaja principal**: Grafana es la navaja suiza de la visualización - si Kibana es especialista en Elasticsearch, Grafana es generalista en todo tipo de datos.

***
# Ejemplo práctico: Monitoreo de una API web

Vamos a crear un escenario simple que muestre cómo se vería en **Kibana** vs **Grafana**.

## Escenario

Tienes una API REST que genera logs y métricas. Quieres monitorear:

-   Número de requests por minuto
-   Tiempo de respuesta promedio
-   Errores 5xx

***

## Ejemplo con Kibana

### 1. Datos en Elasticsearch

``` json
{
  "@timestamp": "2026-02-05T10:30:00Z",
  "service": "api-users",
  "method": "GET",
  "endpoint": "/api/users",
  "status_code": 200,
  "response_time_ms": 45,
  "user_id": "12345"
}
```

### 2. Consulta KQL en Kibana

``` text
service:"api-users" AND status_code >= 500
```

### 3. Visualización en Kibana

**Panel 1 - Requests por minuto**: 
    - Tipo: Line chart 
    - Eje Y: Count 
    - Eje X: @timestamp (por minuto) 
    - Filtro: `service:"api-users"`

**Panel 2 - Tiempo de respuesta** 
    - Tipo: Metric 
    - Agregación: Average de `response_time_ms`

**Panel 3 - Tabla de errores** 
    - Tipo: Data table 
    - Filtro: `status_code >= 500` 
    - Columnas: @timestamp, endpoint, status_code
***

## Ejemplo con Grafana

### 1. Datos en Prometheus

``` promql
# Métricas expuestas por la aplicación
api_requests_total{service="api-users", status="200"}
api_requests_total{service="api-users", status="500"}
api_response_time_seconds{service="api-users"}
```

### 2. Consultas en Grafana

**Panel 1 - Requests por minuto**:

``` promql
rate(api_requests_total{service="api-users"}[1m])
```

**Panel 2 - Tiempo de respuesta promedio**:

``` promql
avg(api_response_time_seconds{service="api-users"}) * 1000
```

**Panel 3 - Tasa de errores 5xx**:

``` promql
rate(api_requests_total{service="api-users", status=~"5.."}[5m])
```

### 3. Dashboard en Grafana

\needspace{16\baselineskip}

``` text
┌─────────────────────────────────────────────────┐
│  API Users - Monitoreo                          │
├──────────────┬──────────────┬───────────────────┤
│   Requests   │  Avg Response│    Error Rate     │
│   1,234/min  │    45ms      │     0.02%         │
│   ▲ +5%      │   ▼ -10ms    │    ▼ -0.01%       │
├──────────────┴──────────────┴───────────────────┤
│  Requests por minuto                            │
│  ╱╲    ╱╲                                       │
│ ╱  ╲  ╱  ╲╱╲  ╱╲                                │
│╱    ╲╱      ╲╱  ╲                               │
├─────────────────────────────────────────────────┤
│  Tiempo de respuesta (ms)                       │
│  ────────────────────────────                   │
│  ▁▂▁▂▃▂▁▂▁▂▃▄▃▂▁                                │
└─────────────────────────────────────────────────┘
```
***
## Comparación lado a lado

### Configuración inicial

**Kibana**:

``` bash
# 1. Levantar Elasticsearch + Kibana
docker-compose up elasticsearch kibana

# 2. Tu aplicación envía logs directamente
POST http://elasticsearch:9200/api-logs/_doc
{
  "@timestamp": "2026-02-05T10:30:00Z",
  "response_time_ms": 45
}

# 3. Crear visualización en Kibana UI
```

**Grafana**:

# 1. Levantar Prometheus + Grafana

``` bash
docker-compose up prometheus grafana
```

# 2. Tu aplicación expone métricas

``` text
# Endpoint: <http://api:8080/metrics>

api_requests_total 1234
api_response_time_seconds 0.045
```

# 3. Configurar datasource y crear dashboard

## Ejemplo de código: Instrumentación

### Para Kibana (enviar logs)

```javascript
// Node.js - Enviar logs a Elasticsearch
const { Client } = require('@elastic/elasticsearch');
const client = new Client({ node: 'http://localhost:9200' });

app.get('/api/users', async (req, res) => {
  const start = Date.now();
  
  // Tu lógica aquí
  const result = await getUsers();
  
  const responseTime = Date.now() - start;
  
  // Enviar log a Elasticsearch
  await client.index({
    index: 'api-logs',
    body: {
      '@timestamp': new Date(),
      service: 'api-users',
      endpoint: '/api/users',
      status_code: 200,
      response_time_ms: responseTime
    }
  });
  
  res.json(result);
});
```

### Para Grafana (exponer métricas)

``` javascript
// Node.js - Exponer métricas para Prometheus
const promClient = require('prom-client');

// Crear métricas
const requestCounter = new promClient.Counter({
  name: 'api_requests_total',
  help: 'Total de requests',
  labelNames: ['service', 'status']
});

const responseTime = new promClient.Histogram({
  name: 'api_response_time_seconds',
  help: 'Tiempo de respuesta',
  labelNames: ['service']
});

app.get('/api/users', async (req, res) => {
  const end = responseTime.startTimer({ service: 'api-users' });
  
  // Tu lógica aquí
  const result = await getUsers();
  
  end(); // Registra el tiempo
  requestCounter.inc({ service: 'api-users', status: '200' });
  
  res.json(result);
});

// Endpoint de métricas para Prometheus
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await promClient.register.metrics());
});
```

***

## Resultado visual

**Lo que verías en Kibana**: 

    - Tabla detallada de cada request individual 
    - Búsqueda: "muéstrame todos los errores del usuario X" 
    - Análisis: "¿qué endpoints fallaron más en la última hora?"

**Lo que verías en Grafana**: 

    - Gráfico de líneas con tendencia de requests 
    - Gauge mostrando latencia actual vs objetivo (SLA) 
    - Alerta si error rate \> 1%

***

## ¿Cuándo usar cada uno en este ejemplo?

**Usa Kibana si necesitas**: 

    - Buscar requests específicos: "¿qué pasó con el user_id 12345?" 
    - Analizar logs de error en detalle 
    - Hacer drill-down en eventos específicos

**Usa Grafana si necesitas**: 

    - Dashboard en tiempo real para el equipo de operaciones 
    - Alertas automáticas cuando métricas superan umbrales 
    - Vista consolidada con otras métricas (CPU, memoria, DB)

**Usa ambos**: 

    - Grafana en la pantalla del equipo mostrando métricas en vivo
    - Kibana para investigar cuando Grafana muestra una alerta

***

**Gauges** se traduce al español como **medidores** o **indicadores**.

En el contexto de dashboards y visualización de datos, dependiendo del tipo específico, también se pueden llamar:

    - **Medidores circulares** o **medidores radiales** (para los tipo velocímetro)
    - **Indicadores de nivel**
    - **Manómetros** (en contextos más técnicos/industriales)
    - **Gauges** (muchas veces se deja el término en inglés en la jerga técnica)

### Ejemplos visuales:

\needspace{12\baselineskip}

``` text
Medidor circular (gauge):
    ┌─────────┐
    │  ╱───╲  │
    │ │ 45% │ │
    │  ╲───╱  │
    └─────────┘

Barra de progreso (bar gauge):
    ┌─────────────────────┐
    │████████░░░░░░░  75% │
    
```

# Introducción a Prometheus

## ¿Qué es Prometheus?

**Prometheus** es un sistema open-source de monitoreo y alertas diseñado específicamente para recopilar y almacenar **métricas de series temporales**. Fue creado en SoundCloud en 2012 y actualmente es un proyecto graduado de la Cloud Native Computing Foundation (CNCF), junto a Kubernetes.

## ¿Para qué se usa Prometheus?

Prometheus está diseñado para:

1.  **Recopilar métricas** de aplicaciones y sistemas mediante scraping (consulta periódica)
2.  **Almacenar datos de series temporales** de forma eficiente
3.  **Consultar métricas** usando su lenguaje PromQL (Prometheus Query Language)
4.  **Generar alertas** basadas en reglas y umbrales

### Características principales

-   **Modelo pull**: Prometheus consulta (scrape) los endpoints de las aplicaciones periódicamente
-   **Modelo de datos multidimensional**: Las métricas se identifican por nombre y pares clave-valor (labels)
-   **Almacenamiento local**: Base de datos de series temporales optimizada
-   **PromQL**: Lenguaje de consulta potente y flexible
-   **Service Discovery**: Descubrimiento automático de targets en entornos dinámicos (Kubernetes, Consul, etc.)
-   **Sin dependencias externas**: Funciona de forma autónoma

## ¿Por qué Prometheus se conecta con Grafana?

Aunque Prometheus tiene su propia interfaz web básica, **Grafana complementa a Prometheus** de forma ideal:

### Prometheus aporta:

-   [OK] Recolección y almacenamiento eficiente de métricas
-   [OK] Motor de consultas potente (PromQL)
-   [OK] Sistema de alertas robusto
-   [No] Visualizaciones básicas y limitadas
-   [No] Dashboards poco flexibles

### Grafana aporta:

-   [OK] Visualizaciones avanzadas y personalizables
-   [OK] Dashboards profesionales e interactivos
-   [OK] Múltiples fuentes de datos en un mismo dashboard
-   [OK] Mejor experiencia de usuario
-   [OK] Compartición y gestión de dashboards

### La combinación perfecta

\needspace{18\baselineskip}

``` text
┌─────────────────────────────────────────────────┐
│              Stack de Monitoreo                 │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────┐         ┌──────────┐            │
│  │ Grafana  │ ◄─────► │Prometheus│            │
│  │(Visualiz)│ PromQL  │(Métricas)│            │
│  └──────────┘         └─────┬────┘            │
│                              │                  │
│                         Scraping                │
│                              │                  │
│       ┌──────────┬───────────┼────────┐        │
│       │          │           │        │        │
│   ┌───▼───┐  ┌──▼────┐  ┌───▼───┐ ┌──▼───┐   │
│   │  App  │  │K8s API│  │ Node  │ │ DB   │   │
│   │/metrics│  │       │  │Export.│ │Export│   │
│   └───────┘  └───────┘  └───────┘ └──────┘   │
└─────────────────────────────────────────────────┘
```

**Flujo típico**: 1. Las aplicaciones exponen métricas en formato Prometheus (endpoint `/metrics`) 2. Prometheus hace scraping de esos endpoints cada X segundos (ej: cada 15s) 3. Prometheus almacena las métricas en su base de datos de series temporales 4. Grafana consulta Prometheus usando PromQL para crear visualizaciones 5. Los usuarios ven dashboards en tiempo real en Grafana

------------------------------------------------------------------------

## Ejemplos concretos de métricas en un proyecto

### 1. Aplicación Web (Backend API)

``` promql
# Número total de peticiones HTTP
http_requests_total{service="api-users", method="GET", status="200"}

# Duración de las peticiones (histograma)
http_request_duration_seconds{service="api-users", endpoint="/api/users"}

# Peticiones activas en este momento
http_requests_in_flight{service="api-users"}

# Tasa de errores 5xx
rate(http_requests_total{status=~"5.."}[5m])

# Percentil 95 de latencia
histogram_quantile(0.95, http_request_duration_seconds_bucket)
```

**Ejemplo de dashboard**:

-   Requests por segundo (RPS)
-   Latencia p50, p95, p99
-   Tasa de errores 4xx y 5xx
-   Throughput por endpoint

### 2. Base de Datos (PostgreSQL)

``` promql
# Conexiones activas
pg_stat_activity_count{state="active"}

# Queries por segundo
rate(pg_stat_database_xact_commit_total[1m])

# Tamaño de la base de datos
pg_database_size_bytes{datname="production"}

# Locks y bloqueos
pg_locks_count{mode="ExclusiveLock"}

# Cache hit ratio
rate(pg_stat_database_blks_hit[5m]) / 
(rate(pg_stat_database_blks_hit[5m]) + rate(pg_stat_database_blks_read[5m]))
```

### 3. Infraestructura (Servidores/Contenedores)

``` promql
# Uso de CPU
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memoria disponible
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100

# Uso de disco
(node_filesystem_size_bytes - node_filesystem_free_bytes) / 
node_filesystem_size_bytes * 100

# I/O de disco
rate(node_disk_read_bytes_total[5m])
rate(node_disk_written_bytes_total[5m])

# Tráfico de red
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])
```

### 4. Kubernetes

``` promql
# Pods en ejecución
kube_pod_status_phase{phase="Running"}

# CPU usado por pod
rate(container_cpu_usage_seconds_total{pod="mi-app"}[5m])

# Memoria por pod
container_memory_usage_bytes{pod="mi-app"}

# Reiniciar de contenedores
rate(kube_pod_container_status_restarts_total[15m])

# Pods pending (esperando recursos)
kube_pod_status_phase{phase="Pending"}
```

### 5. Aplicación específica (E-commerce)

``` promql
# Pedidos completados por minuto
rate(orders_completed_total[1m])

# Valor promedio de pedidos
rate(orders_total_value_euros[5m]) / rate(orders_completed_total[5m])

# Items en carritos activos
shopping_cart_items_total

# Usuarios conectados simultáneamente
active_users_gauge

# Tasa de conversión
rate(orders_completed_total[1h]) / rate(page_views_total{page="checkout"}[1h])
```

### 6. Colas y Workers

``` promql
# Mensajes en cola
queue_messages_ready{queue="email-notifications"}

# Mensajes procesados por segundo
rate(queue_messages_processed_total[1m])

# Workers activos
worker_pool_active_count

# Tiempo de procesamiento de mensajes
rate(queue_message_processing_duration_seconds_sum[5m]) / 
rate(queue_message_processing_duration_seconds_count[5m])
```

### 7. Cache (Redis)

``` text
# Hit rate del cache
rate(redis_keyspace_hits_total[5m]) / 
(rate(redis_keyspace_hits_total[5m]) + rate(redis_keyspace_misses_total[5m]))

# Memoria usada
redis_memory_used_bytes

# Conexiones activas
redis_connected_clients

# Comandos ejecutados por segundo
rate(redis_commands_processed_total[1m])
```

------------------------------------------------------------------------

## Los tres pilares de la Observabilidad

La **observabilidad** moderna se basa en tres tipos de datos complementarios que, juntos, proporcionan una visión completa del comportamiento de un sistema:

### 1. Metricas (Metrics)

**¿Qué son?** Valores numéricos agregados que representan el estado del sistema en un momento dado.

**Características**:

-   Datos estructurados y agregados
-   Eficientes en almacenamiento
-   Ideales para tendencias y alertas
-   Responden: "¿Qué está pasando?"

**Ejemplos**:

-   CPU al 75%
-   1,500 requests/segundo
-   Latencia promedio: 250ms
-   3 errores en los últimos 5 minutos

**Herramientas**: Prometheus, InfluxDB, Graphite

### 2. Registros/Logs (Logs)

**¿Qué son?** Eventos discretos con información contextual sobre lo que ocurrió en un momento específico.

**Características**:

-   Datos no estructurados o semi-estructurados
-   Gran volumen de información
-   Ideales para debugging y análisis forense
-   Responden: "¿Qué ocurrió exactamente?"

**Ejemplos**:

``` text
2026-02-05 10:30:15 ERROR [UserService] Failed to authenticate user_id=12345: Invalid token
2026-02-05 10:30:16 INFO [OrderService] Order created: order_id=ORD-98765, amount=150.50€
2026-02-05 10:30:17 WARN [PaymentGateway] Retry attempt 2/3 for transaction txn_abc123
```

**Herramientas**: Elasticsearch + Kibana, Loki, Splunk

### 3. Trazas (Traces)

**¿Qué son?** Seguimiento del recorrido completo de una petición a través de múltiples servicios y componentes.

**Características**:

-   Muestran el flujo end-to-end
-   Identifican cuellos de botella
-   Esenciales en arquitecturas de microservicios
-   Responden: "¿Por dónde pasó la petición y dónde se ralentizó?"

**Ejemplo visual**:

\needspace{16\baselineskip}

``` text
Request ID: req-xyz789
Total: 850ms

┌─────────────────────────────────────────────────┐
│ API Gateway (50ms)                              │
│   ├─► Auth Service (120ms)                      │
│   │     └─► Redis (15ms)                        │
│   ├─► User Service (200ms)                      │
│   │     └─► PostgreSQL (180ms) ← LENTO!         │
│   ├─► Order Service (300ms)                     │
│   │     ├─► Inventory Service (150ms)           │
│   │     └─► Payment Gateway (120ms)             │
│   └─► Response (30ms)                           │
└─────────────────────────────────────────────────┘
```

**Herramientas**: Jaeger, Zipkin, Tempo, OpenTelemetry

------------------------------------------------------------------------

### Cómo se complementan los tres pilares

| Situación       | Métrica                   | Log                 | Traza         |
|-----------------|---------------------------|---------------------|---------------|
| **Deteccion**   | [OK] Alerta: Latencia \> 1s | [No]                | [No]             |
| **Contexto**    | [Aviso] "Algo va mal"       | [OK] Error especifico | [No]           |
| **Diagnostico** | [No]                         | [Aviso] Pistas         | [OK] Causa raiz |

**Ejemplo práctico**:

1.  **Metrica** detecta: "Latencia p95 subio de 200ms a 2s" -> [ALERTA]
2.  **Log** muestra: "Database connection timeout en OrderService" -> [PISTA]
3.  **Traza** revela: "PostgreSQL tardo 1.8s en query de inventario" -> [CAUSA RAIZ]

------------------------------------------------------------------------

### Stack completo de observabilidad con Prometheus y Grafana

\needspace{18\baselineskip}

``` text
┌─────────────────────────────────────────────────┐
│              OBSERVABILIDAD                     │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────────────────────────┐          │
│  │         GRAFANA                  │          │
│  │  (Visualización unificada)       │          │
│  └───┬──────────┬──────────┬────────┘          │
│      │          │          │                    │
│  ┌───▼────┐ ┌──▼─────┐ ┌──▼──────┐            │
│  │Prometh.│ │  Loki  │ │ Tempo   │            │
│  │MÉTRICAS│ │  LOGS  │ │ TRAZAS  │            │
│  └───┬────┘ └──┬─────┘ └──┬──────┘            │
│      │         │           │                    │
│      └─────────┴───────────┘                    │
│                │                                 │
│         ┌──────▼──────┐                         │
│         │ Aplicación  │                         │
│         │ (con agents)│                         │
│         └─────────────┘                         │
└─────────────────────────────────────────────────┘
```

**Beneficios de la observabilidad completa**:

-   **Detección rápida** de problemas (métricas)
-   **Diagnóstico preciso** de errores (logs)
-   **Optimización** de rendimiento (trazas)
-   **Visión holística** del sistema

------------------------------------------------------------------------

### Prometheus + Grafana: El punto de partida

En este curso nos centraremos en **métricas con Prometheus y Grafana** porque:

-   [OK] Es el punto de partida mas accesible
-   [OK] Proporciona valor inmediato (alertas y dashboards)
-   [OK] Es el estandar de facto en la industria
-   [OK] Sienta las bases para anadir logs y trazas despues

**Próximos pasos**: Una vez domines métricas, puedes expandir tu stack añadiendo:

-   **Loki** (logs)
-   También se integra con Grafana
-   **Tempo** (trazas)
-   También se integra con Grafana
-   **OpenTelemetry**
-   Estándar unificado para instrumentación

------------------------------------------------------------------------

**En resumen**:

-   **Grafana** es como un tablero de control para tus sistemas. Te muestra datos de diferentes fuentes en gráficos y dashboards.
-   **Prometheus** es como un recolector de datos. Recopila información sobre cómo funcionan tus aplicaciones y sistemas.
-   **Grafana y Prometheus** trabajan juntos. Prometheus recolecta los datos, y Grafana los visualiza para que los puedas entender y monitorear.
-   **Métricas, Logs y Traces** son como las diferentes piezas de un rompecabezas. Juntas, te dan una imagen completa de lo que está pasando en tus sistemas. └─────────────────────┘

Medidor tipo velocímetro:

\needspace{8\baselineskip}

``` text
       ╱│╲
      ╱ │ ╲
     │  ↑  │
      ╲   ╱
       ╲ ╱
```

En el documento anterior, donde mencioné "gauges", puedes leerlo como **"medidores"** o **"indicadores"**. Por ejemplo:

-   "Mejor soporte para gauges" → "Mejor soporte para **medidores**"
-   "gauges y métricas instantáneas" → "**indicadores** y métricas instantáneas"
