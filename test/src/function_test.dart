// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('Function.withoutName', () {
    test(
      'Returns a anonymous function that returns a boolean of value true',
      () {
        DartFunction.withoutName(
          Expression.ofBool(true),
          returnType: Type.ofBool(),
        ).toString().should.be(' bool ()  => true;');
      },
    );

    test(
      'Returns a anonymous function that returns a async boolean of value true',
      () {
        DartFunction.withoutName(
          Expression.callMethodOrFunction('booleanGenerator'),
          returnType: Type.ofFuture(Type.ofBool()),
          asynchrony: Asynchrony.async,
        ).toString().should.be(
          ' Future<bool> () async  => booleanGenerator();',
        );
      },
    );

    test(
      'Returns a anonymous function that returns a boolean of value true, with DocComments and Annotations',
      () {
        DartFunction.withoutName(
          Expression.ofBool(true),
          returnType: Type.ofBool(),
          docComments: [DocComment.fromString("This function returns: true")],
          annotations: [
            Annotation(
              Type('Visible'),
              ParameterValues([
                ParameterValue.named('forRole', Expression.ofString('admin')),
              ]),
            ),
            Annotation(
              Type('ExecutionMode'),
              ParameterValues([
                ParameterValue(
                  Expression.ofEnum(Type('ExecutionModes'), 'directly'),
                ),
              ]),
            ),
          ],
        ).toString().should.be(
          '/// This function returns: true\n'
          '@Visible(forRole: \'admin\')\n'
          '@ExecutionMode(ExecutionModes.directly)\n'
          ' bool ()  => true;',
        );
      },
    );
  });

  group('Function.withName', () {
    test('Returns a named function that returns a boolean of value true', () {
      DartFunction.withName(
        'returnBool',
        Expression.ofBool(true),
        returnType: Type.ofBool(),
      ).toString().should.be(' bool returnBool()  => true;');
    });

    test(
      'Returns a named function that returns a async boolean of value true',
      () {
        DartFunction.withName(
          'returnBool',
          Expression.callMethodOrFunction('booleanGenerator'),
          returnType: Type.ofFuture(Type.ofBool()),
          asynchrony: Asynchrony.async,
        ).toString().should.be(
          ' Future<bool> returnBool() async  => booleanGenerator();',
        );
      },
    );

    test(
      'Returns a named function that returns a boolean of value true, with DocComments and Annotations',
      () {
        DartFunction.withName(
          'returnTrue',
          Expression.ofBool(true),
          returnType: Type.ofBool(),
          docComments: [DocComment.fromString("This function returns: true")],
          annotations: [
            Annotation(
              Type('Visible'),
              ParameterValues([
                ParameterValue.named('forRole', Expression.ofString('admin')),
              ]),
            ),
            Annotation(
              Type('ExecutionMode'),
              ParameterValues([
                ParameterValue(
                  Expression.ofEnum(Type('ExecutionModes'), 'directly'),
                ),
              ]),
            ),
          ],
        ).toString().should.be(
          '/// This function returns: true\n'
          '@Visible(forRole: \'admin\')\n'
          '@ExecutionMode(ExecutionModes.directly)\n'
          ' bool returnTrue()  => true;',
        );
      },
    );
  });

  group('Function.main', () {
    test('Returns main function that prints hello world', () {
      DartFunction.main(
        Code("print('Hello World.');"),
      ).toString().should.be(" void main() {print('Hello World.');}");
    });

    test(
      'Returns a main function that returns a async boolean of value true',
      () {
        DartFunction.main(
          Expression.callMethodOrFunction('booleanGenerator'),
          asynchrony: Asynchrony.async,
        ).toString().should.be(' void main() async  => booleanGenerator();');
      },
    );
  });

  group('FunctionCall class', () {
    test('Should return a call to a function or method', () {
      FunctionCall('myFunction').toString().should.be("myFunction()");
    });

    test('Should return a call to a function or method with generic type', () {
      FunctionCall(
        'cast',
        genericType: Type.ofInt(),
      ).toString().should.be("cast<int>()");
    });

    test('Should return a call to a function or method with parameters', () {
      FunctionCall(
        'add',
        parameterValues: ParameterValues([
          ParameterValue(Expression.ofInt(2)),
          ParameterValue(Expression.ofInt(3)),
        ]),
      ).toString().should.be('add(2,3)');
    });

    test(
      'Should return a call to a function with parameters from another library',
      () {
        FunctionCall(
          'add',
          libraryUri: "package:test/calculations.dart",
          parameterValues: ParameterValues([
            ParameterValue(Expression.ofInt(2)),
            ParameterValue(Expression.ofInt(3)),
          ]),
        ).toString().should.be('i1.add(2,3)');
      },
    );

    test('Should throw an exception invalid name ', () {
      Should.throwError<ArgumentError>(() {
        FunctionCall('InvalidFunctionName');
      }).message.toString().should.be('Must start with an lower case letter');
    });
  });
}
