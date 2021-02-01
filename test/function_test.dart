import 'package:dart_code/basic.dart';
import 'package:dart_code/function.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Function.withoutName', () {
    test('Given no arguments => Results in the correct code', () {
      String actual = Function.withoutName(Body(Expression.ofBool(true)),
              returnType: Type.ofBool())
          .toString();
      String expected = 'bool () => true';
      expect(actual, expected);
    });
  });
}
