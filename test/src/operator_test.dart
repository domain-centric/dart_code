import 'package:dart_code/src/import.dart';
import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:dart_code/src/operator.dart';

void main() {
  group('Operator', () {
    test('fromSymbol should return correct Operator for valid symbols', () {
      Should.satisfyAllConditions([
        () => Operator.fromSymbol('==').should.be(Operator.equals),
        () => Operator.fromSymbol('!=').should.be(Operator.notEquals),
        () => Operator.fromSymbol('+').should.be(Operator.add),
      ]);
    });

    test('fromSymbol should return null for invalid symbols', () {
      Should.satisfyAllConditions([
        () => Operator.fromSymbol('invalid').should.beNull(),
        () => Operator.fromSymbol('').should.beNull(),
      ]);
    });

    test('isValidSymbol should return true for valid symbols', () {
      Should.satisfyAllConditions([
        () => Operator.isValidSymbol('==').should.beTrue(),
        () => Operator.isValidSymbol('!=').should.beTrue(),
        () => Operator.isValidSymbol('+').should.beTrue(),
      ]);
    });

    test('isValidSymbol should return false for invalid symbols', () {
      Should.satisfyAllConditions([
        () => Operator.isValidSymbol('invalid').should.beFalse(),
        () => Operator.isValidSymbol('').should.beFalse(),
      ]);
    });

    test('toFormattedString should return correct Code object', () {
      Should.satisfyAllConditions([
        () => Operator.equals.toFormattedString().should.be('=='),
        () => Operator.add.toFormattedString().should.be('+'),
      ]);
    });
    test('toUnFormattedString() should return correct Code object', () {
      Should.satisfyAllConditions([
        () => Operator.equals.toUnFormattedString(Imports()).should.be('=='),
        () => Operator.add.toUnFormattedString(Imports()).should.be('+'),
      ]);
    });
  });
}
