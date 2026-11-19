# Ingesta local de eventos de un servicio web

## Situación y propósito

Un servicio web registra peticiones; al final del día recibimos un CSV para
analizar su funcionamiento. Antes de calcular tiempos, necesitamos conservar una
copia de lo recibido y comprobar si faltan datos. Simularemos la transferencia
con archivos locales: no hay servidor, API, cola ni datos reales.

Una **ingesta** captura y traslada datos de una fuente a un destino para poder
procesarlos. En este ejemplo el origen es `lecturas_servicio.csv` y el destino
`raw/lecturas_servicio.csv`. La copia *raw* conserva el contenido recibido; no
significa que ya esté limpio. Después se pueden validar y transformar los datos
en otra zona, sin perder la copia original.

## Datos

El CSV físico contiene ocho peticiones sintéticas. Cada fila es una petición:

| Columna | Significado |
|---|---|
| `evento_id` | Identificador simulado de la petición. |
| `fecha` | Fecha de la petición, en formato año-mes-día. |
| `servicio` | Parte de la web consultada. |
| `estado_http` | Código HTTP simulado; por ejemplo 200 o 503. |
| `duracion_ms` | Tiempo de respuesta en milisegundos; puede faltar. |

Pregunta antes de ejecutar: ¿cuántas filas tienen duración ausente? ¿Se puede
calcular su tiempo medio sin decidir qué hacer con esos valores?

## Conceptos mínimos

- **Batch:** se capturan y procesan datos agrupados, por ejemplo el fichero de un
  día. **Micro-batch:** lotes más pequeños y frecuentes. **Streaming:** eventos
  procesados de forma continua o casi continua. La elección depende de frescura,
  costes y requisitos, no de que uno sea siempre mejor.
- **ETL:** extraer, transformar y cargar en el destino. **ELT:** extraer, cargar
  y transformar después en el entorno de destino. Son patrones, no productos.
- **Carga completa:** se vuelve a traer el conjunto seleccionado. **Incremental:**
  se traen cambios nuevos según un criterio; exige gestionar modificaciones,
  retrasos y repeticiones. No la implementamos aquí.
- **Idempotencia:** repetir una operación no debe causar efectos adicionales
  indebidos. Rechazar una sobrescritura ayuda a proteger el archivo, pero por sí
  solo no resuelve reintentos, datos cambiados ni cargas incrementales.
- **Observabilidad y linaje:** registrar origen, destino, momento, filas y
  errores ayuda a explicar qué llegó y a reconstruir el proceso.

## Practicar

1. Copia **esta carpeta completa** a tu espacio de trabajo. Necesitas Python 3;
   no necesitas red ni bibliotecas adicionales. No trabajes sobre la copia del
   profesor.
2. Abre `lecturas_servicio.csv` y responde a la pregunta sobre datos ausentes.
3. Desde la carpeta copiada, ejecuta `python ingestar.py`. Comprueba que existe
   `raw/lecturas_servicio.csv` y que el programa indica contenido igual.
4. Ejecuta `python validar.py`. Interpreta filas, duraciones presentes y
   ausentes. La validación solo lee: no corrige ni elimina datos.
5. Ejecuta otra vez `python ingestar.py`. ¿Qué mensaje aparece? ¿Se
   sobrescribe la captura? ¿Qué pasaría si el origen cambiase?
6. Crea `registro_ingesta.md` con origen, destino, fecha de ejecución, resultados,
   una decisión para tratar las ausencias posteriormente y una limitación.
   Propón una segunda comprobación, por ejemplo un dominio de códigos HTTP.

**Resultado esperado:** ocho filas, dos duraciones ausentes y seis presentes.
El segundo intento avisa y conserva la copia, incluso si el origen ha cambiado:
no compara automáticamente versiones ni crea una nueva captura.

## Límites y continuidad

Esta práctica es formativa: no añade una entrega evaluable. La copia local no
demuestra conexión con sistemas reales, procesamiento continuo, recuperación
frente a fallos ni capacidad distribuida. En UD2 se trabajarán conectores,
almacenamiento y pipelines más completos.
