import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('VariableDefinition class', () {
    group('modifier=var\$', () {
      test("Should return: var greeting;\n", () {
        String actual = VariableDefinition("greeting").toString();
        String expected = "var greeting;\n";
        expect(actual, expected);
      });

      test("Should return: var greeting = 'Hello World';\n", () {
        String actual = VariableDefinition("greeting",
                value: Expression.ofString('Hello World'))
            .toString();
        String expected = "var greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: String greeting = 'Hello World';\n", () {
        String actual = VariableDefinition("greeting",
                value: Expression.ofString('Hello World'),
                type: Type.ofString())
            .toString();
        String expected = "String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: String? greeting = 'Hello World';\n", () {
        String actual = VariableDefinition(
          "greeting",
          value: Expression.ofString('Hello World'),
          type: Type.ofString(nullable: true),
        ).toString();
        String expected = "String? greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: static String greeting = 'Hello World';\n", () {
        String actual = CodeFormatter().unFormatted(VariableDefinition(
            "greeting",
            value: Expression.ofString('Hello World'),
            type: Type.ofString(),
            static: true));
        String expected = 'static String greeting = \'Hello World\';';
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          VariableDefinition("InvalidVariableName").toString();
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('modifier=lateVar\$', () {
      test("Should return: late greeting;\n", () {
        String actual =
            VariableDefinition("greeting", modifier: Modifier.lateVar$)
                .toString();
        String expected = "late var greeting;\n";
        expect(actual, expected);
      });

      test("Should return: late greeting = 'Hello World';\n", () {
        String actual = VariableDefinition("greeting",
                modifier: Modifier.lateVar$,
                value: Expression.ofString('Hello World'))
            .toString();
        String expected = "late var greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: late String greeting = 'Hello World';\n", () {
        String actual = VariableDefinition("greeting",
                modifier: Modifier.lateVar$,
                value: Expression.ofVariable('helloWorld'),
                type: Type.ofString())
            .toString();
        String expected = "late String greeting = helloWorld;\n";
        expect(actual, expected);
      });

      test("Should return: late String? greeting = helloWorld;\n", () {
        String actual = VariableDefinition(
          "greeting",
          modifier: Modifier.lateVar$,
          value: Expression.ofVariable('helloWorld'),
          type: Type.ofString(nullable: true),
        ).toString();
        String expected = "late String? greeting = helloWorld;\n";
        expect(actual, expected);
      });

      test("Should return: static late String greeting = 'Hello World';\n", () {
        String actual = CodeFormatter().unFormatted(VariableDefinition(
            "greeting",
            modifier: Modifier.lateVar$,
            value: Expression.ofString('Hello World'),
            type: Type.ofString(),
            static: true));
        String expected = 'static late String greeting = \'Hello World\';';
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          VariableDefinition("InvalidVariableName", modifier: Modifier.lateVar$)
              .toString();
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('modifier=final\$', () {
      test("Should return: final greeting = 'Hello World';\n", () {
        String actual = VariableDefinition("greeting",
                modifier: Modifier.final$,
                value: Expression.ofString('Hello World'))
            .toString();
        String expected = "final greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: final String greeting = 'Hello World';\n", () {
        String actual = VariableDefinition(
          "greeting",
          modifier: Modifier.final$,
          type: Type.ofString(),
          value: Expression.ofVariable('helloWorld'),
        ).toString();
        String expected = "final String greeting = helloWorld;\n";
        expect(actual, expected);
      });

      test("Should return: final String? greeting = helloWorld;\n", () {
        String actual = VariableDefinition(
          "greeting",
          modifier: Modifier.final$,
          type: Type.ofString(nullable: true),
          value: Expression.ofVariable('helloWorld'),
        ).toString();
        String expected = "final String? greeting = helloWorld;\n";
        expect(actual, expected);
      });

      test("Should return: static final String greeting = 'Hello World';\n",
          () {
        String actual = CodeFormatter().unFormatted(VariableDefinition(
          "greeting",
          static: true,
          modifier: Modifier.final$,
          type: Type.ofString(),
          value: Expression.ofString('Hello World'),
        ));
        String expected = 'static final String greeting = \'Hello World\';';
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          VariableDefinition("InvalidVariableName",
                  modifier: Modifier.final$,
                  value: Expression.ofString('Hello World'))
              .toString();
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('modifier=lateFinal\$', () {
      test("Should return: late final greeting = 'Hello World';\n", () {
        String actual = VariableDefinition("greeting",
                modifier: Modifier.lateFinal$,
                value: Expression.ofString('Hello World'))
            .toString();
        String expected = "late final greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: late final String greeting = helloWorld;\n", () {
        String actual = VariableDefinition(
          "greeting",
          modifier: Modifier.lateFinal$,
          type: Type.ofString(),
          value: Expression.ofVariable('helloWorld'),
        ).toString();
        String expected = "late final String greeting = helloWorld;\n";
        expect(actual, expected);
      });

      test("Should return: late final String? greeting = helloWorld;\n", () {
        String actual = VariableDefinition(
          "greeting",
          modifier: Modifier.lateFinal$,
          type: Type.ofString(nullable: true),
          value: Expression.ofVariable('helloWorld'),
        ).toString();
        String expected = "late final String? greeting = helloWorld;\n";
        expect(actual, expected);
      });

      test(
          "Should return: static late final String greeting = 'Hello World';\n",
          () {
        String actual = CodeFormatter().unFormatted(VariableDefinition(
          "greeting",
          static: true,
          modifier: Modifier.lateFinal$,
          type: Type.ofString(),
          value: Expression.ofString('Hello World'),
        ));
        String expected =
            'static late final String greeting = \'Hello World\';';
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          VariableDefinition("InvalidVariableName",
                  modifier: Modifier.lateFinal$,
                  value: Expression.ofString('Hello World'))
              .toString();
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('modifier=const\$', () {
      test("Should return: const greeting = 'Hello World';\n", () {
        String actual = VariableDefinition("greeting",
                modifier: Modifier.const$,
                value: Expression.ofString('Hello World'))
            .toString();
        String expected = "const greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: const String greeting = helloWorld;\n", () {
        String actual = VariableDefinition("greeting",
                modifier: Modifier.const$,
                value: Expression.ofVariable('helloWorld'),
                type: Type.ofString())
            .toString();
        String expected = "const String greeting = helloWorld;\n";
        expect(actual, expected);
      });

      test("Should return: const String? greeting = helloWorld;\n", () {
        String actual = VariableDefinition(
          "greeting",
          modifier: Modifier.const$,
          value: Expression.ofVariable('helloWorld'),
          type: Type.ofString(nullable: true),
        ).toString();
        String expected = "const String? greeting = helloWorld;\n";
        expect(actual, expected);
      });

      test("Should return: static const String greeting = 'Hello World';\n",
          () {
        String actual = CodeFormatter().unFormatted(VariableDefinition(
          "greeting",
          static: true,
          modifier: Modifier.const$,
          type: Type.ofString(),
          value: Expression.ofString('Hello World'),
        ));
        String expected = 'static const String greeting = \'Hello World\';';
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          VariableDefinition("InvalidVariableName",
                  modifier: Modifier.const$,
                  value: Expression.ofString('Hello World'))
              .toString();
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });
  });
}
