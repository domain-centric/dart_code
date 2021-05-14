import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Field class', () {
    group('Field.var\$ constructor', () {
      test("Should return: 'var name;\n'", () {
        String actual = Field('name').toString();
        String expected = 'var name;\n';
        expect(actual, expected);
      });

      test("Should return: 'String name;\n'", () {
        String actual = Field('name', type: Type.ofString()).toString();
        String expected = 'String name;\n';
        expect(actual, expected);
      });

      test("Should return: 'static String name;'", () {
        String actual = CodeFormatter()
            .unFormatted(Field('name', type: Type.ofString(), static: true));
        String expected = 'static String name;';
        expect(actual, expected);
      });

      test("Should return: a string field name;\n'", () {
        String actual = CodeFormatter().unFormatted(Field('name',
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')]));
        String expected = '/// A valid name\n'
            'String name;';
        expect(actual, expected);
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
            String actual = CodeFormatter().unFormatted(Field('name',
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')],
            annotations: [Annotation(Type('Hidden'))]));
        String expected = '/// A valid name\n'
            '@Hidden()\n'
            'String name;';
        expect(actual, expected);
      });
    });

    group('Field.const\$ constructor', () {
      test("Should return: 'const name = 'Nils';\n'", () {
        String actual = Field('name',
                modifier: Modifier.const$, value: Expression.ofString('Nils'))
            .toString();
        String expected = "const name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'const String name = 'Nils';\n'", () {
        String actual = Field('name',
                modifier: Modifier.const$,
                value: Expression.ofString('Nils'),
                type: Type.ofString())
            .toString();
        String expected = "const String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'static const String name = 'Nils';'", () {
        String actual = CodeFormatter().unFormatted(Field('name',
            modifier: Modifier.const$,
            value: Expression.ofString('Nils'),
            type: Type.ofString(),
            static: true));
        String expected = "static const String name = 'Nils';";
        expect(actual, expected);
      });

      test("Should return: a string field name;\n'", () {
        String actual = CodeFormatter().unFormatted(Field('name',
            modifier: Modifier.const$,
            value: Expression.ofString('Nils'),
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')]));
        String expected = '/// A valid name\n'
            'const String name = \'Nils\';';
        expect(actual, expected);
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        String actual = Field('name',
            modifier: Modifier.const$,
            value: Expression.ofString('Nils'),
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')],
            annotations: [Annotation(Type('Hidden'))]).toString();
        String expected = '/// A valid name\n'
            '@Hidden()\n'
            "const String name = 'Nils';\n";
        expect(actual, expected);
      });
    });

    group('Field.final\$ constructor', () {
      test("Should return: 'final name;\n'", () {
        String actual = Field('name', modifier: Modifier.final$).toString();
        String expected = "final name;\n";
        expect(actual, expected);
      });

      test("Should return: 'final name = 'Nils';\n'", () {
        String actual = Field('name',
                modifier: Modifier.final$, value: Expression.ofString('Nils'))
            .toString();
        String expected = "final name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'final String name = 'Nils';\n'", () {
        String actual = Field('name',
                modifier: Modifier.final$,
                value: Expression.ofString('Nils'),
                type: Type.ofString())
            .toString();
        String expected = "final String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'static final String name;'", () {
        String actual = CodeFormatter().unFormatted(Field('name',
            static: true,
            modifier: Modifier.final$,
            type: Type.ofString(),
            value: Expression.ofString('Nils')));
        String expected = "static final String name = 'Nils';";
        expect(actual, expected);
      });

      test("Should return: a string field name;\n'", () {
        String actual = Field(
          'name',
          docComments: [DocComment.fromString('A valid name')],
          modifier: Modifier.final$,
          type: Type.ofString(),
          value: Expression.ofString('Nils'),
        ).toString();
        String expected = '/// A valid name\n'
            "final String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        String actual = Field(
          'name',
          docComments: [DocComment.fromString('A valid name')],
          annotations: [Annotation(Type('Hidden'))],
          modifier: Modifier.final$,
          type: Type.ofString(),
          value: Expression.ofString('Nils'),
        ).toString();
        String expected = '/// A valid name\n'
            '@Hidden()\n'
            "final String name = 'Nils';\n";
        expect(actual, expected);
      });
    });
  });

  group('FieldInitializer class', () {
    test("Should return: name='Nils'", () {
      String actual = CodeFormatter()
          .unFormatted(FieldInitializer('name', Expression.ofString('Nils')));
      String expected = "name = 'Nils'";
      expect(actual, expected);
    });
  });
}
