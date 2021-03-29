import 'package:dart_code/dart_code.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Annotation class', () {
    test("Should return: '@Hidden()\n'", () {
      String actual = Annotation(Type('Hidden')).toString();
      String expected = '@Hidden()\n';
      expect(actual, expected);
    });

    test("Should return: '@Hidden(forRole: \'admin\')\n'", () {
      String actual = Annotation(
          Type('Hidden'),
          ParameterValues([
            ParameterValue.named('forRole', Expression.ofString('admin'))
          ])).toString();
      String expected = '@Hidden(forRole: \'admin\')\n';
      expect(actual, expected);
    });

    test("Should return: '@override\n'", () {
      String actual = Annotation.override().toString();
      String expected = '@override\n';
      expect(actual, expected);
    });

    test("Should return: '@required\n'", () {
      String actual = Annotation.required().toString();
      String expected = '@required\n';
      expect(actual, expected);
    });

    test("Should return: '@deprecated\n'", () {
      String actual = Annotation.deprecated().toString();
      String expected = '@deprecated\n';
      expect(actual, expected);
    });
  });
}
