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
  Field(String name,
      {List<DocComment> docComments = const [],
      List<Annotation> annotations = const [],
      bool static = false,
      Modifier modifier = Modifier.var$,
      Type? type,
      bool nullable = false,
      Expression? value})
      : super(name,
            docComments: docComments,
            annotations: annotations,
            static: static,
            modifier: modifier,
            type: type,
            nullable: nullable,
            value: value);
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
