#!/bin/bash
set -e
echo "========================================"
echo " Rapport+ — Installation & Build APK"
echo "========================================"

echo "[1/4] Verification Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "Flutter non trouvé. Installez Flutter:"
    echo "https://docs.flutter.dev/get-started/install"
    exit 1
fi
flutter --version

echo "[2/4] Installation dépendances..."
flutter pub get
dart run build_runner build --delete-conflicting-outputs

echo "[3/4] Vérification..."
flutter analyze

echo "[4/4] Build APK release..."
flutter build apk --release

echo "Terminé ! APK: build/app/outputs/flutter-apk/app-release.apk"
echo "Dimensions corrigées: phone min(360px,92vw) 74vh sticky"
