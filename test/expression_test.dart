import 'package:dart_code/basic.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/parameter.dart';
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

        test('Should throws an exception invalid name ', () {
          expect(() {
            Expression.ofVariable('InvalidVariableName');
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
                  'add', ParameterValues([
                    ParameterValue(Expression.ofInt(2)),
              ParameterValue(Expression.ofInt(3))
          ]))
              .toString();
          String expected = "add(2, 3)";
          expect(actual, expected);
        });

        test('Should throws an exception invalid name ', () {
          expect(() {
            Expression.callFunction('InvalidFunctionName');
          },
              throwsA((e) =>
                  e is ArgumentError &&
                  e.message == 'Must start with an lower case letter'));
        });
      });
    });

    group('.assignVariable()', () {
      test('should result in a variable assignment', () {
        String actual = Expression.ofString('Hello World')
            .assignVariable("greeting")
            .toString();
        String expected = "var greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test('should result in a String variable assignment', () {
        String actual = Expression.ofString('Hello World')
            .assignVariable("greeting", Type.ofString())
            .toString();
        String expected = "String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test('should result in a variable assignment of type Statement', () {
        bool actual = Expression.ofString('Hello World')
            .assignVariable("greeting") is Statement;
        bool expected = true;
        expect(actual, expected);
      });

      test('should throw name exception', () {
        expect(() {
          Expression.ofString('Hello World').assignVariable("Greeting");
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });
  });
}
