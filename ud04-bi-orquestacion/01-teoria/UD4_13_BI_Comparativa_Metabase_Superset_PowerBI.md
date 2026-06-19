# UD4 - Comparativa de Herramientas BI
## Metabase vs Superset vs Power BI

Centro: IES Rafael Alberti
Módulo: Sistemas de Big Data
Curso: 2025-2026

---

# 1. Introducción

El Business Intelligence no es solo una cuestión técnica, sino también estratégica.

Existen tres grandes enfoques:

- BI libre y sencillo.
- BI open-source profesional.
- BI corporativo estándar.

En esta unidad hemos trabajado con Metabase y Superset.
Ahora analizamos también Power BI para comprender el panorama real del mercado.

---

# 2. Metabase

## Filosofía

- Herramienta sencilla.
- Orientada a negocio.
- Pensada para equipos pequeños o medianos.

## Ventajas

- Muy fácil de usar.
- Rápida configuración.
- Curva de aprendizaje baja.
- Ideal para empezar.

## Limitaciones

- Menor control avanzado.
- Personalización limitada.
- No tan robusta para grandes organizaciones.

## Perfil de uso típico

- Startup.
- Pyme.
- Equipo de analistas no técnicos.

---

# 3. Apache Superset

## Filosofía

- BI open-source profesional.
- Enfoque más técnico.
- Mayor control sobre métricas y datasets.

## Ventajas

- Flexible.
- Más configurable.
- Orientada a entornos Big Data.
- Escalable.

## Limitaciones

- Curva de aprendizaje mayor.
- Requiere mayor comprensión del modelo de datos.

## Perfil de uso típico

- Empresas tecnológicas.
- Equipos de data engineering.
- Entornos distribuidos.

---

# 4. Power BI

## Qué es

Power BI es la herramienta de BI de Microsoft.
Tiene dos componentes principales:

- Power BI Desktop (gratuito, solo Windows).
- Power BI Service (en la nube, con licencias).

## Filosofía

- Integración total con ecosistema Microsoft.
- Modelo semántico potente.
- Lenguaje DAX para cálculos avanzados.

## Ventajas

- Muy extendido en empresa.
- Potente motor de modelado.
- Excelente integración con Excel.
- Visualizaciones profesionales.

## Limitaciones

- No es open-source.
- Dependencia del ecosistema Microsoft.
- Versiones avanzadas requieren licencia.

## Perfil de uso típico

- Empresas tradicionales.
- Departamentos financieros.
- Entornos corporativos grandes.

---

# 5. Comparativa técnica

| Aspecto | Metabase | Superset | Power BI |
|----------|-----------|------------|-------------|
| Licencia | Libre | Open-source | Propietario |
| Facilidad | Alta | Media | Media |
| Curva aprendizaje | Baja | Media | Media |
| Control avanzado | Bajo | Alto | Alto |
| Escalabilidad | Media | Alta | Alta |
| Entorno típico | Pyme | Empresa tecnológica | Corporativo |
| Integración Big Data | Básica | Muy buena | Buena |

---

# 6. Arquitectura conceptual

Metabase y Superset:

- Se conectan a bases de datos.
- No almacenan datos.
- Funcionan como capa de visualización.

Power BI:

- Puede importar datos.
- Puede crear modelo semántico propio.
- Permite transformaciones internas.

---

# 7. Reflexión profesional

Preguntas para el alumnado:

1. ¿Qué herramienta usarías en una startup?
2. ¿Qué herramienta usarías en una empresa pública?
3. ¿Qué herramienta usarías en un entorno Big Data con Spark?
4. ¿Qué ventajas tiene que una herramienta sea open-source?
5. ¿Qué implica depender de un proveedor como Microsoft?

---

# 8. Conclusión

No existe una herramienta mejor en términos absolutos.

La elección depende de:

- Tipo de empresa.
- Infraestructura.
- Perfil técnico del equipo.
- Presupuesto.
- Escalabilidad requerida.

En este módulo se ha trabajado con herramientas abiertas porque:

- Permiten comprender mejor la arquitectura.
- Son compatibles con entornos Big Data.
- No dependen de licencias comerciales.

Power BI es relevante en el mercado laboral, pero conceptualmente no es diferente en su objetivo: transformar datos en información útil para la toma de decisiones.
