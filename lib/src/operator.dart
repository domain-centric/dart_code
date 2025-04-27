import 'package:dart_code/dart_code.dart';

enum Operator implements CodeNode, MethodName {
  equals('=='),
  notEquals('!='),
  greaterThan('>'),
  lessThan('<'),
  greaterThanOrEqualTo('>='),
  lessThanOrEqualTo('<='),
  asType('as'),
  isType('is'),
  isNotType('is!'),
  add('+'),
  subtract('-'),
  multiply('*'),
  divide('/'),
  modulo('%'),
  increment('++'),
  decrement('--'),
  bitwiseAnd('&'),
  bitwiseOr('|'),
  bitwiseXor('^'),
  shiftLeft('<<'),
  shiftRight('>>'),
  logicalAnd('&&'),
  logicalOr('||'),
  negate('!'),
  assign('='),
  addAssign('+='),
  subtractAssign('-='),
  multiplyAssign('*='),
  divideAssign('/='),
  moduloAssign('%='),
  nullCoalesce('??'),
  nullCoalesceAssign('??=');

  final String symbol;

  const Operator(this.symbol);

  static Operator? fromSymbol(String symbol) {
    for (var operator in Operator.values) {
      if (operator.symbol == symbol) {
        return operator;
      }
    }
    return null;
  }

  static bool isValidSymbol(String symbol) {
    return Operator.values.any((operator) => operator.symbol == symbol);
  }

  @override
  String toFormattedString(
          {String? lineEnding,
          int? pageWidth,
          int? indent,
          List<String>? experimentFlags}) =>
      symbol;

  @override
  String toUnFormattedString(Imports imports) => symbol;
}
