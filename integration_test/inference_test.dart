import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:teachable_ml/classifier.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('native model loads and classifies licensed cat/dog fixtures', (
    tester,
  ) async {
    final classifier = LocalClassifier();
    await classifier.load();
    for (final name in ['cat', 'dog']) {
      final bytes = (await rootBundle.load('assets/samples/$name.jpg')).buffer
          .asUint8List();
      final results = await classifier.classify(bytes);
      expect(results.length, 2);
      expect(results.map((p) => p.label).toSet(), {'Gato', 'Cachorro'});
      expect(results.first.score, inInclusiveRange(0, 1));
      // This is a two-fixture smoke test, never an accuracy benchmark.
      expect(results.first.label, name == 'cat' ? 'Gato' : 'Cachorro');
      // ignore: avoid_print
      print('$name: ${results.map((p) => '${p.label}=${p.score}').join(', ')}');
    }
    await expectLater(
      classifier.classify(Uint8List.fromList([1, 2, 3])),
      throwsFormatException,
    );
    classifier.close();
    expect(() => classifier.classify(Uint8List(1)), throwsStateError);
  });
}
// Keep the post-disposal request independent from any filesystem access.
// A one-byte invalid image must be rejected by lifecycle validation first.
