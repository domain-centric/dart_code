// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

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

  ///e.g.import 'package:my_package/my_library.dart' as i1;
  @override
  List<CodeNode> codeNodes(Imports imports) => [
    KeyWord.import$,
    Space(),
    Code("'$libraryUri'"),
    Space(),
    KeyWord.as$,
    Space(),
    Code(alias),
    EndOfStatement(),
  ];

  bool get hasRelativePath => libraryUri.startsWith('/');
}

/// A collection of [Import] statements (and their aliases)
/// See: [https://dart.dev/guides/language/language-tour#libraries-and-visibility]
class Imports extends CodeModel {
  final Map<String, String> _libraryUriAndAliases = {};

  void registerLibraries(CodeNode codeNode, Imports imports) {
    if (codeNode is CodeModelWithLibraryUri) {
      _registerLibrary(codeNode.libraryUri);
    }
    if (codeNode is CodeModel) {
      _registerChildrenRecursively(codeNode, imports);
    }
  }

  void _registerChildrenRecursively(CodeModel codeNode, Imports imports) {
    for (CodeNode child in codeNode.codeNodes(imports)) {
      registerLibraries(child, imports);
    }
  }

  void _registerLibrary(String? libraryUri) {
    if (libraryUri != null) {
      var normalizedLibraryUri = _normalize(libraryUri);
      if (!_libraryUriAndAliases.containsKey(normalizedLibraryUri)) {
        _libraryUriAndAliases[normalizedLibraryUri] =
            'i${_libraryUriAndAliases.length + 1}';
      }
    }
  }

  @override
  List<CodeNode> codeNodes(Imports imports) {
    List<Import> imports = _createImports();
    List<CodeNode> codeNodes = [];
    if (_hasRelativePath(imports)) {
      codeNodes.add(
        Comment.fromString("ignore_for_file: avoid_relative_lib_imports"),
      );
    }
    codeNodes.addAll(imports);
    return codeNodes;
  }

  bool _hasRelativePath(List<Import> imports) {
    for (var import in imports) {
      if (import.hasRelativePath) {
        return true;
      }
    }
    return false;
  }

  List<Import> _createImports() {
    List<Import> imports = _libraryUriAndAliases.keys
        .map(
          (libraryUri) =>
              Import(libraryUri, _libraryUriAndAliases[libraryUri]!),
        )
        .toList();
    return imports;
  }

  bool containsKey(String libraryUri) =>
      _libraryUriAndAliases.containsKey(_normalize(libraryUri));

  Code aliasOf(String libraryUri) {
    if (!_libraryUriAndAliases.containsKey(libraryUri)) {
      _registerLibrary(libraryUri);
    }
    return Code(_libraryUriAndAliases[_normalize(libraryUri)]!);
  }

  /// Returns a normalized library uri:
  /// * All characters should be lower case
  /// * This also makes the keys of [_libraryUriAndAliases] case unsensitive
  /// * Removes everything up until the first slash (relative uri) when the uri
  ///   starts with 'asset:' because its likely we have a dart file in the
  ///   example folder
  String _normalize(String libraryUri) {
    String normalizedUri = libraryUri.toLowerCase();
    var firstSlashIndex = normalizedUri.indexOf('/');
    if (normalizedUri.startsWith('asset:') && firstSlashIndex > 0) {
      normalizedUri = normalizedUri.substring(firstSlashIndex);
    }
    return normalizedUri;
  }
}
