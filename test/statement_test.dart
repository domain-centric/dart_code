import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Statement class', () {
    group('Statement() constructor', () {
      test("Should return: 'test();\n'", () {
        String actual =
            CodeFormatter().unFormatted(Statement([Code('test()')]));
        String expected = 'test();';
        expect(actual, expected);
      });
    });

    group('Statement.assert() constructor', () {
      test("Should return: 'assert(b == false);\n'", () {
        String actual = CodeFormatter().unFormatted(Statement.assert$(
            Expression.ofVariable('b').equalTo(Expression.ofBool(false))));
        String expected = 'assert(b == false);';
        expect(actual, expected);
      });

      test("Should return: 'assert(b == false, 'b must be false');\n'", () {
        String actual = CodeFormatter().unFormatted(Statement.assert$(
            Expression.ofVariable('b').equalTo(Expression.ofBool(false)),
            message: 'b must be false'));
        String expected = 'assert(b == false,\'b must be false\');';
        expect(actual, expected);
      });
    });

    group('Statement.assignVariable() constructor', () {
      test("Should return: greeting = 'Hello World';\n", () {
        String actual = CodeFormatter().unFormatted(Statement.assignVariable(
            "greeting", Expression.ofString('Hello World')));
        String expected = 'greeting = \'Hello World\';';
        expect(actual, expected);
      });

      test("Should return: greeting ??= 'Hello World';\n", () {
        String actual = CodeFormatter().unFormatted(Statement.assignVariable(
            "greeting", Expression.ofString('Hello World'),
            nullAware: true));
        String expected = 'greeting ??= \'Hello World\';';
        expect(actual, expected);
      });

      test("Should return: greeting ??= 'Hello World';\n", () {
        String actual = CodeFormatter().unFormatted(Statement.assignVariable(
            "greeting", Expression.ofString('Hello World'),
            nullAware: true, this$: true));
        String expected = 'this.greeting ??= \'Hello World\';';
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          Statement.assignVariable(
              "InvalidVariableName", Expression.ofString('Hello World'));
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('Statement.break\$ constructor', () {
      test("Should return: 'break;'", () {
        String actual = CodeFormatter().unFormatted(Statement.break$());
        String expected = 'break;';
        expect(actual, expected);
      });
    });

    group('Statement.continue\$ constructor', () {
      test("Should return: 'continue;'", () {
        String actual = CodeFormatter().unFormatted(Statement.continue$());
        String expected = 'continue;';
        expect(actual, expected);
      });
    });

    group('Statement.for\$ constructor', () {
      test("Should return: for loop statements'", () {
        String actual = CodeFormatter().unFormatted(Statement.for$(
            VariableDefinition.var$('i',
                type: Type.ofInt(), value: Expression.ofInt(10)),
            Expression.ofVariable('i').greaterOrEqualTo(Expression.ofInt(0)),
            Expression.ofVariable('i').increment(),
            Block([Statement.print(Expression.ofVariable('i'))])));
        String expected = 'for (  int i = 10; i >= 0; i++) {print(i);};';
        expect(actual, expected);
      });
    });

    group('Statement.forEach\$ constructor', () {
      test("Should return: for loop statements'", () {
        String actual = CodeFormatter().unFormatted(Statement.forEach$(
            VariableDefinition.var$('color', type: Type('Color')),
            Expression.ofVariable('colors'),
            Block([Statement.print(Expression.ofVariable('color'))])));
        String expected = 'for (  Color color in colors) {print(color);};';
        expect(actual, expected);
      });
    });

    group('Statement.if\$() constructor', () {
      test("Should return if statement without else statement", () {
        String actual = CodeFormatter().unFormatted(Statement.if$(
            Expression.ofBool(true),
            Block([Statement.print(Expression.ofString('True'))])));
        String expected = 'if (true){print(\'True\');}';
        expect(actual, expected);
      });

      test("Should return if statement with else statement", () {
        String actual = CodeFormatter().unFormatted(Statement.if$(
            Expression.ofBool(true),
            Block([Statement.print(Expression.ofString('True'))]),
            elseBlock: Block([Statement.print(Expression.ofString('False'))])));
        String expected =
            'if (true){print(\'True\');} else {print(\'False\');}';
        expect(actual, expected);
      });
    });

    group('Statement.ifChain\$() constructor', () {
      final number = 'number';

      test("Should return if chain statement without else statement", () {
        String actual = CodeFormatter().unFormatted(Statement.ifChain$({
          Expression.ofVariable(number).equalTo(Expression.ofInt(1)):
              Block([Statement.print(Expression.ofString('One'))]),
          Expression.ofVariable(number).equalTo(Expression.ofInt(2)):
              Block([Statement.print(Expression.ofString('Two'))])
        }));
        String expected =
            'if (number == 1) {print(\'One\');} else if (number == 2) {print(\'Two\');};';
        expect(actual, expected);
      });

      test("Should return if chain statement with else statement", () {
        String actual = CodeFormatter().unFormatted(Statement.ifChain$({
          Expression.ofVariable(number).equalTo(Expression.ofInt(1)):
              Block([Statement.print(Expression.ofString('One'))]),
          Expression.ofVariable(number).equalTo(Expression.ofInt(2)):
              Block([Statement.print(Expression.ofString('Two'))])
        }, elseBlock: Block([Statement.print(Expression.ofString('Other'))])));
        String expected =
            'if (number == 1) {print(\'One\');} else if (number == 2) {print(\'Two\');} else {print(\'Other\');};';
        expect(actual, expected);
      });
    });

    group('Statement.print() constructor', () {
      test("Should return print statement", () {
        String actual = CodeFormatter()
            .unFormatted(Statement.print(Expression.ofString('Hello World')));
        String expected = 'print(\'Hello World\');';
        expect(actual, expected);
      });
    });

    group('Statement.library() constructor', () {
      test("Should return: greeting = 'library contacts;\n'", () {
        String actual =
            CodeFormatter().unFormatted(Statement.library("contacts"));
        String expected = 'library contacts;';
        expect(actual, expected);
      });

      test("Should throw name exception: 'Must not be null'", () {
        expect(() {
          Statement.library(null);
        },
            throwsA(
                (e) => e is ArgumentError && e.message == 'Must not be null'));
      });

      test(
          "Should throw name exception: 'Must start with an lower case letter'",
          () {
        expect(() {
          Statement.library('InvalidCase');
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('Statement.return\$ constructor', () {
      test("Should return: 'test();\n'", () {
        String actual = CodeFormatter()
            .unFormatted(Statement.return$(Expression.ofString('Hello World')));
        String expected = 'return \'Hello World\';';
        expect(actual, expected);
      });
    });

    group('Statement.return\$ constructor', () {
      test("Should return: 'rethrow;\n'", () {
        String actual = CodeFormatter().unFormatted(Statement.rethrow$());
        String expected = 'rethrow;';
        expect(actual, expected);
      });
    });

    group('Statement.throw\$() constructor', () {
      test("Should return: throw 'Out of camels!';\n", () {
        String actual = CodeFormatter().unFormatted(
            Statement.throw$(Expression.ofString('Out of camels!')));
        String expected = 'throw \'Out of camels!\';';
        expect(actual, expected);
      });

      test("Should return: throw OutOfCamelException();\n", () {
        String actual = CodeFormatter().unFormatted(Statement.throw$(
            Expression.callConstructor(Type('OutOfCamelException'))));
        String expected = 'throw OutOfCamelException();';
        expect(actual, expected);
      });
    });

    group('Statement.try\$() constructor', () {
      test("Should return: try statement", () {
        String actual = CodeFormatter().unFormatted(Statement.try$(
            Block([Statement.print(Expression.ofString('Something to try'))])));
        String expected = 'try {print(\'Something to try\');};';
        expect(actual, expected);
      });

      test("Should return: try statement with on cause", () {
        String actual = CodeFormatter().unFormatted(Statement.try$(
            Block([
              Statement.ofExpression(Expression.callFunction('breedMoreCamels'))
            ]),
            catches: [
              Catch.onException(
                  Type('OutOfCamelsException'),
                  Block([
                    Statement.ofExpression(
                        Expression.callFunction('buyMoreCamels'))
                  ]))
            ]));
        String expected =
            'try {breedMoreCamels();} on OutOfCamelsException {buyMoreCamels();};';
        expect(actual, expected);
      });

      test("Should return: try statement with multiple on causes", () {
        String actual = CodeFormatter().unFormatted(Statement.try$(
            Block([
              Statement.ofExpression(Expression.callFunction('breedMoreCamels'))
            ]),
            catches: [
              Catch.onException(
                  Type('OutOfCamelsException'),
                  Block([
                    Statement.ofExpression(
                        Expression.callFunction('buyMoreCamels'))
                  ])),
              Catch.onException(
                  Type('Exception'),
                  Block([
                    Statement.print(
                        Expression.ofString('Unknown exception: \$e'))
                  ]),
                  exceptionVariableName: 'e'),
              Catch(
                  Block([
                    Statement.print(Expression.ofString(
                        'Something really unknown: \$e, \$s'))
                  ]),
                  "e",
                  "s"),
            ]));
        String expected =
            'try {breedMoreCamels();} on OutOfCamelsException {buyMoreCamels();} on Exception catch(e) {print(\'Unknown exception: \$e\');} catch(e, s) {print(\'Something really unknown: \$e, \$s\');};';
        expect(actual, expected);
      });

      test("Should return: try statement with finally", () {
        String actual = CodeFormatter().unFormatted(Statement.try$(
            Block([
              Statement.ofExpression(Expression.callFunction('breedMoreCamels'))
            ]),
            finallyBlock: Block([
              Statement.ofExpression(
                  Expression.callFunction('cleanCamelStalls'))
            ])));
        String expected =
            'try {breedMoreCamels();} finally {cleanCamelStalls();};';
        expect(actual, expected);
      });
    });

    group('Statement.switch\$() constructor', () {
      final number = 'number';

      test("Should return: switch statement without else statement", () {
        String actual = CodeFormatter()
            .unFormatted(Statement.switch$(Expression.ofVariable(number), {
          Expression.ofInt(1): Block([
            Statement.print(Expression.ofString('One')),
            Statement.break$(),
          ]),
          Expression.ofInt(2): Block([
            Statement.print(Expression.ofString('Two')),
            Statement.break$(),
          ])
        }));
        String expected =
            'switch (number) {case 1: {print(\'One\');break;}case 2: {print(\'Two\');break;}};';
        expect(actual, expected);
      });

      test("Should return: switch statement with else statement", () {
        String actual = CodeFormatter().unFormatted(Statement.switch$(
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
                Block([Statement.print(Expression.ofString('Other'))])));
        String expected =
            'switch (number) {case 1: {print(\'One\');break;}case 2: {print(\'Two\');break;}default: {print(\'Other\');}};';
        expect(actual, expected);
      });
    });

    group('Statement.while\$ constructor', () {
      test("Should return while loop statement ", () {
        final counter = 'counter';
        String actual = CodeFormatter().unFormatted(Statement.while$(
            Expression.ofVariable(counter).lessThan(Expression.ofInt(5)),
            Block([
              Statement.print(Expression.ofVariable(counter)),
              Expression.ofVariable(counter).increment(),
            ])));
        String expected = 'while (counter < 5) {print(counter);counter++};';
        expect(actual, expected);
      });
    });

    group('Statement.doWhile\$ constructor', () {
      test("Should return while loop statement ", () {
        final counter = 'counter';
        String actual = CodeFormatter().unFormatted(Statement.doWhile$(
          Block([
            Statement.print(Expression.ofVariable(counter)),
            Expression.ofVariable(counter).increment(),
          ]),
          Expression.ofVariable(counter).lessThan(Expression.ofInt(5)),
        ));
        String expected = 'do {print(counter);counter++} while (counter < 5);';
        expect(actual, expected);
      });
    });
  });

  group('Statements class', () {
    test('Given Statements => Returns the correct code', () {
      String actual = CodeFormatter().unFormatted(Statements([
        Statement([Code('test1()')]),
        Statement([Code('test2()')])
      ]));
      String expected = 'test1();test2();';
      expect(actual, expected);
    });
  });
}
