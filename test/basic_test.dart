import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('SeparatedValues class', () {
    test('Given no expressions => Returns the literal code string', () {
      String actual =
          CodeFormatter().unFormatted(SeparatedValues.forParameters([]));
      String expected = "";
      expect(actual, expected);
    });
    test('Given 1 expressions => Returns the literal code string', () {
      String actual =
          CodeFormatter().unFormatted(SeparatedValues.forParameters([
        Expression.ofInt(1),
      ]));
      String expected = "1";
      expect(actual, expected);
    });

    test('Given 3 expressions => Returns the literal code string', () {
      String actual =
          CodeFormatter().unFormatted(SeparatedValues.forParameters([
        Expression.ofInt(1),
        Expression.ofInt(2),
        Expression.ofInt(3),
      ]));
      String expected = '1,2,3';
      expect(actual, expected);
    });
  });

  group('Space class', () {
    test(
        'Given multiple sequential SpaceWhenNeeded, or a single SpaceWhenNeeded => Results in a single space',
        () {
      String actual = Statement([
        KeyWord.class$,
        Space(),
        Code('Test'),
        Space(),
        Space(),
        KeyWord.extends$,
        Space(),
        Code('OtherClass'),
        Space(),
        Code('{}'),
      ], hasEndOfStatement: false)
          .toString();
      String expected = 'class Test extends OtherClass {}\n';
      expect(actual, expected);
    });

    test('Given an empty line => Does not ad a space', () {
      String actual = Space().toString();
      String expected = '\n';
      expect(actual, expected);
    });
  });

  group('KeyWord class', () {
    test('Given Keyword.\$class => Returns code string class', () {
      String actual = CodeFormatter().unFormatted(KeyWord.class$);
      String expected = 'class';
      expect(actual, expected);
    });

    final nrOfKeywords = 62;
    test('Given Keyword.allCodes=> Returns .. codes', () {
      int actual = KeyWord.allCodes.length;
      int expected = nrOfKeywords;
      expect(actual, expected);
    });

    test('Given Keyword.allNames=> Returns .. strings', () {
      int actual = KeyWord.allNames.length;
      int expected = nrOfKeywords;
      expect(actual, expected);
    });

    test('Given Keyword.allNames=> Contains string "class"', () {
      bool actual = KeyWord.allNames.contains('class');
      bool expected = true;
      expect(actual, expected);
    });
  });

  group('IdentifierStartingWithUpperCase class', () {
    test('Given an empty name  => Throws "Must not be empty" exception', () {
      expect(
          () => {IdentifierStartingWithUpperCase('')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError && e.message == 'Must not be empty')));
    });

    test(
        'Given a name starting with a lower case letter =>  "Must start with an upper case letter" exception',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('invalidCapitalCase')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message == 'Must start with an upper case letter')));
    });

    test('Given a name starting with a upper case letter => Is accepted', () {
      expect(() => {IdentifierStartingWithUpperCase('ValidCapitalCase')},
          returnsNormally);
    });

    test(
        'Given a special character => Throws "The first character must be a letter or an underscore" exception',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('@')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message ==
                  'The first character must be a letter or an underscore')));
    });

    test(
        'Given a number => Throws "The first character must be a letter or an underscore" exception',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('1')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message ==
                  'The first character must be a letter or an underscore')));
    });

    test('Given a name starting with a upper case letter => Is accepted ', () {
      expect(() => {IdentifierStartingWithUpperCase('ValidCapitalCase')},
          returnsNormally);
    });

    test('Given a name starting with underscore => Is accepted ', () {
      expect(() => {IdentifierStartingWithUpperCase('_ValidCapitalCase')},
          returnsNormally);
    });

    test(
        'Given a name with letters and numbers and underscore and dollar => Is accepted ',
        () {
      expect(() => {IdentifierStartingWithUpperCase('_\$ValidLetters')},
          returnsNormally);
    });

    test(
        'Given a name with illegal character => Throws "No special characters or punctuation symbol is allowed except the underscore or a dollar sign(\$)" exception ',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('_\$Valid!Letters')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message ==
                  'No special characters or punctuation symbol is allowed except the underscore or a dollar sign(\$)')));
    });

    test(
        'Given a name with 2 successive underscores => Throws "No two successive underscores are allowed" exception',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('__ValidLetters')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message == 'No successive underscores are allowed')));
    });

    test(
        'Given a name with 3 successive underscores => Throws "No successive underscores are allowed" exception',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('___ValidLetters')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message == 'No successive underscores are allowed')));
    });

    test('Given a name with single underscore => Is accepted ', () {
      expect(() => {IdentifierStartingWithUpperCase('_ValidLetters')},
          returnsNormally);
    });
  });
  group('IdentifierStartingWithLowerCase class', () {
    test('Given an empty name  => Throws "Must not be empty" exception', () {
      expect(
          () => {IdentifierStartingWithLowerCase('')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError && e.message == 'Must not be empty')));
    });

    test(
        'Given a name starting with a upper case letter => Throws "Must start with an lower case letter" exception',
        () {
      expect(
          () => {IdentifierStartingWithLowerCase('InvalidCapitalCase')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message == 'Must start with an lower case letter')));
    });

    test('Given a name starting with a lower case letter => Is accepted', () {
      expect(() => {IdentifierStartingWithLowerCase('validCapitalCase')},
          returnsNormally);
    });

    test('Given a name starting with a lower case letter => Is accepted ', () {
      expect(() => {IdentifierStartingWithLowerCase('validCapitalCase')},
          returnsNormally);
    });

    test('Given a name starting with underscore => Is accepted ', () {
      expect(() => {IdentifierStartingWithLowerCase('_validCapitalCase')},
          returnsNormally);
    });

    test(
        'Given a name that is a keyword => Throws "Keywords can not be used as identifier" exception',
        () {
      expect(
          () => {IdentifierStartingWithLowerCase('class')},
          throwsA(predicate((dynamic e) =>
              e is ArgumentError &&
              e.message == 'Keywords can not be used as identifier')));
    });
    test('Given a name not being a key word => Is accepted ', () {
      expect(() => {IdentifierStartingWithLowerCase('other')}, returnsNormally);
    });
  });

  group('Block class', () {
    test('Given a Block class => Returns a formatted code string', () {
      String actual = DartFunction.withName(
          'test',
          Block([
            Statement.return$(Expression.ofInt(1)),
          ])).toString();
      String expected = 'test() {\n'
          '  return 1;\n'
          '}\n';
      expect(actual, expected);
    });
  });
}
