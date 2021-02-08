import 'package:dart_code/basic.dart';
import 'package:dart_code/formatting.dart';
import 'package:dart_code/parameter.dart';

import 'model.dart';

///  A syntactic entity in the Dart programming language that may be evaluated to determine its value
///  e.g.: 1 or or 1.1 or 1+2 or 1*2 or 'hello' or 'hello' + ' world' or user.name
class Expression extends CodeModel {
  final List<CodeNode> nodes;

  Expression(this.nodes);

  Expression.ofInt(int value) : nodes = [Code(value.toString())];

  Expression.ofDouble(double value) : nodes = [Code(value.toString())];

  Expression.ofBool(bool value) : nodes = [Code(value.toString())];

  Expression.ofDateTime(DateTime value) : nodes = [Code(value.toString())];

  Expression.ofString(String value) : nodes = _createStringNodes(value);

  Expression.ofVariable(String name) : nodes = [IdentifierStartingWithLowerCase(name)];

  Expression.callFunction( String name ,[ ParameterValues parameterValues]) :nodes=[
    if (name!=null) IdentifierStartingWithLowerCase(name),
    Code('('),
    if (parameterValues!=null) parameterValues,
    Code(')'),
  ];

  Expression.callConstructor(Type type, {String name , ParameterValues parameterValues}) :nodes=[
    type,
    if (name!=null) Code('.'),
    if (name!=null) IdentifierStartingWithLowerCase(name),
    Code('('),
    if (parameterValues!=null) parameterValues,
    Code(')'),
  ];

  Expression callMethod(String name, { ParameterValues parameterValues, bool cascade=false}) => Expression([
    this,
    if (!cascade) Code('.'),
    if (cascade) NewLine(),
    if (cascade) Code('..'),
    IdentifierStartingWithLowerCase(name),
    Code('('),
    if (parameterValues!=null) parameterValues,
    Code(')'),
  ]);


  Expression getProperty(String name, {bool cascade=false}) => Expression([
    this,
    if (!cascade) Code('.'),
    if (cascade) NewLine(),
    if (cascade) Code('..'),
    IdentifierStartingWithLowerCase(name),
  ]);


  Statement assignVariable(String name, [Type type]) => Statement([
        if (type == null) Type.ofVar(),
        if (type != null) type,
        SpaceWhenNeeded(),
        IdentifierStartingWithLowerCase(name),
        Code(' = '),
        this
      ]);




  List<CodeNode> codeNodes(Context context) => nodes;



  static RegExp singleQuote = RegExp("'");
  static RegExp doubleQuote = RegExp('"');
  static RegExp betweenSingleQuotes = RegExp("^'.*'\$");
  static RegExp betweenDoubleQuotes = RegExp('^".*"\$');

  static _createStringNodes(String value) {
    if (!betweenSingleQuotes.hasMatch(value) &&
        !betweenDoubleQuotes.hasMatch(value)) {
      int nrSingleQoutes = singleQuote.allMatches(value).length;
      int nrDoubleQoutes = doubleQuote.allMatches(value).length;
      if (nrSingleQoutes > 0 && nrDoubleQoutes == 0) {
        value = '"$value"';
      } else {
        value = "'$value'";
      }
    }
    return [Code(value.toString())];
  }
}
