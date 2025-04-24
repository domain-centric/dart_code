// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'dart:convert';

import 'package:dart_code/dart_code.dart';

/// Represents a [Comment].
/// See: [https://dart.dev/guides/language/language-tour#comments]
class Comment extends CodeModel {
  final List<CodeNode> nodes;
  static const String commentPrefix = '// ';

  Comment.fromString(String comment)
      : nodes = _commentsToCodeNodes([comment], commentPrefix);

  Comment.fromList(List<String> comments)
      : nodes = _commentsToCodeNodes(comments, commentPrefix);

  @override
  List<CodeNode> codeNodes(Imports imports) => nodes;
}

/// Represents a [DocComment].
/// See: [https://dart.dev/guides/language/language-tour#documentation-comments]
class DocComment extends CodeModel {
  final List<CodeNode> nodes;
  static const String docCommentPrefix = '/// ';

  DocComment.fromString(String comment)
      : nodes = _commentsToCodeNodes([comment], docCommentPrefix);

  DocComment.fromList(List<String> comments)
      : nodes = _commentsToCodeNodes(comments, docCommentPrefix);

  @override
  List<CodeNode> codeNodes(Imports imports) => nodes;
}

List<CodeNode> _commentsToCodeNodes(List<String> comments, String prefix) {
  List<CodeNode> nodes = [];
  for (String comment in comments) {
    var lines = LineSplitter.split(comment);
    for (String line in lines) {
      line = _removeLeadingSlashes(line);
      nodes.add(Code(prefix + line));
      nodes.add(NewLine());
    }
  }
  return nodes;
}

final RegExp _startWithSlash = RegExp(r'^/');
final RegExp _startWithSpace = RegExp('^\\s');

String _removeLeadingSlashes(String line) {
  while (_startWithSlash.hasMatch(line)) {
    line = line.replaceAll(_startWithSlash, '');
  }
  return line.replaceFirst(_startWithSpace, '');
}
