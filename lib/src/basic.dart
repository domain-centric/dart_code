import 'expression.dart';
import 'formatting.dart';
import 'model.dart';
import 'statement.dart';

class SeparatedValues extends CodeModel {
  final Iterable<CodeNode> values;
  final bool startWithNewLine;
  final bool withIndent;
  final bool withCommas;
  final bool withNewLines;

  SeparatedValues.forStatements(this.values)
      : startWithNewLine = false,
        withIndent = false,
        withCommas = false,
        withNewLines = true;

  SeparatedValues.forParameters(this.values)
      : startWithNewLine = true,
        withIndent = true,
        withCommas = true,
        withNewLines = true;

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> nodes = [];
    if (values != null && values.isNotEmpty) {
      if (values.length > 1) {
        if (startWithNewLine) {
          nodes.add(NewLine());
        }
        if (withIndent) {
          nodes.add(IncreaseIndent());
        }
      }
      CodeNode previousValue;
      for (CodeNode value in values) {
        if (previousValue != null && !(previousValue is FormattingCodeLeaf)) {
          if (withCommas) {
            nodes.add(Code(','));
          }
          if (withNewLines) {
            nodes.add(NewLine());
          }
        }
        nodes.add(value);
        previousValue = value;
      }
      if (values.length > 1 && withIndent) nodes.add(DecreaseIndent());
    }
    return nodes;
  }
}

///Adds code only when it is not repeating itself (ignoring spaces)
class NoneRepeatingCode extends CodeLeaf {
  final String code;

  NoneRepeatingCode(this.code);

  @override
  String convertToString(Context context) {
    if (code == context.lastCode) {
      return ''; //add nothing
    } else {
      return code;
    }
  }
}

final RegExp endsWithWhiteSpace = RegExp(r'\s$');

/// adds a space if last code line is not empty and does not end with a white space
class SpaceWhenNeeded extends CodeLeaf {
  @override
  String convertToString(Context context) {
    if (context.lastCode.trim().isEmpty ||
        endsWithWhiteSpace.hasMatch(context.lastCode)) {
      return '';
    } else {
      return ' ';
    }
  }
}

/// A collection of reserved Dart (key)words
/// Using a dollar prefix to prevent compiler issues (field names being keywords)
class KeyWord {
  static final Code abstract$ = Code('abstract');
  static final Code as$ = Code('as');
  static final Code assert$ = Code('assert');
  static final Code async$ = Code('async');
  static final Code asyncStar$ = Code('async*');
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
  static final Code syncStar$ = Code('sync*');
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
    asyncStar$,
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
    syncStar$,
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

final RegExp _firstCharMustBeLetterOrUnderscore =
    RegExp(r"^[a-z_]", caseSensitive: false);

final RegExp _lettersNumbersUnderscoreOrDollar =
    RegExp(r"^[a-z0-9_$]+$", caseSensitive: false);

final RegExp _successiveUnderscores = RegExp(r"__");

abstract class _Identifier extends CodeLeaf {
  final String name;

  _Identifier(this.name, CaseChecker firstLetterCaseChecker) {
    _validateName(name, firstLetterCaseChecker);
  }

  void _validateName(String name, CaseChecker firstLetterCaseChecker) {
    if (name == null) throw ArgumentError.notNull(name);
    if (name.isEmpty)
      throw ArgumentError.value(name, 'name', 'Must not be empty');
    if (!firstLetterCaseChecker.isCorrectCase(name[0]))
      throw ArgumentError.value(name, 'name',
          'Must start with an ${firstLetterCaseChecker.isUpperCase ? 'upper case' : 'lower case'} letter');
    if (!_firstCharMustBeLetterOrUnderscore.hasMatch(name))
      throw ArgumentError.value(name, 'name',
          'The first character must be a letter or an underscore');
    if (!_lettersNumbersUnderscoreOrDollar.hasMatch(name))
      throw ArgumentError.value(name, 'name',
          'No special characters or punctuation symbol is allowed except the underscore or a dollar sign(\$)');
    if (_successiveUnderscores.hasMatch(name))
      throw ArgumentError.value(
          name, 'name', 'No successive underscores are allowed');
    if (KeyWord.allNames.contains(name))
      throw ArgumentError.value(
          name, 'name', 'Keywords can not be used as identifier');
  }

  @override
  String convertToString(Context context) {
    return name;
  }
}

class IdentifierStartingWithUpperCase extends _Identifier {
  IdentifierStartingWithUpperCase(String name)
      : super(name, CaseChecker.forUpperCase());
}

class IdentifierStartingWithLowerCase extends _Identifier {
  IdentifierStartingWithLowerCase(String name)
      : super(name, CaseChecker.forLowerCase());
}

class CaseChecker {
  final bool isUpperCase;

  CaseChecker.forUpperCase() : isUpperCase = true;

  CaseChecker.forLowerCase() : isUpperCase = false;

  bool isCorrectCase(String text) {
    if (text == null) return false;
    if (isUpperCase) {
      return text.toUpperCase() == text;
    } else {
      return text.toLowerCase() == text;
    }
  }
}

class Block extends CodeModel {
  final List<CodeNode> codeInsideBlock;

  Block(this.codeInsideBlock);

  @override
  List<CodeNode> codeNodes(Context context) => [
        Code('{'),
        NewLine(),
        IncreaseIndent(),
        ...codeInsideBlock,
        DecreaseIndent(),
        NoneRepeatingCode(context.newLine),
        Code('}'),
      ];
}

/// e.g. a body of a function, method
class Body extends CodeModel {
  final List<CodeNode> nodes;

  Body(this.nodes);

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> codeNodes = [];
    if (nodes.length == 1 && nodes.first is Expression) {
      codeNodes.add(SpaceWhenNeeded());
      codeNodes.add(Code("=>"));
      codeNodes.add(SpaceWhenNeeded());
      codeNodes.add(nodes.first);
      codeNodes.add(EndOfStatement());
    } else if (nodes.length == 1 && nodes.first is Block) {
      codeNodes.add(nodes.first);
      codeNodes.add(NewLine());
    } else {
      codeNodes.add(Block(nodes));
      codeNodes.add(NewLine());
    }
    return codeNodes;
  }
}

enum Asynchrony {
  async,
  asyncStar,
  sync,
  syncStar,
}
