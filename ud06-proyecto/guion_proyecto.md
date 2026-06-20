# UD6 — Guión del proyecto integrador SBD

> **Duración**: 5 semanas (aprox. 4-5 sesiones presenciales + trabajo autónomo).
>
> **Grupos**: 3-4 personas.
>
> **Coordinación**: Este proyecto se realiza junto a **Big Data Aplicado** y
> **Programación de la IA**. Cada módulo evalúa su propia perspectiva sobre el
> mismo trabajo. Coordinar criterios y entregables con el equipo docente.
>
> **Importante**: no son tres proyectos distintos. Es **un único proyecto final**
> compartido por los tres módulos, con evidencias y criterios diferenciados para
> SBD, BDA y PIA.
>
> **RA/CE SBD cubiertos**: RA1.a-g, RA2.c-d-e, RA3.a-d, RA4.d-f (prácticamente
> todo el módulo, aplicado de forma integrada).

---

## Filosofía del proyecto

No se trata de "hacer una web con datos" ni de "entrenar el mejor modelo".
Se trata de **construir un sistema Big Data mínimo pero completo**:

```text
fuentes → ingesta → almacenamiento → calidad → procesamiento → consulta/visualización
```

El proyecto debe demostrar que sabes **tomar decisiones técnicas**:

- qué arquitectura usar y por qué;
- qué formato y herramientas elegir y con qué criterio;
- cómo garantizar calidad, trazabilidad y reproducibilidad;
- cómo visualizar resultados técnicos y de negocio;
- cómo evaluar coste, viabilidad y limitaciones.

## Uso permitido de IA

La IA generativa se puede usar como herramienta de apoyo, igual que un editor,
un buscador o un asistente de programación. Pero su uso debe ser **transparente,
verificado y defendible**.

En este módulo no se usa la escala completa de niveles 0-5 aplicada en
Programación de 1º. En SBD la exigencia es más sencilla: si se usa IA, el grupo
debe poder explicar el proceso seguido y qué ha aprendido gracias a revisar,
corregir o aplicar esa ayuda.

En este proyecto, si el grupo usa IA, debe documentar:

- qué herramienta/modelo ha usado;
- para qué la ha usado;
- qué prompts o instrucciones relevantes ha dado;
- qué resultado ha incorporado;
- cómo ha cambiado su solución después de usar IA;
- qué ha verificado, corregido o descartado;
- qué decisiones técnicas son responsabilidad del grupo.

Usar IA no penaliza. Ocultarla, no entender lo entregado o no verificarlo sí.

---

## Fases del proyecto

### Fase 0 — Formación y tema (Semana 1)

**Duración**: 1 sesión presencial + trabajo en casa.

**Actividades**:

1. **Formar grupos** (3-4 personas). Idealmente multidisciplinares si el proyecto
   se coordina con BDA y PIA.

   El grupo trabajará sobre un único proyecto común. No debe preparar una versión
   separada para cada módulo, sino un sistema de datos completo que permita
   evaluar la parte técnica de SBD, la parte aplicada/BI de BDA y la parte de
   modelos o IA de PIA.

2. **Elegir un dominio** de datos real. Ejemplos:
   - Turismo y reservas (como las prácticas del curso)
   - Datos deportivos (resultados, jugadores, estadísticas)
   - Datos de transporte público (GTFS, bicis compartidas)
   - Datos de sensores/IoT (temperatura, calidad aire)
   - Datos financieros (cotizaciones, transacciones simuladas)
   - Datos culturales (museos, eventos, afluencia)
   - Cualquier dominio con **2+ fuentes de datos** diferentes

3. **Encontrar fuentes de datos**:
   - Portales open data (datos.gob.es, europa.eu, NYC Open Data, etc.)
   - APIs públicas (restcountries, openweather, etc.)
   - Datasets de Kaggle / Zenodo
   - Datos generados por el grupo si no hay alternativa real

4. **Definir el problema**:
   - ¿Qué pregunta(s) queremos responder?
   - ¿Qué valor aporta el sistema?
   - ¿Quién usaría esto?

**Entregable SBD** (una página):

- Título del proyecto, integrantes.
- Dominio y descripción del problema.
- Fuentes de datos identificadas (mínimo 2, con URLs).
- Boceto de arquitectura Medallion propuesta.
- Cobertura RA/CE prevista.

**Entregable conjunto SBD+BDA+PIA** (si aplica):

- Acuerdo de alcance: qué hace cada módulo, qué comparten.
- Primer registro de uso de IA si ya se ha empleado para buscar ideas, fuentes o planteamiento.

---

### Fase 1 — Ingesta y arquitectura (Semana 2)

**Duración**: 1-2 sesiones presenciales.

**Actividades**:

1. **Diseñar la arquitectura**:
   - Diagrama Medallion (Bronze → Silver → Gold).
   - Elección de herramientas (justificada): ¿dlt? ¿scripts Python? ¿DuckDB?
   - Formato de almacenamiento: Parquet con particionado.

2. **Ingerir los datos**:
   - Descargar o acceder a las fuentes.
   - Crear la capa **Bronze**: datos originales convertidos a Parquet.
   - El pipeline debe ser **reproducible** (script, no clicks).

3. **Primera calidad**:
   - Esquema de cada fuente documentado.
   - Métricas de calidad iniciales (completitud, unicidad, validez).
   - Detección de problemas evidentes.

**Entregable SBD**:

- Script de ingesta reproducible.
- Datos en Bronze (Parquet).
- Reporte de calidad inicial.
- Diagrama de arquitectura actualizado.

**Cobertura RA/CE**: RA1.c-d (combinar fuentes), RA3.a (extraer y almacenar),
RA3.d (eficiencia y seguridad).

---

### Fase 2 — Calidad y procesamiento (Semana 3)

**Duración**: 1-2 sesiones presenciales.

**Actividades**:

1. **Limpiar y transformar** (Silver):
   - Aplicar reglas de calidad (completitud, unicidad, validez, consistencia).
   - Documentar cada decisión (eliminar, limpiar, etiquetar).
   - Normalizar formatos, tipos, codificaciones.

2. **Integrar fuentes** (Gold):
   - Joins entre tablas.
   - Creación de KPIs y métricas de negocio/técnicas.
   - Dataset listo para consulta y visualización.

3. **Pipeline reproducible**:
   - El proceso completo debe poder ejecutarse de nuevo.
   - Idempotencia: ejecutar N veces produce el mismo resultado.

4. **Checklist calidad/RGPD** (usar plantilla):
   - Verificar cada punto de la checklist.
   - Documentar el linaje de datos.
   - Buscar datos personales e identificadores directos o indirectos.
   - Si no hay, documentar que la anonimización queda completada por ausencia de
     identificadores.
   - Si hay, anonimizar, seudonimizar, agregar, generalizar o eliminar hasta que
     el dataset final no permita identificar directa o indirectamente a una persona.

5. **Uso de IA**:
   - Si se ha usado IA para código, limpieza, SQL, documentación o depuración,
     completar la declaración de uso de IA.
   - Verificar manualmente cualquier código o consulta generada.

**Entregable SBD**:

- Scripts de transformación (Silver → Gold).
- Datos en Gold (Parquet particionado).
- Reporte de calidad final (métricas antes/después con Δ).
- Checklist calidad/RGPD completada.
- Anonimización completada: sin identificadores detectados o con medidas aplicadas.
- Declaración de uso de IA actualizada (si se ha usado IA).
- Diagrama de linaje.

**Cobertura RA/CE**: RA1.b (extraer información), RA1.e (planificación),
RA1.g (coste/calidad), RA3.b (tecnologías eficientes), RA3.d (normativa).

---

### Fase 3 — Dashboard técnico (Semana 4)

**Duración**: 1-2 sesiones presenciales.

**Actividades**:

1. **Dashboard técnico** (SBD):
   - Conectar Metabase (o herramienta similar) a los datos Gold.
   - Crear 5-6 visualizaciones que monitoricen el pipeline:
     - Volumen de datos por capa.
     - Calidad a lo largo del tiempo.
     - KPIs técnicos (latencia, completitud, etc.).
   - Diferenciar explícitamente de un dashboard de negocio.

2. **Predicción simple** (opcional, RA2.d):
   - Si hay serie temporal, añadir una previsión (media móvil).
   - Si hay modelo ML de PIA, conectarlo al dashboard.

3. **(Si aplica) Dashboard de negocio** (BDA):
   - El equipo de BDA crea su propio dashboard con enfoque de negocio.
   - Los datos son los mismos, la perspectiva es distinta.

**Entregable SBD**:

- Dashboard técnico en Metabase (capturas + descripción).
- Justificación de cada visualización: qué mide, por qué es útil.
- Si aplica: predicción añadida al dashboard.

**Cobertura RA/CE**: RA2.c (cuadro de mando), RA2.d (técnicas predictivas),
RA2.e (evaluar impacto), RA4.f (visualizar datos).

---

### Fase 4 — Cierre y presentación (Semana 5)

**Duración**: 1 sesión presencial.

**Actividades**:

1. **Documentación final**:
   - README completo del proyecto.
   - Memoria técnica (2-3 páginas) con:
     - Arquitectura y decisiones.
     - Problemas encontrados y cómo se resolvieron.
     - Métricas de calidad antes/después.
     - Coste y viabilidad estimados.
     - Limitaciones del sistema.
     - Uso de IA: herramientas, prompts relevantes, partes afectadas y verificación.

2. **Presentación** (10-15 min por grupo):
   - Demo del pipeline funcionando.
   - Demo del dashboard.
   - Lecciones aprendidas.

**Entregable SBD**:

- Repositorio completo del proyecto.
- Memoria técnica.
- Declaración final de uso de IA (`plantilla_declaracion_uso_ia.md`).
- Presentación.

---

## Evaluación SBD

### Rúbrica (20 puntos)

| Concepto | Excelente (4) | Bien (3) | Suficiente (2) | Insuficiente (0-1) |
|----------|---------------|----------|----------------|-------------------|
| **Arquitectura** | Medallion clara, justificada, con diagrama | Capas presentes, justificación básica | Capas confusas | Sin arquitectura definida |
| **Ingesta** | 2+ fuentes, reproducible, idempotente | 2 fuentes, reproducible | 1 fuente o no reproducible | No funciona |
| **Calidad** | Métricas antes/después, decisiones justificadas | Métricas presentes | Métricas incompletas | Sin métricas |
| **Procesamiento** | Silver+Gold correctos, joins, KPIs | Transformaciones correctas | Procesamiento básico | Sin transformación |
| **Dashboard** | Técnico, 5+ visualizaciones, interpretación | Técnico, 3-4 visualizaciones | Básico, pocas visualizaciones | Sin dashboard |
| **Documentación** | README, linaje, memoria, presentación, declaración IA si aplica | Falta un elemento menor | Documentación incompleta | No permite reproducir ni defender el trabajo |

**Total: 24 puntos** (se puede escalar a 10).

### RA/CE cubiertos

| RA/CE | Cómo se evalúa en el proyecto |
|-------|------------------------------|
| RA1.a | Elección de herramientas con criterio técnico |
| RA1.b | Extracción de información desde fuentes reales |
| RA1.c | Combinación de 2+ fuentes de distinto tipo |
| RA1.d | Dataset Gold con relaciones entre tablas |
| RA1.e | Planificación del proyecto (lo que planearon vs lo que hicieron) |
| RA1.f | Justificación de herramientas seleccionadas |
| RA1.g | Análisis de coste/calidad/viabilidad en la memoria |
| RA2.c | Dashboard técnico funcional |
| RA2.d | Predicción o previsión en el dashboard (opcional) |
| RA2.e | Reflexión sobre el impacto del sistema |
| RA3.a | Ingesta desde 2+ fuentes a Bronze |
| RA3.b | Uso de formatos eficientes (Parquet, DuckDB) |
| RA3.c | Procesamiento de volúmenes significativos |
| RA3.d | Checklist calidad/RGPD completada |
| RA4.d | Comparativa de herramientas (motores, formatos) |
| RA4.e | Pipeline automatizado y reproducible |
| RA4.f | Visualización técnica en dashboard |

---

## Coordinación con BDA y PIA

### Con Big Data Aplicado

BDA puede tomar los datos Gold generados por SBD y construir:

- Dashboard de negocio con los mismos datos.
- Análisis de tendencias, estacionalidad, segmentación.
- Informe ejecutivo con recomendaciones.

Acordar con el docente de BDA:

- Quién genera los datos Gold (SBD los entrega a BDA).
- Qué tablas/kpis necesita BDA.
- Calendario de entregas para no bloquearse mutuamente.

### Con Programación de la IA

PIA puede tomar los datos Gold/Silver y:

- Entrenar modelos de clasificación, regresión, clustering.
- Generar predicciones que SBD puede consumir en el dashboard (RA2.d).
- Evaluar la calidad de los datos desde la perspectiva de ML.

Acordar con el docente de PIA:

- Qué datos necesita y en qué formato.
- Si las predicciones se integran en el dashboard de SBD.
- Qué metadatos de calidad necesita PIA para confiar en los datos.

---

## Defensa oral sobre uso de IA

Durante la presentación, el docente podrá preguntar sobre cualquier parte donde
se haya usado IA. El objetivo no es pillar al alumnado, sino comprobar que ha
aprendido y que puede defender técnicamente lo entregado.

Preguntas posibles:

1. ¿En qué momento del proyecto usasteis IA y para qué?
2. ¿Qué prompt fue más útil y por qué?
3. ¿Qué respuesta de la IA estaba mal, incompleta o era demasiado genérica?
4. ¿Cómo cambió vuestra solución después de usar IA?
5. ¿Cómo verificasteis el código, SQL o explicación generada?
6. ¿Qué parte del pipeline sabríais rehacer sin IA?
7. ¿Qué decisión técnica final tomó el grupo y no la IA?
8. ¿Qué riesgo habría tenido copiar la respuesta sin revisarla?

Si un estudiante no puede explicar una parte esencial de la entrega, esa parte
no se considerará defendida aunque funcione.

No se exige entregar una especificación formal completa para generar el programa
con IA. Sí se exige que el grupo pueda explicar el camino seguido: problema,
ayuda solicitada, cambios realizados, verificación y aprendizaje.

---

## Posibles temas

| Dominio | Fuente 1 | Fuente 2 | Ejemplo de pregunta |
|---------|----------|----------|---------------------|
| Turismo | Ocupación hotelera por provincia | Afluencia a museos | ¿Hay correlación entre turismo y visitas culturales? |
| Transporte | Bicis públicas (BiciMAD, Bicing) | Calidad del aire | ¿El uso de bicis aumenta cuando mejora el aire? |
| Deportes | Resultados NBA | Estadísticas jugadores | ¿Qué factores predicen mejor las victorias? |
| Meteorología | Datos AEMET históricos | Calidad del aire | ¿Cómo afecta el clima a la contaminación? |
| Economía | IPC por comunidad | Salario medio | ¿Hay relación entre inflación y salarios? |
| Cultura | Programación de cines | Taquilla histórica | ¿Qué género tiene mejor retorno de inversión? |

Más ideas orientativas: `05-recursos/ideas_proyecto.md`.

---

## Recursos

- [Checklist calidad/RGPD/seguridad](../plantillas/plantilla_checklist_calidad_rgpd.md)
- [Plantilla declaración uso de IA](../plantillas/plantilla_declaracion_uso_ia.md)
- [Matriz coste-calidad-viabilidad](../plantillas/plantilla_matriz_coste_calidad_viabilidad.md)
- [Plantilla planificación técnica](../plantillas/plantilla_planificacion_tecnica.md)
- [Rúbrica común SBD](../plantillas/rubrica_comun_SBD_por_RA_CE.md)
- [Ideas orientativas de proyecto](05-recursos/ideas_proyecto.md)

---

## Histórico

| Fecha | Cambio |
|-------|--------|
| 2026-06-18 | Creación del guión del proyecto integrador UD6. |
| 2026-06-19 | Añadida declaración obligatoria de uso de IA y defensa oral asociada. |
| 2026-06-19 | Matizada la exigencia SBD: explicar proceso de IA sin aplicar niveles 0-5. |
| 2026-06-19 | Archivada UD6 antigua y rescatadas ideas útiles como recurso auxiliar. |
| 2026-06-19 | Aclarado que UD6 es un único proyecto final compartido por SBD+BDA+PIA. |
