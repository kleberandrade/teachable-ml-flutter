import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:teachable_ml/domain/classification.dart';

void main() {
  test('labels preserve output order and require contiguous indices', () {
    expect(parseLabels('0 Gato\n1 Cachorro\n'), ['Gato', 'Cachorro']);
    for (final value in [
      '',
      '1 Gato\n0 Cachorro',
      '0 \n1 Dog',
      '0 Cat\n1 Cat',
    ]) {
      expect(() => parseLabels(value), throwsFormatException);
    }
  });
  test('model contract rejects wrong shapes and types', () {
    validateContract([1, 224, 224, 3], [1, 2], true, true, 2);
    for (final shape in [
      [224, 224, 3],
      [1, 224, 224, 1],
      [2, 224, 224, 3],
    ]) {
      expect(
        () => validateContract(shape, [1, 2], true, true, 2),
        throwsFormatException,
      );
    }
    expect(
      () => validateContract([1, 224, 224, 3], [1, 3], true, true, 2),
      throwsFormatException,
    );
    expect(
      () => validateContract([1, 224, 224, 3], [1, 2], false, true, 2),
      throwsFormatException,
    );
    expect(
      () => validateContract([1, 224, 224, 3], [1, 2], true, false, 2),
      throwsFormatException,
    );
  });
  test('preprocessing produces RGB float32 in [-1,1]', () {
    final photo = img.Image(width: 3, height: 2)
      ..clear(img.ColorRgb8(255, 0, 128));
    final pixels = preprocess(Uint8List.fromList(img.encodePng(photo)));
    expect(pixels.length, 224 * 224 * 3);
    expect(pixels.take(3), [1.0, -1.0, closeTo(128 / 127.5 - 1, 1e-6)]);
    expect(() => preprocess(Uint8List(0)), throwsFormatException);
    expect(
      () => preprocess(Uint8List.fromList([1, 2, 3])),
      throwsFormatException,
    );
  });
  test('EXIF orientation is baked before center crop', () {
    final photo = img.Image(width: 4, height: 2);
    for (final p in photo) {
      p.setRgb(p.x < 2 ? 255 : 0, 0, 0);
    }
    photo.exif.imageIfd.orientation = 6;
    final pixels = preprocess(
      Uint8List.fromList(img.encodeJpg(photo, quality: 100)),
    );
    expect(pixels[0], greaterThan(.8));
    expect(pixels[(224 * 223) * 3], lessThan(-.8));
  });
  test(
    'scores sorted without changing label mapping; invalid scores rejected',
    () {
      final result = interpret([.2, .8], ['Gato', 'Cachorro']);
      expect(result.first.label, 'Cachorro');
      expect(result.first.score, .8);
      for (final scores in [
        [.5],
        [double.nan, .5],
        [double.infinity, 0.0],
        [-.1, 1.1],
        [.2, .2],
      ]) {
        expect(
          () => interpret(scores, ['Gato', 'Cachorro']),
          throwsFormatException,
        );
      }
    },
  );
}
