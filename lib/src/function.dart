import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'model.dart';
import 'parameter.dart';
import 'type.dart';

/// Represents a [DartFunction]
/// See: [https://dart.dev/guides/language/language-tour#functions]
// ignore: deprecated_function_class_declaration
class DartFunction extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;
  final Type? returnType;
  final IdentifierStartingWithLowerCase? name;
  final Parameters? parameters;
  final Asynchrony? asynchrony;
  final Body body;

  DartFunction.withoutName(
    CodeNode body, {
    this.docComments = const [],
    this.annotations = const [],
    this.returnType,
    this.parameters,
    this.asynchrony,
  })  : name = null,
        body = Body([body]);

  DartFunction.withName(
    String name,
    CodeNode body, {
    this.docComments = const [],
    this.annotations = const [],
    this.returnType,
    this.parameters,
    this.asynchrony,
  })  : name = IdentifierStartingWithLowerCase(name),
        body = Body([body]);

  DartFunction.main(
    CodeNode body, {
    this.docComments = const [],
    this.annotations = const [],
    this.parameters,
    this.asynchrony,
  })  : returnType = null,
        name = IdentifierStartingWithLowerCase('main'),
        body = Body([body]);

  @override
  List<CodeNode> codeNodes(Context context) => [
        ...docComments,
        ...annotations,
        Space(),
        if (returnType != null) returnType!,
        Space(),
        if (name != null) name!,
        Code('('),
        if (parameters != null) parameters!,
        Code(')'),
        if (asynchrony != null) Space(),
        if (asynchrony != null && asynchrony == Asynchrony.async)
          KeyWord.async$,
        if (asynchrony != null && asynchrony == Asynchrony.sync) KeyWord.sync$,
        Space(),
        body,
      ];
}

class FunctionCall extends CodeModelWithLibraryUri {
  final IdentifierStartingWithLowerCase name;
  final ParameterValues? parameterValues;
  final Type? genericType;

  FunctionCall(
    String name, {
    String? libraryUri,
    this.genericType,
    this.parameterValues,
  })  : name = IdentifierStartingWithLowerCase(name),
        super(libraryUri: libraryUri);

  @override
  List<CodeNode> codeNodesToWrap(Context context) => [
        name,
        if (genericType != null) Code('<'),
        if (genericType != null) genericType!,
        if (genericType != null) Code('>'),
        Code('('),
        if (parameterValues != null) parameterValues!,
        Code(')'),
      ];
}
