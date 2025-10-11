// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';

/// BaseType is used to define a type that is a Type or an aggregated Type  like a Record
abstract class BaseType extends CodeModel {}

/// Refers to [Type]
/// For the Dart Type system, see: [https://dart.dev/guides/language/type-system]
/// For the Dart build in types, see: [https://dart.dev/guides/language/language-tour#built-in-types]
class Type extends CodeModelWithLibraryUri implements BaseType {
  final String name;
  final bool nullable;
  List<Type> generics = [];

  Type(
    this.name, {
    String? libraryUri,
    this.generics = const [],
    this.nullable = false,
  }) : super(libraryUri: libraryUri);

  Type copyWith({String? name, bool? nullable, List<Type>? generics}) {
    return Type(
      name ?? this.name,
      nullable: nullable ?? this.nullable,
      generics: generics ?? List<Type>.from(this.generics),
    );
  }

  Type.ofObject({this.nullable = false}) : name = 'Object', super();

  Type.ofDynamic({this.nullable = false}) : name = 'dynamic', super();

  Type.ofBool({this.nullable = false}) : name = 'bool', super();

  Type.ofNum({this.nullable = false}) : name = 'num', super();

  Type.ofInt({this.nullable = false}) : name = 'int', super();

  Type.ofBigInt({this.nullable = false}) : name = 'BigInt', super();

  Type.ofDouble({this.nullable = false}) : name = 'double', super();

  Type.ofString({this.nullable = false}) : name = 'String', super();

  Type.ofUri({this.nullable = false}) : name = 'Uri', super();

  Type.ofDateTime({this.nullable = false}) : name = 'DateTime', super();

  Type.ofDuration({this.nullable = false}) : name = 'Duration', super();

  Type.ofVoid() : name = 'void', this.nullable = false, super();

  Type.ofVar() : name = 'var', this.nullable = false, super();

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

  @override
  List<CodeNode> codeNodesToWrap(Imports imports) => [
    Code(name),
    if (generics.isNotEmpty) Code('<'),
    if (generics.isNotEmpty) SeparatedValues.forParameters(generics),
    if (generics.isNotEmpty) Code('>'),
    if (nullable) Code('?'),
  ];
}
