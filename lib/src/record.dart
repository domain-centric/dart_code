import 'package:dart_code/dart_code.dart';

/// Defines a record type
/// For Record implementation/values see: [Expression.ofRecord]
class Record extends CodeModel implements BaseType {
  final List<RecordField> fields;
  final bool nullable;

  Record(this.fields, {this.nullable = false});

  @override
  List<CodeNode> codeNodes(Context context) {
    return [
      Code('('),
      SeparatedValues.forParameters(fields),
      Code(')'),
      if (nullable) Code('?'),
    ];
  }
}

class RecordField extends CodeModel {
  final IdentifierStartingWithLowerCase? name;
  final Type type;

  RecordField(this.type) : name = null;

  RecordField.named(this.type, String name)
      : name = IdentifierStartingWithLowerCase(name);

  @override
  List<CodeNode> codeNodes(Context context) =>
      name == null ? [type] : [type, Code(' '), name!];
}

class RecordFieldValue extends CodeModel {
  final IdentifierStartingWithLowerCase? name;
  final Expression value;

  RecordFieldValue(this.value) : name = null;
  RecordFieldValue.named(
    String name,
    this.value,
  ) : name = IdentifierStartingWithLowerCase(name);

  @override
  List<CodeNode> codeNodes(Context context) =>
      name == null ? [value] : [name!, Code(': '), value];
}
