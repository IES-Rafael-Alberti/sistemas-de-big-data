# Checklist de calidad, RGPD, seguridad y uso de IA

> **Propósito**: Checklist transversal para que el alumnado verifique que su
> práctica o proyecto cubre los mínimos de calidad, normativa, seguridad y uso
> transparente de IA antes
> de entregar. Aplicable a cualquier práctica con datos.
>
> **RA/CE**: RA3.d (sistemas eficientes, seguros, normativa), RA1.g (coste/calidad).

---

## 1. Calidad de datos

### 1.1 Antes del tratamiento

- [ ] Se ha documentado el **esquema** de cada fuente: columnas, tipos, nulos esperados.
- [ ] Se ha medido la **completitud** inicial (% no nulos por columna).
- [ ] Se ha verificado la **unicidad** de la clave primaria.
- [ ] Se han identificado **valores fuera de dominio** (negativos en importes, fechas futuras, etc.).
- [ ] Se ha calculado el **volumen** inicial (filas, tamaño, rango temporal).

### 1.2 Durante el tratamiento

- [ ] Todas las decisiones de **limpieza** están justificadas por escrito (eliminar, imputar, etiquetar).
- [ ] Los **tipos** de datos son correctos (fechas como fecha, números como número).
- [ ] Se ha normalizado la **codificación** de categóricas (mayúsculas/minúsculas, espacios, sinónimos).
- [ ] Se ha verificado la **consistencia entre columnas** (p.ej., importe ≈ unidades × precio).
- [ ] Los **outliers** se han detectado con un método objetivo (IQR, Z-score) y se ha decidido su tratamiento.

### 1.3 Después del tratamiento

- [ ] Se han recalculado las métricas de calidad y se muestra la **mejora** (Δ puntos porcentuales).
- [ ] El dataset final está en un **formato eficiente** (Parquet recomendado) con **compresión**.
- [ ] El dataset está **particionado** por columnas de filtrado frecuente (fecha, región, etc.).
- [ ] Se ha generado un **reporte de calidad** (`quality_report.json`) junto a los datos.
- [ ] Las métricas de calidad cumplen los **umbrales aceptables** definidos al inicio.

---

## 2. RGPD y privacidad

> **Regla transversal desde UD2**: en cualquier práctica o proyecto donde se
> procesen datos, el alumnado debe aplicar un proceso de anonimización:
>
> 1. Buscar datos personales e identificadores directos o indirectos.
> 2. Si no hay, documentar: **“Anonimización completada: no se han detectado
>    datos personales ni identificadores directos o indirectos”**.
> 3. Si los hay o podría haberlos, anonimizar, seudonimizar, agregar, generalizar
>    o eliminar columnas hasta que el dataset quede listo para publicar, compartir
>    o explotar sin identificar a personas.

El objetivo no es rellenar burocracia: es adquirir el hábito profesional de no
filtrar información que pueda identificar a una persona directa o indirectamente.
Las sanciones por filtraciones de datos personales pueden ser muy elevadas.

- [ ] Se han buscado **datos personales directos** (DNI, email, teléfono, nombre, usuario, IP, etc.).
- [ ] Se han revisado posibles **identificadores indirectos** (combinaciones de fecha, ubicación, edad, código postal, centro, usuario, IP, etc.).
- [ ] Si no se han encontrado identificadores, se ha documentado que la anonimización queda completada por ausencia de datos personales.
- [ ] Si se han encontrado identificadores, se ha aplicado **anonimización, seudonimización, agregación, generalización o eliminación** hasta dejar el dataset listo.
- [ ] Se ha comprobado que el resultado final no permite identificar a una persona directa ni indirectamente.
- [ ] Se ha documentado qué columnas se eliminan, generalizan, enmascaran, agregan o sustituyen por identificadores no reversibles.
- [ ] No hay **secretos** (.env, tokens, contraseñas) en el repositorio ni en los scripts.
- [ ] El `.env` o fichero de configuración está en `.gitignore`.
- [ ] Los datos se almacenan con **acceso restringido** (permisos de fichero, no públicos).
- [ ] Se ha documentado la **base legal** del tratamiento (consentimiento, interés legítimo, etc.) si aplica.
- [ ] Se ha definido un **periodo de retención** y una estrategia de borrado.

---

## 3. Seguridad y buenas prácticas

- [ ] El pipeline es **idempotente**: ejecutarlo N veces produce el mismo resultado final.
- [ ] El procesamiento es **reproducible**: cualquiera puede ejecutarlo y obtener el mismo resultado.
- [ ] Los scripts no usan **rutas absolutas** del desarrollador (usar rutas relativas o variables de entorno).
- [ ] Se ha documentado el **entorno** necesario (Python version, librerías, sistema operativo).
- [ ] Hay un `requirements.txt` o `environment.yml` para reproducir el entorno.
- [ ] Las contraseñas y tokens se leen de **variables de entorno**, no están hardcodeadas.
- [ ] Los datos raw originales se conservan **inmutables** (no se modifican, solo se leen).

---

## 4. Documentación

- [ ] README con: objetivo, fuentes, arquitectura, decisiones técnicas, resultados.
- [ ] **Linaje de datos**: diagrama o texto que muestre el flujo raw → proceso → final.
- [ ] Las decisiones controvertidas tienen una **nota** explicando el por qué.
- [ ] El informe incluye **métricas antes/después** y una reflexión sobre el impacto de las decisiones.
- [ ] Se ha diferenciado entre **dashboard técnico** (SBD) y **dashboard de negocio** (BDA).

---

## 5. Uso de IA generativa

- [ ] Se ha indicado explícitamente si se ha usado IA generativa o no.
- [ ] Si se ha usado, se ha entregado la **declaración de uso de IA**.
- [ ] Se han registrado herramientas/modelos usados (ChatGPT, Claude, Gemini, Copilot, modelo local, etc.).
- [ ] Se han resumido o incluido los prompts relevantes.
- [ ] Se ha explicado qué partes fueron generadas, sugeridas, corregidas o depuradas con IA.
- [ ] Se ha explicado el **proceso seguido**: cuándo se usó IA, para qué, qué cambió y qué se comprobó.
- [ ] El alumnado ha verificado el código/texto producido con ayuda de IA.
- [ ] No se han introducido credenciales, datos personales o información sensible en herramientas externas de IA.
- [ ] El grupo puede defender oralmente las partes en las que recibió ayuda de IA.

Plantilla recomendada: `00-planificacion/plantillas/plantilla_declaracion_uso_ia.md`.

---

## 6. Checklist rápido para el docente

```
[  ] Esquema documentado         [  ] Completitud medida
[  ] Tipos correctos             [  ] Sin secretos en repo
[  ] Pipeline idempotente        [  ] Formato eficiente (Parquet)
[  ] Métricas antes/después      [  ] Particionado justificado
[  ] Sin datos personales        [  ] README completo
[  ] Linaje documentado          [  ] Reproducible
[  ] Uso de IA declarado         [  ] IA verificada/defendible
```

---

## Histórico

| Fecha | Cambio |
|-------|--------|
| 2026-06-18 | Creación de la checklist transversal calidad/RGPD/seguridad. |
| 2026-06-19 | Añadido bloque de uso transparente de IA. |
| 2026-06-19 | Añadida comprobación del proceso seguido con IA. |
| 2026-06-19 | Añadida regla transversal de privacidad/anonimización desde UD2. |
