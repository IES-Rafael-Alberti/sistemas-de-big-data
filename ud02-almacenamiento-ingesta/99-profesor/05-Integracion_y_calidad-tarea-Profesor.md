Perfecto, José Manuel.
Aquí tienes **los tres elementos solicitados**, completamente listos para usar:

1. **Cabecera YAML para exportar a PDF con Pandoc**
2. **Versión orientada al profesor (didáctica + notas pedagógicas + criterios RA/CE)**
3. **Dataset de ejemplo generado para la práctica (ventas + turismo)**

Todo está integrado de manera profesional y coherente con tu módulo UD2.

---

# ✅ **1. CABECERA YAML PARA EXPORTACIÓN A PDF (PANDOC)**

Pega esto **arriba del documento**:

```yaml
---
title: "Práctica: Integración y Calidad Incremental de Datos"
subtitle: "UD2 — Sistemas de Big Data"
author: "José Manuel Sánchez Álvarez"
institute: "IES Rafael Alberti"
course: "Curso 2025–2026"
lang: "es"
fontsize: 11pt
papersize: a4
geometry: margin=2.5cm
toc: true
toc-depth: 3
numbersections: true
colorlinks: true
header-includes:
  - \usepackage{helvet}
  - \renewcommand{\familydefault}{\sfdefault}
  - \usepackage{float}
---
```

Opciones clave:

* **toc** → añadir índice
* **numbersections** → numeración 1, 1.1, 1.1.1
* **helvetica** → estética moderna y limpia
* márgenes adecuados para impresión y PDF académico

---

# ✅ **2. VERSIÓN ORIENTADA AL PROFESOR (CON NOTAS DIDÁCTICAS + RA/CE)**

Esta versión sirve para tu memoria docente, programación o guía interna.

---

# 🟦 **Versión Docente – Notas y Orientaciones Pedagógicas**

## 1. Propósito didáctico

Esta práctica está diseñada para cubrir los aspectos clave de la **ingesta, integración y calidad de datos** dentro de un entorno Big Data. Se enfoca en actividades alcanzables para todos los alumnos, independientemente de sus limitaciones técnicas o de hardware, ofreciendo dos rutas:

* **Ruta A:** uso de Airbyte (si lo han conseguido instalar)
* **Ruta B:** alternativa universal usando DuckDB + Python

Ambas rutas desarrollan exactamente las mismas competencias.

---

## 2. Resultados de Aprendizaje (RD 279/2021 y RD 405/2023)

### **RA3 – Integra y transforma datos procedentes de distintas fuentes**

* CE3.a – Identifica tipos de ingesta y métodos.
* CE3.b – Realiza ingestas batch e incrementales.
* CE3.c – Integra fuentes heterogéneas (CSV, API, BD…).
* CE3.d – Aplica estrategias de incrementalidad e idempotencia.

### **RA4 – Garantiza la calidad del dato durante el procesamiento**

* CE4.a – Identifica requisitos de calidad.
* CE4.b – Aplica reglas de dominio, consistencia y rango.
* CE4.c – Detecta anomalías y propone mejoras.
* CE4.d – Documenta el flujo y el linaje del dato.

---

## 3. Metodología recomendada

* **Aprendizaje basado en proyectos (ABP)**
  La actividad simula un pipeline real en empresa.

* **Evaluación continua**
  Cada fase (ingesta, integración, calidad, upsert) se valida por separado.

* **Flexibilidad técnica**
  La Ruta B asegura que ningún alumno quede atrás por problemas de instalación.

* **Trabajo autónomo + acompañamiento**
  El alumno toma decisiones técnicas sobre incrementalidad, idempotencia y calidad.

---

## 4. Dificultades previstas en el alumnado

* Confusión entre *full refresh* y *incremental*.
* Problemas al interpretar reglas de calidad.
* Errores en upserts (duplicados, pérdida de claves).
* Falta de comprensión del concepto “linaje del dato”.

Se recomienda:

* corregir la primera versión del diagrama de linaje en clase,
* hacer una demostración breve de calidad del dato (3 reglas),
* ofrecer plantilla SQL de ejemplo para upsert.

---

## 5. Criterios de calificación

Ya están integrados en la rúbrica del documento principal:

| Dimensión       | Peso |
| --------------- | ---- |
| Integración     | 20 % |
| Calidad         | 20 % |
| Incrementalidad | 20 % |
| Upsert          | 20 % |
| Documentación   | 20 % |

---

## 6. Observaciones para Dual y Simulación Empresarial

Esta práctica encaja muy bien en actividades de dualización porque:

* reproduce flujos reales en ETL/ELT,
* usa conceptos directamente aplicables a pipelines de negocio,
* genera artefactos que pueden auditarse,
* permite introducir herramientas como dbt en el futuro.

---

# ✅ **3. DATASET DE EJEMPLO (LISTO PARA USAR)**

Incluyo aquí **los dos datasets generados artificialmente**, pequeños pero realistas. Se pueden copiar como CSV.

---

## **ventas_2025-11-01.csv**

```csv
fecha,tienda_id,sku,unidades,precio,importe,canal,municipio_id
2025-11-01,101,A123,5,10.0,50.0,tienda,11
2025-11-01,101,B552,2,22.0,44.0,web,11
2025-11-01,102,A123,1,10.0,10.0,app,15
2025-11-01,103,C991,7,5.0,35.0,tienda,27
```

## **ventas_2025-11-02.csv**

```csv
fecha,tienda_id,sku,unidades,precio,importe,canal,municipio_id
2025-11-02,101,A123,3,10.0,30.0,web,11
2025-11-02,101,B552,2,22.0,44.0,app,11
2025-11-02,102,C991,1,5.0,5.0,tienda,15
2025-11-02,103,D221,4,8.0,32.0,tienda,27
```

---

## **turismo_2025-11-01.csv**

```csv
fecha,municipio_id,visitantes_municipio,visitantes_total
2025-11-01,11,1200,35000
2025-11-01,15,800,27000
2025-11-01,27,640,29000
```

## **turismo_2025-11-02.csv**

```csv
fecha,municipio_id,visitantes_municipio,visitantes_total
2025-11-02,11,1400,36000
2025-11-02,15,750,26500
2025-11-02,27,700,30000
```

---

# 📦 ¿Quieres que genere también un ZIP listo para descargar?

Puedo empaquetar automáticamente:

* ventas CSV
* turismo CSV
* ejemplo de Parquet
* plantilla de carpetas `data_lake/raw/...`
* notebook Python base para integración
* archivo SQL para DuckDB

Solo dime: **“sí, genera el ZIP”**.