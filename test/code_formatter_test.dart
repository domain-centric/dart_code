import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('CodeFormatter class', () {
    test('format()', () {
      Statement statement = Statement([
        Code("print("),
        Code("'" + ('1234567890' * 8) + "'"),
        Code(")"),
      ]);
      String actual =
          CodeFormatter(indent: '\t', wrapIndent: '\t\t').format(statement);
      String expected = 'print(\n'
          '\t\t\'12345678901234567890123456789012345678901234567890123456789012345678901234567890\'\n'
          '\t\t);\n';
      expect(actual, expected);
    });
  });
}
