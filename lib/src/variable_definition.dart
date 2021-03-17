import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'expression.dart';
import 'model.dart';
import 'statement.dart';
import 'type.dart';

enum Modifier { var$, final$, const$ }

class VariableDefinition extends Statement {
  final List<DocComment> docComments;
  final List<Annotation> annotations;

  /// If a static prefix is needed (only required for class fields)
  final bool static;
  final Modifier modifier;
  final Type type;
  final IdentifierStartingWithLowerCase name;
  final Expression value;

  VariableDefinition._(this.modifier, this.name,
      {this.docComments = const [],
      this.annotations = const [],
      this.static = false,
      this.type,
      this.value})
      : super([
          if (docComments != null) ...docComments,
          if (annotations != null) ...annotations,
          if (static == true) KeyWord.static$,
          SpaceWhenNeeded(),
          if (modifier == Modifier.var$ && type == null) KeyWord.var$,
          if (modifier == Modifier.final$) KeyWord.final$,
          if (modifier == Modifier.const$) KeyWord.const$,
          SpaceWhenNeeded(),
          if (type != null) type,
          SpaceWhenNeeded(),
          name,
          if (value != null) SpaceWhenNeeded(),
          if (value != null) Code('='),
          if (value != null) SpaceWhenNeeded(),
          if (value != null) value,
        ]);

  VariableDefinition.var$(String name,
      {List<DocComment> docComments = const [],
      List<Annotation> annotations = const [],
      bool static = false,
      Type type,
      Expression value})
      : this._(Modifier.var$, IdentifierStartingWithLowerCase(name),
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);

  VariableDefinition.final$(
    String name, {
    Expression value,
    List<DocComment> docComments = const [],
    List<Annotation> annotations = const [],
    bool static = false,
    Type type,
  }) : this._(Modifier.final$, IdentifierStartingWithLowerCase(name),
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);

  VariableDefinition.const$(
    String name,
    Expression value, {
    List<DocComment> docComments = const [],
    List<Annotation> annotations = const [],
    bool static = false,
    Type type,
  }) : this._(Modifier.const$, IdentifierStartingWithLowerCase(name),
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);
}
