// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

main() {
  group('Annotation class', () {
    test("Should return: '@Hidden()'", () {
      Annotation(Type('Hidden')).toString().should.be('@Hidden()\n');
    });

    test("Should return: '@Hidden(forRole: \'admin\')'", () {
      Annotation(
          Type('Hidden'),
          ParameterValues([
            ParameterValue.named('forRole', Expression.ofString('admin'))
          ])).toString().should.be('@Hidden(forRole: \'admin\')\n');
    });

    test("Should return: '@override'", () {
      Annotation.override().toString().should.be('@override\n');
    });

    test("Should return: '@required'", () {
      Annotation.required().toString().should.be('@required\n');
    });

    test("Should return: '@deprecated'", () {
      Annotation.deprecated().toString().should.be('@deprecated\n');
    });
  });
}
