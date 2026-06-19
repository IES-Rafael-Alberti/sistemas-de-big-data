# Práctica "Herramientas reales": Airbyte + AWS

> **Propósito**: Contraste curricular — los mismos conceptos ELT que ya practicaron con dlt,
> ahora con herramientas del mundo real. Optativo, no evaluable.
>
> Docente: preparar servidor Airbyte y/o validar laboratorios AWS Academy **antes** de
> impartir UD2. Los alumnos no instalan ni configuran nada — solo usan.

---

## Estructura

| Documento | Contenido |
|-----------|-----------|
| `airbyte-comparativa.md` | Práctica Airbyte GUI. Comparación con dlt. |
| `aws-ingesta-serverless.md` | Práctica AWS S3 + Glue + Athena. Contraste cloud ELT. |
| `README.md` (este) | Visión general + notas de montaje para el docente. |

## Prerrequisitos

### Airbyte (servidor Proxmox)

- Servidor Linux (Debian/Ubuntu recomendado) con Docker + Docker Compose.
- Airbyte 1.x instalado según [guía oficial](https://docs.airbyte.com/deploying-airbyte/docker-compose).
- Recursos mínimos estimados: 4 GB RAM, 2 vCPU, 20 GB disco.

```bash
# Instalación rápida (evaluar si sigue siendo válida)
curl -LsfS https://get.airbyte.com | bash -
# Alternativa: clonar repo y docker compose up
git clone https://github.com/airbytehq/airbyte.git
cd airbyte
docker compose up -d
```

> **Atención**: Airbyte 1.x requiere Docker Compose V2 y al menos Docker 24+.
> Verificar compatibilidad con la versión del servidor.

> **Alternativa**: si Airbyte 1.x da problemas, barajar la versión 0.63.x
> (última pre-Kubernetes) aunque está deprecada. Documentar la decisión
> en este README.

### AWS Academy

- Laboratorios AWS Academy activados para el módulo SBD.
- Acceso a consola AWS con permisos para S3, Glue, Athena (IAM básico).
- Alumnos: cada uno con su cuenta AWS Academy (o una cuenta compartida
  por grupo).
- Servicios usados: S3, Glue Crawler, Glue Data Catalog, Athena.

> El docente debe validar que los servicios mencionados están disponibles
> en los laboratorios AWS Academy antes de impartir la práctica.

---

## Secuencia recomendada

1. Los alumnos hacen la práctica principal con dlt (Ruta A).
2. Al final, el docente propone: *"Ahora veamos cómo se hace esto mismo
   con herramientas que se usan en empresa"*.
3. **Bloque Airbyte** (30-40 min si el servidor responde):
   - Entrar a la GUI.
   - Configurar source CSV y destino DuckDB/Postgres.
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
| Servidor Proxmox asignado | Pendiente | Docente |
| Airbyte instalado y probado | Pendiente | Docente |
| AWS Academy labs verificados | Pendiente | Docente |
| Datos de prueba generados | ✅ Hecho | Script Medallion |
| Documentos de práctica | ✅ Hecho | Este directorio |

---

## Histórico

| Fecha | Cambio |
|-------|--------|
| 2026-06-18 | Creación del directorio y documentos de práctica. |
