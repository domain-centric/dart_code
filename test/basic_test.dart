import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('CommaSeparatedValues class', () {
    test('Given no expressions => Returns the literal code string', () {
      String actual = SeparatedValues.forParameters([]).toString();
      String expected = "";
      expect(actual, expected);
    });
    test('Given 1 expressions => Returns the literal code string', () {
      String actual = SeparatedValues.forParameters([
        Expression.ofInt(1),
      ]).toString();
      String expected = "1";
      expect(actual, expected);
    });

    test('Given 3 expressions => Returns the literal code string', () {
      String actual = SeparatedValues.forParameters([
        Expression.ofInt(1),
        Expression.ofInt(2),
        Expression.ofInt(3),
      ]).toString();
      String expected = '\n'
          '  1,\n'
          '  2,\n'
          '  3';
      expect(actual, expected);
    });
  });

  group('IncreaseIndent class', () {
    test(
        'Given IncreaseIndent => Returns a formatted code with increased indent',
        () {
      String actual = Block([
        Statement([Code("test()")]),
        IncreaseIndent(),
        Statement([Code("test()")]),
      ]).toString();
      String expected = '{\n'
          '  test();\n'
          '    test();\n'
          '  }';
      expect(actual, expected);
    });
  });

  group('DecreaseIndent class', () {
    test(
        'Given DecreaseIndent => Returns a formatted code with decreased indent',
        () {
      String actual = Block([
        Statement([Code("test()")]),
        DecreaseIndent(),
        Statement([Code("test()")]),
      ]).toString();
      String expected = '{\n'
          '  test();\n'
          'test();\n'
          '}';
      expect(actual, expected);
    });
  });

  group('NewLine class', () {
    test('Given NewLine will go to add a new line character', () {
      String actual = Block([
        Code("test1();"),
        NewLine(),
        Code("test2();"),
      ]).toString();
      String expected = '{\n'
          '  test1();\n'
          '  test2();\n'
          '}';
      expect(actual, expected);
    });

    test('Given een alternative NewLine will go to add a new line character',
        () {
      Block block = Block([
        Code("test1();"),
        NewLine(),
        Code("test2();"),
      ]);
      String actual = CodeFormatter(newLine: '\r\n').format(block);
      String expected = '{\r\n'
          '  test1();\r\n'
          '  test2();\r\n'
          '}';
      expect(actual, expected);
    });
  });

  group('SpaceWhenNeeded class', () {
    test(
        'Given multiple sequential SpaceWhenNeeded, or a single SpaceWhenNeeded => Results in a single space',
        () {
      String actual = Statement([
        KeyWord.class$,
        SpaceWhenNeeded(),
        SpaceWhenNeeded(),
        SpaceWhenNeeded(),
        KeyWord.extends$,
        SpaceWhenNeeded(),
        Code('OtherClass'),
        SpaceWhenNeeded(),
        Code('{}'),
      ]).toString();
      String expected = 'class extends OtherClass {};\n';
      expect(actual, expected);
    });

    test('Given an empty line => Does not ad a space', () {
      String actual = SpaceWhenNeeded().toString();
      String expected = '';
      expect(actual, expected);
    });

    test('Given space after new line => No space after new line', () {
      String actual = Statement([NewLine(), SpaceWhenNeeded()]).toString();
      String expected = '\n'
          ';\n';
      expect(actual, expected);
    });
  });

  group('KeyWord class', () {
    test('Given Keyword.\$class => Returns code string class', () {
      String actual = CodeFormatter().format(KeyWord.class$);
      String expected = 'class';
      expect(actual, expected);
    });

    test('Given Keyword.allCodes=> Returns .. codes', () {
      int actual = KeyWord.allCodes.length;
      int expected = 63;
      expect(actual, expected);
    });

    test('Given Keyword.allNames=> Returns .. strings', () {
      int actual = KeyWord.allNames.length;
      int expected = 63;
      expect(actual, expected);
    });

    test('Given Keyword.allNames=> Contains string "class"', () {
      bool actual = KeyWord.allNames.contains('class');
      bool expected = true;
      expect(actual, expected);
    });
  });

  group('IdentifierStartingWithUpperCase class', () {
    test('Given a null name => Throws "Must not be null" exception', () {
      expect(
          () => {IdentifierStartingWithUpperCase(null)},
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'Must not be null')));
    });

    test('Given an empty name  => Throws "Must not be empty" exception', () {
      expect(
          () => {IdentifierStartingWithUpperCase('')},
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'Must not be empty')));
    });

    test(
        'Given a name starting with a lower case letter =>  "Must start with an upper case letter" exception',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('invalidCapitalCase')},
          throwsA(predicate((e) =>
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
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'The first character must be a letter or an underscore')));
    });

    test(
        'Given a number => Throws "The first character must be a letter or an underscore" exception',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('1')},
          throwsA(predicate((e) =>
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
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'No special characters or punctuation symbol is allowed except the underscore or a dollar sign(\$)')));
    });

    test(
        'Given a name with 2 successive underscores => Throws "No two successive underscores are allowed" exception',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('__ValidLetters')},
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'No successive underscores are allowed')));
    });

    test(
        'Given a name with 3 successive underscores => Throws "No successive underscores are allowed" exception',
        () {
      expect(
          () => {IdentifierStartingWithUpperCase('___ValidLetters')},
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'No successive underscores are allowed')));
    });

    test('Given a name with single underscore => Is accepted ', () {
      expect(() => {IdentifierStartingWithUpperCase('_ValidLetters')},
          returnsNormally);
    });
  });
  group('IdentifierStartingWithLowerCase class', () {
    test('Given a null name => Throws "Must not be null" exception', () {
      expect(
          () => {IdentifierStartingWithLowerCase(null)},
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'Must not be null')));
    });

    test('Given an empty name  => Throws "Must not be empty" exception', () {
      expect(
          () => {IdentifierStartingWithLowerCase('')},
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'Must not be empty')));
    });

    test(
        'Given a name starting with a upper case letter => Throws "Must start with an lower case letter" exception',
        () {
      expect(
          () => {IdentifierStartingWithLowerCase('InvalidCapitalCase')},
          throwsA(predicate((e) =>
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
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'Keywords can not be used as identifier')));
    });
    test('Given a name not being a key word => Is accepted ', () {
      expect(() => {IdentifierStartingWithLowerCase('other')}, returnsNormally);
    });
  });

  group('Block class', () {
    test('Given a Block class => Returns a formatted code string', () {
      String actual = Block([
        Statement([Code('test()')]),
      ]).toString();
      String expected = '{\n'
          '  test();\n'
          '}';
      expect(actual, expected);
    });
  });
}
