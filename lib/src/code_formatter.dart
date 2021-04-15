import 'package:dart_style/dart_style.dart';

import 'model.dart';

/// Converts a [CodeNode] to a formatted String, using the constructor parameters.
/// Using the official (dartfmt)[https://github.com/dart-lang/dart_style/wiki/Formatting-Rules] with the dart_style package
/// Note that this formatter may throw parsing exceptions.
/// You can use the [CodeFormatter.unFormatted] method when you need a code partial that can not be parsed by the Dart formatter
class CodeFormatter {
  final DartFormatter dartFormatter;

  CodeFormatter({String lineEnding, int pageWidth, int indent})
      : dartFormatter = DartFormatter(
            lineEnding: lineEnding, pageWidth: pageWidth, indent: indent);

  String format(CodeNode codeNode) {
    String unFormattedCode = unFormatted(codeNode);
    String formattedCode = dartFormatter.format(unFormattedCode);
    return formattedCode;
  }

  String unFormatted(CodeNode codeNode) {
    Context context = Context(codeNode);
    return codeNode.toUnFormattedString(context);
  }
}
