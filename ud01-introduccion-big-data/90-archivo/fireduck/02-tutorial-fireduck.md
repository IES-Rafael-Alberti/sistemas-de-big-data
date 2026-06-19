# Tutorial Completo de FireDuck

## 📚 Índice
1. [¿Qué es FireDuck?](#qué-es-fireduck)
2. [Instalación](#instalación)
3. [Conceptos Básicos](#conceptos-básicos)
4. [Operaciones con Datos](#operaciones-con-datos)
5. [Comparación con pandas](#comparación-con-pandas)
6. [Ejemplos Prácticos](#ejemplos-prácticos)
7. [Best Practices](#best-practices)

## 🤔 ¿Qué es FireDuck?

**FireDuck** es una librería Python que proporciona una interfaz estilo pandas sobre DuckDB. Te permite usar la **velocidad de DuckDB** con una **sintaxis familiar de Python**, sin necesidad de escribir SQL.

**Características principales:**
- 🐍 **Sintaxis Python**: Similar a pandas, no necesitas SQL
- ⚡ **Rendimiento DuckDB**: Mismo motor ultra-rápido subyacente
- 🔄 **Interoperabilidad**: Conversión seamless con pandas
- 📊 **Familiar**: Métodos como `.filter()`, `.group_by()`, `.agg()`

## 🔧 Instalación

```bash
# Instalar FireDuck
pip install fireduck

# O instalar con dependencias completas
pip install fireduck pandas numpy
```

## 🎯 Conceptos Básicos

### Importar y Configurar
```python
from fireduck import Session
import pandas as pd
import numpy as np

# Crear sesión (similar a conexión de DuckDB)
session = Session()

# Alternativa: sesión con archivo persistente
session = Session('mi_base_fireduck.db')
```

### Crear DataFrames
```python
# Desde un DataFrame de pandas
df_pandas = pd.DataFrame({
    'id': range(1, 6),
    'nombre': ['Ana', 'Luis', 'Maria', 'Pedro', 'Elena'],
    'edad': [25, 30, 35, 28, 32],
    'salario': [50000, 60000, 70000, 55000, 65000]
})

# Crear DataFrame de FireDuck
fd_df = session.create_dataframe(df_pandas, table_name='empleados')

# Mostrar datos
print(fd_df)
```

### Operaciones Básicas
```python
# Ver primeras filas
fd_df.head(3)

# Información del schema
fd_df.schema()

# Contar filas
fd_df.count()
```

## 📊 Operaciones con Datos

### 1. Filtrado de Datos
```python
# Filtrado simple (estilo pandas)
empleados_jovenes = fd_df.filter(fd_df.edad < 30)

# Múltiples condiciones
empleados_senior = fd_df.filter(
    (fd_df.edad > 30) & (fd_df.salario > 60000)
)

# Filtro con OR
empleados_especificos = fd_df.filter(
    (fd_df.nombre == 'Ana') | (fd_df.nombre == 'Maria')
)
```

### 2. Selección de Columnas
```python
# Seleccionar columnas específicas
nombres_edades = fd_df.select(['nombre', 'edad'])

# Con alias
nombres_alias = fd_df.select(
    fd_df.nombre.alias('nombre_completo'),
    fd_df.edad.alias('años')
)
```

### 3. Agregaciones
```python
# Agregaciones básicas
stats = fd_df.agg({
    'edad': ['mean', 'max', 'min'],
    'salario': ['sum', 'mean']
})

# Agregación con group_by
por_edad = fd_df.group_by('edad').agg({
    'salario': 'mean',
    'id': 'count'
}).alias('estadisticas_por_edad')
```

### 4. Ordenamiento
```python
# Ordenar por una columna
ordenado_salario = fd_df.order_by('salario', ascending=False)

# Ordenar por múltiples columnas
ordenado_complejo = fd_df.order_by(['edad', 'salario'], ascending=[True, False])
```

## 🔄 Comparación con pandas

### Misma operación en pandas vs FireDuck
```python
# Datos de ejemplo
data = pd.DataFrame({
    'departamento': ['IT', 'HR', 'IT', 'Finance', 'HR'] * 100,
    'salario': np.random.randint(40000, 100000, 500),
    'experiencia': np.random.randint(1, 20, 500)
})

# PANDAS (más lento con muchos datos)
df_pandas = data.copy()
result_pandas = (df_pandas[df_pandas['salario'] > 50000]
                 .groupby('departamento')
                 .agg({'salario': 'mean', 'experiencia': 'max'})
                 .reset_index())

# FIREDUCK (más rápido)
session = Session()
fd_df = session.create_dataframe(data)

result_fireduck = (fd_df.filter(fd_df.salario > 50000)
                   .group_by('departamento')
                   .agg({
                       'salario': 'mean',
                       'experiencia': 'max'
                   }))
```

### Conversión entre FireDuck y pandas
```python
# FireDuck → pandas
df_pandas_result = result_fireduck.to_pandas()

# pandas → FireDuck
nuevo_fd_df = session.create_dataframe(df_pandas_result)

# Verificar tipos
print(type(result_fireduck))  # <class 'fireduck.dataframe.DataFrame'>
print(type(df_pandas_result)) # <class 'pandas.core.frame.DataFrame'>
```

## 🚀 Ejemplos Prácticos

### Ejemplo 1: Análisis de Ventas Complejo
```python
from fireduck import Session
import pandas as pd

# Datos de ventas
ventas_data = pd.DataFrame({
    'fecha': pd.date_range('2024-01-01', periods=1000, freq='D'),
    'producto': ['A', 'B', 'C', 'D'] * 250,
    'categoria': ['Electrónica', 'Hogar', 'Electrónica', 'Ropa'] * 250,
    'cantidad': np.random.randint(1, 100, 1000),
    'precio': np.random.uniform(10, 500, 1000),
    'region': ['Norte', 'Sur', 'Este', 'Oeste'] * 250
})

session = Session()
ventas = session.create_dataframe(ventas_data)

# Análisis completo sin SQL
analisis_ventas = (ventas
    .filter(ventas.precio > 50)
    .group_by(['categoria', 'region'])
    .agg({
        'cantidad': 'sum',
        'precio': ['mean', 'max'],
        'producto': 'count'
    })
    .order_by(['categoria', 'sum(cantidad)'], ascending=[True, False])
)

print(analisis_ventas.to_pandas())
```

### Ejemplo 2: Transformación de Datos
```python
# Operaciones de transformación
datos_transformados = (ventas
    .select([
        ventas.fecha,
        ventas.producto,
        ventas.cantidad,
        ventas.precio,
        (ventas.cantidad * ventas.precio).alias('venta_total'),
        ventas.region
    ])
    .filter(ventas.fecha >= '2024-03-01')
    .with_columns({
        'venta_categoria': (
            ventas.cantidad * ventas.precio > 1000
        ).alias('venta_grande'),
        'precio_con_iva': (ventas.precio * 1.21).alias('precio_final')
    })
)

# Mostrar resultados
resultados = datos_transformados.limit(10).to_pandas()
print(resultados)
```

### Ejemplo 3: Análisis Temporal
```python
# Extraer componentes de fecha
analisis_temporal = (ventas
    .with_columns({
        'año': ventas.fecha.year().alias('año'),
        'mes': ventas.fecha.month().alias('mes'),
        'trimestre': ventas.fecha.quarter().alias('trimestre')
    })
    .group_by(['año', 'mes', 'categoria'])
    .agg({
        'venta_total': 'sum',
        'cantidad': 'sum',
        'producto': 'count'
    })
    .order_by(['año', 'mes', 'sum(venta_total)'], ascending=[True, True, False])
)

# Convertir a pandas para visualización
df_temporal = analisis_temporal.to_pandas()
print(df_temporal.head())
```

### Ejemplo 4: Joins entre Tablas
```python
# Crear segunda tabla
clientes_data = pd.DataFrame({
    'cliente_id': range(1, 101),
    'nombre': [f'Cliente_{i}' for i in range(1, 101)],
    'region': ['Norte', 'Sur', 'Este', 'Oeste'] * 25
})

ventas_con_clientes = pd.DataFrame({
    'venta_id': range(1, 1001),
    'cliente_id': np.random.randint(1, 101, 1000),
    'monto': np.random.uniform(50, 2000, 1000),
    'fecha': pd.date_range('2024-01-01', periods=1000, freq='H')
})

# Crear DataFrames de FireDuck
clientes_fd = session.create_dataframe(clientes_data, 'clientes')
ventas_fd = session.create_dataframe(ventas_con_clientes, 'ventas')

# Join entre tablas
ventas_completas = (ventas_fd
    .join(clientes_fd, on='cliente_id', how='inner')
    .select([
        ventas_fd.venta_id,
        ventas_fd.fecha,
        ventas_fd.monto,
        clientes_fd.nombre.alias('cliente'),
        clientes_fd.region
    ])
    .filter(ventas_fd.monto > 1000)
)

print(ventas_completas.limit(5).to_pandas())
```

## 💡 Best Practices

### 1. Manejo de Memoria
```python
# Para datasets grandes, procesar por chunks
def procesar_chunks(session, archivo, chunk_size=10000):
    for chunk in pd.read_csv(archivo, chunksize=chunk_size):
        fd_chunk = session.create_dataframe(chunk)
        resultado = fd_chunk.filter(fd_chunk.columna > 100).to_pandas()
        yield resultado

# Usar formato Parquet para mejor rendimiento
fd_df = session.create_dataframe_from_parquet('datos.parquet')
```

### 2. Optimización de Consultas
```python
# MAL: Múltiples operaciones separadas
fd1 = fd_df.filter(fd_df.edad > 25)
fd2 = fd1.filter(fd_df.salario > 50000)
fd3 = fd2.select(['nombre', 'edad'])

# BIEN: Encadenamiento eficiente
resultado = (fd_df
    .filter(fd_df.edad > 25)
    .filter(fd_df.salario > 50000)
    .select(['nombre', 'edad'])
)
```

### 3. Reutilización de DataFrames
```python
# Registrar DataFrame para reutilización
session.register_dataframe(fd_df, 'empleados_registrados')

# Usar en múltiples consultas
consulta1 = session.table('empleados_registrados').filter(fd_df.edad > 30)
consulta2 = session.table('empleados_registrados').group_by('departamento')
```

### 4. Trabajo con Archivos Externos
```python
# Cargar directamente desde CSV/Parquet
fd_csv = session.create_dataframe_from_csv('datos.csv')
fd_parquet = session.create_dataframe_from_parquet('datos.parquet')

# Exportar resultados
resultado.to_csv('resultado.csv')
resultado.to_parquet('resultado.parquet')
```

## 🎓 Ejercicios Prácticos

### Ejercicio 1: Análisis de Rendimiento
Compara el rendimiento entre pandas y FireDuck:
```python
# Generar datos grandes
datos_grandes = pd.DataFrame({
    'x': np.random.randn(1_000_000),
    'y': np.random.randn(1_000_000),
    'categoria': np.random.choice(['A', 'B', 'C', 'D'], 1_000_000)
})

# Medir tiempo en pandas
# Medir tiempo en FireDuck
```

### Ejercicio 2: Pipeline de ETL
Crea un pipeline completo:
1. Carga datos desde CSV
2. Limpia y transforma
3. Realiza agregaciones
4. Exporta resultados

### Ejercicio 3: Análisis de Segmentación
Segmenta clientes por:
- Comportamiento de compra
- Valor lifetime
- Frecuencia de compra

## 🔧 Configuración Avanzada

### Configuración de Sesión
```python
from fireduck import Session

session = Session(
    database_path='mi_base.db',  # Archivo persistente
    memory_limit='8GB',          # Límite de memoria
    thread_count=4               # Número de hilos
)

# Configuraciones adicionales
session.configure({
    'enable_object_cache': True,
    'preserve_insertion_order': False
})
```

### Funciones Personalizadas
```python
# Registrar funciones Python
def categorizar_edad(edad):
    if edad < 30: return 'Joven'
    elif edad < 50: return 'Adulto'
    else: return 'Senior'

session.register_function(categorizar_edad, 'categorizar_edad')

# Usar en FireDuck
resultado = fd_df.with_columns({
    'categoria_edad': fd_df.edad.apply('categorizar_edad')
})
```

## 🚀 Ventajas sobre DuckDB Puro

| Característica | DuckDB | FireDuck |
|----------------|---------|-----------|
| Sintaxis | SQL | Python/pandas |
| Curva aprendizaje | Media | Baja (para usuarios de pandas) |
| Rendimiento | Máximo | Muy alto |
| Flexibilidad | Alta | Alta |
| Interoperabilidad | Media | Alta |

## 🔗 Recursos Adicionales

- **Documentación FireDuck**: https://github.com/fireduck/fireduck
- **Ejemplos avanzados**: Repositorio oficial
- **DuckDB subyacente**: https://duckdb.org/docs/

