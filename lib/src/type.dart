import 'package:dart_code/dart_code.dart';

import 'basic.dart';
import 'model.dart';

/// Refers to [Type]
/// For the Dart Type system, see: [https://dart.dev/guides/language/type-system]
/// For the Dart build in types, see: [https://dart.dev/guides/language/language-tour#built-in-types]
class Type extends CodeModelWithLibraryUri {
  final String name;
  List<Type> generics = [];

  Type.ofBool()
      : name = 'bool',
        super();

  Type.ofInt()
      : name = 'int',
        super();

  Type.ofDouble()
      : name = 'double',
        super();

  Type.ofDateTime()
      : name = 'DateTime',
        super();

  Type.ofString()
      : name = 'String',
        super();

  Type.ofVar()
      : name = 'var',
        super();

  Type.ofList({Type? genericType})
      : name = 'List',
        generics = genericType == null ? const [] : [genericType],
        super();

  Type.ofSet({Type? genericType})
      : name = 'Set',
        generics = genericType == null ? const [] : [genericType],
        super();

  Type.ofMap({Type? keyType, Type? valueType})
      : name = 'Map',
        generics = (keyType == null && valueType == null)
            ? const []
            : [keyType!, valueType!],
        super();

  Type.ofFuture(Type type)
      : name = 'Future',
        generics = [type],
        super();

  Type.ofStream(Type type)
      : name = 'Stream',
        generics = [type],
        super();

  Type(this.name, {String? libraryUri, this.generics = const []})
      : super(libraryUri: libraryUri);

  @override
  List<CodeNode> codeNodesToWrap(Context context) => [
        Code(name),
        if (generics.isNotEmpty) Code('<'),
        if (generics.isNotEmpty) SeparatedValues.forParameters(generics),
        if (generics.isNotEmpty) Code('>'),
      ];
}
