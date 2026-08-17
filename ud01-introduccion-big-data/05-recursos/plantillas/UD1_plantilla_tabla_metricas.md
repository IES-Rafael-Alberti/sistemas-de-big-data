# UD1 — Matriz de métricas de calidad (Antes / Después)

Rellena esta tabla con **proporciones** (0–1) o **porcentajes** (0–100%). Usa **2 decimales** y añade notas breves sobre reglas aplicadas.

| Dimensión                 | Definición breve                                           | Métrica (fórmula)                         | Antes | Después | Δ (p.p.) | Notas (reglas, decisiones) |
|--------------------------|-------------------------------------------------------------|-------------------------------------------|:-----:|:-------:|:--------:|----------------------------|
| **Completitud**          | % de valores no nulos                                      | 1 − nulos(col)/N                          |       |         |          |                            |
| **Unicidad**             | % de filas con clave única                                 | nunique(id)/N                             |       |         |          |                            |
| **Validez (dominio)**    | % de valores dentro del conjunto permitido                  | mean(col ∈ dominio)                       |       |         |          |                            |
| **Validez (rango)**      | % de valores dentro de rango                                | mean(min ≤ col ≤ max)                      |       |         |          |                            |
| **Conformidad (regex)**  | % que cumple el patrón/formato                              | mean(fullmatch(regex))                    |       |         |          |                            |
| **Consistencia 1**       | Regla inter-campo #1 (ej. inicio ≤ fin)                     | mean(regla_1)                             |       |         |          |                            |
| **Consistencia 2**       | Regla inter-campo #2 (ej. precio≈pu*cant)                   | mean(regla_2)                             |       |         |          |                            |
| **Puntualidad** (opc.)   | % de filas dentro del umbral de frescura                    | mean(now − ts ≤ umbral)                   |       |         |          |                            |

**Notas de uso**
- Reporta **Δ (puntos porcentuales)** como: `Después − Antes` (en %).  
- Si aplicas **etiquetado** en vez de eliminación, añade columna/flag y explica aquí cómo afecta a las métricas.
- Guarda captura de las **consultas** y del **código** que calcula cada métrica.

---

## Ejemplos rápidos (pandas)

```python
completitud = 1 - df['col'].isna().mean()
unicidad = df['id'].nunique() / len(df)
validez_dom = df['estado'].isin(['ok','ko','hold']).mean()
validez_rango = ((df['precio'] >= 0) & (df['precio'] <= 1000)).mean()
regex_ok = df['email'].str.fullmatch(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').fillna(False).mean()
consistencia_1 = (df['fecha_inicio'] <= df['fecha_fin']).mean()
puntualidad = (pd.Timestamp.utcnow() - df['ts'] <= pd.Timedelta('2D')).mean()
```
