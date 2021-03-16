import 'package:dart_code/annotation.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/parameter.dart';
import 'package:dart_code/type.dart';
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
  });
}
