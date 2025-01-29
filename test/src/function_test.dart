/*
 * Copyright (c) 2022. By Nils ten Hoeve. See LICENSE file in project.
 */

import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

main() {
  group('Function.withoutName', () {
    test('Returns a anonymous function that returns a boolean of value true',
        () {
      String actual = DartFunction.withoutName(Expression.ofBool(true),
              returnType: Type.ofBool())
          .toString();
      String expected = 'bool() => true;\n';
      expect(actual, expected);
    });

    test(
        'Returns a anonymous function that returns a async boolean of value true',
        () {
      String actual = DartFunction.withoutName(
              Expression.callMethodOrFunction('booleanGenerator'),
              returnType: Type.ofFuture(Type.ofBool()),
              asynchrony: Asynchrony.async)
          .toString();
      String expected = 'Future<bool>() async => booleanGenerator();\n';
      expect(actual, expected);
    });

    test(
        'Returns a anonymous function that returns a boolean of value true, with DocComments and Annotations',
        () {
      String actual = DartFunction.withoutName(Expression.ofBool(true),
          returnType: Type.ofBool(),
          docComments: [
            DocComment.fromString("This function returns: true")
          ],
          annotations: [
            Annotation(
                Type('Visible'),
                ParameterValues([
                  ParameterValue.named('forRole', Expression.ofString('admin'))
                ])),
            Annotation(
                Type('ExecutionMode'),
                ParameterValues([
                  ParameterValue(
                      Expression.ofEnum(Type('ExecutionModes'), 'directly'))
                ]))
          ]).toString();
      String expected = '/// This function returns: true\n'
          '@Visible(forRole: \'admin\')\n'
          '@ExecutionMode(ExecutionModes.directly)\n'
          'bool() => true;\n';
      expect(actual, expected);
    });
  });

  group('Function.withName', () {
    test('Returns a named function that returns a boolean of value true', () {
      var actual = DartFunction.withName('returnBool', Expression.ofBool(true),
              returnType: Type.ofBool())
          .toString();
      var expected = 'bool returnBool() => true;\n';
      expect(actual, expected);
    });

    test('Returns a named function that returns a async boolean of value true',
        () {
      String actual = DartFunction.withName(
              'returnBool', Expression.callMethodOrFunction('booleanGenerator'),
              returnType: Type.ofFuture(Type.ofBool()),
              asynchrony: Asynchrony.async)
          .toString();
      String expected =
          'Future<bool> returnBool() async => booleanGenerator();\n';
      expect(actual, expected);
    });

    test(
        'Returns a named function that returns a boolean of value true, with DocComments and Annotations',
        () {
      String actual = DartFunction.withName(
          'returnTrue', Expression.ofBool(true),
          returnType: Type.ofBool(),
          docComments: [
            DocComment.fromString("This function returns: true")
          ],
          annotations: [
            Annotation(
                Type('Visible'),
                ParameterValues([
                  ParameterValue.named('forRole', Expression.ofString('admin'))
                ])),
            Annotation(
                Type('ExecutionMode'),
                ParameterValues([
                  ParameterValue(
                      Expression.ofEnum(Type('ExecutionModes'), 'directly'))
                ]))
          ]).toString();
      String expected = '/// This function returns: true\n'
          '@Visible(forRole: \'admin\')\n'
          '@ExecutionMode(ExecutionModes.directly)\n'
          'bool returnTrue() => true;\n';
      expect(actual, expected);
    });
  });

  group('Function.main', () {
    test('Returns main function that prints hello world', () {
      var actual = DartFunction.main(Code("print('Hello World.');")).toString();
      var expected = 'main() {\n'
          '  print(\'Hello World.\');\n'
          '}\n';
      expect(actual, expected);
    });

    test('Returns a main function that returns a async boolean of value true',
        () {
      String actual = DartFunction.main(
              Expression.callMethodOrFunction('booleanGenerator'),
              asynchrony: Asynchrony.async)
          .toString();
      String expected = 'main() async => booleanGenerator();\n';
      expect(actual, expected);
    });
  });

  group('FunctionCall class', () {
    test('Should return a call to a function or method', () {
      CodeFormatter()
          .unFormatted(FunctionCall('myFunction'))
          .should
          .be("myFunction()");
    });

    test('Should return a call to a function or method with generic type', () {
      CodeFormatter()
          .unFormatted(FunctionCall('cast', genericType: Type.ofInt()))
          .should
          .be("cast<int>()");
    });

    test('Should return a call to a function or method with parameters', () {
      CodeFormatter()
          .unFormatted(FunctionCall('add',
              parameterValues: ParameterValues([
                ParameterValue(Expression.ofInt(2)),
                ParameterValue(Expression.ofInt(3))
              ])))
          .should
          .be('add(2,3)');
    });

    test(
        'Should return a call to a function with parameters from another library',
        () {
      CodeFormatter()
          .unFormatted(FunctionCall('add',
              libraryUri: "package:test/calculations.dart",
              parameterValues: ParameterValues([
                ParameterValue(Expression.ofInt(2)),
                ParameterValue(Expression.ofInt(3))
              ])))
          .should
          .be('i1.add(2,3)');
    });

    test('Should throw an exception invalid name ', () {
      expect(() {
        FunctionCall('InvalidFunctionName');
      },
          throwsA((e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter'));
    });
  });
}
