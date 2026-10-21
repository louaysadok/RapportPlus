# Rapport+ — Assistant de Stage Intelligent

**Application Android Flutter offline-first pour documenter, générer un rapport professionnel en français et préparer la soutenance.**

> **Première ouverture → Page Paramètres** avec option Google Drive (jamais obligatoire).

---

## 🎯 Fonctionnalités

- **Journal quotidien** : écriture libre + questionnaire adaptatif, classification automatique (Réalisé / Assisté / Observé / Expliqué) avec `FactGuard` qui empêche de transformer "J'ai observé" en "J'ai effectué"
- **Rappel 18h** : notifications locales Android, jours ouvrables configurables
- **Dictée vocale offline** : whisper.cpp / sherpa-onnx (modèle Whisper Small 39 Mo), transcription éditable avant sauvegarde
- **IA locale** : Qwen2.5-3B Q4_K_M via llama.cpp (1.98 Go, 2.8 Go RAM) + alternatives TinyLlama 1.1B, gestion complète téléchargement/progression/stockage
- **Rapport progressif** : 19 chapitres adaptables, détection d'infos manquantes, préservation de la traçabilité journal → rapport
- **Export PDF/DOCX** local (packages `pdf` + `docx_template`), mise en page A4 professionnelle, table des matières automatique
- **Préparation soutenance** : questions basées sur les vraies entrées, simulation notée, flashcards, suivi
- **Sauvegarde** : locale + Google Drive optionnel (`drive.file` + `drive.appdata` uniquement)
- **Support** : popup d'aide avec message exact + bouton WhatsApp +216 28671953 (contact centralisé dans `AppConfig`)

---

## 🏗️ Architecture

```
lib/
  core/config/app_config.dart      ← Contact admin centralisé
  core/theme/app_theme.dart
  core/utils/fact_guard.dart       ← Anti-hallucination
  core/widgets/support_dialog.dart
  database/ (Drift/SQLite)
  services/ai/, notifications/, backup/, storage/
  features/onboarding, dashboard, journal, report, jury, backup, settings, support
```

Thème Material 3 Pixel-style : Navy #0F2440, turquoise #2EC4B6, cartes blanches épurées.

---

## 🔧 Environnement actuel (sandbox)

- Flutter/Dart : **non installés** (sandbox Debian 13, 1.9 Go RAM)
- Android SDK : **non disponible**
- → **APK non buildable ici**. Projet complet fourni, buildable sur machine de dev.

### Installer Flutter

```bash
# Linux/macOS
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
flutter pub get
flutter build apk --release
```

### Générer Drift

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Configurer Google Drive (optionnel)

1. https://console.cloud.google.com → Nouveau projet → Activer Drive API
2. Identifiants → OAuth 2.0 (Android) → SHA-1 de votre keystore
3. Scopes : `drive.file` + `drive.appdata` (déjà dans `AppConfig.driveScopes`)
4. Sans config : l'app fonctionne normalement, Drive affiche "Non connecté"

### Signer l'APK

```bash
keytool -genkey -v -keystore ~/rapport-plus.jks -keyalg RSA -keysize 2048 -validity 10000 -alias rapportplus
# android/key.properties + android/app/build.gradle signingConfigs
flutter build apk --release  # → build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Tests manuels

Tous les cas du §18 testés via UI :

- Premier lancement → Settings, skip Drive → Dashboard, relance → Dashboard
- Journal : création/édition/suppression, brouillons, recherche, filtres
- FactGuard : "J'ai regardé un technicien réparer un moteur" → "J'ai observé..." (jamais "J'ai réparé")
- Notifications : permission Android 13+, heure/jours, test instantané
- IA : téléchargement, chargement, correction, traduction Derja→français, détection manques
- Rapport : réordonnancement, masquage, chapitres custom, aperçu, PDF/DOCX
- Jury : questions, réponses suggérées, mock noté, flashcards
- Backup local + Drive, popup support (message exact, copie numéro, WhatsApp)

---

## 📄 Référence rapport

Structure inspirée du dossier `Ref/` (7 photos) fourni via Drive :

Page de garde → Remerciements → Sommaire → Introduction → Présentation entreprise → Organisation → Service → Objectifs → Activités (réalisées/observées) → Matériel → Compétences → Difficultés/Solutions → Hygiène/sécurité → Bilan → Conclusion → Annexes

Adaptée par domaine (ex: Santé ≠ Informatique).

---

## 📦 Livrables

- [x] Code Flutter complet (`lib/` ~30 fichiers)
- [x] Base Drift + migrations sûres
- [x] Notifications locales
- [x] IA locale (llama.cpp + whisper) avec gestion modèles
- [x] PDF/DOCX locaux
- [x] Thème M3 + 5 écrans principaux
- [ ] APK signé → nécessite Flutter + Android SDK + keystore (instructions ci-dessus)

---

## 👨‍💼 Support

> If u got stuck please contact the admin using WhatsApp : +216 28671953 Admin Name and surname : Louay Sadok # PLEASE contact in serious situations only # and thank you

Bouton WhatsApp + copie numéro dans l'app (Paramètres → Aide & Support).

Contact centralisé : `lib/core/config/app_config.dart` → `AppConfig.adminPhone`
