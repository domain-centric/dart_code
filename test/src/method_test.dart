// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:dart_code/src/operator.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

main() {
  group('Method() constructor', () {
    test("Should return: asynch method", () {
      Method(
        'randomNumber',
        Statement.return$(
            Expression.callMethodOrFunction("randomIntGenerator")),
        asynchrony: Asynchrony.async,
        returnType: Type.ofFuture(Type.ofInt()),
      ).toFormattedString().should.be('Future<int> randomNumber() async {\n'
          '  return randomIntGenerator();\n'
          '}\n');
    });

    test('Should return: code of a method that returns a greeting string', () {
      Method('greetingMessage',
              Statement.return$(Expression.ofString('Hello \$name.')),
              parameters: Parameters(
                  [Parameter.required('name', type: Type.ofString())]),
              returnType: Type.ofString())
          .toFormattedString()
          .should
          .be('String greetingMessage(String name) {\n'
              '  return \'Hello \$name.\';\n'
              '}\n');
    });

    test(
        'Should return: code of a method that returns a greeting string, with DocComments and Annotations',
        () {
      Method('greetingMessage',
          Statement.return$(Expression.ofString('Hello \$name.')),
          parameters:
              Parameters([Parameter.required('name', type: Type.ofString())]),
          returnType: Type.ofString(),
          docComments: [
            DocComment.fromString("This method returns a greeting string")
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
          ]).toFormattedString().should.be(
          '/// This method returns a greeting string\n'
          '@Visible(forRole: \'admin\')\n'
          '@ExecutionMode(ExecutionModes.directly)\n'
          'String greetingMessage(String name) {\n'
          '  return \'Hello \$name.\';\n'
          '}\n');
    });
  });

  group('Method.static() constructor', () {
    test(
        'Should return: code of a static method that returns a greeting string',
        () {
      Method.static('greetingMessage',
              Statement.return$(Expression.ofString('Hello \$name.')),
              parameters: Parameters(
                  [Parameter.required('name', type: Type.ofString())]),
              returnType: Type.ofString())
          .toString()
          .should
          .be('static String greetingMessage(String name) {return \'Hello \$name.\';}');
    });

    test(
        'Should return: code of a static method that returns a greeting string, with DocComments and Annotations',
        () {
      Method.static('greetingMessage',
          Statement.return$(Expression.ofString('Hello \$name.')),
          parameters:
              Parameters([Parameter.required('name', type: Type.ofString())]),
          returnType: Type.ofString(),
          docComments: [
            DocComment.fromString("This method returns a greeting string")
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
          ]).toString().should.be('/// This method returns a greeting string\n'
          '@Visible(forRole: \'admin\')\n'
          '@ExecutionMode(ExecutionModes.directly)\n'
          'static String greetingMessage(String name) {return \'Hello \$name.\';}');
    });
  });

  group('Method.abstract() constructor', () {
    test(
        'Should return: code of a abstract method that returns a greeting string',
        () {
      Method.abstract('greetingMessage',
              parameters: Parameters(
                  [Parameter.required('name', type: Type.ofString())]),
              returnType: Type.ofString())
          .toString()
          .should
          .be('String greetingMessage(String name);');
    });

    test(
        'Should return: code of a abstract method that returns a greeting string, with DocComments and Annotations',
        () {
      Method.abstract('greetingMessage',
          parameters:
              Parameters([Parameter.required('name', type: Type.ofString())]),
          returnType: Type.ofString(),
          docComments: [
            DocComment.fromString("This method returns a greeting string")
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
          ]).toString().should.be('/// This method returns a greeting string\n'
          '@Visible(forRole: \'admin\')\n'
          '@ExecutionMode(ExecutionModes.directly)\n'
          'String greetingMessage(String name);');
    });
  });

  group('Method.getter() constructor', () {
    test("Should return: 'int get age  => this.age;'", () {
      Method.getter(
        'age',
        Expression.ofThisField('age'),
        returnType: Type.ofInt(),
      ).toString().should.be('int get age  => this.age;');
    });

    test("Should return: 'final int get age  => this.age;'", () {
      Method.getter(
        'age',
        Expression.ofThisField('age'),
        returnType: Type.ofInt(),
        final$: true,
      ).toString().should.be('final int get age  => this.age;');
    });
  });

  group('Method.setter() constructor', () {
    test("Should return: setter method", () {
      Method.setter(
        'age',
        Statement.assignVariable('age', Expression.ofVariable('age'),
            this$: true),
        returnType: Type.ofInt(),
      ).toString().should.be('set age(int age) {this.age = age;}');
    });
  });

  group('Method.overrideOperator() constructor', () {
    test("Should return: overridden '+' operator method", () {
      Method.overrideOperator(
        Operator.add,
        Expression.ofThis().getProperty('value').add(
            Expression.ofVariable('other')
                .getProperty('value')), //  'this.value + other.value'
        annotations: {Annotation.override()},
        parameter: Parameter.required('other', type: Type.ofInt()),
        returnType: Type.ofInt(),
      ).toString().should.be('@override\n'
          'int operator +(int other)  => this.value + other.value;');
    });

    test("Should return: overridden '==' operator method", () {
      Method.overrideOperator(
        Operator.equals,
        Expression.ofThis()
            .getProperty('id')
            .add(Expression.ofVariable('other').getProperty('id')),
        parameter: Parameter.required('other', type: Type('MyClass')),
        returnType: Type.ofBool(),
      ).toString().should.be('@override\n'
          'bool operator ==(MyClass other)  => this.id + other.id;');
    });

    test("Should return: overridden '>' operator method", () {
      Method.overrideOperator(
        Operator.greaterThan,
        Expression.ofThis()
            .getProperty('value')
            .add(Expression.ofVariable('other').getProperty('value')),
        parameter: Parameter.required('other', type: Type('MyClass')),
        returnType: Type.ofBool(),
      ).toString().should.be('@override\n'
          'bool operator >(MyClass other)  => this.value + other.value;');
    });
  });
}
