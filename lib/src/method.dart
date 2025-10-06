// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

enum PropertyAccessor { getter, setter }

/// Represents a [Class] [Method] or [PropertyAccessor]
/// See: [https://dart.dev/guides/language/language-tour#methods]
class Method extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;
  final bool abstract;
  final bool static;
  final bool final$;
  final BaseType returnType;
  final PropertyAccessor? propertyAccessor;
  final Asynchrony? asynchrony;
  final MethodName name;
  final Parameters? parameters;
  final Body? body;

  Method.abstract(
    String name, {
    this.docComments = const [],
    this.annotations = const [],
    required this.returnType,
    this.propertyAccessor,
    this.parameters,
    this.asynchrony,
  }) : abstract = true,
       static = false,
       final$ = false,
       name = IdentifierStartingWithLowerCase(name),
       body = null;

  Method.static(
    String name,
    CodeNode body, {
    this.docComments = const [],
    this.annotations = const [],
    required this.returnType,
    this.parameters,
    this.asynchrony,
  }) : abstract = false,
       static = true,
       final$ = false,
       name = IdentifierStartingWithLowerCase(name),
       propertyAccessor = null,
       body = Body([body]);

  Method(
    String name,
    CodeNode body, {
    this.docComments = const [],
    this.annotations = const [],
    required this.returnType,
    this.parameters,
    this.asynchrony,
  }) : abstract = false,
       static = false,
       final$ = false,
       name = IdentifierStartingWithLowerCase(name),
       propertyAccessor = null,
       body = Body([body]);

  Method.getter(
    String name,
    CodeNode body, {
    this.docComments = const [],
    this.annotations = const [],
    this.final$ = false,
    required this.returnType,
    this.parameters,
    this.asynchrony,
  }) : abstract = false,
       static = false,
       name = IdentifierStartingWithLowerCase(name),
       propertyAccessor = PropertyAccessor.getter,
       body = Body([body]);

  Method.setter(
    String name,
    CodeNode body, {
    this.docComments = const [],
    this.annotations = const [],
    required BaseType parameterType,
    this.asynchrony,
  }) : abstract = false,
       static = false,
       final$ = false,
       name = IdentifierStartingWithLowerCase(name),
       propertyAccessor = PropertyAccessor.setter,
       body = Body([body]),
       returnType = Type.ofVoid(),
       parameters = Parameters([
         Parameter(ParameterCategory.required, name, type: parameterType),
       ]);

  Method.overrideOperator(
    Operator operator,
    CodeNode body, {
    this.docComments = const [],
    Set<Annotation> annotations = const {},
    required this.returnType,
    required Parameter parameter,
    this.asynchrony,
  }) : abstract = false,
       static = false,
       final$ = false,
       parameters = Parameters([parameter]),
       annotations = createOperatorAnnotations(annotations),
       name = operator,
       propertyAccessor = null,
       body = Body([body]);

  @override
  List<CodeNode> codeNodes(Imports imports) => [
    ...docComments,
    ...annotations,
    if (static) KeyWord.static$,
    if (static) Space(),
    if (final$) KeyWord.final$,
    if (final$) Space(),

    /// return type void for setter not needed for now
    if (propertyAccessor != PropertyAccessor.setter) returnType,
    if (propertyAccessor != PropertyAccessor.setter) Space(),
    if (name is Operator) KeyWord.operator$,
    if (propertyAccessor == PropertyAccessor.getter) KeyWord.get$,
    if (propertyAccessor == PropertyAccessor.setter) KeyWord.set$,
    if (name is Operator || propertyAccessor != null) Space(),
    name,
    if (propertyAccessor == null || propertyAccessor != PropertyAccessor.getter)
      Code('('),
    // if (propertyAccessor != null &&
    //     propertyAccessor == PropertyAccessor.setter)
    //   Parameter.required(name.toUnFormattedString(imports),
    //       type: returnType),
    if (parameters != null && propertyAccessor != PropertyAccessor.getter)
      parameters!,
    if (propertyAccessor != PropertyAccessor.getter) Code(')'),
    if (asynchrony != null) Space(),
    if (asynchrony != null && asynchrony == Asynchrony.async) KeyWord.async$,
    if (asynchrony != null && asynchrony == Asynchrony.sync) KeyWord.sync$,
    if (!abstract) Space(),
    if (!abstract) body!,
    if (abstract) EndOfStatement(),
  ];

  static List<Annotation> createOperatorAnnotations(
    Set<Annotation> annotations,
  ) {
    var overrideAnnotation = Annotation.override().toString();
    return [
      if (!annotations.any((a) => a.toString() == overrideAnnotation))
        Annotation.override(),
      ...annotations,
    ];
  }
}

/// Represents a [IdentifierStartingWithLowerCase] or [Operator]
abstract class MethodName extends CodeNode {}
