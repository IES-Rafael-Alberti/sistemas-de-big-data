Perfecto. Aquí tienes el **documento de entrega del Laboratorio 2**, alineado con el Lab 1, **centrado en reflexión técnica**, fácil de corregir y sin pedir cosas irrelevantes (logs infinitos, tiempos exactos, etc.).

Está en **Markdown**, listo para Moodle / GitHub Classroom / PDF.

---

```markdown
# UD3 — Laboratorio 2: Spark frente a pandas
## Documento de entrega del grupo

---

## 1. Datos del grupo

**Grupo nº:**  
**Fecha de entrega:**  

### Integrantes
- Alumno/a 1:
- Alumno/a 2:
- Alumno/a 3:

---

## 2. Objetivo del laboratorio

El objetivo de este laboratorio ha sido:

- Aumentar artificialmente el volumen de datos.
- Procesar el mismo dataset con **pandas** y con **Spark**.
- Observar cómo afecta el volumen al tiempo y a la experiencia de uso.
- Reflexionar sobre **cuándo tiene sentido Spark** y cuándo no.

---

## 3. Dataset utilizado

### Dataset base
- Nombre:
- Número aproximado de filas:
- Tamaño aproximado:

### Dataset inflado
- Factor de inflado aplicado (×10, ×50, ×100…):
- Número aproximado de filas final:
- Tamaño aproximado final:

> Indica también si tuvisteis que reducir el factor por limitaciones del equipo.

---

## 4. Ejecución con pandas

### Resultado general
Describe brevemente cómo ha sido la ejecución con pandas:

- ☐ Rápida y fluida  
- ☐ Lenta pero funcional  
- ☐ Muy lenta / problemática  
- ☐ No se pudo completar  

### Observaciones
Comenta cualquier aspecto relevante:
- consumo de memoria
- tiempo de espera
- bloqueos
- sensación general

> …

---

## 5. Ejecución con Spark

### Modo de ejecución
Marca la opción utilizada:

- ☐ Plan A — Clúster real (varias máquinas)
- ☐ Plan B — Master y Worker en una sola máquina
- ☐ Plan C — Spark local

### Observaciones
Describe cómo se ha comportado Spark con el mismo volumen de datos:

- tiempo aproximado
- estabilidad
- uso de CPU
- diferencias percibidas frente a pandas

> …

---

## 6. Preguntas de reflexión (obligatorias)

Responde de forma clara y razonada a las siguientes preguntas.

---

### 6.1 ¿Qué ha pasado al aumentar el volumen de datos?

Describe cómo ha cambiado el comportamiento del sistema al inflar el dataset.

> …

---

### 6.2 ¿En qué momento pandas empieza a ser incómodo?

No des una cifra exacta: explica **por qué** pandas deja de ser cómodo o práctico.

> …

---

### 6.3 ¿Spark es siempre mejor que pandas? ¿Por qué?

Razona la respuesta teniendo en cuenta:
- tipo de tarea
- volumen
- complejidad
- coste de infraestructura

> …

---

### 6.4 ¿Qué coste tiene usar Spark frente a pandas?

Habla de:
- complejidad técnica
- recursos
- tiempo de preparación
- mantenimiento

> …

---

### 6.5 ¿Qué enfoque usarías en cada caso?

Indica qué herramienta elegirías y por qué:

#### a) Un análisis rápido exploratorio
> …

#### b) Un proceso periódico (diario, semanal…)
> …

#### c) Un volumen de datos muy grande
> …

---

## 7. Comparación final (resumen)

Completa esta tabla con tus conclusiones:

| Aspecto | pandas | Spark |
|------|------|------|
| Facilidad de uso | | |
| Escalabilidad | | |
| Consumo de recursos | | |
| Adecuado para Big Data | | |

---

## 8. Conclusión del grupo

Redacta una conclusión conjunta (5–10 líneas) respondiendo a:

> ¿Qué has aprendido en este laboratorio sobre el uso real de Spark frente a pandas?

> …

---

## 9. Dificultades técnicas (si las hubo)

Indica brevemente:
- problemas encontrados
- cómo los resolvisteis
- si afectaron al resultado final

> …

---

## 10. Valoración del trabajo en grupo (opcional)

- Reparto de tareas:
- Coordinación:
- Qué mejoraríais en el próximo laboratorio:

> …
```

---

## 🧭 Criterio de corrección (para ti)

Este documento te permite evaluar fácilmente:

* ✔ comprensión conceptual (no solo “funciona”)
* ✔ razonamiento técnico
* ✔ conexión con Big Data real
* ✔ honestidad sobre limitaciones del equipo

No penaliza:

* equipos justos
* tiempos más lentos
  si la **reflexión es correcta**.

---

## 🔜 Encaja directamente con

* **Lab 3** → Parquet, particionado y rendimiento
* **Kibana / Zeppelin** → consumo de resultados Spark
* **Airflow** → procesos periódicos

Si quieres, el siguiente paso lógico es:

* **rúbrica específica del Lab 2**,
* o **documento comparativo Lab 1 + Lab 2** para cerrar la UD3.