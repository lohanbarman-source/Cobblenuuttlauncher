#!/usr/bin/env python3
"""
Script pour calculer les MD5 et tailles des fichiers pour distribution.json
Usage: python calculate_md5.py <fichier_ou_dossier>
"""

import hashlib
import os
import sys
import json
from pathlib import Path


def calculate_md5(filepath):
    """Calcule le hash MD5 d'un fichier"""
    md5 = hashlib.md5()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(8192), b''):
            md5.update(chunk)
    return md5.hexdigest()


def get_file_size(filepath):
    """Retourne la taille du fichier en octets"""
    return os.path.getsize(filepath)


def format_size(size):
    """Formate la taille en unités lisibles"""
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size < 1024.0:
            return f"{size:.2f} {unit}"
        size /= 1024.0
    return f"{size:.2f} TB"


def process_file(filepath):
    """Traite un fichier et retourne ses informations"""
    filepath = Path(filepath)
    if not filepath.exists():
        print(f"❌ Erreur: Le fichier {filepath} n'existe pas")
        return None

    if filepath.is_dir():
        print(f"📁 {filepath.name} est un dossier, traitement de tous les fichiers...")
        return process_directory(filepath)

    print(f"🔍 Traitement de {filepath.name}...")
    size = get_file_size(filepath)
    md5 = calculate_md5(filepath)

    result = {
        "file": str(filepath.name),
        "path": str(filepath),
        "size": size,
        "size_formatted": format_size(size),
        "MD5": md5
    }

    print(f"✅ {filepath.name}")
    print(f"   Taille: {format_size(size)} ({size} octets)")
    print(f"   MD5: {md5}")
    print()

    return result


def process_directory(dirpath):
    """Traite tous les fichiers d'un dossier"""
    results = []
    dirpath = Path(dirpath)

    # Extensions de fichiers à traiter
    extensions = ['.jar', '.zip', '.json', '.cfg', '.toml', '.txt', '.png', '.jpg']

    for root, dirs, files in os.walk(dirpath):
        for filename in files:
            filepath = Path(root) / filename
            if filepath.suffix.lower() in extensions:
                result = process_file(filepath)
                if result:
                    results.append(result)

    return results


def generate_json_snippet(file_info, base_url, module_type="ForgeMod"):
    """Génère un snippet JSON pour distribution.json"""
    filename = file_info['file']
    name_without_ext = filename.rsplit('.', 1)[0]

    snippet = {
        "id": f"com.cobbenuutt:{name_without_ext.lower()}:1.0.0",
        "name": name_without_ext,
        "type": module_type,
        "artifact": {
            "size": file_info['size'],
            "MD5": file_info['MD5'],
            "url": f"{base_url}/{filename}"
        }
    }

    if module_type == "ForgeMod":
        snippet["required"] = {"value": True}

    return snippet


def main():
    if len(sys.argv) < 2:
        print("Usage: python calculate_md5.py <fichier_ou_dossier> [base_url]")
        print("\nExemples:")
        print("  python calculate_md5.py monmod.jar")
        print("  python calculate_md5.py ./mods")
        print("  python calculate_md5.py ./mods https://votre-site.com/mods")
        sys.exit(1)

    target = sys.argv[1]
    base_url = sys.argv[2] if len(sys.argv) > 2 else "https://votre-site.com/files"

    print("=" * 60)
    print("📦 Calculateur MD5 pour CobbleNuutt Launcher")
    print("=" * 60)
    print()

    result = process_file(target)

    if not result:
        sys.exit(1)

    # Si c'est un dossier, result est une liste
    results = result if isinstance(result, list) else [result]

    if not results:
        print("❌ Aucun fichier traité")
        sys.exit(1)

    # Générer le JSON
    print("\n" + "=" * 60)
    print("📄 Snippets JSON pour distribution.json:")
    print("=" * 60)
    print()

    snippets = []
    for file_info in results:
        # Déterminer le type de module selon l'extension
        ext = Path(file_info['file']).suffix.lower()
        if ext == '.jar':
            if 'forge' in file_info['file'].lower():
                module_type = "ForgeHosted"
            else:
                module_type = "ForgeMod"
        elif ext == '.json':
            module_type = "VersionManifest"
        else:
            module_type = "File"

        snippet = generate_json_snippet(file_info, base_url, module_type)
        snippets.append(snippet)

    print(json.dumps(snippets, indent=4, ensure_ascii=False))

    # Sauvegarder dans un fichier
    output_file = "modules_generated.json"
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(snippets, f, indent=4, ensure_ascii=False)

    print()
    print(f"✅ JSON sauvegardé dans: {output_file}")
    print()
    print("=" * 60)
    print(f"✅ {len(results)} fichier(s) traité(s) avec succès!")
    print("=" * 60)


if __name__ == '__main__':
    main()
