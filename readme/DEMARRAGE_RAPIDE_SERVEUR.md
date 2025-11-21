# 🚀 Démarrage Rapide : Ajouter un serveur

## Option 1 : Utiliser Nebula (Le plus simple) ⭐

1. **Télécharger Nebula**
   ```
   https://github.com/dscalzi/Nebula/releases
   ```

2. **Organiser vos fichiers**
   ```
   MonServeur/
   ├── mods/           # Vos mods .jar
   ├── config/         # Fichiers de config
   └── resourcepacks/  # Resource packs
   ```

3. **Lancer Nebula et suivre l'assistant**
   - Sélectionner le dossier
   - Remplir les infos du serveur
   - Générer `distribution.json`

4. **Héberger les fichiers**
   - Uploader sur GitHub Pages, votre serveur web, etc.
   - Obtenir l'URL du `distribution.json`

5. **Configurer le launcher**
   ```javascript
   // Dans app/assets/js/distromanager.js
   exports.REMOTE_DISTRO_URL = 'https://VOTRE-URL/distribution.json'
   ```

6. **Tester**
   ```bash
   npm start
   ```

---

## Option 2 : Configuration manuelle rapide

### 1. Utiliser le script MD5

```bash
# Pour un seul fichier
python tools/calculate_md5.py mods/monmod.jar

# Pour un dossier entier
python tools/calculate_md5.py mods/ https://votre-site.com/mods
```

Cela génère automatiquement le JSON à copier dans `distribution.json` !

### 2. Modifier le template

Éditez `distribution_template.json` :
- Changez l'adresse du serveur
- Ajoutez vos mods (utilisez le JSON généré)
- Mettez vos URLs

### 3. Héberger et configurer

Comme dans l'option 1, étapes 4-6.

---

## 🎯 Exemple minimal qui fonctionne

```json
{
    "version": "1.0.0",
    "servers": [{
        "id": "CobbleNuutt-1.20.1",
        "name": "CobbleNuutt",
        "description": "Serveur CobbleNuutt",
        "icon": "https://i.imgur.com/VOTRE_IMAGE.png",
        "version": "1.0.0",
        "address": "play.cobbenuutt.com:25565",
        "minecraftVersion": "1.20.1",
        "mainServer": true,
        "autoconnect": true,
        "modules": []
    }]
}
```

Hébergez ce fichier, changez l'URL dans `distromanager.js`, et ça fonctionne !

---

## ⚠️ Points importants

1. **Tous les fichiers doivent être en HTTPS**
2. **Les URLs doivent être directes** (pas de page de téléchargement)
3. **Calculez les MD5 correctement**
4. **Testez chaque URL dans un navigateur**

---

## 📚 Documentation complète

Pour plus de détails, voir `GUIDE_SERVEUR.md`

---

## 🆘 Problèmes courants

**Le launcher ne démarre pas**
→ Vérifiez la syntaxe JSON sur https://jsonlint.com/

**Les fichiers ne se téléchargent pas**
→ Vérifiez que les URLs sont accessibles en HTTPS

**Erreur de MD5**
→ Recalculez le MD5 après avoir uploadé le fichier

**Le jeu ne se lance pas**
→ Vérifiez les logs dans la console (CTRL+Shift+I)
