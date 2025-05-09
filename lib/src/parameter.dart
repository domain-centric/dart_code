// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

enum ParameterCategory { required, named, optional }

/// Represents the definition of a [Parameter] in a a [DartFunction] or [Method].
/// A [Parameter] definition can be:
/// - required positional
/// - or optional
/// - or named
/// See: [https://dart.dev/guides/language/language-tour#parameters]
class Parameter extends CodeModel {
  final ParameterCategory category;
  final BaseType? type;
  final bool this$;
  final IdentifierStartingWithLowerCase name;
  final Expression? defaultValue;
  final bool required;

  Parameter._(this.category, String name,
      {this.type, this.defaultValue, this.required = false, this.this$ = false})
      : name = IdentifierStartingWithLowerCase(name);

  Parameter.required(String name, {BaseType? type})
      : this._(ParameterCategory.required, name, type: type);

  Parameter.optional(String name, {BaseType? type, Expression? defaultValue})
      : this._(ParameterCategory.optional, name,
            type: type, defaultValue: defaultValue);

  Parameter.named(String name,
      {BaseType? type, defaultValue, bool required = false})
      : this._(ParameterCategory.named, name,
            type: type, defaultValue: defaultValue, required: required);

  @override
  List<CodeNode> codeNodes(Imports imports) => [
        if (required) Code('@required'),
        if (required) Space(),
        if (this$) KeyWord.this$,
        if (this$) Code('.'),
        if (!this$ && type == null) Code('var'),
        if (!this$ && type != null) type!,
        if (!this$) Space(),
        name,
        if (defaultValue != null) Space(),
        if (defaultValue != null) Code('='),
        if (defaultValue != null) Space(),
        if (defaultValue != null) defaultValue!,
      ];
}

/// [Parameters] can have any number of required positional [Parameter] definitions.
/// These can be followed either by named [Parameter] definitions or by optional positional [Parameter] definitions (but not both).
/// [Parameter] names must be unique.
class Parameters extends CodeModel {
  final List<Parameter> parameters;

  Parameters.empty() : parameters = [];

  Parameters(this.parameters) {
    _validate(this.parameters);
  }

  void _validate(List<Parameter> parameters) {
    _validateOnlyOptionalOrNamed(parameters);
    _validateUniqueNames(parameters);
  }

  void _validateOnlyOptionalOrNamed(List<Parameter> parameters) {
    var hasOptionalParameters =
        parameters.any((p) => p.category == ParameterCategory.optional);
    var hasNamedParameters =
        parameters.any((p) => p.category == ParameterCategory.named);
    if (hasOptionalParameters && hasNamedParameters) {
      throw new ArgumentError.value(parameters, 'parameters',
          'Parameters may not contain both optional parameters and named parameters');
    }
  }

  void _validateUniqueNames(List<Parameter> parameters) {
    var allNames = parameters.map((p) => p.name.toString()).toList();
    var allUniqueNames = parameters.map((p) => p.name.toString()).toSet();
    var namesAreUnique = allNames.length == allUniqueNames.length;
    if (!namesAreUnique) {
      throw new ArgumentError.value(
          parameters, 'parameters', 'Parameter names must be unique');
    }
  }

  @override
  List<CodeNode> codeNodes(Imports imports) {
    List<CodeNode> nodes = [];
    var _requiredParameters = parameters
        .where((p) => p.category == ParameterCategory.required)
        .toList();
    var _optionalParameters = parameters
        .where((p) => p.category == ParameterCategory.optional)
        .toList();
    var _namedParameters =
        parameters.where((p) => p.category == ParameterCategory.named).toList();

    nodes.add(SeparatedValues.forParameters(_requiredParameters));

    if (_requiredParameters.isNotEmpty &&
        (_optionalParameters.isNotEmpty || _namedParameters.isNotEmpty)) {
      nodes.add(Code(', '));
    }

    if (_optionalParameters.isNotEmpty) {
      nodes.add(Code('['));
      nodes.add(SeparatedValues.forParameters(_optionalParameters));
      nodes.add(Code(']'));
    } else if (_namedParameters.isNotEmpty) {
      nodes.add(Code('{'));
      nodes.add(SeparatedValues.forParameters(_namedParameters));
      nodes.add(Code('}'));
    }

    return nodes;
  }
}

/// Represents a [ConstructorParameter] definition.
/// A [ConstructorParameter] definition is comparable to a [Parameter] definition, but it can also have a default value and may refer to a [Field]
class ConstructorParameter extends Parameter {
  ConstructorParameter.required(String name,
      {bool this$ = false, BaseType? type})
      : super._(ParameterCategory.required, name, this$: this$, type: type);

  ConstructorParameter.optional(String name,
      {bool this$ = false, BaseType? type, Expression? defaultValue})
      : super._(ParameterCategory.optional, name,
            type: type, this$: this$, defaultValue: defaultValue);

  ConstructorParameter.named(String name,
      {bool this$ = false, BaseType? type, defaultValue, bool required = false})
      : super._(ParameterCategory.named, name,
            this$: this$,
            type: type,
            defaultValue: defaultValue,
            required: required);
}

/// [ConstructorParameters] are comparable to [Parameters] only for [ConstructorParameter]s
class ConstructorParameters extends Parameters {
  ConstructorParameters.empty() : super(const []);

  ConstructorParameters(List<ConstructorParameter> constructorParameters)
      : super(constructorParameters);
}

/// A [ParameterValue] is used when calling a [DartFunction], [Constructor] or [Method]
class ParameterValue extends CodeModel {
  final IdentifierStartingWithLowerCase? name;
  final Expression value;

  ParameterValue(this.value) : name = null;

  ParameterValue.named(String name, this.value)
      : name = IdentifierStartingWithLowerCase(name);

  @override
  List<CodeNode> codeNodes(Imports imports) =>
      [if (name != null) name!, if (name != null) Code(': '), value];
}

/// [ParameterValues] is a list of [ParameterValue]s
class ParameterValues extends SeparatedValues {
  ParameterValues(List<ParameterValue> parameterValues)
      : super.forParameters(_orderedParameterValues(parameterValues));

  ParameterValues.none() : super.forParameters([]);

  static List<CodeNode> _orderedParameterValues(
      List<ParameterValue> parameterValues) {
    List<ParameterValue> values = [];
    values.addAll(parameterValues.where((pv) => pv.name == null).toList());
    values.addAll(parameterValues.where((pv) => pv.name != null).toList());
    return values;
  }
}
