import 'package:dart_code/formatting.dart';

import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'expression.dart';
import 'method.dart';
import 'model.dart';
import 'parameter.dart';
import 'statement.dart';

class FieldInitializer extends CodeModel {
  final IdentifierStartingWithLowerCase name;
  final Expression value;

  FieldInitializer(String fieldName, this.value)
      : name = IdentifierStartingWithLowerCase(fieldName);

  @override
  List<CodeNode> codeNodes(Context context) =>
      [name, SpaceWhenNeeded(), Code('='), SpaceWhenNeeded(), value];
}

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



/// A [Field] is a [VariableDefinition] in a [Class].
class Field extends VariableDefinition {
  Field.var$(String name,
      {List<DocComment> docComments = const [],
      List<Annotation> annotations = const [],
      bool static = false,
      Type type,
      Expression value})
      : super.var$(name,
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);

  Field.final$(
    String name, {
    Expression value,
    List<DocComment> docComments = const [],
    List<Annotation> annotations = const [],
    bool static = false,
    Type type,
  }) : super.final$(name,
            value: value,
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type);

  Field.const$(
    String name,
    Expression value, {
    List<DocComment> docComments = const [],
    List<Annotation> annotations = const [],
    bool static = false,
    Type type,
  }) : super.const$(
          name,
          value,
          docComments: docComments,
          annotations: annotations,
          static: static,
          type: type,
        );
}

class Class extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;
  final bool abstract;
  final IdentifierStartingWithUpperCase name;
  final Type superClass;
  final List<Type> implements;
  final List<Type> mixins;

  final List<Field> fields;
  final List<Constructor> constructors;
  final List<Method> methods;

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
  List<CodeNode> codeNodes(Context context) => [
        if (docComments != null) ...docComments,
        if (annotations != null) ...annotations,
        if (abstract != null && abstract) KeyWord.abstract$,
        if (abstract != null && abstract) SpaceWhenNeeded(),
        KeyWord.class$,
        SpaceWhenNeeded(),
        name,
        SpaceWhenNeeded(),
        if (superClass != null) KeyWord.extends$,
        if (superClass != null) SpaceWhenNeeded(),
        if (superClass != null) superClass,
        if (superClass != null) SpaceWhenNeeded(),
        if (implements != null) KeyWord.implements$,
        if (implements != null) SpaceWhenNeeded(),
        if (implements != null) SeparatedValues.forParameters(implements),
        if (implements != null) SpaceWhenNeeded(),
        if (mixins != null) KeyWord.with$,
        if (mixins != null) SpaceWhenNeeded(),
        if (mixins != null) SeparatedValues.forParameters(mixins),
        if (mixins != null) SpaceWhenNeeded(),
        Block([
           NewLine(),
          if (fields != null) ...fields,
          if (fields != null) NewLine(),
          if (constructors != null) SeparatedValues.forStatements(constructors),
          if (constructors != null) NewLine(),
          if (methods != null) SeparatedValues.forStatements(methods),
          if (methods != null) NewLine(),
        ]),
      ];
}
