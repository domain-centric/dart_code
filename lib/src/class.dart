// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// Represents a [Class]
/// See [https://dart.dev/guides/language/language-tour#classes]
class Class extends CodeModel {
  final List<DocComment>? docComments;
  final List<Annotation>? annotations;
  final bool? abstract;
  final IdentifierStartingWithUpperCase name;
  final Type? superClass;
  final List<Type>? implements;
  final List<Type>? mixins;
  final List<Field>? fields;
  final List<Constructor>? constructors;
  final List<Method>? methods;

  Class(
    String name, {
    this.docComments,
    this.annotations,
    this.abstract,
    this.superClass,
    this.implements,
    this.mixins,
    this.fields,
    this.constructors,
    this.methods,
  }) : this.name = IdentifierStartingWithUpperCase(name);

  @override
  List<CodeNode> codeNodes(Imports imports) => [
        if (docComments != null) ...docComments!,
        if (annotations != null) ...annotations!,
        if (abstract != null && abstract!) KeyWord.abstract$,
        if (abstract != null && abstract!) Space(),
        KeyWord.class$,
        Space(),
        name,
        Space(),
        if (superClass != null) KeyWord.extends$,
        if (superClass != null) Space(),
        if (superClass != null) superClass!,
        if (superClass != null) Space(),
        if (implements != null) KeyWord.implements$,
        if (implements != null) Space(),
        if (implements != null) SeparatedValues.forParameters(implements!),
        if (implements != null) Space(),
        if (mixins != null) KeyWord.with$,
        if (mixins != null) Space(),
        if (mixins != null) SeparatedValues.forParameters(mixins!),
        if (mixins != null) Space(),
        Block([
          if (fields != null) ...fields!,
          if (constructors != null)
            SeparatedValues.forStatements(constructors!),
          if (methods != null) SeparatedValues.forStatements(methods!),
        ]),
      ];
}
