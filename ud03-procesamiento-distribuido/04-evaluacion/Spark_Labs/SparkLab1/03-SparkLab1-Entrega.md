# UD3 — Laboratorio 1: Primer contacto con Spark
## Documento de entrega del grupo

> **RA/CE**: RA3.c (almacenar/procesar grandes cantidades),
> RA4.c (almacenamiento distribuido), RA4.e (programar automáticamente).

---

## 1. Datos del grupo

**Grupo:**
**Fecha de entrega:**

### Integrantes
- Alumno/a 1:
- Alumno/a 2:
- Alumno/a 3:

---

## 2. Objetivo del laboratorio

El objetivo de este laboratorio ha sido:

- Poner en marcha Apache Spark.
- Ejecutar un primer procesamiento distribuido.
- Comprender el modelo **Master / Worker**.
- Comparar conceptualmente Spark con pandas.

---

## 3. Entorno de ejecución utilizado

Marca la **opción final** que ha utilizado el grupo:

- ☐ **Plan A** — Clúster real (varias máquinas)
- ☐ **Plan B** — Master y Worker en una sola máquina
- ☐ **Plan C** — Spark en modo local (`local[*]`)

### Breve justificación
Explica por qué habéis usado esa opción (red, equipo, problemas técnicos, etc.):

> …

---

## 4. Configuración básica del entorno

### Versión de Spark utilizada
- Apache Spark: **3.5.4**

### Rol de cada integrante
Indica qué rol ha tenido cada miembro del grupo:

- Alumno/a 1: ☐ Master ☐ Worker
- Alumno/a 2: ☐ Master ☐ Worker
- Alumno/a 3: ☐ Master ☐ Worker

(Si ha habido cambios de rol, indícalo brevemente).

---

## 5. Dataset utilizado

- Nombre del fichero:
- Tipo de datos:
- Número aproximado de filas:
- Columnas principales:

> …

---

## 6. Descripción del procesamiento realizado

Resume **qué hace el programa Spark ejecutado** (`lab1_job.py`), en tus propias palabras:

- Lectura de datos:
- Filtro aplicado:
- Agrupación realizada:
- Métricas calculadas:
- Tipo de salida generada:

> …

(No es necesario copiar código).

---

## 7. Problemas encontrados y cómo se resolvieron

Describe brevemente los problemas técnicos encontrados durante el laboratorio y cómo los solucionasteis.

Ejemplos:
- Problemas de red
- Problemas con Docker
- Workers que no conectaban
- Rutas incorrectas
- Otros

| Problema | Solución aplicada |
|--------|-------------------|
|        |                   |
|        |                   |

---

## 8. Observaciones sobre Spark

Responde brevemente a las siguientes cuestiones:

### 8.1 ¿En qué se parece Spark a pandas?
> …

### 8.2 ¿En qué se diferencia Spark de pandas?
> …

### 8.3 ¿Qué ventaja principal aporta Spark en este laboratorio?
> …

### 8.4 ¿Crees que Spark sería necesario para este dataset concreto? ¿Por qué?
> …

---

## 9. Evidencias de ejecución

Incluye **al menos una** de las siguientes evidencias:

- ☐ Captura de la UI de Spark Master (`:8080`)
- ☐ Captura de la ejecución del `spark-submit`
- ☐ Captura del resultado generado (`output/ventas_por_ciudad`)

(Pega aquí las imágenes o enlázalas).

---

## 10. Conclusión del grupo

Redacta una breve conclusión (5–8 líneas) respondiendo a:

> ¿Qué has aprendido sobre Spark y el procesamiento distribuido en este laboratorio?
(Cada miembro del equipo explica brevemente lo que ha aprendido)
> …

---

## 11. Valoración del trabajo en grupo (opcional)

- Reparto de tareas:
- Dificultades de coordinación:
- Qué mejoraríais en el próximo laboratorio:

> …
