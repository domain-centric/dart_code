import 'package:dart_code/annotation.dart';
import 'package:dart_code/basic.dart';
import 'package:dart_code/class.dart';
import 'package:dart_code/comment.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/parameter.dart';
import 'package:dart_code/statement.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('FieldInitializer class', () {
    test("Should return: name='Nils'", () {
      String actual =
          FieldInitializer('name', Expression.ofString('Nils')).toString();
      String expected = "name = 'Nils'";
      expect(actual, expected);
    });
  });

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

  group('Method class', () {
    group('Method() constructor', () {
      test('Should return: code of a method that returns a greeting string',
          () {
        String actual = Method('greetingMessage',
                Statement.return$(Expression.ofString('Hello \$name.')),
                parameters: Parameters(
                    [Parameter.required('name', type: Type.ofString())]),
                returnType: Type.ofString())
            .toString();
        String expected = 'String greetingMessage(String name) {\n'
            '  return \'Hello \$name.\';\n'
            '}';
        expect(actual, expected);
      });

      test(
          'Should return: code of a method that returns a greeting string, with DocComments and Annotations',
          () {
        String actual = Method('greetingMessage',
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
            '}';
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
                returnType: Type.ofString())
            .toString();
        String expected = 'static String greetingMessage(String name) {\n'
            '  return \'Hello \$name.\';\n'
            '}';
        expect(actual, expected);
      });

      test(
          'Should return: code of a static method that returns a greeting string, with DocComments and Annotations',
          () {
        String actual = Method.static('greetingMessage',
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
            '}';
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
                returnType: Type.ofString())
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
            returnType: Type.ofString(),
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
  });

  group('Field class', () {
    group('Field.var\$ constructor', () {
      test("Should return: 'var name;\n'", () {
        String actual = Field.var$('name').toString();
        String expected = 'var name;\n';
        expect(actual, expected);
      });

      test("Should return: 'String name;\n'", () {
        String actual = Field.var$('name', type: Type.ofString()).toString();
        String expected = 'String name;\n';
        expect(actual, expected);
      });

      test("Should return: 'static String name;\n'", () {
        String actual =
            Field.var$('name', type: Type.ofString(), static: true).toString();
        String expected = 'static String name;\n';
        expect(actual, expected);
      });

      test("Should return: a string field name;\n'", () {
        String actual = Field.var$('name',
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')]).toString();
        String expected = '/// A valid name\n'
            'String name;\n';
        expect(actual, expected);
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        String actual = Field.var$('name',
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')],
            annotations: [Annotation(Type('Hidden'))]).toString();
        String expected = '/// A valid name\n'
            '@Hidden()\n'
            'String name;\n';
        expect(actual, expected);
      });
    });

    group('Field.const\$ constructor', () {
      test("Should return: 'const name = 'Nils';\n'", () {
        String actual =
            Field.const$('name', Expression.ofString('Nils')).toString();
        String expected = "const name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'const String name = 'Nils';\n'", () {
        String actual = Field.const$('name', Expression.ofString('Nils'),
                type: Type.ofString())
            .toString();
        String expected = "const String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'static const String name = 'Nils';\n'", () {
        String actual = Field.const$('name', Expression.ofString('Nils'),
                type: Type.ofString(), static: true)
            .toString();
        String expected = "static const String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: a string field name;\n'", () {
        String actual = Field.const$('name', Expression.ofString('Nils'),
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')]).toString();
        String expected = '/// A valid name\n'
            "const String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        String actual = Field.const$('name', Expression.ofString('Nils'),
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')],
            annotations: [Annotation(Type('Hidden'))]).toString();
        String expected = '/// A valid name\n'
            '@Hidden()\n'
            "const String name = 'Nils';\n";
        expect(actual, expected);
      });
    });

    group('Field.final\$ constructor', () {
      test("Should return: 'final name;\n'", () {
        String actual = Field.final$('name').toString();
        String expected = "final name;\n";
        expect(actual, expected);
      });

      test("Should return: 'final name = 'Nils';\n'", () {
        String actual =
            Field.final$('name', value: Expression.ofString('Nils')).toString();
        String expected = "final name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'final String name = 'Nils';\n'", () {
        String actual = Field.final$('name',
                value: Expression.ofString('Nils'), type: Type.ofString())
            .toString();
        String expected = "final String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'static final String name;\n'", () {
        String actual = Field.final$('name',
                value: Expression.ofString('Nils'),
                type: Type.ofString(),
                static: true)
            .toString();
        String expected = "static final String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: a string field name;\n'", () {
        String actual = Field.final$('name',
            value: Expression.ofString('Nils'),
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')]).toString();
        String expected =
            '/// A valid name\n'
            "final String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        String actual = Field.final$('name',
            value: Expression.ofString('Nils'),
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')],
            annotations: [Annotation(Type('Hidden'))]).toString();
        String expected =
            '/// A valid name\n'
            '@Hidden()\n'
            "final String name = 'Nils';\n";
        expect(actual, expected);
      });
    });
  });

  group('Class class', () {
    test("Should return: class", () {
      String actual = Class('Person').toString();
      String expected =
          'class Person {\n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with DocComment and annotation", () {
      String actual = Class('Person', docComments: [
        DocComment.fromString(
            'A Person that can be converted to and from Json format')
      ], annotations: [
        Annotation(Type('JsonSerializable',
            libraryUrl: 'package:json_annotation/json_annotation.dart'))
      ]).toString();
      String expected =
          '/// A Person that can be converted to and from Json format\n'
          '@_i1.JsonSerializable()\n'
          'class Person {\n'
          '}';
      expect(actual, expected);
    });

    test("Should return: abstract class", () {
      String actual = Class('Person', abstract: true).toString();
      String expected =
          'abstract class Person {\n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with super class", () {
      String actual = Class('Person', superClass: Type('Contact', libraryUrl:'package:my_lib/contact.dart')).toString();
      String expected =
          'class Person extends _i1.Contact {\n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with implements", () {
      String actual = Class('Person', implements: [
        Type('Musician', libraryUrl:'package:my_lib/musician.dart'),
        Type('Technician', libraryUrl:'package:my_lib/technician.dart')
      ]).toString();
      String expected ='class Person implements \n'
          '  _i1.Musician,\n'
          '  _i2.Technician {\n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with mixins", () {
      String actual = Class('Person', mixins: [
        Type('Musician', libraryUrl:'package:my_lib/musician.dart'),
        Type('Technician', libraryUrl:'package:my_lib/technician.dart')
      ]).toString();
      String expected ='class Person with \n'
          '  _i1.Musician,\n'
          '  _i2.Technician {\n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with fields", () {
      String actual = Class('Person', fields: [
        Field.final$('name', type: Type.ofString()),
        Field.const$('human', Expression.ofBool(true), static: true),
        Field.var$('gender', value: Expression.ofEnum(Type('Gender'), "male")),
      ]).toString();
      String expected ='class Person {\n'
          '  final String name;\n'
          '  static const human = true;\n'
          '  var gender = Gender.male;\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    /// TODO fields,
    /// TODO constructors,
    /// TODO methods,
    /// TODO getter methods
    /// TODO setter methods
    /// TODO combined

  });
}
