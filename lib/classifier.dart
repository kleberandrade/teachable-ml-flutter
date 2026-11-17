import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'controller.dart';
import 'domain/classification.dart';

void _validate(Interpreter interpreter, int labelCount) {
  final inputs = interpreter.getInputTensors();
  final outputs = interpreter.getOutputTensors();
  if (inputs.length != 1 || outputs.length != 1) {
    throw const FormatException('O modelo deve ter uma entrada e uma saída.');
  }
  validateContract(
    inputs.single.shape,
    outputs.single.shape,
    inputs.single.type == TensorType.float32,
    outputs.single.type == TensorType.float32,
    labelCount,
  );
}

// Each job owns its native interpreter. Failures propagate across the isolate
// boundary and disposal/reset cannot free a runtime that is still in use.
List<Prediction> _infer((Uint8List, Uint8List, List<String>) request) {
  final (model, image, labels) = request;
  final pixels = preprocess(image);
  final interpreter = Interpreter.fromBuffer(model);
  try {
    _validate(interpreter, labels.length);
    final output = [List<double>.filled(labels.length, 0)];
    interpreter.run(pixels.buffer.asUint8List(), output);
    return interpret(output.single, labels);
  } finally {
    interpreter.close();
  }
}

class LocalClassifier implements Classifier {
  Uint8List? _model;
  List<String> _labels = [];
  bool _closed = false;
  @override
  Future<void> load() async {
    final labels = parseLabels(
      await rootBundle.loadString('assets/labels.txt'),
    );
    final data = await rootBundle.load('assets/model_unquant.tflite');
    final model = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final interpreter = Interpreter.fromBuffer(model);
    try {
      _validate(interpreter, labels.length);
    } finally {
      interpreter.close();
    }
    if (!_closed) {
      _labels = labels;
      _model = model;
    }
  }

  @override
  Future<List<Prediction>> classify(Uint8List bytes) {
    final model = _model;
    if (model == null || _closed) throw StateError('Model not loaded');
    return compute(_infer, (model, bytes, _labels));
  }

  @override
  void close() {
    _closed = true;
    _model = null;
  }
}
