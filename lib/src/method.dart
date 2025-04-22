import '../dart_code.dart';

enum PropertyAccessor {
  getter,
  setter,
}

/// Represents a [Class] [Method] or [PropertyAccessor]
/// See: [https://dart.dev/guides/language/language-tour#methods]
class Method extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;
  final bool abstract;
  final bool static;
  final bool final$;
  final BaseType? returnType;
  final PropertyAccessor? propertyAccessor;
  final Asynchrony? asynchrony;
  final IdentifierStartingWithLowerCase name;
  final Parameters? parameters;
  final Body? body;

  Method.abstract(
    String name, {
    this.docComments = const [],
    this.annotations = const [],
    this.returnType,
    this.propertyAccessor,
    this.parameters,
    this.asynchrony,
  })  : abstract = true,
        static = false,
        final$ = false,
        name = IdentifierStartingWithLowerCase(name),
        body = null;

  Method.static(
    String name,
    CodeNode body, {
    this.docComments = const [],
    this.annotations = const [],
    this.returnType,
    this.parameters,
    this.asynchrony,
  })  : abstract = false,
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
    this.returnType,
    this.parameters,
    this.asynchrony,
  })  : abstract = false,
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
    this.returnType,
    this.parameters,
    this.asynchrony,
  })  : abstract = false,
        static = false,
        name = IdentifierStartingWithLowerCase(name),
        propertyAccessor = PropertyAccessor.getter,
        body = Body([body]);

  Method.setter(
    String name,
    CodeNode body, {
    this.docComments = const [],
    this.annotations = const [],
    this.returnType,
    this.parameters,
    this.asynchrony,
  })  : abstract = false,
        static = false,
        final$ = false,
        name = IdentifierStartingWithLowerCase(name),
        propertyAccessor = PropertyAccessor.setter,
        body = Body([body]);

  @override
  List<CodeNode> codeNodes(Context context) => [
        ...docComments,
        ...annotations,
        if (static) KeyWord.static$,
        if (static) Space(),
        if (final$) KeyWord.final$,
        if (final$) Space(),
        if (returnType != null &&
            (propertyAccessor == null ||
                propertyAccessor != PropertyAccessor.setter))
          returnType!,
        if (returnType != null &&
            (propertyAccessor == null ||
                propertyAccessor != PropertyAccessor.setter))
          Space(),
        if (propertyAccessor != null &&
            propertyAccessor == PropertyAccessor.getter)
          KeyWord.get$,
        if (propertyAccessor != null &&
            propertyAccessor == PropertyAccessor.setter)
          KeyWord.set$,
        if (propertyAccessor != null) Space(),
        name,
        if (propertyAccessor == null ||
            propertyAccessor != PropertyAccessor.getter)
          Code('('),
        if (propertyAccessor != null &&
            propertyAccessor == PropertyAccessor.setter)
          Parameter.required(CodeFormatter().unFormatted(name),
              type: returnType),
        if (parameters != null && propertyAccessor == null) parameters!,
        if (propertyAccessor == null ||
            propertyAccessor != PropertyAccessor.getter)
          Code(')'),
        if (asynchrony != null) Space(),
        if (asynchrony != null && asynchrony == Asynchrony.async)
          KeyWord.async$,
        if (asynchrony != null && asynchrony == Asynchrony.sync) KeyWord.sync$,
        if (!abstract) Space(),
        if (!abstract) body!,
        if (abstract) EndOfStatement(),
      ];
}
