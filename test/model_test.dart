import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Code class', () {
    test('Given a Code => Returns the literal code string', () {
      String actual = Code("test();").toString();
      String expected = 'test();';
      expect(actual, expected);
    });
  });
}
