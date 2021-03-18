import 'package:dart_code/dart_code.dart';

/// OUTPUTS:
/// main() {
///     print(\'Hello World.\');
/// }

main() {
  print(CodeFormatter(indent: '    ').format(
      Function.main(Statement.print(Expression.ofString('Hello World.')))));
}
