import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'constructor.dart';
import 'field.dart';
import 'formatting.dart';
import 'method.dart';
import 'model.dart';
import 'type.dart';

class Class extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;
  final bool abstract;
  final IdentifierStartingWithUpperCase name;
  final Type superClass;
  final List<Type> implements;
  final List<Type> mixins;
  final List<Field> fields;
  final List<Constructor> constructors;
  final List<Method> methods;

  Class(
    String name, {
    this.docComments,
    this.annotations,
    this.abstract,
    this.superClass,
    this.implements,
    this.mixins,
    this.fields,
    this.constructors,
    this.methods,
  }) : this.name = IdentifierStartingWithUpperCase(name);

  @override
  List<CodeNode> codeNodes(Context context) => [
        if (docComments != null) ...docComments,
        if (annotations != null) ...annotations,
        if (abstract != null && abstract) KeyWord.abstract$,
        if (abstract != null && abstract) SpaceWhenNeeded(),
        KeyWord.class$,
        SpaceWhenNeeded(),
        name,
        SpaceWhenNeeded(),
        if (superClass != null) KeyWord.extends$,
        if (superClass != null) SpaceWhenNeeded(),
        if (superClass != null) superClass,
        if (superClass != null) SpaceWhenNeeded(),
        if (implements != null) KeyWord.implements$,
        if (implements != null) SpaceWhenNeeded(),
        if (implements != null) SeparatedValues.forParameters(implements),
        if (implements != null) SpaceWhenNeeded(),
        if (mixins != null) KeyWord.with$,
        if (mixins != null) SpaceWhenNeeded(),
        if (mixins != null) SeparatedValues.forParameters(mixins),
        if (mixins != null) SpaceWhenNeeded(),
        Block([
          NewLine(),
          if (fields != null) ...fields,
          if (fields != null) NewLine(),
          if (constructors != null) SeparatedValues.forStatements(constructors),
          if (constructors != null) NewLine(),
          if (methods != null) SeparatedValues.forStatements(methods),
          if (methods != null) NewLine(),
        ]),
        NewLine(),
      ];
}
