/*
 * Copyright (c) 2022. By Nils ten Hoeve. See LICENSE file in project.
 */

import 'package:dart_code/dart_code.dart';

/// Refers to [Type]
/// For the Dart Type system, see: [https://dart.dev/guides/language/type-system]
/// For the Dart build in types, see: [https://dart.dev/guides/language/language-tour#built-in-types]
class Type extends CodeModelWithLibraryUri {
  final String name;
  final bool nullable;
  List<Type> generics = [];

  Type.ofBool({this.nullable = false})
      : name = 'bool',
        super();

  Type.ofNum({this.nullable = false})
      : name = 'num',
        super();

  Type.ofInt({this.nullable = false})
      : name = 'int',
        super();

  Type.ofDouble({this.nullable = false})
      : name = 'double',
        super();

  Type.ofDateTime({this.nullable = false})
      : name = 'DateTime',
        super();

  Type.ofString({this.nullable = false})
      : name = 'String',
        super();

  Type.ofVar()
      : name = 'var',
        this.nullable = false,
        super();

  Type.ofList({Type? genericType, this.nullable = false})
      : name = 'List',
        generics = genericType == null ? const [] : [genericType],
        super();

  Type.ofSet({Type? genericType, this.nullable = false})
      : name = 'Set',
        generics = genericType == null ? const [] : [genericType],
        super();

  Type.ofMap({Type? keyType, Type? valueType, this.nullable = false})
      : name = 'Map',
        generics = (keyType == null && valueType == null)
            ? const []
            : [keyType!, valueType!],
        super();

  Type.ofFuture(Type type, {this.nullable = false})
      : name = 'Future',
        generics = [type],
        super();

  Type.ofStream(Type type, {this.nullable = false})
      : name = 'Stream',
        generics = [type],
        super();

  Type(this.name,
      {String? libraryUri, this.generics = const [], this.nullable = false})
      : super(libraryUri: libraryUri);

  @override
  List<CodeNode> codeNodesToWrap(Context context) => [
        Code(name),
        if (generics.isNotEmpty) Code('<'),
        if (generics.isNotEmpty) SeparatedValues.forParameters(generics),
        if (generics.isNotEmpty) Code('>'),
        if (nullable) Code('?'),
      ];
}
