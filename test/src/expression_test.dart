// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    group('Expression.ofNull() constructor', () {
      test(
          'Calling named constructor .ofNull() => Returns the literal code string',
          () {
        Expression.ofNull().toString().should.be('null');
      });

      group('Expression.ofInt() constructor', () {
        test(
            'Calling named constructor .ofInt() => Returns the literal code string',
            () {
          Expression.ofInt(12).toString().should.be('12');
        });
      });

      group('Expression.ofDouble() constructor', () {
        test(
            'Calling named constructor .ofDouble() => Returns the literal code string',
            () {
          Expression.ofDouble(12.12).toString().should.be('12.12');
        });
      });
    });

    group('Expression.ofBool() constructor', () {
      test(
          'Calling named constructor .ofBool(true) => Returns the literal code string',
          () {
        Expression.ofBool(true).toString().should.be('true');
      });

      test(
          'Calling named constructor .ofBool(false) => Returns the literal code string',
          () {
        Expression.ofBool(false).toString().should.be('false');
      });
    });

    group('Expression.ofDateTime() constructor', () {
      test(
          'Calling named constructor .ofDateTime() => Returns the literal code string',
          () {
        var now = DateTime.now();
        Expression.ofDateTime(now).toString().should.be(now.toString());
      });
    });
    group('Expression.ofString() constructor', () {
      test(
          'Calling named constructor .ofString() => Returns the literal code string',
          () {
        Expression.ofString('Hello').toString().should.be("'Hello'");
      });

      test(
          'Calling named constructor .ofString() => Returns the literal code string',
          () {
        Expression.ofString('considered "normal" behavior')
            .toString()
            .should
            .be("'considered \"normal\" behavior'");
      });
    });
    group('Expression.ofList() constructor', () {
      test('Should return: [1, 2, 3]', () {
        Expression.ofList([
          Expression.ofInt(1),
          Expression.ofInt(2),
          Expression.ofInt(3),
        ]).toString().should.be('[1,2,3]');
      });

      test('Should return: [1, 2 + 3, 3]', () {
        Expression.ofList([
          Expression.ofInt(1),
          Expression.ofInt(2).add(Expression.ofInt(3)),
          Expression.ofInt(3),
        ]).toString().should.be('[1,2 + 3,3]');
      });

      test("Should return: [\'Hello\',\'World\']'", () {
        Expression.ofList([
          Expression.ofString('Hello'),
          Expression.ofString('World'),
        ]).toString().should.be('[\'Hello\',\'World\']');
      });
    });

    group('Expression.ofSet() constructor', () {
      test('Should return: {1,2,3}', () {
        Expression.ofSet({
          Expression.ofInt(1),
          Expression.ofInt(2),
          Expression.ofInt(3),
        }).toString().should.be('{1,2,3}');
      });

      test("Should return: {1,2 + 3,3}", () {
        Expression.ofSet({
          Expression.ofInt(1),
          Expression.ofInt(2).add(Expression.ofInt(3)),
          Expression.ofInt(3),
        }).toString().should.be('{1,2 + 3,3}');
      });

      test("Should return: {\'Hello\',\'World\'}", () {
        Expression.ofSet({
          Expression.ofString('Hello'),
          Expression.ofString('World'),
        }).toString().should.be('{\'Hello\',\'World\'}');
      });
    });

    group("Expression.ofMap() constructor", () {
      test("Should return: '{1 : \'Hello\',2 : \'World\'}'", () {
        Expression.ofMap({
          Expression.ofInt(1): Expression.ofString('Hello'),
          Expression.ofInt(2): Expression.ofString('World'),
        }).toString().should.be('{1 : \'Hello\',2 : \'World\'}');
      });
    });

    group("Expression.ofRecord() constructor", () {
      test("Should return: (1,name: \'Hello\')'", () {
        Expression.ofRecord([
          RecordFieldValue(Expression.ofInt(1)),
          RecordFieldValue.named('name', Expression.ofString('Hello')),
        ]).toString().should.be('(1,name: \'Hello\')');
      });
    });

    group("Expression.ofType() constructor", () {
      test("Should return: '{1 : \'Hello\',2 : \'World\'}'", () {
        Expression.ofType(Type('Environment'))
            .getProperty('supportsDebugging')
            .toString()
            .should
            .be('Environment.supportsDebugging');
      });
    });

    group('Expression.ofVariable constructor', () {
      test('Should returns the literal code variable name', () {
        Expression.ofVariable('myValue').toString().should.be("myValue");
      });

      test('Should returns the literal code variable! name', () {
        Expression.ofVariable('myValue')
            .assertNull()
            .toString()
            .should
            .be("myValue!");
      });

      test('Should throw an exception invalid name ', () {
        Should.throwError<ArgumentError>(
                () => {Expression.ofVariable('InvalidVariableName')})
            .message
            .toString()
            .should
            .be('Must start with an lower case letter');
      });
    });

    group('Expression.callConstructor constructor', () {
      test('Should return a call to a empty constructor', () {
        Expression.callConstructor(Type('Point'))
            .toString()
            .should
            .be("Point()");
      });

      test('Should return a call to a empty constructor as a const', () {
        Expression.callConstructor(Type('Point'), isConst: true)
            .toString()
            .should
            .be("const Point()");
      });

      test('Should return a call to a constructor with parameter values', () {
        Expression.callConstructor(Type('Point'),
            parameterValues: ParameterValues([
              ParameterValue.named('x', Expression.ofInt(20)),
              ParameterValue.named('y', Expression.ofInt(30))
            ])).toString().should.be('Point(x: 20,y: 30)');
      });

      test('Should return a call to a empty named constructor', () {
        Expression.callConstructor(Type('Point'), name: 'origin')
            .toString()
            .should
            .be("Point.origin()");
      });

      test('Should return a call to a named constructor with parameter values',
          () {
        Expression.callConstructor(Type('Point'),
            name: 'fromJson',
            parameterValues: ParameterValues([
              ParameterValue(Expression.ofVariable('json')),
            ])).toString().should.be("Point.fromJson(json)");
      });

      test('Should throw an exception invalid constructor name ', () {
        Should.throwError<ArgumentError>(() {
          Expression.callConstructor(Type('Point'),
              name: 'InvalidConstructorName');
        }).message.toString().should.be('Must start with an lower case letter');
      });
    });

    group('Expression.ofEnu, constructor', () {
      test('Should return a reference to a enum value', () {
        Expression.ofEnum(Type('MyColors'), 'red')
            .toString()
            .should
            .be("MyColors.red");
      });

      test('Should throw an exception invalid constructor name ', () {
        Should.throwError<ArgumentError>(
                () => {Expression.ofEnum(Type('MyColors'), 'InvalidEnumValue')})
            .message
            .toString()
            .should
            .be('Must start with an lower case letter');
      });
    });

    group('Expression.callMethodOrFunction constructor', () {
      test('Should return a call to a function or method', () {
        Expression.callMethodOrFunction('myFunction')
            .toString()
            .should
            .be("myFunction()");
      });

      test('Should return a call to a function or method with generic type',
          () {
        Expression.callMethodOrFunction('cast', genericType: Type.ofDouble())
            .toString()
            .should
            .be("cast<double>()");
      });

      test('Should return a call to a function or method with parameters', () {
        Expression.callMethodOrFunction('add',
            parameterValues: ParameterValues([
              ParameterValue(Expression.ofInt(2)),
              ParameterValue(Expression.ofInt(3))
            ])).toString().should.be('add(2,3)');
      });

      test(
          'Should return a call to a function with parameters from another library',
          () {
        Expression.callMethodOrFunction('add',
            libraryUri: "package:test/calculations.dart",
            parameterValues: ParameterValues([
              ParameterValue(Expression.ofInt(2)),
              ParameterValue(Expression.ofInt(3))
            ])).toString().should.be('i1.add(2,3)');
      });

      test('Should throw an exception invalid name ', () {
        Should.throwError<ArgumentError>(
                () => {Expression.callMethodOrFunction('InvalidFunctionName')})
            .message
            .toString()
            .should
            .be('Must start with an lower case letter');
      });
    });

    group('Expression.ofThis() constructor', () {
      test('Should this', () {
        Expression.ofThis().toString().should.be("this");
      });
    });
    group('Expression.ofThisField() constructor', () {
      test('Should this', () {
        Expression.ofThisField('field').toString().should.be("this.field");
      });
    });

    group('Expression.ofSuper() constructor', () {
      test('Should this', () {
        Expression.ofSuper().toString().should.be("super");
      });
    });

    group('Expression.ofSuperField() constructor', () {
      test('Should this', () {
        Expression.ofSuperField('field').toString().should.be("super.field");
      });
    });

    group('Fluent method for operators', () {
      test('Should return me && other', () {
        Expression.ofVariable('me')
            .and(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me && other');
      });

      test('Should return me || other', () {
        Expression.ofVariable('me')
            .or(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me || other');
      });

      test('Should return !me', () {
        Expression.ofVariable('me').negate().toString().should.be('!me');
      });

      test('Should return me as String ', () {
        Expression.ofVariable('me')
            .asA(Type.ofString())
            .toString()
            .should
            .be('me as String ');
      });

      test('Should return me as String? ', () {
        Expression.ofVariable('me')
            .asA(Type.ofString(nullable: true))
            .toString()
            .should
            .be('me as String? ');
      });

      test('Should return me[index]', () {
        Expression.ofVariable('me')
            .index(Expression.ofVariable('index'))
            .toString()
            .should
            .be('me[index]');
      });

      test('Should return me is other', () {
        Expression.ofVariable('me')
            .isA(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me is other');
      });

      test('Should return me is! other', () {
        Expression.ofVariable('me')
            .isNotA(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me is! other');
      });

      test('Should return me == other', () {
        Expression.ofVariable('me')
            .equalTo(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me == other');
      });

      test('Should return me != other', () {
        Expression.ofVariable('me')
            .notEqualTo(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me != other');
      });

      test('Should return me > other', () {
        Expression.ofVariable('me')
            .greaterThan(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me > other');
      });

      test('Should return me < other', () {
        Expression.ofVariable('me')
            .lessThan(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me < other');
      });

      test('Should return me >= other', () {
        Expression.ofVariable('me')
            .greaterOrEqualTo(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me >= other');
      });

      test('Should return me <= other', () {
        Expression.ofVariable('me')
            .lessOrEqualTo(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me <= other');
      });

      test('Should return me + other', () {
        Expression.ofVariable('me')
            .add(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me + other');
      });

      test('Should return me - other', () {
        Expression.ofVariable('me')
            .subtract(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me - other');
      });

      test('Should return me / other', () {
        Expression.ofVariable('me')
            .divide(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me / other');
      });

      test('Should return me * other', () {
        Expression.ofVariable('me')
            .multiply(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me * other');
      });

      test('Should return me % other', () {
        Expression.ofVariable('me')
            .modulo(Expression.ofVariable('other'))
            .toString()
            .should
            .be('me % other');
      });

      test('Should return me++', () {
        Expression.ofVariable('me').increment().toString().should.be('me++');
      });

      test('Should return ++me', () {
        Expression.ofVariable('me')
            .increment(after: false)
            .toString()
            .should
            .be('++me');
      });

      test('Should return me--', () {
        Expression.ofVariable('me').decrement().toString().should.be('me--');
      });

      test('Should return --me', () {
        Expression.ofVariable('me')
            .decrement(after: false)
            .toString()
            .should
            .be('--me');
      });

      test('Should return me ? whenTrue : whenFalse', () {
        Expression.ofVariable('me')
            .conditional(Expression.ofVariable('whenTrue'),
                Expression.ofVariable('whenFalse'))
            .toString()
            .should
            .be('me ? whenTrue : whenFalse');
      });

      test("Should return 'name ?? 'Guest'", () {
        Expression.ofVariable('name')
            .ifNull(Expression.ofString('Guest'))
            .toString()
            .should
            .be("name ?? 'Guest'");
      });

      test("Should return 'name!'", () {
        Expression.ofVariable('name')
            .assertNull()
            .toString()
            .should
            .be("name!");
      });

      test('Should return await me', () {
        Expression.ofVariable('me').awaited().toString().should.be('await me');
      });
    });

    group('Other fluent methods', () {
      group('assignVariable() method', () {
        test("Should return: greeting = 'Hello World';", () {
          Expression.ofString('Hello World')
              .assignVariable("greeting")
              .toString()
              .should
              .be("greeting = 'Hello World';");
        });

        test("Should return: greeting ??= helloWorld;", () {
          Expression.ofVariable('helloWorld')
              .assignVariable("greeting", nullAware: true)
              .toString()
              .should
              .be("greeting ??= helloWorld;");
        });

        test('Should throw name exception', () {
          Should.throwError<ArgumentError>(() {
            Expression.ofString('Hello World').assignVariable("Greeting");
          })
              .message
              .toString()
              .should
              .be('Must start with an lower case letter');
        });
      });

      group('defineVariable() method', () {
        test("Should return: var greeting = 'Hello World';", () {
          Expression.ofString('Hello World')
              .defineVariable("greeting")
              .toString()
              .should
              .be("var greeting = 'Hello World';");
        });

        test("Should return: String greeting = 'Hello World';", () {
          Expression.ofString('Hello World')
              .defineVariable("greeting", type: Type.ofString())
              .toString()
              .should
              .be("String greeting = 'Hello World';");
        });

        test("Should return: static String greeting = 'Hello World';", () {
          Expression.ofString('Hello World')
              .defineVariable("greeting", type: Type.ofString(), static: true)
              .toString()
              .should
              .be("static String greeting = 'Hello World';");
        });

        test('Should throw name exception', () {
          Should.throwError<ArgumentError>(() {
            Expression.ofString('Hello World').defineVariable("Greeting");
          })
              .message
              .toString()
              .should
              .be('Must start with an lower case letter');
        });
      });

      group('defineFinal() method', () {
        test("Should return: final greeting = 'Hello World';", () {
          Expression.ofString('Hello World')
              .defineVariable("greeting", modifier: Modifier.final$)
              .toString()
              .should
              .be("final greeting = 'Hello World';");
        });

        test("Should return: final String greeting = 'Hello World';", () {
          Expression.ofString('Hello World')
              .defineVariable("greeting",
                  modifier: Modifier.final$, type: Type.ofString())
              .toString()
              .should
              .be("final String greeting = 'Hello World';");
        });

        test("Should return: static final String greeting = 'Hello World';",
            () {
          Expression.ofString('Hello World')
              .defineVariable("greeting",
                  static: true,
                  modifier: Modifier.final$,
                  type: Type.ofString())
              .toString()
              .should
              .be("static final String greeting = 'Hello World';");
        });

        test('Should throw name exception', () {
          Should.throwError<ArgumentError>(() {
            Expression.ofString('Hello World')
                .defineVariable("Greeting", modifier: Modifier.final$);
          })
              .message
              .toString()
              .should
              .be('Must start with an lower case letter');
        });
      });
      group('defineConst() method', () {
        test("Should return: const greeting = 'Hello World';", () {
          Expression.ofString('Hello World')
              .defineVariable("greeting", modifier: Modifier.const$)
              .toString()
              .should
              .be("const greeting = 'Hello World';");
        });

        test("Should return: const String greeting = 'Hello World';", () {
          Expression.ofString('Hello World')
              .defineVariable("greeting",
                  modifier: Modifier.const$, type: Type.ofString())
              .toString()
              .should
              .be("const String greeting = 'Hello World';");
        });

        test("Should return: static const String greeting = \'Hello World\';",
            () {
          Expression.ofString('Hello World')
              .defineVariable("greeting",
                  static: true,
                  modifier: Modifier.const$,
                  type: Type.ofString())
              .toString()
              .should
              .be("static const String greeting = \'Hello World\';");
        });

        test('Should throw name exception', () {
          Should.throwError<ArgumentError>(() {
            Expression.ofString('Hello World')
                .defineVariable("Greeting", modifier: Modifier.const$);
          })
              .message
              .toString()
              .should
              .be('Must start with an lower case letter');
        });
      });

      group('callMethod() method', () {
        test('Should return a call to a method without parameter values', () {
          Expression.callConstructor(Type('AddressFinder'))
              .callMethod('findFirst')
              .toString()
              .should
              .be('AddressFinder().findFirst()');
        });

        test(
            'Should return a call to a method with generic type, without parameter values',
            () {
          Expression.callConstructor(Type('MyCollection'))
              .callMethod('cast', genericType: Type.ofNum())
              .toString()
              .should
              .be('MyCollection().cast<num>()');
        });

        test(
            'Should return a call to a method without parameter values with ?. separator',
            () {
          Expression.ofVariable('address')
              .callMethod('findGpsLocation', ifNullReturnNull: true)
              .toString()
              .should
              .be('address?.findGpsLocation()');
        });

        test(
            'Should return a call to a method without parameter values with ?.. separator',
            () {
          Expression.ofVariable('address')
              .callMethod('findGpsLocation',
                  cascade: true, ifNullReturnNull: true)
              .callMethod('calculateLongitude',
                  cascade: false, ifNullReturnNull: true)
              .toString()
              .should
              .be('address?..findGpsLocation()?.calculateLongitude()');
        });

        test('Should return a call to a method with parameter values', () {
          Expression.callConstructor(Type('AddressFinder'))
              .callMethod('find',
                  parameterValues: ParameterValues(
                      [ParameterValue(Expression.ofString("Santa's house"))]))
              .toString()
              .should
              .be("AddressFinder().find(\"Santa\'s house\")");
        });

        test('Should return a call to 2 cascade methods', () {
          Expression.callConstructor(Type('Person'))
              .callMethod('tickle',
                  cascade: true,
                  parameterValues: ParameterValues(
                      [ParameterValue(Expression.ofString('feather'))]))
              .callMethod('kiss', cascade: true)
              .assignVariable('person')
              .toString()
              .should
              .be("person = Person()..tickle(\'feather\')..kiss();");
        });

        test('Should throw an exception invalid name ', () {
          Should.throwError<ArgumentError>(() {
            Expression.callConstructor(Type('AddressFinder'))
                .callMethod('InvalidMethodName');
          })
              .message
              .toString()
              .should
              .be('Must start with an lower case letter');
        });
      });

      group('getProperty() method', () {
        test('Should return a get property', () {
          Expression.callConstructor(Type('Person'))
              .getProperty('name')
              .toString()
              .should
              .be("Person().name");
        });

        test('Should get a get property with ?. separator', () {
          Expression.ofVariable('address')
              .getProperty('gpsLocation', ifNullReturnNull: true)
              .toString()
              .should
              .be('address?.gpsLocation');
        });

        test('Should return a call to 2 cascade methods', () {
          Expression.callConstructor(Type('Person'))
              .callMethod('kiss', cascade: true)
              .getProperty('cheekColor', cascade: true)
              .defineVariable('person')
              .toString()
              .should
              .be('var person = Person()..kiss()..cheekColor;');
        });

        test('Should get a get property with ?.. separator', () {
          Expression.ofVariable('address')
              .getProperty('gpsLocation', cascade: true, ifNullReturnNull: true)
              .getProperty('longitude', cascade: false, ifNullReturnNull: true)
              .toString()
              .should
              .be('address?..gpsLocation?.longitude');
        });

        test('Should throw an invalid name exception', () {
          Should.throwError<ArgumentError>(() {
            Expression.callConstructor(Type('Person'))
                .getProperty('InvalidPropertyName');
          })
              .message
              .toString()
              .should
              .be('Must start with an lower case letter');
        });
      });

      group('setProperty() method', () {
        test('Should return a get property', () {
          Expression.callConstructor(Type('Person'))
              .setProperty('name', Expression.ofString('James'))
              .toString()
              .should
              .be("Person().name = 'James'");
        });

        test('Should return a get property', () {
          Expression.callConstructor(Type('Person'))
              .setProperty('name', Expression.ofString('James'))
              .toString()
              .should
              .be("Person().name = 'James'");
        });

        test('Should return a call to 2 cascade methods', () {
          Expression.callConstructor(Type('Person'))
              .callMethod('kiss', cascade: true)
              .setProperty(
                  'cheekColor', Expression.ofEnum(Type('CheekColors'), 'red'),
                  cascade: true)
              .assignVariable('person')
              .toString()
              .should
              .be('person = Person()..kiss()..cheekColor = CheekColors.red;');
        });

        test('Should throw an invalid name exception', () {
          Should.throwError<ArgumentError>(() {
            Expression.callConstructor(Type('Person')).setProperty(
                'InvalidPropertyName', Expression.ofString('Value'));
          })
              .message
              .toString()
              .should
              .be('Must start with an lower case letter');
        });
      });
    });
  });
}
