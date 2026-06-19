### Actividad: Comparativa entre Cassandra y MongoDB

#### **Objetivo:**
Los alumnos aprenderán a trabajar con bases de datos NoSQL, específicamente **Cassandra** y **MongoDB**, para explorar sus diferencias y similitudes en términos de estructura, operaciones básicas, rendimiento y casos de uso. La actividad incluirá la creación de bases de datos, inserción de datos, consultas y comparación de características clave.

---

### **Parte 1: Configuración**

#### **Paso 1: Acceso a AWS Academy**
1. Inicia sesión en **AWS Academy Learner Lab**.
2. Verifica que las instancias EC2 y los recursos necesarios estén disponibles.

#### **Paso 2: Configurar MongoDB**
1. Lanza una instancia de EC2 con Amazon Linux 2.
2. Conéctate a la instancia mediante SSH.
3. Instala MongoDB en la instancia:
   ```bash
   sudo yum install -y mongodb-org
   sudo systemctl start mongod
   sudo systemctl enable mongod
   ```
4. Abre el puerto 27017 en el grupo de seguridad de la instancia para permitir conexiones.

#### **Paso 3: Configurar Cassandra**
1. Lanza otra instancia de EC2 con Amazon Linux 2.
2. Conéctate a la instancia mediante SSH.
3. Instala Cassandra en la instancia:
   ```bash
   sudo yum install -y java-1.8.0-openjdk
   echo "[cassandra]
   name=Apache Cassandra
   baseurl=https://downloads.apache.org/cassandra/redhat/311x/
   gpgcheck=1
   repo_gpgcheck=1
   gpgkey=https://downloads.apache.org/cassandra/KEYS
   " | sudo tee /etc/yum.repos.d/cassandra.repo

   sudo yum install -y cassandra
   sudo systemctl start cassandra
   sudo systemctl enable cassandra
   ```
4. Abre el puerto 9042 en el grupo de seguridad de la instancia para permitir conexiones.

---

### **Parte 2: Actividad con MongoDB**

#### **Paso 1: Conectar al Cliente MongoDB**
1. Conéctate a MongoDB desde la instancia EC2:
   ```bash
   mongo
   ```

#### **Paso 2: Crear una Base de Datos y Colección**
1. Crear la base de datos:
   ```javascript
   use CustomerDB
   ```
2. Crear una colección `Customers` e insertar documentos:
   ```javascript
   db.Customers.insertMany([
       { "CustomerID": "C001", "Name": "Alice Smith", "Age": 30, "City": "New York" },
       { "CustomerID": "C002", "Name": "Bob Johnson", "Age": 25, "City": "Los Angeles" },
       { "CustomerID": "C003", "Name": "Carol Lee", "Age": 28, "City": "Chicago" }
   ])
   ```

#### **Paso 3: Realizar Consultas**
1. Obtener todos los documentos:
   ```javascript
   db.Customers.find()
   ```
2. Filtrar por ciudad:
   ```javascript
   db.Customers.find({ "City": "New York" })
   ```

#### **Paso 4: Actualizar y Eliminar Documentos**
1. Actualizar el nombre de un cliente:
   ```javascript
   db.Customers.updateOne({ "CustomerID": "C001" }, { $set: { "Name": "Alice Brown" } })
   ```
2. Eliminar un cliente:
   ```javascript
   db.Customers.deleteOne({ "CustomerID": "C003" })
   ```

---

### **Parte 3: Actividad con Cassandra**

#### **Paso 1: Conectar al Cliente CQL**
1. Inicia el cliente Cassandra desde la instancia:
   ```bash
   cqlsh
   ```

#### **Paso 2: Crear un Keyspace y una Tabla**
1. Crear un keyspace:
   ```sql
   CREATE KEYSPACE CustomerDB WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
   ```
2. Crear una tabla `Customers`:
   ```sql
   USE CustomerDB;
   CREATE TABLE Customers (
       CustomerID UUID PRIMARY KEY,
       Name text,
       Age int,
       City text
   );
   ```

#### **Paso 3: Insertar Datos**
1. Inserta algunos registros:
   ```sql
   INSERT INTO Customers (CustomerID, Name, Age, City) VALUES (uuid(), 'Alice Smith', 30, 'New York');
   INSERT INTO Customers (CustomerID, Name, Age, City) VALUES (uuid(), 'Bob Johnson', 25, 'Los Angeles');
   INSERT INTO Customers (CustomerID, Name, Age, City) VALUES (uuid(), 'Carol Lee', 28, 'Chicago');
   ```

#### **Paso 4: Realizar Consultas**
1. Obtener todos los registros:
   ```sql
   SELECT * FROM Customers;
   ```
2. Filtrar por ciudad:
   ```sql
   SELECT * FROM Customers WHERE City = 'New York';
   ```

#### **Paso 5: Actualizar y Eliminar Registros**
1. Actualizar el nombre de un cliente:
   ```sql
   UPDATE Customers SET Name = 'Alice Brown' WHERE CustomerID = <UUID>;
   ```
2. Eliminar un cliente:
   ```sql
   DELETE FROM Customers WHERE CustomerID = <UUID>;
   ```

---

### **Parte 4: Comparativa entre MongoDB y Cassandra**

#### **Criterios de Comparación**
1. **Modelo de Datos:**
   - MongoDB: Documentos JSON.
   - Cassandra: Filas y columnas con un esquema definido.
2. **Consultas:**
   - MongoDB: Flexible, admite búsquedas en cualquier campo.
   - Cassandra: Optimizado para consultas por clave primaria.
3. **Escalabilidad:**
   - MongoDB: Escala horizontalmente con réplicas.
   - Cassandra: Diseñado para alta disponibilidad y replicación.
4. **Casos de Uso:**
   - MongoDB: Aplicaciones web y sistemas de contenido dinámico.
   - Cassandra: Grandes volúmenes de datos transaccionales.

#### **Tarea de Análisis**
1. Completa la siguiente tabla con tus observaciones:
   | Característica    | MongoDB                       | Cassandra                     |
   |-------------------|-------------------------------|-------------------------------|
   | Modelo de Datos   | Documentos JSON              | Filas y columnas              |
   | Escalabilidad     | **Completar**                | **Completar**                 |
   | Rendimiento       | **Completar**                | **Completar**                 |
   | Casos de Uso      | **Completar**                | **Completar**                 |

2. Discute con tu grupo:
   - ¿Qué base de datos preferirías para un sistema de recomendaciones de productos y por qué?
   - ¿Qué base de datos sería más eficiente para un sistema financiero que requiere alta disponibilidad?

---

### **Criterios de Evaluación**
1. **Configuración Correcta:**
   - MongoDB y Cassandra están configurados y accesibles.
2. **Operaciones Realizadas:**
   - Datos creados, consultados, actualizados y eliminados correctamente.
3. **Análisis Comparativo:**
   - Tabla completada con observaciones claras.
4. **Discusión:**
   - Argumentos bien fundamentados sobre las bases de datos para diferentes escenarios.

Esta actividad proporciona un enfoque práctico para explorar MongoDB y Cassandra, mientras permite reflexionar sobre las diferencias fundamentales en el diseño y uso de bases de datos NoSQL.
