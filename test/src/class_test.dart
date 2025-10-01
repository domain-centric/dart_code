// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('Class class', () {
    test("Should return: class", () {
      Class('Person').toString().should.be('class Person {}');
    });

    test("Should return: class with DocComment and annotation", () {
      Class('Person', docComments: [
        DocComment.fromString(
            'A Person that can be converted to and from Json format')
      ], annotations: [
        Annotation(Type('JsonSerializable',
            libraryUri: 'package:json_annotation/json_annotation.dart'))
      ])
          .toFormattedString()
          .should
          .be('/// A Person that can be converted to and from Json format\n'
              '@i1.JsonSerializable()\n'
              'class Person {}\n');
    });

    test("Should return: abstract class", () {
      Class('Person', abstract: true)
          .toString()
          .should
          .be('abstract class Person {}');
    });

    test("Should return: class with super class", () {
      Class('Person',
              superClass:
                  Type('Contact', libraryUri: 'package:my_lib/contact.dart'))
          .toString()
          .should
          .be('class Person extends i1.Contact {}');
    });

    test("Should return: class with implements", () {
      Class('Person', implements: [
        Type('Musician', libraryUri: 'package:my_lib/musician.dart'),
        Type('Technician', libraryUri: 'package:my_lib/technician.dart')
      ])
          .toString()
          .should
          .be('class Person implements i1.Musician,i2.Technician {}');
    });

    test("Should return: class with mixins", () {
      Class('Person', mixins: [
        Type('Musician', libraryUri: 'package:my_lib/musician.dart'),
        Type('Technician', libraryUri: 'package:my_lib/technician.dart')
      ]).toString().should.be('class Person with i1.Musician,i2.Technician {}');
    });

    test("Should return: class with fields", () {
      Class('Person', fields: [
        Field('name', modifier: Modifier.final$, type: Type.ofString()),
        Field('human',
            static: true,
            modifier: Modifier.const$,
            value: Expression.ofBool(true)),
        Field('gender', value: Expression.ofEnum(Type('Gender'), "male")),
      ]).toFormattedString().should.be('class Person {\n'
          '  final String name;\n'
          '  static const human = true;\n'
          '  var gender = Gender.male;\n'
          '}\n');
    });

    test("Should return: class with constructors", () {
      Class('Point', constructors: [
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
      ]).toFormattedString().should.be('class Point {\n'
          '  Point(this.x, this.y);\n'
          '  Point.origin() : x = 0, y = 0;\n'
          '}\n');
    });

    test("Should return: class with methods", () {
      Class('Person', methods: [
        Method('greetingMessage',
            Statement.return$(Expression.ofString('Hello \$name.')),
            returnType: Type.ofString())
      ]).toFormattedString().should.be('class Person {\n'
          '  String greetingMessage() {\n'
          '    return \'Hello \$name.\';\n'
          '  }\n'
          '}\n');
    });

    test("Should return: class with getter method", () {
      Class('Person', methods: [
        Method.getter(
          'age',
          Expression.ofThisField('age'),
          returnType: Type.ofInt(),
        )
      ]).toFormattedString().should.be('class Person {\n'
          '  int get age => this.age;\n'
          '}\n');
    });

    test("Should return: class with getter method", () {
      Class('Person', methods: [
        Method.setter(
          'age',
          Statement.assignVariable('age', Expression.ofVariable('age'),
              this$: true),
          returnType: Type.ofInt(),
        )
      ])
          .toString()
          .should
          .be('class Person {set age(int age) {this.age = age;}}');
    });

    test("Should return: a composed class", () {
      Class('Person', fields: [
        Field('givenName', modifier: Modifier.final$, type: Type.ofString()),
        Field('familyName', modifier: Modifier.final$, type: Type.ofString()),
        Field('fullName', modifier: Modifier.final$, type: Type.ofString()),
        Field('dateOfBirth',
            modifier: Modifier.final$, type: Type.ofDateTime()),
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
            returnType: Type.ofString()),
        Method.getter(
            'ageInYears',
            Block([
              VariableDefinition('now',
                  type: Type.ofDateTime(),
                  value: Expression.callConstructor(Type.ofDateTime(),
                      name: "now")),
              VariableDefinition('years',
                  type: Type.ofInt(),
                  value: Expression.ofVariable('now')
                      .getProperty('year')
                      .subtract(Expression.ofVariable('dateOfBirth')
                          .getProperty('year'))),
              VariableDefinition('months',
                  type: Type.ofInt(),
                  value: Expression.ofVariable('now')
                      .getProperty('month')
                      .subtract(Expression.ofVariable('dateOfBirth')
                          .getProperty('month'))),
              VariableDefinition('days',
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
      ]).toFormattedString().should.be('class Person {\n'
          '  final String givenName;\n'
          '  final String familyName;\n'
          '  final String fullName;\n'
          '  final DateTime dateOfBirth;\n'
          '  Person(this.givenName, this.familyName, this.dateOfBirth)\n'
          '    : fullName = \'\$givenName \$familyName\';\n'
          '  String greetingMessage() {\n'
          '    return \'Hello \$fullName.\';\n'
          '  }\n'
          '\n'
          '  get ageInYears {\n'
          '    DateTime now = DateTime.now();\n'
          '    int years = now.year - dateOfBirth.year;\n'
          '    int months = now.month - dateOfBirth.month;\n'
          '    int days = now.day - dateOfBirth.day;\n'
          '    if (months < 0 || (months == 0 && days < 0)) {\n'
          '      years--;\n'
          '    }\n'
          '    return years;\n'
          '  }\n'
          '}\n');
    });
  });

  group("Person class", () {
    test('Person.fullName property', () {
      var dateOfBirth = DateTime.utc(1977, 6, 7);
      Person('Nils', 'ten Hoeve', dateOfBirth)
          .fullName
          .should
          .be('Nils ten Hoeve');
    });

    test('Person.ageInYears property', () {
      var ageInYears = 30;
      var dateOfBirth =
          DateTime.now().subtract(Duration(days: 366 * ageInYears));
      Person('Nils', 'ten Hoeve', dateOfBirth).ageInYears.should.be(ageInYears);
    });

    test('Person.greetingMessage() method', () {
      var dateOfBirth = DateTime.utc(1977, 6, 7);
      Person('Nils', 'ten Hoeve', dateOfBirth)
          .greetingMessage()
          .should
          .be("Hello Nils ten Hoeve.");
    });
  });
}

class Person {
  final String givenName;
  final String familyName;
  final String fullName;
  final DateTime dateOfBirth;

  Person(this.givenName, this.familyName, this.dateOfBirth)
      : fullName = '$givenName $familyName';

  String greetingMessage() {
    return 'Hello $fullName.';
  }

  int get ageInYears {
    DateTime now = DateTime.now();
    int years = now.year - dateOfBirth.year;
    int months = now.month - dateOfBirth.month;
    int days = now.day - dateOfBirth.day;
    if (months < 0 || (months == 0 && days < 0)) {
      years--;
    }
    return years;
  }
}
