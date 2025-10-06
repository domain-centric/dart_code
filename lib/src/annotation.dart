// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
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

  /// Creates an annotation for overriding a member in a subclass.
  /// See [https://api.dart.dev/dart-core/override-constant.html] for more details.
  Annotation.override() : this._dartType('override');

  /// Creates an annotation for deprecated a member in a subclass.
  /// See [https://api.dart.dev/dart-core/Deprecated-class.html] for more details.
  Annotation.deprecated() : this._dartType('deprecated');

  /// Creates a required annotation.
  /// @required is just an annotation that allows analyzers let you know that you're
  ///  missing a named parameter and that's it. so you can still compile the application
  /// and possibly get an exception if this named param was not passed.
  Annotation.required() : this._dartType('required');

  @override
  List<CodeNode> codeNodes(Imports imports) => [
    Code('@'),
    type,
    if (customType) Code('('),
    if (customType && parameterValues != null) parameterValues!,
    if (customType) Code(')'),
    NewLine(),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Annotation &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          parameterValues == other.parameterValues &&
          customType == other.customType;

  @override
  int get hashCode =>
      type.hashCode ^ parameterValues.hashCode ^ customType.hashCode;
}
