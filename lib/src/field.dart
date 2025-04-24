// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// A [Field] is a [VariableDefinition] in a [Class].
/// See [https://dart.dev/guides/language/language-tour#using-class-members]
class Field extends VariableDefinition {
  Field(String name,
      {List<DocComment> docComments = const [],
      List<Annotation> annotations = const [],
      bool static = false,
      Modifier modifier = Modifier.var$,
      BaseType? type,
      Expression? value})
      : super(name,
            docComments: docComments,
            annotations: annotations,
            static: static,
            modifier: modifier,
            type: type,
            value: value);
}

/// A [FieldInitializer] is a [VariableDefinition] with a value assignment within a [Class].
/// See [https://dart.dev/guides/language/language-tour#using-class-members]
class FieldInitializer extends CodeModel {
  final IdentifierStartingWithLowerCase name;
  final Expression value;

  FieldInitializer(String fieldName, this.value)
      : name = IdentifierStartingWithLowerCase(fieldName);

  @override
  List<CodeNode> codeNodes(Imports imports) =>
      [name, Space(), Code('='), Space(), value];
}
