import 'package:flutter/foundation.dart';

import 'domain/classification.dart';

abstract interface class Classifier {
  Future<void> load();
  Future<List<Prediction>> classify(Uint8List bytes);
  void close();
}

class ClassificationController extends ChangeNotifier {
  ClassificationController(this.classifier);
  final Classifier classifier;
  bool ready = false, busy = false, _disposed = false;
  int _generation = 0;
  String? error;
  Uint8List? image;
  List<Prediction> predictions = [];

  bool _current(int generation) => !_disposed && generation == _generation;

  Future<void> initialize() async {
    if (busy || _disposed) return;
    final generation = ++_generation;
    busy = true;
    ready = false;
    error = null;
    notifyListeners();
    try {
      await classifier.load();
      if (_current(generation)) ready = true;
    } catch (_) {
      if (_current(generation)) {
        error = 'Não foi possível carregar o modelo. Tente novamente.';
      }
    } finally {
      if (_current(generation)) {
        busy = false;
        notifyListeners();
      }
    }
  }

  Future<void> choose(Future<Uint8List?> Function() pick) async {
    if (!ready || busy || _disposed) return;
    final generation = ++_generation;
    busy = true;
    error = null;
    notifyListeners();
    try {
      final bytes = await pick();
      if (!_current(generation) || bytes == null) return;
      if (bytes.isEmpty || bytes.length > maxImageBytes) {
        throw const FormatException('Escolha uma imagem de até 12 MB.');
      }
      // Clear previous results before inferring a different image.
      image = bytes;
      predictions = [];
      notifyListeners();
      final result = await classifier.classify(bytes);
      if (_current(generation)) predictions = result;
    } on FormatException catch (e) {
      if (_current(generation)) error = e.message;
    } catch (_) {
      if (_current(generation)) error = 'Não foi possível analisar a imagem. Escolha outra e tente novamente.';
    } finally {
      if (_current(generation)) {
        busy = false;
        notifyListeners();
      }
    }
  }

  void reset() {
    if (_disposed) return;
    ++_generation;
    image = null;
    predictions = [];
    error = null;
    busy = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    ++_generation;
    classifier.close();
    super.dispose();
  }
}
