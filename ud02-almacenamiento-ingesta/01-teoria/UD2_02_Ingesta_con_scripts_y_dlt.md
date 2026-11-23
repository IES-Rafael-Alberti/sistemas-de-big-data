# UD2 · Ingesta con scripts y dlt

La ruta de esta unidad empieza con un script local y continúa con **dlt**, una
librería Python para construir cargas de datos. El material anterior de Airbyte
se conserva en `ud02-almacenamiento-ingesta/90-archivo/airbyte-antiguo/`.
La práctica independiente se ha probado en el equipo docente y sigue
**pendiente de prueba en el entorno del aula**: no implica cambios en tareas ya
publicadas.

## 1. El problema

Un servicio entrega un lote de eventos. Queremos copiarlo, entender qué contiene
y cargarlo en un destino consultable, sin confundir **trasladar datos** con
**garantizar que son correctos**. El origen, el destino, la frecuencia y el
tratamiento de reintentos forman parte del diseño.

- **Carga completa:** se vuelve a procesar el conjunto seleccionado.
- **Carga incremental:** se identifican cambios con un criterio documentado,
  por ejemplo una marca temporal. Hay que considerar registros retrasados,
  actualizaciones y empates en el cursor.
- **Idempotencia:** repetir la operación no produce efectos adicionales no
  deseados. Un nombre fijo o una clave, por sí solos, no la garantizan.
- **Trazabilidad:** registrar qué fuente, versión, reglas y ejecución produjeron
  una salida.

## 2. Script local

En UD1 se simuló una copia de un CSV a `raw/` y su validación:
`ud01-introduccion-big-data/02-ejemplos/ingesta-local/`. Una copia no demuestra
que los datos sean correctos ni que exista una conexión remota. En UD2 podemos
usar Python para leer fuentes, registrar incidencias y escribir en un destino.

## 3. Qué añade dlt

**dlt** es una librería Python para describir recursos y cargarlos a distintos
destinos. Puede gestionar esquemas, cargas y estado, pero es necesario decidir y
comprobar la configuración. En particular:

| Decisión | Pregunta |
|---|---|
| Fuente y recurso | ¿De dónde vienen los registros y qué significa cada uno? |
| Destino | ¿Dónde se guardan y quién podrá consultarlos? |
| Modo de escritura | ¿Añadir, reemplazar o combinar? ¿Qué pasa al repetir? |
| Clave y cursor | ¿Cómo identificamos cada registro y cada cambio? |
| Calidad | ¿Qué comprobaciones se hacen y qué ocurre si fallan? |

Una **clave primaria declarada no convierte por sí sola una carga en merge**.
La combinación `merge` y una clave adecuada permite configurar una estrategia
de actualización/deduplicación en destinos compatibles; debe comprobarse con
datos y reintentos. `replace` reemplaza la tabla y `append` añade registros.
No confundir un cursor incremental con una garantía universal frente a llegadas
tardías o cambios históricos.

## 4. Primera práctica: una fuente pequeña

Seguir `ud02-almacenamiento-ingesta/03-practicas/ingesta-dlt/README.md`: primero
se carga un lote simulado en DuckDB, después se consulta y se repite para
observar el comportamiento de `replace`. Es una **práctica de aula no
evaluable**; no modifica la tarea de integración existente.

La práctica de integración ya disponible en
`ud02-almacenamiento-ingesta/03-practicas/Tareas/005/00-Integracion_y_calidad/05-Integracion_y_calidad-tarea.md`
es un recorrido posterior distinto. Su script y comportamiento incremental deben
validarse antes de impartirlos; no asumir que una clave evita duplicados.

## 5. Eventos y plataformas

Una plataforma como Airbyte ofrece conectores y operación de sincronizaciones;
un script o dlt permiten describir pipelines mediante código. Comparar implica
valorar infraestructura, mantenimiento, conectores y necesidades reales.
**Kafka** es una plataforma de eventos: productores publican mensajes en
*topics* y consumidores los leen; resuelve otro problema y puede convivir con
herramientas de ingesta. La práctica de streaming de UD3 se revisará por separado.

Fuentes: [documentación de dlt](https://dlthub.com/docs) y
[cargas incrementales de dlt](https://dlthub.com/docs/general-usage/incremental-loading).
