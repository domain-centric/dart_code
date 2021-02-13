import 'package:dart_code/annotation.dart';
import 'package:dart_code/basic.dart';
import 'package:dart_code/comment.dart';
import 'package:dart_code/model.dart';
import 'package:dart_code/parameter.dart';

import 'expression.dart';

class Statement extends CodeModel {
  final List<CodeNode> nodes;

  Statement(this.nodes);

  Statement.assignVariable(String name, Expression value,
      {bool nullAware = false})
      : this([
          IdentifierStartingWithLowerCase(name),
          SpaceWhenNeeded(),
          nullAware == true ? Code('??=') : Code('='),
          SpaceWhenNeeded(),
          value,
        ]);

  Statement.return$(Expression expression)
      : this([KeyWord.return$, SpaceWhenNeeded(), expression]);

  Statement.print(Expression expression)
      : this([
          Expression.callFunction(
              'print', ParameterValues([ParameterValue(expression)]))
        ]);

  Statement.if$(Expression condition, Block ifBock, {Block elseBlock})
      : this([
          KeyWord.if$,
          SpaceWhenNeeded(),
          Code('('),
          condition,
          Code(')'),
          ifBock,
          if (elseBlock != null) SpaceWhenNeeded(),
          if (elseBlock != null) KeyWord.else$,
          if (elseBlock != null) SpaceWhenNeeded(),
          if (elseBlock != null) elseBlock
        ]);

  Statement.ifChain$(Map<Expression, Block> conditionsAndBlocks,
      {Block elseBlock})
      : this(_createIfChain(conditionsAndBlocks, elseBlock));

  static List<CodeNode> _createIfChain(
      Map<Expression, Block> conditionsAndBlocks, Block elseBlock) {
    List<CodeNode> nodes = [];
    bool isFirst = true;
    conditionsAndBlocks.forEach((condition, block) {
      if (!isFirst) {
        nodes.add(SpaceWhenNeeded());
        nodes.add(KeyWord.else$);
        nodes.add(SpaceWhenNeeded());
      }
      isFirst = false;
      nodes.add(KeyWord.if$);
      nodes.add(SpaceWhenNeeded());
      nodes.add(Code('('));
      nodes.add(condition);
      nodes.add(Code(')'));
      nodes.add(SpaceWhenNeeded());
      nodes.add(block);
    });
    if (elseBlock != null) {
      nodes.add(SpaceWhenNeeded());
      nodes.add(KeyWord.else$);
      nodes.add(SpaceWhenNeeded());
      nodes.add(elseBlock);
    }
    return nodes;
  }

  Statement.for$(Statement initialization, Expression condition,
      Expression manipulation, Block loopBlock)
      : this([
          KeyWord.for$,
          SpaceWhenNeeded(),
          Code('('),
          for (int i=0;i<initialization.nodes.length;i++)
                  initialization.nodes[i],
          Code(';'),
          SpaceWhenNeeded(),
          condition,
          Code(';'),
          SpaceWhenNeeded(),
          manipulation,
          Code(')'),
          SpaceWhenNeeded(),
          loopBlock,
        ]);

  Statement.forEach$(Statement initialization, Expression in$,
       Block loopBlock)
      : this([
    KeyWord.for$,
    SpaceWhenNeeded(),
    Code('('),
    for (int i=0;i<initialization.nodes.length;i++)
      initialization.nodes[i],
  SpaceWhenNeeded(),
    KeyWord.in$,
    SpaceWhenNeeded(),
    in$,
    Code(')'),
    SpaceWhenNeeded(),
    loopBlock,
  ]);


  Statement.while$(Expression condition,
      Block loopBlock)
      : this([
    KeyWord.while$,
    SpaceWhenNeeded(),
    Code('('),
    condition,
    Code(')'),
    SpaceWhenNeeded(),
    loopBlock,
  ]);

  @override
  List<CodeNode> codeNodes(Context context) => [
        for (CodeNode codeNode in nodes) codeNode,
        if (nodes.isNotEmpty) EndOfStatement(),
      ];
}

class VariableDefinition extends Statement {
  final List<DocComment> docComments;
  final List<Annotation> annotations;

  /// If a static prefix is needed (only required for class fields)
  final bool static;
  final Modifier modifier;
  final Type type;
  final IdentifierStartingWithLowerCase name;
  final Expression value;

  VariableDefinition._(this.modifier, this.name,
      {this.docComments = const [],
      this.annotations = const [],
      this.static = false,
      this.type,
      this.value})
      : super([
          for (DocComment docComment in docComments) docComment,
          for (Annotation annotation in annotations) annotation,
          if (static == true) KeyWord.static$,
          SpaceWhenNeeded(),
          if (modifier == Modifier.var$ && type == null) KeyWord.var$,
          if (modifier == Modifier.final$) KeyWord.final$,
          if (modifier == Modifier.const$) KeyWord.const$,
          SpaceWhenNeeded(),
          if (type != null) type,
          SpaceWhenNeeded(),
          name,
          if (value != null) SpaceWhenNeeded(),
          if (value != null) Code('='),
          if (value != null) SpaceWhenNeeded(),
          if (value != null) value,
        ]);

  VariableDefinition.var$(String name,
      {List<DocComment> docComments = const [],
      List<Annotation> annotations = const [],
      bool static = false,
      Type type,
      Expression value})
      : this._(Modifier.var$, IdentifierStartingWithLowerCase(name),
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);

  VariableDefinition.final$(
    String name,
    Expression value, {
    List<DocComment> docComments = const [],
    List<Annotation> annotations = const [],
    bool static = false,
    Type type,
  }) : this._(Modifier.final$, IdentifierStartingWithLowerCase(name),
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);

  VariableDefinition.const$(
    String name,
    Expression value, {
    List<DocComment> docComments = const [],
    List<Annotation> annotations = const [],
    bool static = false,
    Type type,
  }) : this._(Modifier.const$, IdentifierStartingWithLowerCase(name),
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);
}

enum Modifier { var$, final$, const$ }

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
