import 'package:dart_code/dart_code.dart';

import 'basic.dart';
import 'model.dart';
import 'statement.dart';

/// Refers to [Type]
/// For the Dart Type system, see: [https://dart.dev/guides/language/type-system]
/// For the Dart build in types, see: [https://dart.dev/guides/language/language-tour#built-in-types]
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

  Type.ofGenericList(Type genericType)
      : name = 'List',
        libraryUrl = null,
        generics = [if (genericType != null) genericType];

  Type.ofSet() : this.ofGenericSet(null);

  Type.ofGenericSet(Type genericType)
      : name = 'Set',
        libraryUrl = null,
        generics = [if (genericType != null) genericType];

  Type.ofMap()
      : name = 'Map',
        libraryUrl = null,
        generics = [];

  Type.ofGenericMap(Type keyType, Type valueType)
      : name = 'Map',
        libraryUrl = null,
        generics = [keyType, valueType];

  Type.ofFuture(Type type)
      : name = 'Future',
        libraryUrl = null,
        generics = [type];

  Type.ofStream(Type type)
      : name = 'Stream',
        libraryUrl = null,
        generics = [type];

  Type(this.name, {this.libraryUrl, this.generics = const []});

  @override
  List<CodeNode> codeNodes(Context context) =>
      Reference(this).codeNodes(context);
}

/// Importing makes the components in a library available to the caller code.
/// The import keyword is used to achieve the same.
/// A dart file can have multiple import statements.
/// Import statements use the following URLs:
/// - the dart: scheme to refer to build in Dart library.
/// - the package: scheme to refer to a library inside a package.
/// - or a relative reference to a library inside your project.
///
/// [Type]s are often defined with their library URL's in order to make them unique
/// The dart_code library will organize these URL's and references to these Types for you
/// See: [https://dart.dev/guides/language/language-tour#libraries-and-visibility]
class Import extends CodeModel {
  final String libraryUrl;
  final String alias;

  Import(this.libraryUrl, this.alias);

  ///e.g.import 'package:reflect_framework/reflect_info_service.dart' as _i1;
  @override
  List<CodeNode> codeNodes(Context context) => [
        KeyWord.import$,
        Space(),
        Code("'$libraryUrl'"),
        Space(),
        KeyWord.as$,
        Space(),
        Code(alias),
        EndOfStatement(),
      ];
}

/// A collection of [Import] statements (and their aliases)
/// See: [https://dart.dev/guides/language/language-tour#libraries-and-visibility]
class Imports extends CodeModel {
  /// A map of [Library] URLs and their aliases
  final Map<String, String> _imports = {};

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
      if (!_imports.containsKey(libraryUrl)) {
        _imports[libraryUrl] = '_i${_imports.length + 1}';
      }
      for (Type genericType in type.generics) {
        //recursive call
        _registerType(genericType);
      }
    }
  }

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> imports = [];
    imports.addAll(_imports.keys
        .map((libraryUrl) => Import(libraryUrl, _imports[libraryUrl]))
        .toList());
    return imports;
  }

  bool containsKey(String libraryUrl) => _imports.containsKey(libraryUrl);

  String aliasOf(String libraryUrl) => _imports[libraryUrl];
}

/// Represents a [Reference] to a [Library] depending on the alias of an [Import] statement
/// See: [https://dart.dev/guides/language/language-tour#libraries-and-visibility]
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
            'Types need to be registered to Imports, before getting a reference, for libraryUrl: $libraryUrl');
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

  SeparatedValues _genericNodes(Type type) {
    List<CodeNode> genericNodes = [];
    for (Type genericType in type.generics) {
      if (type != genericType) {
        genericNodes.add(Reference(genericType));
      }
    }
    return SeparatedValues.forParameters(genericNodes);
  }
}
