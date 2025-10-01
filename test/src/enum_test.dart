// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:dart_code/dart_code.dart';

void main() {
  group('Enumeration class', () {
    test('should create Enumeration with name and values', () {
      final enumDecl = Enumeration(
          'Color', {EnumValue('red'), EnumValue('green'), EnumValue('blue')});
      enumDecl.toString().should.be('enum Color {red,green,blue}');
    });

    test('should handle docComments and annotations', () {
      final doc = DocComment.fromString('/// This is a color enum');
      final annotation = Annotation.deprecated();
      final enumDecl = Enumeration(
        'Color',
        {EnumValue('red'), EnumValue('green')},
        docComments: [doc],
        annotations: [annotation],
      );

      enumDecl.toString().should.be("/// This is a color enum\n"
          "@deprecated\n"
          "enum Color {red,green}");
    });

    test('should handle implements', () {
      final type = Type('Serializable');
      final enumDecl = Enumeration(
        'Color',
        {EnumValue('red')},
        implements: [type],
      );

      enumDecl.toString().should.be('enum Color implements Serializable {red}');
    });

    test('should handle constructors and methods', () {
      var constructorParameters = ConstructorParameters(
          [ConstructorParameter.named('tires', type: Type.ofInt())]);
      final ctor =
          Constructor(Type('Vehicle '), parameters: constructorParameters);
      final method = Method(
          'toString', Expression.ofString('A \$name has \$tires tires'),
          returnType: Type.ofString());
      final enumDecl = Enumeration(
        'Vehicle',
        {
          EnumValue(
              'car',
              ParameterValues(
                  [ParameterValue.named('tires', Expression.ofInt(4))])),
          EnumValue(
              'bicycle',
              ParameterValues(
                  [ParameterValue.named('tires', Expression.ofInt(2))])),
        },
        constructor: ctor,
        methods: [method],
      );

      enumDecl
          .toString()
          .should
          .be("enum Vehicle {car(tires: 4),bicycle(tires: 2);\n"
              "const Vehicle ({required this.tires});final int tires;"
              "String toString()  => 'A \$name has \$tires tires';}");
    });

    test('should throw an error when enum name casing is incorrect', () {
      Should.throwError<ArgumentError>(
          () =>
              Enumeration('color', {EnumValue('red')})).toString().should.be(
          'Invalid argument (name): Must start with an upper case letter: "color"');
      Should.throwError<ArgumentError>(
          () =>
              Enumeration('cOLOR', {EnumValue('red')})).toString().should.be(
          'Invalid argument (name): Must start with an upper case letter: "cOLOR"');
    });

    test('should throw an error when enum name contains an illegal character',
        () {
      Should.throwError<ArgumentError>(
          () =>
              Enumeration('Col@r', {EnumValue('red')})).toString().should.be(
          'Invalid argument (name): All characters must be a letter or number or an underscore or a dollar sign(\$): "Col@r"');
      Should.throwError<ArgumentError>(
          () =>
              Enumeration('Col r', {EnumValue('red')})).toString().should.be(
          'Invalid argument (name): All characters must be a letter or number or an underscore or a dollar sign(\$): "Col r"');
    });

    test('should throw an error when enum value name casing is incorrect', () {
      Should.throwError<ArgumentError>(
          () =>
              Enumeration('Color', {EnumValue('Red')})).toString().should.be(
          'Invalid argument (name): Must start with an lower case letter: "Red"');
      Should.throwError<ArgumentError>(
          () =>
              Enumeration('Color', {EnumValue('GREEN')})).toString().should.be(
          'Invalid argument (name): Must start with an lower case letter: "GREEN"');
    });

    test(
        'should throw an error when enum value name contains an illegal character',
        () {
      Should.throwError<ArgumentError>(
          () =>
              Enumeration('Color', {EnumValue('gr@en')})).toString().should.be(
          'Invalid argument (name): All characters must be a letter or number or an underscore or a dollar sign(\$): "gr@en"');
      Should.throwError<ArgumentError>(
          () =>
              Enumeration('Color', {EnumValue('bl ue')})).toString().should.be(
          'Invalid argument (name): All characters must be a letter or number or an underscore or a dollar sign(\$): "bl ue"');
    });

    test('should throw an error when creating an Enumeration with empty values',
        () {
      Should.throwError<ArgumentError>(() => Enumeration('EmptyEnum', {}))
          .toString()
          .should
          .be('Invalid argument(s) (values): must have 1 or more values');
    });

    test('should support multiple annotations', () {
      final annotation1 = Annotation.deprecated();
      final annotation2 = Annotation.override();
      final enumDecl = Enumeration(
        'Color',
        {EnumValue('red')},
        annotations: [annotation1, annotation2],
      );
      enumDecl.annotations!.length.should.be(2);
    });

    test('should support multiple docComments', () {
      final doc1 = DocComment.fromString('/// First comment');
      final doc2 = DocComment.fromString('/// Second comment');
      final enumDecl = Enumeration(
        'Color',
        {EnumValue('red')},
        docComments: [doc1, doc2],
      );
      enumDecl.toString().should.be('/// First comment\n'
          '/// Second comment\n'
          'enum Color {red}');
    });

    test('should support multiple implements', () {
      final type1 = Type('Serializable');
      final type2 = Type('Equatable');
      final enumDecl = Enumeration(
        'Color',
        {EnumValue('red')},
        implements: [type1, type2],
      );
      enumDecl
          .toString()
          .should
          .be('enum Color implements Serializable,Equatable {red}');
    });

    test('should support multiple methods', () {
      final method1 = Method(
          'toString', Expression([Code('name.toUpperCase()')]),
          returnType: Type.ofString());
      final method2 = Method('toJson', Expression([Code('name.toLowerCase()')]),
          returnType: Type.ofString());
      final enumDecl = Enumeration(
        'Color',
        {EnumValue('red')},
        methods: [method1, method2],
      );
      enumDecl.toString().should.be("enum Color {red;\n"
          "String toString()  => name.toUpperCase();"
          "String toJson()  => name.toLowerCase();}");
    });
  });
}
