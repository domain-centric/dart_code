import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('ConstructorCall class', () {
    test("Should return: this()", () {
      String actual = CodeFormatter().unFormatted(ConstructorCall());
      String expected = "this()";
      expect(actual, expected);
    });

    test("Should return: this.origin()", () {
      String actual =
          CodeFormatter().unFormatted(ConstructorCall(name: 'origin'));
      String expected = "this.origin()";
      expect(actual, expected);
    });

    test("Should throw invalid name exception", () {
      expect(
          () => {ConstructorCall(name: 'InvalidConstructorName').toString()},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter')));
    });

    test("Should return: this.point(x: 5, y: 10)", () {
      String actual = CodeFormatter().unFormatted(ConstructorCall(
          name: 'point',
          parameterValues: ParameterValues([
            ParameterValue.named('x', Expression.ofInt(5)),
            ParameterValue.named('y', Expression.ofInt(10)),
          ])));
      String expected = 'this.point(x: 5,y: 10)';
      expect(actual, expected);
    });

    test("Should return: super()", () {
      String actual =
          CodeFormatter().unFormatted(ConstructorCall(super$: true));
      String expected = "super()";
      expect(actual, expected);
    });

    test("Should return: super.origin()", () {
      String actual = CodeFormatter()
          .unFormatted(ConstructorCall(name: 'origin', super$: true));
      String expected = "super.origin()";
      expect(actual, expected);
    });

    test("Should throw invalid name exception", () {
      expect(
          () => {
                ConstructorCall(
                  name: 'InvalidConstructorName',
                  super$: true,
                ).toString()
              },
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter')));
    });

    test("Should return: super.point(x: 5, y: 10)", () {
      String actual = CodeFormatter().unFormatted(ConstructorCall(
          name: 'point',
          super$: true,
          parameterValues: ParameterValues([
            ParameterValue.named('x', Expression.ofInt(5)),
            ParameterValue.named('y', Expression.ofInt(10)),
          ])));
      String expected = 'super.point(x: 5,y: 10)';
      expect(actual, expected);
    });
  });

  group('Initializer class', () {
    test("Should return: name = 'Nils', age = 30", () {
      String actual = CodeFormatter()
          .unFormatted(FieldInitializer('name', Expression.ofString('Nils')));
      String expected = 'name = \'Nils\'';
      expect(actual, expected);
    });
  });

  group('Initializers class', () {
    test("Should return: name = 'Nils', age = 30", () {
      String actual =
          CodeFormatter().unFormatted(Initializers(fieldInitializers: [
        FieldInitializer('name', Expression.ofString('Nils')),
        FieldInitializer('age', Expression.ofInt(30)),
      ]));

      String expected = 'name = \'Nils\',age = 30';
      expect(actual, expected);
    });

    test("Should throw parameter value names not unique exception", () {
      expect(
          () => {
                Initializers(fieldInitializers: [
                  FieldInitializer('name', Expression.ofString('Nils')),
                  FieldInitializer('name', Expression.ofString('Bianca')),
                ]).toString()
              },
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message == 'Field names must be unique')));
    });

    test("Should return: name = 'Nils', age = 30", () {
      String actual =
          CodeFormatter().unFormatted(Initializers(fieldInitializers: [
        FieldInitializer('name', Expression.ofString('Nils')),
        FieldInitializer('age', Expression.ofInt(30)),
      ]));

      String expected = 'name = \'Nils\',age = 30';
      expect(actual, expected);
    });

    test("gender = Gender.male, age = 30, super(name = 'Nils')", () {
      String actual = CodeFormatter().unFormatted(Initializers(
          fieldInitializers: [
            FieldInitializer(
                'gender', Expression.ofEnum(Type('Gender'), 'male')),
            FieldInitializer('age', Expression.ofInt(30)),
          ],
          constructorCall: ConstructorCall(
              super$: true,
              parameterValues: ParameterValues([
                ParameterValue.named('name', Expression.ofString('Nils'))
              ]))));
      String expected = 'gender = Gender.male,age = 30,super(name: \'Nils\')';
      expect(actual, expected);
    });
  });

  group('Constructor class', () {
    test("Should return: Person();\n", () {
      String actual = CodeFormatter().unFormatted(Constructor(Type('Person')));
      String expected = 'Person();';
      expect(actual, expected);
    });

    test("Should return: Constructor with annotation", () {
      String actual =
          CodeFormatter().unFormatted(Constructor(Type('Person'), annotations: [
        Annotation(Type('JsonSerializable',
            libraryUri: 'package:json_annotation/json_annotation.dart'))
      ]));
      String expected = '@_i1.JsonSerializable()\n'
          'Person();';
      expect(actual, expected);
    });

    test("Should return: Constructor with doc comment", () {
      String actual = CodeFormatter().unFormatted(Constructor(
        Type('Person'),
        docComments: [
          DocComment.fromString(
              'A Person that can be converted to and from Json format')
        ],
      ));
      String expected =
          '/// A Person that can be converted to and from Json format\n'
          'Person();';
      expect(actual, expected);
    });

    test("Should return: Constructor with doc comment and annotation", () {
      String actual =
          CodeFormatter().unFormatted(Constructor(Type('Person'), docComments: [
        DocComment.fromString(
            'A Person that can be converted to and from Json format')
      ], annotations: [
        Annotation(Type('JsonSerializable',
            libraryUri: 'package:json_annotation/json_annotation.dart'))
      ]));
      String expected =
          '/// A Person that can be converted to and from Json format\n'
          '@_i1.JsonSerializable()\n'
          'Person();';
      expect(actual, expected);
    });

    test("Should return: external Person();\n", () {
      String actual = Constructor(Type('Person'), external: true).toString();
      String expected = 'external Person();\n';
      expect(actual, expected);
    });

    test("Should return: const Person();\n", () {
      String actual = CodeFormatter()
          .unFormatted(Constructor(Type('Person'), constant: true));
      String expected = 'const Person();';
      expect(actual, expected);
    });

    test("Should return: factory Person();\n", () {
      String actual = CodeFormatter()
          .unFormatted(Constructor(Type('Person'), factory: true));
      String expected = 'factory Person();';
      expect(actual, expected);
    });

    test("Should return: factory Point.origin();\n", () {
      String actual = CodeFormatter()
          .unFormatted(Constructor(Type('Point'), name: 'origin'));
      String expected = 'Point.origin();';
      expect(actual, expected);
    });

    test("Should return: Point.(int x, int y);\n", () {
      String actual = CodeFormatter().unFormatted(Constructor(Type('Point'),
          parameters: ConstructorParameters([
            ConstructorParameter.required('x', type: Type.ofInt()),
            ConstructorParameter.required('y', type: Type.ofInt())
          ])));
      String expected = 'Point(int x,int y);';
      expect(actual, expected);
    });

    test("Should return: Point.origin() : x = 0, y = 0;\n", () {
      String actual = CodeFormatter().unFormatted(Constructor(Type('Point'),
          name: 'origin',
          initializers: Initializers(fieldInitializers: [
            FieldInitializer('x', Expression.ofInt(0)),
            FieldInitializer('y', Expression.ofInt(0)),
          ])));
      String expected = 'Point.origin() : x = 0,y = 0;';
      expect(actual, expected);
    });

    test("Should return: Point.origin() : this(x : 0, y : 0);\n", () {
      String actual = CodeFormatter().unFormatted(Constructor(Type('Point'),
          name: 'origin',
          initializers: Initializers(
              constructorCall: ConstructorCall(
                  parameterValues: ParameterValues([
            ParameterValue.named('x', Expression.ofInt(0)),
            ParameterValue.named('y', Expression.ofInt(0))
          ])))));
      String expected = 'Point.origin() : this(x: 0,y: 0);';
      expect(actual, expected);
    });

    test("Should return: Constructor with a body", () {
      String actual = CodeFormatter().unFormatted(Constructor(Type('Point'),
          name: 'origin',
          body: Block([
            Statement.assignVariable('x', Expression.ofInt(5), this$: true),
            Statement.assignVariable('y', Expression.ofInt(10), this$: true),
          ])));
      String expected = 'Point.origin() {this.x = 5;this.y = 10;};';
      expect(actual, expected);
    });

    test("Should return: Correct complex constructor", () {
      final givenName = 'givenName';
      final familyName = 'familyName';
      String actual = CodeFormatter().unFormatted(Constructor(Type('Person'),
          initializers: Initializers(
              fieldInitializers: [
                FieldInitializer(givenName, Expression.ofString('Nils')),
                FieldInitializer(familyName, Expression.ofString('ten Hoeve')),
              ],
              constructorCall: ConstructorCall(
                  parameterValues: ParameterValues([
                ParameterValue.named(
                    'gender', Expression.ofEnum(Type('Gender'), 'male')),
                ParameterValue.named('age', Expression.ofInt(30))
              ]))),
          body: Block([
            Statement.assignVariable(
                'fullName',
                Expression.callFunction('_appendNames',
                    parameterValues: ParameterValues([
                      ParameterValue(Expression.ofVariable(givenName)),
                      ParameterValue(Expression.ofVariable(familyName)),
                    ])),
                this$: true),
          ])));
      String expected =
          'Person() : givenName = \'Nils\',familyName = \'ten Hoeve\',this(gender: Gender.male,age: 30) {this.fullName = _appendNames(givenName,familyName);};';
      expect(actual, expected);
    });
  });
}
