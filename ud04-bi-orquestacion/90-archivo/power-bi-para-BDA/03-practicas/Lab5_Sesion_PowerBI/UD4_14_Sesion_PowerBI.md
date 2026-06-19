# UD4 - Sesión Demo
## Power BI en el ecosistema Big Data

Centro: IES Rafael Alberti  
Módulo: Sistemas de Big Data  
Curso: 2025-2026  

---

# 1. Objetivo de la sesión

Comprender el papel de Power BI dentro de un ecosistema de datos moderno y compararlo con las herramientas trabajadas en la unidad (Metabase y Superset).

El objetivo no es dominar Power BI, sino entender:

- Su arquitectura.
- Su modelo de trabajo.
- Su encaje en un pipeline Big Data.
- Su relevancia profesional en el mercado laboral.

---

# 2. Contexto: ¿Dónde encaja Power BI?

En un entorno Big Data típico encontramos:

Fuente de datos  
→ Ingesta  
→ Procesamiento (Spark)  
→ Almacenamiento (Data Warehouse / Lakehouse / Base relacional)  
→ Herramienta BI  
→ Usuario final  

Power BI se sitúa en la última capa: consumo y visualización.

No sustituye a Spark.  
No sustituye a la ingesta.  
Consume datos procesados.

---

# 3. Componentes de Power BI

## 3.1 Power BI Desktop

- Aplicación gratuita.
- Solo Windows.
- Permite conectar, modelar y visualizar datos.
- Genera archivos .pbix.

## 3.2 Power BI Service

- Plataforma en la nube.
- Publicación y compartición de dashboards.
- Control de acceso y roles.
- Requiere licencia en entornos empresariales.

---

# 4. Arquitectura conceptual

A diferencia de Superset o Metabase, Power BI puede trabajar en dos modos principales:

## 4.1 Import Mode

- Los datos se importan al modelo interno.
- Se almacenan en memoria.
- Mejor rendimiento.
- Limitado por tamaño.

## 4.2 DirectQuery

- Consulta directa a la base de datos.
- No importa datos.
- Dependiente del rendimiento del origen.

Pregunta para reflexionar:

¿Qué modo sería más adecuado si trabajamos con millones de registros procesados por Spark?

---

# 5. Modelo semántico

Power BI no solo consulta datos.

Permite:

- Crear relaciones entre tablas.
- Definir medidas calculadas.
- Aplicar lógica mediante DAX. (DAX es un lenguaje de fórmulas específico de Power BI).

Ejemplo conceptual de medida:

TotalVentas = SUM(Ventas[Monto])

Esto se calcula dentro del modelo.

En Superset, la lógica suele residir en la base de datos.

---

# 6. Demo estructurada

Instala Power BI Desktop, o accede a Power BI en la nube y sigue estos pasos:

1. Conexión a un dataset.
2. Creación de modelo.
3. Definición de una medida básica.
4. Creación de:
   - Un KPI.
   - Una serie temporal.
   - Un gráfico categórico.
5. Construcción de un dashboard.
6. Publicación conceptual.

---

# 7. Comparativa técnica

| Aspecto | Metabase | Superset | Power BI |
|----------|-----------|------------|-------------|
| Licencia | Libre | Open-source | Propietario |
| Curva aprendizaje | Baja | Media | Media |
| Modelo semántico interno | No | Parcial | Sí |
| Integración Big Data | Media | Alta | Buena |
| Uso empresarial | Medio | Alto | Muy alto |

---

# 8. Integración con Spark

Escenario real:

Spark procesa grandes volúmenes  
→ Se escriben resultados en PostgreSQL / S3 / Delta  
→ Power BI conecta al resultado  

Conclusión clave:

El procesamiento masivo se hace en Spark.  
El análisis ejecutivo se hace en BI.

Separación clara de responsabilidades.

---

# 9. Reflexión profesional

Responder:

1. ¿En qué tipo de empresa sería habitual Power BI?
2. ¿Qué ventajas tiene frente a Superset?
3. ¿Qué limitaciones presenta?
4. ¿Qué papel juega el modelo semántico?
5. ¿Dónde debería realizarse el cálculo pesado: Spark o BI?

---

# 10. Conclusión

Power BI no es una herramienta de ingeniería de datos.  
Es una herramienta de explotación y visualización.

Metabase → simplicidad.  
Superset → flexibilidad open-source.  
Power BI → estándar corporativo.

En un ecosistema profesional completo, pueden convivir.

---

# 🧪 Entrega de la práctica

El alumno deberá entregar:

* Archivo `.pbix`
* Captura del dashboard final
* Documento breve explicando:

  * Modelo utilizado
  * Medidas creadas
  * Decisiones de visualización

---

# 📌 Criterios de evaluación (orientativo)

| Criterio                   | Peso |
| -------------------------- | ---- |
| Conexión correcta de datos | 15%  |
| Modelo bien construido     | 20%  |
| Medidas correctas          | 20%  |
| Visualizaciones coherentes | 25%  |
| Diseño del dashboard       | 10%  |
| Explicación técnica        | 10%  |

# Fin de la sesión.
