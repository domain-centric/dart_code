import '../dart_code.dart';

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

  ///e.g.import 'package:reflect_framework/reflectinfo_service.dart' as i1;
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
            'i${_libraryUriAndAliases.length + 1}';
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
