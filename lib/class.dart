import 'annotation.dart';
import 'basic.dart';
import 'model.dart';

class Constructor extends CodeModel {
  @override
  // TODO: implement codes
  List<CodeNode> codeNodes(Context context) => throw UnimplementedError();
}

class Method extends CodeModel {
  @override
  // TODO: implement codes
  List<CodeNode> codeNodes(Context context) => throw UnimplementedError();
}

class Field extends CodeModel {
  @override
  // TODO: implement codes
  List<CodeNode> codeNodes(Context context) => throw UnimplementedError();
}

class Class extends CodeModel {
  final IdentifierStartingWithUpperCase name;
  bool abstract;
  List<String> docs;
  List<Annotation> annotations;
  Type superClass;
  List<Type> implements = [];
  List<Type> mixins = [];
  List<Constructor> constructors;
  List<Method> methods;
  List<Field> fields;

  Class(String name) : this.name = IdentifierStartingWithUpperCase(name);

  @override
  List<CodeNode> codeNodes(Context context) => [
    //TODO DocComments
    //TODO Annotations
    if (abstract) KeyWord.$abstract,
    SpaceWhenNeeded(),
    KeyWord.$class,
    SpaceWhenNeeded(),
    name,
    SpaceWhenNeeded(),
    if (superClass != null) KeyWord.$extends,
    SpaceWhenNeeded(),
    if (superClass != null) superClass,
    // TODO implements
    //TODO with mixins
    SpaceWhenNeeded(),
    Block([
      Code(";"), //TODO  fields, properties, constructors, methods
    ]),
  ];
}
