import 'package:dart_code/basic.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/parameter.dart';
import 'package:dart_code/statement.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Expression class', () {
    group('Constructors', () {
      test(
          'Calling named constructor .ofInt() => Returns the literal code string',
          () {
        String actual = Expression.ofInt(12).toString();
        String expected = '12';
        expect(actual, expected);
      });

      test(
          'Calling named constructor .ofDouble() => Returns the literal code string',
          () {
        String actual = Expression.ofDouble(12.12).toString();
        String expected = '12.12';
        expect(actual, expected);
      });

      test(
          'Calling named constructor .ofBool(true) => Returns the literal code string',
          () {
        String actual = Expression.ofBool(true).toString();
        String expected = 'true';
        expect(actual, expected);
      });

      test(
          'Calling named constructor .ofBool(false) => Returns the literal code string',
          () {
        String actual = Expression.ofBool(false).toString();
        String expected = 'false';
        expect(actual, expected);
      });

      test(
          'Calling named constructor .ofDateTime() => Returns the literal code string',
          () {
        var now = DateTime.now();
        String actual = Expression.ofDateTime(now).toString();
        String expected = now.toString();
        expect(actual, expected);
      });

      test(
          'Calling named constructor .ofString() => Returns the literal code string',
          () {
        String actual = Expression.ofString('Hello').toString();
        String expected = "'Hello'";
        expect(actual, expected);
      });

      test(
          'Calling named constructor .ofString() => Returns the literal code string',
          () {
        String actual = Expression.ofString('"Hello"').toString();
        String expected = '"Hello"';
        expect(actual, expected);
      });

      test(
          'Calling named constructor .ofString() => Returns the literal code string',
          () {
        String actual = Expression.ofString("'Hello'").toString();
        String expected = "'Hello'";
        expect(actual, expected);
      });

      test(
          'Calling named constructor .ofString() => Returns the literal code string',
          () {
        String actual =
            Expression.ofString('considered "normal" behavior').toString();
        String expected = "'considered \"normal\" behavior'";
        expect(actual, expected);
      });

      group('Expression.ofVariable constructor', () {
        test('Should returns the literal code variable name', () {
          String actual = Expression.ofVariable('myValue').toString();
          String expected = "myValue";
          expect(actual, expected);
        });

        test('Should throw an exception invalid name ', () {
          expect(() {
            Expression.ofVariable('InvalidVariableName');
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });

      group('Expression.callConstructor constructor', () {
        test('Should return a call to a empty constructor', () {
          String actual = Expression.callConstructor(Type('Point')).toString();
          String expected = "Point()";
          expect(actual, expected);
        });

        test('Should return a call to a constructor with parameter values', () {
          String actual = Expression.callConstructor(Type('Point'),
              parameterValues: ParameterValues([
                NamedParameterValue('x', Expression.ofInt(20)),
                NamedParameterValue('y', Expression.ofInt(30))
              ])).toString();
          String expected = "Point(x: 20, y: 30)";
          expect(actual, expected);
        });

        test('Should return a call to a empty named constructor', () {
          String actual =
              Expression.callConstructor(Type('Point'), name: 'origin')
                  .toString();
          String expected = "Point.origin()";
          expect(actual, expected);
        });

        test(
            'Should return a call to a named constructor with parameter values',
            () {
          String actual = Expression.callConstructor(Type('Point'),
              name: 'fromJson',
              parameterValues: ParameterValues([
                ParameterValue(Expression.ofVariable('json')),
              ])).toString();
          String expected = "Point.fromJson(json)";
          expect(actual, expected);
        });

        test('Should throw an exception invalid constructor name ', () {
          expect(() {
            Expression.callConstructor(Type('Point'),
                name: 'InvalidConstructorName');
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });

      group('Expression.ofEnu, constructor', () {
        test('Should return a reference to a enum value', () {
          String actual = Expression.ofEnum(Type('MyColors'), 'red').toString();
          String expected = "MyColors.red";
          expect(actual, expected);
        });

        test('Should throw an exception invalid constructor name ', () {
          expect(() {
            Expression.ofEnum(Type('MyColors'), 'InvalidEnumValue');
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });

      group('Expression.callFunction constructor', () {
        test('Should return a call to a function', () {
          String actual = Expression.callFunction('myFunction').toString();
          String expected = "myFunction()";
          expect(actual, expected);
        });

        test('Should return a call to a function with parameters', () {
          String actual = Expression.callFunction(
              'add',
              ParameterValues([
                ParameterValue(Expression.ofInt(2)),
                ParameterValue(Expression.ofInt(3))
              ])).toString();
          String expected = "add(2, 3)";
          expect(actual, expected);
        });

        test('Should throw an exception invalid name ', () {
          expect(() {
            Expression.callFunction('InvalidFunctionName');
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });
    });

    group('Fluent method for operators', () {
      test('Should return me && other', () {
        String actual = Expression.ofVariable('me')
            .and(Expression.ofVariable('other'))
            .toString();
        String expected = 'me && other';
        expect(actual, expected);
      });

      test('Should return me || other', () {
        String actual = Expression.ofVariable('me')
            .or(Expression.ofVariable('other'))
            .toString();
        String expected = 'me || other';
        expect(actual, expected);
      });

      test('Should return !me', () {
        String actual = Expression.ofVariable('me').negate().toString();
        String expected = '!me';
        expect(actual, expected);
      });

      test('Should return me as other', () {
        String actual = Expression.ofVariable('me')
            .asA(Expression.ofVariable('other'))
            .toString();
        String expected = 'me as other';
        expect(actual, expected);
      });

      test('Should return me[index]', () {
        String actual = Expression.ofVariable('me')
            .index(Expression.ofVariable('index'))
            .toString();
        String expected = 'me[index]';
        expect(actual, expected);
      });

      test('Should return me is other', () {
        String actual = Expression.ofVariable('me')
            .isA(Expression.ofVariable('other'))
            .toString();
        String expected = 'me is other';
        expect(actual, expected);
      });

      test('Should return me is! other', () {
        String actual = Expression.ofVariable('me')
            .isNotA(Expression.ofVariable('other'))
            .toString();
        String expected = 'me is! other';
        expect(actual, expected);
      });

      test('Should return me == other', () {
        String actual = Expression.ofVariable('me')
            .equalTo(Expression.ofVariable('other'))
            .toString();
        String expected = 'me == other';
        expect(actual, expected);
      });

      test('Should return me != other', () {
        String actual = Expression.ofVariable('me')
            .notEqualTo(Expression.ofVariable('other'))
            .toString();
        String expected = 'me != other';
        expect(actual, expected);
      });

      test('Should return me > other', () {
        String actual = Expression.ofVariable('me')
            .greaterThan(Expression.ofVariable('other'))
            .toString();
        String expected = 'me > other';
        expect(actual, expected);
      });

      test('Should return me < other', () {
        String actual = Expression.ofVariable('me')
            .lessThan(Expression.ofVariable('other'))
            .toString();
        String expected = 'me < other';
        expect(actual, expected);
      });

      test('Should return me >= other', () {
        String actual = Expression.ofVariable('me')
            .greaterOrEqualTo(Expression.ofVariable('other'))
            .toString();
        String expected = 'me >= other';
        expect(actual, expected);
      });

      test('Should return me <= other', () {
        String actual = Expression.ofVariable('me')
            .lessOrEqualTo(Expression.ofVariable('other'))
            .toString();
        String expected = 'me <= other';
        expect(actual, expected);
      });

      test('Should return me + other', () {
        String actual = Expression.ofVariable('me')
            .add(Expression.ofVariable('other'))
            .toString();
        String expected = 'me + other';
        expect(actual, expected);
      });

      test('Should return me - other', () {
        String actual = Expression.ofVariable('me')
            .substract(Expression.ofVariable('other'))
            .toString();
        String expected = 'me - other';
        expect(actual, expected);
      });

      test('Should return me / other', () {
        String actual = Expression.ofVariable('me')
            .divide(Expression.ofVariable('other'))
            .toString();
        String expected = 'me / other';
        expect(actual, expected);
      });

      test('Should return me * other', () {
        String actual = Expression.ofVariable('me')
            .multiply(Expression.ofVariable('other'))
            .toString();
        String expected = 'me * other';
        expect(actual, expected);
      });

      test('Should return me % other', () {
        String actual = Expression.ofVariable('me')
            .modulo(Expression.ofVariable('other'))
            .toString();
        String expected = 'me % other';
        expect(actual, expected);
      });

      test('Should return me ? whenTrue : whenFalse', () {
        String actual = Expression.ofVariable('me')
            .conditional(Expression.ofVariable('whenTrue'),
                Expression.ofVariable('whenFalse'))
            .toString();
        String expected = 'me ? whenTrue : whenFalse';
        expect(actual, expected);
      });

      test('Should return await me', () {
        String actual = Expression.ofVariable('me').awaited().toString();
        String expected = 'await me';
        expect(actual, expected);
      });

      test('Should return other ?? me', () {
        String actual = Expression.ofVariable('me')
            .ifNullThen(Expression.ofVariable('other'))
            .toString();
        String expected = 'other ?? me';
        expect(actual, expected);
      });
    });

    group('Other fluent methods', () {
      group('assignVariable() method', () {
        test("Should return: var greeting = 'Hello World';\n", () {
          String actual = Expression.ofString('Hello World')
              .assignVariable("greeting")
              .toString();
          String expected = "var greeting = 'Hello World';\n";
          expect(actual, expected);
        });

        test("Should return: var greeting ??= 'Hello World';\n", () {
          String actual = Expression.ofString('Hello World')
              .assignVariable("greeting", nullAware: true)
              .toString();
          String expected = "var greeting ??= 'Hello World';\n";
          expect(actual, expected);
        });

        test("Should return: String greeting = 'Hello World';\n", () {
          String actual = Expression.ofString('Hello World')
              .assignVariable("greeting", type:Type.ofString())
              .toString();
          String expected = "String greeting = 'Hello World';\n";
          expect(actual, expected);
        });

        test("Should return: String greeting ??= 'Hello World';\n", () {
          String actual = Expression.ofString('Hello World')
              .assignVariable("greeting", type:Type.ofString(), nullAware: true)
              .toString();
          String expected = "String greeting ??= 'Hello World';\n";
          expect(actual, expected);
        });

        test('Should return in a variable assignment of type Statement', () {
          bool actual = Expression.ofString('Hello World')
              .assignVariable("greeting") is Statement;
          bool expected = true;
          expect(actual, expected);
        });

        test('Should throw name exception', () {
          expect(() {
            Expression.ofString('Hello World').assignVariable("Greeting");
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });

      group('assignFinal() method', () {
        test('should result in a final assignment', () {
          String actual = Expression.ofString('Hello World')
              .assignFinal("greeting")
              .toString();
          String expected = "final greeting = 'Hello World';\n";
          expect(actual, expected);
        });

        test('should result in a String final assignment', () {
          String actual = Expression.ofString('Hello World')
              .assignFinal("greeting", Type.ofString())
              .toString();
          String expected = "final String greeting = 'Hello World';\n";
          expect(actual, expected);
        });

        test('should result in a final assignment of type Statement', () {
          bool actual = Expression.ofString('Hello World')
              .assignFinal("greeting") is Statement;
          bool expected = true;
          expect(actual, expected);
        });

        test('should throw name exception', () {
          expect(() {
            Expression.ofString('Hello World').assignFinal("Greeting");
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });

      group('assignConst() method', () {
        test('should result in a const assignment', () {
          String actual = Expression.ofString('Hello World')
              .assignConst("greeting")
              .toString();
          String expected = "const greeting = 'Hello World';\n";
          expect(actual, expected);
        });

        test('should result in a String const assignment', () {
          String actual = Expression.ofString('Hello World')
              .assignConst("greeting", Type.ofString())
              .toString();
          String expected = "const String greeting = 'Hello World';\n";
          expect(actual, expected);
        });

        test('should result in a const assignment of type Statement', () {
          bool actual = Expression.ofString('Hello World')
              .assignConst("greeting") is Statement;
          bool expected = true;
          expect(actual, expected);
        });

        test('should throw name exception', () {
          expect(() {
            Expression.ofString('Hello World').assignConst("Greeting");
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });

      group('callMethod() method', () {
        test('Should return a call to a method without parameter values', () {
          String actual = Expression.callConstructor(Type('AddressFinder'))
              .assignConst('findFirst')
              .toString();
          String expected = 'const findFirst = AddressFinder();\n';
          expect(actual, expected);
        });

        test('Should return a call to a method with parameter values', () {
          String actual = Expression.callConstructor(Type('AddressFinder'))
              .callMethod('find',
                  parameterValues: ParameterValues(
                      [ParameterValue(Expression.ofString("Santa's house"))]))
              .toString();
          String expected = "AddressFinder().find(\"Santa\'s house\")";
          expect(actual, expected);
        });

        test('Should return a call to 2 cascade methods', () {
          String actual = Expression.callConstructor(Type('Person'))
              .callMethod('tickle',
                  cascade: true,
                  parameterValues: ParameterValues(
                      [ParameterValue(Expression.ofString('feather'))]))
              .callMethod('kiss', cascade: true)
              .assignVariable('person')
              .toString();
          String expected = 'var person = Person()\n'
              '..tickle(\'feather\')\n'
              '..kiss();\n';
          expect(actual, expected);
        });

        test('Should throw an exception invalid name ', () {
          expect(() {
            Expression.callConstructor(Type('AddressFinder'))
                .callMethod('InvalidMethodName');
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });

      group('getProperty() method', () {
        test('Should return a get property', () {
          String actual = Expression.callConstructor(Type('Person'))
              .getProperty('name')
              .toString();
          String expected = "Person().name";
          expect(actual, expected);
        });

        test('Should return a call to 2 cascade methods', () {
          String actual = Expression.callConstructor(Type('Person'))
              .callMethod('kiss', cascade: true)
              .getProperty('cheekColor', cascade: true)
              .assignVariable('person')
              .toString();
          String expected = 'var person = Person()\n'
              '..kiss()\n'
              '..cheekColor;\n'; //makes no sense: returns a kissed Person!
          expect(actual, expected);
        });

        test('Should throw an invalid name exception', () {
          expect(() {
            Expression.callConstructor(Type('Person'))
                .getProperty('InvalidPropertyName');
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });

      group('setProperty() method', () {
        test('Should return a get property', () {
          String actual = Expression.callConstructor(Type('Person'))
              .setProperty('name', Expression.ofString('James'))
              .toString();
          String expected = "Person().name = 'James'";
          expect(actual, expected);
        });

        test('Should return a get property', () {
          String actual = Expression.callConstructor(Type('Person'))
              .setProperty('name', Expression.ofString('James'))
              .toString();
          String expected = "Person().name = 'James'";
          expect(actual, expected);
        });

        test('Should return a call to 2 cascade methods', () {
          String actual = Expression.callConstructor(Type('Person'))
              .callMethod('kiss', cascade: true)
              .setProperty(
                  'cheekColor', Expression.ofEnum(Type('CheekColors'), 'red'),
                  cascade: true)
              .assignVariable('person')
              .toString();
          String expected = 'var person = Person()\n'
              '..kiss()\n'
              '..cheekColor = CheekColors.red;\n'; //makes no sense: returns a kissed Person!
          expect(actual, expected);
        });

        test('Should throw an invalid name exception', () {
          expect(() {
            Expression.callConstructor(Type('Person')).setProperty(
                'InvalidPropertyName', Expression.ofString('Value'));
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });
    });
  });
}
