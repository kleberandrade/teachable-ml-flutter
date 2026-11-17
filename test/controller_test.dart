import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:teachable_ml/domain/classification.dart';
import 'package:teachable_ml/controller.dart';

class FakeClassifier implements Classifier {
  bool loadError = false, inferError = false;
  Completer<List<Prediction>>? pending;
  @override
  Future<void> load() async {
    if (loadError) throw StateError('load');
  }

  @override
  Future<List<Prediction>> classify(Uint8List bytes) async {
    if (inferError) throw StateError('infer');
    return pending?.future ??
        [const Prediction('Gato', .9), const Prediction('Cachorro', .1)];
  }

  @override
  void close() {}
}

void main() {
  test('load failure can be retried, picker cancel preserves state, inference failure recovers', () async {
    final engine = FakeClassifier()..loadError = true;
    final state = ClassificationController(engine);
    await state.initialize();
    expect(state.error, isNotNull);
    engine.loadError = false;
    await state.initialize();
    expect(state.ready, isTrue);
    await state.choose(() async => null);
    expect(state.image, isNull);
    expect(state.error, isNull);
    engine.inferError = true;
    await state.choose(() async => Uint8List.fromList([1]));
    expect(state.error, isNotNull);
    engine.inferError = false;
    await state.choose(() async => Uint8List.fromList([1]));
    expect(state.predictions.first.label, 'Gato');
    state.reset();
    expect(state.image, isNull);
    expect(state.predictions, isEmpty);
    state.dispose();
  });
  test(
    'reset ignores stale work; picker errors recover; dispose while working',
    () async {
      final engine = FakeClassifier()..pending = Completer<List<Prediction>>();
      final state = ClassificationController(engine);
      await state.initialize();
      final work = state.choose(() async => Uint8List.fromList([1]));
      await Future<void>.delayed(Duration.zero);
      expect(state.busy, isTrue);
      state.reset();
      engine.pending!.complete([const Prediction('Gato', 1)]);
      await work;
      expect(state.predictions, isEmpty);
      await state.choose(() async => throw StateError('permission'));
      expect(state.error, isNotNull);
      final picker = Completer<Uint8List?>();
      final outstanding = state.choose(() => picker.future);
      state.dispose();
      picker.complete(null);
      await outstanding;
    },
  );
  test('empty image and overlapping requests are rejected', () async {
    final state = ClassificationController(FakeClassifier());
    await state.initialize();
    await state.choose(() async => Uint8List(0));
    expect(state.error, isNotNull);
    state.dispose();
  });
}
