### Actividad: Trabajo Práctico con una Base de Datos SQL en AWS (Amazon RDS)

#### **Objetivo:**
Familiarizarse con bases de datos relacionales (SQL) en un entorno de nube, utilizando **Amazon RDS** para crear, configurar y trabajar con una base de datos relacional. Los alumnos aprenderán a realizar operaciones básicas como creación de tablas, inserción de datos, consultas y manipulación de datos.

---

### **Parte Teórica: Introducción a RDS**
1. **Características Clave:**
   - Base de datos gestionada en la nube que soporta motores como MySQL, PostgreSQL, SQL Server, MariaDB y Oracle.
   - Escalabilidad en almacenamiento y capacidad de procesamiento.
   - Respaldos automáticos y recuperación ante fallos.

2. **Casos de Uso Comunes:**
   - Aplicaciones web y móviles que requieren persistencia de datos.
   - Sistemas analíticos con procesamiento SQL.
   - Gestión de catálogos o datos transaccionales.

3. **Modelo de Datos Relacional:**
   - **Tablas**: Organizan los datos en filas y columnas.
   - **Relaciones**: Conexiones entre tablas mediante claves primarias y foráneas.
   - **Consultas SQL**: Lenguaje estándar para gestionar y consultar datos.

---

### **Actividad Práctica**

#### **Paso 1: Crear una Base de Datos en Amazon RDS**
1. Inicia sesión en la consola de AWS y selecciona **RDS** desde el menú de servicios.
2. Haz clic en **Create database**.
3. Configura la base de datos:
   - **Engine type**: MySQL.
   - **Template**: Free Tier.
   - **DB instance identifier**: `CustomerDB`.
   - **Master username**: `admin`.
   - **Master password**: Establece una contraseña segura.
4. Ajusta el almacenamiento:
   - **Storage type**: General Purpose (SSD).
   - **Allocated storage**: 20 GiB.
5. Configura la conectividad:
   - **Public access**: Activado (para acceso desde fuera de AWS).
   - **VPC security groups**: Asegúrate de permitir conexiones al puerto 3306 desde tu IP.
6. Haz clic en **Create database**. Esto tomará unos minutos.

---

#### **Paso 2: Conectar a la Base de Datos**
1. Una vez que la instancia esté disponible, selecciona tu base de datos en el panel de RDS.
2. Copia el **endpoint** de conexión.
3. Conéctate desde tu máquina usando un cliente MySQL como **MySQL Workbench** o la línea de comandos:
   ```bash
   mysql -h <endpoint> -u admin -p
   ```
4. Ingresa la contraseña que configuraste al crear la base de datos.

---

#### **Paso 3: Crear una Tabla**
1. Ejecuta el siguiente comando SQL para crear una tabla llamada `Customers`:
   ```sql
   CREATE TABLE Customers (
       CustomerID INT AUTO_INCREMENT PRIMARY KEY,
       Name VARCHAR(100),
       Email VARCHAR(100),
       Age INT,
       City VARCHAR(100)
   );
   ```

---

#### **Paso 4: Insertar Datos**
1. Inserta algunos datos en la tabla:
   ```sql
   INSERT INTO Customers (Name, Email, Age, City)
   VALUES
       ('Alice Smith', 'alice@example.com', 30, 'New York'),
       ('Bob Johnson', 'bob@example.com', 25, 'Los Angeles'),
       ('Carol Lee', 'carol@example.com', 28, 'Chicago'),
       ('David Brown', 'david@example.com', 35, 'Houston'),
       ('Eve Green', 'eve@example.com', 22, 'Seattle');
   ```

---

#### **Paso 5: Realizar Consultas**
1. Ejemplo de consulta para obtener todos los registros:
   ```sql
   SELECT * FROM Customers;
   ```
2. Consulta para filtrar clientes mayores de 30 años:
   ```sql
   SELECT Name, Age FROM Customers WHERE Age > 30;
   ```

---

#### **Paso 6: Modificar y Eliminar Datos**
1. Actualizar la ciudad de un cliente:
   ```sql
   UPDATE Customers SET City = 'San Francisco' WHERE CustomerID = 2;
   ```
2. Eliminar un cliente:
   ```sql
   DELETE FROM Customers WHERE CustomerID = 5;
   ```

---

### **Tarea Extra (Opcional): Integración con Python**
#### **Objetivo:**
Conectar a la base de datos desde Python y realizar operaciones SQL programáticamente.

#### **Paso 1: Instalar Conector MySQL para Python**
```bash
pip install mysql-connector-python
```

#### **Paso 2: Escribir un Script Python**
1. Crea un archivo `database_script.py` y escribe el siguiente código:
   ```python
   import mysql.connector

   # Conectar a la base de datos
   connection = mysql.connector.connect(
       host="<endpoint>",
       user="admin",
       password="<password>",
       database="CustomerDB"
   )

   cursor = connection.cursor()

   # Insertar un nuevo cliente
   cursor.execute("""
       INSERT INTO Customers (Name, Email, Age, City)
       VALUES ('Frank White', 'frank@example.com', 40, 'Boston');
   """)
   connection.commit()

   # Consultar clientes
   cursor.execute("SELECT * FROM Customers")
   for row in cursor.fetchall():
       print(row)

   # Cerrar la conexión
   cursor.close()
   connection.close()
   ```

#### **Paso 3: Ejecutar el Script**
```bash
python database_script.py
```

---

### **Criterios de Evaluación**
1. **Comprensión del Modelo Relacional:**
   - Crear tablas con claves primarias correctamente configuradas.
2. **Operaciones SQL:**
   - Insertar, consultar, modificar y eliminar datos sin errores.
3. **Conexión y Configuración:**
   - Configurar correctamente RDS y conectar desde un cliente.
4. **Automatización (Opcional):**
   - Conectar desde Python y ejecutar operaciones SQL con scripts funcionales.
5. **Análisis Reflexivo:**
   - Comparar bases de datos relacionales con NoSQL, destacando ventajas y limitaciones.

---

Esta actividad guía a los alumnos desde la configuración de una base de datos relacional en RDS hasta el manejo de datos con SQL y Python, sentando las bases para proyectos más avanzados en Big Data.
