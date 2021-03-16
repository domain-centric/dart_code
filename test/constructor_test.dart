import 'package:dart_code/annotation.dart';
import 'package:dart_code/basic.dart';
import 'package:dart_code/comment.dart';
import 'package:dart_code/constructor.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/field.dart';
import 'package:dart_code/parameter.dart';
import 'package:dart_code/statement.dart';
import 'package:dart_code/type.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('ConstructorCall class', () {
    test("Should return: this()", () {
      String actual = ConstructorCall().toString();
      String expected = "this()";
      expect(actual, expected);
    });

    test("Should return: this.origin()", () {
      String actual = ConstructorCall(name: 'origin').toString();
      String expected = "this.origin()";
      expect(actual, expected);
    });

    test("Should throw invalid name exception", () {
      expect(
          () => {ConstructorCall(name: 'InvalidConstructorName').toString()},
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter')));
    });

    test("Should return: this.point(x: 5, y: 10)", () {
      String actual = ConstructorCall(
          name: 'point',
          parameterValues: ParameterValues([
            ParameterValue.named('x', Expression.ofInt(5)),
            ParameterValue.named('y', Expression.ofInt(10)),
          ])).toString();
      String expected = 'this.point(\n'
          '  x: 5,\n'
          '  y: 10)';
      expect(actual, expected);
    });

    test("Should return: super()", () {
      String actual = ConstructorCall(super$: true).toString();
      String expected = "super()";
      expect(actual, expected);
    });

    test("Should return: super.origin()", () {
      String actual = ConstructorCall(name: 'origin', super$: true).toString();
      String expected = "super.origin()";
      expect(actual, expected);
    });

    test("Should throw invalid name exception", () {
      expect(
          () => {
                ConstructorCall(
                  name: 'InvalidConstructorName',
                  super$: true,
                ).toString()
              },
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter')));
    });

    test("Should return: super.point(x: 5, y: 10)", () {
      String actual = ConstructorCall(
          name: 'point',
          super$: true,
          parameterValues: ParameterValues([
            ParameterValue.named('x', Expression.ofInt(5)),
            ParameterValue.named('y', Expression.ofInt(10)),
          ])).toString();
      String expected = 'super.point(\n'
          '  x: 5,\n'
          '  y: 10)';
      expect(actual, expected);
    });
  });

  group('Initializers class', () {
    test("Should return: name = 'Nils', age = 30", () {
      String actual = Initializers(fieldInitializers: [
        FieldInitializer('name', Expression.ofString('Nils')),
        FieldInitializer('age', Expression.ofInt(30)),
      ]).toString();

      String expected = '\n'
          '  name = \'Nils\',\n'
          '  age = 30';
      expect(actual, expected);
    });

    test("Should throw parameter value names not unique exception", () {
      expect(
          () => {
                Initializers(fieldInitializers: [
                  FieldInitializer('name', Expression.ofString('Nils')),
                  FieldInitializer('name', Expression.ofString('Bianca')),
                ]).toString()
              },
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'Field names must be unique')));
    });

    test("Should return: name = 'Nils', age = 30", () {
      String actual = Initializers(fieldInitializers: [
        FieldInitializer('name', Expression.ofString('Nils')),
        FieldInitializer('age', Expression.ofInt(30)),
      ]).toString();

      String expected = '\n'
          '  name = \'Nils\',\n'
          '  age = 30';
      expect(actual, expected);
    });

    test("gender = Gender.male, age = 30, super(name = 'Nils')", () {
      String actual = Initializers(
          fieldInitializers: [
            FieldInitializer(
                'gender', Expression.ofEnum(Type('Gender'), 'male')),
            FieldInitializer('age', Expression.ofInt(30)),
          ],
          constructorCall: ConstructorCall(
              super$: true,
              parameterValues: ParameterValues([
                ParameterValue.named('name', Expression.ofString('Nils'))
              ]))).toString();
      String expected = '\n'
          '  gender = Gender.male,\n'
          '  age = 30,\n'
          '  super(name: \'Nils\')';
      expect(actual, expected);
    });
  });

  group('Constructor class', () {
    test("Should return: Person();\n", () {
      String actual = Constructor(Type('Person')).toString();
      String expected = 'Person();\n';
      expect(actual, expected);
    });

    test("Should return: Constructor with annotation", () {
      String actual = Constructor(Type('Person'), annotations: [
        Annotation(Type('JsonSerializable',
            libraryUrl: 'package:json_annotation/json_annotation.dart'))
      ]).toString();
      String expected = '@_i1.JsonSerializable()\n'
          'Person();\n';
      expect(actual, expected);
    });

    test("Should return: Constructor with doc comment", () {
      String actual = Constructor(
        Type('Person'),
        docComments: [
          DocComment.fromString(
              'A Person that can be converted to and from Json format')
        ],
      ).toString();
      String expected =
          '/// A Person that can be converted to and from Json format\n'
          'Person();\n';
      expect(actual, expected);
    });

    test("Should return: Constructor with doc comment and annotation", () {
      String actual = Constructor(Type('Person'), docComments: [
        DocComment.fromString(
            'A Person that can be converted to and from Json format')
      ], annotations: [
        Annotation(Type('JsonSerializable',
            libraryUrl: 'package:json_annotation/json_annotation.dart'))
      ]).toString();
      String expected =
          '/// A Person that can be converted to and from Json format\n'
          '@_i1.JsonSerializable()\n'
          'Person();\n';
      expect(actual, expected);
    });

    test("Should return: external Person();\n", () {
      String actual = Constructor(Type('Person'), external: true).toString();
      String expected = 'external Person();\n';
      expect(actual, expected);
    });

    test("Should return: const Person();\n", () {
      String actual = Constructor(Type('Person'), constant: true).toString();
      String expected = 'const Person();\n';
      expect(actual, expected);
    });

    test("Should return: factory Person();\n", () {
      String actual = Constructor(Type('Person'), factory: true).toString();
      String expected = 'factory Person();\n';
      expect(actual, expected);
    });

    test("Should return: factory Point.origin();\n", () {
      String actual = Constructor(Type('Point'), name: 'origin').toString();
      String expected = 'Point.origin();\n';
      expect(actual, expected);
    });

    test("Should return: Point.(int x, int y);\n", () {
      String actual = Constructor(Type('Point'),
          parameters: ConstructorParameters([
            ConstructorParameter.required('x', type: Type.ofInt()),
            ConstructorParameter.required('y', type: Type.ofInt())
          ])).toString();
      String expected = 'Point(\n'
          '  int x,\n'
          '  int y);\n';
      expect(actual, expected);
    });

    test("Should return: Point.origin() : x = 0, y = 0;\n", () {
      String actual = Constructor(Type('Point'),
          name: 'origin',
          initializers: Initializers(fieldInitializers: [
            FieldInitializer('x', Expression.ofInt(0)),
            FieldInitializer('y', Expression.ofInt(0)),
          ])).toString();
      String expected = 'Point.origin() : \n'
          '  x = 0,\n'
          '  y = 0;\n';
      expect(actual, expected);
    });

    test("Should return: Point.origin() : this(x : 0, y : 0);\n", () {
      String actual = Constructor(Type('Point'),
          name: 'origin',
          initializers: Initializers(
              constructorCall: ConstructorCall(
                  parameterValues: ParameterValues([
            ParameterValue.named('x', Expression.ofInt(0)),
            ParameterValue.named('y', Expression.ofInt(0))
          ])))).toString();
      String expected = 'Point.origin() : this(\n'
          '  x: 0,\n'
          '  y: 0);\n';
      expect(actual, expected);
    });

    test("Should return: Constructor with a body", () {
      String actual = Constructor(Type('Point'),
          name: 'origin',
          body: Block([
            Statement.assignVariable('x', Expression.ofInt(5), this$: true),
            Statement.assignVariable('y', Expression.ofInt(10), this$: true),
          ])).toString();
      String expected = 'Point.origin() {\n'
          '  this.x = 5;\n'
          '  this.y = 10;\n'
          '};\n';
      expect(actual, expected);
    });

    test("Should return: Correct complex constructor", () {
      final givenName = 'givenName';
      final familyName = 'familyName';
      String actual = Constructor(Type('Person'),
          initializers: Initializers(
              fieldInitializers: [
                FieldInitializer(givenName, Expression.ofString('Nils')),
                FieldInitializer(familyName, Expression.ofString('ten Hoeve')),
              ],
              constructorCall: ConstructorCall(
                  parameterValues: ParameterValues([
                ParameterValue.named(
                    'gender', Expression.ofEnum(Type('Gender'), 'male')),
                ParameterValue.named('age', Expression.ofInt(30))
              ]))),
          body: Block([
            Statement.assignVariable(
                'fullName',
                Expression.callFunction(
                    '_appendNames',
                    ParameterValues([
                      ParameterValue(Expression.ofVariable(givenName)),
                      ParameterValue(Expression.ofVariable(familyName)),
                    ])),
                this$: true),
          ])).toString();
      String expected = 'Person() : \n'
          '  givenName = \'Nils\',\n'
          '  familyName = \'ten Hoeve\',\n'
          '  this(\n'
          '    gender: Gender.male,\n'
          '    age: 30) {\n'
          '  this.fullName = _appendNames(\n'
          '    givenName,\n'
          '    familyName);\n'
          '};\n';
      expect(actual, expected);
    });
  });
}
