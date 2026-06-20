import os
import re
from pathlib import Path

EXCLUDE_DIRS = {'90-archivo', '99-profesor', '_profesor', 'Presentaciones', '__pycache__'}
EXCLUDE_FILES = {
    'README_Docente.md', 'README_Ingesta.md', 'referencia_meltano.md',
}

SECTION_ORDER = {
    '01-teoria': 'Teoría',
    '02-ejemplos': 'Ejemplos',
    '03-practicas': 'Prácticas',
    '04-evaluacion': 'Evaluación',
    '05-recursos': 'Recursos',
    '06-extra': 'Extra',
}
SECTION_KEYS = list(SECTION_ORDER.keys())


FILE_TITLE_OVERRIDES = {
    'guion_proyecto.md': 'Guion del proyecto',
    'UD1_Dossier_Completo.md': 'Dossier completo',
    'UD1-Parte0-BaseMatematica/UD1_P0_Capsula_Matematica_Normativa.md': 'Cápsula matemática — normativa',
    'UD1-Parte0-BaseMatematica/UD1_P0_Estadistica_para_BigData.md': 'Estadística para Big Data',
}


def clean_title(filename, rel_path=''):
    if rel_path and rel_path in FILE_TITLE_OVERRIDES:
        return FILE_TITLE_OVERRIDES[rel_path]
    name = filename.replace('.md', '')
    # Remove UD-prefixed codes: UD1_01_, UD1_P3_, 001-, 00-, etc.
    name = re.sub(r'^UD\d+(_[A-Z]\d+)?_', '', name, flags=re.IGNORECASE)
    name = re.sub(r'^\d{2,3}-', '', name)
    # Replace separators
    name = name.replace('_', ' ').replace('-', ' ').replace('.', ' ')
    name = re.sub(r'\s+', ' ', name).strip()
    if len(name) > 75:
        name = name[:72] + '...'
    return name or filename.replace('.md', '')


def scan_files(dirpath, docs_dir):
    """Scan a directory for md files, return nav entries."""
    entries = []
    try:
        items = sorted(os.listdir(dirpath))
    except PermissionError:
        return entries

    for item in items:
        if item.startswith('.'):
            continue
        path = os.path.join(dirpath, item)

        # Build relative path from docs/ for MkDocs
        rel = str(Path(path).relative_to(docs_dir))

        if os.path.isdir(path):
            if item in EXCLUDE_DIRS:
                continue
            sub = scan_files(path, docs_dir)
            if sub:
                nice = item.replace('-', ' ').replace('_', ' ').title()
                entries.append({nice: sub})
        elif item.endswith('.md') and item not in EXCLUDE_FILES:
            title = clean_title(item, rel)
            entries.append({title: rel})

    return entries


def scan_unit(unit_symlink, docs_dir, index_path):
    """Scan a unit directory via its symlink in docs/."""
    children = [{'Guía de la unidad': index_path}]

    # Top-level md files besides README (e.g. guion_proyecto.md)
    for item in sorted(os.listdir(unit_symlink)):
        if item == 'README.md' or item in EXCLUDE_FILES:
            continue
        item_path = unit_symlink / item
        if not item_path.is_file() or not item.endswith('.md'):
            continue
        rel = str(item_path.relative_to(docs_dir))
        title = clean_title(item, rel)
        children.append({title: rel})

    # Grouped sections
    for section_key, section_title in SECTION_ORDER.items():
        section_path = unit_symlink / section_key
        if not section_path.is_dir():
            continue
        entries = scan_files(section_path, docs_dir)
        if entries:
            children.append({section_title: entries})

    # Remaining dirs not in SECTION_ORDER
    for item in sorted(os.listdir(unit_symlink)):
        if item.startswith('.') or item in EXCLUDE_DIRS:
            continue
        if item in SECTION_KEYS:
            continue
        item_path = unit_symlink / item
        if not item_path.is_dir():
            continue
        entries = scan_files(item_path, docs_dir)
        if entries:
            nice = item.replace('-', ' ').replace('_', ' ').title()
            children.append({nice: entries})

    return children


def on_config(config):
    docs_dir = Path(config['docs_dir'])

    nav = [{'Inicio': 'index.md'}]

    UNIT_NAMES = {
        'ud01-introduccion-big-data': ('UD1 — Introducción Big Data', 'unidades/ud01.md'),
        'ud02-almacenamiento-ingesta': ('UD2 — Almacenamiento e Ingesta', 'unidades/ud02.md'),
        'ud03-procesamiento-distribuido': ('UD3 — Procesamiento Distribuido', 'unidades/ud03.md'),
        'ud04-bi-orquestacion': ('UD4 — BI y Orquestación', 'unidades/ud04.md'),
        'ud05-spark-mllib': ('UD5 — Spark MLlib', 'unidades/ud05.md'),
        'ud06-proyecto': ('UD6 — Proyecto Integrador', 'unidades/ud06.md'),
    }

    for unit_dirname in sorted(UNIT_NAMES):
        unit_symlink = docs_dir / unit_dirname
        if not unit_symlink.exists():
            continue

        unit_title, index_path = UNIT_NAMES[unit_dirname]
        children = scan_unit(unit_symlink, docs_dir, index_path)
        if children:
            nav.append({unit_title: children})

    # Plantillas section
    plantillas = docs_dir / 'plantillas'
    if plantillas.is_dir():
        entries = scan_files(plantillas, docs_dir)
        if entries:
            nav.append({'Plantillas': entries})

    config['nav'] = nav
    return config
