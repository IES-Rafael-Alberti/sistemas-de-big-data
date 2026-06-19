---
title: "Laboratorio de Grafana — Introducción y Práctica"
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
---
# UD3 — Laboratorio de Grafana  
## Visualización de métricas y observabilidad con Grafana

---

### Módulo
Sistemas de Big Data

### Unidad Didáctica
UD3 — Procesamiento, visualización y observabilidad en sistemas Big Data

### Laboratorio
Laboratorio — Introducción a Grafana y métricas temporales

---

## 1. Contexto del laboratorio

En la Unidad Didáctica 3 se ha trabajado el ciclo completo del dato en sistemas Big Data:

- ingesta e integración,
- procesamiento distribuido (Spark),
- exploración y visualización (Kibana),
- observabilidad básica.

Hasta ahora, la visualización se ha realizado principalmente con **Kibana**, orientado al análisis de **logs, eventos y datos indexados**.

En este laboratorio se introduce **Grafana**, una herramienta ampliamente utilizada para la **visualización de métricas y series temporales**, muy común en entornos de producción, monitorización y observabilidad.

---

## 2. ¿Qué es Grafana?

**Grafana** es una plataforma de visualización y análisis que permite crear **dashboards interactivos** a partir de múltiples fuentes de datos.

A diferencia de Kibana:

- Grafana **no está ligada a un único motor de datos**.
- Está especialmente orientada a **series temporales** y métricas.
- Se usa habitualmente para **monitorización de sistemas**, rendimiento y observabilidad.

Grafana no almacena datos:  
👉 **consume datos de otras fuentes** (Prometheus, bases de datos, APIs, etc.).

---

## 3. Grafana en el ecosistema Big Data

En proyectos reales de Big Data y Data Engineering, Grafana se utiliza para:

- monitorizar clústeres Spark,
- analizar rendimiento de jobs,
- observar consumo de recursos,
- detectar anomalías temporales,
- crear paneles técnicos para equipos de operación.

Este laboratorio simula ese contexto a pequeña escala.

---

## 4. Grafana frente a Kibana (visión conceptual)

| Aspecto | Grafana | Kibana |
|------|--------|--------|
| Tipo de datos | Métricas, series temporales | Logs, eventos, documentos |
| Almacenamiento | No almacena datos | Basado en Elasticsearch |
| Casos de uso | Monitorización, observabilidad | Exploración, búsqueda |
| Público objetivo | Técnicos / DevOps | Analistas / usuarios técnicos |
| Lenguaje de consulta | Depende de la fuente (PromQL, SQL…) | KQL / ES|QL |

Ambas herramientas **no compiten**, sino que se **complementan**.

---

## 5. Objetivo del laboratorio

El objetivo de este laboratorio es:

- comprender el papel de Grafana en sistemas Big Data,
- trabajar con **métricas temporales**,
- crear dashboards básicos orientados a observabilidad,
- comparar Grafana con Kibana desde un punto de vista técnico.

---

## 6. Enfoque del laboratorio

Durante el laboratorio se realizará:

1. Despliegue de Grafana en contenedor.
2. Conexión a una fuente de métricas.
3. Creación de paneles básicos.
4. Construcción de un dashboard.
5. Reflexión comparativa con Kibana.

No se busca dominar Grafana en profundidad, sino **entender su filosofía y uso principal**.

---

## 7. Entorno de trabajo

El laboratorio se realiza en **entorno local**, usando:

- contenedores OCI (Docker o Podman),
- despliegue reproducible,
- sin necesidad de cuentas externas.

Esto garantiza que el laboratorio:
- sea estable,
- funcione en el aula,
- no dependa de servicios en la nube.

---

## 8. Nota sobre Docker y Podman

El laboratorio está planteado usando **Docker Compose**.

En sistemas donde Docker no esté disponible, puede utilizarse **Podman + podman-compose**, ya que Grafana y las herramientas asociadas cumplen el estándar OCI.

Esta diferencia **no afecta al desarrollo del laboratorio**.

---

## 9. Relación con la UD3

Este laboratorio actúa como:

- **cierre del bloque de visualización**,
- ampliación de la observabilidad,
- puente hacia arquitecturas reales de producción.

Permite ver que:
> no existe una única herramienta de visualización en Big Data, sino soluciones adaptadas a cada tipo de dato.

---

## 10. Cierre

Tras este laboratorio, el alumnado habrá trabajado:

- Spark → procesamiento,
- Kibana → exploración y dashboards,
- Grafana → métricas y observabilidad.

Esto completa una visión **realista y profesional** del ecosistema Big Data.

---

## Fin del laboratorio