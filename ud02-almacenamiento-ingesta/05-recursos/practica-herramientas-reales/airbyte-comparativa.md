# Práctica: ELT con Airbyte (GUI)

> **Propósito**: Configurar los mismos conectores que hiciste con dlt, ahora desde
> la interfaz gráfica de Airbyte. Comparar enfoques: código vs GUI, flexibilidad
> vs rapidez, coste de infraestructura.
>
> **Duración estimada**: 30-40 minutos.
>
> **Prerrequisito**: Tener la práctica Ruta A (dlt) completada.

---

## 1. Acceso

El docente te dará la URL y credenciales del servidor Airbyte.

```text
URL: http://<ip-del-servidor>:8000
Usuario: ...
Contraseña: ...
```

Abre la URL en el navegador. Deberías ver el dashboard de Airbyte.

---

## 2. Configurar un origen (Source)

Vas a conectar Airbyte a los mismos CSVs de la práctica Medallion.

1. Click en **Sources → + New source**.
2. Busca "Local File (CSV)" o "File" en el catálogo de conectores.
   - Si el conector CSV no aparece, tu docente te indicará la alternativa
     (p.ej. copiar los archivos a Postgres o a un bucket S3 primero).
3. Configura:
   - **Name**: `Ventas Medallion`
   - **File path**: `${RUTA_DATOS}/ventas.csv`
   - **Dataset name**: `bronze_ventas`
   - **Format**: CSV
4. **Test** → debe salir verde.
5. **Create & Save**.

Repite para los otros archivos:

| Origen | Archivo | Dataset |
|--------|---------|---------|
| Ventas | `ventas.csv` | `bronze_ventas` |
| Reservas | `reservas.jsonl` | `bronze_reservas` |
| Meteo | `meteo.csv` | `bronze_meteo` |
| Zonas | `zonas.csv` | `bronze_zonas` |

---

## 3. Configurar un destino (Destination)

1. **Destinations → + New destination**.
2. Busca **DuckDB**.
3. Configura:
   - **Name**: `DuckDB Medallion`
   - **Destination path**: `/tmp/medallion_airbyte.duckdb`
4. **Test** → verde.
5. **Save**.

Alternativa: si DuckDB no está disponible en la versión de Airbyte, el docente
indicará un **destino Postgres** (más común en Airbyte). Los conceptos son los
mismos.

---

## 4. Crear conexiones

1. **Connections → + New connection**.
2. Source: `Ventas Medallion` → Destination: `DuckDB Medallion`.
3. Configura:
   - **Replication frequency**: `Manual` (ejecutaremos bajo demanda).
   - **Sync mode**: `Full refresh | Overwrite` (para empezar).
   - **Streams**: selecciona `bronze_ventas`.
4. **Save**.

Repite la conexión para cada origen. Después, vuelve a la lista de
conexiones y ejecuta un **Sync Now** en cada una.

---

## 5. Verificar

Pregunta al docente cómo verificar los datos cargados. Si el destino es DuckDB:

```bash
duckdb /tmp/medallion_airbyte.duckdb \
  -c "SELECT COUNT(*) FROM bronze_ventas;"
```

Si es Postgres:

```sql
SELECT COUNT(*) FROM bronze_ventas;
```

---

## 6. Comparación con dlt

Responde por escrito (puede ser en el mismo documento de la práctica principal):

| Aspecto | dlt | Airbyte |
|---------|-----|---------|
| ¿Qué necesité instalar? | | |
| ¿Cuánto tardé en tener los datos cargados? | | |
| ¿Puedo ver el código del pipeline? | | |
| ¿Qué tan fácil es debuggear un error? | | |
| ¿Qué recursos de infraestructura consume? | | |
| ¿Para qué tipo de proyecto usarías cada uno? | | |

Preguntas de reflexión:

1.  **¿Qué ventajas tiene dlt frente a Airbyte para un proyecto pequeño?**
    ¿Y para un proyecto grande con 50 fuentes de datos?

2.  **Airbyte gestiona automáticamente el esquema de los datos.**
    ¿Es siempre una ventaja? ¿Cuándo puede ser un problema?

3.  **Coste de infraestructura**: Airbyte necesita un servidor corriendo
    24/7 (o al menos mientras se ejecutan sincronizaciones). ¿Cómo
    afecta eso a la decisión técnica?

4.  **Observabilidad**: Airbyte ofrece logs, métricas y estado de cada
    sync desde la GUI. En dlt, ¿cómo haces lo mismo?

5.  **¿Cuál crees que es más fácil de integrar en un equipo de
    desarrolladores que ya usa Python?** ¿Y en un equipo de analistas
    que no programa?

---

## 7. Ampliación opcional

Si el servidor Airbyte lo permite, configura una conexión **incremental**:

- En la conexión, cambia **Sync mode** a `Incremental | Append`.
- Añade un nuevo registro al CSV de ventas.
- Ejecuta otro sync.
- Verifica que solo se añadió el registro nuevo.

¿Cómo sabe Airbyte qué registros son nuevos? ¿Qué columna usa como cursor?

---

## Histórico

| Fecha       | Cambio |
|-------------|--------|
| 2026-06-18 | Creación de la práctica Airbyte comparativa. |
