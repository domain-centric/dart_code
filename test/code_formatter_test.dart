import 'package:dart_code/basic.dart';
import 'package:dart_code/code_formatter.dart';
import 'package:dart_code/model.dart';
import 'package:test/test.dart' as code_formatter_test;

main() {
  code_formatter_test.group('CodeFormatter class', () {
    code_formatter_test.test('format()', () {
      Statement statement = Statement([
        Code("print("),
        Code("'" + ('1234567890' * 8) + "'"),
        Code(")"),
      ]);
      String actual = CodeFormatter(indent: '\t', wrapIndent: '\t\t').format(statement);
      String expected = 'print(\n'
          '\t\t\'12345678901234567890123456789012345678901234567890123456789012345678901234567890\'\n'
          '\t\t);\n';
      code_formatter_test.expect(actual, expected);
    });
  });
}
