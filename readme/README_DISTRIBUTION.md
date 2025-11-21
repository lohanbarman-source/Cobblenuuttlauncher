# 📦 Guide de Distribution CobbleNuutt Launcher

Ce guide explique comment générer, déployer et maintenir la distribution pour le CobbleNuutt Launcher.

---

## 📋 Table des matières

1. [Prérequis](#prérequis)
2. [Architecture de la distribution](#architecture-de-la-distribution)
3. [Configuration de Nebula](#configuration-de-nebula)
4. [Génération de la distribution](#génération-de-la-distribution)
5. [Déploiement sur le serveur](#déploiement-sur-le-serveur)
6. [Test du launcher](#test-du-launcher)
7. [Mise à jour de la distribution](#mise-à-jour-de-la-distribution)
8. [Dépannage](#dépannage)
9. [Bonnes pratiques](#bonnes-pratiques)

---

## 🔧 Prérequis

### Logiciels requis

- **Node.js 20+** : https://nodejs.org/
  - Vérification : `node --version`
- **Java 21+** : https://adoptium.net/
  - Vérification : `java --version`
- **Git** : https://git-scm.com/
  - Vérification : `git --version`
- **Nebula** : https://github.com/dscalzi/Nebula
  - Outil officiel pour générer les distributions Helios Launcher

### Accès requis

- **Accès FTP/SFTP** au serveur web (nuutt-cobblemon.com)
  - Permissions de lecture/écriture sur `/site/`
- **Accès au serveur Minecraft** (optionnel pour tests)
  - Pour copier les mods et configs

### Espace disque

- **Local** : ~2GB minimum pour la distribution
- **Serveur web** : ~1GB pour les fichiers uploadés
- **Bande passante** : Upload initial de ~500MB-1GB

---

## 🏗️ Architecture de la distribution
(Fichier ZIP distribution.zip)

### Structure des dossiers

```
CobbleNuutt-Distribution/
├── distribution.json           # Fichier principal de la distribution
├── meta/
│   └── distrometa.json        # Métadonnées globales (RSS, Discord)
└── servers/
    └── CobbleNuutt-1.21.1/    # Serveur Minecraft
        ├── servermeta.json    # Configuration du serveur
        ├── server-icon.png    # Icône du serveur (optionnel)
        ├── files/             # Fichiers de configuration
        │   ├── config/        # Configs des mods
        │   ├── resourcepacks/ # Resource packs
        │   └── shaderpacks/   # Shader packs
        ├── libraries/         # Librairies Fabric
        └── fabricmods/        # Mods Fabric
            ├── required/      # Mods obligatoires
            ├── optionalon/    # Mods optionnels activés par défaut
            └── optionaloff/   # Mods optionnels désactivés par défaut
```

### Flux de distribution

1. **Génération locale** : Nebula scanne les mods et génère `distribution.json`
2. **Upload serveur** : Fichiers uploadés sur `https://nuutt-cobblemon.com/launcher/`
3. **Téléchargement client** : Le launcher télécharge et vérifie les fichiers
4. **Lancement jeu** : Minecraft démarre avec tous les mods

---

## ⚙️ Configuration de Nebula

### 1. Cloner et installer Nebula

```bash
# Cloner le dépôt Nebula
git clone https://github.com/dscalzi/Nebula.git
cd Nebula

# Installer les dépendances
npm install
```

### 2. Créer le fichier de configuration `.env`
(sera donne mais a modifier)

Créez un fichier `.env` à la racine du dossier Nebula :

**Windows :**
```properties
# Root directory où seront générés les fichiers de distribution
ROOT=D:\dev fivem\CobbleNuutt-Distribution

# Dossier de données du launcher (pour test local)
HELIOS_DATA_FOLDER=C:\Users\VOTRE_NOM\AppData\Roaming\CobbleNuutt Launcher

# URL publique où les fichiers seront hébergés (DOIT inclure https://)
BASE_URL=https://nuutt-cobblemon.com/launcher/

# Java 21 requis pour Minecraft 1.21.1
JAVA_EXECUTABLE=java
```

**⚠️ Points importants :**
- Remplacez `VOTRE_NOM` ou `votre-user` par votre nom d'utilisateur
- Sous Windows, utilisez des backslashes simples `\`
- `BASE_URL` DOIT commencer par `https://` et se terminer par `/`
- Le dossier `ROOT` sera créé automatiquement

### 3. Vérifier la configuration

```bash
# Afficher la version de Nebula
npm run start -- --version

# Tester que Nebula fonctionne
npm run start -- help
```

---

## 🏗️ Génération de la distribution

### Vue d'ensemble

La génération de la distribution se fait en 5 étapes principales :
1. Initialiser la structure
2. Générer le serveur Fabric
3. Copier les fichiers du serveur (mods, configs, etc.)
4. Configurer les métadonnées
5. Générer le fichier `distribution.json`

### Étape 1 : Initialiser la structure

```bash
cd Nebula
npm run start -- init root
```

**Ce que fait cette commande :**
- Crée le dossier `ROOT` défini dans `.env`
- Crée la structure `meta/` et `servers/`
- Prépare l'environnement pour la génération

**Résultat attendu :**
```
✓ Initialized root directory at D:\dev fivem\CobbleNuutt-Distribution
```

### Étape 2 : Générer le serveur Fabric

```bash
npm run start -- generate server CobbleNuutt 1.21.1 --fabric 0.17.2
```

**Paramètres :**
- `CobbleNuutt` : ID unique du serveur (pas d'espaces)
- `1.21.1` : Version de Minecraft
- `--fabric 0.17.2` : Version de Fabric Loader compatible

**Ce que fait cette commande :**
- Télécharge Fabric Loader 0.17.2
- Télécharge les librairies Minecraft 1.21.1
- Crée la structure du serveur
- Génère le fichier `servermeta.json` par défaut

**Résultat attendu :**
```
✓ Generated server CobbleNuutt-1.21.1
✓ Downloaded Fabric Loader 0.17.2
✓ Downloaded 45 libraries
```

**Note :** Si le serveur existe déjà, vous verrez une erreur. Voir [Dépannage](#erreur--server-already-exists).

### Étape 3 : Copier les fichiers du serveur

Cette étape consiste à copier tous les mods, configurations et ressources depuis votre serveur Minecraft vers la distribution.

#### A. Créer les dossiers fabricmods

**Windows (PowerShell) :**
```powershell
$distro = "D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1"
mkdir "$distro\fabricmods\required" -Force
mkdir "$distro\fabricmods\optionalon" -Force
mkdir "$distro\fabricmods\optionaloff" -Force
```

**Linux/Mac (Bash) :**
```bash
distro="/path/to/CobbleNuutt-Distribution/servers/CobbleNuutt-1.21.1"
mkdir -p "$distro/fabricmods/required"
mkdir -p "$distro/fabricmods/optionalon"
mkdir -p "$distro/fabricmods/optionaloff"
```

#### B. Copier les mods (REQUIS)

**Windows (PowerShell) :**
```powershell
$server = "D:\dev fivem\CobbleNuutt-Server"
$distro = "D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1"

# Copier tous les mods
Copy-Item "$server\mods\*" -Destination "$distro\fabricmods\required\" -Force
```

**Linux/Mac (Bash) :**
```bash
cp -r /path/to/CobbleNuutt-Server/mods/* "$distro/fabricmods/required/"
```

**Note :** Si certains mods doivent être optionnels, déplacez-les dans `optionalon/` ou `optionaloff/`.

#### C. Copier les configs

**Windows (PowerShell) :**
```powershell
Copy-Item "$server\config" -Destination "$distro\files\" -Recurse -Force
```

**Linux/Mac (Bash) :**
```bash
cp -r /path/to/CobbleNuutt-Server/config "$distro/files/"
```

#### D. Copier les resourcepacks (optionnel)

**Windows (PowerShell) :**
```powershell
if (Test-Path "$server\resourcepacks") {
    Copy-Item "$server\resourcepacks" -Destination "$distro\files\" -Recurse -Force
}
```

**Linux/Mac (Bash) :**
```bash
[ -d /path/to/CobbleNuutt-Server/resourcepacks ] && \
cp -r /path/to/CobbleNuutt-Server/resourcepacks "$distro/files/"
```

#### E. Copier les shaderpacks (optionnel)

**Windows (PowerShell) :**
```powershell
if (Test-Path "$server\shaderpacks") {
    Copy-Item "$server\shaderpacks" -Destination "$distro\files\" -Recurse -Force
}
```

**Linux/Mac (Bash) :**
```bash
[ -d /path/to/CobbleNuutt-Server/shaderpacks ] && \
cp -r /path/to/CobbleNuutt-Server/shaderpacks "$distro/files/"
```

**Résumé de ce qui a été copié :**
- ✅ ~138 mods Fabric dans `fabricmods/required/`
- ✅ Configurations des mods dans `files/config/`
- ✅ Resource packs (optionnel)
- ✅ Shader packs (optionnel)

### Étape 4 : Configurer les métadonnées

#### A. Éditer `servermeta.json`

Fichier : `D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1\servermeta.json`

Ce fichier contient toutes les informations sur votre serveur Minecraft.

```json
{
  "meta": {
    "version": "1.0.0",
    "name": "CobbleNuutt Server",
    "description": "Serveur Cobblemon CobbleNuutt - Attrapez-les tous !",
    "icon": "",
    "address": "play.nuutt-cobblemon.com:25565",
    "discord": {
      "shortId": "CobbleNuutt",
      "largeImageText": "CobbleNuutt Server",
      "largeImageKey": "server-cobbenuutt"
    },
    "mainServer": true,
    "autoconnect": true,
    "javaOptions": {
      "supported": ">=21",
      "suggestedMajor": 21,
      "ram": {
        "recommended": 6144,
        "minimum": 4096
      }
    }
  },
  "fabric": {
    "version": "0.17.2"
  }
}
```

**Détails des champs :**
- `version` : Version de la configuration du serveur (incrementez à chaque maj)
- `name` : Nom affiché dans le launcher
- `description` : Description affichée dans le launcher
- `icon` : Chemin vers l'icône (laissez vide pour `server-icon.png`)
- `address` : Adresse IP:Port du serveur Minecraft
- `discord` : Configuration pour Discord Rich Presence
  - `shortId` : ID court pour Discord
  - `largeImageText` : Texte au survol de l'image
  - `largeImageKey` : Clé de l'image (doit correspondre aux assets Discord)
- `mainServer` : `true` si c'est le serveur principal
- `autoconnect` : `true` pour se connecter automatiquement au lancement
- `javaOptions` :
  - `supported` : Versions Java supportées (syntaxe semver)
  - `suggestedMajor` : Version Java recommandée
  - `ram.recommended` : RAM recommandée en Mo (6144 = 6GB)
  - `ram.minimum` : RAM minimum en Mo (4096 = 4GB)

#### B. Créer `distrometa.json`

Fichier : `D:\dev fivem\CobbleNuutt-Distribution\meta\distrometa.json`

Ce fichier contient les métadonnées globales de la distribution (RSS, Discord).

```json
{
  "meta": {
    "rss": "https://nuutt-cobblemon.com/api/rss",
    "discord": {
      "clientId": "VOTRE_DISCORD_CLIENT_ID",
      "smallImageText": "CobbleNuutt",
      "smallImageKey": "cobbenuutt-logo"
    }
  }
}
```

**Détails des champs :**
- `rss` : URL du flux RSS pour les news du launcher (optionnel)
- `discord.clientId` : ID de l'application Discord pour Rich Presence
  - Créez une app Discord : https://discord.com/developers/applications
  - Copiez l'Application ID
- `discord.smallImageText` : Texte au survol de la petite icône
- `discord.smallImageKey` : Clé de l'image (uploadez dans Discord Developer Portal)

**Note :** Si vous n'utilisez pas Discord Rich Presence, vous pouvez omettre la section `discord`.

#### C. Ajouter l'icône du serveur (optionnel)

Copiez une image PNG ou JPG (recommandé : 256x256px) :
```
D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1\server-icon.png
```

**Formats acceptés :** PNG, JPG, JPEG
**Taille recommandée :** 256x256px ou 512x512px
**Poids max :** 500KB

### Étape 5 : Générer le distribution.json

Cette commande est la plus importante : elle scanne tous les fichiers et génère le `distribution.json`.

```bash
cd Nebula
npm run start -- generate distro
```

**Ce que fait cette commande :**
- ✅ Scanne tous les mods dans `fabricmods/` (~138 fichiers)
- ✅ Scanne tous les fichiers dans `files/` (configs, resourcepacks, etc.)
- ✅ Scanne toutes les librairies Fabric/Minecraft
- ✅ Calcule automatiquement les checksums MD5 de chaque fichier
- ✅ Génère le fichier `distribution.json` avec toutes les URLs
- ✅ Sauvegarde dans `D:\dev fivem\CobbleNuutt-Distribution\distribution.json`

**Durée estimée :** 2-5 minutes (selon le nombre de mods)

**Résultat attendu :**
```
Scanning modules...
✓ Found 138 mods in fabricmods/required
✓ Found 45 libraries
✓ Found 3 config directories
✓ Calculated 186 checksums
✓ Generated distribution.json (1.2MB)
```

**En cas d'erreur "Invalid fabric.mod.json" :**
Certains mods ont des métadonnées invalides. Ce n'est pas bloquant, Nebula ignore ces erreurs. Si le mod est critique, contactez son développeur.

**Vérification :**
```bash
# Vérifier que le fichier existe et n'est pas vide
ls -lh D:\dev fivem\CobbleNuutt-Distribution\distribution.json
```

Le fichier doit faire entre 500KB et 2MB selon le nombre de mods.

---

## 🌐 Déploiement sur le serveur

### Structure à uploader

Uploadez **TOUT le contenu** de `D:\dev fivem\CobbleNuutt-Distribution\` sur votre serveur web.

**Structure complète :**

```
Source (local) :
D:\dev fivem\CobbleNuutt-Distribution\
├── distribution.json          # Fichier principal (REQUIS)
├── meta\
│   └── distrometa.json        # Métadonnées (optionnel)
└── servers\
    └── CobbleNuutt-1.21.1\
        ├── servermeta.json    # Config serveur (REQUIS)
        ├── server-icon.png    # Icône (optionnel)
        ├── files\             # Configs, packs
        │   ├── config\
        │   ├── resourcepacks\
        │   └── shaderpacks\
        ├── libraries\         # Librairies Fabric/MC
        └── fabricmods\        # Mods
            └── required\

Destination (serveur) :
https://nuutt-cobblemon.com/launcher/
├── distribution.json
├── meta\
│   └── distrometa.json
└── servers\
    └── CobbleNuutt-1.21.1\
        ├── servermeta.json
        ├── server-icon.png
        ├── files\
        ├── libraries\
        └── fabricmods\
```

### Méthodes de déploiement

#### Option 1 : FTP/SFTP (FileZilla, WinSCP, etc.)

1. Connectez-vous au serveur FTP
2. Naviguez vers `/public_html/launcher/`
3. Uploadez **TOUT** le contenu de `CobbleNuutt-Distribution\`
4. **Important :** Conservez la structure des dossiers

#### Option 2 : Panneau de contrôle (cPanel, Plesk, etc.)

1. Compressez `CobbleNuutt-Distribution\` en ZIP
2. Uploadez le ZIP via le gestionnaire de fichiers
3. Extrayez dans `/public_html/launcher/`

#### Option 3 : Ligne de commande (SSH/SCP)

```bash
# Depuis votre machine locale
scp -r D:\dev fivem\CobbleNuutt-Distribution/* user@nuutt-cobblemon.com:/var/www/launcher/

# Ou avec rsync (recommandé pour les mises à jour)
rsync -avz --progress D:\dev fivem\CobbleNuutt-Distribution/* user@nuutt-cobblemon.com:/var/www/launcher/
```

### Vérification du déploiement

#### Test 1 : Accès au distribution.json

Ouvrez dans votre navigateur :
```
https://nuutt-cobblemon.com/launcher/distribution.json
```

**Attendu :** Vous voyez le contenu JSON
**Si erreur 404 :** Le fichier n'a pas été uploadé ou le chemin est incorrect

#### Test 2 : Accès aux mods

Testez l'URL d'un mod (exemple) :
```
https://nuutt-cobblemon.com/launcher/servers/CobbleNuutt-1.21.1/fabricmods/required/cobblemon-fabric-1.6.0.jar
```

**Attendu :** Le téléchargement du fichier démarre
**Si erreur 403/404 :** Vérifiez les permissions des fichiers

#### Test 3 : Validation JSON

Utilisez un validateur JSON en ligne :
1. Copiez le contenu de `distribution.json`
2. Collez sur https://jsonlint.com/
3. Vérifiez qu'il n'y a pas d'erreurs de syntaxe

### Permissions des fichiers

**Sur serveur Linux :**
```bash
# Se connecter au serveur via SSH
ssh user@nuutt-cobblemon.com

# Appliquer les permissions correctes
cd /var/www/launcher/
chmod -R 755 .
chmod 644 distribution.json
chmod 644 servers/*/servermeta.json
find . -type f -name "*.jar" -exec chmod 644 {} \;
```

**Permissions recommandées :**
- Dossiers : 755 (rwxr-xr-x)
- Fichiers : 644 (rw-r--r--)


---

## 🔄 Mise à jour de la distribution

### Workflow de mise à jour

Toute modification nécessite 3 étapes :
1. **Modifier** les fichiers localement
2. **Régénérer** `distribution.json`
3. **Uploader** les fichiers modifiés + `distribution.json`

### Scénario 1 : Ajouter un nouveau mod

**Étape 1 : Ajouter le mod**
```powershell
# Copiez le nouveau mod dans le dossier
Copy-Item "chemin/vers/nouveau-mod.jar" -Destination "D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1\fabricmods\required\"
```

**Étape 2 : Régénérer**
```bash
cd Nebula
npm run start -- generate distro
```

**Étape 3 : Uploader**
- Uploadez `distribution.json`
- Uploadez `servers/CobbleNuutt-1.21.1/fabricmods/required/nouveau-mod.jar`

**Important :** Les clients téléchargeront automatiquement le nouveau mod au prochain lancement.

### Scénario 2 : Mettre à jour un mod existant

**Étape 1 : Remplacer le mod**
```powershell
# Supprimez l'ancienne version
Remove-Item "D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1\fabricmods\required\ancien-mod-1.0.0.jar"

# Ajoutez la nouvelle version
Copy-Item "chemin/vers/nouveau-mod-1.1.0.jar" -Destination "D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1\fabricmods\required\"
```

**Étape 2 : Régénérer**
```bash
cd Nebula
npm run start -- generate distro
```

**Étape 3 : Uploader**
- Uploadez `distribution.json`
- Uploadez `servers/CobbleNuutt-1.21.1/fabricmods/required/nouveau-mod-1.1.0.jar`
- Supprimez l'ancien fichier sur le serveur (optionnel mais recommandé)

### Scénario 3 : Supprimer un mod

**Étape 1 : Supprimer le mod**
```powershell
Remove-Item "D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1\fabricmods\required\mod-a-supprimer.jar"
```

**Étape 2 : Régénérer**
```bash
cd Nebula
npm run start -- generate distro
```

**Étape 3 : Uploader**
- Uploadez `distribution.json`
- Supprimez le mod du serveur

**Important :** Les clients supprimeront automatiquement le mod au prochain lancement.

### Scénario 4 : Modifier une configuration

**Étape 1 : Modifier la config**
```powershell
# Éditez le fichier de config
notepad "D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1\files\config\cobblemon.json"
```

**Étape 2 : Régénérer**
```bash
cd Nebula
npm run start -- generate distro
```

**Étape 3 : Uploader**
- Uploadez `distribution.json`
- Uploadez `servers/CobbleNuutt-1.21.1/files/config/cobblemon.json`

### Scénario 5 : Changer l'adresse du serveur

**Étape 1 : Éditer servermeta.json**
```json
{
  "meta": {
    "address": "nouvelle-adresse.com:25565",
    "version": "1.0.1"
  }
}
```

**Important :** Incrémentez la version à chaque changement.

**Étape 2 : Régénérer**
```bash
cd Nebula
npm run start -- generate distro
```

**Étape 3 : Uploader**
- Uploadez `distribution.json`
- Uploadez `servers/CobbleNuutt-1.21.1/servermeta.json`

### Scénario 6 : Modifier la RAM recommandée

**Étape 1 : Éditer servermeta.json**
```json
{
  "meta": {
    "javaOptions": {
      "ram": {
        "recommended": 8192,
        "minimum": 6144
      }
    },
    "version": "1.0.2"
  }
}
```

**Étape 2 : Régénérer et uploader** (même processus)

### Versionning de la distribution

**Bonnes pratiques :**
- Incrémentez `meta.version` dans `servermeta.json` à chaque modification
- Utilisez le versioning sémantique : `MAJOR.MINOR.PATCH`
  - `MAJOR` : Changements majeurs (nouveau serveur, Minecraft version, etc.)
  - `MINOR` : Ajout/suppression de mods
  - `PATCH` : Modifications mineures (configs, tweaks)

**Exemples :**
- `1.0.0` → `1.0.1` : Modification d'une config
- `1.0.1` → `1.1.0` : Ajout de 5 nouveaux mods
- `1.1.0` → `2.0.0` : Migration vers Minecraft 1.21.2

### Cache et propagation

**Délai de propagation :**
- Les clients vérifient `distribution.json` à chaque lancement
- Si le MD5 d'un fichier change, il est re-téléchargé
- Aucun cache CDN n'est utilisé par défaut

**Forcer une mise à jour :**
Si un client ne voit pas les changements :
1. Supprimer le cache local : `%APPDATA%\CobbleNuutt Launcher`
2. Relancer le launcher

---

## 🛠️ Dépannage

### Problème : "Please provide a URL protocol"

**Symptômes :**
```
Error: Please provide a URL protocol
```

**Cause :** Le `BASE_URL` dans `.env` ne commence pas par `https://` ou `http://`

**Solution :**
```properties
# ❌ Incorrect
BASE_URL=nuutt-cobblemon.com/launcher/

# ✅ Correct
BASE_URL=https://nuutt-cobblemon.com/launcher/
```

---

### Problème : "Server already exists"

**Symptômes :**
```
Error: Server CobbleNuutt-1.21.1 already exists
```

**Cause :** Vous essayez de générer un serveur qui existe déjà

**Solutions :**

**Option 1 : Supprimer et régénérer**
```powershell
Remove-Item -Recurse -Force "D:\dev fivem\CobbleNuutt-Distribution\servers\CobbleNuutt-1.21.1"
npm run start -- generate server CobbleNuutt 1.21.1 --fabric 0.17.2
```

**Option 2 : Modifier le nom**
```bash
npm run start -- generate server CobbleNuutt-v2 1.21.1 --fabric 0.17.2
```

---

### Problème : Les mods ne se téléchargent pas

**Symptômes :**
- Le launcher reste bloqué sur "Downloading modules"
- Erreurs 404 dans la console DevTools
- Téléchargement qui échoue

**Diagnostic :**

**Test 1 : Vérifier l'accès au distribution.json**
```
https://nuutt-cobblemon.com/launcher/distribution.json
```

**Test 2 : Vérifier l'accès aux mods**
Copiez une URL depuis `distribution.json` et testez dans un navigateur.

**Solutions :**

1. **Fichiers non uploadés**
   - Vérifiez que tous les fichiers sont sur le serveur
   - Utilisez FileZilla ou WinSCP pour confirmer

2. **BASE_URL incorrect**
   - Vérifiez que `BASE_URL` dans `.env` correspond à l'URL réelle
   - Régénérez si vous avez changé le `BASE_URL`

3. **Permissions incorrectes**
   ```bash
   # Sur serveur Linux
   chmod -R 755 /var/www/launcher/
   find /var/www/launcher/ -type f -exec chmod 644 {} \;
   ```

4. **Cache navigateur**
   - Videz le cache de votre navigateur
   - Testez en mode incognito

---

### Problème : "Invalid fabric.mod.json"

**Symptômes :**
```
Warning: Invalid fabric.mod.json in mod XYZ
```

**Cause :** Certains mods ont des métadonnées `fabric.mod.json` malformées

**Solution :**
- **Ce n'est pas bloquant** : Nebula ignore ces erreurs et continue
- Le mod sera quand même inclus dans la distribution
- Si le mod est critique et ne fonctionne pas, contactez le développeur
- Vérifiez que le mod est compatible avec Fabric 0.17.2 et MC 1.21.1

---

### Problème : Le launcher ne trouve pas Java 21

**Symptômes :**
- "Java 21 is required but not found"
- Le launcher ne démarre pas Minecraft

**Solutions :**

**1. Installer Java 21**
```
https://adoptium.net/temurin/releases/?version=21
```

**2. Vérifier l'installation**
```bash
java --version
```
Attendu : `openjdk 21.x.x` ou similaire

**3. Ajouter Java au PATH (Windows)**
```
Panneau de configuration > Système > Paramètres système avancés
> Variables d'environnement > PATH > Ajouter le chemin vers Java
```

**4. Spécifier le chemin dans servermeta.json**
```json
{
  "meta": {
    "javaOptions": {
      "supported": ">=21",
      "suggestedMajor": 21,
      "executable": "C:\\Program Files\\Eclipse Adoptium\\jdk-21.0.1.12-hotspot\\bin\\java.exe"
    }
  }
}
```

---

### Problème : Checksum MD5 mismatch

**Symptômes :**
```
Error: Checksum mismatch for file XYZ
Expected: abc123...
Got: def456...
```

**Cause :** Le fichier sur le serveur ne correspond pas au MD5 dans `distribution.json`

**Solutions :**

1. **Régénérer le distribution.json**
   ```bash
   cd Nebula
   npm run start -- generate distro
   ```

2. **Re-uploader le fichier**
   - Téléchargez le fichier depuis votre distribution locale
   - Uploadez-le à nouveau sur le serveur

3. **Vérifier l'intégrité du fichier**
   ```bash
   # Calculer le MD5 local
   certutil -hashfile "chemin/vers/fichier.jar" MD5
   ```

---

### Problème : Minecraft crash au lancement

**Symptômes :**
- Minecraft se lance puis crash immédiatement
- Erreur dans les logs

**Diagnostic :**

**1. Consulter les logs**
```
%APPDATA%\.minecraft\logs\latest.log
```

**2. Vérifier les incompatibilités**
- Certains mods peuvent être incompatibles entre eux
- Vérifiez les versions des mods

**Solutions :**

1. **Tester en local**
   - Copiez tous les mods dans une instance Minecraft locale
   - Identifiez le mod problématique

2. **Vérifier les dépendances**
   - Certains mods nécessitent d'autres mods (Fabric API, Cloth Config, etc.)
   - Ajoutez les dépendances manquantes

3. **Mettre à jour Fabric Loader**
   ```bash
   npm run start -- generate server CobbleNuutt 1.21.1 --fabric 0.17.3
   ```

---

### Problème : Le launcher ne se met pas à jour

**Symptômes :**
- Les clients ne voient pas les nouveaux mods
- L'ancienne version est toujours chargée

**Solutions :**

1. **Vérifier que distribution.json est uploadé**
   ```
   https://nuutt-cobblemon.com/launcher/distribution.json
   ```

2. **Supprimer le cache client**
   ```
   %APPDATA%\CobbleNuutt Launcher\
   ```
   Supprimez ce dossier et relancez le launcher

3. **Vérifier le versionning**
   - Incrémentez `meta.version` dans `servermeta.json`
   - Régénérez la distribution

---

### Problème : Upload FTP très lent

**Symptômes :**
- Upload de 500MB+ prend des heures

**Solutions :**

1. **Utiliser rsync (Linux/Mac)**
   ```bash
   rsync -avz --progress --partial \
     D:\dev fivem\CobbleNuutt-Distribution/* \
     user@server:/var/www/launcher/
   ```

2. **Compresser avant d'uploader**
   ```bash
   # Compresser
   tar -czf distribution.tar.gz CobbleNuutt-Distribution/

   # Uploader
   scp distribution.tar.gz user@server:/tmp/

   # Décompresser sur le serveur
   ssh user@server "cd /var/www/launcher && tar -xzf /tmp/distribution.tar.gz"
   ```

3. **Upload incrémental**
   - Uploadez uniquement les fichiers modifiés
   - Utilisez un client FTP avec support de reprise (FileZilla)

---

## ✨ Bonnes pratiques

### Gestion des versions

**1. Versionning sémantique**
```
MAJOR.MINOR.PATCH
```
- `MAJOR` : Changements incompatibles (nouveau Minecraft, reset serveur)
- `MINOR` : Ajout/suppression de mods, nouvelles fonctionnalités
- `PATCH` : Corrections, tweaks, mises à jour mineures

**2. Historique des versions**
Créez un fichier `CHANGELOG.md` dans votre distribution :
```markdown
# Changelog

## [1.2.0] - 2025-10-27
### Ajouté
- 5 nouveaux mods de décoration
- Shader pack Complementary v5

### Modifié
- Cobblemon 1.6.0 → 1.6.1
- Configuration RAM : 6GB → 8GB

### Supprimé
- Mod XYZ (incompatible)
```

### Sauvegarde et sécurité

**1. Sauvegarde de la distribution**
```bash
# Sauvegarde complète
tar -czf backup-distribution-$(date +%Y%m%d).tar.gz CobbleNuutt-Distribution/

# Sauvegarde sur cloud
rclone sync CobbleNuutt-Distribution/ gdrive:backups/distribution/
```

**2. Git pour le versioning**
```bash
cd CobbleNuutt-Distribution
git init
git add .
git commit -m "Version 1.0.0 - Initial distribution"
git tag v1.0.0
```

**3. Sauvegarde du distribution.json**
Conservez une copie de chaque version de `distribution.json` :
```
backups/
├── distribution-v1.0.0.json
├── distribution-v1.1.0.json
└── distribution-v1.2.0.json
```

### Organisation des mods

**1. Catégorisation**
Organisez vos mods par catégorie (localement, pour votre référence) :
```
mods-source/
├── gameplay/        # Cobblemon, etc.
├── performance/     # Sodium, Lithium
├── visuals/         # Iris, Better Third Person
├── utility/         # JEI, REI
└── server-side/     # Mods serveur uniquement
```

**2. Documentation des mods**
Créez un fichier `MODS.md` listant tous les mods avec :
- Nom et version
- Description
- URL de téléchargement
- Dépendances
- Raison de l'inclusion

**3. Mods optionnels vs obligatoires**
```
fabricmods/
├── required/        # Obligatoires (gameplay, compatibilité)
├── optionalon/      # Optionnels activés (shaders, visuals)
└── optionaloff/     # Optionnels désactivés (alternatives)
```

### Tests et qualité

**1. Checklist avant production**
- [ ] Tester en local avec `--installLocal`
- [ ] Vérifier que tous les mods se chargent
- [ ] Tester la connexion au serveur
- [ ] Vérifier les performances (FPS, RAM)
- [ ] Valider le JSON avec jsonlint.com
- [ ] Tester sur une machine vierge (sans cache)

**2. Tests de charge**
Si vous avez beaucoup de joueurs :
- Testez avec 5-10 personnes simultanément
- Vérifiez la bande passante du serveur web
- Envisagez un CDN si > 100 joueurs

**3. Monitoring**
Surveillez les logs du serveur web :
```bash
tail -f /var/log/apache2/access.log | grep distribution.json
```

### Performance et optimisation

**1. Compression**
Activez la compression sur votre serveur web :
```apache
# .htaccess
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE application/json
    AddOutputFilterByType DEFLATE application/java-archive
</IfModule>
```

**2. Cache headers**
```apache
# .htaccess
<FilesMatch "\.(jar|json)$">
    Header set Cache-Control "public, max-age=86400"
</FilesMatch>
```

**3. CDN (optionnel)**
Pour de meilleures performances globales :
- Cloudflare (gratuit)
- BunnyCDN
- AWS CloudFront

### Communication avec les joueurs

**1. Annonces de mise à jour**
Utilisez le flux RSS configuré dans `distrometa.json` :
```xml
<!-- rss.xml -->
<item>
    <title>Mise à jour 1.2.0 disponible</title>
    <description>5 nouveaux mods ajoutés !</description>
    <pubDate>Mon, 27 Oct 2025 10:00:00 GMT</pubDate>
</item>
```

**2. Discord Rich Presence**
Configurez correctement les assets Discord pour un affichage professionnel :
- Logo du serveur en haute qualité (1024x1024)
- Textes descriptifs clairs

**3. Documentation pour les joueurs**
Créez un guide simple pour les joueurs :
- Comment installer le launcher
- Configuration recommandée (RAM, Java)
- FAQ
- Support Discord

### Maintenance régulière

**Planning suggéré :**

**Hebdomadaire :**
- Vérifier les mises à jour de mods critiques
- Surveiller les logs d'erreurs
- Vérifier l'espace disque du serveur web

**Mensuel :**
- Mettre à jour les mods (après tests)
- Nettoyer les anciennes versions sur le serveur
- Optimiser la distribution (supprimer mods inutilisés)

**Trimestriel :**
- Mettre à jour Fabric Loader
- Réviser la liste des mods (ajouts/suppressions)
- Sauvegarder la distribution complète

---

## 📚 Ressources utiles

- **Documentation Nebula** : https://github.com/dscalzi/Nebula
- **Documentation Helios Launcher** : https://github.com/dscalzi/HeliosLauncher
- **Format distribution.json** : https://github.com/dscalzi/HeliosLauncher/blob/master/docs/distro.md
- **Fabric Loader releases** : https://fabricmc.net/use/installer/
- **Adoptium Java** : https://adoptium.net/
- **Discord CobbleNuutt** : https://discord.gg/npfsQfpYp8
- **Site web** : https://nuutt-cobblemon.com
- **CurseForge (mods)** : https://www.curseforge.com/minecraft/mc-mods
- **Modrinth (mods)** : https://modrinth.com/mods

---

## 📝 Notes importantes

**Configuration actuelle :**
- **Minecraft** : 1.21.1
- **Fabric Loader** : 0.17.2
- **Java requis** : Java 21 minimum
- **RAM recommandée** : 6GB (4GB minimum)
- **Nombre de mods** : 138+ mods Fabric
- **Taille distribution** : ~500MB à télécharger pour le client
- **Serveur** : play.nuutt-cobblemon.com:25565

**Compatibilité :**
- Windows 10/11 (x64)
- macOS 10.14+ (Intel et Apple Silicon)
- Linux (la plupart des distributions)

---

## ✅ Checklist de déploiement

### Pré-déploiement (Local)

**Configuration :**
- [ ] `.env` créé et configuré correctement
- [ ] `ROOT` pointe vers le bon dossier
- [ ] `BASE_URL` est correct (avec `https://` et `/` à la fin)
- [ ] Nebula installé et fonctionnel

**Génération :**
- [ ] Structure initialisée (`npm run start -- init root`)
- [ ] Serveur Fabric généré (`generate server`)
- [ ] Dossiers `fabricmods/` créés
- [ ] Tous les mods copiés dans `fabricmods/required/` (138+)
- [ ] Configs copiées dans `files/config/`
- [ ] Resource packs copiés (si applicable)
- [ ] Shader packs copiés (si applicable)

**Métadonnées :**
- [ ] `servermeta.json` édité avec les bonnes valeurs
  - [ ] Adresse serveur correcte
  - [ ] RAM configurée (min/recommandé)
  - [ ] Version incrémentée
- [ ] `distrometa.json` créé
  - [ ] Discord Client ID configuré (si Rich Presence)
  - [ ] URL RSS configurée (si applicable)
- [ ] Icône serveur ajoutée (optionnel)

**Génération finale :**
- [ ] `distribution.json` généré sans erreur
- [ ] Taille du fichier normale (500KB-2MB)
- [ ] JSON validé sur jsonlint.com

### Test local

- [ ] Test local avec `--installLocal` réussi
- [ ] Launcher démarre sans erreur
- [ ] Tous les mods se téléchargent
- [ ] Minecraft 1.21.1 se lance
- [ ] Fabric 0.17.2 chargé
- [ ] Tous les mods fonctionnent (138+)
- [ ] Pas d'erreurs dans DevTools
- [ ] Performance acceptable (FPS, RAM)

### Déploiement (Serveur)

**Upload :**
- [ ] Tous les fichiers uploadés sur le serveur
- [ ] Structure des dossiers préservée
- [ ] `distribution.json` uploadé
- [ ] `servers/CobbleNuutt-1.21.1/` complet
- [ ] Permissions correctes (755 pour dossiers, 644 pour fichiers)

**Vérification serveur :**
- [ ] URL `https://nuutt-cobblemon.com/launcher/distribution.json` accessible
- [ ] Test d'un mod dans le navigateur fonctionne
- [ ] Pas d'erreurs 403/404
- [ ] JSON valide dans le navigateur

### Test production

**Test client :**
- [ ] Test sur une machine vierge (sans cache)
- [ ] Launcher se connecte au serveur
- [ ] `distribution.json` téléchargé
- [ ] Tous les mods téléchargés
- [ ] Minecraft se lance
- [ ] Connexion au serveur `play.nuutt-cobblemon.com` fonctionne
- [ ] Les commandes Cobblemon fonctionnent

**Test multi-utilisateurs :**
- [ ] Test avec 2-3 personnes simultanément
- [ ] Pas de ralentissement serveur
- [ ] Tous les clients reçoivent les bons fichiers

### Post-déploiement

**Documentation :**
- [ ] CHANGELOG.md mis à jour
- [ ] Version documentée
- [ ] Sauvegarde de la distribution créée
- [ ] Git commit/tag créé (si utilisé)

**Communication :**
- [ ] Annonce Discord publiée
- [ ] RSS mis à jour (si applicable)
- [ ] Instructions pour les joueurs disponibles

**Monitoring :**
- [ ] Logs serveur surveillés
- [ ] Aucune erreur critique
- [ ] Bande passante normale
- [ ] Retours joueurs positifs

---

## 🎯 Résumé des commandes essentielles

### Première génération complète

```bash
# 1. Cloner et installer Nebula
git clone https://github.com/dscalzi/Nebula.git
cd Nebula
npm install

# 2. Créer le .env (puis éditer manuellement)
touch .env

# 3. Initialiser la structure
npm run start -- init root

# 4. Générer le serveur Fabric
npm run start -- generate server CobbleNuutt 1.21.1 --fabric 0.17.2

# 5. Copier les fichiers (voir section détaillée)

# 6. Éditer servermeta.json et distrometa.json

# 7. Générer la distribution
npm run start -- generate distro

# 8. Tester en local
npm run start -- generate distro distribution_dev --installLocal

# 9. Uploader sur le serveur (FTP/rsync)
```

### Mise à jour

```bash
# 1. Modifier les fichiers (ajouter/supprimer mods, etc.)

# 2. Régénérer la distribution
cd Nebula
npm run start -- generate distro

# 3. Uploader les nouveaux fichiers + distribution.json
```

---

**Dernière mise à jour :** 27 octobre 2025

**Version du guide :** 2.0.0

**Auteur :** Delta Arts

---

