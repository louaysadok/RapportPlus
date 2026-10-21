# Documentation développeur Rapport+

## Principes
- Offline-first : tout fonctionne sans internet (IA, journal, rapport, PDF)
- FactGuard : jamais transformer observation → performance
- Original toujours conservé, IA génère version séparée à approuver
- Contact admin centralisé dans AppConfig uniquement

## Base de données (Drift)
- 8 tables : UserProfiles, Internships, JournalEntries, MediaAttachments, ReportChapters, JuryQuestions, Flashcards, AppSettings
- `first_launch` flag → Settings au premier démarrage, sinon Dashboard
- Migrations : jamais de DROP de données utilisateur

## IA locale
- `AIService` : download → load → infer via Isolate (pas de freeze UI)
- Système prompt factuel injecté à chaque requête
- Fallback rule-based si modèle absent (app reste utilisable)
- FFI llama.cpp : `libllama.so` compilé via NDK, modèle .gguf dans `getApplicationDocumentsDirectory()/models/`

## Voix
- `SpeechService` : record (package record) → whisper.cpp transcribe
- Transcription toujours affichée pour édition/confirmation avant sauvegarde

## Notifications
- flutter_local_notifications + timezone, channel RapportPlus, weekdays Mon-Fri par défaut

## Export
- pdf: mise en page A4, marges 2.5cm, police Inter/Poppins, TOC auto, images avec légendes
- docx: OOXML via archive, même structure

## Tests
- FactGuard unit tests : observed vs performed
- Widget tests : first launch navigation, journal CRUD
- Intégration : backup/restore, notifications, export

## Améliorations futures
- Sync multi-appareils chiffrée
- Templates rapport par établissement
- Mode collaboratif encadrant (lecture seule)
