// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

///  An [Expression] is a syntactic entity in the Dart programming language
///  that may be evaluated to determine its value
///  e.g.: 1 or or 1.1 or 1+2 or 'hello' or 'hello' + ' world' or user.name
///  See: [https://dart.dev/guides/language/language-tour#operators]
class Expression extends CodeModel {
  final List<CodeNode> nodes;

  /// =========================================================================
  ///                            CONSTRUCTORS
  /// =========================================================================

  Expression(this.nodes);

  Expression.ofNull() : nodes = [Code('null')];

  Expression.ofInt(int value) : nodes = [Code(value.toString())];

  Expression.ofDouble(double value) : nodes = [Code(value.toString())];

  Expression.ofBool(bool value) : nodes = [Code(value.toString())];

  Expression.ofDateTime(DateTime value) : nodes = [Code(value.toString())];

  Expression.ofString(String value) : nodes = _createStringNodes(value);

  Expression.ofList(List<Expression> expressions)
      : nodes = [
          Code('['),
          SeparatedValues.forParameters(expressions),
          Code(']')
        ];

  Expression.ofSet(Set<Expression> expressions)
      : nodes = [
          Code('{'),
          SeparatedValues.forParameters(expressions),
          Code('}')
        ];

  Expression.ofMap(Map<Expression, Expression> expressions)
      : nodes = _createMapNodes(expressions);

  static List<CodeNode> _createMapNodes(
          Map<Expression, Expression> expressions) =>
      [
        Code('{'),
        SeparatedValues.forParameters(_createKeyValueExpressions(expressions)),
        Code('}')
      ];

  static List<Expression> _createKeyValueExpressions(
          Map<Expression, Expression> expressions) =>
      expressions.keys
          .map((key) => _createKeyValueExpression(key, expressions[key]!))
          .toList();

  static Expression _createKeyValueExpression(
          Expression key, Expression value) =>
      Expression([
        key,
        Space(),
        Code(':'),
        Space(),
        value,
      ]);

  Expression.ofType(BaseType type) : nodes = [type];

  Expression.ofRecord(List<RecordFieldValue> values)
      : nodes = [
          Code('('),
          SeparatedValues.forParameters(values),
          Code(')'),
        ];

  static RegExp _singleQuote = RegExp("'");
  static RegExp _doubleQuote = RegExp('"');
  static RegExp _betweenSingleQuotes = RegExp("^'.*'\$");
  static RegExp _betweenDoubleQuotes = RegExp('^".*"\$');

  static _createStringNodes(String value) {
    if (!_betweenSingleQuotes.hasMatch(value) &&
        !_betweenDoubleQuotes.hasMatch(value)) {
      int nrSingleQuotes = _singleQuote.allMatches(value).length;
      int nrDoubleQuotes = _doubleQuote.allMatches(value).length;
      if (nrSingleQuotes > 0 && nrDoubleQuotes == 0) {
        value = '"$value"';
      } else {
        value = "'$value'";
      }
    }
    return [Code(value.toString())];
  }

  Expression.ofVariable(String name)
      : nodes = [
          IdentifierStartingWithLowerCase(name),
        ];

  Expression.ofThis() : nodes = [KeyWord.this$];

  Expression.ofThisField(String name)
      : nodes = [
          KeyWord.this$,
          Code('.'),
          IdentifierStartingWithLowerCase(name)
        ];

  Expression.ofSuper() : nodes = [KeyWord.super$];

  Expression.ofSuperField(String name)
      : nodes = [
          KeyWord.super$,
          Code('.'),
          IdentifierStartingWithLowerCase(name)
        ];

  /// A call to a method in the same class or a function
  Expression.callMethodOrFunction(
    String name, {
    String? libraryUri,
    Type? genericType,
    ParameterValues? parameterValues,
  }) : nodes = [
          FunctionCall(name,
              libraryUri: libraryUri,
              genericType: genericType,
              parameterValues: parameterValues)
        ];

  Expression.callConstructor(
    Type type, {
    String? name,
    ParameterValues? parameterValues,
    bool isConst = false,
  }) : nodes = [
          if (isConst) KeyWord.const$,
          if (isConst) Space(),
          type,
          if (name != null) Code('.'),
          if (name != null) IdentifierStartingWithLowerCase(name),
          Code('('),
          if (parameterValues != null) parameterValues,
          Code(')'),
        ];

  Expression.ofEnum(Type type, String value)
      : nodes = [
          type,
          Code('.'),
          IdentifierStartingWithLowerCase(value),
        ];

  Expression.betweenParentheses(Expression expression)
      : nodes = [Code('('), expression, Code(')')];

  /// =========================================================================
  ///                        OPERATORS AS FLUENT METHODS
  /// =========================================================================

  /// Returns the result of `this` `&&` [other].
  Expression and(Expression other) =>
      Expression([this, Space(), Operator.logicalAnd, Space(), other]);

  /// Returns the result of `this` `||` [other].
  Expression or(Expression other) =>
      Expression([this, Space(), Operator.logicalOr, Space(), other]);

  /// Returns the result of `!this`.
  Expression negate() => Expression([Operator.negate, this]);

  /// Returns the result of `this` `as` [other].
  Expression asA(BaseType otherType) =>
      Expression([this, Space(), Operator.asType, Space(), otherType, Space()]);

  /// Returns accessing the index operator (`[]`) on `this`.
  Expression index(Expression index) =>
      Expression([this, Code('['), index, Code(']')]);

  /// Returns the result of `this` `is` [other].
  Expression isA(Expression other) =>
      Expression([this, Space(), Operator.isType, Space(), other]);

  /// Returns the result of `this` `is!` [other].
  Expression isNotA(Expression other) =>
      Expression([this, Space(), Operator.isNotType, Space(), other]);

  /// Returns the result of `this` `==` [other].
  Expression equalTo(Expression other) =>
      Expression([this, Space(), Operator.equals, Space(), other]);

  /// Returns the result of `this` `!=` [other].
  Expression notEqualTo(Expression other) =>
      Expression([this, Space(), Operator.notEquals, Space(), other]);

  /// Returns the result of `this` `>` [other].
  Expression greaterThan(Expression other) =>
      Expression([this, Space(), Operator.greaterThan, Space(), other]);

  /// Returns the result of `this` `<` [other].
  Expression lessThan(Expression other) =>
      Expression([this, Space(), Operator.lessThan, Space(), other]);

  /// Returns the result of `this` `>=` [other].
  Expression greaterOrEqualTo(Expression other) => Expression(
      [this, Space(), Operator.greaterThanOrEqualTo, Space(), other]);

  /// Returns the result of `this` `<=` [other].
  Expression lessOrEqualTo(Expression other) =>
      Expression([this, Space(), Operator.lessThanOrEqualTo, Space(), other]);

  /// Returns the result of `this` `+` [other].
  Expression add(Expression other) =>
      Expression([this, Space(), Operator.add, Space(), other]);

  /// Returns the result of `this` `-` [other].
  Expression subtract(Expression other) =>
      Expression([this, Space(), Operator.subtract, Space(), other]);

  /// Returns the result of `this` `/` [other].
  Expression divide(Expression other) =>
      Expression([this, Space(), Operator.divide, Space(), other]);

  /// Returns the result of `this` `*` [other].
  Expression multiply(Expression other) =>
      Expression([this, Space(), Operator.multiply, Space(), other]);

  /// Returns the result of `this` `%` [other].
  Expression modulo(Expression other) =>
      Expression([this, Space(), Operator.modulo, Space(), other]);

  /// Returns the result of this++ or ++this.
  Expression increment({after = true}) => after
      ? Expression([this, Operator.increment])
      : Expression([Operator.increment, this]);

  /// Returns the result of this-- or --this.
  Expression decrement({after = true}) => after
      ? Expression([this, Operator.decrement])
      : Expression([Operator.decrement, this]);

  /// Return `{this} ? {whenTrue} : {whenFalse}`.
  Expression conditional(Expression whenTrue, Expression whenFalse) =>
      Expression([
        this,
        Space(),
        Code('?'),
        Space(),
        whenTrue,
        Space(),
        Code(':'),
        Space(),
        whenFalse
      ]);

  /// Return `{this} ?? {alternativeWhenNull} '`.
  Expression ifNull(Expression alternativeWhenNull) => Expression([
        this,
        Space(),
        Operator.nullCoalesce,
        Space(),
        alternativeWhenNull,
      ]);

  /// Return '{this}!'
  Expression assertNull() => Expression([
        this,
        Operator.negate,
      ]);

  /// This expression preceded by `await`.
  Expression awaited() => Expression([Code('await'), Space(), this]);

  ///===========================================================================
  ///                     OTHER FLUENT METHODS
  ///===========================================================================

  Expression callMethod(
    String name, {
    Type? genericType,
    ParameterValues? parameterValues,
    bool cascade = false,
    bool ifNullReturnNull = false,
  }) =>
      Expression([
        this,
        if (ifNullReturnNull) Code('?'),
        Code('.'),
        if (cascade) Code('.'),
        FunctionCall(
          name,
          genericType: genericType,
          parameterValues: parameterValues,
        ),
      ]);

  Expression getProperty(
    String name, {
    bool cascade = false,
    bool ifNullReturnNull = false,
  }) =>
      Expression([
        this,
        if (ifNullReturnNull) Code('?'),
        Code('.'),
        if (cascade) Code('.'),
        IdentifierStartingWithLowerCase(name),
      ]);

  Expression setProperty(
    String name,
    Expression value, {
    bool cascade = false,
  }) =>
      Expression([
        this,
        Code('.'),
        if (cascade) Code('.'),
        IdentifierStartingWithLowerCase(name),
        Space(),
        Code('='),
        Space(),
        value,
      ]);

  Statement assignVariable(String name, {nullAware = false}) =>
      Statement.assignVariable(name, this, nullAware: nullAware);

  Statement defineVariable(String name,
          {List<DocComment> docComments = const [],
          List<Annotation> annotations = const [],
          bool static = false,
          Modifier modifier = Modifier.var$,
          BaseType? type,
          Expression? value}) =>
      VariableDefinition(
        name,
        docComments: docComments,
        annotations: annotations,
        static: static,
        modifier: modifier,
        type: type,
        value: this,
      );

  ///===========================================================================
  ///                             codeNodes
  ///===========================================================================

  @override
  List<CodeNode> codeNodes(Imports imports) => nodes;
}
