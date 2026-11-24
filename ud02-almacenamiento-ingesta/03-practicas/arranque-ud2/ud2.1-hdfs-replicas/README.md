# UD2.1 — Simulación de réplicas de bloques (HDFS, modo didáctico)

## Qué hay en esta carpeta

- `README.md` → este fichero.
- `simular_replicas.py` → simulador sencillo de distribución de bloques y réplicas. **No necesita un clúster real de Hadoop/HDFS**; sirve para razonar sobre el mismo concepto.

## Escenario

Imagina que tenemos un archivo de **400 MiB** que se almacena en un sistema de ficheros distribuido con estas reglas:

- Tamaño de bloque: **128 MiB**.
- Factor de réplicas: **3** (cada bloque se copia 3 veces en nodos distintos).
- Nodos disponibles: **N1, N2, N3, N4**.

El simulador parte el archivo en 4 bloques: tres de 128 MiB y uno de 16 MiB (la cola del último bloque).

## Antes de ejecutar

1. Abre una terminal en esta carpeta.
2. Sin ejecutar el programa, responde en tu cuaderno:
   - ¿Cuántos bloques tendrá el archivo?
   - ¿Cuánto espacio en bruto (raw) ocuparán todas las réplicas juntas?
   - ¿Qué crees que pasará si falla **N1**?
   - ¿Qué crees que pasará si fallan **N1, N2 y N3** a la vez?

## Cómo ejecutar

Requiere Python 3 (cualquier versión reciente). Desde esta carpeta:

```bash
python3 simular_replicas.py
```

Muestra el estado sano: todos los nodos vivos y cada bloque con sus 3 réplicas.

## Comprobar fallos de nodos

Prueba estos dos casos y compara con tu predicción:

```bash
python3 simular_replicas.py N1
python3 simular_replicas.py N1 N2 N3
```

El programa indica, bloque a bloque, qué réplicas siguen vivas y si el archivo completo sigue siendo reconstruible.

## Reglas clave que ilustra el simulador

- Un bloque se considera perdido solo si **ninguna** de sus réplicas está viva.
- El archivo se considera perdido si **algún bloque** está perdido.
- Por eso HDFS reparte las réplicas entre racks/nodos: aguantar fallos sin perder datos.

## Nota importante

Esto es una **simulación didáctica**, no un clúster HDFS real. No necesitas Hadoop, Java, claves SSH ni Docker.
