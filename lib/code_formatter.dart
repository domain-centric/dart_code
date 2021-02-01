
import 'formating.dart';
import 'model.dart';

/// Converts a [CodeModel] to a formatted code [String], by going to the [CodeModel] recursively and adding [CodeLeaf]s to the result.
/// It will format the code (indent and wrap) depending on the current [Context]
class CodeBuffer {
  final StringBuffer codeBuffer = StringBuffer();
  final Context context;
  int lineLength = 0;

  CodeBuffer(this.context, CodeNode codeNode) {
    _appendNode(codeNode);
  }

  _appendNodes(List<CodeNode> codeNodes) {
    for (CodeNode codeNode in codeNodes) {
      _appendNode(codeNode);
    }
  }

  _appendNode(CodeNode codeNode) {
    if (codeNode is CodeLeaf) {
      String code = codeNode.convertToString(context);
      context.previousCodeLeaf = codeNode;
      if (codeNode is NewLine) {
        _appendNewLine();
      } else if (code.length > 0 &&
          lineLength + code.length > context.maxLineLength) {
        _appendNewLine();
        _appendWrappingIndent();
        _appendString(code);
      } else {
        _appendString(code);
      }
    } else if (codeNode is CodeModel) {
      // recursive call
      _appendNodes(codeNode.codeNodes(context));
    }
  }

  final _newLine = NewLine();

  void _appendNewLine() {
    String code = _newLine.convertToString(context);
    codeBuffer.write(code);
    context.previousCodeLeaf = _newLine;
    lineLength = 0;
  }

  void _appendIndent() {
    String indent = ' ' * (context.indent * context.indentWidth);
    codeBuffer.write(indent);
    lineLength += indent.length;
  }

  void _appendWrappingIndent() {
    String wrappingIndent = ' ' * (2 * context.indentWidth);
    _appendString(wrappingIndent);
  }

  void _appendString(String string) {
    if (lineLength == 0) _appendIndent();
    codeBuffer.write(string);
    lineLength += string.length;
  }

  @override
  String toString() {
    return codeBuffer.toString();
  }
}

/// Converts a [CodeModel] to a formatted String, using the constructor parameters, which already have sensible default values.
class CodeFormatter {
  final int maxLineLength;
  final int indentWidth;
  final String newLine;

  CodeFormatter(
      {this.maxLineLength = 80, this.indentWidth = 2, this.newLine = '\n'});

  String format(CodeNode codeNode) {
    Context context = Context(codeNode,
        maxLineLength: maxLineLength,
        newLine: newLine,
        indentWidth: indentWidth);
    CodeBuffer codeBuffer = CodeBuffer(context, codeNode);
    return codeBuffer.toString();
  }
}


