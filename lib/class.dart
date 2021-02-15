import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'expression.dart';
import 'model.dart';
import 'parameter.dart';
import 'statement.dart';

class Constructor extends Statement {
  // TODO final List<DocComment> docComments;
  // TODO final List<Annotation> annotations;
  // TODO final bool static;
  // TODO final bool abstract;
  // TODO final IdentifierStartingWithUpperCase name;

  Constructor(final List<CodeNode> nodes) : super(nodes);
}

class Method extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;
  final bool abstract;
  final bool static;
  final Type returnType;
  final IdentifierStartingWithLowerCase name;
  final Parameters parameters;
  final Body body;

  Method.abstract(String name,
      {this.docComments = const [],
      this.annotations = const [],
      this.parameters,
      this.returnType})
      : abstract = true,
        static = false,
        name = IdentifierStartingWithLowerCase(name),
        body = null;

  Method.static(String name, CodeNode body,
      {this.docComments = const [],
      this.annotations = const [],
      this.parameters,
      this.returnType})
      : abstract = false,
        static = true,
        name = IdentifierStartingWithLowerCase(name),
        body = Body([body]);

  Method(String name, CodeNode body,
      {this.docComments = const [],
      this.annotations = const [],
      this.parameters,
      this.returnType})
      : abstract = false,
        static = false,
        name = IdentifierStartingWithLowerCase(name),
        body = Body([body]);

  @override
  List<CodeNode> codeNodes(Context context) => [
        ...docComments,
        ...annotations,
        if (abstract) KeyWord.abstract$,
        if (abstract) SpaceWhenNeeded(),
        if (static) KeyWord.static$,
        if (static) SpaceWhenNeeded(),
        if (returnType != null) returnType,
        if (returnType != null) SpaceWhenNeeded(),
        name,
        Code('('),
        if (parameters != null) parameters,
        Code(')'),
        if (!abstract) SpaceWhenNeeded(),
        if (!abstract) body,
        if (abstract) EndOfStatement(),
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
    String name,
    Expression value, {
    List<DocComment> docComments = const [],
    List<Annotation> annotations = const [],
    bool static = false,
    Type type,
  }) : super.final$(name, value,
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
  // TODO final List<DocComment> docComments;
  // TODO final List<Annotation> annotations;
  bool abstract;

  // TODO bool static;
  final IdentifierStartingWithUpperCase name;
  Type superClass;

  // TODO List<Type> implements = [];
  // TODO List<Type> mixins = [];
  // TODO List<Field> fields;
  // TODO List<PropertyAccessor> propertyAccessors;
  // TODO List<Constructor> constructors;
  // TODO List<Method> methods;

  Class(String name) : this.name = IdentifierStartingWithUpperCase(name);

  @override
  List<CodeNode> codeNodes(Context context) => [
        //TODO DocComments
        //TODO Annotations
        if (abstract) KeyWord.abstract$,
        SpaceWhenNeeded(),
        KeyWord.class$,
        SpaceWhenNeeded(),
        name,
        SpaceWhenNeeded(),
        if (superClass != null) KeyWord.extends$,
        SpaceWhenNeeded(),
        if (superClass != null) superClass,
        // TODO implements
        //TODO with mixins
        SpaceWhenNeeded(),
        Block([
          Code(";"), //TODO  fields, propertyAccessors, constructors, methods
        ]),
      ];
}
