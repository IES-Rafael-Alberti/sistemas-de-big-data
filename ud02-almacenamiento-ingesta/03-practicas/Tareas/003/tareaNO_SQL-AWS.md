### Actividad: Trabajo Práctico con una Base de Datos NoSQL en AWS (DynamoDB)

#### **Objetivo:**
Familiarizarse con una base de datos NoSQL en un entorno de nube, comprender su modelo de datos y explorar sus capacidades de escalabilidad y rendimiento. Utilizaremos **DynamoDB** en AWS para realizar operaciones básicas de creación, inserción, consulta y eliminación de datos.

---

### **Parte Teórica: Introducción a DynamoDB**
1. **Características Clave:**
   - Almacenamiento basado en documentos y clave-valor.
   - Escalabilidad automática para manejar grandes volúmenes de datos.
   - Integración nativa con otros servicios de AWS como Lambda y S3.

2. **Casos de Uso Comunes:**
   - Aplicaciones web y móviles.
   - Sistemas de seguimiento en tiempo real (IoT).
   - Tablas de puntuaciones para juegos.

3. **Modelo de Datos:**
   - **Tablas**: Almacenan datos.
   - **Elementos**: Filas de la tabla, cada una identificada por una clave primaria.
   - **Atributos**: Columnas que describen las propiedades de los elementos.

---

### **Actividad Práctica**

#### **Paso 1: Crear una Tabla en DynamoDB**
1. Inicia sesión en la consola de AWS y selecciona **DynamoDB** desde el menú de servicios.
2. Haz clic en **Create table**.
3. Configura la tabla:
   - **Table name**: `CustomerData`.
   - **Partition key**: `CustomerID` (Tipo: String).
4. Haz clic en **Create table**. La tabla estará disponible en pocos segundos.

---

#### **Paso 2: Insertar Datos en la Tabla**
1. Ve a la tabla `CustomerData`.
2. Haz clic en **Explore table items** y luego en **Create item**.
3. Inserta un elemento:
   ```json
   {
       "CustomerID": "C001",
       "Name": "Alice Smith",
       "Email": "alice@example.com",
       "Age": 30
   }
   ```
4. Inserta varios elementos más para tener un conjunto de datos.

---

#### **Paso 3: Consultar Datos**
1. Desde la consola de DynamoDB, selecciona la tabla y ve a **Explore table items**.
2. Realiza consultas utilizando filtros:
   - Ejemplo: Buscar por `CustomerID` con el valor `C001`.
3. Nota cómo DynamoDB devuelve resultados basados en la clave primaria.

---

#### **Paso 4: Configurar un Índice Secundario**
1. Ve a **Indexes** en la tabla y haz clic en **Create index**.
2. Configura un índice secundario:
   - **Index name**: `EmailIndex`.
   - **Partition key**: `Email` (Tipo: String).
3. Usa el índice para buscar elementos por su correo electrónico.

---

#### **Paso 5: Eliminar Elementos**
1. Ve a la tabla y selecciona un elemento.
2. Haz clic en **Actions** y luego en **Delete item**.
3. Confirma la eliminación.

---

### **Tarea Extra (Opcional): Uso de SDK de AWS para DynamoDB**
#### **Objetivo:**
Realizar operaciones CRUD en DynamoDB usando el SDK de AWS en Python.

#### **Paso 1: Configurar AWS CLI y Credenciales**
1. Instala el AWS CLI:
   ```bash
   pip install awscli
   ```
2. Configura las credenciales:
   ```bash
   aws configure
   ```

#### **Paso 2: Escribir un Script Python**
1. Instala el SDK de AWS para Python (boto3):
   ```bash
   pip install boto3
   ```
2. Crea un script para insertar un elemento:
   ```python
   import boto3

   dynamodb = boto3.resource('dynamodb')
   table = dynamodb.Table('CustomerData')

   response = table.put_item(
       Item={
           'CustomerID': 'C002',
           'Name': 'Bob Johnson',
           'Email': 'bob@example.com',
           'Age': 25
       }
   )

   print("Insertado:", response)
   ```

#### **Paso 3: Ejecutar el Script**
1. Guarda el archivo como `insert_item.py`.
2. Ejecuta el script:
   ```bash
   python insert_item.py
   ```

---

### **Criterios de Evaluación**
1. **Comprensión del Modelo NoSQL:**
   - Identificar correctamente los componentes de DynamoDB (tablas, elementos, claves).
2. **Uso de la Consola:**
   - Crear, insertar, consultar y eliminar elementos sin errores.
3. **Uso del SDK (Opcional):**
   - Ejecutar operaciones CRUD con scripts funcionales.
4. **Análisis Reflexivo:**
   - Comparar DynamoDB con otras bases de datos vistas en clase, destacando ventajas y limitaciones.

---

Esta actividad combina teoría y práctica, proporcionando una introducción sólida a DynamoDB y su integración en flujos de trabajo Big Data.


# Apéndice I

Conjunto de datos de ejemplo que puedes insertar en la tabla `CustomerData` de DynamoDB:

### **Datos para Insertar**
```json
{
    "CustomerID": "C001",
    "Name": "Alice Smith",
    "Email": "alice@example.com",
    "Age": 30,
    "City": "New York",
    "LoyaltyPoints": 1200
},
{
    "CustomerID": "C002",
    "Name": "Bob Johnson",
    "Email": "bob@example.com",
    "Age": 25,
    "City": "Los Angeles",
    "LoyaltyPoints": 800
},
{
    "CustomerID": "C003",
    "Name": "Carol Lee",
    "Email": "carol@example.com",
    "Age": 28,
    "City": "Chicago",
    "LoyaltyPoints": 950
},
{
    "CustomerID": "C004",
    "Name": "David Brown",
    "Email": "david@example.com",
    "Age": 35,
    "City": "Houston",
    "LoyaltyPoints": 1500
},
{
    "CustomerID": "C005",
    "Name": "Eve Green",
    "Email": "eve@example.com",
    "Age": 22,
    "City": "Seattle",
    "LoyaltyPoints": 600
}
```

---

### **Insertar los Datos con la Consola de DynamoDB**
1. **Crear un Elemento:**
   - Ve a la consola de DynamoDB.
   - Selecciona tu tabla `CustomerData` y haz clic en **Explore table items**.
   - Haz clic en **Create item** y copia uno de los objetos JSON arriba.
   - Inserta cada dato uno por uno.

---

### **Insertar los Datos con un Script Python**
Si deseas automatizar el proceso de inserción de múltiples elementos, puedes usar un script en Python con `boto3`.

#### **Script Python**
```python
import boto3

# Conectar con DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('CustomerData')

# Lista de datos para insertar
data = [
    {
        "CustomerID": "C001",
        "Name": "Alice Smith",
        "Email": "alice@example.com",
        "Age": 30,
        "City": "New York",
        "LoyaltyPoints": 1200
    },
    {
        "CustomerID": "C002",
        "Name": "Bob Johnson",
        "Email": "bob@example.com",
        "Age": 25,
        "City": "Los Angeles",
        "LoyaltyPoints": 800
    },
    {
        "CustomerID": "C003",
        "Name": "Carol Lee",
        "Email": "carol@example.com",
        "Age": 28,
        "City": "Chicago",
        "LoyaltyPoints": 950
    },
    {
        "CustomerID": "C004",
        "Name": "David Brown",
        "Email": "david@example.com",
        "Age": 35,
        "City": "Houston",
        "LoyaltyPoints": 1500
    },
    {
        "CustomerID": "C005",
        "Name": "Eve Green",
        "Email": "eve@example.com",
        "Age": 22,
        "City": "Seattle",
        "LoyaltyPoints": 600
    }
]

# Insertar cada dato en la tabla
for item in data:
    response = table.put_item(Item=item)
    print(f"Insertado: {item['CustomerID']}, Respuesta: {response}")
```

#### **Ejecución**
1. Guarda este script como `insert_multiple_items.py`.
2. Ejecuta el script desde la línea de comandos:
   ```bash
   python insert_multiple_items.py
   ```

Esto cargará todos los datos de forma automática en tu tabla de DynamoDB.
