import 'package:dart_code/annotation.dart';
import 'package:dart_code/basic.dart';
import 'package:dart_code/class.dart';
import 'package:dart_code/comment.dart';
import 'package:dart_code/constructor.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/field.dart';
import 'package:dart_code/function.dart';
import 'package:dart_code/library.dart';
import 'package:dart_code/method.dart';
import 'package:dart_code/parameter.dart';
import 'package:dart_code/statement.dart';
import 'package:dart_code/variable_definition.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Library class', () {
    test('constructor with name parameter', () {
      String actual = Library(name: 'contacts').toString();
      String expected = 'library contacts;\n'
          '\n';
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
      String actual = Library(annotations: [
        Annotation(Type('Foo'),
            ParameterValues([ParameterValue(Expression.ofInt(42))]))
      ]).toString();
      String expected = '@Foo(42)\n';
      expect(actual, expected);
    });

    test('constructor with functions parameter', () {
      String actual = Library(functions: [
        Function.withName('returnTrue', Expression.ofBool(true),
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
          'bool returnTrue() => true;\n'
          '\n';
      expect(actual, expected);
    });

    test('constructor with classes parameter', () {
      String actual = Library(classes: [
        Class('Person', fields: [
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
        ])
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
class CalculateAgeInYearsFunction extends Function {
  CalculateAgeInYearsFunction()
      : super.withName(
          'calculateAgeInYears',
          Block([
            VariableDefinition.var$('now',
                type: Type.ofDateTime(),
                value:
                    Expression.callConstructor(Type.ofDateTime(), name: "now")),
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
      '  if (months < 0 || (months == 0 && days < 0)){\n'
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
              type: Type.ofGenericList(Type.ofString()),
              propertyAccessor: PropertyAccessor.getter,
            )
          ],
          abstract: true,
        );

  String expectedCode = 'abstract class SoftWareEngineer {\n'
      '  \n'
      '  List<String> get familiarProgramingLanguages;\n'
      '  \n'
      '}\n';
}

class PersonClass extends Class {
  PersonClass()
      : super('Person', implements: [
          Type('SoftWareEngineer')
        ], fields: [
          Field.final$('givenName', type: Type.ofString()),
          Field.final$('familyName', type: Type.ofString()),
          Field.final$('fullName', type: Type.ofString()),
          Field.final$('dateOfBirth', type: Type.ofDateTime()),
          Field.final$('familiarProgramingLanguages',
              type: Type.ofGenericList(Type.ofString())),
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
              type: Type.ofString()),
          Method.getter(
              'ageInYears',
              Expression.callFunction(
                  'calculateAgeInYears',
                  ParameterValues(
                      [ParameterValue(Expression.ofVariable('dateOfBirth'))])))
        ]);

  String expectedCode = 'class Person implements SoftWareEngineer {\n'
      '  \n'
      '  final String givenName;\n'
      '  final String familyName;\n'
      '  final String fullName;\n'
      '  final DateTime dateOfBirth;\n'
      '  final List<String> familiarProgramingLanguages;\n'
      '  \n'
      '  Person(\n'
      '    this.givenName,\n'
      '    this.familyName,\n'
      '    this.dateOfBirth,\n'
      '    this.familiarProgramingLanguages) : fullName = \'\$givenName \$familyName\';\n'
      '  \n'
      '  String greetingMessage() {\n'
      '    return \'Hello \$fullName.\';\n'
      '  }\n'
      '  \n'
      '  get ageInYears => calculateAgeInYears(dateOfBirth);\n'
      '  \n'
      '}\n';
}
