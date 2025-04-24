// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

main() {
  group('SeparatedValues class', () {
    test('Given no expressions => Returns the literal code string', () {
      SeparatedValues.forParameters([]).toString().should.be('');
    });
    test('Given 1 expressions => Returns the literal code string', () {
      SeparatedValues.forParameters([
        Expression.ofInt(1),
      ]).toString().should.be('1');
    });

    test('Given 3 expressions => Returns the literal code string', () {
      SeparatedValues.forParameters([
        Expression.ofInt(1),
        Expression.ofInt(2),
        Expression.ofInt(3),
      ]).toString().should.be('1,2,3');
    });
  });

  group('Space class', () {
    test(
        'Given multiple sequential SpaceWhenNeeded, or a single SpaceWhenNeeded => Results in a single space',
        () {
      Statement([
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
          .toString()
          .should
          .be('class Test  extends OtherClass {}');
    });

    test('Given an empty line => Does not ad a space', () {
      Space().toString().should.be(' ');
    });
  });

  group('KeyWord class', () {
    test('Given Keyword.\$class => Returns code string class', () {
      KeyWord.class$.toString().should.be('class');
    });

    final nrOfKeywords = 61;
    test('Given Keyword.allCodes=> Returns .. codes', () {
      KeyWord.allCodes.length.should.be(nrOfKeywords);
    });

    test('Given Keyword.allNames=> Returns .. strings', () {
      KeyWord.allNames.length.should.be(nrOfKeywords);
    });

    test('Given Keyword.allNames=> Contains string "class"', () {
      KeyWord.allNames.contains('class').should.beTrue();
    });
  });

  group('IdentifierStartingWithUpperCase class', () {
    test('Given an empty name  => Throws "Must not be empty" exception', () {
      Should.throwError<ArgumentError>(
              () => {IdentifierStartingWithUpperCase('')})
          .message
          .toString()
          .should
          .be('Must not be empty');
    });

    test(
        'Given a name starting with a lower case letter =>  "Must start with an upper case letter" exception',
        () {
      Should.throwError<ArgumentError>(
              () => {IdentifierStartingWithUpperCase('invalidCapitalCase')})
          .message
          .toString()
          .should
          .be('Must start with an upper case letter');
    });

    test('Given a name starting with a upper case letter => Is accepted', () {
      Should.notThrowError(
          () => {IdentifierStartingWithUpperCase('ValidCapitalCase')});
    });

    test(
        'Given a special character => Throws "The first character must be a letter or an underscore or a dollar sign(\$)" exception',
        () {
      Should.throwError<ArgumentError>(
          () => {
                IdentifierStartingWithUpperCase('@')
              }).message.toString().should.be(
          'The first character must be a letter or an underscore or a dollar sign(\$)');
    });

    test(
        'Given a number => Throws "The first character must be a letter or an underscore or a dollar sign(\$)" exception',
        () {
      Should.throwError<ArgumentError>(
          () => {
                IdentifierStartingWithUpperCase('1')
              }).message.toString().should.be(
          'The first character must be a letter or an underscore or a dollar sign(\$)');
    });

    test('Given a name starting with a upper case letter => Is accepted ', () {
      Should.notThrowError(
          () => {IdentifierStartingWithUpperCase('ValidCapitalCase')});
    });

    test('Given a name starting with underscore => Is accepted ', () {
      Should.notThrowError(
          () => {IdentifierStartingWithUpperCase('_ValidCapitalCase')});
    });

    test('Given a name starting with dollar sign => Is accepted ', () {
      Should.notThrowError(
          () => {IdentifierStartingWithUpperCase('\$ValidCapitalCase')});
    });

    test(
        'Given a name with letters and numbers and underscore and dollar => Is accepted ',
        () {
      Should.notThrowError(
          () => {IdentifierStartingWithUpperCase('_\$ValidLetters')});
    });

    test(
        'Given a name with illegal character => Throws "All characters must be a letter or number or an underscore or a dollar sign(\$)" exception ',
        () {
      Should.throwError<ArgumentError>(
          () => {
                IdentifierStartingWithUpperCase('_\$Valid!Letters')
              }).message.toString().should.be(
          'All characters must be a letter or number or an underscore or a dollar sign(\$)');
    });

    test(
        'Given a name with 2 successive underscores => Throws "No two successive underscores are allowed" exception',
        () {
      Should.throwError<ArgumentError>(
              () => {IdentifierStartingWithUpperCase('__ValidLetters')})
          .message
          .toString()
          .should
          .be('No successive underscores are allowed');
    });

    test(
        'Given a name with 3 successive underscores => Throws "No successive underscores are allowed" exception',
        () {
      Should.throwError<ArgumentError>(
              () => {IdentifierStartingWithUpperCase('___ValidLetters')})
          .message
          .toString()
          .should
          .be('No successive underscores are allowed');
    });

    test('Given a name with single underscore => Is accepted ', () {
      Should.notThrowError(
          () => {IdentifierStartingWithUpperCase('_ValidLetters')});
    });
  });
  group('IdentifierStartingWithLowerCase class', () {
    test('Given an empty name  => Throws "Must not be empty" exception', () {
      Should.throwError<ArgumentError>(
              () => {IdentifierStartingWithLowerCase('')})
          .message
          .toString()
          .should
          .be('Must not be empty');
    });

    test(
        'Given a name starting with a upper case letter => Throws "Must start with an lower case letter" exception',
        () {
      Should.throwError<ArgumentError>(
              () => {IdentifierStartingWithLowerCase('InvalidCapitalCase')})
          .message
          .toString()
          .should
          .be('Must start with an lower case letter');
    });

    test('Given a name starting with a lower case letter => Is accepted', () {
      Should.notThrowError(
          () => {IdentifierStartingWithLowerCase('validCapitalCase')});
    });

    test('Given a name starting with a lower case letter => Is accepted ', () {
      Should.notThrowError(
          () => {IdentifierStartingWithLowerCase('validCapitalCase')});
    });

    test('Given a name starting with underscore => Is accepted ', () {
      Should.notThrowError(
        () => {IdentifierStartingWithLowerCase('_validCapitalCase')},
      );
    });

    test('Given a name starting with dollar sign => Is accepted ', () {
      Should.notThrowError(
        () => {IdentifierStartingWithLowerCase('\$validCapitalCase')},
      );
    });

    test(
        'Given a name that is a keyword => Throws "Keywords can not be used as identifier" exception',
        () {
      Should.throwError<ArgumentError>(
              () => {IdentifierStartingWithLowerCase('class')})
          .message
          .toString()
          .should
          .be('Keywords can not be used as identifier');
    });
    test('Given a name not being a key word => Is accepted ', () {
      Should.notThrowError(
        () => {IdentifierStartingWithLowerCase('other')},
      );
    });
  });

  group('Block class', () {
    test('Given a Block class => Returns a formatted code string', () {
      DartFunction.withName(
          'test',
          Block([
            Statement.return$(Expression.ofInt(1)),
          ])).toFormattedString().should.be('test() {\n'
          '  return 1;\n'
          '}\n');
    });
  });
}
