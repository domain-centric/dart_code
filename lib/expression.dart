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