import 'model.dart';
import 'variable_definition.dart';
import 'basic.dart';
import 'annotation.dart';
import 'comment.dart';
import 'expression.dart';

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

class FieldInitializer extends CodeModel {
  final IdentifierStartingWithLowerCase name;
  final Expression value;

  FieldInitializer(String fieldName, this.value)
      : name = IdentifierStartingWithLowerCase(fieldName);

  @override
  List<CodeNode> codeNodes(Context context) =>
      [name, SpaceWhenNeeded(), Code('='), SpaceWhenNeeded(), value];
}
