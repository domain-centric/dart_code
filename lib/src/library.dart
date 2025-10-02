// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// Represents a [Library] containing optional [DocComment]s, [Annotation]s, [DartFunction]s and [Class]es
/// See: [https://www.tutorialspoint.com/dart_programming/dart_programming_libraries.htm#:~:text=A%20library%20in%20a%20programming,typedefs%2C%20properties%2C%20and%20exceptions.]
class Library extends CodeModel {
  final IdentifierStartingWithLowerCase? name;
  final List<DocComment>? docComments;
  final List<Annotation>? annotations;
  final Statement? libraryStatement;
  final List<DartFunction>? functions;
  final List<Class>? classes;
  final List<Enumeration>? enumerations;
  final List<TypeDef>? typeDefs;

  Library({
    String? name,
    this.docComments,
    this.annotations,
    this.functions,
    this.classes,
    this.enumerations,
    this.typeDefs,
  })  : name = name == null ? null : IdentifierStartingWithLowerCase(name),
        libraryStatement = name == null ? null : Statement.library(name);

  Library copyWith({
    String? name,
    List<DocComment>? docComments,
    List<Annotation>? annotations,
    List<DartFunction>? functions,
    List<Class>? classes,
    List<Enumeration>? enumerations,
    List<TypeDef>? typeDefs,
  }) {
    return Library(
      name: name ?? this.name.toString(),
      docComments: docComments ?? this.docComments,
      annotations: annotations ?? this.annotations,
      functions: functions ?? this.functions,
      classes: classes ?? this.classes,
      enumerations: enumerations ?? this.enumerations,
      typeDefs: typeDefs ?? this.typeDefs,
    );
  }

  @override
  List<CodeNode> codeNodes(Imports imports) {
    var codeNodes = [
      if (libraryStatement != null) libraryStatement!,
      imports,
      if (docComments != null) ...docComments!,
      if (annotations != null) ...annotations!,
      if (functions != null) SeparatedValues.forStatements(functions!),
      if (classes != null) SeparatedValues.forStatements(classes!),
      if (enumerations != null) SeparatedValues.forStatements(enumerations!),
      if (typeDefs != null) SeparatedValues.forStatements(typeDefs!),
    ];
    for (var codeNode in codeNodes) {
      imports.registerLibraries(codeNode, imports);
    }
    return codeNodes;
  }
}
