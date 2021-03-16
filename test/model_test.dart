import 'package:dart_code/model.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Code class', () {
    test('Given a Code => Returns the literal code string', () {
      String actual = Code("test();").toString();
      String expected = 'test();';
      expect(actual, expected);
    });
  });
}
