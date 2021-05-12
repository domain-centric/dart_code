import 'annotation.dart';
import 'basic.dart';
import 'class.dart';
import 'comment.dart';
import 'function.dart';
import 'model.dart';
import 'statement.dart';

/// Represents a [Library] containing optional [DocComment]s, [Annotation]s, [Function]s and [Class]es
/// See: [https://www.tutorialspoint.com/dart_programming/dart_programming_libraries.htm#:~:text=A%20library%20in%20a%20programming,typedefs%2C%20properties%2C%20and%20exceptions.]
class Library extends CodeModel {
  final List<DocComment>? docComments;
  final List<Annotation>? annotations;
  final Statement? libraryStatement;
  final List<Function>? functions;
  final List<Class>? classes;

  Library({
    String? name,
    this.docComments,
    this.annotations,
    this.functions,
    this.classes,
  }) : libraryStatement = name == null ? null : Statement.library(name);

  @override
  List<CodeNode> codeNodes(Context context) =>
      [
        if (libraryStatement != null) libraryStatement!,
        context.imports,
        if (docComments != null) ...docComments!,
        if (annotations != null) ...annotations!,
        if (functions != null) SeparatedValues.forStatements(functions!),
        if (classes != null) SeparatedValues.forStatements(classes!),
      ];
}
