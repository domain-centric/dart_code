import 'package:dart_code/annotation.dart';
import 'package:dart_code/basic.dart';
import 'package:dart_code/comment.dart';
import 'package:dart_code/formatting.dart';
import 'package:dart_code/model.dart';
import 'package:dart_code/parameter.dart';

import 'expression.dart';

class Statement extends CodeModel {
  final List<CodeNode> nodes;

  Statement(this.nodes);

  Statement.ofExpression(Expression expression) : this(expression.nodes);

  Statement.assert$(Expression expression, {String message})
      : this([
          KeyWord.assert$,
          Code('('),
          CommaSeparatedValues(
              [expression, if (message != null) Expression.ofString(message)]),
          Code(')'),
        ]);

  Statement.assignVariable(String name, Expression value,
      {bool nullAware = false})
      : this([
          IdentifierStartingWithLowerCase(name),
          SpaceWhenNeeded(),
          nullAware == true ? Code('??=') : Code('='),
          SpaceWhenNeeded(),
          value,
        ]);

  Statement.break$() : this([KeyWord.break$]);

  Statement.continue$() : this([KeyWord.continue$]);

  Statement.doWhile$(Block loopBlock, Expression condition)
      : this([
          KeyWord.do$,
          SpaceWhenNeeded(),
          loopBlock,
          SpaceWhenNeeded(),
          KeyWord.while$,
          SpaceWhenNeeded(),
          Code('('),
          condition,
          Code(')'),
        ]);

  Statement.for$(Statement initialization, Expression condition,
      Expression manipulation, Block loopBlock)
      : this([
          KeyWord.for$,
          SpaceWhenNeeded(),
          Code('('),
          for (int i = 0; i < initialization.nodes.length; i++)
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

  Statement.forEach$(Statement initialization, Expression in$, Block loopBlock)
      : this([
          KeyWord.for$,
          SpaceWhenNeeded(),
          Code('('),
          for (int i = 0; i < initialization.nodes.length; i++)
            initialization.nodes[i],
          SpaceWhenNeeded(),
          KeyWord.in$,
          SpaceWhenNeeded(),
          in$,
          Code(')'),
          SpaceWhenNeeded(),
          loopBlock,
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

  Statement.print(Expression expression)
      : this([
          Expression.callFunction(
              'print', ParameterValues([ParameterValue(expression)]))
        ]);

  Statement.rethrow$() : this([KeyWord.rethrow$]);

  Statement.return$(Expression expression)
      : this([KeyWord.return$, SpaceWhenNeeded(), expression]);

  Statement.switch$(
      Expression condition, Map<Expression, Block> valuesAndBlocks,
      {Block defaultBlock})
      : this(_createSwitchNodes(condition, valuesAndBlocks, defaultBlock));

  static List<CodeNode> _createSwitchNodes(Expression condition,
      Map<Expression, Block> valuesAndBlocks, Block defaultBlock) {
    List<CodeNode> nodes = [];
    nodes.add(KeyWord.switch$);
    nodes.add(SpaceWhenNeeded());
    nodes.add(Code('('));
    nodes.add(condition);
    nodes.add(Code(')'));
    nodes.add(SpaceWhenNeeded());
    List<CodeNode> caseNodes = _createCaseNodes(valuesAndBlocks, defaultBlock);
    nodes.add(Block(caseNodes));
    return nodes;
  }

  static List<CodeNode> _createCaseNodes(
      Map<Expression, Block> valuesAndBlocks, Block defaultBlock) {
    List<CodeNode> caseNodes = [];
    valuesAndBlocks.forEach((value, block) {
      caseNodes.addAll(_createCaseNode(value, block));
    });
    if (defaultBlock != null) {
      caseNodes.add(KeyWord.default$);
      caseNodes.add(Code(':'));
      caseNodes.add(SpaceWhenNeeded());
      caseNodes.add(defaultBlock);
    }
    return caseNodes;
  }

  static List<CodeNode> _createCaseNode(Expression value, Block block) {
    List<CodeNode> caseNodes = [];
    caseNodes.add(KeyWord.case$);
    caseNodes.add(SpaceWhenNeeded());
    caseNodes.add(value);
    caseNodes.add(Code(':'));
    caseNodes.add(SpaceWhenNeeded());
    caseNodes.add(block);
    caseNodes.add(NewLine());
    return caseNodes;
  }

  Statement.throw$(Expression expression)
      : this([
          KeyWord.throw$,
          SpaceWhenNeeded(),
          expression,
        ]);

  Statement.try$(Block tryBlock,
      {List<Catch> catches = const [], Block finallyBlock})
      : this([
          KeyWord.try$,
          SpaceWhenNeeded(),
          tryBlock,
          ...catches,
          if (finallyBlock != null) SpaceWhenNeeded(),
          if (finallyBlock != null) KeyWord.finally$,
          if (finallyBlock != null) SpaceWhenNeeded(),
          if (finallyBlock != null) finallyBlock,
        ]);

  Statement.while$(Expression condition, Block loopBlock)
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

class Catch extends CodeModel {
  final List<CodeNode> nodes;

  Catch(Block exceptionBlock,
      [String exceptionVariableName, String stackTraceVariableName])
      : this.onException(null, exceptionBlock,
            exceptionVariableName: exceptionVariableName,
            stackTraceVariableName: stackTraceVariableName);

  Catch.onException(Type exceptionType, Block exceptionBlock,
      {String exceptionVariableName, String stackTraceVariableName})
      : nodes = [
          SpaceWhenNeeded(),
          if (exceptionType != null) KeyWord.on$,
          if (exceptionType != null) SpaceWhenNeeded(),
          if (exceptionType != null) exceptionType,
          if (exceptionType != null) SpaceWhenNeeded(),
          if (exceptionVariableName != null) KeyWord.catch$,
          if (exceptionVariableName != null) Code('('),
          if (exceptionVariableName != null)
            IdentifierStartingWithLowerCase(exceptionVariableName),
          if (exceptionVariableName != null && stackTraceVariableName != null)
            Code(","),
          if (exceptionVariableName != null && stackTraceVariableName != null)
            SpaceWhenNeeded(),
          if (exceptionVariableName != null && stackTraceVariableName != null)
            IdentifierStartingWithLowerCase(stackTraceVariableName),
          if (exceptionVariableName != null) Code(')'),
          if (exceptionVariableName != null) SpaceWhenNeeded(),
          exceptionBlock,
        ];

  @override
  List<CodeNode> codeNodes(Context context) => nodes;
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
    String name, {
    Expression value,
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
