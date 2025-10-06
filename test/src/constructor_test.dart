// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('ConstructorCall class', () {
    test("Should return: this()", () {
      ConstructorCall().toString().should.be('this()');
    });

    test("Should return: this.origin()", () {
      ConstructorCall(name: 'origin').toString().should.be('this.origin()');
    });

    test("Should throw invalid name exception", () {
      Should.throwError<ArgumentError>(
        () => {ConstructorCall(name: 'InvalidConstructorName').toString()},
      ).message.toString().should.be('Must start with an lower case letter');
    });

    test("Should return: this.point(x: 5, y: 10)", () {
      ConstructorCall(
        name: 'point',
        parameterValues: ParameterValues([
          ParameterValue.named('x', Expression.ofInt(5)),
          ParameterValue.named('y', Expression.ofInt(10)),
        ]),
      ).toString().should.be('this.point(x: 5,y: 10)');
    });

    test("Should return: super()", () {
      ConstructorCall(super$: true).toString().should.be('super()');
    });

    test("Should return: super.origin()", () {
      ConstructorCall(
        name: 'origin',
        super$: true,
      ).toString().should.be('super.origin()');
    });

    test("Should throw invalid name exception", () {
      Should.throwError<ArgumentError>(
        () => {
          ConstructorCall(
            name: 'InvalidConstructorName',
            super$: true,
          ).toString(),
        },
      ).message.toString().should.be('Must start with an lower case letter');
    });

    test("Should return: super.point(x: 5, y: 10)", () {
      ConstructorCall(
        name: 'point',
        super$: true,
        parameterValues: ParameterValues([
          ParameterValue.named('x', Expression.ofInt(5)),
          ParameterValue.named('y', Expression.ofInt(10)),
        ]),
      ).toString().should.be('super.point(x: 5,y: 10)');
    });
  });

  group('Initializer class', () {
    test("Should return: name = 'Nils', age = 30", () {
      FieldInitializer(
        'name',
        Expression.ofString('Nils'),
      ).toString().should.be('name = \'Nils\'');
    });
  });

  group('Initializers class', () {
    test("Should return: name = 'Nils', age = 30", () {
      Initializers(
        fieldInitializers: [
          FieldInitializer('name', Expression.ofString('Nils')),
          FieldInitializer('age', Expression.ofInt(30)),
        ],
      ).toString().should.be('name = \'Nils\',age = 30');
    });

    test("Should throw parameter value names not unique exception", () {
      Should.throwError<ArgumentError>(
        () => {
          Initializers(
            fieldInitializers: [
              FieldInitializer('name', Expression.ofString('Nils')),
              FieldInitializer('name', Expression.ofString('Bianca')),
            ],
          ).toString(),
        },
      ).message.toString().should.be('Field names must be unique');
    });

    test("Should return: name = 'Nils', age = 30", () {
      Initializers(
        fieldInitializers: [
          FieldInitializer('name', Expression.ofString('Nils')),
          FieldInitializer('age', Expression.ofInt(30)),
        ],
      ).toString().should.be('name = \'Nils\',age = 30');
    });

    test("gender = Gender.male, age = 30, super(name = 'Nils')", () {
      Initializers(
        fieldInitializers: [
          FieldInitializer('gender', Expression.ofEnum(Type('Gender'), 'male')),
          FieldInitializer('age', Expression.ofInt(30)),
        ],
        constructorCall: ConstructorCall(
          super$: true,
          parameterValues: ParameterValues([
            ParameterValue.named('name', Expression.ofString('Nils')),
          ]),
        ),
      ).toString().should.be(
        'gender = Gender.male,age = 30,super(name: \'Nils\')',
      );
    });
  });

  group('Constructor class', () {
    test("Should return: Person();", () {
      Constructor(Type('Person')).toString().should.be('Person();');
    });

    test("Should return: Constructor with annotation", () {
      Constructor(
        Type('Person'),
        annotations: [
          Annotation(
            Type(
              'JsonSerializable',
              libraryUri: 'package:json_annotation/json_annotation.dart',
            ),
          ),
        ],
      ).toString().should.be(
        '@i1.JsonSerializable()\n'
        'Person();',
      );
    });

    test("Should return: Constructor with doc comment", () {
      Constructor(
        Type('Person'),
        docComments: [
          DocComment.fromString(
            'A Person that can be converted to and from Json format',
          ),
        ],
      ).toString().should.be(
        '/// A Person that can be converted to and from Json format\n'
        'Person();',
      );
    });

    test("Should return: Constructor with doc comment and annotation", () {
      Constructor(
        Type('Person'),
        docComments: [
          DocComment.fromString(
            'A Person that can be converted to and from Json format',
          ),
        ],
        annotations: [
          Annotation(
            Type(
              'JsonSerializable',
              libraryUri: 'package:json_annotation/json_annotation.dart',
            ),
          ),
        ],
      ).toString().should.be(
        '/// A Person that can be converted to and from Json format\n'
        '@i1.JsonSerializable()\n'
        'Person();',
      );
    });

    test("Should return: external Person();", () {
      Constructor(
        Type('Person'),
        external: true,
      ).toString().should.be('external Person();');
    });

    test("Should return: const Person();\n", () {
      Constructor(
        Type('Person'),
        constant: true,
      ).toString().should.be('const Person();');
    });

    test("Should return: factory Person();\n", () {
      Constructor(
        Type('Person'),
        factory: true,
      ).toString().should.be('factory Person();');
    });

    test("Should return: factory Point.origin();\n", () {
      Constructor(
        Type('Point'),
        name: 'origin',
        factory: true,
      ).toString().should.be('factory Point.origin();');
    });

    test("Should return: Point.(int x, int y);\n", () {
      Constructor(
        Type('Point'),
        parameters: ConstructorParameters([
          ConstructorParameter.required('x', type: Type.ofInt()),
          ConstructorParameter.required('y', type: Type.ofInt()),
        ]),
      ).toString().should.be('Point(int x,int y);');
    });

    test("Should return: Point.origin() : x = 0, y = 0;\n", () {
      Constructor(
        Type('Point'),
        name: 'origin',
        initializers: Initializers(
          fieldInitializers: [
            FieldInitializer('x', Expression.ofInt(0)),
            FieldInitializer('y', Expression.ofInt(0)),
          ],
        ),
      ).toString().should.be('Point.origin() : x = 0,y = 0;');
    });

    test("Should return: Point.origin() : this(x : 0, y : 0);\n", () {
      Constructor(
        Type('Point'),
        name: 'origin',
        initializers: Initializers(
          constructorCall: ConstructorCall(
            parameterValues: ParameterValues([
              ParameterValue.named('x', Expression.ofInt(0)),
              ParameterValue.named('y', Expression.ofInt(0)),
            ]),
          ),
        ),
      ).toString().should.be('Point.origin() : this(x: 0,y: 0);');
    });

    test("Should return: Constructor with a body", () {
      Constructor(
        Type('Point'),
        name: 'origin',
        body: Block([
          Statement.assignVariable('x', Expression.ofInt(5), this$: true),
          Statement.assignVariable('y', Expression.ofInt(10), this$: true),
        ]),
      ).toString().should.be('Point.origin() {this.x = 5;this.y = 10;};');
    });

    test("Should return: Correct complex constructor", () {
      final givenName = 'givenName';
      final familyName = 'familyName';
      Constructor(
        Type('Person'),
        initializers: Initializers(
          fieldInitializers: [
            FieldInitializer(givenName, Expression.ofString('Nils')),
            FieldInitializer(familyName, Expression.ofString('ten Hoeve')),
          ],
          constructorCall: ConstructorCall(
            parameterValues: ParameterValues([
              ParameterValue.named(
                'gender',
                Expression.ofEnum(Type('Gender'), 'male'),
              ),
              ParameterValue.named('age', Expression.ofInt(30)),
            ]),
          ),
        ),
        body: Block([
          Statement.assignVariable(
            'fullName',
            Expression.callMethodOrFunction(
              '_appendNames',
              parameterValues: ParameterValues([
                ParameterValue(Expression.ofVariable(givenName)),
                ParameterValue(Expression.ofVariable(familyName)),
              ]),
            ),
            this$: true,
          ),
        ]),
      ).toString().should.be(
        'Person() : givenName = \'Nils\',familyName = \'ten Hoeve\',this(gender: Gender.male,age: 30) {this.fullName = _appendNames(givenName,familyName);};',
      );
    });
  });
}
