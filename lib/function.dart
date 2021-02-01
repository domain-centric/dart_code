import 'basic.dart';
import 'model.dart';
import 'parameter.dart';

// ignore: deprecated_function_class_declaration
class Function extends CodeModel {
  final Type returnType;
  final IdentifierStartingWithLowerCase name;
  final Parameters parameters;
  final Body body;

  Function.withoutName(this.body, {this.parameters, this.returnType})
      : name = null;

  Function.withName(String name, this.body, {this.parameters, this.returnType})
      : name = IdentifierStartingWithLowerCase(name);

  @override
  List<CodeNode> codeNodes(Context context) => [
        if (returnType != null) returnType,
        SpaceWhenNeeded(),
        if (name != null) name,
        Code('('),
        if (parameters != null) parameters,
        Code(')'),
        body,
      ];
}
