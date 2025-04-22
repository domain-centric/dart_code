/*
 * Copyright (c) 2022. By Nils ten Hoeve. See LICENSE file in project.
 */

import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Library class', () {
    test('constructor with name parameter', () {
      String actual = Library(name: 'contacts').toString();
      String expected = 'library contacts;\n';
      expect(actual, expected);
    });

    test('constructor with docComments parameter', () {
      String actual = Library(docComments: [
        DocComment.fromString('This is a library with a doc comment.')
      ]).toString();
      String expected = '/// This is a library with a doc comment.\n';
      expect(actual, expected);
    });

    test('constructor with annotations parameter', () {
      String actual = CodeFormatter().unFormatted(Library(annotations: [
        Annotation(Type('Foo'),
            ParameterValues([ParameterValue(Expression.ofInt(42))]))
      ]));
      String expected = '@Foo(42)\n';
      expect(actual, expected);
    });

    test('constructor with functions parameter', () {
      String actual = Library(functions: [
        DartFunction.withName('returnTrue', Expression.ofBool(true),
            returnType: Type.ofBool(),
            docComments: [
              DocComment.fromString("This function returns: true")
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
            ])
      ]).toString();
      String expected = '/// This function returns: true\n'
          '@Visible(forRole: \'admin\')\n'
          '@ExecutionMode(ExecutionModes.directly)\n'
          'bool returnTrue() => true;\n';
      expect(actual, expected);
    });

    test('constructor with classes parameter with imports', () {
      String actual = Library(classes: [
        Class(
          'Employee',
          superClass:
              Type('Person', libraryUri: 'package:my_package/person.dart'),
          implements: [
            Type('Skills', libraryUri: 'package:my_package/skills.dart')
          ],
          abstract: true,
        )
      ]).toString();
      String expected = 'import \'package:my_package/person.dart\' as i1;\n'
          'import \'package:my_package/skills.dart\' as i2;\n'
          '\n'
          'abstract class Employee extends i1.Person implements i2.Skills {}\n';
      expect(actual, expected);
    });

    test('constructor with classes parameter', () {
      String actual = Library(classes: [
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
        ])
      ]).toString();
      String expected = 'class Person {\n'
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
          '}\n';
      expect(actual, expected);
    });

    test('constructor with full library', () {
      String actual = Library(
          name: 'software_engineer',
          functions: [CalculateAgeInYearsFunction()],
          classes: [SoftWareEngineerClass(), PersonClass()]).toString();
      String expected = "library software_engineer;\n"
              "\n" +
          CalculateAgeInYearsFunction().expectedCode +
          "\n" +
          SoftWareEngineerClass().expectedCode +
          "\n" +
          PersonClass().expectedCode;
      expect(actual, expected);
    });
  });
}

// ignore: deprecated_extends_function
class CalculateAgeInYearsFunction extends DartFunction {
  CalculateAgeInYearsFunction()
      : super.withName(
          'calculateAgeInYears',
          Block([
            VariableDefinition('now',
                type: Type.ofDateTime(),
                value:
                    Expression.callConstructor(Type.ofDateTime(), name: "now")),
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
                value: Expression.ofVariable('now').getProperty('day').subtract(
                    Expression.ofVariable('dateOfBirth').getProperty('day'))),
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
          ]),
          parameters: Parameters(
              [Parameter.required('dateOfBirth', type: Type.ofDateTime())]),
        );

  String expectedCode = 'calculateAgeInYears(DateTime dateOfBirth) {\n'
      '  DateTime now = DateTime.now();\n'
      '  int years = now.year - dateOfBirth.year;\n'
      '  int months = now.month - dateOfBirth.month;\n'
      '  int days = now.day - dateOfBirth.day;\n'
      '  if (months < 0 || (months == 0 && days < 0)) {\n'
      '    years--;\n'
      '  }\n'
      '  return years;\n'
      '}\n';
}

class SoftWareEngineerClass extends Class {
  SoftWareEngineerClass()
      : super(
          'SoftWareEngineer',
          methods: [
            Method.abstract(
              'familiarProgramingLanguages',
              returnType: Type.ofList(genericType: Type.ofString()),
              propertyAccessor: PropertyAccessor.getter,
            )
          ],
          abstract: true,
        );

  String expectedCode = 'abstract class SoftWareEngineer {\n'
      '  List<String> get familiarProgramingLanguages;\n}\n';
}

class PersonClass extends Class {
  PersonClass()
      : super('Person', implements: [
          Type('SoftWareEngineer')
        ], fields: [
          Field('givenName', modifier: Modifier.final$, type: Type.ofString()),
          Field('familyName', modifier: Modifier.final$, type: Type.ofString()),
          Field('fullName', modifier: Modifier.final$, type: Type.ofString()),
          Field('dateOfBirth',
              modifier: Modifier.final$, type: Type.ofDateTime()),
          Field('familiarProgramingLanguages',
              modifier: Modifier.final$,
              type: Type.ofList(genericType: Type.ofString())),
        ], constructors: [
          Constructor(Type('Person'),
              parameters: ConstructorParameters([
                ConstructorParameter.required('givenName', this$: true),
                ConstructorParameter.required('familyName', this$: true),
                ConstructorParameter.required('dateOfBirth', this$: true),
                ConstructorParameter.required('familiarProgramingLanguages',
                    this$: true),
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
              Expression.callMethodOrFunction('calculateAgeInYears',
                  parameterValues: ParameterValues(
                      [ParameterValue(Expression.ofVariable('dateOfBirth'))])))
        ]);

  String expectedCode = 'class Person implements SoftWareEngineer {\n'
      '  final String givenName;\n'
      '  final String familyName;\n'
      '  final String fullName;\n'
      '  final DateTime dateOfBirth;\n'
      '  final List<String> familiarProgramingLanguages;\n'
      '  Person(\n'
      '    this.givenName,\n'
      '    this.familyName,\n'
      '    this.dateOfBirth,\n'
      '    this.familiarProgramingLanguages,\n'
      '  ) : fullName = \'\$givenName \$familyName\';\n'
      '  String greetingMessage() {\n'
      '    return \'Hello \$fullName.\';\n'
      '  }\n\n'
      '  get ageInYears => calculateAgeInYears(dateOfBirth);\n}\n';
}
