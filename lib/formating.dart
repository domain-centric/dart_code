import 'model.dart';

abstract class FormattingCodeLeaf extends CodeLeaf {

}

/// Increases the [Context.indent] by one
class IncreaseIndent extends FormattingCodeLeaf {
  @override
  String convertToString(Context context) {
    context.indent++;
    return "";
  }
}

/// Decreases the [Context.indent] by one
class DecreaseIndent extends FormattingCodeLeaf {
  @override
  String convertToString(Context context) {
    if (context.indent > 0) context.indent--;
    return "";
  }
}

/// New line character
class NewLine extends FormattingCodeLeaf {
  @override
  String convertToString(Context context) => context.newLine;
}
