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

    group('Statement.assert() constructor', () {
      test("Should return: 'assert(b == false);\n'", () {
        String actual = Statement.assert$(
                Expression.ofVariable('b').equalTo(Expression.ofBool(false)))
            .toString();
        String expected = "assert(b == false);\n";
        expect(actual, expected);
      });

      test("Should return: 'assert(b == false, 'b must be false');\n'", () {
        String actual = Statement.assert$(
                Expression.ofVariable('b').equalTo(Expression.ofBool(false)),
                message: 'b must be false')
            .toString();
        String expected = "assert(b == false, 'b must be false');\n";
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

    group('Statement.break\$ constructor', () {
      test("Should return: 'break;'", () {
        String actual = Statement.break$().toString();
        String expected = 'break;\n';
        expect(actual, expected);
      });
    });

    group('Statement.continue\$ constructor', () {
      test("Should return: 'break;'", () {
        String actual = Statement.continue$().toString();
        String expected = 'continue;\n';
        expect(actual, expected);
      });
    });

    group('Statement.for\$ constructor', () {
      test("Should return: for loop statements'", () {
        String actual = Statement.for$(
            VariableDefinition.var$('i',
                type: Type.ofInt(), value: Expression.ofInt(10)),
            Expression.ofVariable('i').greaterOrEqualTo(Expression.ofInt(0)),
            Expression.ofVariable('i').increment(),
            Block([Statement.print(Expression.ofVariable('i'))])).toString();
        String expected = 'for ( int i = 10; i >= 0; i++) {\n'
            '  print(i);\n'
            '};\n';
        expect(actual, expected);
      });
    });

    group('Statement.forEach\$ constructor', () {
      test("Should return: for loop statements'", () {
        String actual = Statement.forEach$(
                VariableDefinition.var$('color', type: Type('Color')),
                Expression.ofVariable('colors'),
                Block([Statement.print(Expression.ofVariable('color'))]))
            .toString();
        String expected = 'for ( Color color in colors) {\n'
            '  print(color);\n'
            '};\n';
        expect(actual, expected);
      });
    });

    group('Statement.if\$() constructor', () {
      test("Should return if statement without else statement", () {
        String actual = Statement.if$(Expression.ofBool(true),
            Block([Statement.print(Expression.ofString('True'))])).toString();
        String expected = 'if (true){\n'
            '  print(\'True\');\n'
            '};\n';
        expect(actual, expected);
      });

      test("Should return if statement with else statement", () {
        String actual = Statement.if$(Expression.ofBool(true),
                Block([Statement.print(Expression.ofString('True'))]),
                elseBlock:
                    Block([Statement.print(Expression.ofString('False'))]))
            .toString();
        String expected = 'if (true){\n'
            '  print(\'True\');\n'
            '} else {\n'
            '  print(\'False\');\n'
            '};\n';
        expect(actual, expected);
      });
    });

    group('Statement.ifChain\$() constructor', () {
      final number = 'number';

      test("Should return if chain statement without else statement", () {
        String actual = Statement.ifChain$({
          Expression.ofVariable(number).equalTo(Expression.ofInt(1)):
              Block([Statement.print(Expression.ofString('One'))]),
          Expression.ofVariable(number).equalTo(Expression.ofInt(2)):
              Block([Statement.print(Expression.ofString('Two'))])
        }).toString();
        String expected = 'if (number == 1) {\n'
            '  print(\'One\');\n'
            '} else if (number == 2) {\n'
            '  print(\'Two\');\n'
            '};\n';
        expect(actual, expected);
      });

      test("Should return if chain statement with else statement", () {
        String actual = Statement.ifChain$({
          Expression.ofVariable(number).equalTo(Expression.ofInt(1)):
              Block([Statement.print(Expression.ofString('One'))]),
          Expression.ofVariable(number).equalTo(Expression.ofInt(2)):
              Block([Statement.print(Expression.ofString('Two'))])
        }, elseBlock: Block([Statement.print(Expression.ofString('Other'))]))
            .toString();
        String expected = 'if (number == 1) {\n'
            '  print(\'One\');\n'
            '} else if (number == 2) {\n'
            '  print(\'Two\');\n'
            '} else {\n'
            '  print(\'Other\');\n'
            '};\n';
        expect(actual, expected);
      });
    });

    group('Statement.print() constructor', () {
      test("Should return print statement", () {
        String actual =
            Statement.print(Expression.ofString('Hello World')).toString();
        String expected = "print('Hello World');\n";
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

    group('Statement.switch\$() constructor', () {
      final number = 'number';

      test("Should return: switch statement without else statement", () {
        String actual = Statement.switch$(Expression.ofVariable(number), {
          Expression.ofInt(1): Block([
            Statement.print(Expression.ofString('One')),
            Statement.break$(),
          ]),
          Expression.ofInt(2): Block([
            Statement.print(Expression.ofString('Two')),
            Statement.break$(),
          ])
        }).toString();
        String expected = 'switch (number) {\n'
            '  case 1: {\n'
            '    print(\'One\');\n'
            '    break;\n'
            '  }\n'
            '  case 2: {\n'
            '    print(\'Two\');\n'
            '    break;\n'
            '  }\n'
            '};\n';
        expect(actual, expected);
      });

      test("Should return: switch statement with else statement", () {
        String actual = Statement.switch$(
                Expression.ofVariable(number),
                {
                  Expression.ofInt(1): Block([
                    Statement.print(Expression.ofString('One')),
                    Statement.break$(),
                  ]),
                  Expression.ofInt(2): Block([
                    Statement.print(Expression.ofString('Two')),
                    Statement.break$(),
                  ])
                },
                defaultBlock:
                    Block([Statement.print(Expression.ofString('Other'))]))
            .toString();
        String expected = 'switch (number) {\n'
            '  case 1: {\n'
            '    print(\'One\');\n'
            '    break;\n'
            '  }\n'
            '  case 2: {\n'
            '    print(\'Two\');\n'
            '    break;\n'
            '  }\n'
            '  default: {\n'
            '    print(\'Other\');\n'
            '  }\n'
            '};\n';
        expect(actual, expected);
      });
    });

    group('Statement.while\$ constructor', () {
      test("Should return while loop statement ", () {
        final counter = 'counter';
        String actual = Statement.while$(
            Expression.ofVariable(counter).lessThan(Expression.ofInt(5)),
            Block([
              Statement.print(Expression.ofVariable(counter)),
              Expression.ofVariable(counter).increment(),
            ])).toString();
        String expected = 'while (counter < 5) {\n'
            '  print(counter);\n'
            '  counter++\n'
            '};\n';
        expect(actual, expected);
      });
    });

    group('Statement.doWhile\$ constructor', () {
      test("Should return while loop statement ", () {
        final counter = 'counter';
        String actual = Statement.doWhile$(
          Block([
            Statement.print(Expression.ofVariable(counter)),
            Expression.ofVariable(counter).increment(),
          ]),
          Expression.ofVariable(counter).lessThan(Expression.ofInt(5)),
        ).toString();
        String expected = 'do {\n'
            '  print(counter);\n'
            '  counter++\n'
            '} while (counter < 5);\n';
        expect(actual, expected);
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
