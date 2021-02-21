import 'package:dart_code/basic.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/parameter.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('RequiredParameter class', () {
    test('should result in a named parameter without type', () {
      String actual = RequiredParameter('name').toString();
      String expected = 'var name';
      expect(actual, expected);
    });

    test('should result in a named parameter with String type', () {
      String actual =
          RequiredParameter('name', type: Type.ofString()).toString();
      String expected = 'String name';
      expect(actual, expected);
    });

    test('should result in a named parameter with MyClass type', () {
      String actual = RequiredParameter('name',
              type: Type('MyClass',
                  libraryUrl: 'package:dart_code/my_class.dart'))
          .toString();
      String expected = '_i1.MyClass name';
      expect(actual, expected);
    });
  });

  group('RequiredConstructorParameter class', () {
    test('should result in a named parameter without type', () {
      String actual = RequiredConstructorParameter('name').toString();
      String expected = 'var name';
      expect(actual, expected);
    });

    test('should result in a named parameter without type with this', () {
      String actual = RequiredConstructorParameter('name',this$: true).toString();
      String expected = 'this.name';
      expect(actual, expected);
    });

    test('should result in a named parameter with String type', () {
      String actual =
      RequiredConstructorParameter('name', type: Type.ofString()).toString();
      String expected = 'String name';
      expect(actual, expected);
    });


    test('should result in a named parameter with this even given a type ', () {
      String actual =
      RequiredConstructorParameter('name', type: Type.ofString(), this$: true).toString();
      String expected = 'this.name';
      expect(actual, expected);
    });

    test('should result in a named parameter with MyClass type', () {
      String actual = RequiredConstructorParameter('name',
          type: Type('MyClass',
              libraryUrl: 'package:dart_code/my_class.dart'))
          .toString();
      String expected = '_i1.MyClass name';
      expect(actual, expected);
    });
  });

  group('OptionalParameter class', () {
    test('should result in a optional parameter without type', () {
      String actual = OptionalParameter('name').toString();
      String expected = 'var name';
      expect(actual, expected);
    });

    test('should result in a optional parameter with String type', () {
      String actual =
          OptionalParameter('name', type: Type.ofString()).toString();
      String expected = 'String name';
      expect(actual, expected);
    });

    test('should result in a optional parameter with MyClass type', () {
      String actual = OptionalParameter('name',
              type: Type('MyClass',
                  libraryUrl: 'package:dart_code/my_class.dart'))
          .toString();
      String expected = '_i1.MyClass name';
      expect(actual, expected);
    });

    test(
        'should result in a optional parameter with String type and default value "Hello World"',
        () {
      String actual = OptionalParameter('name',
              type: Type.ofString(),
              defaultValue: Expression.ofString('Hello World'))
          .toString();
      String expected = "String name = 'Hello World'";
      expect(actual, expected);
      expect(actual, expected);
    });
  });


  group('OptionalConstructorParameter class', () {
    test('should result in a optional parameter without type', () {
      String actual = OptionalConstructorParameter('name').toString();
      String expected = 'var name';
      expect(actual, expected);
    });

    test('should result in a optional parameter with this', () {
      String actual = OptionalConstructorParameter('name', this$: true).toString();
      String expected = 'this.name';
      expect(actual, expected);
    });

    test('should result in a optional parameter with String type', () {
      String actual =
      OptionalConstructorParameter('name', type: Type.ofString()).toString();
      String expected = 'String name';
      expect(actual, expected);
    });


    test('should result in a optional parameter with this even with given type', () {
      String actual =
      OptionalConstructorParameter('name', type: Type.ofString(), this$: true).toString();
      String expected = 'this.name';
      expect(actual, expected);
    });


    test('should result in a optional parameter with MyClass type', () {
      String actual = OptionalConstructorParameter('name',
          type: Type('MyClass',
              libraryUrl: 'package:dart_code/my_class.dart'))
          .toString();
      String expected = '_i1.MyClass name';
      expect(actual, expected);
    });

    test(
        'should result in a optional parameter with String type and default value "Hello World"',
            () {
          String actual = OptionalConstructorParameter('name',
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
          String actual = OptionalConstructorParameter('name',
              type: Type.ofString(),
              this$: true,
              defaultValue: Expression.ofString('Hello World'))
              .toString();
          String expected = "this.name = 'Hello World'";
          expect(actual, expected);
        });
  });

  group('NamedParameter class', () {
    test('should result in a named parameter without type', () {
      String actual = NamedParameter('name').toString();
      String expected = 'var name';
      expect(actual, expected);
    });

    test('should result in a named parameter with String type', () {
      String actual = NamedParameter('name', type: Type.ofString()).toString();
      String expected = 'String name';
      expect(actual, expected);
    });

    test('should result in a named parameter with MyClass type', () {
      String actual = NamedParameter('name',
              type: Type('MyClass',
                  libraryUrl: 'package:dart_code/my_class.dart'))
          .toString();
      String expected = '_i1.MyClass name';
      expect(actual, expected);
    });

    test(
        'should result in a named parameter with String type and default value "Hello World"',
        () {
      String actual = NamedParameter('name',
              type: Type.ofString(),
              defaultValue: Expression.ofString('Hello World'))
          .toString();
      String expected = "String name = 'Hello World'";
      expect(actual, expected);
    });

    test(
        'should result in a required named parameter with String type and default value "Hello World"',
        () {
      String actual = NamedParameter('name',
              type: Type.ofString(),
              defaultValue: Expression.ofString('Hello World'),
              required: true)
          .toString();
      String expected = "@required String name = 'Hello World'";
      expect(actual, expected);
    });
  });

  group('NamedConstructorParameter class', () {
    test('should result in a named parameter without type', () {
      String actual = NamedConstructorParameter('name').toString();
      String expected = 'var name';
      expect(actual, expected);
    });

    test('should result in a named parameter this', () {
      String actual = NamedConstructorParameter('name', this$: true).toString();
      String expected = 'this.name';
      expect(actual, expected);
    });

    test('should result in a named parameter with String type', () {
      String actual = NamedConstructorParameter('name', type: Type.ofString()).toString();
      String expected = 'String name';
      expect(actual, expected);
    });

    test('should result in a named parameter with this even with a given type', () {
      String actual = NamedConstructorParameter('name', type: Type.ofString(), this$: true).toString();
      String expected = 'this.name';
      expect(actual, expected);
    });

    test('should result in a named parameter with MyClass type', () {
      String actual = NamedConstructorParameter('name',
          type: Type('MyClass',
              libraryUrl: 'package:dart_code/my_class.dart'))
          .toString();
      String expected = '_i1.MyClass name';
      expect(actual, expected);
    });

    test(
        'should result in a named parameter with String type and default value "Hello World"',
            () {
          String actual = NamedConstructorParameter('name',
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
          String actual = NamedConstructorParameter('name',
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
          String actual = NamedConstructorParameter('name',
              type: Type.ofString(),
              this$: true,
              defaultValue: Expression.ofString('Hello World'),
              required: true)
              .toString();
          String expected = "@required this.name = 'Hello World'";
          expect(actual, expected);
        });
  });



  group('Parameters class', () {
    test('should result in no parameters', () {
      String actual = Parameters.none().toString();
      String expected = '';
      expect(actual, expected);
    });

    test('should result in no parameters', () {
      String actual = Parameters([]).toString();
      String expected = '';
      expect(actual, expected);
    });

    test('should result in a single required parameter', () {
      String actual = Parameters([RequiredParameter('required')]).toString();
      String expected = 'var required';
      expect(actual, expected);
    });

    test('should result in a double required parameter', () {
      String actual = Parameters([
        RequiredParameter('name', type: Type.ofString()),
        RequiredParameter('age', type: Type.ofInt())
      ]).toString();
      String expected = 'String name, int age';
      expect(actual, expected);
    });

    test(
        'should result in a double required parameter with double optional parameters',
        () {
      String actual = Parameters([
        RequiredParameter('name', type: Type.ofString()),
        RequiredParameter('dateOfBirth', type: Type.ofDateTime()),
        OptionalParameter('email', type: Type.ofString()),
        OptionalParameter('phoneNumber', type: Type.ofString()),
      ]).toString();
      String expected =
          'String name, DateTime dateOfBirth, [String email, String phoneNumber]';
      expect(actual, expected);
    });

    test(
        'should result in a double required parameter with double Named parameters',
        () {
      String actual = Parameters([
        RequiredParameter('name', type: Type.ofString()),
        RequiredParameter('dateOfBirth', type: Type.ofDateTime()),
        NamedParameter('email', type: Type.ofString()),
        NamedParameter('phoneNumber', type: Type.ofString()),
      ]).toString();
      String expected =
          'String name, DateTime dateOfBirth, {String email, String phoneNumber}';
      expect(actual, expected);
    });

    test('should throw an unique parameter name exception', () {
      expect(
          () => Parameters([
                RequiredParameter('name', type: Type.ofString()),
                RequiredParameter('dateOfBirth', type: Type.ofDateTime()),
                NamedParameter('email', type: Type.ofString()),
                NamedParameter('email', type: Type.ofString()),
              ]),
          throwsA((e) =>
              e is ArgumentError &&
              e.message == 'Parameter names must be unique'));
    });

    test('should throw an only OptionalParameter or NamedParameter exception',
        () {
      expect(
          () => Parameters([
                RequiredParameter('name', type: Type.ofString()),
                RequiredParameter('dateOfBirth', type: Type.ofDateTime()),
                OptionalParameter('email', type: Type.ofString()),
                NamedParameter('phoneNumber', type: Type.ofString()),
              ]),
          throwsA((e) =>
              e is ArgumentError &&
              e.message ==
                  'Parameters may not contain both optional parameters and named parameters'));
    });
  });

  group('ParameterValue class', () {
    test('should result in a String parameter value', () {
      String actual =
          ParameterValue(Expression.ofString('Hello World')).toString();
      String expected = "'Hello World'";
      expect(actual, expected);
    });
  });

  group('NamedParameterValue class', () {
    test('should result in a named String parameter value', () {
      String actual =
          NamedParameterValue('greeting', Expression.ofString('Hello World'))
              .toString();
      String expected = "greeting: 'Hello World'";
      expect(actual, expected);
    });

    test('should throw invalid name exception', () {
      expect(
          () => NamedParameterValue(
              'Greeting', Expression.ofString('Hello World')),
          throwsA((e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter'));
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
      String expected = "'James', 30";
      expect(actual, expected);
    });

    test('should result in a parameter value and named parameter', () {
      String actual = ParameterValues([
        NamedParameterValue('name', Expression.ofString("James")),
        ParameterValue(Expression.ofInt(30)),
      ]).toString();
      String expected = "30, name: 'James'";
      expect(actual, expected);
    });

    test('should result in a double named parameter values', () {
      String actual = ParameterValues([
        NamedParameterValue('name', Expression.ofString("James")),
        NamedParameterValue('age',Expression.ofInt(30)),
      ]).toString();
      String expected = "name: 'James', age: 30";
      expect(actual, expected);
    });

  });
}
