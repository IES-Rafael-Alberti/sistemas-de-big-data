# Tutorial Completo de DuckDB

## 📚 Índice
1. [¿Qué es DuckDB?](#qué-es-duckdb)
2. [Instalación](#instalación)
3. [Conceptos Básicos](#conceptos-básicos)
4. [Operaciones con Datos](#operaciones-con-datos)
5. [Integración con Python](#integración-con-python)
6. [Ejemplos Prácticos](#ejemplos-prácticos)
7. [Best Practices](#best-practices)

## 🤔 ¿Qué es DuckDB?

DuckDB es una base de datos SQL embebida diseñada para **análisis de datos** (OLAP). Es perfecta para:

- Procesamiento rápido de datos dentro de tu aplicación
- Análisis de datos sin servidor externo
- Reemplazo de pandas para operaciones pesadas
- Trabajar con archivos CSV, Parquet, JSON

**Ventajas clave:**
- ⚡ **Rápido**: Optimizado para consultas analíticas
- 🚀 **Fácil**: No requiere configuración ni servidor
- 💾 **Eficiente**: Maneja grandes volúmenes de datos en memoria
- 🔄 **Compatibilidad**: Lee directamente CSV, Parquet, JSON

## 🔧 Instalación

### En Python:
```bash
pip install duckdb
```

### En Jupyter Notebook:
```bash
pip install duckdb jupysql
%load_ext sql
```

## 🎯 Conceptos Básicos

### Conexión Básica
```python
import duckdb

# Conexión en memoria (default)
conn = duckdb.connect()

# Conexión persistente en archivo
conn = duckdb.connect('mi_base_de_datos.db')
```

### Tu Primera Consulta
```python
# Consulta simple
result = conn.execute("SELECT 'Hola DuckDB!' as saludo").fetchall()
print(result)
# [('Hola DuckDB!',)]

# Crear tabla e insertar datos
conn.execute("CREATE TABLE usuarios (id INTEGER, nombre VARCHAR, edad INTEGER)")
conn.execute("INSERT INTO usuarios VALUES (1, 'Ana', 25), (2, 'Carlos', 30)")
```

## 📊 Operaciones con Datos

### 1. Cargar Datos desde CSV
```python
# Cargar CSV directamente
df = conn.execute("""
    SELECT * 
    FROM read_csv('datos.csv', header=true, auto_detect=true)
""").fetchdf()

# O usando la función read_csv
df = conn.read_csv('datos.csv')
print(df.head())
```

### 2. Cargar desde Parquet
```python
# Parquet es muy eficiente con DuckDB
df = conn.execute("SELECT * FROM 'datos.parquet'").fetchdf()

# Múltiples archivos
df = conn.execute("SELECT * FROM 'datos_*.parquet'").fetchdf()
```

### 3. Consultas SQL Avanzadas
```python
# Agregaciones
result = conn.execute("""
    SELECT 
        departamento,
        AVG(salario) as salario_promedio,
        COUNT(*) as empleados
    FROM empleados
    GROUP BY departamento
    HAVING COUNT(*) > 5
    ORDER BY salario_promedio DESC
""").fetchdf()
```

### 4. Window Functions
```python
# Ranking y análisis avanzado
result = conn.execute("""
    SELECT 
        nombre,
        departamento,
        salario,
        RANK() OVER (PARTITION BY departamento ORDER BY salario DESC) as ranking
    FROM empleados
""").fetchdf()
```

## 🐍 Integración con Python

### Convertir entre DuckDB y pandas
```python
import pandas as pd
import duckdb

# DataFrame de ejemplo
df_pandas = pd.DataFrame({
    'id': [1, 2, 3, 4],
    'nombre': ['Ana', 'Luis', 'Maria', 'Pedro'],
    'edad': [25, 30, 35, 28]
})

# 1. DataFrame → DuckDB
conn.register('mi_tabla', df_pandas)

# Consultar el DataFrame como tabla SQL
result = conn.execute("""
    SELECT * FROM mi_tabla WHERE edad > 28
""").fetchdf()

# 2. DuckDB → DataFrame
df_resultado = conn.execute("SELECT * FROM mi_tabla").fetchdf()

# 3. Método directo
df_resultado = conn.sql("SELECT * FROM mi_tabla WHERE edad > 25").df()
```

### Funciones Personalizadas
```python
# Registrar función Python en DuckDB
def calcular_impuesto(salario):
    return salario * 0.15

conn.create_function('calcular_impuesto', calcular_impuesto)

# Usar la función en SQL
result = conn.execute("""
    SELECT nombre, salario, calcular_impuesto(salario) as impuesto
    FROM empleados
""").fetchdf()
```

## 🚀 Ejemplos Prácticos

### Ejemplo 1: Análisis de Ventas
```python
import duckdb
import pandas as pd

# Datos de ejemplo
ventas = pd.DataFrame({
    'fecha': pd.date_range('2024-01-01', periods=100, freq='D'),
    'producto': ['A', 'B', 'C'] * 33 + ['A'],
    'cantidad': range(100),
    'precio': [10.5, 25.0, 15.0] * 33 + [10.5]
})

conn = duckdb.connect()
conn.register('ventas', ventas)

# Análisis completo
analisis = conn.execute("""
    SELECT 
        producto,
        SUM(cantidad) as total_vendido,
        SUM(cantidad * precio) as ingresos_totales,
        AVG(precio) as precio_promedio,
        COUNT(*) as transacciones
    FROM ventas
    GROUP BY producto
    ORDER BY ingresos_totales DESC
""").fetchdf()

print(analisis)
```

### Ejemplo 2: Procesamiento de Logs
```python
# Simular logs (en la práctica cargarías desde archivo)
logs = pd.DataFrame({
    'timestamp': pd.date_range('2024-01-01', periods=1000, freq='H'),
    'usuario': [f'user_{i%100}' for i in range(1000)],
    'accion': ['login', 'view', 'purchase'] * 333 + ['login'],
    'duracion_ms': np.random.randint(100, 5000, 1000)
})

conn.register('logs', logs)

# Análisis de actividad
actividad = conn.execute("""
    SELECT 
        DATE(timestamp) as fecha,
        usuario,
        COUNT(*) as total_acciones,
        AVG(duracion_ms) as tiempo_promedio_ms,
        SUM(CASE WHEN accion = 'purchase' THEN 1 ELSE 0 END) as compras
    FROM logs
    GROUP BY fecha, usuario
    HAVING COUNT(*) > 5
    ORDER BY fecha, total_acciones DESC
""").fetchdf()
```

### Ejemplo 3: Análisis de Series Temporales
```python
# Datos temporales
datos_temporales = pd.DataFrame({
    'fecha': pd.date_range('2023-01-01', periods=365, freq='D'),
    'valor': np.random.normal(100, 15, 365).cumsum()
})

conn.register('series_temporales', datos_temporales)

# Análisis con funciones de ventana
analisis_temporal = conn.execute("""
    SELECT 
        fecha,
        valor,
        AVG(valor) OVER (
            ORDER BY fecha 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) as media_movil_7d,
        LAG(valor, 7) OVER (ORDER BY fecha) as valor_hace_7_dias,
        (valor - LAG(valor, 1) OVER (ORDER BY fecha)) / LAG(valor, 1) OVER (ORDER BY fecha) * 100 as cambio_porcentual
    FROM series_temporales
    ORDER BY fecha DESC
""").fetchdf()
```

## 💡 Best Practices

### 1. Manejo Eficiente de Memoria
```python
# Para datasets grandes, usa archivos en lugar de memoria
conn.execute("""
    CREATE TABLE ventas_largas AS 
    SELECT * FROM read_parquet('ventas_grandes.parquet')
""")

# O usa persistencia en disco
conn = duckdb.connect('mi_base.db')
```

### 2. Optimización de Consultas
```python
# MAL: Múltiples consultas pequeñas
for producto in productos:
    result = conn.execute(f"SELECT * FROM ventas WHERE producto = '{producto}'").fetchdf()

# BIEN: Una consulta con filtro
result = conn.execute("""
    SELECT producto, COUNT(*) 
    FROM ventas 
    WHERE producto IN ({})
    GROUP BY producto
""".format(','.join(f"'{p}'" for p in productos))).fetchdf()
```

### 3. Trabajo con Archivos Grandes
```python
# Usar formato Parquet para mejor rendimiento
conn.execute("""
    COPY (SELECT * FROM ventas) 
    TO 'ventas_export.parquet' (FORMAT PARQUET)
""")

# Leer múltiples archivos
result = conn.execute("""
    SELECT * FROM read_parquet('ventas_*.parquet')
    WHERE fecha >= '2024-01-01'
""").fetchdf()
```

### 4. Configuraciones de Rendimiento
```python
# Configurar para máximo rendimiento
conn.execute("PRAGMA threads=4")
conn.execute("PRAGMA memory_limit='4GB'")

# Para operaciones de muchos grupos
conn.execute("PRAGMA temp_directory='/tmp/duckdb'")
```

## 🎓 Ejercicios Prácticos

### Ejercicio 1: Análisis de E-commerce
Crea un análisis de datos de e-commerce que muestre:
- Ventas por categoría de producto
- Clientes más valiosos (por gasto total)
- Tendencia de ventas mensual

### Ejercicio 2: Limpieza de Datos
Usa DuckDB para:
- Limpiar datos duplicados
- Manejar valores nulos
- Normalizar formatos de fecha

### Ejercicio 3: Análisis de Sentimientos
Combina DuckDB con una librería de NLP para analizar sentimientos en textos.

## 🔗 Recursos Adicionales

- **Documentación oficial**: https://duckdb.org/docs/
- **Ejemplos avanzados**: https://duckdb.org/docs/examples/examples.html
- **SQL reference**: https://duckdb.org/docs/sql/introduction
- **GitHub repository**:
- **Cómo usarlo**: https://keepcoding.io/blog/duckdb-python-como-usarlo/

