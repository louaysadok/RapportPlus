import 'package:flutter_test/flutter_test.dart';
import 'package:rapport_plus/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Rapport+ app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RapportPlusApp()));
    expect(find.text('Rapport+'), findsWidgets);
  });
}
