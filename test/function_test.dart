import 'package:dart_code/basic.dart';
import 'package:dart_code/function.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Function.withoutName', () {
    test('Returns a anonymous function that returns a boolean of value true',
        () {
      String actual = Function.withoutName(Expression.ofBool(true),
              returnType: Type.ofBool())
          .toString();
      String expected = 'bool () => true;\n';
      expect(actual, expected);
    });
  });

  group('Function.withName', () {
    test('Returns a named function that returns a boolean of value true', () {
      var actual = Function.withName('returnTrue', Expression.ofBool(true),
              returnType: Type.ofBool())
          .toString();
      var expected = 'bool returnTrue() => true;\n';
      expect(actual, expected);
    });
  });

  group('Function.main', () {
    test('Returns main function that prints hello world', () {
      var actual = Function.main(Code("print('Hello World.');")).toString();
      var expected = 'main() {\n'
          '  print(\'Hello World.\');\n'
          '}';
      expect(actual, expected);
    });
  });
}
