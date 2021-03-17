import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'field.dart';
import 'model.dart';
import 'parameter.dart';
import 'statement.dart';
import 'type.dart';

class ConstructorCall extends CodeModel {
  final String name;
  final ParameterValues parameterValues;
  final bool super$;

  ConstructorCall({this.super$ = false, this.name, this.parameterValues});

  @override
  List<CodeNode> codeNodes(Context context) => [
        if (super$) KeyWord.super$,
        if (!super$) KeyWord.this$,
        if (name != null) Code('.'),
        if (name != null) IdentifierStartingWithLowerCase(name),
        Code('('),
        if (parameterValues != null) parameterValues,
        Code(')')
      ];
}

class Initializers extends SeparatedValues {
  Initializers(
      {List<FieldInitializer> fieldInitializers,
      ConstructorCall constructorCall})
      : super.forParameters([
          if (fieldInitializers != null) ...fieldInitializers,
          if (constructorCall != null) constructorCall
        ]) {
    _validateIfFieldInitializerNamesAreUnique(fieldInitializers);
  }

  void _validateIfFieldInitializerNamesAreUnique(
      List<FieldInitializer> fieldInitializers) {
    if (fieldInitializers != null) {
      var allNames = fieldInitializers.map((p) => p.name.toString()).toList();
      var allUniqueNames =
          fieldInitializers.map((p) => p.name.toString()).toSet();
      var namesAreUnique = allNames.length == allUniqueNames.length;
      if (!namesAreUnique)
        throw new ArgumentError.value(fieldInitializers, 'fieldInitializers',
            'Field names must be unique');
    }
  }
}

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
  final IdentifierStartingWithLowerCase name;
  final ConstructorParameters parameters;
  final Initializers initializers;
  final Block body;

  Constructor(this.type,
      {this.docComments = const [],
      this.annotations = const [],
      this.external = false,
      this.constant = false,
      this.factory = false,
      String name,
      this.parameters,
      this.initializers,
      this.body})
      : name = name == null ? null : IdentifierStartingWithLowerCase(name);

  @override
  List<CodeNode> codeNodes(Context context) => [
        ...docComments,
        ...annotations,
        if (external) KeyWord.external$,
        if (external) SpaceWhenNeeded(),
        if (constant) KeyWord.const$,
        if (constant) SpaceWhenNeeded(),
        if (factory) KeyWord.factory$,
        if (factory) SpaceWhenNeeded(),
        type,
        if (name != null) Code('.'),
        if (name != null) name,
        Code('('),
        if (parameters != null) parameters,
        Code(')'),
        if (initializers != null) SpaceWhenNeeded(),
        if (initializers != null) Code(':'),
        if (initializers != null) SpaceWhenNeeded(),
        if (initializers != null) initializers,
        if (body != null) SpaceWhenNeeded(),
        if (body != null) body,
        EndOfStatement(),
      ];
}
