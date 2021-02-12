import 'package:dart_code/basic.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/model.dart';
import 'package:dart_code/statement.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Statement class', () {
    group('Statement() constructor', () {
      test("Should return: 'test();\n'", () {
        String actual = Statement([Code('test()')]).toString();
        String expected = "test();\n";
        expect(actual, expected);
      });
    });

    group('Statement.return\$ constructor', () {
      test("Should return: 'test();\n'", () {
        String actual =
            Statement.return$(Expression.ofString('Hello World')).toString();
        String expected = "return 'Hello World';\n";
        expect(actual, expected);
      });
    });

    group('Statement.assignVariable() constructor', () {
      test("Should return: greeting = 'Hello World';\n", () {
        String actual = Statement.assignVariable(
                "greeting", Expression.ofString('Hello World'))
            .toString();
        String expected = "greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: greeting ??= 'Hello World';\n", () {
        String actual = Statement.assignVariable(
                "greeting", Expression.ofString('Hello World'),
                nullAware: true)
            .toString();
        String expected = "greeting ??= 'Hello World';\n";
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
  });
  group('VariableDefinition class', () {
    group('var\$() constructor', () {
      test("Should return: var greeting;\n", () {
        String actual = VariableDefinition.var$("greeting").toString();
        String expected = "var greeting;\n";
        expect(actual, expected);
      });

      test("Should return: var greeting = 'Hello World';\n", () {
        String actual = VariableDefinition.var$("greeting",
                value: Expression.ofString('Hello World'))
            .toString();
        String expected = "var greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: String greeting = 'Hello World';\n", () {
        String actual = VariableDefinition.var$("greeting",
                value: Expression.ofString('Hello World'),
                type: Type.ofString())
            .toString();
        String expected = "String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: static String greeting = 'Hello World';\n", () {
        String actual = VariableDefinition.var$("greeting",
                value: Expression.ofString('Hello World'),
                type: Type.ofString(),
                static: true)
            .toString();
        String expected = "static String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          VariableDefinition.var$("InvalidVariableName").toString();
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('final\$() constructor', () {
      test("Should return: final greeting = 'Hello World';\n", () {
        String actual = VariableDefinition.final$(
                "greeting", Expression.ofString('Hello World'))
            .toString();
        String expected = "final greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: final String greeting = 'Hello World';\n", () {
        String actual = VariableDefinition.final$(
                "greeting", Expression.ofString('Hello World'),
                type: Type.ofString())
            .toString();
        String expected = "final String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: final String greeting = 'Hello World';\n", () {
        String actual = VariableDefinition.final$(
                "greeting", Expression.ofString('Hello World'),
                type: Type.ofString(), static: true)
            .toString();
        String expected = "static final String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          VariableDefinition.final$(
                  "InvalidVariableName", Expression.ofString('Hello World'))
              .toString();
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('const\$() constructor', () {
      test("Should return: const greeting = 'Hello World';\n", () {
        String actual = VariableDefinition.const$(
                "greeting", Expression.ofString('Hello World'))
            .toString();
        String expected = "const greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: const String greeting = 'Hello World';\n", () {
        String actual = VariableDefinition.const$(
                "greeting", Expression.ofString('Hello World'),
                type: Type.ofString())
            .toString();
        String expected = "const String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: static const String greeting = 'Hello World';\n",
          () {
        String actual = VariableDefinition.const$(
                "greeting", Expression.ofString('Hello World'),
                type: Type.ofString(), static: true)
            .toString();
        String expected = "static const String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          VariableDefinition.const$(
                  "InvalidVariableName", Expression.ofString('Hello World'))
              .toString();
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
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
