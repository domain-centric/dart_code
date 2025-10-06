// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// Defines a record type
/// For Record implementation/values see: [Expression.ofRecord]
class Record extends CodeModel implements BaseType {
  final List<RecordField> fields;
  final bool nullable;

  Record(this.fields, {this.nullable = false});

  @override
  List<CodeNode> codeNodes(Imports imports) {
    var positionalFields = fields.where((e) => e.name == null).toList();
    var namedFields = fields.where((e) => e.name != null).toList();
    return [
      Code('('),
      SeparatedValues.forParameters(positionalFields),
      if (positionalFields.isNotEmpty && namedFields.isNotEmpty) Code(','),
      if (namedFields.isNotEmpty) Code('{'),
      if (namedFields.isNotEmpty) SeparatedValues.forParameters(namedFields),
      if (namedFields.isNotEmpty) Code('}'),
      Code(')'),
      if (nullable) Code('?'),
    ];
  }
}

/// A class representing a field in a record.
///
/// This class extends [CodeModel] and is used to define the structure
/// and behavior of a field within a record. It can be used to model
/// data fields with specific properties and functionality.
class RecordField extends CodeModel {
  final IdentifierStartingWithLowerCase? name;
  final Type type;

  RecordField(this.type) : name = null;

  RecordField.named(this.type, String name)
    : name = IdentifierStartingWithLowerCase(name);

  @override
  List<CodeNode> codeNodes(Imports imports) =>
      name == null ? [type] : [type, Code(' '), name!];
}

/// Represents a field value within a record in the code model.
///
/// This class is a part of the code model structure and is used to define
/// and manage individual field values associated with a record.
class RecordFieldValue extends CodeModel {
  final IdentifierStartingWithLowerCase? name;
  final Expression value;

  RecordFieldValue(this.value) : name = null;
  RecordFieldValue.named(String name, this.value)
    : name = IdentifierStartingWithLowerCase(name);

  @override
  List<CodeNode> codeNodes(Imports imports) =>
      name == null ? [value] : [name!, Code(': '), value];
}
