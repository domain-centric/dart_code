import 'package:dart_code/dart_code.dart';

/// Represents an [Annotation]. See [https://dart.dev/guides/language/language-tour#metadata]
class Annotation extends CodeModel {
  final Type type;
  final ParameterValues? parameterValues;
  final bool customType;

  Annotation(this.type, [this.parameterValues]) : customType = true;

  Annotation._dartType(String name)
      : type = Type(name),
        parameterValues = null,
        customType = false;

  Annotation.override() : this._dartType('override');

  Annotation.deprecated() : this._dartType('deprecated');

  Annotation.required() : this._dartType('required');

  @override
  List<CodeNode> codeNodes(Context context) => [
        Code('@'),
        type,
        if (customType) Code('('),
        if (customType && parameterValues != null) parameterValues!,
        if (customType) Code(')'),
        NewLine(),
      ];
}
