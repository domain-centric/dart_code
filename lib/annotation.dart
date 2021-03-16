import 'formatting.dart';
import 'model.dart';
import 'parameter.dart';
import 'type.dart';

class Annotation extends CodeModel {
  final Type type;
  final ParameterValues parameterValues;

  Annotation(this.type, [this.parameterValues]);

  @override
  List<CodeNode> codeNodes(Context context) => [
        Code('@'),
        type,
        Code('('),
        if (parameterValues != null) parameterValues,
        Code(')'),
        NewLine(),
      ];
}
