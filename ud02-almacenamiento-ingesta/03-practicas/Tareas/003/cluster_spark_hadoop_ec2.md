Montar un clúster con Apache Spark y Hadoop (HDFS) en AWS con un nodo maestro y dos secundarios es un proceso que implica varios pasos. Aquí tienes una guía general para hacerlo:

1. **Lanzar instancias EC2**:
   - Inicia sesión en la consola de AWS.
   - Ve a la sección de EC2 y haz clic en "Launch Instance".
   - Selecciona una AMI (Amazon Machine Image), como Ubuntu.
   - Elige el tipo de instancia según tus necesidades (por ejemplo, t2.micro para pruebas).
   - Lanza una instancia para el nodo maestro y dos instancias para los nodos secundarios.

2. **Conectar a las instancias**:
   - Una vez lanzadas las instancias, conéctate a ellas usando SSH.
   - Puedes encontrar las instrucciones de conexión en la consola de AWS.

3. **Actualizar los paquetes del sistema**:
   ```bash
   sudo apt-get update
   sudo apt-get upgrade
   ```

4. **Instalar Java**:
   Apache Spark y Hadoop requieren Java para funcionar.
   ```bash
   sudo apt-get install openjdk-11-jdk
   ```

5. **Descargar e instalar Hadoop**:
   - Descarga Hadoop desde el sitio oficial.
   ```bash
   wget https://downloads.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz
   tar -xzvf hadoop-3.3.1.tar.gz
   sudo mv hadoop-3.3.1 /usr/local/hadoop
   ```

6. **Configurar las variables de entorno de Hadoop**:
   - Edita el archivo `.bashrc` para añadir las variables de entorno de Hadoop.
   ```bash
   nano ~/.bashrc
   ```
   - Añade las siguientes líneas al final del archivo:
   ```bash
   export HADOOP_HOME=/usr/local/hadoop
   export HADOOP_INSTALL=$HADOOP_HOME
   export HADOOP_MAPRED_HOME=$HADOOP_HOME
   export HADOOP_COMMON_HOME=$HADOOP_HOME
   export HADOOP_HDFS_HOME=$HADOOP_HOME
   export YARN_HOME=$HADOOP_HOME
   export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
   export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
   ```
   - Guarda y cierra el archivo, luego recarga las variables de entorno:
   ```bash
   source ~/.bashrc
   ```

7. **Configurar Hadoop**:
   - Edita los archivos de configuración de Hadoop (`core-site.xml`, `hdfs-site.xml`, `mapred-site.xml`, `yarn-site.xml`) ubicados en el directorio `etc/hadoop` dentro de la instalación de Hadoop.
   - Aquí tienes un ejemplo de configuración básica para `core-site.xml`:
   ```xml
   <configuration>
       <property>
           <name>fs.defaultFS</name>
           <value>hdfs://localhost:9000</value>
       </property>
   </configuration>
   ```

8. **Crear directorios para Hadoop**:
   ```bash
   sudo mkdir -p /usr/local/hadoop/hdfs/namenode
   sudo mkdir -p /usr/local/hadoop/hdfs/datanode
   ```

9. **Formatear el NameNode**:
   ```bash
   hdfs namenode -format
   ```

10. **Iniciar Hadoop**:
    - Inicia los servicios de Hadoop:
    ```bash
    start-dfs.sh
    start-yarn.sh
    ```

11. **Instalar Apache Spark**:
    - Descarga Apache Spark desde el sitio oficial.
    ```bash
    wget https://downloads.apache.org/spark/spark-3.3.1/spark-3.3.1-bin-hadoop3.2.tgz
    tar -xzvf spark-3.3.1-bin-hadoop3.2.tgz
    sudo mv spark-3.3.1-bin-hadoop3.2 /usr/local/spark
    ```

12. **Configurar las variables de entorno de Spark**:
    - Edita el archivo `.bashrc` para añadir las variables de entorno de Spark.
    ```bash
    nano ~/.bashrc
    ```
    - Añade las siguientes líneas al final del archivo:
    ```bash
    export SPARK_HOME=/usr/local/spark
    export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
    ```
    - Guarda y cierra el archivo, luego recarga las variables de entorno:
    ```bash
    source ~/.bashrc
    ```

13. **Configurar Spark**:
    - Edita los archivos de configuración de Spark (`spark-env.sh`, `spark-defaults.conf`, `slaves`) ubicados en el directorio `conf` dentro de la instalación de Spark.
    - Aquí tienes un ejemplo de configuración básica para `spark-env.sh`:
    ```bash
    export SPARK_MASTER_HOST='master-node-public-ip'
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    ```

14. **Configurar SSH sin contraseña**:
    - Configura SSH sin contraseña para permitir la comunicación entre los nodos.
    ```bash
    ssh-keygen -t rsa
    ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@<IP_del_nodo_secundario>
    ```

15. **Iniciar Spark**:
    - Inicia el nodo maestro:
    ```bash
    start-master.sh
    ```
    - Inicia los nodos secundarios:
    ```bash
    start-slave.sh spark://<IP_del_nodo_maestro>:7077
    ```

16. **Verificar la instalación**:
    - Puedes verificar que Spark y Hadoop están funcionando correctamente accediendo a las interfaces web de Spark en `http://<IP_del_nodo_maestro>:8080` y de Hadoop en `http://<IP_del_nodo_maestro>:9870`.

Para una guía más detallada y paso a paso, puedes consultar [este artículo](https://www.bing.com/search?q=ram+y+almacenamiento+m%C3%ADnimo+para+instalar+hadoop+en+linux&qs=n&form=QBRE&sp=-1&ghc=1&lq=0&pq=ram+y+almacenamiento+m%C3%ADnimo+para+instalar+hadoop+en+linux&sc=8-57&sk=&cvid=0688BDB3564344F6B2FDAA347F381E7D&ghsh=0&ghacc=0&ghpl=) o .

