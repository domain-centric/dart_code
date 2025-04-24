// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// Represents a [Library] containing optional [DocComment]s, [Annotation]s, [DartFunction]s and [Class]es
/// See: [https://www.tutorialspoint.com/dart_programming/dart_programming_libraries.htm#:~:text=A%20library%20in%20a%20programming,typedefs%2C%20properties%2C%20and%20exceptions.]
class Library extends CodeModel {
  final List<DocComment>? docComments;
  final List<Annotation>? annotations;
  final Statement? libraryStatement;
  final List<DartFunction>? functions;
  final List<Class>? classes;

  Library({
    String? name,
    this.docComments,
    this.annotations,
    this.functions,
    this.classes,
  }) : libraryStatement = name == null ? null : Statement.library(name);

  @override
  List<CodeNode> codeNodes(Imports imports) {
    var codeNodes = [
      if (libraryStatement != null) libraryStatement!,
      imports,
      if (docComments != null) ...docComments!,
      if (annotations != null) ...annotations!,
      if (functions != null) SeparatedValues.forStatements(functions!),
      if (classes != null) SeparatedValues.forStatements(classes!),
    ];
    for (var codeNode in codeNodes) {
      imports.registerLibraries(codeNode, imports);
    }
    return codeNodes;
  }
}
