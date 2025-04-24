// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

main() {
  group('VariableDefinition class', () {
    group('modifier=var\$', () {
      test("Should return: var greeting;", () {
        VariableDefinition("greeting").toString().should.be("var greeting;");
      });

      test("Should return: var greeting = 'Hello World';", () {
        VariableDefinition("greeting",
                value: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("var greeting = 'Hello World';");
      });

      test("Should return: String greeting = 'Hello World';", () {
        VariableDefinition("greeting",
                value: Expression.ofString('Hello World'),
                type: Type.ofString())
            .toString()
            .should
            .be("String greeting = 'Hello World';");
      });

      test("Should return: String? greeting = 'Hello World';", () {
        VariableDefinition(
          "greeting",
          value: Expression.ofString('Hello World'),
          type: Type.ofString(nullable: true),
        ).toString().should.be("String? greeting = 'Hello World';");
      });

      test("Should return: static String greeting = 'Hello World';", () {
        VariableDefinition(
          "greeting",
          value: Expression.ofString('Hello World'),
          type: Type.ofString(),
          static: true,
        ).toString().should.be('static String greeting = \'Hello World\';');
      });

      test('Should throw name exception', () {
        Should.throwError<ArgumentError>(() {
          VariableDefinition("InvalidVariableName").toString();
        }).message.toString().should.be('Must start with an lower case letter');
      });
    });

    group('modifier=lateVar\$', () {
      test("Should return: late greeting;", () {
        VariableDefinition("greeting", modifier: Modifier.lateVar$)
            .toString()
            .should
            .be("late var greeting;");
      });

      test("Should return: late greeting = 'Hello World';", () {
        VariableDefinition("greeting",
                modifier: Modifier.lateVar$,
                value: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("late var greeting = 'Hello World';");
      });

      test("Should return: late String greeting = 'Hello World';", () {
        VariableDefinition("greeting",
                modifier: Modifier.lateVar$,
                value: Expression.ofVariable('helloWorld'),
                type: Type.ofString())
            .toString()
            .should
            .be("late String greeting = helloWorld;");
      });

      test("Should return: late String? greeting = helloWorld;", () {
        VariableDefinition(
          "greeting",
          modifier: Modifier.lateVar$,
          value: Expression.ofVariable('helloWorld'),
          type: Type.ofString(nullable: true),
        ).toString().should.be("late String? greeting = helloWorld;");
      });

      test("Should return: static late String greeting = 'Hello World';", () {
        VariableDefinition(
          "greeting",
          modifier: Modifier.lateVar$,
          value: Expression.ofString('Hello World'),
          type: Type.ofString(),
          static: true,
        )
            .toString()
            .should
            .be('static late String greeting = \'Hello World\';');
      });

      test('Should throw name exception', () {
        Should.throwError<ArgumentError>(() {
          VariableDefinition("InvalidVariableName", modifier: Modifier.lateVar$)
              .toString();
        }).message.toString().should.be('Must start with an lower case letter');
      });
    });

    group('modifier=final\$', () {
      test("Should return: final greeting = 'Hello World';", () {
        VariableDefinition("greeting",
                modifier: Modifier.final$,
                value: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("final greeting = 'Hello World';");
      });

      test("Should return: final String greeting = 'Hello World';", () {
        VariableDefinition(
          "greeting",
          modifier: Modifier.final$,
          type: Type.ofString(),
          value: Expression.ofVariable('helloWorld'),
        ).toString().should.be("final String greeting = helloWorld;");
      });
      test("Should return: final String? greeting = helloWorld;", () {
        VariableDefinition(
          "greeting",
          modifier: Modifier.final$,
          type: Type.ofString(nullable: true),
          value: Expression.ofVariable('helloWorld'),
        ).toString().should.be("final String? greeting = helloWorld;");
      });

      test("Should return: static final String greeting = 'Hello World';", () {
        VariableDefinition(
          "greeting",
          static: true,
          modifier: Modifier.final$,
          type: Type.ofString(),
          value: Expression.ofString('Hello World'),
        )
            .toString()
            .should
            .be('static final String greeting = \'Hello World\';');
      });

      test('Should throw name exception', () {
        Should.throwError<ArgumentError>(() {
          VariableDefinition("InvalidVariableName",
                  modifier: Modifier.final$,
                  value: Expression.ofString('Hello World'))
              .toString();
        }).message.toString().should.be('Must start with an lower case letter');
      });
    });

    group('modifier=lateFinal\$', () {
      test("Should return: late final greeting = 'Hello World';", () {
        VariableDefinition("greeting",
                modifier: Modifier.lateFinal$,
                value: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("late final greeting = 'Hello World';");
      });

      test("Should return: late final String greeting = helloWorld;", () {
        VariableDefinition(
          "greeting",
          modifier: Modifier.lateFinal$,
          type: Type.ofString(),
          value: Expression.ofVariable('helloWorld'),
        ).toString().should.be("late final String greeting = helloWorld;");
      });

      test("Should return: late final String? greeting = helloWorld;", () {
        VariableDefinition(
          "greeting",
          modifier: Modifier.lateFinal$,
          type: Type.ofString(nullable: true),
          value: Expression.ofVariable('helloWorld'),
        ).toString().should.be("late final String? greeting = helloWorld;");
      });

      test("Should return: static late final String greeting = 'Hello World';",
          () {
        VariableDefinition(
          "greeting",
          static: true,
          modifier: Modifier.lateFinal$,
          type: Type.ofString(),
          value: Expression.ofString('Hello World'),
        )
            .toString()
            .should
            .be('static late final String greeting = \'Hello World\';');
      });

      test('Should throw name exception', () {
        Should.throwError<ArgumentError>(() {
          VariableDefinition("InvalidVariableName",
                  modifier: Modifier.lateFinal$,
                  value: Expression.ofString('Hello World'))
              .toString();
        }).message.toString().should.be('Must start with an lower case letter');
      });
    });

    group('modifier=const\$', () {
      test("Should return: const greeting = 'Hello World';", () {
        VariableDefinition("greeting",
                modifier: Modifier.const$,
                value: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("const greeting = 'Hello World';");
      });

      test("Should return: const String greeting = helloWorld;", () {
        VariableDefinition("greeting",
                modifier: Modifier.const$,
                value: Expression.ofVariable('helloWorld'),
                type: Type.ofString())
            .toString()
            .should
            .be("const String greeting = helloWorld;");
      });

      test("Should return: const String? greeting = helloWorld;", () {
        VariableDefinition(
          "greeting",
          modifier: Modifier.const$,
          value: Expression.ofVariable('helloWorld'),
          type: Type.ofString(nullable: true),
        ).toString().should.be("const String? greeting = helloWorld;");
      });

      test("Should return: static const String greeting = 'Hello World';", () {
        VariableDefinition(
          "greeting",
          static: true,
          modifier: Modifier.const$,
          type: Type.ofString(),
          value: Expression.ofString('Hello World'),
        )
            .toString()
            .should
            .be('static const String greeting = \'Hello World\';');
      });

      test('Should throw name exception', () {
        Should.throwError<ArgumentError>(() {
          VariableDefinition("InvalidVariableName",
                  modifier: Modifier.const$,
                  value: Expression.ofString('Hello World'))
              .toString();
        }).message.toString().should.be('Must start with an lower case letter');
      });
    });
  });
}
