// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('TypeDef', () {
    test('should have correct alias and type', () {
      var typeDef = TypeDef(
        alias: Type('MyAlias'),
        type: Type('int'),
        docComments: [DocComment.fromString('/// This is a typedef')],
        annotations: [Annotation.deprecated()],
      );
      typeDef.toString().should.be(
        '/// This is a typedef\n'
        '@deprecated\n'
        'typedef MyAlias=int;',
      );
    });

    test('should have correct alias and type', () {
      var typeDef = TypeDef(
        alias: Type('IntList'),
        type: Type.ofList(genericType: Type.ofInt()),
      );
      typeDef.toString().should.be('typedef IntList=List<int>;');
    });

    test('should have correct alias and type', () {
      var typeDef = TypeDef(
        alias: Type('MappedList', generics: [Type('X')]),
        type: Type.ofMap(
          keyType: Type('X'),
          valueType: Type.ofList(genericType: Type('X')),
        ),
      );
      typeDef.toString().should.be('typedef MappedList<X>=Map<X,List<X>>;');
    });
  });
}
