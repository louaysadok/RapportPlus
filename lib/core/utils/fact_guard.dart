/// FactGuard - Core principle: NEVER fabricate internship experiences.
/// This utility enforces factual accuracy in AI generations.

enum ActivityType {
  performed,      // "J'ai effectué..."
  assisted,       // "J'ai participé à... avec l'aide de..."
  observed,       // "J'ai observé..."
  explained,      // "On m'a expliqué..."
  theoretical,    // "J'ai étudié..."
  unknown,
}

class FactGuard {
  /// Detects activity type from raw user text using keyword heuristics.
  /// This is used to tag entries so AI never upgrades observation -> performance.
  static ActivityType detectActivityType(String rawText) {
    final t = rawText.toLowerCase();
    // Observation markers
    if (RegExp(r"\b(j'ai vu|j'ai observé|j'ai regardé|on m'a montré|démonstration|j'ai assisté|témoin)\b")
        .hasMatch(t)) {
      return ActivityType.observed;
    }
    if (RegExp(r"\b(on m'a expliqu[ée]|explication|présentation|cours|théorie)\b").hasMatch(t)) {
      return ActivityType.explained;
    }
    if (RegExp(r"\b(avec l'aide|assisté par|supervis[ée]|accompagn[ée]|ensemble avec)\b").hasMatch(t)) {
      return ActivityType.assisted;
    }
    if (RegExp(r"\b(j'ai fait|j'ai effectu[ée]|j'ai réalis[ée]|j'ai répar[ée]|j'ai installé)\b").hasMatch(t)) {
      return ActivityType.performed;
    }
    return ActivityType.unknown;
  }

  /// Transforms a sentence to preserve factual accuracy.
  /// Example: "I watched a mechanic repair" -> "J'ai observé un mécanicien pendant..."
  static String preserveFact(String userInput, String proposedFrench) {
    final type = detectActivityType(userInput);
    // If AI output claims performance but user only observed, flag it.
    if (type == ActivityType.observed &&
        RegExp(r"J'ai (effectué|réalisé|réparé|exécuté)", caseSensitive: false)
            .hasMatch(proposedFrench)) {
      throw FactViolation(
          'Violation: user observed but AI claimed performance. Original: "$userInput" Proposed: "$proposedFrench"');
    }
    return proposedFrench;
  }

  /// Validates a generated report paragraph against source entries.
  static List<String> validateReportParagraph({
    required String paragraph,
    required List<String> sourceEntries,
  }) {
    final issues = <String>[];
    // Check for invented dates
    final datePattern = RegExp(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b');
    final paragraphDates = datePattern.allMatches(paragraph).map((m) => m.group(0)).toList();
    final sourceDates = sourceEntries.expand((e) => datePattern.allMatches(e).map((m) => m.group(0))).toList();
    for (final d in paragraphDates) {
      if (!sourceDates.contains(d)) {
        issues.add('Date inventée détectée: $d - non présente dans les entrées sources');
      }
    }
    // Check for invented equipment (simple heuristic)
    if (paragraph.toLowerCase().contains('j\'ai utilisé') &&
        !sourceEntries.join(' ').toLowerCase().contains('utilis')) {
      issues.add('Usage d\'outil non documenté - vérifier avec l\'utilisateur');
    }
    return issues;
  }

  /// Builds a safe AI prompt prefix that forbids hallucination.
  static String get systemGuardPrompt => '''
Tu es un assistant de stage. RÈGLES ABSOLUES:
- N'invente JAMAIS d'activités, dates, noms d'entreprise, outils ou résultats.
- Si l'utilisateur a OBSERVÉ, écris "J'ai observé..." et JAMAIS "J'ai effectué...".
- Si l'information manque, dis "Information manquante: [détail]".
- Chaque phrase doit être traçable à une entrée du journal.
- Le français doit être clair, professionnel mais simple.
- Utilise un vocabulaire accessible (niveau B1-B2).
''';
}

class FactViolation implements Exception {
  final String message;
  FactViolation(this.message);
  @override
  String toString() => 'FactViolation: $message';
}
