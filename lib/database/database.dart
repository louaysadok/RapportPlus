import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/app_tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  UserProfiles,
  Internships,
  JournalEntries,
  MediaAttachments,
  ReportChapters,
  JuryQuestions,
  Flashcards,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Seed default settings
          await _seedDefaults();
        },
        onUpgrade: (m, from, to) async {
          // Safe migrations - never drop user data
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _seedDefaults() async {
    await batch((b) {
      b.insertAll(appSettings, [
        AppSettingsCompanion.insert(key: 'first_launch', value: 'true'),
        AppSettingsCompanion.insert(key: 'reminder_enabled', value: 'true'),
        AppSettingsCompanion.insert(key: 'reminder_hour', value: '18'),
        AppSettingsCompanion.insert(key: 'reminder_minute', value: '0'),
        AppSettingsCompanion.insert(key: 'working_days', value: '1,2,3,4,5'),
        AppSettingsCompanion.insert(key: 'theme_mode', value: 'light'),
        AppSettingsCompanion.insert(key: 'ai_model_id', value: ''),
        AppSettingsCompanion.insert(key: 'ai_model_downloaded', value: 'false'),
      ]);
      b.insert(userProfiles, UserProfilesCompanion.insert(
        fullName: const Value(''),
        institution: const Value(''),
        specialization: const Value(''),
      ));
    });
  }

  // ── Helpers ──
  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(key: key, value: value),
    );
  }

  Future<bool> isFirstLaunch() async {
    final v = await getSetting('first_launch');
    return v == 'true' || v == null;
  }

  Future<void> completeFirstLaunch() async {
    await setSetting('first_launch', 'false');
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'rapport_plus.db',
    native: const DriftNativeOptions(
      databaseDirectory: _getLibraryDirectory,
    ),
  );
}

Future<Directory> _getLibraryDirectory() async {
  final dir = await getApplicationDocumentsDirectory();
  return dir;
}

// ── Report Template Definitions ──
class ReportTemplates {
  static const List<Map<String, dynamic>> defaultChapters = [
    {'key': 'page_garde', 'title': 'Page de garde', 'required': true},
    {'key': 'remerciements', 'title': 'Remerciements', 'required': true},
    {'key': 'sommaire', 'title': 'Sommaire', 'required': true},
    {'key': 'introduction', 'title': 'Introduction générale', 'required': true},
    {'key': 'presentation_entreprise', 'title': 'Présentation de l\'entreprise', 'required': true},
    {'key': 'organisation', 'title': 'Organisation et fonctionnement', 'required': false},
    {'key': 'service_accueil', 'title': 'Présentation du service d\'accueil', 'required': false},
    {'key': 'objectifs', 'title': 'Objectifs du stage', 'required': true},
    {'key': 'activites_realisees', 'title': 'Activités réalisées', 'required': true},
    {'key': 'activites_observees', 'title': 'Activités observées', 'required': false},
    {'key': 'materiel_outils', 'title': 'Matériel, outils et logiciels utilisés', 'required': false},
    {'key': 'competences', 'title': 'Compétences acquises', 'required': true},
    {'key': 'difficultes', 'title': 'Difficultés rencontrées', 'required': false},
    {'key': 'solutions', 'title': 'Solutions apportées', 'required': false},
    {'key': 'hygiene_securite', 'title': 'Hygiène et sécurité', 'required': false},
    {'key': 'bilan', 'title': 'Bilan personnel et professionnel', 'required': true},
    {'key': 'conclusion', 'title': 'Conclusion générale', 'required': true},
    {'key': 'annexes', 'title': 'Annexes', 'required': false},
    {'key': 'bibliographie', 'title': 'Bibliographie / Références', 'required': false},
  ];

  static const Map<String, List<String>> fieldSpecificChapters = {
    'Mécanique': ['atelier', 'machines', 'maintenance', 'sécurité'],
    'Informatique': ['technologies', 'architecture', 'méthodologie', 'tests'],
    'Santé': ['service', 'protocoles', 'patients', 'hygiène'],
    'Commerce': ['marché', 'stratégie', 'clients', 'résultats'],
  };
}
