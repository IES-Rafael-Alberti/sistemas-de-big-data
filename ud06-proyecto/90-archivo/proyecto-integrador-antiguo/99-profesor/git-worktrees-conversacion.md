# Git - Submódulos vs Worktrees vs Ramas

Conversación sobre organización de repositorio para asignaturas con múltiples unidades.

---

## Pregunta inicial

El usuario quiere hacer un repositorio para un directorio con diferentes unidades de una asignatura, donde cada unidad sea independiente y pueda subir solo las partesready. Consulta si los módulos son la solución.

## Respuesta sobre submódulos

Los submódulos son un puntero (referencia) a un commit específico de otro repositorio. No son la mejor opción para este caso porque están diseñados para dependencias externas (libraries, frameworks).

## Segunda duda del usuario

Las ramas por unidad generan problema de "vaivén" de archivos al hacer checkout/switch entre ramas.

## Opción 1: Un solo repositorio en main

Usar `.gitignore` para excluir archivos no listos:
```gitignore
*~
*.bak
borradores/
en-progreso/
```

## Opción 2: Git Worktrees

Permite tener varias ramas checkoutadas simultáneamente en carpetas distintas.

### Estructura propuesta:
```bash
~/curso/           # worktree principal (main)
~/curso-UD1/       # worktree para UD1 (rama UD1)
~/curso-UD2/       # worktree para UD2 (rama UD2)
```

### Comandos:
```bash
# Crear worktree para UD1
git worktree add ../curso-UD1 -b UD1

# Crear worktree para UD2
git worktree add ../curso-UD2 -b UD2

# Listar worktrees
git worktree list

# Eliminar worktree
git worktree remove ../curso-UD1
```

### Ventajas:
- Múltiples carpetas abiertas simultáneamente
- Cada unidad en su propia rama
- Comparten el mismo .git (sin duplicar historial)
- Commits visibles desde todos los worktrees

### Inconveniente:
- Cada worktree necesita sus propias dependencias

---

## Comparación final de opciones

| Opción | Pros | Contras |
|--------|------|---------|
| Un repo con .gitignore | Simple, todo visible | Histórico no limpio |
| Worktrees | Ramas aisladas + trabajo paralelo | Necesitas carpetas separadas |
| Varios repositorios | Totalmente independientes | Sin visión global |
| Submódulos | - | Demasiado complejos para este caso |

---

## Recomendación

Para el caso del usuario (múltiples unidades de una asignatura donde consulta materiales de otras unidades frecuentemente), **worktrees** es la mejor opción porque:
1. Permite trabajar en varias unidades simultáneamente
2. Cada unidad tiene su propia rama
3. No pierde contexto al cambiar entre unidades
