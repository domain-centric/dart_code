import 'dart:convert';

import 'package:dart_code/formatting.dart';
import 'package:dart_code/model.dart';

class Comment extends CodeModel {
  final List<CodeNode> nodes;
  static const String commentPrefix = '// ';

  Comment.fromString(String comment)
      : nodes = _commentsToCodeNodes([comment], commentPrefix);

  Comment.fromList(List<String> comments)
      : nodes = _commentsToCodeNodes(comments, commentPrefix);

  @override
  List<CodeNode> codeNodes(Context context) => nodes;
}

class DocComment extends CodeModel {
  final List<CodeNode> nodes;
  static const String docCommentPrefix = '/// ';

  DocComment.fromString(String comment)
      : nodes = _commentsToCodeNodes([comment], docCommentPrefix);

  DocComment.fromList(List<String> comments)
      : nodes = _commentsToCodeNodes(comments, docCommentPrefix);

  @override
  List<CodeNode> codeNodes(Context context) => nodes;
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
