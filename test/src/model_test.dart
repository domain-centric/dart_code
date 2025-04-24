// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

main() {
  group('Code class', () {
    test('Given a Code => Returns the literal code string', () {
      Code("test();").toString().should.be('test();');
    });
  });
}
