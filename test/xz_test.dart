import 'dart:convert';
import 'dart:io';

import 'package:archive_test/archive.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '_test_util.dart';

void main() {
  group('xz', () {
    test('good-1-lzma2-1.xz', () {
      final file = File(p.join('test/_data/xz/good-1-lzma2-1.xz'));
      final compressed = file.readAsBytesSync();
      final data = XZDecoder().decodeBytes(compressed);
      final expected = File(p.join('test/_data/xz/expected/good-1-lzma2-1'))
          .readAsBytesSync();

      expect(data.length, equals(expected.length));
      for (var i = 0; i < data.length; ++i) {
        expect(data[i], equals(expected[i]));
      }
    });

    test('decode empty', () {
      final file = File(p.join('test/_data/xz/empty.xz'));
      final compressed = file.readAsBytesSync();
      final data = XZDecoder().decodeBytes(compressed);
      expect(data, isEmpty);
    });

    test('decode hello', () {
      // hello.xz has no LZMA compression due to its simplicity.
      final file = File(p.join('test/_data/xz/hello.xz'));
      final compressed = file.readAsBytesSync();
      final data = XZDecoder().decodeBytes(compressed);
      expect(data, equals(utf8.encode('hello\n')));
    });

    test('decode crc32', () {
      // Uses a CRC-32 checksum.
      final file = File(p.join('test/_data/xz/crc32.xz'));
      final compressed = file.readAsBytesSync();
      final data = XZDecoder().decodeBytes(compressed, verify: true);
      expect(data, equals(utf8.encode('hello\n')));
    });

    test('decode crc64', () {
      // Uses a CRC-64 checksum.
      final file = File(p.join('test/_data/xz/crc64.xz'));
      final compressed = file.readAsBytesSync();
      final data = XZDecoder().decodeBytes(compressed, verify: true);
      expect(data, equals(utf8.encode('hello\n')));
    });

    test('decode sha256', () {
      // Uses a SHA-256 checksum.
      final file = File(p.join('test/_data/xz/sha256.xz'));
      final compressed = file.readAsBytesSync();
      final data = XZDecoder().decodeBytes(compressed, verify: true);
      expect(data, equals(utf8.encode('hello\n')));
    });

    test('decode nocheck', () {
      // Uses no checksum
      final file = File(p.join('test/_data/xz/nocheck.xz'));
      final compressed = file.readAsBytesSync();
      final data = XZDecoder().decodeBytes(compressed, verify: true);
      expect(data, equals(utf8.encode('hello\n')));
    });

    test('decode hello repeated', () {
      // Simple file with a small amount of compression due to repeated data.
      final file = File(p.join('test/_data/xz/hello-hello-hello.xz'));
      final compressed = file.readAsBytesSync();
      final data = XZDecoder().decodeBytes(compressed);
      expect(data, equals(utf8.encode('hello hello hello')));
    });

    test('decode cat.jpg', () {
      final file = File(p.join('test/_data/xz/cat.jpg.xz'));
      final compressed = file.readAsBytesSync();
      final b = File(p.join('test/_data/cat.jpg'));
      final bBytes = b.readAsBytesSync();
      final data = XZDecoder().decodeBytes(compressed);
      compareBytes(data, bBytes);
    });

    test('encode empty', () {
      final file = File(p.join('test/_data/xz/empty.xz'));
      final expected = file.readAsBytesSync();
      final data = XZEncoder().encodeBytes([]);
      compareBytes(data, expected);
    });

    test('encode hello', () {
      // hello.xz has no LZMA compression due to its simplicity.
      final file = File(p.join('test/_data/xz/hello.xz'));
      final expected = file.readAsBytesSync();
      final data = XZEncoder().encodeBytes(utf8.encode('hello\n'));
      compareBytes(data, expected);
    });

    test('encode crc32', () {
      // Uses a CRC-32 checksum.
      final file = File(p.join('test/_data/xz/crc32.xz'));
      final expected = file.readAsBytesSync();
      final data =
          XZEncoder().encodeBytes(utf8.encode('hello\n'), check: XZCheck.crc32);
      compareBytes(data, expected);
    });

    test('encode crc64', () {
      // Uses a CRC-64 checksum.
      final file = File(p.join('test/_data/xz/crc64.xz'));
      final expected = file.readAsBytesSync();
      final data =
          XZEncoder().encodeBytes(utf8.encode('hello\n'), check: XZCheck.crc64);
      compareBytes(data, expected);
    });

    test('encode sha256', () {
      // Uses a SHA-256 checksum.
      final file = File(p.join('test/_data/xz/sha256.xz'));
      final expected = file.readAsBytesSync();
      final data = XZEncoder()
          .encodeBytes(utf8.encode('hello\n'), check: XZCheck.sha256);
      compareBytes(data, expected);
    });

    test('encode nocheck', () {
      // Uses no checksum
      final file = File(p.join('test/_data/xz/nocheck.xz'));
      final expected = file.readAsBytesSync();
      final data =
          XZEncoder().encodeBytes(utf8.encode('hello\n'), check: XZCheck.none);
      compareBytes(data, expected);
    });
  });
}
