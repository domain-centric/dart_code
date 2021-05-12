import 'basic.dart';
import 'expression.dart';
import 'model.dart';
import 'parameter.dart';
import 'type.dart';

/// A [Statement] is a syntactic unit of an imperative programming language that expresses some action to be carried out.
/// See: [https://dart.dev/guides/language/language-tour#control-flow-statements]
class Statement extends CodeModel {
  final List<CodeNode> nodes;
  final bool hasEndOfStatement;

  Statement(this.nodes, {this.hasEndOfStatement = true});

  Statement.ofExpression(Expression expression) : this(expression.nodes);

  Statement.assert$(Expression expression, {String? message})
      : this([
          KeyWord.assert$,
          Code('('),
          SeparatedValues.forParameters(
              [expression, if (message != null) Expression.ofString(message)]),
          Code(')'),
        ]);

  Statement.assignVariable(String name, Expression value,
      {bool nullAware = false, bool this$ = false})
      : this([
          if (this$) KeyWord.this$,
          if (this$) Code('.'),
          IdentifierStartingWithLowerCase(name),
          Space(),
          nullAware == true ? Code('??=') : Code('='),
          Space(),
          value,
        ]);

  Statement.break$() : this([KeyWord.break$]);

  Statement.continue$() : this([KeyWord.continue$]);

  Statement.doWhile$(Block loopBlock, Expression condition)
      : this([
          KeyWord.do$,
          Space(),
          loopBlock,
          Space(),
          KeyWord.while$,
          Space(),
          Code('('),
          condition,
          Code(')'),
        ]);

  Statement.for$(Statement initialization, Expression condition,
      Expression manipulation, Block loopBlock)
      : this([
          KeyWord.for$,
          Space(),
          Code('('),
          for (int i = 0; i < initialization.nodes.length; i++)
            initialization.nodes[i],
          Code(';'),
          Space(),
          condition,
          Code(';'),
          Space(),
          manipulation,
          Code(')'),
          Space(),
          loopBlock,
        ]);

  Statement.forEach$(Statement initialization, Expression in$, Block loopBlock)
      : this([
          KeyWord.for$,
          Space(),
          Code('('),
          for (int i = 0; i < initialization.nodes.length; i++)
            initialization.nodes[i],
          Space(),
          KeyWord.in$,
          Space(),
          in$,
          Code(')'),
          Space(),
          loopBlock,
        ]);

  Statement.if$(Expression condition, Block ifBock, {Block? elseBlock})
      : this([
          KeyWord.if$,
          Space(),
          Code('('),
          condition,
          Code(')'),
          ifBock,
          if (elseBlock != null) Space(),
          if (elseBlock != null) KeyWord.else$,
          if (elseBlock != null) Space(),
          if (elseBlock != null) elseBlock,
        ], hasEndOfStatement: false);

  Statement.ifChain$(Map<Expression, Block> conditionsAndBlocks,
      {Block? elseBlock})
      : this(_createIfChain(conditionsAndBlocks, elseBlock));

  static List<CodeNode> _createIfChain(
      Map<Expression, Block> conditionsAndBlocks, Block? elseBlock) {
    List<CodeNode> nodes = [];
    bool isFirst = true;
    conditionsAndBlocks.forEach((condition, block) {
      if (!isFirst) {
        nodes.add(Space());
        nodes.add(KeyWord.else$);
        nodes.add(Space());
      }
      isFirst = false;
      nodes.add(KeyWord.if$);
      nodes.add(Space());
      nodes.add(Code('('));
      nodes.add(condition);
      nodes.add(Code(')'));
      nodes.add(Space());
      nodes.add(block);
    });
    if (elseBlock != null) {
      nodes.add(Space());
      nodes.add(KeyWord.else$);
      nodes.add(Space());
      nodes.add(elseBlock);
    }
    return nodes;
  }

  Statement.library(String name)
      : this([
          KeyWord.library$,
          Space(),
          IdentifierStartingWithLowerCase(name),
        ]);

  Statement.print(Expression expression)
      : this([
          Expression.callFunction(
              'print', ParameterValues([ParameterValue(expression)]))
        ]);

  Statement.rethrow$() : this([KeyWord.rethrow$]);

  Statement.return$(Expression expression)
      : this([KeyWord.return$, Space(), expression]);

  Statement.switch$(
      Expression condition, Map<Expression, Block> valuesAndBlocks,
      {Block? defaultBlock})
      : this(_createSwitchNodes(condition, valuesAndBlocks, defaultBlock));

  static List<CodeNode> _createSwitchNodes(Expression condition,
      Map<Expression, Block> valuesAndBlocks, Block? defaultBlock) {
    List<CodeNode> nodes = [];
    nodes.add(KeyWord.switch$);
    nodes.add(Space());
    nodes.add(Code('('));
    nodes.add(condition);
    nodes.add(Code(')'));
    nodes.add(Space());
    List<CodeNode> caseNodes = _createCaseNodes(valuesAndBlocks, defaultBlock);
    nodes.add(Block(caseNodes));
    return nodes;
  }

  static List<CodeNode> _createCaseNodes(
      Map<Expression, Block> valuesAndBlocks, Block? defaultBlock) {
    List<CodeNode> caseNodes = [];
    valuesAndBlocks.forEach((value, block) {
      caseNodes.addAll(_createCaseNode(value, block));
    });
    if (defaultBlock != null) {
      caseNodes.add(KeyWord.default$);
      caseNodes.add(Code(':'));
      caseNodes.add(Space());
      caseNodes.add(defaultBlock);
    }
    return caseNodes;
  }

  static List<CodeNode> _createCaseNode(Expression value, Block block) {
    List<CodeNode> caseNodes = [];
    caseNodes.add(KeyWord.case$);
    caseNodes.add(Space());
    caseNodes.add(value);
    caseNodes.add(Code(':'));
    caseNodes.add(Space());
    caseNodes.add(block);
    return caseNodes;
  }

  Statement.throw$(Expression expression)
      : this([
          KeyWord.throw$,
          Space(),
          expression,
        ]);

  Statement.try$(Block tryBlock,
      {List<Catch> catches = const [], Block? finallyBlock})
      : this([
          KeyWord.try$,
          Space(),
          tryBlock,
          ...catches,
          if (finallyBlock != null) Space(),
          if (finallyBlock != null) KeyWord.finally$,
          if (finallyBlock != null) Space(),
          if (finallyBlock != null) finallyBlock,
        ]);

  Statement.while$(Expression condition, Block loopBlock)
      : this([
          KeyWord.while$,
          Space(),
          Code('('),
          condition,
          Code(')'),
          Space(),
          loopBlock,
        ]);

  @override
  List<CodeNode> codeNodes(Context context) => [
        ...nodes,
        if (nodes.isNotEmpty && hasEndOfStatement) EndOfStatement(),
      ];
}

class Catch extends CodeModel {
  final List<CodeNode> nodes;

  Catch(Block exceptionBlock,
      [String? exceptionVariableName, String? stackTraceVariableName])
      : this.onException(null, exceptionBlock,
            exceptionVariableName: exceptionVariableName,
            stackTraceVariableName: stackTraceVariableName);

  Catch.onException(Type? exceptionType, Block exceptionBlock,
      {String? exceptionVariableName, String? stackTraceVariableName})
      : nodes = [
          Space(),
          if (exceptionType != null) KeyWord.on$,
          if (exceptionType != null) Space(),
          if (exceptionType != null) exceptionType,
          if (exceptionType != null) Space(),
          if (exceptionVariableName != null) KeyWord.catch$,
          if (exceptionVariableName != null) Code('('),
          if (exceptionVariableName != null)
            IdentifierStartingWithLowerCase(exceptionVariableName),
          if (exceptionVariableName != null && stackTraceVariableName != null)
            Code(","),
          if (exceptionVariableName != null && stackTraceVariableName != null)
            Space(),
          if (exceptionVariableName != null && stackTraceVariableName != null)
            IdentifierStartingWithLowerCase(stackTraceVariableName),
          if (exceptionVariableName != null) Code(')'),
          if (exceptionVariableName != null) Space(),
          exceptionBlock,
        ];

  @override
  List<CodeNode> codeNodes(Context context) => nodes;
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
      ];
}
