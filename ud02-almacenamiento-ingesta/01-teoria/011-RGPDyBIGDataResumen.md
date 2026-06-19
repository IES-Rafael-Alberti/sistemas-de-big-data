---
title: "RGPD y Big Data: Guía esencial para estudiantes"
subtitle: "Módulo: Sistemas de Big Data (SBD)"
author: "José Manuel Sánchez Álvarez"
lang: "es"
toc: true
numbersections: true
fontsize: 11pt
geometry: margin=2.5cm
---

# 1. Introducción

El Reglamento General de Protección de Datos (RGPD) no es un obstáculo para el Big Data.  
Es un **marco que permite tratar datos masivos sin vulnerar derechos fundamentales**.

En esta unidad aprenderás cómo los principios del RGPD se aplican en proyectos reales de Big Data y qué medidas técnicas debes implementar cuando trabajas con información personal.

---

# 2. Qué son datos personales

Se considera dato personal *cualquier información que identifique o pueda identificar a una persona*.  
Incluye:

- Nombre, dirección, email, teléfono  
- IP, cookies, identificadores de dispositivo  
- Historial de compras, comportamiento digital  
- Geolocalización  
- Datos de salud, biometría o ideología (datos sensibles)

Estos datos requieren protección reforzada.

---

# 3. Principios del RGPD aplicados al Big Data

## 3.1 Licitud, lealtad y transparencia
Debe existir una base legal clara. Los usuarios deben saber qué datos se recogen y para qué.

**Ejemplo:** un sistema de recomendaciones debe informar de que analiza hábitos de navegación.

## 3.2 Limitación de la finalidad
Los datos se usan sólo para el fin declarado.

## 3.3 Minimización
Recolectar únicamente lo necesario.  
Evita el enfoque “guardo todo por si acaso”.

## 3.4 Exactitud
Los datos deben ser correctos y estar actualizados.

## 3.5 Limitación del plazo de conservación
No almacenar indefinidamente. Deben existir políticas de borrado.

## 3.6 Integridad y confidencialidad
Medidas técnicas: cifrado, control de accesos, auditoría, anonimización.

## 3.7 Responsabilidad proactiva (*accountability*)
Debe demostrarse el cumplimiento del RGPD mediante documentación y medidas técnicas.

---

# 4. Derechos de las personas en Big Data

- Acceso  
- Rectificación  
- Supresión (*derecho al olvido*)  
- Portabilidad  
- Oposición  
- No ser objeto de decisiones automatizadas sin garantías

En sistemas masivos es obligatorio aplicar estos derechos aunque existan múltiples capas de datos.

---

# 5. Evaluación de Impacto (DPIA)

Obligatoria en tratamientos de alto riesgo:

- Perfiles masivos  
- IA predictiva  
- Datos especialmente protegidos  
- Observación sistemática o monitorización

---

# 6. Brechas de seguridad en Big Data

No son sólo ciberataques:

- Buckets abiertos  
- Logs con datos personales  
- Copias de seguridad sin cifrado  
- Permisos incorrectos en clusters  
- Publicación accidental en GitHub

---

# 7. Principios RGPD vs. retos del Big Data

| Principio RGPD | Reto Big Data | Ejemplo |
|----------------|---------------|---------|
| Minimización   | Captura masiva de datos | Retirar columnas innecesarias |
| Transparencia  | Modelos complejos | Explicar recomendaciones |
| Limitación de la finalidad | Reutilización de datos | No usar datos educativos para marketing |
| Seguridad      | Infraestructuras distribuidas | Cifrado + control de accesos |
| Derecho al olvido | Sistemas replicados | Borrar datos en todas las capas |

---

# 8. Actividades en clase

- Análisis de casos reales  
- Simulaciones (empresa vs. autoridad de protección)  
- Diseño de un pipeline con minimización y anonimización  
- Debates éticos sobre IA y privacidad  

---

# 9. Conclusión

El RGPD es un aliado del Big Data.  
Un profesional debe saber:

- cómo minimizar datos,  
- cómo anonimizar correctamente,  
- cómo documentar tratamientos,  
- cómo garantizar seguridad y transparencia.

---