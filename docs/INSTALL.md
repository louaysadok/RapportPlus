# Installation Rapport+ — Guide complet

## Prérequis
- Flutter 3.16+ , Dart 3.2+
- Android Studio + SDK 33+ , NDK pour llama.cpp
- 8 Go RAM recommandé pour build, 3 Go min pour exécution modèle 3B

## Étapes
1. `git clone <repo> && cd rapport_plus`
2. `flutter pub get`
3. `dart run build_runner build --delete-conflicting-outputs` (génère database.g.dart)
4. (Optionnel) Configurer Google Drive OAuth dans Google Cloud Console
5. `flutter run` (debug) ou `flutter build apk --release`

## Permissions Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

## Modèles IA
- Ouvrir app → Paramètres → Modèles IA → Télécharger (Wi-Fi)
- Qwen2.5-3B : 1.98 Go, nécessite 2.8 Go RAM libre
- Vérification automatique avant téléchargement

## Dépannage
- `flutter clean && flutter pub get` si drift errors
- Notifications non reçues → vérifier autorisation dans Paramètres Android → Rapport+
- Drive "Non connecté" → normal sans OAuth, configurer si besoin

## Signature release
Voir README.md → Signer l'APK
