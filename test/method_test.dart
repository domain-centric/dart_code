import 'package:dart_code/annotation.dart';
import 'package:dart_code/basic.dart';
import 'package:dart_code/comment.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/method.dart';
import 'package:dart_code/parameter.dart';
import 'package:dart_code/statement.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Method() constructor', () {
    test("Should return: asynch method", () {
      String actual = Method(
        'randomNumber',
        Statement.return$(Expression.callFunction("randomIntGenerator")),
        asynchrony: Asynchrony.async,
        type: Type.ofFuture(Type.ofInt()),
      ).toString();
      String expected = 'Future<int> randomNumber() async {\n'
          '  return randomIntGenerator();\n'
          '}\n';
      expect(actual, expected);
    });

    test('Should return: code of a method that returns a greeting string',
            () {
          String actual = Method('greetingMessage',
              Statement.return$(Expression.ofString('Hello \$name.')),
              parameters: Parameters(
                  [Parameter.required('name', type: Type.ofString())]),
              type: Type.ofString())
              .toString();
          String expected = 'String greetingMessage(String name) {\n'
              '  return \'Hello \$name.\';\n'
              '}\n';
          expect(actual, expected);
        });

    test(
        'Should return: code of a method that returns a greeting string, with DocComments and Annotations',
            () {
          String actual = Method('greetingMessage',
              Statement.return$(Expression.ofString('Hello \$name.')),
              parameters:
              Parameters([Parameter.required('name', type: Type.ofString())]),
              type: Type.ofString(),
              docComments: [
                DocComment.fromString("This method returns a greeting string")
              ],
              annotations: [
                Annotation(
                    Type('Visible'),
                    ParameterValues([
                      ParameterValue.named(
                          'forRole', Expression.ofString('admin'))
                    ])),
                Annotation(
                    Type('ExecutionMode'),
                    ParameterValues([
                      ParameterValue(
                          Expression.ofEnum(Type('ExecutionModes'), 'directly'))
                    ]))
              ]).toString();
          String expected = '/// This method returns a greeting string\n'
              '@Visible(forRole: \'admin\')\n'
              '@ExecutionMode(ExecutionModes.directly)\n'
              'String greetingMessage(String name) {\n'
              '  return \'Hello \$name.\';\n'
              '}\n';
          expect(actual, expected);
        });
  });

  group('Method.static() constructor', () {
    test(
        'Should return: code of a static method that returns a greeting string',
            () {
          String actual = Method.static('greetingMessage',
              Statement.return$(Expression.ofString('Hello \$name.')),
              parameters: Parameters(
                  [Parameter.required('name', type: Type.ofString())]),
              type: Type.ofString())
              .toString();
          String expected ='static String greetingMessage(String name) {\n'
              '  return \'Hello \$name.\';\n'
              '}\n';
          expect(actual, expected);
        });

    test(
        'Should return: code of a static method that returns a greeting string, with DocComments and Annotations',
            () {
          String actual = Method.static('greetingMessage',
              Statement.return$(Expression.ofString('Hello \$name.')),
              parameters:
              Parameters([Parameter.required('name', type: Type.ofString())]),
              type: Type.ofString(),
              docComments: [
                DocComment.fromString("This method returns a greeting string")
              ],
              annotations: [
                Annotation(
                    Type('Visible'),
                    ParameterValues([
                      ParameterValue.named(
                          'forRole', Expression.ofString('admin'))
                    ])),
                Annotation(
                    Type('ExecutionMode'),
                    ParameterValues([
                      ParameterValue(
                          Expression.ofEnum(Type('ExecutionModes'), 'directly'))
                    ]))
              ]).toString();
          String expected = '/// This method returns a greeting string\n'
              '@Visible(forRole: \'admin\')\n'
              '@ExecutionMode(ExecutionModes.directly)\n'
              'static String greetingMessage(String name) {\n'
              '  return \'Hello \$name.\';\n'
              '}\n';
          expect(actual, expected);
        });
  });

  group('Method.abstract() constructor', () {
    test(
        'Should return: code of a abstract method that returns a greeting string',
            () {
          String actual = Method.abstract('greetingMessage',
              parameters: Parameters(
                  [Parameter.required('name', type: Type.ofString())]),
              type: Type.ofString())
              .toString();
          String expected = 'abstract String greetingMessage(String name);\n';
          expect(actual, expected);
        });

    test(
        'Should return: code of a abstract method that returns a greeting string, with DocComments and Annotations',
            () {
          String actual = Method.abstract('greetingMessage',
              parameters:
              Parameters([Parameter.required('name', type: Type.ofString())]),
              type: Type.ofString(),
              docComments: [
                DocComment.fromString("This method returns a greeting string")
              ],
              annotations: [
                Annotation(
                    Type('Visible'),
                    ParameterValues([
                      ParameterValue.named(
                          'forRole', Expression.ofString('admin'))
                    ])),
                Annotation(
                    Type('ExecutionMode'),
                    ParameterValues([
                      ParameterValue(
                          Expression.ofEnum(Type('ExecutionModes'), 'directly'))
                    ]))
              ]).toString();
          String expected = '/// This method returns a greeting string\n'
              '@Visible(forRole: \'admin\')\n'
              '@ExecutionMode(ExecutionModes.directly)\n'
              'abstract String greetingMessage(String name);\n';
          expect(actual, expected);
        });
  });

  group('Method.getter() constructor', () {
    test("Should return: 'int get age => this.age;\n'", () {
      String actual = Method.getter(
        'age',
        Expression.ofThisField('age'),
        type: Type.ofInt(),
      ).toString();
      String expected = 'int get age => this.age;\n';
      expect(actual, expected);
    });
  });

  group('Method.setter() constructor', () {
    test("Should return: setter method", () {
      String actual = Method.setter(
        'age',
        Statement.assignVariable('age', Expression.ofVariable('age'),
            this$: true),
        type: Type.ofInt(),
      ).toString();
      String expected = 'set age(int age) {\n'
          '  this.age = age;\n'
          '}\n';
      expect(actual, expected);
    });
  });

}