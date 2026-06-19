# Referencia: Meltano — alternativa ELT open-source

> **Propósito**: Documentación de referencia para el profesorado. Meltano es una
> alternativa a dlt/Airbyte para pipelines ELT, basada en configuración YAML y CLI.
>
> No se usa como ruta principal en SBD porque añade una capa de abstracción
> (config YAML + singer taps/targets) que no aporta valor curricular frente a dlt.
> Se deja documentado por si el profesor de BDA quiere explorarlo.

---

## ¿Qué es Meltano?

Meltano es una herramienta ELT open-source que usa el estándar **Singer** para
conectores (taps = extracción, targets = carga). Se configura con YAML y se
opera desde CLI.

```bash
pip install meltano
meltano init mi-proyecto
cd mi-proyecto
meltano add tap-csv
meltano add target-duckdb
meltano run tap-csv target-duckdb
```

---

## Comparativa con dlt

| Aspecto | dlt | Meltano |
|---------|-----|---------|
| Instalación | `pip install dlt` | `pip install meltano` |
| Enfoque | Python programático | YAML declarativo + CLI |
| Curva de aprendizaje | Baja (Python puro) | Media (Singer taps/targets) |
| Destino DuckDB | Nativo | Vía target-duckdb |
| Ideal para | SBD (los alumnos escriben código) | BDA (configuración + operación) |
| Estado del proyecto | Muy activo (5.5k ★) | Activo pero menos tracción |

---

## Ejemplo mínimo con los datos de UD2

```yaml
# meltano.yml
version: 1
default_environment: dev

plugins:
  extractors:
    - name: tap-csv
      variant: meltanolabs
      pip_url: git+https://github.com/MeltanoLabs/tap-csv.git
      config:
        files:
          - path: datos/practica_medallion/raw/ventas.csv
            key_properties: [venta_id]

  loaders:
    - name: target-duckdb
      variant: jwills
      pip_url: target-duckdb
      config:
        filepath: output/medallion.duckdb
        default_target_schema: bronze
```

```bash
meltano install
meltano run tap-csv target-duckdb
```

---

## Cuándo usarlo

- Si se monta un **servidor compartido** y se quiere una herramienta ELT con UI web
  (Meltano tiene `meltano ui`).
- En **BDA** para flujos ELT donde prime la configuración sobre el código.
- Como herramienta de referencia en el **proyecto integrador UD6** para comparar
  enfoques (dlt vs Meltano vs script manual).

---

## Enlaces

- https://meltano.com/
- https://docs.meltano.com/
- https://hub.meltano.com/ (catálogo de conectores Singer)

---

## Histórico

| Fecha       | Cambio |
| ----------- | ------ |
| 2026-06-18 | Creación de referencia para el profesorado. |
