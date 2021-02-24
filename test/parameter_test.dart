import 'package:dart_code/basic.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/parameter.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Parameter class', () {
    group('Parameter.required constructor', () {
      test('should result in a named parameter without type', () {
        String actual = Parameter.required('name').toString();
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String type', () {
        String actual =
            Parameter.required('name', type: Type.ofString()).toString();
        String expected = 'String name';
        expect(actual, expected);
      });

      test('should result in a named parameter with MyClass type', () {
        String actual = Parameter.required('name',
                type: Type('MyClass',
                    libraryUrl: 'package:dart_code/my_class.dart'))
            .toString();
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });
    });

    group('Parameter.optional constructor', () {
      test('should result in a optional parameter without type', () {
        String actual = Parameter.optional('name').toString();
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with String type', () {
        String actual =
            Parameter.optional('name', type: Type.ofString()).toString();
        String expected = 'String name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with MyClass type', () {
        String actual = Parameter.optional('name',
                type: Type('MyClass',
                    libraryUrl: 'package:dart_code/my_class.dart'))
            .toString();
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });

      test(
          'should result in a optional parameter with String type and default value "Hello World"',
          () {
        String actual = Parameter.optional('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'))
            .toString();
        String expected = "String name = 'Hello World'";
        expect(actual, expected);
        expect(actual, expected);
      });
    });

    group('Parameter.named constructor', () {
      test('should result in a named parameter without type', () {
        String actual = Parameter.named('name').toString();
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String type', () {
        String actual =
            Parameter.named('name', type: Type.ofString()).toString();
        String expected = 'String name';
        expect(actual, expected);
      });

      test('should result in a named parameter with MyClass type', () {
        String actual = Parameter.named('name',
                type: Type('MyClass',
                    libraryUrl: 'package:dart_code/my_class.dart'))
            .toString();
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });

      test(
          'should result in a named parameter with String type and default value "Hello World"',
          () {
        String actual = Parameter.named('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'))
            .toString();
        String expected = "String name = 'Hello World'";
        expect(actual, expected);
      });

      test(
          'should result in a required named parameter with String type and default value "Hello World"',
          () {
        String actual = Parameter.named('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'),
                required: true)
            .toString();
        String expected = "@required String name = 'Hello World'";
        expect(actual, expected);
      });
    });
  });

  group('Parameters class', () {
    test('should result in no parameters', () {
      String actual = Parameters.empty().toString();
      String expected = '';
      expect(actual, expected);
    });

    test('should result in no parameters', () {
      String actual = Parameters([]).toString();
      String expected = '';
      expect(actual, expected);
    });

    test('should result in a single required parameter', () {
      String actual = Parameters([Parameter.required('required')]).toString();
      String expected = 'var required';
      expect(actual, expected);
    });

    test('should result in a double required parameter', () {
      String actual = Parameters([
        Parameter.required('name', type: Type.ofString()),
        Parameter.required('age', type: Type.ofInt())
      ]).toString();
      String expected = '\n'
          '  String name,\n'
          '  int age';
      expect(actual, expected);
    });

    test(
        'should result in a double required parameter with double optional parameters',
        () {
      String actual = Parameters([
        Parameter.required('name', type: Type.ofString()),
        Parameter.required('dateOfBirth', type: Type.ofDateTime()),
        Parameter.optional('email', type: Type.ofString()),
        Parameter.optional('phoneNumber', type: Type.ofString()),
      ]).toString();
      String expected =       '\n'
          '  String name,\n'
          '  DateTime dateOfBirth, [\n'
          '  String email,\n'
          '  String phoneNumber]';
      expect(actual, expected);
    });

    test(
        'should result in a double required parameter with double Named parameters',
        () {
      String actual = Parameters([
        Parameter.required('name', type: Type.ofString()),
        Parameter.required('dateOfBirth', type: Type.ofDateTime()),
        Parameter.named('email', type: Type.ofString()),
        Parameter.named('phoneNumber', type: Type.ofString()),
      ]).toString();
      String expected ='\n'
          '  String name,\n'
          '  DateTime dateOfBirth, {\n'
          '  String email,\n'
          '  String phoneNumber}';
      expect(actual, expected);
    });

    test('should throw an unique parameter name exception', () {
      expect(
          () => Parameters([
                Parameter.required('name', type: Type.ofString()),
                Parameter.required('dateOfBirth', type: Type.ofDateTime()),
                Parameter.named('email', type: Type.ofString()),
                Parameter.named('email', type: Type.ofString()),
              ]),
          throwsA((e) =>
              e is ArgumentError &&
              e.message == 'Parameter names must be unique'));
    });

    test('should throw an only Parameter.optional or Parameter.named exception',
        () {
      expect(
          () => Parameters([
                Parameter.required('name', type: Type.ofString()),
                Parameter.required('dateOfBirth', type: Type.ofDateTime()),
                Parameter.optional('email', type: Type.ofString()),
                Parameter.named('phoneNumber', type: Type.ofString()),
              ]),
          throwsA((e) =>
              e is ArgumentError &&
              e.message ==
                  'Parameters may not contain both optional parameters and named parameters'));
    });
  });

  group('ConstructorParameter class', () {
    group('ConstructorParameter.required constructor', () {
      test('should result in a named parameter without type', () {
        String actual = ConstructorParameter.required('name').toString();
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a named parameter without type with this', () {
        String actual =
            ConstructorParameter.required('name', this$: true).toString();
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String type', () {
        String actual =
            ConstructorParameter.required('name', type: Type.ofString())
                .toString();
        String expected = 'String name';
        expect(actual, expected);
      });

      test('should result in a named parameter with this even given a type ',
          () {
        String actual = ConstructorParameter.required('name',
                type: Type.ofString(), this$: true)
            .toString();
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a named parameter with MyClass type', () {
        String actual = ConstructorParameter.required('name',
                type: Type('MyClass',
                    libraryUrl: 'package:dart_code/my_class.dart'))
            .toString();
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });
    });

    group('ConstructorParameter.optional constructor', () {
      test('should result in a optional parameter without type', () {
        String actual = ConstructorParameter.optional('name').toString();
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with this', () {
        String actual =
            ConstructorParameter.optional('name', this$: true).toString();
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with String type', () {
        String actual =
            ConstructorParameter.optional('name', type: Type.ofString())
                .toString();
        String expected = 'String name';
        expect(actual, expected);
      });

      test(
          'should result in a optional parameter with this even with given type',
          () {
        String actual = ConstructorParameter.optional('name',
                type: Type.ofString(), this$: true)
            .toString();
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with MyClass type', () {
        String actual = ConstructorParameter.optional('name',
                type: Type('MyClass',
                    libraryUrl: 'package:dart_code/my_class.dart'))
            .toString();
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });

      test(
          'should result in a optional parameter with String type and default value "Hello World"',
          () {
        String actual = ConstructorParameter.optional('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'))
            .toString();
        String expected = "String name = 'Hello World'";
        expect(actual, expected);
        expect(actual, expected);
      });

      test(
          'should result in a optional parameter with this type (even with given type) and default value "Hello World"',
          () {
        String actual = ConstructorParameter.optional('name',
                type: Type.ofString(),
                this$: true,
                defaultValue: Expression.ofString('Hello World'))
            .toString();
        String expected = "this.name = 'Hello World'";
        expect(actual, expected);
      });
    });

    group('ConstructorParameter.named constructor', () {
      test('should result in a named parameter without type', () {
        String actual = ConstructorParameter.named('name').toString();
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a named parameter this', () {
        String actual =
            ConstructorParameter.named('name', this$: true).toString();
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String type', () {
        String actual =
            ConstructorParameter.named('name', type: Type.ofString())
                .toString();
        String expected = 'String name';
        expect(actual, expected);
      });

      test(
          'should result in a named parameter with this even with a given type',
          () {
        String actual = ConstructorParameter.named('name',
                type: Type.ofString(), this$: true)
            .toString();
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a named parameter with MyClass type', () {
        String actual = ConstructorParameter.named('name',
                type: Type('MyClass',
                    libraryUrl: 'package:dart_code/my_class.dart'))
            .toString();
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });

      test(
          'should result in a named parameter with String type and default value "Hello World"',
          () {
        String actual = ConstructorParameter.named('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World'))
            .toString();
        String expected = "String name = 'Hello World'";
        expect(actual, expected);
        expect(actual, expected);
      });

      test(
          'should result in a named parameter with this (even with a given type) and default value "Hello World"',
          () {
        String actual = ConstructorParameter.named('name',
                type: Type.ofString(),
                this$: true,
                defaultValue: Expression.ofString('Hello World'))
            .toString();
        String expected = "this.name = 'Hello World'";
        expect(actual, expected);
      });

      test(
          'should result in a required named parameter with this (even with a given type) and default value "Hello World"',
          () {
        String actual = ConstructorParameter.named('name',
                type: Type.ofString(),
                this$: true,
                defaultValue: Expression.ofString('Hello World'),
                required: true)
            .toString();
        String expected = "@required this.name = 'Hello World'";
        expect(actual, expected);
      });
    });
  });

  group('ConstructorParameters class', () {
    test('should result in no constructor parameters', () {
      String actual = ConstructorParameters.empty().toString();
      String expected = '';
      expect(actual, expected);
    });

    test('should result in no constructor parameters', () {
      String actual = ConstructorParameters([]).toString();
      String expected = '';
      expect(actual, expected);
    });

    test('should result in a single required constructor parameter', () {
      String actual =
          ConstructorParameters([ConstructorParameter.required('required')])
              .toString();
      String expected = 'var required';
      expect(actual, expected);
    });

    test('should result in a double required constructor parameter', () {
      String actual = ConstructorParameters([
        ConstructorParameter.required('name', type: Type.ofString()),
        ConstructorParameter.required('age', type: Type.ofInt())
      ]).toString();
      String expected = '\n'
          '  String name,\n'
          '  int age';
      expect(actual, expected);
    });

    test(
        'should result in a double required constructor parameter with double optional constructor parameters',
        () {
      String actual = ConstructorParameters([
        ConstructorParameter.required('name', type: Type.ofString()),
        ConstructorParameter.required('dateOfBirth', type: Type.ofDateTime()),
        ConstructorParameter.optional('email', type: Type.ofString()),
        ConstructorParameter.optional('phoneNumber', type: Type.ofString()),
      ]).toString();
      String expected ='\n'
          '  String name,\n'
          '  DateTime dateOfBirth, [\n'
          '  String email,\n'
          '  String phoneNumber]';
      expect(actual, expected);
    });

    test(
        'should result in a double required constructor parameter with double Named constructor parameters',
        () {
      String actual = ConstructorParameters([
        ConstructorParameter.required('name', type: Type.ofString()),
        ConstructorParameter.required('dateOfBirth', type: Type.ofDateTime()),
        ConstructorParameter.named('email', type: Type.ofString()),
        ConstructorParameter.named('phoneNumber', type: Type.ofString()),
      ]).toString();
      String expected =          '\n'
          '  String name,\n'
          '  DateTime dateOfBirth, {\n'
          '  String email,\n'
          '  String phoneNumber}';
      expect(actual, expected);
    });

    test('should throw an unique parameter name exception', () {
      expect(
          () => ConstructorParameters([
                ConstructorParameter.required('name', type: Type.ofString()),
                ConstructorParameter.required('dateOfBirth',
                    type: Type.ofDateTime()),
                ConstructorParameter.named('email', type: Type.ofString()),
                ConstructorParameter.named('email', type: Type.ofString()),
              ]),
          throwsA((e) =>
              e is ArgumentError &&
              e.message == 'Parameter names must be unique'));
    });

    test(
        'should throw an only Optional constructor Parameter or Named constructor Parameter exception',
        () {
      expect(
          () => ConstructorParameters([
                ConstructorParameter.required('name', type: Type.ofString()),
                ConstructorParameter.required('dateOfBirth',
                    type: Type.ofDateTime()),
                ConstructorParameter.optional('email', type: Type.ofString()),
                ConstructorParameter.named('phoneNumber',
                    type: Type.ofString()),
              ]),
          throwsA((e) =>
              e is ArgumentError &&
              e.message ==
                  'Parameters may not contain both optional parameters and named parameters'));
    });
  });

  group('ParameterValue class', () {
    group('ParameterValue constructor', () {
      test('should result in a String parameter value', () {
        String actual =
        ParameterValue(Expression.ofString('Hello World')).toString();
        String expected = "'Hello World'";
        expect(actual, expected);
      });
    });

    group('ParameterValue.named constructor', () {
      test('should result in a named String parameter value', () {
        String actual =
        ParameterValue.named('greeting', Expression.ofString('Hello World'))
            .toString();
        String expected = "greeting: 'Hello World'";
        expect(actual, expected);
      });

      test('should throw invalid name exception', () {
        expect(
                () => ParameterValue.named(
                'Greeting', Expression.ofString('Hello World')),
            throwsA((e) =>
            e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });
  });



  group('ParameterValues class', () {
    test('should result in no parameter values', () {
      String actual = ParameterValues.none().toString();
      String expected = '';
      expect(actual, expected);
    });

    test('should result in no parameter values', () {
      String actual = ParameterValues([]).toString();
      String expected = '';
      expect(actual, expected);
    });

    test('should result in a single parameter value', () {
      String actual =
          ParameterValues([ParameterValue(Expression.ofString('Hello World'))])
              .toString();
      String expected = "'Hello World'";
      expect(actual, expected);
    });

    test('should result in a double parameter values', () {
      String actual = ParameterValues([
        ParameterValue(Expression.ofString("James")),
        ParameterValue(Expression.ofInt(30)),
      ]).toString();
      String expected = '\n'
          '  \'James\',\n'
          '  30';
      expect(actual, expected);
    });

    test('should result in a parameter value and named parameter', () {
      String actual = ParameterValues([
        ParameterValue.named('name', Expression.ofString("James")),
        ParameterValue(Expression.ofInt(30)),
      ]).toString();
      String expected = '\n'
          '  30,\n'
          '  name: \'James\'';
      expect(actual, expected);
    });

    test('should result in a double named parameter values', () {
      String actual = ParameterValues([
        ParameterValue.named('name', Expression.ofString("James")),
        ParameterValue.named('age', Expression.ofInt(30)),
      ]).toString();
      String expected = '\n'
          '  name: \'James\',\n'
          '  age: 30';
      expect(actual, expected);
    });
  });
}
