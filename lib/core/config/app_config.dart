/// Centralized configuration - single source of truth.
/// All admin contact & app constants must be edited here only.
class AppConfig {
  // ── App Identity ──
  static const String appName = 'Rapport+';
  static const String appTagline = 'Votre compagnon de stage intelligent';
  static const String appVersion = '1.0.0';
  static const String packageName = 'tn.sadoklouay.rapport_plus';

  // ── Admin Contact (Support Popup - DO NOT HARDCODE ELSEWHERE) ──
  static const String adminPhone = '+216 28671953';
  static const String adminPhoneRaw = '+21628671953'; // for tel/wa link
  static const String adminName = 'Louay Sadok';
  static const String supportMessage =
      'If u got stuck please contact the admin using WhatsApp : +216 28671953 '
      'Admin Name and surname : Louay Sadok # PLEASE contact in serious situations only # and thank you';

  static String get whatsappUrl =>
      'https://wa.me/${adminPhoneRaw.replaceAll('+', '').replaceAll(' ', '')}';

  // ── Notifications ──
  static const int defaultReminderHour = 18;
  static const int defaultReminderMinute = 0;
  static const String defaultNotificationTitle = 'Hey {name}! Qu\'as-tu fait aujourd\'hui ? 🤔';
  static const String notificationChannelId = 'rapport_plus_daily_reminder';
  static const String notificationChannelName = 'Rappels journaliers';
  static const String notificationChannelDesc =
      'Rappels pour documenter votre journée de stage';

  // ── Storage ──
  static const String dbName = 'rapport_plus.db';
  static const int dbVersion = 1;
  static const String backupFileName = 'rapport_plus_backup.json';
  static const String backupFolderName = 'RapportPlus_Backups';

  // ── AI Models ──
  static const List<AIModelConfig> availableModels = [
    AIModelConfig(
      id: 'qwen2.5-3b-q4km',
      name: 'Qwen2.5 3B Instruct (Q4_K_M)',
      sizeMb: 1980,
      ramRequiredMb: 2800,
      description: 'Modèle recommandé - Excellent français, raisonnement solide',
      url: 'https://huggingface.co/Qwen/Qwen2.5-3B-Instruct-GGUF/resolve/main/qwen2.5-3b-instruct-q4_k_m.gguf',
      license: 'Qwen License (Apache 2.0 compatible)',
      contextLength: 8192,
    ),
    AIModelConfig(
      id: 'qwen2.5-1.5b-q4km',
      name: 'Qwen2.5 1.5B Instruct (Q4_K_M)',
      sizeMb: 1050,
      ramRequiredMb: 1600,
      description: 'Alternative légère - Bon compromis qualité/ressources',
      url: 'https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf',
      license: 'Qwen License',
      contextLength: 8192,
    ),
    AIModelConfig(
      id: 'tinyllama-1.1b-q4',
      name: 'TinyLlama 1.1B Chat (Q4_0)',
      sizeMb: 620,
      ramRequiredMb: 900,
      description: 'Ultra-léger - Pour appareils скромные, français basique',
      url: 'https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_0.gguf',
      license: 'Apache 2.0',
      contextLength: 2048,
    ),
  ];

  // ── Google Drive ──
  static const String driveAppFolder = 'RapportPlus';
  static const List<String> driveScopes = [
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.appdata',
  ];

  // ── Report ──
  static const String reportDefaultLanguage = 'fr';
  static const int reportMinEntriesForGeneration = 3;

  // ── UI ──
  static const Duration animationDuration = Duration(milliseconds: 250);
}

class AIModelConfig {
  final String id;
  final String name;
  final int sizeMb;
  final int ramRequiredMb;
  final String description;
  final String url;
  final String license;
  final int contextLength;
  const AIModelConfig({
    required this.id,
    required this.name,
    required this.sizeMb,
    required this.ramRequiredMb,
    required this.description,
    required this.url,
    required this.license,
    required this.contextLength,
  });
}
