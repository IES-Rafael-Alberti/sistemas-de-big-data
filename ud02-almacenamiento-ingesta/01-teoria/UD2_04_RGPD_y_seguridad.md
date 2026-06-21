# UD2 · RGPD y seguridad (plantilla rápida)

> Usa esta **plantilla** como `README_RGPD.md` en tu repo.

## 1. Naturaleza de los datos
- [ ] Contienen **datos personales (PII)**  
  - [ ] Directos (nombre, email, teléfono)  
  - [ ] Indirectos (ID dispositivo, IP, cookie)  
- [ ] **No** contienen PII (datos abiertos / agregados)

### Comprobación operativa mínima

Antes de publicar un dataset o usarlo en una práctica, revisa las columnas con esta tabla:

| Tipo de riesgo | Ejemplos | Qué hacer |
| -------------- | -------- | --------- |
| Identificador directo | DNI, email, teléfono, nombre completo | Eliminar, enmascarar o sustituir por identificador no reversible. |
| Identificador indirecto | IP, usuario, código postal, ubicación precisa, fecha/hora exacta | Generalizar, agrupar o justificar por qué no permite identificar. |
| Dato sensible | salud, ideología, menores, sanciones, datos biométricos | No usar salvo base legal clara y autorización docente. |
| Secreto técnico | token, contraseña, `.env`, clave API | Sacar del repositorio y rotar si se ha expuesto. |

Si no hay identificadores, escribe explícitamente:

> Anonimización completada: no se han detectado datos personales ni identificadores directos o indirectos.

Si los hay, documenta qué columnas se han eliminado, agregado, generalizado o seudonimizado.

## 2. Base jurídica (si hay PII)
- [ ] Consentimiento | [ ] Contrato | [ ] Interés legítimo | [ ] Obligación legal

## 3. Minimización y finalidad
- [ ] Solo campos necesarios
- [ ] Finalidad documentada (BI / control operativo / docencia)

## 4. Medidas técnicas
- [ ] **.env** con credenciales (no subir secretos)  
- [ ] Cifrado **en tránsito** (HTTPS)  
- [ ] Cifrado **en reposo** (si aplica)  
- [ ] Control de acceso a BI (roles/lectura)

## 5. Derechos y retención
- [ ] Plazos de **retención** definidos  
- [ ] Procedimiento de **supresión** / **anonimización**

## 6. Auditoría y trazabilidad
- [ ] Logs de ingesta (éxito/error, nº filas)  
- [ ] Linaje (diagrama actualizado)  
- [ ] Versionado (tags/releases)

## 7. Evidencia que debe entregarse

- Tabla de columnas revisadas y decisión tomada.
- Captura o consulta que demuestre que no quedan identificadores directos.
- Explicación de posibles identificadores indirectos y mitigación aplicada.
- Confirmación de que no hay secretos en el repositorio.

**Contacto DPO (si aplica):** _nombre@centro.es_
