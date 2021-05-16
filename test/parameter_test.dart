import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Parameter class', () {
    group('Parameter.required constructor', () {
      test('should result in a named parameter without type', () {
        String actual = CodeFormatter().unFormatted(Parameter.required('name'));
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String type', () {
        String actual = CodeFormatter()
            .unFormatted(Parameter.required('name', type: Type.ofString()));
        String expected = 'String name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String? type', () {
        String actual = CodeFormatter().unFormatted(
            Parameter.required('name', type: Type.ofString(nullable: true)));
        String expected = 'String? name';
        expect(actual, expected);
      });

      test('should result in a named parameter with MyClass type', () {
        String actual = CodeFormatter().unFormatted(Parameter.required('name',
            type: Type('MyClass',
                libraryUri: 'package:dart_code/my_class.dart')));
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });
    });

    group('Parameter.optional constructor', () {
      test('should result in a optional parameter without type', () {
        String actual = CodeFormatter().unFormatted(Parameter.optional('name'));
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with String type', () {
        String actual = CodeFormatter()
            .unFormatted(Parameter.optional('name', type: Type.ofString()));
        String expected = 'String name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with String? type', () {
        String actual = CodeFormatter().unFormatted(
            Parameter.optional('name', type: Type.ofString(nullable: true)));
        String expected = 'String? name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with MyClass type', () {
        String actual = CodeFormatter().unFormatted(Parameter.optional('name',
            type: Type('MyClass',
                libraryUri: 'package:dart_code/my_class.dart')));
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });

      test(
          'should result in a optional parameter with String type and default value "Hello World"',
          () {
        String actual = CodeFormatter().unFormatted(Parameter.optional('name',
            type: Type.ofString(),
            defaultValue: Expression.ofString('Hello World')));
        String expected = "String name = 'Hello World'";
        expect(actual, expected);
        expect(actual, expected);
      });
    });

    group('Parameter.named constructor', () {
      test('should result in a named parameter without type', () {
        String actual = CodeFormatter().unFormatted(Parameter.named('name'));
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String type', () {
        String actual = CodeFormatter()
            .unFormatted(Parameter.named('name', type: Type.ofString()));
        String expected = 'String name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String? type', () {
        String actual = CodeFormatter().unFormatted(
            Parameter.named('name', type: Type.ofString(nullable: true)));
        String expected = 'String? name';
        expect(actual, expected);
      });

      test('should result in a named parameter with MyClass type', () {
        String actual = CodeFormatter().unFormatted(Parameter.named('name',
            type: Type('MyClass',
                libraryUri: 'package:dart_code/my_class.dart')));
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });

      test(
          'should result in a named parameter with String type and default value "Hello World"',
          () {
            String actual = CodeFormatter().unFormatted(Parameter.named('name',
            type: Type.ofString(),
            defaultValue: Expression.ofString('Hello World')));
        String expected = "String name = 'Hello World'";
        expect(actual, expected);
      });

      test(
          'should result in a required named parameter with String type and default value "Hello World"',
          () {
            String actual = CodeFormatter().unFormatted(Parameter.named('name',
            type: Type.ofString(),
            defaultValue: Expression.ofString('Hello World'),
            required: true));
        String expected = "@required String name = 'Hello World'";
        expect(actual, expected);
      });
    });
  });

  group('Parameters class', () {
    test('should result in no parameters', () {
      String actual = CodeFormatter().unFormatted(Parameters.empty());
      String expected = '';
      expect(actual, expected);
    });

    test('should result in no parameters', () {
      String actual = CodeFormatter().unFormatted(Parameters([]));
      String expected = '';
      expect(actual, expected);
    });

    test('should result in a single required parameter', () {
      String actual = CodeFormatter()
          .unFormatted(Parameters([Parameter.required('required')]));
      String expected = 'var required';
      expect(actual, expected);
    });

    test('should result in a double required parameter', () {
      String actual = CodeFormatter().unFormatted(Parameters([
        Parameter.required('name', type: Type.ofString()),
        Parameter.required('age', type: Type.ofInt())
      ]));
      String expected = 'String name,int age';
      expect(actual, expected);
    });

    test(
        'should result in a double required parameter with double optional parameters',
        () {
          String actual = CodeFormatter().unFormatted(Parameters([
        Parameter.required('name', type: Type.ofString()),
        Parameter.required('dateOfBirth', type: Type.ofDateTime()),
        Parameter.optional('email', type: Type.ofString()),
        Parameter.optional('phoneNumber', type: Type.ofString()),
      ]));
      String expected =
          'String name,DateTime dateOfBirth, [String email,String phoneNumber]';
      expect(actual, expected);
    });

    test(
        'should result in a double required parameter with double Named parameters',
        () {
          String actual = CodeFormatter().unFormatted(Parameters([
        Parameter.required('name', type: Type.ofString()),
        Parameter.required('dateOfBirth', type: Type.ofDateTime()),
        Parameter.named('email', type: Type.ofString()),
        Parameter.named('phoneNumber', type: Type.ofString()),
      ]));
      String expected =
          'String name,DateTime dateOfBirth, {String email,String phoneNumber}';
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
        String actual =
            CodeFormatter().unFormatted(ConstructorParameter.required('name'));
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a named parameter without type with this', () {
        String actual = CodeFormatter()
            .unFormatted(ConstructorParameter.required('name', this$: true));
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String type', () {
        String actual = CodeFormatter().unFormatted(
            ConstructorParameter.required('name', type: Type.ofString()));
        String expected = 'String name';
        expect(actual, expected);
      });

      test('should result in a named parameter with this even given a type ',
          () {
            String actual = CodeFormatter().unFormatted(
            ConstructorParameter.required('name',
                type: Type.ofString(), this$: true));
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a named parameter with MyClass type', () {
        String actual = CodeFormatter().unFormatted(
            ConstructorParameter.required('name',
                type: Type('MyClass',
                    libraryUri: 'package:dart_code/my_class.dart')));
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });
    });

    group('ConstructorParameter.optional constructor', () {
      test('should result in a optional parameter without type', () {
        String actual =
            CodeFormatter().unFormatted(ConstructorParameter.optional('name'));
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with this', () {
        String actual = CodeFormatter()
            .unFormatted(ConstructorParameter.optional('name', this$: true));
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with String type', () {
        String actual = CodeFormatter().unFormatted(
            ConstructorParameter.optional('name', type: Type.ofString()));
        String expected = 'String name';
        expect(actual, expected);
      });

      test(
          'should result in a optional parameter with this even with given type',
          () {
            String actual = CodeFormatter().unFormatted(
            ConstructorParameter.optional('name',
                type: Type.ofString(), this$: true));
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a optional parameter with MyClass type', () {
        String actual = CodeFormatter().unFormatted(
            ConstructorParameter.optional('name',
                type: Type('MyClass',
                    libraryUri: 'package:dart_code/my_class.dart')));
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });

      test(
          'should result in a optional parameter with String type and default value "Hello World"',
          () {
            String actual = CodeFormatter().unFormatted(
            ConstructorParameter.optional('name',
                type: Type.ofString(),
                defaultValue: Expression.ofString('Hello World')));
        String expected = "String name = 'Hello World'";
        expect(actual, expected);
        expect(actual, expected);
      });

      test(
          'should result in a optional parameter with this type (even with given type) and default value "Hello World"',
          () {
            String actual = CodeFormatter().unFormatted(
            ConstructorParameter.optional('name',
                type: Type.ofString(),
                this$: true,
                defaultValue: Expression.ofString('Hello World')));
        String expected = "this.name = 'Hello World'";
        expect(actual, expected);
      });
    });

    group('ConstructorParameter.named constructor', () {
      test('should result in a named parameter without type', () {
        String actual =
            CodeFormatter().unFormatted(ConstructorParameter.named('name'));
        String expected = 'var name';
        expect(actual, expected);
      });

      test('should result in a named parameter this', () {
        String actual = CodeFormatter()
            .unFormatted(ConstructorParameter.named('name', this$: true));
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a named parameter with String type', () {
        String actual = CodeFormatter().unFormatted(
            ConstructorParameter.named('name', type: Type.ofString()));
        String expected = 'String name';
        expect(actual, expected);
      });

      test(
          'should result in a named parameter with this even with a given type',
          () {
            String actual = CodeFormatter().unFormatted(ConstructorParameter.named(
            'name',
            type: Type.ofString(),
            this$: true));
        String expected = 'this.name';
        expect(actual, expected);
      });

      test('should result in a named parameter with MyClass type', () {
        String actual = CodeFormatter().unFormatted(ConstructorParameter.named(
            'name',
            type: Type('MyClass',
                libraryUri: 'package:dart_code/my_class.dart')));
        String expected = '_i1.MyClass name';
        expect(actual, expected);
      });

      test(
          'should result in a named parameter with String type and default value "Hello World"',
          () {
            String actual = CodeFormatter().unFormatted(ConstructorParameter.named(
            'name',
            type: Type.ofString(),
            defaultValue: Expression.ofString('Hello World')));
        String expected = "String name = 'Hello World'";
        expect(actual, expected);
        expect(actual, expected);
      });

      test(
          'should result in a named parameter with this (even with a given type) and default value "Hello World"',
          () {
            String actual = CodeFormatter().unFormatted(ConstructorParameter.named(
            'name',
            type: Type.ofString(),
            this$: true,
            defaultValue: Expression.ofString('Hello World')));
        String expected = "this.name = 'Hello World'";
        expect(actual, expected);
      });

      test(
          'should result in a required named parameter with this (even with a given type) and default value "Hello World"',
          () {
            String actual = CodeFormatter().unFormatted(ConstructorParameter.named(
            'name',
            type: Type.ofString(),
            this$: true,
            defaultValue: Expression.ofString('Hello World'),
            required: true));
        String expected = "@required this.name = 'Hello World'";
        expect(actual, expected);
      });
    });
  });

  group('ConstructorParameters class', () {
    test('should result in no constructor parameters', () {
      String actual =
          CodeFormatter().unFormatted(ConstructorParameters.empty());
      String expected = '';
      expect(actual, expected);
    });

    test('should result in no constructor parameters', () {
      String actual = CodeFormatter().unFormatted(ConstructorParameters([]));
      String expected = '';
      expect(actual, expected);
    });

    test('should result in a single required constructor parameter', () {
      String actual = CodeFormatter().unFormatted(
          ConstructorParameters([ConstructorParameter.required('required')]));
      String expected = 'var required';
      expect(actual, expected);
    });

    test('should result in a double required constructor parameter', () {
      String actual = CodeFormatter().unFormatted(ConstructorParameters([
        ConstructorParameter.required('name', type: Type.ofString()),
        ConstructorParameter.required('age', type: Type.ofInt())
      ]));
      String expected = 'String name,int age';
      expect(actual, expected);
    });

    test(
        'should result in a double required constructor parameter with double optional constructor parameters',
        () {
          String actual = CodeFormatter().unFormatted(ConstructorParameters([
        ConstructorParameter.required('name', type: Type.ofString()),
        ConstructorParameter.required('dateOfBirth', type: Type.ofDateTime()),
        ConstructorParameter.optional('email', type: Type.ofString()),
        ConstructorParameter.optional('phoneNumber', type: Type.ofString()),
      ]));
      String expected =
          'String name,DateTime dateOfBirth, [String email,String phoneNumber]';
      expect(actual, expected);
    });

    test(
        'should result in a double required constructor parameter with double Named constructor parameters',
        () {
          String actual = CodeFormatter().unFormatted(ConstructorParameters([
        ConstructorParameter.required('name', type: Type.ofString()),
        ConstructorParameter.required('dateOfBirth', type: Type.ofDateTime()),
        ConstructorParameter.named('email', type: Type.ofString()),
        ConstructorParameter.named('phoneNumber', type: Type.ofString()),
      ]));
      String expected =
          'String name,DateTime dateOfBirth, {String email,String phoneNumber}';
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
        String actual = CodeFormatter()
            .unFormatted(ParameterValue(Expression.ofString('Hello World')));
        String expected = "'Hello World'";
        expect(actual, expected);
      });
    });

    group('ParameterValue.named constructor', () {
      test('should result in a named String parameter value', () {
        String actual = CodeFormatter().unFormatted(ParameterValue.named(
            'greeting', Expression.ofString('Hello World')));
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
      String expected = '\n';
      expect(actual, expected);
    });

    test('should result in no parameter values', () {
      String actual = ParameterValues([]).toString();
      String expected = '\n';
      expect(actual, expected);
    });

    test('should result in a single parameter value', () {
      String actual = CodeFormatter().unFormatted(ParameterValues(
          [ParameterValue(Expression.ofString('Hello World'))]));
      String expected = "'Hello World'";
      expect(actual, expected);
    });

    test('should result in a double parameter values', () {
      String actual = CodeFormatter().unFormatted(ParameterValues([
        ParameterValue(Expression.ofString("James")),
        ParameterValue(Expression.ofInt(30)),
      ]));
      String expected = '\'James\',30';
      expect(actual, expected);
    });

    test('should result in a parameter value and named parameter', () {
      String actual = CodeFormatter().unFormatted(ParameterValues([
        ParameterValue.named('name', Expression.ofString("James")),
        ParameterValue(Expression.ofInt(30)),
      ]));
      String expected = '30,name: \'James\'';
      expect(actual, expected);
    });

    test('should result in a double named parameter values', () {
      String actual = CodeFormatter().unFormatted(ParameterValues([
        ParameterValue.named('name', Expression.ofString("James")),
        ParameterValue.named('age', Expression.ofInt(30)),
      ]));
      String expected = 'name: \'James\',age: 30';
      expect(actual, expected);
    });
  });
}
