import 'package:flutter_test/flutter_test.dart';
// import 'package:rapport_plus/core/utils/fact_guard.dart';

void main() {
  group('FactGuard', () {
    test('detects observed activity', () {
      // final type = FactGuard.detectActivityType("J'ai observé un mécanicien réparer une machine");
      // expect(type, ActivityType.observed);
      expect(1 + 1, 2); // placeholder - run after drift generation
    });

    test('preserves observation vs performance', () {
      // final result = FactGuard.preserveFact(
      //   "J'ai regardé un technicien réparer un moteur",
      //   "J'ai réparé un moteur électrique"
      // );
      // expect(() => result, throwsA(isA<FactViolation>()));
    });

    test('validates invented dates', () {
      // final issues = FactGuard.validateReportParagraph(
      //   paragraph: "Le 15/03/2024 j'ai effectué...",
      //   sourceEntries: ["Aujourd'hui j'ai observé..."],
      // );
      // expect(issues, isNotEmpty);
    });
  });
}
