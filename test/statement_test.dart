import 'package:dart_code/model.dart';
import 'package:dart_code/statement.dart';
import 'package:flutter_test/flutter_test.dart';


main() {
  group('Statement class', () {
    test('Given Statement => Returns the correct code', () {
      String actual = Statement([Code('test()')]).toString();
      String expected = "test();\n";
      expect(actual, expected);
    });
  });

  group('Statements class', () {
    test('Given Statements => Returns the correct code', () {
      String actual = Statements([
        Statement([Code('test1()')]),
        Statement([Code('test2()')])
      ]).toString();
      String expected = "test1();\n"
          "test2();\n";
      expect(actual, expected);
    });
  });
}