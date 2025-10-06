// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

// For type definition see https://dart.dev/language/typedefs
class TypeDef extends CodeModel {
  TypeDef({
    required this.alias,
    required this.type,
    this.docComments,
    this.annotations,
  });

  final Type alias;
  final Type type;
  final List<DocComment>? docComments;
  final List<Annotation>? annotations;

  @override
  List<CodeNode> codeNodes(Imports imports) => [
    if (docComments != null) ...docComments!,
    if (annotations != null) ...annotations!,
    KeyWord.typedef$,
    Space(),
    alias,
    Operator.assign,
    type,
    Code(';'),
  ];
}
