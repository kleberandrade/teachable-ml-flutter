class TFLiteResult {
  double confidence;
  int id;
  String label;

  TFLiteResult(this.confidence, this.id, this.label);

  TFLiteResult.fromModel(dynamic model) {
    confidence = model['confidence'];
    id = model['index'];
    label = model['label'];
  }
}
