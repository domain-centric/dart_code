import 'package:dart_code/annotation.dart';
import 'package:dart_code/basic.dart';
import 'package:dart_code/class.dart';
import 'package:dart_code/comment.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/field.dart';
import 'package:dart_code/method.dart';
import 'package:dart_code/parameter.dart';
import 'package:dart_code/statement.dart';
import 'package:dart_code/variable_definition.dart';
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




  group('Class class', () {
    test("Should return: class", () {
      String actual = Class('Person').toString();
      String expected = 'class Person {\n'
          '  \n'
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
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: abstract class", () {
      String actual = Class('Person', abstract: true).toString();
      String expected = 'abstract class Person {\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with super class", () {
      String actual = Class('Person',
              superClass:
                  Type('Contact', libraryUrl: 'package:my_lib/contact.dart'))
          .toString();
      String expected = 'class Person extends _i1.Contact {\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with implements", () {
      String actual = Class('Person', implements: [
        Type('Musician', libraryUrl: 'package:my_lib/musician.dart'),
        Type('Technician', libraryUrl: 'package:my_lib/technician.dart')
      ]).toString();
      String expected = 'class Person implements \n'
          '  _i1.Musician,\n'
          '  _i2.Technician {\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with mixins", () {
      String actual = Class('Person', mixins: [
        Type('Musician', libraryUrl: 'package:my_lib/musician.dart'),
        Type('Technician', libraryUrl: 'package:my_lib/technician.dart')
      ]).toString();
      String expected ='class Person with \n'
          '  _i1.Musician,\n'
          '  _i2.Technician {\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with fields", () {
      String actual = Class('Person', fields: [
        Field.final$('name', type: Type.ofString()),
        Field.const$('human', Expression.ofBool(true), static: true),
        Field.var$('gender', value: Expression.ofEnum(Type('Gender'), "male")),
      ]).toString();
      String expected = 'class Person {\n'
          '  \n'
          '  final String name;\n'
          '  static const human = true;\n'
          '  var gender = Gender.male;\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with constructors", () {
      String actual = Class('Point', constructors: [
        Constructor(Type('Point'),
            parameters: ConstructorParameters([
              ConstructorParameter.required('x', this$: true),
              ConstructorParameter.required('y', this$: true),
            ])),
        Constructor(Type('Point'),
            name: 'origin',
            initializers: Initializers(fieldInitializers: [
              FieldInitializer('x', Expression.ofInt(0)),
              FieldInitializer('y', Expression.ofInt(0)),
            ]))
      ]).toString();
      String expected = 'class Point {\n'
          '  \n'
          '  Point(\n'
          '    this.x,\n'
          '    this.y);\n'
          '  \n'
          '  Point.origin() : \n'
          '    x = 0,\n'
          '    y = 0;\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with methods", () {
      String actual = Class('Person', methods: [
        Method('greetingMessage',
            Statement.return$(Expression.ofString('Hello \$name.')),
            type: Type.ofString())
      ]).toString();
      String expected = 'class Person {\n'
          '  \n'
          '  String greetingMessage() {\n'
          '    return \'Hello \$name.\';\n'
          '  }\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with getter method", () {
      String actual = Class('Person', methods: [
        Method.getter(
          'age',
          Expression.ofThisField('age'),
          type: Type.ofInt(),
        )
      ]).toString();
      String expected = 'class Person {\n'
          '  \n'
          '  int get age => this.age;\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: class with getter method", () {
      String actual = Class('Person', methods: [
        Method.setter(
          'age',
          Statement.assignVariable('age', Expression.ofVariable('age'),
              this$: true),
          type: Type.ofInt(),
        )
      ]).toString();
      String expected ='class Person {\n'
          '  \n'
          '  set age(int age) {\n'
          '    this.age = age;\n'
          '  }\n'
          '  \n'
          '}';
      expect(actual, expected);
    });

    test("Should return: a composed class", () {
      String actual = Class('Person', fields: [
        Field.final$('givenName', type: Type.ofString()),
        Field.final$('familyName', type: Type.ofString()),
        Field.final$('fullName', type: Type.ofString()),
        Field.final$('dateOfBirth', type: Type.ofDateTime()),
      ], constructors: [
        Constructor(Type('Person'),
            parameters: ConstructorParameters([
              ConstructorParameter.required('givenName', this$: true),
              ConstructorParameter.required('familyName', this$: true),
              ConstructorParameter.required('dateOfBirth', this$: true),
            ]),
            initializers: Initializers(fieldInitializers: [
              FieldInitializer(
                  'fullName', Expression.ofString('\$givenName \$familyName'))
            ]))
      ], methods: [
        Method('greetingMessage',
            Statement.return$(Expression.ofString('Hello \$fullName.')),
            type: Type.ofString()),
        Method.getter(
            'ageInYears',
            Block([
              VariableDefinition.var$('now',
                  type: Type.ofDateTime(),
                  value: Expression.callConstructor(Type.ofDateTime(),
                      name: "now")),
              VariableDefinition.var$('years',
                  type: Type.ofInt(),
                  value: Expression.ofVariable('now')
                      .getProperty('year')
                      .subtract(Expression.ofVariable('dateOfBirth')
                          .getProperty('year'))),
              VariableDefinition.var$('months',
                  type: Type.ofInt(),
                  value: Expression.ofVariable('now')
                      .getProperty('month')
                      .subtract(Expression.ofVariable('dateOfBirth')
                          .getProperty('month'))),
              VariableDefinition.var$('days',
                  type: Type.ofInt(),
                  value: Expression.ofVariable('now')
                      .getProperty('day')
                      .subtract(Expression.ofVariable('dateOfBirth')
                          .getProperty('day'))),
              Statement.if$(
                  Expression.ofVariable('months')
                      .lessThan(Expression.ofInt(0))
                      .or(Expression.betweenParentheses(
                          Expression.ofVariable('months')
                              .equalTo(Expression.ofInt(0))
                              .and(Expression.ofVariable('days')
                                  .lessThan(Expression.ofInt(0))))),
                  Block([
                    Statement.ofExpression(
                        Expression.ofVariable('years').decrement())
                  ])),
              Statement.return$(Expression.ofVariable('years')),
            ]))
      ]).toString();
      String expected = 'class Person {\n'
          '  \n'
          '  final String givenName;\n'
          '  final String familyName;\n'
          '  final String fullName;\n'
          '  final DateTime dateOfBirth;\n'
          '  \n'
          '  Person(\n'
          '    this.givenName,\n'
          '    this.familyName,\n'
          '    this.dateOfBirth) : fullName = \'\$givenName \$familyName\';\n'
          '  \n'
          '  String greetingMessage() {\n'
          '    return \'Hello \$fullName.\';\n'
          '  }\n'
          '  \n'
          '  get ageInYears {\n'
          '    DateTime now = DateTime.now();\n'
          '    int years = now.year - dateOfBirth.year;\n'
          '    int months = now.month - dateOfBirth.month;\n'
          '    int days = now.day - dateOfBirth.day;\n'
          '    if (months < 0 || (months == 0 && days < 0)){\n'
          '      years--;\n'
          '    }\n'
          '    return years;\n'
          '  }\n'
          '  \n'
          '}';
      expect(actual, expected);
    });
  });

  group("Person class", () {
    test('Person.fullName property', () {
      var dateOfBirth = DateTime.utc(1977,6,7);
      String actual=Person('Nils', 'ten Hoeve', dateOfBirth).fullName;
      String expected='Nils ten Hoeve';
      expect(actual, expected);
    });

    test('Person.ageInYears property', () {
      var ageInYears = 30;
      var dateOfBirth = DateTime.now().subtract(Duration(days: 366*ageInYears));
      int actual=Person('Nils', 'ten Hoeve', dateOfBirth).ageInYears;
      expect(actual, ageInYears);
    });


    test('Person.greetingMessage() method', () {
      var dateOfBirth = DateTime.utc(1977,6,7);
      String actual=Person('Nils', 'ten Hoeve', dateOfBirth).greetingMessage();
      String expected="Hello Nils ten Hoeve.";
      expect(actual,expected);
    });

  });
}
class Person {

  final String givenName;
  final String familyName;
  final String fullName;
  final DateTime dateOfBirth;

  Person(
      this.givenName,
      this.familyName,
      this.dateOfBirth) : fullName = '$givenName $familyName';

  String greetingMessage() {
    return 'Hello $fullName.';
  }

  get ageInYears {
    DateTime now = DateTime.now();
    int years = now.year - dateOfBirth.year;
    int months = now.month - dateOfBirth.month;
    int days = now.day - dateOfBirth.day;
    if (months < 0 || (months == 0 && days < 0)){
      years--;
    }
    return years;
  }

}