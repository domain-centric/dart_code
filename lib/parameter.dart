import 'package:dart_code/basic.dart';

import 'model.dart';

abstract class Parameter extends CodeModel {

  final Type type;
  final IdentifierStartingWithLowerCase name;
  final Expression defaultValue;
  final bool required;

  Parameter(this.type, this.name, [this.defaultValue, this.required = false]);

  @override
  List<CodeNode> codeNodes(Context context) =>
      [
        if (required) Code('@required '),
        type,
        SpaceWhenNeeded(),
        name,
        if (defaultValue != null) Code('='),
        if (defaultValue != null) defaultValue,
      ];
}

class RequiredParameter extends Parameter {
  RequiredParameter(Type type, IdentifierStartingWithLowerCase name)
      : super(type, name);
}

class OptionalParameter extends Parameter {
  OptionalParameter(Type type, IdentifierStartingWithLowerCase name,
      {Expression defaultValue}) : super(type, name, defaultValue);
}

class NamedParameter extends Parameter {
  NamedParameter(Type type, IdentifierStartingWithLowerCase name,
      {Expression defaultValue, bool required})
      : super(type, name, defaultValue, required);
}


///[Parameters]  can have any number of required positional parameters. These can be followed either by named parameters or by optional positional parameters (but not both).
class Parameters extends CodeModel {

  final List<Parameter> parameters;

  Parameters.none(): parameters=[];


  Parameters(this.parameters) {
    _validate(parameters);
  }

  void _validate(List<Parameter> parameters) {
    _validateOnlyOptionalOrNamed(parameters);
    _validateUniqueNames(parameters);
  }

  void _validateOnlyOptionalOrNamed(List<Parameter> parameters) {
    var hasOptionalParameters = parameters.any((p) => p is OptionalParameter);
    var hasNamedParameters = parameters.any((p) => p is NamedParameter);
    if (hasOptionalParameters && hasNamedParameters)
      throw new ArgumentError.value(
          parameters, 'parameters',
          'Parameters may not contain both optional parameters and named parameters');
  }

  void _validateUniqueNames(List<Parameter> parameters) {
    var allNames = parameters.map((p) => p.name).toList();
    var allUniqueNames = parameters.map((p) => p.name).toSet();
    var namesAreUnique = allNames.length == allUniqueNames.length;
    if (!namesAreUnique)
      throw new ArgumentError.value(
          parameters, 'parameters', 'Parameter names must be unique');
  }

  @override
  List<CodeNode> codeNodes(Context context) {
    List<CodeNode> nodes = [];
    if (parameters != null) {
      var _requiredParameters = parameters.where((p) => p is RequiredParameter)
          .toList();
      var _optionalParameters = parameters.where((p) => p is OptionalParameter)
          .toList();
      var _namedParameters = parameters.where((p) => p is NamedParameter)
          .toList();

      nodes.add(CommaSeparatedValues(_requiredParameters));

      if (_requiredParameters.isNotEmpty &&
          (_optionalParameters.isNotEmpty || _namedParameters.isNotEmpty))
        nodes.add(Code(', '));

      if (_optionalParameters.isNotEmpty) {
        nodes.add(Code('['));
        nodes.add(CommaSeparatedValues(_optionalParameters));
        nodes.add(Code(']'));
      } else if (_requiredParameters.isNotEmpty) {
        nodes.add(Code('{'));
        nodes.add(CommaSeparatedValues(_requiredParameters));
        nodes.add(Code('}'));
      }
    }
    return nodes;
  }

}

class ParameterValue extends CodeModel {
  final Expression value;

  ParameterValue(this.value);

  @override
  List<CodeNode> codeNodes(Context context) => value.codeNodes(context);
}

class NamedParameterValue extends ParameterValue {
  final IdentifierStartingWithLowerCase name;
  NamedParameterValue(this.name, Expression value): super(value);

  @override
  List<CodeNode> codeNodes(Context context) => [
    name,
    Code(':'),
    value
  ];
}

class ParameterValues extends CommaSeparatedValues {
  ParameterValues(List<ParameterValue> parameterValues) : super(parameterValues);
}