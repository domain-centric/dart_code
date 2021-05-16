import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'expression.dart';
import 'model.dart';
import 'statement.dart';
import 'type.dart';

enum Modifier { var$, lateVar$, final$, lateFinal$, const$ }

/// A Variable is used to store the value and refer the memory location in computer memory.
/// When we create a variable (with a [VariableDefinition] also known as variable declaration), the Dart compiler allocates some space in memory.
/// The size of the memory block of memory is depended upon the type of variable.
class VariableDefinition extends Statement {
  final List<DocComment> docComments;
  final List<Annotation> annotations;

  /// If a static prefix is needed (only required for class fields)
  final bool static;
  final Modifier modifier;
  final Type? type;
  final String name;
  final Expression? value;

  VariableDefinition(this.name,
      {this.docComments = const [],
      this.annotations = const [],
      this.static = false,
      this.modifier = Modifier.var$,
      this.type,
      this.value})
      : super([
          ...docComments,
          ...annotations,
          if (static) KeyWord.static$,
          if (static) Space(),
          if (modifier == Modifier.lateVar$ || modifier == Modifier.lateFinal$)
            KeyWord.late$,
          if (modifier == Modifier.lateVar$ || modifier == Modifier.lateFinal$)
            Space(),
          if ((modifier == Modifier.var$ || modifier == Modifier.lateVar$) &&
              type == null)
            KeyWord.var$,
          if ((modifier == Modifier.var$ || modifier == Modifier.lateVar$) &&
              type == null)
            Space(),
          if (modifier == Modifier.final$ || modifier == Modifier.lateFinal$)
            KeyWord.final$,
          if (modifier == Modifier.final$ || modifier == Modifier.lateFinal$)
            Space(),
          if (modifier == Modifier.const$) KeyWord.const$,
          if (modifier == Modifier.const$) Space(),
          if (type != null) type,
          if (type != null) Space(),
          IdentifierStartingWithLowerCase(name),
          if (value != null) Space(),
          if (value != null) Code('='),
          if (value != null) Space(),
          if (value != null) value,
        ]);
}
