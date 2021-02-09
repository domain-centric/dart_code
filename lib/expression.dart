import 'package:dart_code/basic.dart';
import 'package:dart_code/formatting.dart';
import 'package:dart_code/parameter.dart';
import 'package:dart_code/statement.dart';

import 'model.dart';

///  A syntactic entity in the Dart programming language that may be evaluated to determine its value
///  e.g.: 1 or or 1.1 or 1+2 or 1*2 or 'hello' or 'hello' + ' world' or user.name
class Expression extends CodeModel {
  final List<CodeNode> nodes;

  /// =========================================================================
  ///                            CONSTRUCTORS
  /// =========================================================================

  Expression(this.nodes);

  Expression.ofInt(int value) : nodes = [Code(value.toString())];

  Expression.ofDouble(double value) : nodes = [Code(value.toString())];

  Expression.ofBool(bool value) : nodes = [Code(value.toString())];

  Expression.ofDateTime(DateTime value) : nodes = [Code(value.toString())];

  Expression.ofString(String value) : nodes = _createStringNodes(value);

  static RegExp singleQuote = RegExp("'");
  static RegExp doubleQuote = RegExp('"');
  static RegExp betweenSingleQuotes = RegExp("^'.*'\$");
  static RegExp betweenDoubleQuotes = RegExp('^".*"\$');

  static _createStringNodes(String value) {
    if (!betweenSingleQuotes.hasMatch(value) &&
        !betweenDoubleQuotes.hasMatch(value)) {
      int nrSingleQoutes = singleQuote.allMatches(value).length;
      int nrDoubleQoutes = doubleQuote.allMatches(value).length;
      if (nrSingleQoutes > 0 && nrDoubleQoutes == 0) {
        value = '"$value"';
      } else {
        value = "'$value'";
      }
    }
    return [Code(value.toString())];
  }

  Expression.ofVariable(String name)
      : nodes = [IdentifierStartingWithLowerCase(name)];

  Expression.callFunction(String name, [ParameterValues parameterValues])
      : nodes = [
          if (name != null) IdentifierStartingWithLowerCase(name),
          Code('('),
          if (parameterValues != null) parameterValues,
          Code(')'),
        ];

  Expression.callConstructor(Type type,
      {String name, ParameterValues parameterValues})
      : nodes = [
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

  /// =========================================================================
  ///                        OPERATORS AS FLUENT METHODS
  /// =========================================================================

  /// Returns the result of `this` `&&` [other].
  Expression and(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('&&'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `||` [other].
  Expression or(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('||'), SpaceWhenNeeded(), other]);

  /// Returns the result of `!this`.
  Expression negate() => Expression([Code('!'), this]);

  /// Returns the result of `this` `as` [other].
  Expression asA(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('as'), SpaceWhenNeeded(), other]);

  /// Returns accessing the index operator (`[]`) on `this`.
  Expression index(Expression index) =>
      Expression([this, Code('['), index, Code(']')]);

  /// Returns the result of `this` `is` [other].
  Expression isA(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('is'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `is!` [other].
  Expression isNotA(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('is!'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `==` [other].
  Expression equalTo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('=='), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `!=` [other].
  Expression notEqualTo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('!='), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `>` [other].
  Expression greaterThan(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('>'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `<` [other].
  Expression lessThan(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('<'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `>=` [other].
  Expression greaterOrEqualTo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('>='), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `<=` [other].
  Expression lessOrEqualTo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('<='), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `+` [other].
  Expression add(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('+'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `-` [other].
  Expression substract(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('-'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `/` [other].
  Expression divide(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('/'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `*` [other].
  Expression multiply(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('*'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `%` [other].
  Expression modulo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('%'), SpaceWhenNeeded(), other]);

  Expression conditional(Expression whenTrue, Expression whenFalse) =>
      Expression([
        this,
        SpaceWhenNeeded(),
        Code('?'),
        SpaceWhenNeeded(),
        whenTrue,
        SpaceWhenNeeded(),
        Code(':'),
        SpaceWhenNeeded(),
        whenFalse
      ]);

  /// This expression preceded by `await`.
  Expression awaited() => Expression([Code('await'), SpaceWhenNeeded(), this]);

  /// Return `{other} ?? {this}`.
  Expression ifNullThen(Expression other) => Expression(
      [other, SpaceWhenNeeded(), Code('??'), SpaceWhenNeeded(), this]);

  ///===========================================================================
  ///                     OTHER FLUENT METHODS
  ///===========================================================================

  Expression callMethod(String name,
          {ParameterValues parameterValues, bool cascade = false}) =>
      Expression([
        this,
        if (!cascade) Code('.'),
        if (cascade) NewLine(),
        if (cascade) Code('..'),
        IdentifierStartingWithLowerCase(name),
        Code('('),
        if (parameterValues != null) parameterValues,
        Code(')'),
      ]);

  Expression getProperty(String name, {bool cascade = false}) => Expression([
        this,
        if (!cascade) Code('.'),
        if (cascade) NewLine(),
        if (cascade) Code('..'),
        IdentifierStartingWithLowerCase(name),
      ]);

  Expression setProperty(String name, Expression value,
          {bool cascade = false}) =>
      Expression([
        this,
        if (!cascade) Code('.'),
        if (cascade) NewLine(),
        if (cascade) Code('..'),
        IdentifierStartingWithLowerCase(name),
        SpaceWhenNeeded(),
        Code('='),
        SpaceWhenNeeded(),
        value,
      ]);

  Statement assignVariable(String name, {Type type, nullAware = false}) =>
      Statement.assignVariable(name, this, type: type, nullAware: nullAware);

  /// Return `final {name} = {this}`.
  Statement assignFinal(String name, [Type type]) =>
      Statement.assignFinal(name, this, type);

  /// Return `const {name} = {this}`.
  Statement assignConst(String name, [Type type]) => Statement([
        KeyWord.$const,
        SpaceWhenNeeded(),
        if (type != null) type,
        SpaceWhenNeeded(),
        IdentifierStartingWithLowerCase(name),
        Code(' = '),
        this
      ]);

  ///===========================================================================
  ///                             codeNodes
  ///===========================================================================

  @override
  List<CodeNode> codeNodes(Context context) => nodes;
}
