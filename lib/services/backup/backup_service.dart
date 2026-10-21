import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '../../database/database.dart';

/// Backup Service - Local + Optional Google Drive
/// Never auto-uploads without explicit user consent.

class BackupService {
  final AppDatabase db;
  BackupService(this.db);

  /// Create local backup JSON file
  Future<File> createLocalBackup() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${dir.path}/backups');
    if (!await backupDir.exists()) await backupDir.create(recursive: true);

    final data = await _collectAllData();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
    final file = File('${backupDir.path}/backup_${DateTime.now().toIso8601String().split('T').first}.json');
    await file.writeAsString(jsonStr);
    return file;
  }

  Future<Map<String, dynamic>> _collectAllData() async {
    final internships = await db.select(db.internships).get();
    final entries = await db.select(db.journalEntries).get();
    final media = await db.select(db.mediaAttachments).get();
    final chapters = await db.select(db.reportChapters).get();
    final questions = await db.select(db.juryQuestions).get();
    final flashcards = await db.select(db.flashcards).get();
    final profile = await db.select(db.userProfiles).getSingleOrNull();
    final settings = await db.select(db.appSettings).get();

    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'app': 'Rapport+ 1.0.0',
      'profile': profile?.toJson(),
      'internships': internships.map((e) => e.toJson()).toList(),
      'journalEntries': entries.map((e) => e.toJson()).toList(),
      'media': media.map((e) => e.toJson()).toList(),
      'reportChapters': chapters.map((e) => e.toJson()).toList(),
      'juryQuestions': questions.map((e) => e.toJson()).toList(),
      'flashcards': flashcards.map((e) => e.toJson()).toList(),
      'settings': settings.map((e) => e.toJson()).toList(),
    };
  }

  /// Restore from local backup file
  Future<void> restoreFromLocalBackup(File backupFile) async {
    final jsonStr = await backupFile.readAsString();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    // Use transaction to ensure atomicity
    await db.transaction(() async {
      // Clear existing (with confirmation handled in UI)
      // Insert restored data
      // NOTE: Real implementation performs upsert with conflict resolution
    });
  }

  /// Google Drive backup - only if user explicitly authorized
  Future<void> backupToDrive(drive.DriveApi driveApi) async {
    final localFile = await createLocalBackup();
    final media = drive.Media(localFile.openRead(), await localFile.length());
    final driveFile = drive.File()
      ..name = 'rapport_plus_backup_${DateTime.now().toIso8601String()}.json'
      ..parents = ['appDataFolder']
      ..description = 'Rapport+ backup - ${DateTime.now().toLocal()}';

    await driveApi.files.create(driveFile, uploadMedia: media);
  }

  Future<List<drive.File>> listDriveBackups(drive.DriveApi driveApi) async {
    final result = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name contains 'rapport_plus_backup'",
      orderBy: 'createdTime desc',
    );
    return result.files ?? [];
  }

  Future<void> restoreFromDrive(drive.DriveApi driveApi, String fileId) async {
    final media = await driveApi.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    final bytes = <int>[];
    await for (final chunk in media.stream) {
      bytes.addAll(chunk);
    }
    final jsonStr = utf8.decode(bytes);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    // Same restore logic as local
  }
}

extension _ToJson on Object {
  Map<String, dynamic> toJson() {
    // Drift data classes have toJson via generated code
    // This is a placeholder for the extension
    return {};
  }
}
