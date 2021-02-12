import 'package:dart_code/model.dart';
import 'package:dart_code/statement.dart';

import 'expression.dart';
import 'formatting.dart';

class CommaSeparatedValues extends CodeModel {
  final Iterable<CodeNode> values;

  CommaSeparatedValues(this.values);

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> nodes = [];
    if (values != null) {
      CodeNode previousValue;
      for (CodeNode value in values) {
        if (previousValue != null && !(previousValue is FormattingCodeLeaf)) {
          nodes.add(Code(', '));
        }
        nodes.add(value);
        previousValue = value;
      }
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
    if (context.lastCode.isEmpty ||
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

class Type extends CodeModel {
  final String name;
  final String libraryUrl;
  final List<Type> generics;

  Type.ofBool()
      : name = 'bool',
        libraryUrl = null,
        generics = [];

  Type.ofInt()
      : name = 'int',
        libraryUrl = null,
        generics = [];

  Type.ofDouble()
      : name = 'double',
        libraryUrl = null,
        generics = [];

  Type.ofDateTime()
      : name = 'DateTime',
        libraryUrl = null,
        generics = [];

  Type.ofString()
      : name = 'String',
        libraryUrl = null,
        generics = [];

  Type.ofVar()
      : name = 'var',
        libraryUrl = null,
        generics = [];

  Type.ofList() : this.ofGenericList(null);

  Type.ofGenericList(Type genericType) :
        name='List',
        libraryUrl=null,
        generics=[if (genericType!=null) genericType];

  Type.ofSet() : this.ofGenericSet(null);

  Type.ofGenericSet(Type genericType) :
        name='Set',
        libraryUrl=null,
        generics=[if (genericType!=null) genericType];

  Type.ofMap() :
        name='Map',
        libraryUrl=null,
        generics=[];

  Type.ofGenericMap(Type keyType, Type valueType) :
        name='Map',
        libraryUrl=null,
        generics=[keyType, valueType];


  Type(this.name, {this.libraryUrl, this.generics = const []});

  @override
  List<CodeNode> codeNodes(Context context) =>
      Reference(this).codeNodes(context);
}

class Import extends CodeModel {
  final String libraryUrl;
  final String alias;

  Import(this.libraryUrl, this.alias);

  ///e.g.import 'package:reflect_framework/reflect_info_service.dart' as _i1;
  @override
  List<CodeNode> codeNodes(Context context) => [
        KeyWord.import$,
        SpaceWhenNeeded(),
        Code("'$libraryUrl'"),
        SpaceWhenNeeded(),
        KeyWord.as$,
        SpaceWhenNeeded(),
        Code(alias),
        EndOfStatement(),
      ];
}

class Imports extends CodeModel {
  final Map<String, String> imports = {};

  Imports(CodeNode codeNode, Context context) {
    _registerTypesInCodeNode(codeNode, context);
  }

  void _registerTypesInCodeNode(CodeNode codeNode, Context context) {
    if (codeNode is Type) {
      _registerType(codeNode);
    } else if (codeNode is CodeModel) {
      //recursive call
      _registerTypesInCodeModel(codeNode, context);
    }
  }

  void _registerTypesInCodeModel(CodeModel codeModel, Context context) {
    for (CodeNode codeNode in codeModel.codeNodes(context)) {
      _registerTypesInCodeNode(codeNode, context);
    }
  }

  void _registerType(Type type) {
    if (type.libraryUrl != null) {
      var libraryUrl = type.libraryUrl.toLowerCase();
      if (!imports.containsKey(libraryUrl)) {
        imports[libraryUrl] = '_i${imports.length + 1}';
      }
      for (Type genericType in type.generics) {
        //recursive call
        _registerType(genericType);
      }
    }
  }

  @override
  List<CodeNode> codeNodes(Context context) => imports.keys
      .map((libraryUrl) => Import(libraryUrl, imports[libraryUrl]))
      .toList();

  bool containsKey(String libraryUrl) => imports.containsKey(libraryUrl);

  String aliasOf(String libraryUrl) => imports[libraryUrl];
}

class Reference extends CodeModel {
  final Type type;

  Reference(this.type);

  @override
  List<CodeNode> codeNodes(Context context) {
    Imports imports = context.imports;
    List<CodeNode> typeNodes = [];
    if (type.libraryUrl != null) {
      String libraryUrl = type.libraryUrl.toLowerCase();
      if (!imports.containsKey(libraryUrl)) {
        throw Exception(
            'Types need to be registered to Imports, before getting a reference');
      }
      String alias = imports.aliasOf(libraryUrl);
      typeNodes.add(Code(alias));
      typeNodes.add(Code('.'));
    }
    var name = type.name;
    typeNodes.add(Code(name));
    if (type.generics.isNotEmpty) {
      typeNodes.add(Code('<'));
      typeNodes.add(_genericNodes(type));
      typeNodes.add(Code('>'));
    }
    return typeNodes;
  }

  CommaSeparatedValues _genericNodes(Type type) {
    List<CodeNode> genericNodes = [];
    for (Type genericType in type.generics) {
      if (type != genericType) {
        genericNodes.add(Reference(genericType));
      }
    }
    return CommaSeparatedValues(genericNodes);
  }
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
        for (CodeNode codeNode in codeInsideBlock) codeNode,
        DecreaseIndent(),
        NoneRepeatingCode(context.newLine),
        Code('}')
      ];
}

/// e.g. a body of a function, method, constructor
class Body extends CodeModel {
  CodeNode body;

  Body(this.body);

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> codeNodes = [];
    if (body is Expression) {
      codeNodes.add(Code("=> "));
      codeNodes.add(body);
      codeNodes.add(EndOfStatement());
    } else {
      codeNodes.add(Block([body]));
    }
    return codeNodes;
  }
}
