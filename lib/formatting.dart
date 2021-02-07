import 'model.dart';

abstract class FormattingCodeLeaf extends CodeLeaf {

}

/// Increases the [Context.indentCount] by one
class IncreaseIndent extends FormattingCodeLeaf {
  @override
  String convertToString(Context context) {
    context.indentCount++;
    return "";
  }
}

/// Decreases the [Context.indentCount] by one
class DecreaseIndent extends FormattingCodeLeaf {
  @override
  String convertToString(Context context) {
    if (context.indentCount > 0) context.indentCount--;
    return "";
  }
}

/// New line character
class NewLine extends FormattingCodeLeaf {
  @override
  String convertToString(Context context) => context.newLine;
}
