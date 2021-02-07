import 'model.dart';

/// Converts a [CodeModel] to a formatted code [String], by going to the [CodeModel] recursively and adding [CodeLeaf]s to the result.
/// It will format the code (indent and wrap) depending on the current [Context]
class CodeBuffer {
  final Context context;
  StringBuffer codeBuffer = StringBuffer();
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
      if (code == context.newLine) {
        _appendNewLine();
      } else if (_wrapLine(code)) {
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

  bool _wrapLine(String code) {
    return code.length > 0 && lineLength + code.length > context.maxLineLength;
  }

  void _appendNewLine() {
    _appendString(context.newLine);
    lineLength = 0;
  }

  void _appendIndent() {
    String indent =  context.indent * context.indentCount;
    codeBuffer.write(indent);
    lineLength += indent.length;
  }

  void _appendWrappingIndent() {
    String indent = context.wrapIndent;
    codeBuffer.write(indent);
    lineLength += indent.length;
  }

  void _appendString(String string) {
    if (string.isNotEmpty) {
      if (lineLength == 0) _appendIndent();
      codeBuffer.write(string);
      context.lastCode = string;
      lineLength += string.length;
    }
  }

  @override
  String toString() {
    return codeBuffer.toString();
  }
}

/// Converts a [CodeModel] to a formatted String, using the constructor parameters, which already have sensible default values.
class CodeFormatter {
  final int maxLineLength;
  final String indent;
  final String wrapIndent;
  final String newLine;

  CodeFormatter(
      {this.maxLineLength = 80,
      this.indent = '  ',
      this.wrapIndent = '    ',
      this.newLine = '\n'});

  String format(CodeNode codeNode) {
    Context context = Context(codeNode,
        maxLineLength: maxLineLength,
        newLine: newLine,
        indent: indent,
        wrapIndent: wrapIndent);
    CodeBuffer codeBuffer = CodeBuffer(context, codeNode);
    return codeBuffer.toString();
  }
}
