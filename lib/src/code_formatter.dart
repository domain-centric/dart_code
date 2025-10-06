// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// Converts a [CodeNode] to a formatted String, using the constructor parameters.
/// Using the official (dartfmt)[https://github.com/dart-lang/dart_style/wiki/Formatting-Rules] with the dart_style package
/// Note that this formatter may throw parsing exceptions.
/// You can use the [CodeFormatter.unFormatted] method when you need a code partial that can not be parsed by the Dart formatter
@Deprecated(
  'Use CodeNode.toFormattedString() or CodeNode.toUnFormattedString() instead',
)
class CodeFormatter {
  String? lineEnding;
  int? pageWidth;
  int? indent;
  List<String>? experimentFlags;
  CodeFormatter({
    this.lineEnding,
    this.pageWidth,
    this.indent,
    this.experimentFlags,
  });

  @Deprecated('Use CodeNode.toFormattedString() instead')
  String format(CodeNode codeNode) => codeNode.toFormattedString(
    lineEnding: lineEnding,
    pageWidth: pageWidth,
    indent: indent,
    experimentFlags: experimentFlags,
  );

  @Deprecated('Use CodeNode.toUnFormattedString() instead')
  String unFormatted(CodeNode codeNode) =>
      codeNode.toUnFormattedString(Imports());
}
