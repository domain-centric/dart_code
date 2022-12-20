/*
 * Copyright (c) 2022. By Nils ten Hoeve. See LICENSE file in project.
 */

import 'package:dart_code/dart_code.dart';

class SeparatedValues extends CodeModel {
  final Iterable<CodeNode> values;
  final bool withCommas;

  SeparatedValues.forStatements(this.values) : withCommas = false;

  SeparatedValues.forParameters(this.values) : withCommas = true;

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> nodes = [];
    if (values.isNotEmpty) {
      bool first = true;
      for (CodeNode value in values) {
        if (withCommas && !first) {
          nodes.add(Code(','));
        } else {
          first = false;
        }
        nodes.add(value);
      }
    }
    return nodes;
  }
}

///Adds code only when it is not repeating itself (ignoring spaces)
class NoneRepeatingCode extends CodeNode {
  final String code;

  NoneRepeatingCode(this.code);

  @override
  String toUnFormattedString(Context context) {
    if (code == context.lastCode) {
      return ''; //add nothing
    } else {
      return code;
    }
  }
}

final RegExp endsWithWhiteSpace = RegExp(r'\s$');

/// adds a space.
/// Note that [CodeFormatter] may add additional spaces or remove unneeded spaces
class Space extends Code {
  Space() : super(' ');
}

/// adds a carriage return (CR) character.
/// This character is used as a new line character in most other non-Unix operating systems
/// Note that [CodeFormatter] may
/// - add additional cr characters
/// - or remove unneeded cr characters
/// - or replace it with different end of line characters.
class NewLine extends Code {
  NewLine() : super('\n');
}

/// A collection of reserved Dart (key)words
/// Using a dollar prefix to prevent compiler issues (field names being keywords)
/// See [https://dart.dev/guides/language/language-tour#keywords]
class KeyWord {
  static final Code abstract$ = Code('abstract');
  static final Code as$ = Code('as');
  static final Code assert$ = Code('assert');
  static final Code async$ = Code('async');
  static final Code await$ = Code('await');
  static final Code break$ = Code('break');
  static final Code case$ = Code('case');
  static final Code catch$ = Code('catch');
  static final Code class$ = Code('class');
  static final Code const$ = Code('const');
  static final Code continue$ = Code('continue');
  static final Code covariant$ = Code('covariant');
  static final Code default$ = Code('default');
  static final Code deferred$ = Code('deferred');
  static final Code do$ = Code('do');
  static final Code dynamic$ = Code('dynamic');
  static final Code else$ = Code('else');
  static final Code enum$ = Code('enum');
  static final Code export$ = Code('export');
  static final Code extends$ = Code('extends');
  static final Code extension$ = Code('extension');
  static final Code external$ = Code('external');
  static final Code factory$ = Code('factory');
  static final Code false$ = Code('false');
  static final Code final$ = Code('final');
  static final Code finally$ = Code('finally');
  static final Code for$ = Code('for');
  static final Code function$ = Code('Function');
  static final Code get$ = Code('get');
  static final Code hide$ = Code('hide');
  static final Code if$ = Code('if');
  static final Code implements$ = Code('implements');
  static final Code import$ = Code('import');
  static final Code in$ = Code('in');
  static final Code interface$ = Code('interface');
  static final Code is$ = Code('is');
  static final Code late$ = Code('late');
  static final Code library$ = Code('library');
  static final Code mixin$ = Code('mixin');
  static final Code new$ = Code('new');
  static final Code null$ = Code('null');
  static final Code on$ = Code('on');
  static final Code operator$ = Code('operator');
  static final Code part$ = Code('part');
  static final Code rethrow$ = Code('rethrow');
  static final Code return$ = Code('return');
  static final Code set$ = Code('set');
  static final Code show$ = Code('show');
  static final Code static$ = Code('static');
  static final Code super$ = Code('super');
  static final Code switch$ = Code('switch');
  static final Code sync$ = Code('sync');
  static final Code this$ = Code('this');
  static final Code throw$ = Code('throw');
  static final Code true$ = Code('true');
  static final Code try$ = Code('try');
  static final Code typedef$ = Code('typedef');
  static final Code var$ = Code('var');
  static final Code void$ = Code('void');
  static final Code while$ = Code('while');
  static final Code with$ = Code('with');
  static final Code yield$ = Code('yield');
  static final List<Code> allCodes = [
    abstract$,
    as$,
    assert$,
    async$,
    await$,
    break$,
    case$,
    catch$,
    class$,
    const$,
    continue$,
    covariant$,
    default$,
    deferred$,
    do$,
    dynamic$,
    else$,
    enum$,
    export$,
    extends$,
    extension$,
    external$,
    factory$,
    false$,
    final$,
    finally$,
    for$,
    function$,
    get$,
    hide$,
    if$,
    implements$,
    import$,
    in$,
    interface$,
    is$,
    late$,
    library$,
    mixin$,
    new$,
    null$,
    on$,
    operator$,
    part$,
    rethrow$,
    return$,
    set$,
    show$,
    static$,
    super$,
    switch$,
    sync$,
    this$,
    throw$,
    true$,
    try$,
    typedef$,
    var$,
    void$,
    while$,
    with$,
    yield$,
  ];
  static final List<String> allNames = allCodes.map((c) => c.code).toList();
}

final RegExp _firstCharMustBeLetterOrUnderscoreOrDollar =
    RegExp(r"^[a-z_$]", caseSensitive: false);

final RegExp _lettersNumbersUnderscoreOrDollar =
    RegExp(r"^[a-z0-9_$]+$", caseSensitive: false);

final RegExp _successiveUnderscores = RegExp(r"__");

/// Identifiers are names of [Class]es, [Field]s, [Method]s, [DartFunction]s etc.
/// See [https://dart.dev/guides/language/language-tour#important-concepts]
abstract class Identifier extends CodeNode {
  final String _name;

  Identifier(this._name, CaseChecker firstLetterCaseChecker) {
    _validateName(_name, firstLetterCaseChecker);
  }

  void _validateName(String name, CaseChecker firstLetterCaseChecker) {
    if (name.isEmpty)
      throw ArgumentError.value(name, 'name', 'Must not be empty');
    if (!firstLetterCaseChecker.isCorrectCase(name[0]))
      throw ArgumentError.value(name, 'name',
          'Must start with an ${firstLetterCaseChecker.isUpperCase ? 'upper case' : 'lower case'} letter');
    if (!_firstCharMustBeLetterOrUnderscoreOrDollar.hasMatch(name))
      throw ArgumentError.value(name, 'name',
          'The first character must be a letter or an underscore or a dollar sign(\$)');
    if (!_lettersNumbersUnderscoreOrDollar.hasMatch(name))
      throw ArgumentError.value(name, 'name',
          'All characters must be a letter or number or an underscore or a dollar sign(\$)');
    if (_successiveUnderscores.hasMatch(name))
      throw ArgumentError.value(
          name, 'name', 'No successive underscores are allowed');
    if (KeyWord.allNames.contains(name))
      throw ArgumentError.value(
          name, 'name', 'Keywords can not be used as identifier');
  }

  @override
  String toUnFormattedString(Context context) {
    return _name;
  }
}

class IdentifierStartingWithUpperCase extends Identifier {
  IdentifierStartingWithUpperCase(String name)
      : super(name, CaseChecker.forUpperCase());
}

class IdentifierStartingWithLowerCase extends Identifier {
  IdentifierStartingWithLowerCase(String name)
      : super(name, CaseChecker.forLowerCase());
}

class CaseChecker {
  final bool isUpperCase;

  CaseChecker.forUpperCase() : isUpperCase = true;

  CaseChecker.forLowerCase() : isUpperCase = false;

  bool isCorrectCase(String text) {
    if (isUpperCase) {
      return text.toUpperCase() == text;
    } else {
      return text.toLowerCase() == text;
    }
  }
}

/// Represents a block statement
/// See [https://dart.dev/guides/language/language-tour#functions]
class Block extends CodeModel {
  final List<CodeNode> codeInsideBlock;

  Block(this.codeInsideBlock);

  @override
  List<CodeNode> codeNodes(Context context) => [
        Code('{'),
        ...codeInsideBlock,
        Code('}'),
      ];
}

/// Represent a body of e.g. a [DartFunction] or [Method]
/// A body can be a block (e.g. with a return statement) or a functional block (using =>)
class Body extends CodeModel {
  final List<CodeNode> nodes;

  Body(this.nodes);

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> codeNodes = [];
    if (nodes.length == 1 && nodes.first is Expression) {
      codeNodes.add(Space());
      codeNodes.add(Code("=>"));
      codeNodes.add(Space());
      codeNodes.add(nodes.first);
      codeNodes.add(EndOfStatement());
    } else if (nodes.length == 1 && nodes.first is Block) {
      codeNodes.add(nodes.first);
    } else {
      codeNodes.add(Block(nodes));
    }
    return codeNodes;
  }
}

enum Asynchrony {
  async,
  sync,
}
