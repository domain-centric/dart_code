import 'annotation.dart';
import 'basic.dart';
import 'class.dart';
import 'comment.dart';
import 'formatting.dart';
import 'function.dart';
import 'model.dart';
import 'statement.dart';

class Library extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;
  final Statement libraryStatement;
  final List<Function> functions;
  final List<Class> classes;

  Library({
    String name,
    this.docComments,
    this.annotations,
    this.functions,
    this.classes,
  }) : libraryStatement = name == null ? null : Statement.library(name);

  @override
  List<CodeNode> codeNodes(Context context) => [
        if (libraryStatement != null) libraryStatement,
        if (libraryStatement != null) NewLine(),
        context.imports,
        if (docComments != null) ...docComments,
        if (annotations != null) ...annotations,
        if (functions != null) SeparatedValues.forStatements(functions),
        if (functions != null) NewLine(),
        if (classes != null) SeparatedValues.forStatements(classes),
      ];
}
