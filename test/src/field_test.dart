// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

main() {
  group('Field class', () {
    group('Modifier=var', () {
      test("Should return: 'var name;'", () {
        Field('name').toString().should.be('var name;');
      });

      test("Should return: 'String name;'", () {
        Field('name', type: Type.ofString())
            .toString()
            .should
            .be('String name;');
      });

      test("Should return: 'String? name;'", () {
        Field('name', type: Type.ofString(nullable: true))
            .toString()
            .should
            .be('String? name;');
      });

      test("Should return: 'static String name;'", () {
        Field('name', type: Type.ofString(), static: true)
            .toString()
            .should
            .be('static String name;');
      });

      test("Should return: a string field name;'", () {
        Field('name',
                type: Type.ofString(),
                docComments: [DocComment.fromString('A valid name')])
            .toString()
            .should
            .be('/// A valid name\nString name;');
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        Field('name',
                type: Type.ofString(),
                docComments: [DocComment.fromString('A valid name')],
                annotations: [Annotation(Type('Hidden'))])
            .toString()
            .should
            .be('/// A valid name\n@Hidden()\nString name;');
      });
    });

    group('Modifier=const', () {
      test("Should return: 'const name = 'Nils';'", () {
        Field('name',
                modifier: Modifier.const$, value: Expression.ofString('Nils'))
            .toString()
            .should
            .be("const name = 'Nils';");
      });

      test("Should return: 'const String name = personName;'", () {
        Field('name',
                modifier: Modifier.const$,
                value: Expression.ofVariable('personName'),
                type: Type.ofString())
            .toString()
            .should
            .be("const String name = personName;");
      });

      test("Should return: 'const String? name = personName;'", () {
        Field(
          'name',
          modifier: Modifier.const$,
          value: Expression.ofVariable('personName'),
          type: Type.ofString(nullable: true),
        ).toString().should.be("const String? name = personName;");
      });

      test("Should return: 'static const String name = 'Nils';'", () {
        Field('name',
                modifier: Modifier.const$,
                value: Expression.ofString('Nils'),
                type: Type.ofString(),
                static: true)
            .toString()
            .should
            .be("static const String name = 'Nils';");
      });

      test("Should return: a string field name;'", () {
        Field('name',
                modifier: Modifier.const$,
                value: Expression.ofString('Nils'),
                type: Type.ofString(),
                docComments: [DocComment.fromString('A valid name')])
            .toString()
            .should
            .be('/// A valid name\nconst String name = \'Nils\';');
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        Field('name',
                modifier: Modifier.const$,
                value: Expression.ofString('Nils'),
                type: Type.ofString(),
                docComments: [DocComment.fromString('A valid name')],
                annotations: [Annotation(Type('Hidden'))])
            .toString()
            .should
            .be('/// A valid name\n@Hidden()\nconst String name = \'Nils\';');
      });
    });

    group('Modifier=field', () {
      test("Should return: 'final name;'", () {
        Field('name', modifier: Modifier.final$)
            .toString()
            .should
            .be("final name;");
      });

      test("Should return: 'final name = 'Nils';'", () {
        Field('name',
                modifier: Modifier.final$, value: Expression.ofString('Nils'))
            .toString()
            .should
            .be("final name = 'Nils';");
      });

      test("Should return: 'final String name = personName;'", () {
        Field('name',
                modifier: Modifier.final$,
                value: Expression.ofVariable('personName'),
                type: Type.ofString())
            .toString()
            .should
            .be("final String name = personName;");
      });

      test("Should return: 'final String? name = personName;'", () {
        Field(
          'name',
          modifier: Modifier.final$,
          value: Expression.ofVariable('personName'),
          type: Type.ofString(nullable: true),
        ).toString().should.be("final String? name = personName;");
      });

      test("Should return: 'static final String name;'", () {
        Field('name',
                static: true,
                modifier: Modifier.final$,
                type: Type.ofString(),
                value: Expression.ofString('Nils'))
            .toString()
            .should
            .be("static final String name = 'Nils';");
      });

      test("Should return: a string field name;'", () {
        Field(
          'name',
          docComments: [DocComment.fromString('A valid name')],
          modifier: Modifier.final$,
          type: Type.ofString(),
          value: Expression.ofString('Nils'),
        )
            .toString()
            .should
            .be('/// A valid name\nfinal String name = \'Nils\';');
      });

      test("Should return:  a string field name with docComment and annotation",
          () {
        Field(
          'name',
          docComments: [DocComment.fromString('A valid name')],
          annotations: [Annotation(Type('Hidden'))],
          modifier: Modifier.final$,
          type: Type.ofString(),
          value: Expression.ofString('Nils'),
        )
            .toString()
            .should
            .be('/// A valid name\n@Hidden()\nfinal String name = \'Nils\';');
      });
    });
  });

  group('FieldInitializer class', () {
    test("Should return: name='Nils'", () {
      FieldInitializer('name', Expression.ofString('Nils'))
          .toString()
          .should
          .be("name = 'Nils'");
    });
  });
}
