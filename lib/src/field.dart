import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'expression.dart';
import 'model.dart';
import 'type.dart';
import 'variable_definition.dart';

/// A [Field] is a [VariableDefinition] in a [Class].
/// See [https://dart.dev/guides/language/language-tour#using-class-members]
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

/// A [FieldInitializer] is a [VariableDefinition] with a value assignment within a [Class].
/// See [https://dart.dev/guides/language/language-tour#using-class-members]
class FieldInitializer extends CodeModel {
  final IdentifierStartingWithLowerCase name;
  final Expression value;

  FieldInitializer(String fieldName, this.value)
      : name = IdentifierStartingWithLowerCase(fieldName);

  @override
  List<CodeNode> codeNodes(Context context) =>
      [name, Space(), Code('='), Space(), value];
}
