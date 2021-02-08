import 'package:dart_code/basic.dart';
import 'package:dart_code/model.dart';

class Statement extends CodeModel {
  final List<CodeNode> statementCodes;

  Statement(this.statementCodes);

  @override
  List<CodeNode> codeNodes(Context context) => [
    for (CodeNode codeNode in statementCodes) codeNode,
    if (statementCodes.isNotEmpty) EndOfStatement(),
  ];
}

class Statements extends CodeModel {
  final List<Statement> statements;

  Statements(this.statements);

  @override
  List<CodeNode> codeNodes(Context context) => statements;
}

/// ;
class EndOfStatement extends CodeModel {
  @override
  List<CodeNode> codeNodes(Context context) => [
    NoneRepeatingCode(';'),
    NoneRepeatingCode(context.newLine),
  ];
}
