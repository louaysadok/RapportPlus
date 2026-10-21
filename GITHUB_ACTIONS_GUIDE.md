# Générer l'APK SANS PC — via GitHub Actions (gratuit)

Tu n'as pas besoin de PC. Utilise ton téléphone + navigateur.

## Étapes (5 minutes sur téléphone)

### 1. Créer un compte GitHub (si tu n'en as pas)
- Va sur https://github.com sur ton téléphone
- Inscris-toi (gratuit)

### 2. Créer le repository
1. Clique sur `+` → `New repository`
2. Nom: `rapport-plus`
3. Public (pour Actions gratuits)
4. Clique `Create repository`

### 3. Uploader le projet
**Option A — via web (téléphone):**
1. Sur la page du repo vide, clique `uploading an existing file`
2. Sur ton téléphone, ouvre le gestionnaire de fichiers
3. Upload le fichier `rapport_plus_project.zip` que je t'ai préparé
   - Télécharge-le depuis le workspace : `rapport_plus_project.zip` (78 Ko)
4. Décompresse pas — GitHub le fera, ou upload dossier par dossier

**Option B — plus simple:**
1. Sur GitHub, clique `Add file` → `Upload files`
2. Glisse tout le dossier `rapport_plus` (via navigateur mobile en mode desktop)

### 4. Le workflow se lance automatiquement
- Dès que tu pushes, GitHub Actions démarre (onglet `Actions`)
- Il installe Flutter + Android SDK + build l'APK en 8-12 minutes
- Temps: ~10 min sur serveur GitHub (7 Go RAM — pas de limite comme ici)

### 5. Télécharger l'APK
1. Va dans `Actions` → clique sur le run `Build Rapport+ APK`
2. En bas: `Artifacts` → `rapport-plus-apks`
3. Télécharge → tu auras `app-debug.apk` (installable direct) et `app-release.apk`

### 6. Installer sur ton téléphone Android
1. Ouvre le APK téléchargé
2. Autorise "Installer apps inconnues" si demandé
3. Installe → ouvre Rapport+

## Fichier workflow déjà prêt
J'ai créé `.github/workflows/build-apk.yml` pour toi:

```yaml
name: Build Rapport+ APK
on: [push, workflow_dispatch]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: {distribution: temurin, java-version: '17'}
      - uses: subosito/flutter-action@v2
        with: {flutter-version: '3.24.x', channel: stable}
      - run: flutter pub get
      - run: flutter build apk --debug
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v4
        with: {name: rapport-plus-apks, path: build/app/outputs/flutter-apk/*.apk}
```

Tu n'as rien à configurer — copie juste ce fichier dans ton repo.

## Alternative — Je build ici si tu attends
Le sandbox a maintenant Flutter 3.47 + Android SDK 36 + Java 17 installés (1.5 Go téléchargés).
Le build APK local est en cours mais le sandbox n'a que 1.9 Go RAM — Gradle a besoin de 2 Go.
Ça peut prendre 15-20 min ou échouer par manque de RAM. GitHub Actions est 100% fiable et gratuit.

## Dimensions corrigées ✅
- Phone: `width: min(360px, 92vw)` + `max-height: 74vh` + `position: sticky`
- Plus de débordement sur mobile
- Testé dans preview.html

Besoin d'aide pour GitHub? Dis-moi et je te guide étape par étape.
Contact: Louay Sadok +216 28671953 (WhatsApp)
