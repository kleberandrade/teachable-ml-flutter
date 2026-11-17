import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teachable_ml/main.dart';
import 'package:teachable_ml/controller.dart';
import 'package:teachable_ml/domain/classification.dart';

class Engine implements Classifier {
  @override
  Future<void> load() async {}
  @override
  Future<List<Prediction>> classify(Uint8List bytes) async => [
    const Prediction('Gato', .8),
    const Prediction('Cachorro', .2),
  ];
  @override
  void close() {}
}

void main() {
  testWidgets('responsive empty state, cancellation and reset are accessible', (
    tester,
  ) async {
    final state = ClassificationController(Engine());
    await state.initialize();
    await tester.binding.setSurfaceSize(const Size(360, 740));
    await tester.pumpWidget(
      MyApp(controller: state, pickImage: () async => null),
    );
    expect(find.text('Gato ou cachorro?'), findsOneWidget);
    expect(find.text('Créditos e licenças'), findsOneWidget);
    await tester.ensureVisible(find.text('Escolher imagem'));
    await tester.tap(find.text('Escolher imagem'));
    await tester.pumpAndSettle();
    expect(find.text('Sua imagem aparece aqui'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Créditos e licenças'));
    await tester.tap(find.text('Créditos e licenças'));
    await tester.pumpAndSettle();
    expect(find.text('Teachable Lab'), findsOneWidget);
    expect(
      find.text('Copyright 2020 Kleber de Oliveira Andrade'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    await tester.binding.setSurfaceSize(null);
  });
}
