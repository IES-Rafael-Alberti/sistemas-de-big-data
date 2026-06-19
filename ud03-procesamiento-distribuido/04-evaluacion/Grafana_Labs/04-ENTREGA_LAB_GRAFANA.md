# UD3 - Laboratorio Grafana  
## Visualizacion de metricas y observabilidad  
### Documento de entrega y rubrica

---

## 1. Datos del grupo

Alumno o alumna(s):

- Nombre y apellidos:
- Nombre y apellidos (si procede):

Grupo:  
Fecha de entrega:

---

## 2. Objetivo del laboratorio

El objetivo de este laboratorio es trabajar con Grafana como herramienta de visualizacion de metricas temporales y observabilidad tecnica, utilizando Prometheus como fuente de datos, y creando paneles y dashboards a partir de las metricas generadas por un servicio simulado.

---

## 3. Entorno de trabajo

Indica el entorno utilizado:

- Sistema operativo:
- Contenedores utilizados (Docker o Podman):
- Version de Grafana:
- Version de Prometheus:

---

## 4. Configuracion de la fuente de datos

Indica si se ha realizado correctamente la configuracion de Prometheus como fuente de datos en Grafana.

Marca lo que proceda:

- [ ] Prometheus configurado como Data Source
- [ ] Conexion verificada correctamente
- [ ] No se han producido errores en la conexion

Breve descripcion (opcional):

---

## 5. Paneles obligatorios

En este laboratorio son **obligatorios los Paneles 1 y 2**.  
El Panel 3 es **opcional** y permite mejorar la calificacion.

---

### 5.1 Panel 1 - Uso simulado de CPU (OBLIGATORIO)

- [ ] Panel creado correctamente
- [ ] Metrica utilizada: `fake_cpu_usage`
- [ ] Tipo de visualizacion adecuado (Time series)
- [ ] Titulo del panel correcto

Breve descripcion de la informacion que aporta el panel:

(Incluir captura de pantalla)

---

### 5.2 Panel 2 - Peticiones simuladas (OBLIGATORIO)

- [ ] Panel creado correctamente
- [ ] Metrica utilizada: `fake_requests_total`
- [ ] Tipo de visualizacion adecuado (Time series o Stat)
- [ ] Titulo del panel correcto

Breve descripcion de la informacion que aporta el panel:

(Incluir captura de pantalla)

---

### 5.3 Panel 3 - Comparacion de metricas (OPCIONAL)

Este panel es **opcional** y permite mejorar la calificacion final.

- [ ] Panel creado
- [ ] Se utilizan al menos dos metricas
- [ ] Panel correctamente interpretado

Breve descripcion del panel:

(Incluir captura de pantalla)

---

## 6. Dashboard final

Describe el dashboard creado a partir de los paneles anteriores:

- Numero total de paneles:
- Organizacion general del dashboard:
- Objetivo del dashboard:

(Incluir captura de pantalla del dashboard completo)

---

## 7. Analisis e interpretacion

Responde de forma razonada:

1. Que informacion se obtiene rapidamente del dashboard?
2. Que tipo de problemas tecnicos podrian detectarse con estas metricas?
3. Que limitaciones tiene este enfoque de observabilidad?

---

## 8. Comparacion Grafana vs Kibana

Desde tu experiencia practica, responde:

1. Para que tipo de datos resulta mas adecuado Grafana?
2. En que casos seguirias utilizando Kibana?
3. Consideras que son herramientas complementarias? Por que?

---

## 9. Dificultades encontradas

Describe brevemente cualquier dificultad tecnica o conceptual encontrada y como se resolvio.

(Si no hubo dificultades, indicarlo expresamente)

---

## 10. Reflexion final

Reflexiona brevemente (5 a 10 lineas):

- que has aprendido con Grafana,
- en que se diferencia de otras herramientas vistas,
- en que tipo de proyectos consideras util esta herramienta.

---

# Rubrica de evaluacion

---

## Criterios de evaluacion

### Configuracion del entorno (2 puntos)

- [ ] Fuente de datos Prometheus correctamente configurada (1 punto)
- [ ] Entorno funcional sin errores (1 punto)

---

### Paneles obligatorios (5 puntos)

**Panel 1 - Uso simulado de CPU (2.5 puntos)**  
- [ ] Metrica correcta  
- [ ] Visualizacion adecuada  
- [ ] Interpretacion correcta  

**Panel 2 - Peticiones simuladas (2.5 puntos)**  
- [ ] Metrica correcta  
- [ ] Visualizacion adecuada  
- [ ] Interpretacion correcta  

---

### Panel opcional (1 punto)

**Panel 3 - Comparacion de metricas**

- [ ] Panel correctamente creado
- [ ] Uso adecuado de varias metricas

(Solo puntua si esta realizado)

---

### Dashboard final (1 punto)

- [ ] Paneles correctamente integrados
- [ ] Dashboard claro y coherente

---

### Analisis y reflexion (1 punto)

- [ ] Respuestas razonadas
- [ ] Comprension del enfoque de observabilidad

---

## Calificacion final

Puntuacion obtenida: ____ / 10

---

## Fin del documento de entrega