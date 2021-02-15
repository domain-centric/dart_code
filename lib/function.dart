import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'model.dart';
import 'parameter.dart';

// ignore: deprecated_function_class_declaration
class Function extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;
  final Type returnType;
  final IdentifierStartingWithLowerCase name;
  final Parameters parameters;
  final Body body;

  Function.withoutName(CodeNode body,
      {this.docComments = const [],
      this.annotations = const [],
      this.parameters,
      this.returnType})
      : name = null,
        body = Body([body]);

  Function.withName(String name, CodeNode body,
      {this.docComments = const [],
      this.annotations = const [],
      this.parameters,
      this.returnType})
      : name = IdentifierStartingWithLowerCase(name),
        body = Body([body]);

  Function.main(CodeNode body,
      {this.docComments = const [],
      this.annotations = const [],
      this.parameters})
      : returnType = null,
        name = IdentifierStartingWithLowerCase('main'),
        body = Body([body]);

  @override
  List<CodeNode> codeNodes(Context context) => [
        ...docComments,
        ...annotations,
        SpaceWhenNeeded(),
        if (returnType != null) returnType,
        SpaceWhenNeeded(),
        if (name != null) name,
        Code('('),
        if (parameters != null) parameters,
        Code(')'),
        SpaceWhenNeeded(),
        body,
      ];
}
