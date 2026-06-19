# UD4 - Laboratorio
## Documento de entrega - Power BI para Business Intelligence

---

## Datos del grupo

- Módulo: Sistemas de Big Data
- Unidad: UD4 - BI y Orquestación
- Curso: 2025-2026
- Grupo:
- Integrantes:
- Fecha de entrega:

---

# 1. Modo de trabajo seleccionado

**Indicar la opción utilizada:**

- [ ] **Power BI Desktop** (aplicación Windows)
- [ ] **Power BI Service** (navegador/web - app.powerbi.com)

## 1.1 Justificación

Explicar brevemente por qué se ha elegido esta opción:

- Si Power BI Desktop: ¿Por qué? (facilidad de uso, necesidad de DAX, etc.)
- Si Power BI Service: ¿Por qué? (Linux, accesibilidad, sin instalación)

---

# 2. Descripción del trabajo realizado

## 2.1 Objetivo del dashboard

Explicar brevemente:

- Qué pregunta de negocio responde el dashboard.
- Qué datos se han utilizado.
- Qué tipo de análisis permite.

---

# 3. Datos y modelo

## 3.1 Origen de datos

Indicar:

- Tipo de archivo/fuente utilizada.
- Número de registros/filas.
- Estructura básica (nombre de campos).

## 3.2 Modelo de datos

**Solo aplicable si se usa Power BI Desktop:**

Adjuntar captura de la vista Modelo (diagrama de relaciones).

Describir:

- Tabla de hechos identificada.
- Tablas de dimensiones identificadas.
- Relaciones creadas (cardinalidad: 1:N, etc.).

**Si se usa Power BI Service:**

El modelo se crea automáticamente al importar datos. Indicar si se han creado relaciones o se ha trabajado con una sola tabla.

**Pregunta de reflexión:**
¿Por qué es importante un modelo de datos correcto en BI?

---

# 4. Medidas y cálculos

## 4.1 Medidas creadas

**Solo aplicable si se usa Power BI Desktop (DAX):**

Para cada medida creada, indicar:

| Nombre | Fórmula DAX | Descripción |
|--------|-------------|-------------|
| | | |

**Si se usa Power BI Service:**

Power BI Service no permite crear medidas DAX. Indicar qué alternativas se han utilizado:

- [ ] Campos agregados automático (Sigma Σ)
- [ ] Q&A para consultas dinámicas
- [ ] Solo visualización de datos importados
- [ ] Otra forma

## 4.2 Diferencia conceptual

**Solo para Power BI Desktop:**

Explicar con tus propias palabras:

- ¿Por qué usar medidas en lugar de columnas calculadas?
- ¿Qué significa "contexto de filtro"?

**Para Power BI Service:**

Explicar las limitaciones de no tener DAX:

- ¿Qué operaciones se pueden hacer?
- ¿Qué ventajas tiene trabajar sin fórmulas?

---

# 5. Visualizaciones

## 5.1 Elementos del dashboard

Indicar qué visualizaciones se han creado:

| Visualización | Tipo | Campos utilizados | Propósito |
|---------------|------|-------------------|------------|
| KPI Ventas | Tarjeta | Total Ventas | Mostrar indicador principal |
| | | | |

## 5.2 Diseño del dashboard

Adjuntar captura del dashboard final.

Describir:

- Criterios de layout utilizados.
- Uso de segmentadores (slicers) - solo en Power BI Service disponibles directamente en dashboards.
- Interacciones entre visualizaciones.

---

# 6. Creación del dashboard

## 6.1 Power BI Desktop

Pasos realizados:

1. Crear informe (pestañas/páginas)
2. Añadir visualizaciones al lienzo
3. Guardar archivo `.pbix`
4. Publicar en Power BI Service (opcional)

## 6.2 Power BI Service

Pasos realizados:

1. Importar datos → Crear modelo semántico
2. Crear informe desde el modelo
3. Anclar visualizaciones al dashboard
4. Editar layout del dashboard

**Adjuntar capturas de:**

- Modelo semántico o de datos
- Informe creado
- Dashboard final

---

# 7. Publicación y compartición

## 7.1 Power BI Desktop

- ¿Se ha publicado en Power BI Service?
- Workspace utilizado.
- Enlace de acceso (si procede).

## 7.2 Power BI Service

- ¿Se ha compartido el dashboard?
- Permisos configurados (solo lectura / puede editar).
- Enlace de acceso (si se ha compartido).

---

# 8. Análisis conceptual

Responde de forma razonada:

1. ¿Qué diferencias has observado entre Power BI y las herramientas vistas anteriormente (Metabase, Superset)?
2. ¿Qué ventajas tiene el modelo semántico de Power BI?
3. ¿En qué escenarios sería mejor usar DirectQuery en lugar de Import?
4. ¿Dónde debería realizarse el cálculo pesado: en Spark o en Power BI?
5. ¿Qué tipo de empresas utilizan Power BI como herramienta principal de BI?
6. **¿Qué limitaciones has encontrado al usar Power BI Service comparado con Desktop?**
7. **¿Qué ventajas tiene usar Power BI Service para usuarios de Linux?**

---

# 9. Comparativa técnica

Completar la siguiente tabla:

| Aspecto | Metabase | Superset | Power BI Desktop | Power BI Service |
|----------|----------|----------|------------------|------------------|
| Licencia | | | | |
| Requiere instalación | | | | |
| Modelo semántico | | | | |
| Lenguaje DAX | | | | |
| Trabajo en Linux | | | | |
| Power Query/Transformación | | | | |

---

# 10. Extensión (si se realizó)

Indicar si se realizó alguna ampliación:

**Para Power BI Desktop:**

- Nueva medida DAX avanzada (CALCULATE, FILTER, etc.)
- Jerarquía de fechas
- Drill-through entre páginas
- Columnas calculadas

**Para Power Power BI Service:**

- Uso de Q&A para generar visualizaciones
- Uso de Copilot (si disponible)
- Creación de múltiples dashboards
- Vinculación a OneDrive/SharePoint

Explicar brevemente.

---

# 11. Reflexión final

Responder:

- ¿Qué parte ha resultado más clara?
- ¿Qué parte ha resultado más compleja?
- ¿Entiendes ahora el papel de Power BI en el ecosistema Big Data?
- ¿Consideras útil Power BI para tu futuro profesional? ¿Por qué?
- ¿Qué opción prefieres: Desktop o Service? ¿Por qué?

---

# 12. Rúbrica de evaluación

| Criterio | Excelente (9-10) | Notable (7-8) | Aprobado (5-6) | Insuficiente (<5) |
|----------|-----------------|---------------|---------------|------------------|
| Modelo de datos | Relaciones correctas y bien justificadas | Relaciones correctas | Modelo básico sin optimizar | Sin modelo o incorrecto |
| Medidas/Cálculos | Medidas DAX correctas o uso eficiente de alternativas | Medidas correctas | Medida básica | Sin medidas o incorrectas |
| Visualizaciones | Coherentes y bien diseñadas | Visualizaciones correctas | Visualizaciones mínimas | Sin visualizaciones |
| Dashboard | Diseño claro y profesional | Diseño correcto | Dashboard básico | Sin dashboard |
| Análisis conceptual | Reflexión profunda sobre BI | Reflexión correcta | Reflexión superficial | Sin reflexión |
| Documentación | Documento estructurado y completo | Documento correcto | Documento mínimo | Documento incompleto |

---

## Nota importante

No se evaluará la complejidad técnica avanzada.
Se valorará la comprensión del concepto de Business Intelligence y la capacidad de crear un dashboard funcional.

Para Power BI Service: se evaluará el uso eficiente de las herramientas disponibles en la versión web.
Para Power BI Desktop: se evaluará el uso de DAX y el modelado de datos.

---

## Archivos a entregar

**Para Power BI Desktop:**

1. Archivo `.pbix`
2. Capturas de pantalla del trabajo realizado
3. Este documento de entrega cumplimentado

**Para Power BI Service:**

1. Enlace al dashboard publicado (o capturas)
2. Capturas de pantalla del trabajo realizado
3. Este documento de entrega cumplimentado

---

## Fin del documento
