// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('Parameter class', () {
    group('Parameter.required constructor', () {
      test('should result in a named parameter without type', () {
        Parameter.required('name').toString().should.be('var name');
      });

      test('should result in a named parameter with String type', () {
        Parameter.required('name', type: Type.ofString())
            .toString()
            .should
            .be('String name');
      });

      test('should result in a named parameter with String? type', () {
        Parameter.required('name', type: Type.ofString(nullable: true))
            .toString()
            .should
            .be('String? name');
      });

      test('should result in a named parameter with MyClass type', () {
        Parameter.required('name',
                type: Type('MyClass',
                    libraryUri: 'package:dart_code/my_class.dart'))
            .toString()
            .should
            .be('i1.MyClass name');
      });
    });

    group('Parameter.optional constructor', () {
      test('should result in a optional parameter without type', () {
        Parameter.optional('name').toString().should.be('var name');
      });

      test('should result in a optional parameter with String type', () {
        Parameter.optional('name', type: Type.ofString())
            .toString()
            .should
            .be('String name');
      });

      test('should result in a optional parameter with String? type', () {
        Parameter.optional('name', type: Type.ofString(nullable: true))
            .toString()
            .should
            .be('String? name');
      });

      test('should result in a optional parameter with MyClass type', () {
        Parameter.optional('name',
                type: Type('MyClass',
                    libraryUri: 'package:dart_code/my_class.dart'))
            .toString()
            .should
            .be('i1.MyClass name');
      });

      test(
          'should result in a optional parameter with String type and default value "Hello World"',
          () {
        Parameter.optional('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("String name = 'Hello World'");
      });
    });

    group('Parameter.named constructor', () {
      test('should result in a named parameter without type', () {
        Parameter.named('name').toString().should.be('var name');
      });

      test('should result in a named parameter with String type', () {
        Parameter.named('name', type: Type.ofString())
            .toString()
            .should
            .be('String name');
      });

      test('should result in a named parameter with String? type', () {
        Parameter.named('name', type: Type.ofString(nullable: true))
            .toString()
            .should
            .be('String? name');
      });

      test('should result in a named parameter with MyClass type', () {
        Parameter.named('name',
                type: Type('MyClass',
                    libraryUri: 'package:dart_code/my_class.dart'))
            .toString()
            .should
            .be('i1.MyClass name');
      });

      test(
          'should result in a named parameter with String type and default value "Hello World"',
          () {
        Parameter.named('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("String name = 'Hello World'");
      });

      test(
          'should result in a required named parameter with String type and default value "Hello World"',
          () {
        Parameter.named('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'),
                required: true)
            .toString()
            .should
            .be("required String name = 'Hello World'");
      });
    });
  });
  group('Parameters class', () {
    test('should result in no parameters', () {
      Parameters.empty().toString().should.be('');
    });

    test('should result in no parameters', () {
      Parameters([]).toString().should.be('');
    });

    test('should result in a single required parameter', () {
      Parameters([Parameter.required('required')])
          .toString()
          .should
          .be('var required');
    });

    test('should result in a double required parameter', () {
      Parameters([
        Parameter.required('name', type: Type.ofString()),
        Parameter.required('age', type: Type.ofInt())
      ]).toString().should.be('String name,int age');
    });

    test(
        'should result in a double required parameter with double optional parameters',
        () {
      Parameters([
        Parameter.required('name', type: Type.ofString()),
        Parameter.required('dateOfBirth', type: Type.ofDateTime()),
        Parameter.optional('email', type: Type.ofString()),
        Parameter.optional('phoneNumber', type: Type.ofString()),
      ]).toString().should.be(
          'String name,DateTime dateOfBirth, [String email,String phoneNumber]');
    });

    test(
        'should result in a double required parameter with double Named parameters',
        () {
      Parameters([
        Parameter.required('name', type: Type.ofString()),
        Parameter.required('dateOfBirth', type: Type.ofDateTime()),
        Parameter.named('email', type: Type.ofString()),
        Parameter.named('phoneNumber', type: Type.ofString()),
      ]).toString().should.be(
          'String name,DateTime dateOfBirth, {String email,String phoneNumber}');
    });

    test('should throw an unique parameter name exception', () {
      Should.throwError<ArgumentError>(() => Parameters([
            Parameter.required('name', type: Type.ofString()),
            Parameter.required('dateOfBirth', type: Type.ofDateTime()),
            Parameter.named('email', type: Type.ofString()),
            Parameter.named('email', type: Type.ofString()),
          ])).message.toString().should.be('Parameter names must be unique');
    });

    test('should throw an only Parameter.optional or Parameter.named exception',
        () {
      Should.throwError<ArgumentError>(() => Parameters([
                Parameter.required('name', type: Type.ofString()),
                Parameter.required('dateOfBirth', type: Type.ofDateTime()),
                Parameter.optional('email', type: Type.ofString()),
                Parameter.named('phoneNumber', type: Type.ofString()),
              ]))
          .message
          .toString()
          .should
          .be('Parameters may not contain both optional parameters and named parameters');
    });
  });

  group('ConstructorParameter class', () {
    group('ConstructorParameter.required constructor', () {
      test('should result in a named parameter without type', () {
        ConstructorParameter.required('name').toString().should.be('var name');
      });

      test('should result in a named parameter without type with this', () {
        ConstructorParameter.required('name', qualifier: Qualifier.this$)
            .toString()
            .should
            .be('this.name');
      });

      test('should result in a named parameter with String type', () {
        ConstructorParameter.required('name', type: Type.ofString())
            .toString()
            .should
            .be('String name');
      });

      test('should result in a named parameter with this even given a type ',
          () {
        ConstructorParameter.required('name',
                type: Type.ofString(), qualifier: Qualifier.super$)
            .toString()
            .should
            .be('super.name');
      });

      test('should result in a named parameter with MyClass type', () {
        ConstructorParameter.required('name',
                type: Type('MyClass',
                    libraryUri: 'package:dart_code/my_class.dart'))
            .toString()
            .should
            .be('i1.MyClass name');
      });
    });

    group('ConstructorParameter.optional constructor', () {
      test('should result in a optional parameter without type', () {
        ConstructorParameter.optional('name').toString().should.be('var name');
      });

      test('should result in a optional parameter with this', () {
        ConstructorParameter.optional('name', qualifier: Qualifier.super$)
            .toString()
            .should
            .be('super.name');
      });

      test('should result in a optional parameter with String type', () {
        ConstructorParameter.optional('name', type: Type.ofString())
            .toString()
            .should
            .be('String name');
      });

      test(
          'should result in a optional parameter with this even with given type',
          () {
        ConstructorParameter.optional('name',
                type: Type.ofString(), qualifier: Qualifier.this$)
            .toString()
            .should
            .be('this.name');
      });

      test('should result in a optional parameter with MyClass type', () {
        ConstructorParameter.optional('name',
                type: Type('MyClass',
                    libraryUri: 'package:dart_code/my_class.dart'))
            .toString()
            .should
            .be('i1.MyClass name');
      });

      test(
          'should result in a optional parameter with String type and default value "Hello World"',
          () {
        ConstructorParameter.optional('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("String name = 'Hello World'");
      });

      test(
          'should result in a optional parameter with this type (even with given type) and default value "Hello World"',
          () {
        ConstructorParameter.optional('name',
                type: Type.ofString(),
                qualifier: Qualifier.this$,
                defaultValue: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("this.name = 'Hello World'");
      });
    });

    group('ConstructorParameter.named constructor', () {
      test('should result in a named parameter without type', () {
        ConstructorParameter.named('name').toString().should.be('var name');
      });

      test('should result in a named parameter this', () {
        ConstructorParameter.named('name', qualifier: Qualifier.super$)
            .toString()
            .should
            .be('super.name');
      });

      test('should result in a named parameter with String type', () {
        ConstructorParameter.named('name', type: Type.ofString())
            .toString()
            .should
            .be('String name');
      });

      test(
          'should result in a named parameter with this even with a given type',
          () {
        ConstructorParameter.named('name',
                type: Type.ofString(), qualifier: Qualifier.this$)
            .toString()
            .should
            .be('this.name');
      });

      test('should result in a named parameter with MyClass type', () {
        ConstructorParameter.named('name',
                type: Type('MyClass',
                    libraryUri: 'package:dart_code/my_class.dart'))
            .toString()
            .should
            .be('i1.MyClass name');
      });

      test(
          'should result in a named parameter with String type and default value "Hello World"',
          () {
        ConstructorParameter.named('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("String name = 'Hello World'");
      });

      test(
          'should result in a named parameter with this (even with a given type) and default value "Hello World"',
          () {
        ConstructorParameter.named('name',
                type: Type.ofString(),
                qualifier: Qualifier.this$,
                defaultValue: Expression.ofString('Hello World'))
            .toString()
            .should
            .be("this.name = 'Hello World'");
      });

      test(
          'should result in a required named parameter with this (even with a given type) and default value "Hello World"',
          () {
        ConstructorParameter.named('name',
                type: Type.ofString(),
                qualifier: Qualifier.this$,
                defaultValue: Expression.ofString('Hello World'),
                required: true)
            .toString()
            .should
            .be("required this.name = 'Hello World'");
      });
    });
    group('ConstructorParameters class', () {
      test('should result in no constructor parameters', () {
        ConstructorParameters.empty().toString().should.be('');
      });

      test('should result in no constructor parameters', () {
        ConstructorParameters([]).toString().should.be('');
      });

      test('should result in a single required constructor parameter', () {
        ConstructorParameters([ConstructorParameter.required('required')])
            .toString()
            .should
            .be('var required');
      });

      test('should result in a double required constructor parameter', () {
        ConstructorParameters([
          ConstructorParameter.required('name', type: Type.ofString()),
          ConstructorParameter.required('age', type: Type.ofInt())
        ]).toString().should.be('String name,int age');
      });

      test(
          'should result in a double required constructor parameter with double optional constructor parameters',
          () {
        ConstructorParameters([
          ConstructorParameter.required('name', type: Type.ofString()),
          ConstructorParameter.required('dateOfBirth', type: Type.ofDateTime()),
          ConstructorParameter.optional('email', type: Type.ofString()),
          ConstructorParameter.optional('phoneNumber', type: Type.ofString()),
        ]).toString().should.be(
            'String name,DateTime dateOfBirth, [String email,String phoneNumber]');
      });

      test(
          'should result in a double required constructor parameter with double Named constructor parameters',
          () {
        ConstructorParameters([
          ConstructorParameter.required('name', type: Type.ofString()),
          ConstructorParameter.required('dateOfBirth', type: Type.ofDateTime()),
          ConstructorParameter.named('email', type: Type.ofString()),
          ConstructorParameter.named('phoneNumber', type: Type.ofString()),
        ]).toString().should.be(
            'String name,DateTime dateOfBirth, {String email,String phoneNumber}');
      });

      test('should throw an unique parameter name exception', () {
        Should.throwError<ArgumentError>(() => ConstructorParameters([
              ConstructorParameter.required('name', type: Type.ofString()),
              ConstructorParameter.required('dateOfBirth',
                  type: Type.ofDateTime()),
              ConstructorParameter.named('email', type: Type.ofString()),
              ConstructorParameter.named('email', type: Type.ofString()),
            ])).message.toString().should.be('Parameter names must be unique');
      });

      test(
          'should throw an only Optional constructor Parameter or Named constructor Parameter exception',
          () {
        Should.throwError<ArgumentError>(() => ConstructorParameters([
                  ConstructorParameter.required('name', type: Type.ofString()),
                  ConstructorParameter.required('dateOfBirth',
                      type: Type.ofDateTime()),
                  ConstructorParameter.optional('email', type: Type.ofString()),
                  ConstructorParameter.named('phoneNumber',
                      type: Type.ofString()),
                ]))
            .message
            .toString()
            .should
            .be('Parameters may not contain both optional parameters and named parameters');
      });
    });

    group('ParameterValue class', () {
      group('ParameterValue constructor', () {
        test('should result in a String parameter value', () {
          ParameterValue(Expression.ofString('Hello World'))
              .toString()
              .should
              .be("'Hello World'");
        });
      });

      group('ParameterValue.named constructor', () {
        test('should result in a named String parameter value', () {
          ParameterValue.named('greeting', Expression.ofString('Hello World'))
              .toString()
              .should
              .be("greeting: 'Hello World'");
        });

        test('should throw invalid name exception', () {
          Should.throwError<ArgumentError>(() => ParameterValue.named(
                  'Greeting', Expression.ofString('Hello World')))
              .message
              .toString()
              .should
              .be('Must start with an lower case letter');
        });
      });
    });

    group('ParameterValues class', () {
      test('should result in no parameter values', () {
        ParameterValues.none().toString().should.be('');
      });

      test('should result in no parameter values', () {
        ParameterValues([]).toString().should.be('');
      });

      test('should result in a single parameter value', () {
        ParameterValues([ParameterValue(Expression.ofString('Hello World'))])
            .toString()
            .should
            .be("'Hello World'");
      });

      test('should result in a double parameter values', () {
        ParameterValues([
          ParameterValue(Expression.ofString("James")),
          ParameterValue(Expression.ofInt(30)),
        ]).toString().should.be("'James',30");
      });

      test('should result in a parameter value and named parameter', () {
        ParameterValues([
          ParameterValue.named('name', Expression.ofString("James")),
          ParameterValue(Expression.ofInt(30)),
        ]).toString().should.be('30,name: \'James\'');
      });

      test('should result in a double named parameter values', () {
        ParameterValues([
          ParameterValue.named('name', Expression.ofString("James")),
          ParameterValue.named('age', Expression.ofInt(30)),
        ]).toString().should.be('name: \'James\',age: 30');
      });
    });
  });
}
