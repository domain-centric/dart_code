// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// Represents a dart enumeration declaration.
/// See [https://dart.dev/guides/language/language-tour#classes]
class Enumeration extends CodeModel {
  final List<DocComment>? docComments;
  final List<Annotation>? annotations;
  final IdentifierStartingWithUpperCase name;
  final List<Type>? implements;
  final Set<EnumValue> values;
  final Constructor? constructor;
  final List<Method>? methods;

  Enumeration(
    String name,
    this.values, {
    this.docComments,
    this.annotations,
    this.implements,
    this.constructor,
    this.methods,
  }) : name = IdentifierStartingWithUpperCase(name) {
    validateIfValuesIsNotEmpty();
    validateIfConstructorContainsParameters();
    validateIfConstructorParametersHaveTypes();
  }

  @override
  List<CodeNode> codeNodes(Imports imports) => [
    if (docComments != null) ...docComments!,
    if (annotations != null) ...annotations!,
    KeyWord.enum$,
    Space(),
    name,
    Space(),
    if (implements != null) KeyWord.implements$,
    if (implements != null) Space(),
    if (implements != null) SeparatedValues.forParameters(implements!),
    if (implements != null) Space(),
    Block([
      SeparatedValues.forParameters(values),
      if (constructor != null || (methods ?? []).isNotEmpty) Code(';\n'),
      if (constructor != null) normalizedEnumConstructor(constructor!),
      if (constructor != null) ...fieldsFromConstructor(constructor!),
      if (methods != null) SeparatedValues.forStatements(methods!),
    ]),
  ];

  void validateIfValuesIsNotEmpty() {
    if (values.isEmpty) {
      throw ArgumentError('must have 1 or more values', 'values');
    }
  }

  void validateIfConstructorIsConst() {
    if (constructor?.constant == null || !constructor!.constant) {
      throw ArgumentError('must be a constant constructor', 'constructor');
    }
  }

  void validateIfConstructorContainsParameters() {
    if (constructor == null) {
      return;
    }
    if (constructor!.parameters == null ||
        constructor!.parameters!.parameters.isEmpty) {
      throw ArgumentError(
        'must have one or more constructor parameters',
        'constructor',
      );
    }
  }

  void validateIfConstructorParametersHaveTypes() {
    if (constructor == null) {
      return;
    }
    var parameters = constructor!.parameters!.parameters;
    for (var parameter in parameters) {
      parameter as ConstructorParameter;
      if (parameter.type == null) {
        throw ArgumentError(
          'constructor parameter: ${parameter.name} must have a type',
          'constructor',
        );
      }
    }
  }

  Constructor normalizedEnumConstructor(Constructor constructor) =>
      constructor.copyWith(
        parameters: normalizedConstructorParameters(constructor.parameters!),
        constant: true,
        factory: false,
      );

  ConstructorParameters normalizedConstructorParameters(
    ConstructorParameters parameters,
  ) => ConstructorParameters(
    parameters.parameters
        .cast<ConstructorParameter>()
        .map(
          (p) => p.copyWith(
            qualifier: Qualifier.this$,
            required: (p.type is! Type || !(p.type as Type).nullable),
          ),
        )
        .toList(),
  );

  Iterable<Field> fieldsFromConstructor(Constructor constructor) =>
      constructor.parameters!.parameters.map((p) {
        var field = Field(
          p.name.toString(),
          type: p.type,
          modifier: Modifier.final$,
        );
        print(field.toString());
        return field;
      });
}

class EnumValue extends CodeModel {
  final IdentifierStartingWithLowerCase name;
  final ParameterValues? parameterValues;
  EnumValue(String name, [this.parameterValues])
    : name = IdentifierStartingWithLowerCase(name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumValue &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          parameterValues == other.parameterValues;

  @override
  int get hashCode => name.hashCode ^ (parameterValues?.hashCode ?? 0);

  @override
  List<CodeNode> codeNodes(Imports imports) => [
    name,
    if (parameterValues != null) Code('('),
    if (parameterValues != null) parameterValues!,
    if (parameterValues != null) Code(')'),
  ];
}
