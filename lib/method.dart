import 'parameter.dart';
import 'statement.dart';
import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'model.dart';

enum PropertyAccessor {
  getter,
  setter,
}

class Method extends CodeModel {
  final List<DocComment> docComments;
  final List<Annotation> annotations;
  final bool abstract;
  final bool static;
  final Type type;
  final PropertyAccessor propertyAccessor;
  final Asynchrony asynchrony;
  final IdentifierStartingWithLowerCase name;
  final Parameters parameters;
  final Body body;

  Method.abstract(
      String name, {
        this.docComments = const [],
        this.annotations = const [],
        this.type,
        this.parameters,
        this.asynchrony,
      })  : abstract = true,
        static = false,
        name = IdentifierStartingWithLowerCase(name),
        propertyAccessor = null,
        body = null;

  Method.static(
      String name,
      CodeNode body, {
        this.docComments = const [],
        this.annotations = const [],
        this.type,
        this.parameters,
        this.asynchrony,
      })  : abstract = false,
        static = true,
        name = IdentifierStartingWithLowerCase(name),
        propertyAccessor = null,
        body = Body([body]);

  Method(
      String name,
      CodeNode body, {
        this.docComments = const [],
        this.annotations = const [],
        this.type,
        this.parameters,
        this.asynchrony,
      })  : abstract = false,
        static = false,
        name = IdentifierStartingWithLowerCase(name),
        propertyAccessor = null,
        body = Body([body]);

  Method.getter(
      String name,
      CodeNode body, {
        this.docComments = const [],
        this.annotations = const [],
        this.type,
        this.parameters,
        this.asynchrony,
      })  : abstract = false,
        static = false,
        name = IdentifierStartingWithLowerCase(name),
        propertyAccessor = PropertyAccessor.getter,
        body = Body([body]);

  Method.setter(
      String name,
      CodeNode body, {
        this.docComments = const [],
        this.annotations = const [],
        this.type,
        this.parameters,
        this.asynchrony,
      })  : abstract = false,
        static = false,
        name = IdentifierStartingWithLowerCase(name),
        propertyAccessor = PropertyAccessor.setter,
        body = Body([body]);


  @override
  List<CodeNode> codeNodes(Context context) => [
    if (docComments != null) ...docComments,
    if (annotations != null) ...annotations,
    if (abstract) KeyWord.abstract$,
    if (abstract) SpaceWhenNeeded(),
    if (static) KeyWord.static$,
    if (static) SpaceWhenNeeded(),
    if (type != null &&
        (propertyAccessor == null ||
            propertyAccessor != PropertyAccessor.setter))
      type,
    if (type != null &&
        (propertyAccessor == null ||
            propertyAccessor != PropertyAccessor.setter))
      SpaceWhenNeeded(),
    if (propertyAccessor != null &&
        propertyAccessor == PropertyAccessor.getter)
      KeyWord.get$,
    if (propertyAccessor != null &&
        propertyAccessor == PropertyAccessor.setter)
      KeyWord.set$,
    if (propertyAccessor != null) SpaceWhenNeeded(),
    name,
    if (propertyAccessor == null ||
        propertyAccessor != PropertyAccessor.getter)
      Code('('),
    if (propertyAccessor != null &&
        propertyAccessor == PropertyAccessor.setter)
      Parameter.required(name.name, type: type),
    if (parameters != null && propertyAccessor == null) parameters,
    if (propertyAccessor == null ||
        propertyAccessor != PropertyAccessor.getter)
      Code(')'),
    if (asynchrony != null) SpaceWhenNeeded(),
    if (asynchrony != null && asynchrony == Asynchrony.async)
      KeyWord.async$,
    if (asynchrony != null && asynchrony == Asynchrony.asyncStar)
      KeyWord.asyncStar$,
    if (asynchrony != null && asynchrony == Asynchrony.sync) KeyWord.sync$,
    if (asynchrony != null && asynchrony == Asynchrony.syncStar)
      KeyWord.syncStar$,
    if (!abstract) SpaceWhenNeeded(),
    if (!abstract) body,
    if (abstract) EndOfStatement(),
  ];
}