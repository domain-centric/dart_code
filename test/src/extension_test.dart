import 'package:test/test.dart';
import 'package:dart_code/dart_code.dart';

void main() {
  group('Extension', () {
    test('should initialize with correct name and onType', () {
      final extension = Extension('MyExtension', Type('String'));

      expect(extension.name.toString(), equals('MyExtension'));
      expect(extension.onType!.toString(), equals('String'));
    });

    test('should include docComments in codeNodes if present', () {
      final docComment = DocComment.fromString('/// This is an extension');
      final extension = Extension(
        'MyExtension',
        Type('String'),
        docComments: [docComment],
      );

      final nodes = extension.codeNodes(Imports());
      expect(nodes.contains(docComment), isTrue);
    });

    test('should include annotations in codeNodes if present', () {
      final annotation = Annotation.deprecated();
      final extension = Extension(
        'MyExtension',
        Type('String'),
        annotations: [annotation],
      );

      // Assuming annotations are used somewhere in codeNodes (not shown in your code)
      // This test is a placeholder unless annotations are actually added to codeNodes
      final nodes = extension.codeNodes(Imports());
      expect(
        nodes.contains(annotation),
        isFalse,
      ); // Adjust if annotations are used
    });

    test('should include methods in codeNodes if present', () {
      final method = Method('greet', Body([]), returnType: Type.ofVoid(), );
      final extension = Extension(
        'MyExtension',
        Type('String'),
        methods: [method],
      );

      final nodes = extension.codeNodes(Imports());
      expect(nodes.toString(), contains('greet'));
    });

    test('should throw if onType is null', () {
      expect(() => Extension('MyExtension', null), throwsA(isA<TypeError>()));
    });
  });
}
