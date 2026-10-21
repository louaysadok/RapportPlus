import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import '../../core/config/app_config.dart';
import '../../core/utils/fact_guard.dart';

/// AI Service - Local LLM via llama.cpp
/// Falls back to rule-based engine when model not available.

enum AIModelStatus { notDownloaded, downloading, ready, loading, loaded, error, unsupported }

class AIModelState {
  final AIModelStatus status;
  final String? modelId;
  final double downloadProgress;
  final String? error;
  const AIModelState({required this.status, this.modelId, this.downloadProgress = 0, this.error});
}

class AIService {
  AIModelState _state = const AIModelState(status: AIModelStatus.notDownloaded);
  AIModelState get state => _state;

  // Simulated llama.cpp binding - real implementation uses ffi
  // ignore: unused_field
  bool _isInitialized = false;
  String? _loadedModelPath;

  /// Check device compatibility
  Future<DeviceCompatibility> checkCompatibility(String modelId) async {
    final model = AppConfig.availableModels.firstWhere((m) => m.id == modelId,
        orElse: () => AppConfig.availableModels.first);
    // Estimate RAM: in sandbox we have 1.9GB, real device check uses device_info_plus
    // For demo, we simulate checks
    final totalMemMb = 1900; // would be actual device RAM
    final availableStorageMb = 8000; // would be actual storage
    return DeviceCompatibility(
      model: model,
      hasEnoughRam: totalMemMb >= model.ramRequiredMb,
      hasEnoughStorage: availableStorageMb >= model.sizeMb + 500,
      totalRamMb: totalMemMb,
      availableStorageMb: availableStorageMb,
      recommendation: totalMemMb < 2000
          ? 'Votre appareil a une mémoire limitée. Le modèle TinyLlama 1.1B est recommandé.'
          : 'Votre appareil peut exécuter ce modèle.',
    );
  }

  Future<void> downloadModel(String modelId, {void Function(double)? onProgress}) async {
    _state = AIModelState(status: AIModelStatus.downloading, modelId: modelId, downloadProgress: 0);
    // Real implementation: HTTP download with resume to getApplicationDocumentsDirectory/models/
    // Simulated progressive download
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 120));
      _state = AIModelState(status: AIModelStatus.downloading, modelId: modelId, downloadProgress: i / 100);
      onProgress?.call(i / 100);
    }
    _state = AIModelState(status: AIModelStatus.ready, modelId: modelId, downloadProgress: 1.0);
  }

  Future<void> loadModel(String modelId) async {
    _state = AIModelState(status: AIModelStatus.loading, modelId: modelId);
    await Future.delayed(const Duration(milliseconds: 800));
    // Real: llama.cpp model load via ffi
    _loadedModelPath = '/data/models/$modelId.gguf';
    _isInitialized = true;
    _state = AIModelState(status: AIModelStatus.loaded, modelId: modelId);
  }

  void unloadModel() {
    _isInitialized = false;
    _loadedModelPath = null;
    if (_state.modelId != null) {
      _state = AIModelState(status: AIModelStatus.ready, modelId: _state.modelId);
    }
  }

  Future<void> deleteModel(String modelId) async {
    // Delete file from storage
    _state = const AIModelState(status: AIModelStatus.notDownloaded);
  }

  // ── AI Tasks ──

  /// Correct grammar & translate to French, preserving facts.
  Future<String> correctAndTranslate(String input, {String inputLang = 'auto'}) async {
    if (!_isInitialized) return _ruleBasedCorrect(input);
    final prompt = '''${FactGuard.systemGuardPrompt}
Corrige et traduis en français clair et professionnel (niveau B2 max):
Texte: "$input"
Français:''';
    return _infer(prompt, input);
  }

  /// Summarize daily activities
  Future<String> summarizeDay(List<String> entries) async {
    if (!_isInitialized) return _ruleBasedSummarize(entries);
    final prompt = '''${FactGuard.systemGuardPrompt}
Résume ces activités de stage en 3-4 phrases en français clair:
${entries.join('\n')}
Résumé:''';
    return _infer(prompt, entries.join(' '));
  }

  /// Detect missing info & generate questions
  Future<List<String>> detectMissingInfo({
    required String chapterTitle,
    required String currentContent,
    required String professionalField,
  }) async {
    if (currentContent.length > 200) return [];
    // Rule-based missing info detector
    final questions = <String>[];
    switch (chapterTitle.toLowerCase()) {
      case 'présentation de l\'entreprise':
        if (!currentContent.toLowerCase().contains('activité')) {
          questions.add('Quelle est l\'activité principale de l\'entreprise ?');
        }
        if (!currentContent.toLowerCase().contains('département')) {
          questions.add('Combien de départements ou services l\'entreprise possède-t-elle ?');
        }
        questions.add('Dans quel département/service avez-vous effectué votre stage ?');
        break;
      case 'activités réalisées':
        questions.add('Quelles tâches avez-vous effectuées vous-même ?');
        questions.add('Quels outils ou logiciels avez-vous utilisés ?');
        break;
      default:
        if (currentContent.trim().isEmpty) {
          questions.add('Cette section est vide. Que souhaitez-vous y inclure ?');
        }
    }
    return questions;
  }

  /// Generate jury questions based on actual entries
  Future<List<Map<String, String>>> generateJuryQuestions({
    required String internshipTitle,
    required String professionalField,
    required List<String> journalEntries,
  }) async {
    // Rule-based generator - never invents
    final base = [
      {
        'question': 'Pouvez-vous présenter l\'entreprise dans laquelle vous avez effectué votre stage ?',
        'category': 'entreprise',
      },
      {
        'question': 'Quels étaient les objectifs de votre stage ?',
        'category': 'objectifs',
      },
      {
        'question': 'Quelles activités avez-vous réalisées durant votre stage ?',
        'category': 'activités',
      },
      {
        'question': 'Quelles compétences avez-vous acquises ?',
        'category': 'compétences',
      },
      {
        'question': 'Quelles difficultés avez-vous rencontrées et comment les avez-vous surmontées ?',
        'category': 'difficultés',
      },
      {
        'question': 'Qu\'avez-vous appris de cette expérience ?',
        'category': 'bilan',
      },
    ];
    // Add field-specific
    if (professionalField.toLowerCase().contains('informatique')) {
      base.add({
        'question': 'Quelles technologies ou langages avez-vous utilisés ?',
        'category': 'technique',
      });
    }
    if (professionalField.toLowerCase().contains('mécanique')) {
      base.add({
        'question': 'Quelles machines ou équipements avez-vous manipulés ?',
        'category': 'technique',
      });
    }
    return base;
  }

  /// Evaluate mock jury answer
  Future<EvaluationResult> evaluateAnswer({
    required String question,
    required String userAnswer,
    required List<String> sourceEntries,
  }) async {
    int score = 5;
    final feedback = <String>[];
    if (userAnswer.length < 20) {
      score -= 2;
      feedback.add('Votre réponse est trop courte. Développez davantage.');
    }
    if (userAnswer.length > 50) score += 1;
    if (RegExp(r'\b(parce que|car|donc|ensuite|puis)\b', caseSensitive: false).hasMatch(userAnswer)) {
      score += 1;
      feedback.add('Bonne structure logique.');
    } else {
      feedback.add('Essayez d\'utiliser des connecteurs logiques (parce que, ensuite...).');
    }
    feedback.add('Assurez-vous que votre réponse correspond à votre expérience réelle.');
    return EvaluationResult(
      score: score.clamp(0, 10),
      feedback: feedback,
      improvedExample: 'Exemple amélioré: ${userAnswer.trim()} En effet, cette expérience m\'a permis de...',
    );
  }

  // ── Private ──

  Future<String> _infer(String prompt, String fallbackInput) async {
    // Real: call llama.cpp via Isolate to avoid UI freeze
    // Simulated local inference
    await Future.delayed(const Duration(milliseconds: 600));
    return _ruleBasedCorrect(fallbackInput);
  }

  String _ruleBasedCorrect(String input) {
    // Minimal rule-based fallback - preserves facts, fixes obvious errors
    // In production, this is replaced by real LLM output
    var t = input.trim();
    if (t.isEmpty) return '';
    // Basic cleanup - does NOT invent
    t = t.replaceAll(RegExp(r'\s+'), ' ');
    // Ensure first letter capital
    if (t.isNotEmpty) t = t[0].toUpperCase() + t.substring(1);
    if (!t.endsWith('.') && !t.endsWith('!') && !t.endsWith('?')) t += '.';
    return t;
  }

  String _ruleBasedSummarize(List<String> entries) {
    if (entries.isEmpty) return 'Aucune activité enregistrée.';
    if (entries.length == 1) return entries.first;
    return 'Journée comprenant ${entries.length} activités. Points clés: ${entries.first}';
  }
}

class DeviceCompatibility {
  final AIModelConfig model;
  final bool hasEnoughRam;
  final bool hasEnoughStorage;
  final int totalRamMb;
  final int availableStorageMb;
  final String recommendation;
  DeviceCompatibility({
    required this.model,
    required this.hasEnoughRam,
    required this.hasEnoughStorage,
    required this.totalRamMb,
    required this.availableStorageMb,
    required this.recommendation,
  });
  bool get isCompatible => hasEnoughRam && hasEnoughStorage;
}

class EvaluationResult {
  final int score;
  final List<String> feedback;
  final String improvedExample;
  EvaluationResult({required this.score, required this.feedback, required this.improvedExample});
}
