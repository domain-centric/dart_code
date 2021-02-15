import 'formatting.dart';
import 'parameter.dart';
import 'basic.dart';
import 'model.dart';

class Annotation extends CodeModel {
  final Type type;
  final ParameterValues parameterValues;

  Annotation(this.type,[this.parameterValues]);

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
