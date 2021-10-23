import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('CodeFormatter class', () {
    test('format()', () {
      String actual = CodeFormatter(pageWidth: 20, indent: 4).format(
          DartFunction.main(Statement.print(Expression.ofString('Hello World.'))));
      String expected = '    main() {\n'
          '      print(\n'
          '          \'Hello World.\');\n'
          '    }\n';
      expect(actual, expected);
    });
  });
}
