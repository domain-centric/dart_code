import 'basic.dart';
import 'expression.dart';
import 'model.dart';

abstract class Parameter extends CodeModel {
  final Type type;
  final bool this$;
  final IdentifierStartingWithLowerCase name;
  final Expression defaultValue;
  final bool required;

  Parameter(String name,
      {this.type, this.defaultValue, this.required = false, this.this$ = false})
      : name = IdentifierStartingWithLowerCase(name);

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
        if (defaultValue != null) Code(' = '),
        if (defaultValue != null) defaultValue,
      ];
}

abstract class ConstructorParameter extends Parameter {
  ConstructorParameter(String name,
      {Type type,
      Expression defaultValue,
      bool required = false,
      bool this$ = false})
      : super(name,
            type: type,
            defaultValue: defaultValue,
            required: required,
            this$: this$);
}

class RequiredParameter extends Parameter {
  RequiredParameter(String name, {Type type}) : super(name, type: type);
}

class RequiredConstructorParameter extends ConstructorParameter {
  RequiredConstructorParameter(String name, {bool this$ = false, Type type})
      : super(name, this$: this$, type: type);
}

class OptionalParameter extends Parameter {
  OptionalParameter(String name, {Type type, Expression defaultValue})
      : super(name, type: type, defaultValue: defaultValue);
}

class OptionalConstructorParameter extends ConstructorParameter {
  OptionalConstructorParameter(String name,
      {bool this$ = false, Type type, Expression defaultValue})
      : super(name, type: type, this$: this$, defaultValue: defaultValue);
}

class NamedParameter extends Parameter {
  NamedParameter(String name, {Type type, defaultValue, bool required = false})
      : super(name, type: type, defaultValue: defaultValue, required: required);
}

class NamedConstructorParameter extends ConstructorParameter {
  NamedConstructorParameter(String name,
      {bool this$ = false, Type type, defaultValue, bool required = false})
      : super(name,
            this$: this$,
            type: type,
            defaultValue: defaultValue,
            required: required);
}

/// [Parameters]  can have any number of required positional parameters.
/// These can be followed either by named parameters or by optional positional parameters (but not both).
/// Parameter names must be unique.
class Parameters extends CodeModel {
  final List<Parameter> parameters;

  Parameters.none() : parameters = [];

  Parameters(this.parameters) {
    _validate(this.parameters);
  }

  void _validate(List<Parameter> parameters) {
    _validateOnlyOptionalOrNamed(parameters);
    _validateUniqueNames(parameters);
  }

  void _validateOnlyOptionalOrNamed(List<Parameter> parameters) {
    var hasOptionalParameters = parameters.any((p) => p is OptionalParameter);
    var hasNamedParameters = parameters.any((p) => p is NamedParameter);
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
      var _requiredParameters =
          parameters.where((p) => p is RequiredParameter).toList();
      var _optionalParameters =
          parameters.where((p) => p is OptionalParameter).toList();
      var _namedParameters =
          parameters.where((p) => p is NamedParameter).toList();

      nodes.add(CommaSeparatedValues(_requiredParameters));

      if (_requiredParameters.isNotEmpty &&
          (_optionalParameters.isNotEmpty || _namedParameters.isNotEmpty))
        nodes.add(Code(', '));

      if (_optionalParameters.isNotEmpty) {
        nodes.add(Code('['));
        nodes.add(CommaSeparatedValues(_optionalParameters));
        nodes.add(Code(']'));
      } else if (_namedParameters.isNotEmpty) {
        nodes.add(Code('{'));
        nodes.add(CommaSeparatedValues(_namedParameters));
        nodes.add(Code('}'));
      }
    }
    return nodes;
  }
}

class ConstructorParameters extends Parameters {
  ConstructorParameters(List<ConstructorParameter> constructorParameters)
      : super(constructorParameters);
}

class ParameterValue extends CodeModel {
  final Expression value;

  ParameterValue(this.value);

  @override
  List<CodeNode> codeNodes(Context context) => value.codeNodes(context);
}

class NamedParameterValue extends ParameterValue {
  final IdentifierStartingWithLowerCase name;

  NamedParameterValue(String name, Expression value)
      : name = IdentifierStartingWithLowerCase(name),
        super(value);

  @override
  List<CodeNode> codeNodes(Context context) => [name, Code(': '), value];
}

class ParameterValues extends CommaSeparatedValues {
  ParameterValues(List<ParameterValue> parameterValues)
      : super(_orderedParameterValues(parameterValues));

  ParameterValues.none() : super([]);

  static List<CodeNode> _orderedParameterValues(
      List<ParameterValue> parameterValues) {
    List<ParameterValue> values = [];
    values.addAll(
        parameterValues.where((pv) => !(pv is NamedParameterValue)).toList());
    values.addAll(
        parameterValues.where((pv) => pv is NamedParameterValue).toList());
    return values;
  }
}
