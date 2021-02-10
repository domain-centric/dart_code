import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'expression.dart';
import 'model.dart';
import 'statement.dart';

class Constructor extends Statement {
  // TODO final List<DocComment> docComments;
  // TODO final List<Annotation> annotations;
  // TODO final bool static;
  // TODO final bool abstract;
  // TODO final IdentifierStartingWithUpperCase name;

  Constructor(final List<CodeNode> nodes) : super(nodes);
}

class Method extends Statement {
  // TODO final List<DocComment> docComments;
  // TODO final List<Annotation> annotations;
  // TODO final bool static;
  // TODO final bool abstract;
  // TODO final IdentifierStartingWithLowerCase name;

  Method(List<CodeNode> nodes) : super(nodes);
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
        if (abstract) KeyWord.$abstract,
        SpaceWhenNeeded(),
        KeyWord.$class,
        SpaceWhenNeeded(),
        name,
        SpaceWhenNeeded(),
        if (superClass != null) KeyWord.$extends,
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
