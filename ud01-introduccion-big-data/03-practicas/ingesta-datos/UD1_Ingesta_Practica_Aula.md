# UD1 · Ingesta de datos — práctica de aula

**SBD · jueves 19 de noviembre de 2026 · 120 minutos · trabajo en parejas**

Este documento acompaña la sesión de ingesta. No es una entrega evaluable: es
material de trabajo para seguir la clase. La mini-práctica P5 de la guía de
ingesta **no** forma parte de esta sesión.

## De qué va la sesión

Un servicio web registra cada petición que recibe y al final del día entrega un
CSV. Antes de analizarlo necesitamos:

1. **conservar** una copia de lo recibido, sin tocarlo;
2. **comprobar** qué contiene: filas, duraciones, ausencias;
3. **decidir** qué hacer al repetir la carga.

Simularemos la transferencia con archivos locales: no hay servidor, ni API, ni
cola de mensajes, ni datos reales.

**Idea clave:** una copia *raw* conserva lo recibido, pero **no** significa que
los datos ya estén limpios ni validados.

## Antes de empezar

1. Descarga de Moodle el archivo `ingesta_clase.zip` y descomprímelo en tu
   espacio de trabajo. Debe quedar una carpeta `ingesta-local/`.
2. Renómbrala a `ingesta_clase/` si quieres seguir las instrucciones al pie de
   la letra.
3. Comprueba que tienes Python 3:

   ```bash
   python --version
   ```

   No hacen falta pandas, DuckDB, conexión ni instalaciones adicionales.
4. Trabaja **siempre** sobre tu copia. No modifiques la carpeta del profesor ni
   los datos de P3.

## Materiales

| Archivo | Para qué sirve |
|---|---|
| `lecturas_servicio.csv` | Fichero recibido del servicio: 8 peticiones. |
| `ingestar.py` | Copia el fichero a `raw/lecturas_servicio.csv`. |
| `validar.py` | Cuenta filas y duraciones ausentes. Solo lee. |
| `README.md` | Contexto ampliado y ejercicios del ejemplo. |

Columnas del CSV:

| Columna | Significado |
|---|---|
| `evento_id` | Identificador simulado de la petición. |
| `fecha` | Fecha de la petición, formato año-mes-día. |
| `servicio` | Parte de la web consultada. |
| `estado_http` | Código HTTP simulado, por ejemplo 200 o 503. |
| `duracion_ms` | Tiempo de respuesta en milisegundos. Puede faltar. |

Cada fila es **una petición**, no un usuario ni una sesión.

## Parte 1 · Ingerir un fichero (≈55 minutos)

### Paso 1 · Entender qué es ingerir

Antes de ejecutar nada, responde por parejas:

- ¿Qué puede salir mal si transformamos directamente el único original?
- ¿Para qué sirve guardar una copia que todavía puede tener errores?

Flujo del día:

```text
fichero de origen  →  copia raw  →  validación y transformación posterior
```

### Paso 2 · Observar la demostración

El profesor hará la misma operación con otro fichero. Fíjate en tres cosas:

- se crea `raw/` si no existe;
- se abre el destino en modo `xb`, que **no sobrescribe**;
- se compara byte a byte el origen y la copia.

### Paso 3 · Ejecutar la ingesta

Desde dentro de `ingesta_clase/`:

```bash
python ingestar.py
```

**Comprueba que:**

- existe `raw/lecturas_servicio.csv`;
- el programa indica que el contenido es igual;
- el fichero de origen sigue existiendo y no ha cambiado.

Si aparece **«La captura ya existe»**, no borres nada: lo trataremos en la
Parte 2. Si el programa no encuentra el fichero, revisa desde qué carpeta lo
estás ejecutando.

### Paso 4 · Documentar la llegada

Crea el fichero `registro_ingesta.md` con:

```markdown
# Registro de ingesta

- Origen:
- Destino:
- Qué representa una fila:
- Fecha y hora de ejecución:
- Resultado de la comparación:
```

Añade una frase respondiendo a: **si el origen cambia mañana, ¿cómo sabríais qué
versión analizasteis?** Basta con proponerlo; no hay que implementarlo.

### Paso 5 · Puesta en común

Dos parejas explican su origen, su destino y una limitación. Antes de parar,
guarda `ingestar.py`, `lecturas_servicio.csv`, `raw/lecturas_servicio.csv` y el
registro: los necesitas en la Parte 2.

## Descanso (≈5 minutos)

Guarda la carpeta de trabajo. No cierres la terminal.

## Parte 2 · Validar la ingesta y controlar repeticiones (≈60 minutos)

### Paso 6 · Separar capturar de validar

Una copia idéntica al origen puede contener errores. Pregunta: **¿es correcto
borrar un registro solo porque falte una duración?**

Hoy no borramos nada: contamos y decidimos.

### Paso 7 · Contar sin modificar

```bash
python validar.py
```

**Comprueba que:**

- el programa se ha ejecutado sobre `raw/`, no sobre el original;
- muestra el número de filas y de duraciones ausentes;
- no ha cambiado ningún archivo.

Resultado esperado con la muestra del profesor: **8 filas y 2 duraciones
ausentes**. Si te sale otra cosa, revisa qué copia estás usando; no cambies el
número para que cuadre.

### Paso 8 · Registrar una decisión

Añade al `registro_ingesta.md`:

```markdown
- Filas leídas:
- Duraciones presentes:
- Duraciones ausentes:
- Completitud: presentes / total = … %
- Decisión propuesta para las ausencias:
- Segundo control propuesto y por qué:
```

Orientación para la completitud: 6 de 8 es el **75 %**. El porcentaje es tuyo,
pero el denominador debe estar explicado.

### Paso 9 · Repetir sin sobrescribir

Predice qué pasará y vuelve a ejecutar:

```bash
python ingestar.py
```

¿Se sobrescribe la captura? ¿Qué mensaje aparece? ¿Qué pasaría si el origen
hubiera cambiado?

**Aviso conceptual:** rechazar una sobrescritura protege el archivo, pero **no**
es idempotencia completa. Una ingesta idempotente debe definir qué hacer con
reintentos y con cambios de origen sin producir duplicados.

### Paso 10 · Puesta en común y cierre

Dos parejas comparten una incidencia y una decisión. Guarda código y registro.

## Ejercicios del ejemplo (para continuar)

Todos están en el `README.md` de la carpeta:

1. Abre el CSV y responde cuántas filas tienen duración ausente.
2. Ejecuta `ingestar.py` y comprueba la copia.
3. Ejecuta `validar.py` e interpreta los conteos.
4. Repite la ingesta y explica el mensaje.
5. Propón un segundo control, por ejemplo un dominio de códigos HTTP.

## Para pensar durante la sesión

- **Batch / micro-batch / streaming:** ¿cuál encaja aquí y por qué?
- **ETL / ELT:** ¿en qué orden hacemos nosotros las cosas?
- **Incremental:** ¿qué necesitaríamos para no volver a traer todo?
- **Linaje:** ¿qué datos mínimos permiten reconstruir qué pasó?

## Límites

Esta práctica es una **simulación local**:

- no demuestra conexión con sistemas reales;
- no prueba procesamiento continuo;
- no cubre recuperación frente a fallos;
- no mide capacidad ni rendimiento.

Los conectores reales, el almacenamiento y los pipelines completos se trabajan
en UD2.

## Antes de irte

- [ ] Tengo mi carpeta `ingesta_clase/` con `raw/lecturas_servicio.csv`.
- [ ] He ejecutado `ingestar.py` y `validar.py`.
- [ ] Mi `registro_ingesta.md` explica origen, destino, conteos y una decisión.
- [ ] No he borrado ni modificado el CSV original.
- [ ] Puedo explicar la diferencia entre capturar y validar.

## Continuidad

Lo aprendido aquí enlaza con UD2:

- vocabulario y decisiones mínimas sobre formatos y partición;
- plantilla de validación y publicación a Parquet;
- hábitos de logs, linaje y RGPD para pipelines que crecerán.
