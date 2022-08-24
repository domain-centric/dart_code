import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Constructors', () {
    group('Expression.ofNull() constructor', () {
      test(
          'Calling named constructor .ofNull() => Returns the literal code string',
          () {
        String actual = CodeFormatter().unFormatted(Expression.ofNull());
        String expected = 'null';
        expect(actual, expected);
      });
    });

    group('Expression.ofInt() constructor', () {
      test(
          'Calling named constructor .ofInt() => Returns the literal code string',
          () {
        String actual = CodeFormatter().unFormatted(Expression.ofInt(12));
        String expected = '12';
        expect(actual, expected);
      });
    });

    group('Expression.ofDouble() constructor', () {
      test(
          'Calling named constructor .ofDouble() => Returns the literal code string',
              () {
            String actual = CodeFormatter().unFormatted(Expression.ofDouble(12.12));
            String expected = '12.12';
            expect(actual, expected);
          });
    });

    group('Expression.ofBool() constructor', () {
      test(
          'Calling named constructor .ofBool(true) => Returns the literal code string',
              () {
            String actual = CodeFormatter().unFormatted(Expression.ofBool(true));
            String expected = 'true';
            expect(actual, expected);
          });

      test(
          'Calling named constructor .ofBool(false) => Returns the literal code string',
              () {
            String actual = CodeFormatter().unFormatted(Expression.ofBool(false));
            String expected = 'false';
            expect(actual, expected);
          });
    });

    group('Expression.ofDateTime() constructor', () {
      test(
          'Calling named constructor .ofDateTime() => Returns the literal code string',
              () {
            var now = DateTime.now();
            String actual = CodeFormatter().unFormatted(Expression.ofDateTime(now));
            String expected = now.toString();
            expect(actual, expected);
          });
    });

    group('Expression.ofString() constructor', () {
      test(
          'Calling named constructor .ofString() => Returns the literal code string',
              () {
            String actual =
            CodeFormatter().unFormatted(Expression.ofString('Hello'));
            String expected = "'Hello'";
            expect(actual, expected);
          });

      test(
          'Calling named constructor .ofString() => Returns the literal code string',
              () {
            String actual =
            CodeFormatter().unFormatted(Expression.ofString('"Hello"'));
            String expected = '"Hello"';
            expect(actual, expected);
          });

      test(
          'Calling named constructor .ofString() => Returns the literal code string',
              () {
            String actual =
            CodeFormatter().unFormatted(Expression.ofString("'Hello'"));
            String expected = "'Hello'";
            expect(actual, expected);
          });

      test(
          'Calling named constructor .ofString() => Returns the literal code string',
              () {
            String actual = CodeFormatter()
                .unFormatted(Expression.ofString('considered "normal" behavior'));
            String expected = "'considered \"normal\" behavior'";
            expect(actual, expected);
          });
    });

    group('Expression.ofList() constructor', () {
      test('Should return: [1, 2, 3]', () {
        String actual = CodeFormatter().unFormatted(Expression.ofList([
          Expression.ofInt(1),
          Expression.ofInt(2),
          Expression.ofInt(3),
        ]));
        String expected = '[1,2,3]';
        expect(actual, expected);
      });

      test('Should return: [1, 2 + 3, 3]', () {
        String actual = CodeFormatter().unFormatted(Expression.ofList([
          Expression.ofInt(1),
          Expression.ofInt(2).add(Expression.ofInt(3)),
          Expression.ofInt(3),
        ]));
        String expected = '[1,2 + 3,3]';
        expect(actual, expected);
      });

      test("Should return: [\'Hello\',\'World\']'", () {
        String actual = CodeFormatter().unFormatted(Expression.ofList([
          Expression.ofString('Hello'),
          Expression.ofString('World'),
        ]));
        String expected = '[\'Hello\',\'World\']';
        expect(actual, expected);
      });
    });

    group('Expression.ofSet() constructor', () {
      test('Should return: {1,2,3}', () {
        String actual = CodeFormatter().unFormatted(Expression.ofSet({
          Expression.ofInt(1),
          Expression.ofInt(2),
          Expression.ofInt(3),
        }));
        String expected = '{1,2,3}';
        expect(actual, expected);
      });

      test("Should return: {1,2 + 3,3}", () {
        String actual = CodeFormatter().unFormatted(Expression.ofSet({
          Expression.ofInt(1),
          Expression.ofInt(2).add(Expression.ofInt(3)),
          Expression.ofInt(3),
        }));
        String expected = '{1,2 + 3,3}';
        expect(actual, expected);
      });

      test("Should return: {\'Hello\',\'World\'}", () {
        String actual = CodeFormatter().unFormatted(Expression.ofSet({
          Expression.ofString('Hello'),
          Expression.ofString('World'),
        }));
        String expected = '{\'Hello\',\'World\'}';
        expect(actual, expected);
      });
    });

    group("Expression.ofMap() constructor", () {
      test("Should return: '{1 : \'Hello\',2 : \'World\'}'", () {
        String actual = CodeFormatter().unFormatted(Expression.ofMap({
          Expression.ofInt(1): Expression.ofString('Hello'),
          Expression.ofInt(2): Expression.ofString('World'),
        }));
        String expected = '{1 : \'Hello\',2 : \'World\'}';
        expect(actual, expected);
      });
    });

    group('Expression.ofVariable constructor', () {
      test('Should returns the literal code variable name', () {
        String actual =
        CodeFormatter().unFormatted(Expression.ofVariable('myValue'));
        String expected = "myValue";
        expect(actual, expected);
      });

      test('Should returns the literal code variable! name', () {
        String actual = CodeFormatter()
            .unFormatted(Expression.ofVariable('myValue', assertNull: true));
        String expected = "myValue!";
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
        String actual = CodeFormatter()
            .unFormatted(Expression.callConstructor(Type('Point')));
        String expected = "Point()";
        expect(actual, expected);
      });

      test('Should return a call to a constructor with parameter values', () {
        String actual = CodeFormatter()
            .unFormatted(Expression.callConstructor(Type('Point'),
            parameterValues: ParameterValues([
              ParameterValue.named('x', Expression.ofInt(20)),
              ParameterValue.named('y', Expression.ofInt(30))
            ])));
        String expected = 'Point(x: 20,y: 30)';
        expect(actual, expected);
      });

      test('Should return a call to a empty named constructor', () {
        String actual = CodeFormatter().unFormatted(
            Expression.callConstructor(Type('Point'), name: 'origin'));
        String expected = "Point.origin()";
        expect(actual, expected);
      });

      test('Should return a call to a named constructor with parameter values',
              () {
            String actual = CodeFormatter()
                .unFormatted(Expression.callConstructor(Type('Point'),
                name: 'fromJson',
                parameterValues: ParameterValues([
                  ParameterValue(Expression.ofVariable('json')),
                ])));
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
        String actual = CodeFormatter()
            .unFormatted(Expression.ofEnum(Type('MyColors'), 'red'));
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
        String actual =
        CodeFormatter().unFormatted(Expression.callFunction('myFunction'));
        String expected = "myFunction()";
        expect(actual, expected);
      });

      test('Should return a call to a function with parameters', () {
        String actual = CodeFormatter().unFormatted(Expression.callFunction(
            'add',
            parameterValues: ParameterValues([
              ParameterValue(Expression.ofInt(2)),
              ParameterValue(Expression.ofInt(3))
            ])));
        String expected = 'add(2,3)';
        expect(actual, expected);
      });

      test(
          'Should return a call to a function with parameters from another library',
              () {
            String actual = CodeFormatter().unFormatted(Expression.callFunction(
                'add',
                libraryUri: "package:test/calculations.dart",
                parameterValues: ParameterValues([
                  ParameterValue(Expression.ofInt(2)),
                  ParameterValue(Expression.ofInt(3))
                ])));
            String expected = 'i1.add(2,3)';
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

    group('Expression.ofThis() constructor', () {
      test('Should this', () {
        String actual = CodeFormatter().unFormatted(Expression.ofThis());
        String expected = "this";
        expect(actual, expected);
      });
    });

    group('Expression.ofThisField() constructor', () {
      test('Should this', () {
        String actual =
        CodeFormatter().unFormatted(Expression.ofThisField('field'));
        String expected = "this.field";
        expect(actual, expected);
      });
    });

    group('Expression.ofSuper() constructor', () {
      test('Should this', () {
        String actual = CodeFormatter().unFormatted(Expression.ofSuper());
        String expected = "super";
        expect(actual, expected);
      });
    });

    group('Expression.ofSuperField() constructor', () {
      test('Should this', () {
        String actual =
        CodeFormatter().unFormatted(Expression.ofSuperField('field'));
        String expected = "super.field";
        expect(actual, expected);
      });
    });
  });

  group('Fluent method for operators', () {
    test('Should return me && other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').and(Expression.ofVariable('other')));
      String expected = 'me && other';
      expect(actual, expected);
    });

    test('Should return me || other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').or(Expression.ofVariable('other')));
      String expected = 'me || other';
      expect(actual, expected);
    });

    test('Should return !me', () {
      String actual =
          CodeFormatter().unFormatted(Expression.ofVariable('me').negate());
      String expected = '!me';
      expect(actual, expected);
    });

    test('Should return me as other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').asA(Expression.ofVariable('other')));
      String expected = 'me as other';
      expect(actual, expected);
    });

    test('Should return me[index]', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').index(Expression.ofVariable('index')));
      String expected = 'me[index]';
      expect(actual, expected);
    });

    test('Should return me is other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').isA(Expression.ofVariable('other')));
      String expected = 'me is other';
      expect(actual, expected);
    });

    test('Should return me is! other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').isNotA(Expression.ofVariable('other')));
      String expected = 'me is! other';
      expect(actual, expected);
    });

    test('Should return me == other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').equalTo(Expression.ofVariable('other')));
      String expected = 'me == other';
      expect(actual, expected);
    });

    test('Should return me != other', () {
      String actual = CodeFormatter().unFormatted(Expression.ofVariable('me')
          .notEqualTo(Expression.ofVariable('other')));
      String expected = 'me != other';
      expect(actual, expected);
    });

    test('Should return me > other', () {
      String actual = CodeFormatter().unFormatted(Expression.ofVariable('me')
          .greaterThan(Expression.ofVariable('other')));
      String expected = 'me > other';
      expect(actual, expected);
    });

    test('Should return me < other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').lessThan(Expression.ofVariable('other')));
      String expected = 'me < other';
      expect(actual, expected);
    });

    test('Should return me >= other', () {
      String actual = CodeFormatter().unFormatted(Expression.ofVariable('me')
          .greaterOrEqualTo(Expression.ofVariable('other')));
      String expected = 'me >= other';
      expect(actual, expected);
    });

    test('Should return me <= other', () {
      String actual = CodeFormatter().unFormatted(Expression.ofVariable('me')
          .lessOrEqualTo(Expression.ofVariable('other')));
      String expected = 'me <= other';
      expect(actual, expected);
    });

    test('Should return me + other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').add(Expression.ofVariable('other')));
      String expected = 'me + other';
      expect(actual, expected);
    });

    test('Should return me - other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').subtract(Expression.ofVariable('other')));
      String expected = 'me - other';
      expect(actual, expected);
    });

    test('Should return me / other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').divide(Expression.ofVariable('other')));
      String expected = 'me / other';
      expect(actual, expected);
    });

    test('Should return me * other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').multiply(Expression.ofVariable('other')));
      String expected = 'me * other';
      expect(actual, expected);
    });

    test('Should return me % other', () {
      String actual = CodeFormatter().unFormatted(
          Expression.ofVariable('me').modulo(Expression.ofVariable('other')));
      String expected = 'me % other';
      expect(actual, expected);
    });

    test('Should return me++', () {
      String actual =
          CodeFormatter().unFormatted(Expression.ofVariable('me').increment());
      String expected = 'me++';
      expect(actual, expected);
    });

    test('Should return ++me', () {
      String actual = CodeFormatter()
          .unFormatted(Expression.ofVariable('me').increment(after: false));
      String expected = '++me';
      expect(actual, expected);
    });

    test('Should return me--', () {
      String actual =
          CodeFormatter().unFormatted(Expression.ofVariable('me').decrement());
      String expected = 'me--';
      expect(actual, expected);
    });

    test('Should return --me', () {
      String actual = CodeFormatter()
          .unFormatted(Expression.ofVariable('me').decrement(after: false));
      String expected = '--me';
      expect(actual, expected);
    });

    test('Should return me ? whenTrue : whenFalse', () {
      String actual = CodeFormatter().unFormatted(Expression.ofVariable('me')
          .conditional(Expression.ofVariable('whenTrue'),
              Expression.ofVariable('whenFalse')));
      String expected = 'me ? whenTrue : whenFalse';
      expect(actual, expected);
    });

    test('Should return await me', () {
      String actual =
          CodeFormatter().unFormatted(Expression.ofVariable('me').awaited());
      String expected = 'await me';
      expect(actual, expected);
    });

    test('Should return other ?? me', () {
      String actual = CodeFormatter().unFormatted(Expression.ofVariable('me')
          .ifNullThen(Expression.ofVariable('other')));
      String expected = 'other ?? me';
      expect(actual, expected);
    });
  });

  group('Other fluent methods', () {
    group('assignVariable() method', () {
      test("Should return: greeting = 'Hello World';", () {
        String actual = CodeFormatter().unFormatted(
            Expression.ofString('Hello World').assignVariable("greeting"));
        String expected = "greeting = 'Hello World';";
        expect(actual, expected);
      });

      test("Should return: greeting ??= helloWorld;", () {
        String actual = CodeFormatter().unFormatted(
            Expression.ofVariable('helloWorld')
                .assignVariable("greeting", nullAware: true));
        String expected = "greeting ??= helloWorld;";
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

    group('defineVariable() method', () {
      test("Should return: var greeting = 'Hello World';\n", () {
        String actual = Expression.ofString('Hello World')
            .defineVariable("greeting")
            .toString();
        String expected = "var greeting = \'Hello World\';\n";
        expect(actual, expected);
      });

      test("Should return: String greeting = \'Hello World\';\n", () {
        String actual = Expression.ofString('Hello World')
            .defineVariable("greeting", type: Type.ofString())
            .toString();
        String expected = "String greeting = \'Hello World\';\n";
        expect(actual, expected);
      });

      test("Should return: static String greeting = \'Hello World\';", () {
        String actual = CodeFormatter().unFormatted(
            Expression.ofString('Hello World').defineVariable("greeting",
                type: Type.ofString(), static: true));
        String expected = "static String greeting = \'Hello World\';";
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          Expression.ofString('Hello World').defineVariable("Greeting");
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });
    group('defineFinal() method', () {
      test("Should return: final greeting = 'Hello World';\n", () {
        String actual = Expression.ofString('Hello World')
            .defineVariable("greeting", modifier: Modifier.final$)
            .toString();
        String expected = "final greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: final String greeting = 'Hello World';\n", () {
        String actual = Expression.ofString('Hello World')
            .defineVariable("greeting",
                modifier: Modifier.final$, type: Type.ofString())
            .toString();
        String expected = "final String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: static final String greeting = \'Hello World\';",
          () {
        String actual = CodeFormatter().unFormatted(
            Expression.ofString('Hello World').defineVariable("greeting",
                static: true,
                modifier: Modifier.final$,
                type: Type.ofString()));
        String expected = "static final String greeting = \'Hello World\';";
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          Expression.ofString('Hello World')
              .defineVariable("Greeting", modifier: Modifier.final$);
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('defineConst() method', () {
      test("Should return: const greeting = 'Hello World';\n", () {
        String actual = Expression.ofString('Hello World')
            .defineVariable("greeting", modifier: Modifier.const$)
            .toString();
        String expected = "const greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: const String greeting = 'Hello World';\n", () {
        String actual = Expression.ofString('Hello World')
            .defineVariable("greeting",
                modifier: Modifier.const$, type: Type.ofString())
            .toString();
        String expected = "const String greeting = 'Hello World';\n";
        expect(actual, expected);
      });

      test("Should return: static const String greeting = \'Hello World\';",
          () {
        String actual = CodeFormatter().unFormatted(
            Expression.ofString('Hello World').defineVariable("greeting",
                static: true,
                modifier: Modifier.const$,
                type: Type.ofString()));
        String expected = "static const String greeting = \'Hello World\';";
        expect(actual, expected);
      });

      test('Should throw name exception', () {
        expect(() {
          Expression.ofString('Hello World')
              .defineVariable("Greeting", modifier: Modifier.const$);
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });

    group('callMethod() method', () {
      test('Should return a call to a method without parameter values', () {
        String actual = CodeFormatter().unFormatted(
            Expression.callConstructor(Type('AddressFinder'))
                .callMethod('findFirst'));
        String expected = 'AddressFinder().findFirst()';
        expect(actual, expected);
      });

      test('Should return a call to a method with parameter values', () {
        String actual = CodeFormatter().unFormatted(
            Expression.callConstructor(Type('AddressFinder')).callMethod('find',
                parameterValues: ParameterValues(
                    [ParameterValue(Expression.ofString("Santa's house"))])));
        String expected = "AddressFinder().find(\"Santa\'s house\")";
        expect(actual, expected);
      });

      test('Should return a call to 2 cascade methods', () {
        String actual = CodeFormatter().unFormatted(
            Expression.callConstructor(Type('Person'))
                .callMethod('tickle',
                    cascade: true,
                    parameterValues: ParameterValues(
                        [ParameterValue(Expression.ofString('feather'))]))
                .callMethod('kiss', cascade: true)
                .assignVariable('person'));
        String expected = "person = Person()..tickle(\'feather\')..kiss();";
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
        String actual = CodeFormatter().unFormatted(
            Expression.callConstructor(Type('Person')).getProperty('name'));
        String expected = "Person().name";
        expect(actual, expected);
      });

      test('Should return a call to 2 cascade methods', () {
        String actual = CodeFormatter().unFormatted(
            Expression.callConstructor(Type('Person'))
                .callMethod('kiss', cascade: true)
                .getProperty('cheekColor', cascade: true)
                .defineVariable('person'));
        String expected =
            'var person = Person()..kiss()..cheekColor;'; //makes no sense: returns a kissed Person!
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
        String actual = CodeFormatter().unFormatted(
            Expression.callConstructor(Type('Person'))
                .setProperty('name', Expression.ofString('James')));
        String expected = "Person().name = 'James'";
        expect(actual, expected);
      });

      test('Should return a get property', () {
        String actual = CodeFormatter().unFormatted(
            Expression.callConstructor(Type('Person'))
                .setProperty('name', Expression.ofString('James')));
        String expected = "Person().name = 'James'";
        expect(actual, expected);
      });

      test('Should return a call to 2 cascade methods', () {
        String actual = CodeFormatter().unFormatted(
            Expression.callConstructor(Type('Person'))
                .callMethod('kiss', cascade: true)
                .setProperty(
                    'cheekColor', Expression.ofEnum(Type('CheekColors'), 'red'),
                    cascade: true)
                .assignVariable('person'));
        String expected =
            'person = Person()..kiss()..cheekColor = CheekColors.red;'; //makes no sense: returns a kissed Person!
        expect(actual, expected);
      });

      test('Should throw an invalid name exception', () {
        expect(() {
          Expression.callConstructor(Type('Person'))
              .setProperty('InvalidPropertyName', Expression.ofString('Value'));
        },
            throwsA((e) =>
                e is ArgumentError &&
                e.message == 'Must start with an lower case letter'));
      });
    });
  });
}
