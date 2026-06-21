# Práctica "Herramientas reales": Airbyte + AWS Academy

> **Propósito**: Contraste curricular — los mismos conceptos ELT que ya practicaron con dlt,
> ahora con herramientas del mundo real. Optativo, no evaluable.
>
> Docente: Airbyte se asume ya instalado en un servidor Proxmox. Antes de
> impartir UD2 solo hay que validar acceso, conectores y destino Postgres.
> AWS Academy se deja preparado, aunque su ejecución dependerá de permisos y
> disponibilidad del laboratorio.

---

## Estructura

| Documento | Contenido |
|-----------|-----------|
| `airbyte-comparativa.md` | Práctica Airbyte GUI con destino Postgres. Comparación con dlt. |
| `aws-ingesta-serverless.md` | Práctica AWS S3 + Glue + Athena. Contraste cloud ELT. |
| `README.md` (este) | Visión general + notas de montaje para el docente. |

## Prerrequisitos

### Airbyte (servidor Proxmox)

Airbyte **no se instala durante la práctica**. Se parte de un servidor Proxmox
ya preparado por el docente o el departamento.

Validación mínima antes de clase:

- URL accesible desde el aula: `http://<ip-o-dominio>:8000` o la ruta definida.
- Credenciales de acceso preparadas para alumnado o grupos.
- Conectores disponibles: **File** como origen y **Postgres** como destino.
- Volumen o ruta accesible para los CSV/JSONL de la práctica Medallion, o bien
  alternativa HTTP/S3 si el conector File no puede leer ficheros locales.
- Postgres accesible desde Airbyte con base de datos, usuario y esquema creados.

Configuración recomendada de Postgres:

| Campo | Valor orientativo |
|-------|-------------------|
| Host | IP/nombre del servidor Postgres visible desde Airbyte |
| Port | `5432` |
| Database | `sbd_airbyte` |
| Username | `airbyte_sbd` |
| Default schema | `bronze` |
| SSL mode | `disable` en red local controlada; `require` si hay exposición de red |

> Usar un usuario dedicado, no el superusuario `postgres`. Es más realista y
> evita que una práctica de aula tenga privilegios innecesarios.

### AWS Academy

- Laboratorios AWS Academy preparados o solicitados para el módulo SBD.
- Acceso a consola AWS con permisos para S3, Glue, Athena (IAM básico).
- Alumnos: cada uno con su cuenta AWS Academy (o una cuenta compartida
  por grupo).
- Servicios usados: S3, Glue Crawler, Glue Data Catalog, Athena.

> Si AWS Academy no ofrece los permisos necesarios, la práctica se convierte en
> demo guiada o análisis comparativo. La ruta principal de UD2 no depende de AWS.

---

## Secuencia recomendada

1. Los alumnos hacen la práctica principal con dlt (Ruta A).
2. Al final, el docente propone: *"Ahora veamos cómo se hace esto mismo
   con herramientas que se usan en empresa"*.
3. **Bloque Airbyte** (30-40 min si el servidor responde):
   - Entrar a la GUI.
   - Configurar source CSV/JSONL y destino Postgres.
   - Ejecutar sync y ver los datos.
   - Responder preguntas de comparación.
4. **Bloque AWS** (45-60 min si los labs están operativos):
   - Subir los mismos CSVs a S3.
   - Ejecutar Glue Crawler.
   - Consultar con Athena.
   - Responder preguntas de comparación.
5. Debate final: ¿cuándo usas dlt? ¿cuándo Airbyte? ¿cuándo AWS? ¿qué
   implicaciones de coste, aprendizaje, infraestructura tiene cada uno?

---

## Notas de montaje (uso interno del docente)

| Elemento | Estado | Quién |
|----------|--------|-------|
| Servidor Proxmox con Airbyte | Supuesto de partida | Docente/departamento |
| Acceso Airbyte probado desde aula | Pendiente | Docente |
| Postgres destino creado y probado | Pendiente | Docente |
| AWS Academy labs verificados | Pendiente | Docente |
| Datos de prueba generados | ✅ Hecho | Script Medallion |
| Documentos de práctica | ✅ Hecho | Este directorio |

---

## Histórico

| Fecha | Cambio |
|-------|--------|
| 2026-06-21 | Se fija Postgres como destino Airbyte y se explicita que Airbyte ya está instalado en Proxmox. |
| 2026-06-18 | Creación del directorio y documentos de práctica. |
