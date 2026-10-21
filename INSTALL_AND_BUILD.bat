@echo off
echo ========================================
echo  Rapport+ — Installation & Build APK
echo ========================================
echo.

echo [1/4] Verification Flutter...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo   Flutter non trouve. Installez Flutter:
    echo   https://docs.flutter.dev/get-started/install/windows
    echo   Extraire vers C:\flutter et ajouter C:\flutter\bin au PATH
    pause
    exit /b 1
)
flutter --version

echo.
echo [2/4] Installation dependances...
flutter pub get
dart run build_runner build --delete-conflicting-outputs

echo.
echo [3/4] Verification...
flutter analyze

echo.
echo [4/4] Build APK release...
flutter build apk --release

echo.
echo Termine ! APK: build\app\outputs\flutter-apk\app-release.apk
echo Dimensions corrigees: phone min(360px,92vw) 74vh sticky
pause
