import 'dart:io' as io;

import 'package:archive_test/archive.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('decode', () {
    final orig = io.File(p.join('test/_data/bzip2/test.bz2')).readAsBytesSync();

    BZip2Decoder().decodeBytes(orig, verify: true);
  });

  test('encode', () {
    final file = io.File(p.join('test/_data/cat.jpg')).readAsBytesSync();

    final compressed = BZip2Encoder().encodeBytes(file);

    final d2 = BZip2Decoder().decodeBytes(compressed, verify: true);

    expect(d2.length, equals(file.length));
    for (var i = 0, len = d2.length; i < len; ++i) {
      expect(d2[i], equals(file[i]));
    }
  });
}
