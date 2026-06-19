# Plantilla — Matriz de coste, calidad y viabilidad

> **Propósito**: Evaluar y comparar alternativas técnicas para un sistema Big Data
> usando criterios objetivos de coste, calidad, escalabilidad y viabilidad en aula.
>
> **RA/CE asociado**: RA1.g — "Se han determinado criterios de coste y calidad
> necesarios para la eficacia y eficiencia de la implementación de un sistema Big Data."
>
> **Uso**: Plantilla transversal válida para UD2 (almacenamiento/ingesta),
> UD6 (proyecto integrador) y cualquier ejercicio de selección razonada de herramientas.

---

## Instrucciones de uso

1. Seleccionar 2-4 alternativas a comparar (herramientas, plataformas, enfoques).
2. Para cada criterio, asignar una valoración **1-5** y una **justificación breve**.
3. Marcar la Columna "Peso" según la importancia relativa del criterio en el contexto del problema (Alto/Medio/Bajo).
4. Completar la **tabla resumen** al final.
5. Responder las **preguntas de reflexión**.

---

## Criterios

| ID  | Criterio            | Qué valorar                                                                 | Peso por defecto |
| --- | ------------------- | --------------------------------------------------------------------------- | ---------------- |
| C1  | Coste económico     | Licencias, cloud, límites gratuitos, infraestructura necesaria              | Alto             |
| C2  | Coste operativo     | Instalación, mantenimiento, cuentas, permisos, curva de aprendizaje         | Alto             |
| C3  | Calidad de datos    | Validaciones, trazabilidad, reproducibilidad, control de versiones          | Alto             |
| C4  | Escalabilidad       | Volumen máximo soportado, crecimiento horizontal/vertical, límites conocidos | Medio            |
| C5  | Seguridad / RGPD    | Datos personales, control de acceso, ubicación, cifrado, anonimización      | Medio            |
| C6  | Viabilidad en aula  | Tiempo de configuración, equipos, conectividad, fiabilidad, soporte         | Alto             |
| C7  | Encaje curricular   | RA/CE que cubre, módulo donde corresponde, competencias asociadas           | Medio            |

---

## Matriz de comparación

| Alternativa | C1 (Peso: __) | C2 (Peso: __) | C3 (Peso: __) | C4 (Peso: __) | C5 (Peso: __) | C6 (Peso: __) | C7 (Peso: __) | Total |
| ----------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ----- |
|             | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   |       |
|             | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   |       |
|             | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   |       |
|             | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   | V: _ / J: _   |       |

**Leyenda**: V = Valoración (1-5), J = Justificación breve.
**Total**: Suma ponderada de valoraciones según el peso asignado a cada criterio.

---

## Ejemplo resuelto: Comparativa de motores de procesamiento

Contexto: equipo de 2-3 alumnos, portátiles con 8-16 GB RAM, sin acceso cloud,
dataset de ~5 GB, necesidad de SQL analítico y transformaciones.

| Alternativa | C1 Coste económico (Alto) | C2 Coste operativo (Alto) | C3 Calidad datos (Medio) | C4 Escalabilidad (Medio) | C5 Seguridad (Bajo) | C6 Viabilidad aula (Alto) | C7 Encaje curricular (Medio) | Total |
| ----------- | ------------------------- | ------------------------- | ------------------------ | ------------------------ | ------------------- | ------------------------- | ---------------------------- | ----- |
| **pandas**  | V: 5 / J: Gratuito, Open Source | V: 5 / J: Ya instalado, conocido | V: 3 / J: En memoria, sin trazabilidad automática | V: 2 / J: Monohilo, 5 GB puede no caber | V: 3 / J: Depende del script | V: 5 / J: Sin instalación extra | V: 4 / J: Cubre RA1.b-d | 4.3 |
| **DuckDB**  | V: 5 / J: Gratuito, Open Source | V: 4 / J: pip install, SQL directo | V: 5 / J: Trazabilidad SQL, reproducible | V: 3 / J: Local, soporta > RAM con paralelismo | V: 3 / J: Datos locales | V: 4 / J: pip + extensión Parquet | V: 5 / J: Cubre RA1.g directamente | 4.4 |
| **Spark/PySpark** | V: 4 / J: Gratuito pero requiere Java | V: 2 / J: Configuración Java + Spark, pesado | V: 4 / J: DataFrame API trazable | V: 5 / J: Distribuido, escala bien | V: 4 / J: Seguridad por config | V: 2 / J: Java requerido, fricción en aula | V: 5 / J: Cubre RA1.c-g, RA3.d | 3.7 |

**Conclusión del ejemplo**: DuckDB ofrece el mejor equilibrio coste-calidad-viabilidad
para un escenario local con dataset mediano. Spark se justifica cuando el volumen
supera la memoria local o se necesita procesamiento distribuido como aprendizaje
curricular.

---

## Preguntas de reflexión

1. **¿Qué criterio ha tenido más peso en tu decisión? ¿Por qué?**
2. **¿Cambiaría la decisión si el presupuesto fuera mayor o menor?**
3. **¿Qué alternativa es más sostenible a 1-2 años vista?**
4. **¿Cómo afecta la elección a la calidad y trazabilidad de los datos?**
5. **¿Qué alternativa recomendarías a un equipo sin experiencia técnica? ¿Y a uno experto?**
6. **¿Cómo justificarías tu elección ante un responsable de proyecto?**

---

## Rúbrica de evaluación (para el docente)

| Nivel      | Descripción |
| ---------- | ----------- |
| Excelente (4) | Matriz completa con todas las alternativas valoradas, justificaciones coherentes, reflexión crítica que muestra comprensión de los trade-offs. |
| Notable (3)   | Matriz completa, justificaciones presentes pero genéricas, reflexión adecuada. |
| Aprobado (2)  | Matriz parcialmente completa, justificaciones superficiales o copiadas del ejemplo. |
| Insuficiente (1) | Matriz incompleta, sin justificaciones, sin reflexión. |

---

## Histórico de cambios

| Fecha       | Cambio |
| ----------- | ------ |
| 2026-06-18 | Creación inicial de la plantilla transversal. |
