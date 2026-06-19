# Prompt para mejorar contenidos de Sistemas de Big Data tras alineación curricular

## Objetivo

Diseñar una propuesta de mejora del contenido de **Sistemas de Big Data** para el curso 2026/2027 después de la alineación curricular con **Big Data Aplicado**.

La idea es:

1. Mantener y reforzar lo que encaja claramente en Sistemas de Big Data.
2. Marcar qué contenidos pasan a ser candidatos de Big Data Aplicado.
3. Proponer contenido nuevo o sustituciones para cubrir huecos en Sistemas de Big Data.
4. Mantener el curso coherente con los RA/CE obligatorios de Sistemas de Big Data.
5. Ajustar las herramientas a la práctica actual, sin caer en tecnologías obsoletas salvo como contexto conceptual.

No borres, muevas ni edites materiales en esta fase.

Sólo genera una propuesta documentada.

## Directorio de trabajo

Trabaja sobre la copia reorganizada:

`./`

Crea la salida dentro de:

`00-planificacion/`

## Entradas obligatorias

Usa como fuentes principales:

- `00-planificacion/SistemasDeBIG_DATA-RAs_CE.md`
- `00-planificacion/BigDataAplicado-RAs_CE.md`
- `00-planificacion/matriz_alineacion_curricular_sbd_bigdata_aplicado.md`
- `00-planificacion/herramientas_usadas_curso.md`
- `00-planificacion/inventario_material_sbd.md`
- `00-planificacion/INFORME_REORGANIZACION_FINA.md`

Puedes consultar los README de cada unidad y materiales concretos si necesitas más contexto.

## Principio rector

Los **RA y CE de Sistemas de Big Data** mandan.

El objetivo no es dejar el módulo vacío por mover contenidos a Big Data Aplicado, sino mejorar su identidad:

- Sistemas.
- Arquitecturas.
- Integración.
- Procesamiento.
- Almacenamiento.
- Calidad.
- Visualización técnica.
- Selección razonada de herramientas.
- Coste, viabilidad y calidad de sistemas Big Data.

Si un contenido se marca como candidato a Big Data Aplicado, debes proponer qué queda en SBD para cubrir el RA/CE correspondiente.

## Criterios importantes

- No sustituyas contenido útil sólo porque use una herramienta antigua.
- Hadoop/HDFS puede quedar como base conceptual o comparativa histórica, pero no debe dominar la práctica si Spark/PySpark u otras herramientas actuales evidencian mejor el RA/CE.
- Spark/PySpark/Spark MLlib pueden ser sustitutos prácticos razonables de parte del ecosistema Hadoop clásico.
- Las herramientas cloud deben evaluarse por coste, acceso educativo y riesgo de facturación.
- AWS Academy o tiers gratuitos pueden permitir prácticas parciales, pero no todo lo deseable.
- Las prácticas deben ser viables en aula real, no sólo bonitas en el papel.
- Si una herramienta o práctica requiere demasiada infraestructura, propón una alternativa más ligera.

## Qué debes producir

Genera este archivo:

`00-planificacion/propuesta_mejora_contenidos_sbd.md`

## Estructura obligatoria del informe

```md
# Propuesta de mejora de contenidos — Sistemas de Big Data 2026/2027

## 1. Resumen ejecutivo

Explica:

- Qué se mantiene como núcleo de SBD.
- Qué se desplaza o queda como candidato a Big Data Aplicado.
- Qué huecos aparecen en SBD.
- Qué contenidos nuevos conviene crear.
- Qué herramientas conviene mantener, sustituir o contextualizar.

## 2. Identidad curricular propuesta para SBD

Define en pocas líneas qué debe ser Sistemas de Big Data después de separar mejor Big Data Aplicado.

## 3. Mapa RA/CE de Sistemas de Big Data

| RA/CE SBD | Cobertura actual | Materiales actuales | Problema detectado | Mejora propuesta | Prioridad |
| --------- | ---------------- | ------------------- | ------------------ | ---------------- | --------- |

Prioridades:

- `alta`
- `media`
- `baja`

## 4. Contenidos que se mantienen y se refuerzan

| Bloque | Materiales actuales | Por qué se mantiene | Mejora recomendada |
| ------ | ------------------- | ------------------- | ------------------ |

## 5. Contenidos candidatos a Big Data Aplicado y sustitución en SBD

| Contenido/material candidato a BDA | Motivo | RA/CE SBD que deja hueco | Sustitución o refuerzo propuesto para SBD | Acción recomendada |
| --------------------------------- | ------ | ------------------------ | --------------------------------------- | ------------------ |

Acciones recomendadas:

- `mantener_resumen_en_sbd`
- `duplicar_y_adaptar_para_bda`
- `mover_en_fase_posterior`
- `crear_sustituto_sbd`
- `dejar_como_ampliacion`

## 6. Contenido nuevo recomendado para SBD

| Nuevo contenido | RA/CE SBD que cubre | Tipo | Herramientas sugeridas | Justificación | Prioridad |
| --------------- | ------------------- | ---- | ---------------------- | ------------- | --------- |

Tipos:

- teoría breve
- práctica guiada
- laboratorio
- checklist
- dataset
- rúbrica
- proyecto corto
- recurso profesor

## 7. Herramientas recomendadas para SBD

| Herramienta | Papel en SBD | Estado | Motivo | Alternativa si falla |
| ----------- | ------------ | ------ | ------ | -------------------- |

Estados:

- `principal`
- `apoyo`
- `contexto histórico`
- `pendiente de viabilidad`
- `mejor para BDA`

## 8. Propuesta de estructura revisada por unidades

Para cada unidad indica:

- foco de la unidad,
- materiales que se mantienen,
- materiales que se reducen o pasan a ampliación,
- materiales nuevos a crear,
- evaluación sugerida.

## 9. Backlog accionable

| Tarea | Unidad | Tipo | Prioridad | Resultado esperado |
| ----- | ------ | ---- | --------- | ------------------ |

## 10. Riesgos y decisiones pendientes

Incluye:

- riesgos de coste/cloud,
- herramientas dudosas,
- exceso de contenido,
- dependencias entre SBD y Big Data Aplicado,
- decisiones que debe tomar el profesor.
```

## Reglas de salida

- Sé práctico.
- No hagas una defensa burocrática de la normativa.
- Usa RA/CE como ancla obligatoria.
- Propón mejoras realistas para aula.
- No propongas crear contenido nuevo si antes se puede adaptar material existente.
- Marca claramente lo que requiere decisión docente.
- No ejecutes cambios físicos; sólo genera la propuesta.
