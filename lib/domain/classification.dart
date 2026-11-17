import 'dart:typed_data';

import 'package:image/image.dart' as img;

const inputSize = 224;
const maxImageBytes = 12 * 1024 * 1024;

List<String> parseLabels(String text) {
  final lines = text.trim().split('\n');
  final labels = <String>[];
  for (var i = 0; i < lines.length; i++) {
    final match = RegExp(r'^(\d+)\s+(.+)$').firstMatch(lines[i].trim());
    if (match == null ||
        int.parse(match[1]!) != i ||
        match[2]!.trim().isEmpty) {
      throw const FormatException('Rótulos inválidos ou fora de ordem.');
    }
    labels.add(match[2]!.trim());
  }
  if (labels.length != 2 || labels.toSet().length != labels.length) {
    throw const FormatException(
      'O modelo desta aula exige duas classes únicas.',
    );
  }
  return List.unmodifiable(labels);
}

void validateContract(
  List<int> input,
  List<int> output,
  bool floatInput,
  bool floatOutput,
  int labelCount,
) {
  if (input.join(',') != '1,224,224,3' ||
      output.join(',') != '1,$labelCount' ||
      !floatInput ||
      !floatOutput) {
    throw const FormatException(
      'Modelo incompatível: esperado RGB float32 [1,224,224,3] → [1,2].',
    );
  }
}

Float32List preprocess(Uint8List bytes) {
  if (bytes.isEmpty || bytes.length > maxImageBytes) {
    throw const FormatException('Escolha uma imagem de até 12 MB.');
  }
  final decoder = img.findDecoderForData(bytes);
  final info = decoder?.startDecode(bytes);
  if (info == null || info.width * info.height > 24000000) {
    throw const FormatException('Imagem inválida ou maior que 24 megapixels.');
  }
  final decoded = decoder!.decodeFrame(0);
  if (decoded == null) {
    throw const FormatException('Não foi possível abrir a imagem.');
  }
  final oriented = img
      .bakeOrientation(decoded)
      .convert(format: img.Format.uint8, numChannels: 3);
  final square = img.copyResizeCropSquare(
    oriented,
    size: inputSize,
    interpolation: img.Interpolation.linear,
  );
  final result = Float32List(inputSize * inputSize * 3);
  var index = 0;
  for (final pixel in square) {
    result[index++] = pixel.r / 127.5 - 1;
    result[index++] = pixel.g / 127.5 - 1;
    result[index++] = pixel.b / 127.5 - 1;
  }
  return result;
}

class Prediction {
  const Prediction(this.label, this.score);
  final String label;
  final double score;
}

List<Prediction> interpret(List<double> scores, List<String> labels) {
  if (scores.length != labels.length ||
      scores.isEmpty ||
      scores.any((s) => !s.isFinite || s < 0 || s > 1) ||
      (scores.fold(0.0, (a, b) => a + b) - 1).abs() > .01) {
    throw const FormatException('O modelo retornou probabilidades inválidas.');
  }
  return List.generate(scores.length, (i) => Prediction(labels[i], scores[i]))
    ..sort((a, b) => b.score.compareTo(a.score));
}
