// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// Represents a [ConstructorCall]
/// See [https://dart.dev/guides/language/language-tour#constructors]
class ConstructorCall extends CodeModel {
  final String? name;
  final ParameterValues? parameterValues;
  final bool super$;

  ConstructorCall({this.super$ = false, this.name, this.parameterValues});

  @override
  List<CodeNode> codeNodes(Imports imports) => [
    if (super$) KeyWord.super$,
    if (!super$) KeyWord.this$,
    if (name != null) Code('.'),
    if (name != null) IdentifierStartingWithLowerCase(name!),
    Code('('),
    if (parameterValues != null) parameterValues!,
    Code(')'),
  ];
}

/// Represents a [Constructor] [Initializers]
/// See: [https://dart.dev/guides/language/language-tour#instance-variables]
class Initializers extends SeparatedValues {
  Initializers({
    List<FieldInitializer>? fieldInitializers,
    ConstructorCall? constructorCall,
  }) : super.forParameters([
         if (fieldInitializers != null) ...fieldInitializers,
         if (constructorCall != null) constructorCall,
       ]) {
    _validateIfFieldInitializerNamesAreUnique(fieldInitializers);
  }

  void _validateIfFieldInitializerNamesAreUnique(
    List<FieldInitializer>? fieldInitializers,
  ) {
    if (fieldInitializers != null) {
      var allNames = fieldInitializers.map((p) => p.name.toString()).toList();
      var allUniqueNames = fieldInitializers
          .map((p) => p.name.toString())
          .toSet();
      var namesAreUnique = allNames.length == allUniqueNames.length;
      if (!namesAreUnique) {
        throw new ArgumentError.value(
          fieldInitializers,
          'fieldInitializers',
          'Field names must be unique',
        );
      }
    }
  }
}

/// Represents a [Class] [Constructor]
/// See [https://dart.dev/guides/language/language-tour#constructors]
class Constructor extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;

  /// Whether the constructor should be prefixed with `external`.
  final bool external;

  /// Whether the constructor should be prefixed with `const`.
  final bool constant;

  /// Whether this constructor should be prefixed with `factory`.
  final bool factory;
  final Type type;
  final IdentifierStartingWithLowerCase? name;
  final ConstructorParameters? parameters;
  final Initializers? initializers;
  final Block? body;

  Constructor(
    this.type, {
    this.docComments = const [],
    this.annotations = const [],
    this.external = false,
    this.constant = false,
    this.factory = false,
    String? name,
    this.parameters,
    this.initializers,
    this.body,
  }) : name = name == null ? null : IdentifierStartingWithLowerCase(name);

  Constructor copyWith({
    List<DocComment>? docComments,
    List<Annotation>? annotations,
    bool? external,
    bool? constant,
    bool? factory,
    Type? type,
    String? name,
    ConstructorParameters? parameters,
    Initializers? initializers,
    Block? body,
  }) {
    return Constructor(
      type ?? this.type,
      docComments: docComments ?? this.docComments,
      annotations: annotations ?? this.annotations,
      external: external ?? this.external,
      constant: constant ?? this.constant,
      factory: factory ?? this.factory,
      name: name ?? this.name?.toString(),
      parameters: parameters ?? this.parameters,
      initializers: initializers ?? this.initializers,
      body: body ?? this.body,
    );
  }

  @override
  List<CodeNode> codeNodes(Imports imports) => [
    ...docComments,
    ...annotations,
    if (external) KeyWord.external$,
    if (external) Space(),
    if (constant) KeyWord.const$,
    if (constant) Space(),
    if (factory) KeyWord.factory$,
    if (factory) Space(),
    Code(type.name),
    if (name != null) Code('.'),
    if (name != null) name!,
    Code('('),
    if (parameters != null) parameters!,
    Code(')'),
    if (initializers != null) Space(),
    if (initializers != null) Code(':'),
    if (initializers != null) Space(),
    if (initializers != null) initializers!,
    if (body != null) Space(),
    if (body != null) body!,
    EndOfStatement(),
  ];
}
