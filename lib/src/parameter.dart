import 'basic.dart';
import 'expression.dart';
import 'model.dart';
import 'type.dart';

enum ParameterCategory { required, named, optional }

class Parameter extends CodeModel {
  final ParameterCategory category;
  final Type type;
  final bool this$;
  final IdentifierStartingWithLowerCase name;
  final Expression defaultValue;
  final bool required;

  Parameter._(this.category, String name,
      {this.type, this.defaultValue, this.required = false, this.this$ = false})
      : name = IdentifierStartingWithLowerCase(name);

  Parameter.required(String name, {Type type})
      : this._(ParameterCategory.required, name, type: type);

  Parameter.optional(String name, {Type type, Expression defaultValue})
      : this._(ParameterCategory.optional, name,
            type: type, defaultValue: defaultValue);

  Parameter.named(String name, {Type type, defaultValue, bool required = false})
      : this._(ParameterCategory.named, name,
            type: type, defaultValue: defaultValue, required: required);

  @override
  List<CodeNode> codeNodes(Context context) => [
        if (required) Code('@required'),
        if (required) SpaceWhenNeeded(),
        if (this$) KeyWord.this$,
        if (this$) Code('.'),
        if (!this$ && type == null) Code('var'),
        if (!this$ && type != null) type,
        if (!this$) SpaceWhenNeeded(),
        name,
        if (defaultValue != null) SpaceWhenNeeded(),
        if (defaultValue != null) Code('='),
        if (defaultValue != null) SpaceWhenNeeded(),
        if (defaultValue != null) defaultValue,
      ];
}

/// [Parameters]  can have any number of required positional parameters.
/// These can be followed either by named parameters or by optional positional parameters (but not both).
/// Parameter names must be unique.
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
    if (hasOptionalParameters && hasNamedParameters)
      throw new ArgumentError.value(parameters, 'parameters',
          'Parameters may not contain both optional parameters and named parameters');
  }

  void _validateUniqueNames(List<Parameter> parameters) {
    var allNames = parameters.map((p) => p.name.toString()).toList();
    var allUniqueNames = parameters.map((p) => p.name.toString()).toSet();
    var namesAreUnique = allNames.length == allUniqueNames.length;
    if (!namesAreUnique)
      throw new ArgumentError.value(
          parameters, 'parameters', 'Parameter names must be unique');
  }

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> nodes = [];
    if (parameters != null) {
      var _requiredParameters = parameters
          .where((p) => p.category == ParameterCategory.required)
          .toList();
      var _optionalParameters = parameters
          .where((p) => p.category == ParameterCategory.optional)
          .toList();
      var _namedParameters = parameters
          .where((p) => p.category == ParameterCategory.named)
          .toList();

      nodes.add(SeparatedValues.forParameters(_requiredParameters));

      if (_requiredParameters.isNotEmpty &&
          (_optionalParameters.isNotEmpty || _namedParameters.isNotEmpty))
        nodes.add(Code(', '));

      if (_optionalParameters.isNotEmpty) {
        nodes.add(Code('['));
        nodes.add(SeparatedValues.forParameters(_optionalParameters));
        nodes.add(Code(']'));
      } else if (_namedParameters.isNotEmpty) {
        nodes.add(Code('{'));
        nodes.add(SeparatedValues.forParameters(_namedParameters));
        nodes.add(Code('}'));
      }
    }
    return nodes;
  }
}

class ConstructorParameter extends Parameter {
  ConstructorParameter.required(String name, {bool this$ = false, Type type})
      : super._(ParameterCategory.required, name, this$: this$, type: type);

  ConstructorParameter.optional(String name,
      {bool this$ = false, Type type, Expression defaultValue})
      : super._(ParameterCategory.optional, name,
            type: type, this$: this$, defaultValue: defaultValue);

  ConstructorParameter.named(String name,
      {bool this$ = false, Type type, defaultValue, bool required = false})
      : super._(ParameterCategory.named, name,
            this$: this$,
            type: type,
            defaultValue: defaultValue,
            required: required);
}

class ConstructorParameters extends Parameters {
  ConstructorParameters.empty() : super(const []);

  ConstructorParameters(List<ConstructorParameter> constructorParameters)
      : super(constructorParameters);
}

class ParameterValue extends CodeModel {
  final IdentifierStartingWithLowerCase name;
  final Expression value;

  ParameterValue(this.value) : name = null;

  ParameterValue.named(String name, this.value)
      : name = (name == null) ? null : IdentifierStartingWithLowerCase(name);

  @override
  List<CodeNode> codeNodes(Context context) =>
      [if (name != null) name, if (name != null) Code(': '), value];
}

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
