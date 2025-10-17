// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// Represents a [Extension]
/// See [https://dart.dev/guides/language/language-tour#classes]
class Extension extends CodeModel {
  final List<DocComment>? docComments;
  final List<Annotation>? annotations;
  final IdentifierStartingWithUpperCase name;
  final Type? onType;
  final List<Method>? methods;

  Extension(
    String name,
    this.onType, {
    this.docComments,
    this.annotations,
    this.methods,
  }) : this.name = IdentifierStartingWithUpperCase(name);

  @override
  List<CodeNode> codeNodes(Imports imports) => [
    if (docComments != null) ...docComments!,
    KeyWord.extension$,
    Space(),
    name,
    Space(),
    KeyWord.on$,
    Space(),
    onType!,
    Block([if (methods != null) SeparatedValues.forStatements(methods!)]),
  ];
}
