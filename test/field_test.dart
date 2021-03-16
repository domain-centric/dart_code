import 'package:dart_code/annotation.dart';
import 'package:dart_code/comment.dart';
import 'package:dart_code/expression.dart';
import 'package:dart_code/field.dart';
import 'package:dart_code/type.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Field class', () {
    group('Field.var\$ constructor', () {
      test("Should return: 'var name;\n'", () {
        String actual = Field.var$('name').toString();
        String expected = 'var name;\n';
        expect(actual, expected);
      });

      test("Should return: 'String name;\n'", () {
        String actual = Field.var$('name', type: Type.ofString()).toString();
        String expected = 'String name;\n';
        expect(actual, expected);
      });

      test("Should return: 'static String name;\n'", () {
        String actual =
            Field.var$('name', type: Type.ofString(), static: true).toString();
        String expected = 'static String name;\n';
        expect(actual, expected);
      });

      test("Should return: a string field name;\n'", () {
        String actual = Field.var$('name',
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')]).toString();
        String expected = '/// A valid name\n'
            'String name;\n';
        expect(actual, expected);
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        String actual = Field.var$('name',
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')],
            annotations: [Annotation(Type('Hidden'))]).toString();
        String expected = '/// A valid name\n'
            '@Hidden()\n'
            'String name;\n';
        expect(actual, expected);
      });
    });

    group('Field.const\$ constructor', () {
      test("Should return: 'const name = 'Nils';\n'", () {
        String actual =
            Field.const$('name', Expression.ofString('Nils')).toString();
        String expected = "const name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'const String name = 'Nils';\n'", () {
        String actual = Field.const$('name', Expression.ofString('Nils'),
                type: Type.ofString())
            .toString();
        String expected = "const String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'static const String name = 'Nils';\n'", () {
        String actual = Field.const$('name', Expression.ofString('Nils'),
                type: Type.ofString(), static: true)
            .toString();
        String expected = "static const String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: a string field name;\n'", () {
        String actual = Field.const$('name', Expression.ofString('Nils'),
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')]).toString();
        String expected = '/// A valid name\n'
            "const String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        String actual = Field.const$('name', Expression.ofString('Nils'),
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
        String actual = Field.final$('name').toString();
        String expected = "final name;\n";
        expect(actual, expected);
      });

      test("Should return: 'final name = 'Nils';\n'", () {
        String actual =
            Field.final$('name', value: Expression.ofString('Nils')).toString();
        String expected = "final name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'final String name = 'Nils';\n'", () {
        String actual = Field.final$('name',
                value: Expression.ofString('Nils'), type: Type.ofString())
            .toString();
        String expected = "final String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: 'static final String name;\n'", () {
        String actual = Field.final$('name',
                value: Expression.ofString('Nils'),
                type: Type.ofString(),
                static: true)
            .toString();
        String expected = "static final String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return: a string field name;\n'", () {
        String actual = Field.final$('name',
            value: Expression.ofString('Nils'),
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')]).toString();
        String expected = '/// A valid name\n'
            "final String name = 'Nils';\n";
        expect(actual, expected);
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        String actual = Field.final$('name',
            value: Expression.ofString('Nils'),
            type: Type.ofString(),
            docComments: [DocComment.fromString('A valid name')],
            annotations: [Annotation(Type('Hidden'))]).toString();
        String expected = '/// A valid name\n'
            '@Hidden()\n'
            "final String name = 'Nils';\n";
        expect(actual, expected);
      });
    });
  });

  group('FieldInitializer class', () {
    test("Should return: name='Nils'", () {
      String actual =
          FieldInitializer('name', Expression.ofString('Nils')).toString();
      String expected = "name = 'Nils'";
      expect(actual, expected);
    });
  });
}
