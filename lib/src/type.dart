import 'package:dart_code/dart_code.dart';

import 'basic.dart';
import 'model.dart';
import 'statement.dart';

/// Refers to [Type]
/// For the Dart Type system, see: [https://dart.dev/guides/language/type-system]
/// For the Dart build in types, see: [https://dart.dev/guides/language/language-tour#built-in-types]
class Type extends CodeModelWithLibraryUri {
  final String name;
  List<Type> generics = [];

  Type.ofBool()
      : name = 'bool',
        super();

  Type.ofInt()
      : name = 'int',
        super();

  Type.ofDouble()
      : name = 'double',
        super();

  Type.ofDateTime()
      : name = 'DateTime',
        super();

  Type.ofString()
      : name = 'String',
        super();

  Type.ofVar()
      : name = 'var',
        super();

  Type.ofList({Type? genericType})
      : name = 'List',
        generics = genericType == null ? const [] : [genericType],
        super();

  Type.ofSet({Type? genericType})
      : name = 'Set',
        generics = genericType == null ? const [] : [genericType],
        super();

  Type.ofMap({Type? keyType, Type? valueType})
      : name = 'Map',
        generics = (keyType == null && valueType == null)
            ? const []
            : [keyType!, valueType!],
        super();

  Type.ofFuture(Type type)
      : name = 'Future',
        generics = [type],
        super();

  Type.ofStream(Type type)
      : name = 'Stream',
        generics = [type],
        super();

  Type(this.name, {String? libraryUri, this.generics = const []})
      : super(libraryUri: libraryUri);

  @override
  List<CodeNode> codeNodesToWrap(Context context) => [
        Code(name),
        if (generics.isNotEmpty) Code('<'),
        if (generics.isNotEmpty) SeparatedValues.forParameters(generics),
        if (generics.isNotEmpty) Code('>'),
      ];
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
  final String libraryUri;
  final String alias;

  Import(this.libraryUri, this.alias);

  ///e.g.import 'package:reflect_framework/reflect_info_service.dart' as _i1;
  @override
  List<CodeNode> codeNodes(Context context) => [
        KeyWord.import$,
        Space(),
        Code("'$libraryUri'"),
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
  final Map<String, String> _libraryUriAndAliases = {};

  void registerLibraries(CodeNode codeNode, Context context) {
    if (codeNode is CodeModelWithLibraryUri) {
      _registerLibrary(codeNode.libraryUri);
    }
    if (codeNode is CodeModel) {
      _registerChildrenRecursively(codeNode, context);
    }
  }

  void _registerChildrenRecursively(CodeModel codeNode, Context context) {
    for (CodeNode child in codeNode.codeNodes(context)) {
      registerLibraries(child, context);
    }
  }

  void _registerLibrary(String? libraryUri) {
    if (libraryUri != null) {
      libraryUri = libraryUri.toLowerCase();
      if (!_libraryUriAndAliases.containsKey(libraryUri)) {
        _libraryUriAndAliases[libraryUri] =
            '_i${_libraryUriAndAliases.length + 1}';
      }
    }
  }

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> imports = [];
    imports.addAll(_libraryUriAndAliases.keys
        .map((libraryUri) =>
            Import(libraryUri, _libraryUriAndAliases[libraryUri]!))
        .toList());
    return imports;
  }

  bool containsKey(String libraryUri) =>
      _libraryUriAndAliases.containsKey(libraryUri);

  Code aliasOf(String libraryUri) {
    if (!_libraryUriAndAliases.containsKey(libraryUri)) {
      _registerLibrary(libraryUri);
    }
    return Code(_libraryUriAndAliases[libraryUri]!);
  }
}
