import 'package:dart_code/basic.dart';
import 'package:dart_code/model.dart';

import 'expression.dart';

class Statement extends CodeModel {
  final List<CodeNode> nodes;

  Statement(this.nodes);

  Statement.assignVariable(String name, Expression value,
      {Type type, nullAware = false})
      : nodes = [
          type == null ? Type.ofVar() : type,
          SpaceWhenNeeded(),
          IdentifierStartingWithLowerCase(name),
          SpaceWhenNeeded(),
          nullAware ? Code('??=') : Code('='),
          SpaceWhenNeeded(),
          value,
        ];

  Statement.assignFinal(String name, Expression value, [Type type])
      : nodes = [
          KeyWord.$final,
          SpaceWhenNeeded(),
          if (type != null) type,
          SpaceWhenNeeded(),
          IdentifierStartingWithLowerCase(name),
          SpaceWhenNeeded(),
          Code('='),
          SpaceWhenNeeded(),
          value
        ];

  Statement.assignConst(String name, Expression value, [Type type])
      : nodes = [
          KeyWord.$const,
          SpaceWhenNeeded(),
          if (type != null) type,
          SpaceWhenNeeded(),
          IdentifierStartingWithLowerCase(name),
          Code(' = '),
          value
        ];

  @override
  List<CodeNode> codeNodes(Context context) => [
        for (CodeNode codeNode in nodes) codeNode,
        if (nodes.isNotEmpty) EndOfStatement(),
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
