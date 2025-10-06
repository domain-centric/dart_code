// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('Statement class', () {
    group('Statement() constructor', () {
      test("Should return: 'test();\n'", () {
        Statement([Code('test()')]).toString().should.be('test();');
      });
    });

    group('Statement.assert() constructor', () {
      test("Should return: 'assert(b == false);\n'", () {
        Statement.assert$(
          Expression.ofVariable('b').equalTo(Expression.ofBool(false)),
        ).toString().should.be('assert(b == false);');
      });

      test("Should return: 'assert(b == false, 'b must be false');\n'", () {
        Statement.assert$(
          Expression.ofVariable('b').equalTo(Expression.ofBool(false)),
          message: 'b must be false',
        ).toString().should.be('assert(b == false,\'b must be false\');');
      });
    });

    group('Statement.assignVariable() constructor', () {
      test("Should return: greeting = 'Hello World';\n", () {
        Statement.assignVariable(
          "greeting",
          Expression.ofString('Hello World'),
        ).toString().should.be('greeting = \'Hello World\';');
      });

      test("Should return: greeting ??= 'Hello World';\n", () {
        Statement.assignVariable(
          "greeting",
          Expression.ofString('Hello World'),
          nullAware: true,
        ).toString().should.be('greeting ??= \'Hello World\';');
      });

      test("Should return: greeting ??= 'Hello World';\n", () {
        Statement.assignVariable(
          "greeting",
          Expression.ofString('Hello World'),
          nullAware: true,
          this$: true,
        ).toString().should.be('this.greeting ??= \'Hello World\';');
      });

      test('Should throw name exception', () {
        Should.throwError<ArgumentError>(() {
          Statement.assignVariable(
            "InvalidVariableName",
            Expression.ofString('Hello World'),
          );
        }).message.toString().should.be('Must start with an lower case letter');
      });
    });

    group('Statement.break\$ constructor', () {
      test("Should return: 'break;'", () {
        Statement.break$().toString().should.be('break;');
      });
    });

    group('Statement.continue\$ constructor', () {
      test("Should return: 'continue;'", () {
        Statement.continue$().toString().should.be('continue;');
      });
    });

    group('Statement.for\$ constructor', () {
      test("Should return: for loop statements'", () {
        Statement.for$(
          VariableDefinition(
            'i',
            type: Type.ofInt(),
            value: Expression.ofInt(10),
          ),
          Expression.ofVariable('i').greaterOrEqualTo(Expression.ofInt(0)),
          Expression.ofVariable('i').increment(),
          Block([Statement.print(Expression.ofVariable('i'))]),
        ).toString().should.be('for (int i = 10; i >= 0; i++) {print(i);};');
      });
    });

    group('Statement.forEach\$ constructor', () {
      test("Should return: for loop statements'", () {
        Statement.forEach$(
          VariableDefinition('color', type: Type('Color')),
          Expression.ofVariable('colors'),
          Block([Statement.print(Expression.ofVariable('color'))]),
        ).toString().should.be('for (Color color in colors) {print(color);};');
      });
    });

    group('Statement.if\$() constructor', () {
      test("Should return if statement without else statement", () {
        Statement.if$(
          Expression.ofBool(true),
          Block([Statement.print(Expression.ofString('True'))]),
        ).toString().should.be('if (true){print(\'True\');}');
      });

      test("Should return if statement with else statement", () {
        Statement.if$(
          Expression.ofBool(true),
          Block([Statement.print(Expression.ofString('True'))]),
          elseBlock: Block([Statement.print(Expression.ofString('False'))]),
        ).toString().should.be(
          'if (true){print(\'True\');} else {print(\'False\');}',
        );
      });
    });

    group('Statement.ifChain\$() constructor', () {
      final number = 'number';

      test("Should return if chain statement without else statement", () {
        Statement.ifChain$({
          Expression.ofVariable(number).equalTo(Expression.ofInt(1)): Block([
            Statement.print(Expression.ofString('One')),
          ]),
          Expression.ofVariable(number).equalTo(Expression.ofInt(2)): Block([
            Statement.print(Expression.ofString('Two')),
          ]),
        }).toString().should.be(
          'if (number == 1) {print(\'One\');} else if (number == 2) {print(\'Two\');};',
        );
      });

      test("Should return if chain statement with else statement", () {
        Statement.ifChain$(
          {
            Expression.ofVariable(number).equalTo(Expression.ofInt(1)): Block([
              Statement.print(Expression.ofString('One')),
            ]),
            Expression.ofVariable(number).equalTo(Expression.ofInt(2)): Block([
              Statement.print(Expression.ofString('Two')),
            ]),
          },
          elseBlock: Block([Statement.print(Expression.ofString('Other'))]),
        ).toString().should.be(
          'if (number == 1) {print(\'One\');} else if (number == 2) {print(\'Two\');} else {print(\'Other\');};',
        );
      });
    });
  });

  group('Statement.print() constructor', () {
    test("Should return print statement", () {
      Statement.print(
        Expression.ofString('Hello World'),
      ).toString().should.be('print(\'Hello World\');');
    });
  });

  group('Statement.library() constructor', () {
    test("Should return: greeting = 'library contacts;\n'", () {
      Statement.library("contacts").toString().should.be('library contacts;');
    });

    test(
      "Should throw name exception: 'Must start with an lower case letter'",
      () {
        Should.throwError<ArgumentError>(() {
          Statement.library('InvalidCase');
        }).message.toString().should.be('Must start with an lower case letter');
      },
    );
  });

  group('Statement.return\$ constructor', () {
    test("Should return: 'test();\n'", () {
      Statement.return$(
        Expression.ofString('Hello World'),
      ).toString().should.be('return \'Hello World\';');
    });
  });

  group('Statement.return\$ constructor', () {
    test("Should return: 'rethrow;\n'", () {
      Statement.rethrow$().toString().should.be('rethrow;');
    });
  });

  group('Statement.throw\$() constructor', () {
    test("Should return: throw 'Out of camels!';\n", () {
      Statement.throw$(
        Expression.ofString('Out of camels!'),
      ).toString().should.be('throw \'Out of camels!\';');
    });

    test("Should return: throw OutOfCamelException();\n", () {
      Statement.throw$(
        Expression.callConstructor(Type('OutOfCamelException')),
      ).toString().should.be('throw OutOfCamelException();');
    });
  });

  group('Statement.try\$() constructor', () {
    test("Should return: try statement", () {
      Statement.try$(
        Block([Statement.print(Expression.ofString('Something to try'))]),
      ).toString().should.be('try {print(\'Something to try\');};');
    });

    test("Should return: try statement with on cause", () {
      Statement.try$(
        Block([
          Statement.ofExpression(
            Expression.callMethodOrFunction('breedMoreCamels'),
          ),
        ]),
        catches: [
          Catch.onException(
            Type('OutOfCamelsException'),
            Block([
              Statement.ofExpression(
                Expression.callMethodOrFunction('buyMoreCamels'),
              ),
            ]),
          ),
        ],
      ).toString().should.be(
        'try {breedMoreCamels();} on OutOfCamelsException {buyMoreCamels();};',
      );
    });

    test("Should return: try statement with multiple on causes", () {
      Statement.try$(
        Block([
          Statement.ofExpression(
            Expression.callMethodOrFunction('breedMoreCamels'),
          ),
        ]),
        catches: [
          Catch.onException(
            Type('OutOfCamelsException'),
            Block([
              Statement.ofExpression(
                Expression.callMethodOrFunction('buyMoreCamels'),
              ),
            ]),
          ),
          Catch.onException(
            Type('Exception'),
            Block([
              Statement.print(Expression.ofString('Unknown exception: \$e')),
            ]),
            exceptionVariableName: 'e',
          ),
          Catch(
            Block([
              Statement.print(
                Expression.ofString('Something really unknown: \$e, \$s'),
              ),
            ]),
            "e",
            "s",
          ),
        ],
      ).toString().should.be(
        'try {breedMoreCamels();} on OutOfCamelsException {buyMoreCamels();} on Exception catch(e) {print(\'Unknown exception: \$e\');} catch(e, s) {print(\'Something really unknown: \$e, \$s\');};',
      );
    });

    test("Should return: try statement with finally", () {
      Statement.try$(
        Block([
          Statement.ofExpression(
            Expression.callMethodOrFunction('breedMoreCamels'),
          ),
        ]),
        finallyBlock: Block([
          Statement.ofExpression(
            Expression.callMethodOrFunction('cleanCamelStalls'),
          ),
        ]),
      ).toString().should.be(
        'try {breedMoreCamels();} finally {cleanCamelStalls();};',
      );
    });
  });

  group('Statement.switch\$() constructor', () {
    final number = 'number';

    test("Should return: switch statement without else statement", () {
      Statement.switch$(Expression.ofVariable(number), {
        Expression.ofInt(1): Block([
          Statement.print(Expression.ofString('One')),
          Statement.break$(),
        ]),
        Expression.ofInt(2): Block([
          Statement.print(Expression.ofString('Two')),
          Statement.break$(),
        ]),
      }).toString().should.be(
        'switch (number) {case 1: {print(\'One\');break;}case 2: {print(\'Two\');break;}};',
      );
    });

    test("Should return: switch statement with else statement", () {
      Statement.switch$(
        Expression.ofVariable(number),
        {
          Expression.ofInt(1): Block([
            Statement.print(Expression.ofString('One')),
            Statement.break$(),
          ]),
          Expression.ofInt(2): Block([
            Statement.print(Expression.ofString('Two')),
            Statement.break$(),
          ]),
        },
        defaultBlock: Block([Statement.print(Expression.ofString('Other'))]),
      ).toString().should.be(
        'switch (number) {case 1: {print(\'One\');break;}case 2: {print(\'Two\');break;}default: {print(\'Other\');}};',
      );
    });
  });

  group('Statement.while\$ constructor', () {
    test("Should return while loop statement ", () {
      final counter = 'counter';
      Statement.while$(
        Expression.ofVariable(counter).lessThan(Expression.ofInt(5)),
        Block([
          Statement.print(Expression.ofVariable(counter)),
          Expression.ofVariable(counter).increment(),
        ]),
      ).toString().should.be('while (counter < 5) {print(counter);counter++};');
    });
  });

  group('Statement.doWhile\$ constructor', () {
    test("Should return while loop statement ", () {
      final counter = 'counter';
      Statement.doWhile$(
        Block([
          Statement.print(Expression.ofVariable(counter)),
          Expression.ofVariable(counter).increment(),
        ]),
        Expression.ofVariable(counter).lessThan(Expression.ofInt(5)),
      ).toString().should.be(
        'do {print(counter);counter++} while (counter < 5);',
      );
    });
  });

  group('Statements class', () {
    test('Given Statements => Returns the correct code', () {
      Statements([
        Statement([Code('test1()')]),
        Statement([Code('test2()')]),
      ]).toString().should.be('test1();test2();');
    });
  });
}
