import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Class class', () {
    test("Should return: class", () {
      String actual = Class('Person').toString();
      String expected = 'class Person {}\n';
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
          'class Person {}\n';
      expect(actual, expected);
    });

    test("Should return: abstract class", () {
      String actual = Class('Person', abstract: true).toString();
      String expected = 'abstract class Person {}\n';
      expect(actual, expected);
    });

    test("Should return: class with super class", () {
      String actual = Class('Person',
              superClass:
                  Type('Contact', libraryUrl: 'package:my_lib/contact.dart'))
          .toString();
      String expected = 'class Person extends _i1.Contact {}\n';
      expect(actual, expected);
    });

    test("Should return: class with implements", () {
      String actual = Class('Person', implements: [
        Type('Musician', libraryUrl: 'package:my_lib/musician.dart'),
        Type('Technician', libraryUrl: 'package:my_lib/technician.dart')
      ]).toString();
      String expected =
          'class Person implements _i1.Musician, _i2.Technician {}\n';
      expect(actual, expected);
    });

    test("Should return: class with mixins", () {
      String actual = Class('Person', mixins: [
        Type('Musician', libraryUrl: 'package:my_lib/musician.dart'),
        Type('Technician', libraryUrl: 'package:my_lib/technician.dart')
      ]).toString();
      String expected = 'class Person with _i1.Musician, _i2.Technician {}\n';
      expect(actual, expected);
    });

    test("Should return: class with fields", () {
      String actual = Class('Person', fields: [
        Field.final$('name', type: Type.ofString()),
        Field.const$('human', Expression.ofBool(true), static: true),
        Field.var$('gender', value: Expression.ofEnum(Type('Gender'), "male")),
      ]).toString();
      String expected = 'class Person {\n'
          '  final String name;\n'
          '  static const human = true;\n'
          '  var gender = Gender.male;\n'
          '}\n';
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
          '  Point(this.x, this.y);\n'
          '  Point.origin()\n'
          '      : x = 0,\n'
          '        y = 0;\n'
          '}\n';
      expect(actual, expected);
    });

    test("Should return: class with methods", () {
      String actual = Class('Person', methods: [
        Method('greetingMessage',
            Statement.return$(Expression.ofString('Hello \$name.')),
            type: Type.ofString())
      ]).toString();
      String expected = 'class Person {\n'
          '  String greetingMessage() {\n'
          '    return \'Hello \$name.\';\n'
          '  }\n'
          '}\n';
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
          '  int get age => this.age;\n'
          '}\n';
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
      String expected = 'class Person {\n'
          '  set age(int age) {\n'
          '    this.age = age;\n'
          '  }\n'
          '}\n';
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
          '  final String givenName;\n'
          '  final String familyName;\n'
          '  final String fullName;\n'
          '  final DateTime dateOfBirth;\n'
          '  Person(this.givenName, this.familyName, this.dateOfBirth)\n'
          '      : fullName = \'\$givenName \$familyName\';\n'
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
          '}\n';
      expect(actual, expected);
    });
  });

  group("Person class", () {
    test('Person.fullName property', () {
      var dateOfBirth = DateTime.utc(1977, 6, 7);
      String actual = Person('Nils', 'ten Hoeve', dateOfBirth).fullName;
      String expected = 'Nils ten Hoeve';
      expect(actual, expected);
    });

    test('Person.ageInYears property', () {
      var ageInYears = 30;
      var dateOfBirth =
          DateTime.now().subtract(Duration(days: 366 * ageInYears));
      int actual = Person('Nils', 'ten Hoeve', dateOfBirth).ageInYears;
      expect(actual, ageInYears);
    });

    test('Person.greetingMessage() method', () {
      var dateOfBirth = DateTime.utc(1977, 6, 7);
      String actual =
          Person('Nils', 'ten Hoeve', dateOfBirth).greetingMessage();
      String expected = "Hello Nils ten Hoeve.";
      expect(actual, expected);
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

  get ageInYears {
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
