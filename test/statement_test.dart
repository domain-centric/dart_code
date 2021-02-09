import 'package:dart_code/basic.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/model.dart';
import 'package:dart_code/statement.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Statement constructor', () {
    test('Given Statement => Returns the correct code', () {
      String actual = Statement([Code('test()')]).toString();
      String expected = "test();\n";
      expect(actual, expected);
    });
  });

  group('Statement.assignVariable() constructor', () {
    test("Should return: var greeting = 'Hello World';\n", () {
      String actual = Statement.assignVariable(
              "greeting", Expression.ofString('Hello World'))
          .toString();
      String expected = "var greeting = 'Hello World';\n";
      expect(actual, expected);
    });

    test("Should return: var greeting ??= 'Hello World';\n", () {
      String actual = Statement.assignVariable(
              "greeting", Expression.ofString('Hello World'),
              nullAware: true)
          .toString();
      String expected = "var greeting ??= 'Hello World';\n";
      expect(actual, expected);
    });

    test("Should return: String greeting = 'Hello World';\n", () {
      String actual = Statement.assignVariable(
              "greeting", Expression.ofString('Hello World'),
              type: Type.ofString())
          .toString();
      String expected = "String greeting = 'Hello World';\n";
      expect(actual, expected);
    });

    test("Should return: String greeting ??= 'Hello World';\n", () {
      String actual = Statement.assignVariable(
              "greeting", Expression.ofString('Hello World'),
              type: Type.ofString(), nullAware: true)
          .toString();
      String expected = "String greeting ??= 'Hello World';\n";
      expect(actual, expected);
    });

    test('Should throw name exception', () {
      expect(() {
        Statement.assignVariable(
                "InvalidVariableName", Expression.ofString('Hello World'))
            .toString();
      },
          throwsA((e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter'));
    });
  });

  group('Statement.assignFinal() constructor', () {
    test("Should return: final greeting = 'Hello World';\n", () {
      String actual =
          Statement.assignFinal("greeting", Expression.ofString('Hello World'))
              .toString();
      String expected = "final greeting = 'Hello World';\n";
      expect(actual, expected);
    });

    test("Should return: final String greeting = 'Hello World';\n", () {
      String actual = Statement.assignFinal(
              "greeting", Expression.ofString('Hello World'), Type.ofString())
          .toString();
      String expected = "final String greeting = 'Hello World';\n";
      expect(actual, expected);
    });

    test('Should throw name exception', () {
      expect(() {
        Statement.assignFinal(
                "InvalidVariableName", Expression.ofString('Hello World'))
            .toString();
      },
          throwsA((e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter'));
    });
  });

  group('Statement.assignConst() constructor', () {
    test("Should return: const greeting = 'Hello World';\n", () {
      String actual =
          Statement.assignConst("greeting", Expression.ofString('Hello World'))
              .toString();
      String expected = "const greeting = 'Hello World';\n";
      expect(actual, expected);
    });

    test("Should return: final String greeting = 'Hello World';\n", () {
      String actual = Statement.assignConst(
              "greeting", Expression.ofString('Hello World'), Type.ofString())
          .toString();
      String expected = "const String greeting = 'Hello World';\n";
      expect(actual, expected);
    });

    test('Should throw name exception', () {
      expect(() {
        Statement.assignConst(
                "InvalidVariableName", Expression.ofString('Hello World'))
            .toString();
      },
          throwsA((e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter'));
    });
  });

  group('Statements constructor', () {
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
