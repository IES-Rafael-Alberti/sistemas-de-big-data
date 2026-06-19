# Zeppelin con cluster spark en contenedores distribuidos

Si los workers de Spark están en máquinas físicas (hosts) diferentes al maestro de Spark, docker-compose por sí solo ya no es suficiente. docker-compose está diseñado principalmente para orquestación multi-contenedor en un solo host.

Para desplegar contenedores de Docker a través de múltiples máquinas físicas, necesitas una herramienta de orquestación de clústeres como Docker Swarm o Kubernetes.

Aquí te explico los pasos conceptuales y qué ajustes necesitas hacer:

## Requerimientos para múltiples máquinas físicas:

- Orquestación de Contenedores: Debes configurar tus máquinas físicas como un clúster de Docker Swarm. El maestro de Spark se convertirá en el "manager" del Swarm y los workers de Spark serán los "nodos worker" del Swarm.

- Networking: Docker Swarm utiliza overlay networks (redes superpuestas) que permiten que los contenedores en diferentes máquinas físicas se comuniquen entre sí como si estuvieran en la misma red local.

- Visibilidad de IP: Cuando los contenedores están en hosts diferentes, no puedes confiar en localhost ni en los nombres de servicio de docker-compose sin Swarm. Debes usar la IP pública o el nombre de host visible externamente del maestro de Spark.

## Pasos Modificados (Usando Docker Swarm)

1. Configurar Docker Swarm
En la máquina que actuará como maestro de Spark y Zeppelin (Host A):

```bash
docker swarm init --advertise-addr <IP_PUBLICA_O_PRIVADA_DEL_HOST_A>
```

Este comando te dará un token para unir otras máquinas.
En cada máquina que actuará como worker de Spark (Host B, C...):

```bash
docker swarm join --token <TOKEN_GENERADO> <IP_PUBLICA_O_PRIVADA_DEL_HOST_A>:2377
```

2. Crear una Red Overlay
En el Host A (el manager de Swarm), crea una red overlay para que todos los servicios puedan comunicarse:

``` bash
docker network create --driver overlay spark-network
```

3. Adaptar el Archivo de Despliegue (docker-compose.yml)

Ahora, usarás este archivo con docker stack deploy en lugar de docker-compose up. Debes añadir la red externa que acabas de crear y especificar cómo se despliegan los servicios.

``` yaml
version: '3.8'

services:
  spark-master:
    image: apache/spark:3.5.4
    container_name: spark-master # Container name es menos relevante en Swarm, usa service name
    hostname: spark-master
    command: >
      /opt/spark/bin/spark-class
      org.apache.spark.deploy.master.Master
    ports:
      - "7077:7077"
      - "8080:8080"
    volumes:
      - ./apps:/opt/spark-apps
      - ./data:/opt/spark-data
    networks:
      - spark-network # Asigna a la red overlay
    deploy:
      replicas: 1 # Solo 1 maestro
      placement:
        constraints:
          - node.role == manager # Asegura que corra en el nodo manager (Host A)

  spark-worker: # Renombramos a 'spark-worker' genérico, Swarm creará múltiples instancias
    image: apache/spark:3.5.4
    # No usamos container_name ni hostname fijos aquí, Swarm los gestiona
    command: >
      /opt/spark/bin/spark-class
      org.apache.spark.deploy.worker.Worker
      spark://spark-master:7077 # Usa el nombre del servicio Master, que Swarm resuelve
    ports:
      # Expón solo si necesitas acceso individual a la UI del worker, si no, omite los puertos
      - "8081-8090:8080" # Usa un rango para evitar conflictos si hay múltiples workers en un host
    environment:
      - "SPARK_WORKER_CORES=2"
      - "SPARK_WORKER_MEMORY=4g"
    volumes:
      - ./apps:/opt/spark-apps
      - ./data:/opt/spark-data
    networks:
      - spark-network
    deploy:
      mode: global # Despliega un worker en CADA nodo Swarm disponible
      # Alternativa: replicas: 3 # Despliega 3 workers en total, distribuidos automáticamente

  zeppelin:
    image: apache/zeppelin:0.11.0
    ports:
      - "8082:8080"
    volumes:
      - ./zeppelin/notebook:/opt/zeppelin/notebook
      - ./zeppelin/conf:/opt/zeppelin/conf
    environment:
      # Sigue usando el nombre del servicio Master
      - "SPARK_MASTER=spark://spark-master:7077"
    networks:
      - spark-network
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == manager # Mantenlo junto al maestro en el Host A

# Define la red externa que creamos manualmente
networks:
  spark-network:
    external: true

```

4. Desplegar el Stack
En el Host A (manager), despliega el stack:

``` bash
docker stack deploy -c docker-compose.yml sparkcluster
```

Docker Swarm se encargará de desplegar los contenedores spark-master y zeppelin en el Host A y distribuirá los contenedores spark-worker globalmente en todos los nodos (Host A, B, C...).


5. Configuración de Zeppelin
Sigue siendo la misma que antes: en la UI de Zeppelin, asegúrate de que el intérprete de Spark apunte a spark://spark-master:7077. El service discovery de Swarm se encargará de resolver spark-master a la IP correcta dentro de la red overlay
