# UD2 · RGPD y seguridad (plantilla rápida)

> Usa esta **plantilla** como `README_RGPD.md` en tu repo.

## 1. Naturaleza de los datos
- [ ] Contienen **datos personales (PII)**  
  - [ ] Directos (nombre, email, teléfono)  
  - [ ] Indirectos (ID dispositivo, IP, cookie)  
- [ ] **No** contienen PII (datos abiertos / agregados)

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

**Contacto DPO (si aplica):** _nombre@centro.es_
