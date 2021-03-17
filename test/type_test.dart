import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Type class', () {
    test('Should result in var', () {
      String actual = Type.ofVar().toString();
      String expected = "var";
      expect(actual, expected);
    });

    test('Should result in bool', () {
      String actual = Type.ofBool().toString();
      String expected = "bool";
      expect(actual, expected);
    });

    test('Should result in int', () {
      String actual = Type.ofInt().toString();
      String expected = "int";
      expect(actual, expected);
    });

    test('Should result in double', () {
      String actual = Type.ofDouble().toString();
      String expected = "double";
      expect(actual, expected);
    });

    test('Should result in DateTime', () {
      String actual = Type.ofDateTime().toString();
      String expected = "DateTime";
      expect(actual, expected);
    });

    test('Should result in String', () {
      String actual = Type.ofString().toString();
      String expected = "String";
      expect(actual, expected);
    });

    test("Should return: 'List'", () {
      String actual = Type.ofList().toString();
      String expected = "List";
      expect(actual, expected);
    });

    test("Should return: 'List<String>'", () {
      String actual = Type.ofGenericList(Type.ofString()).toString();
      String expected = "List<String>";
      expect(actual, expected);
    });

    test("Should return: 'Set'", () {
      String actual = Type.ofSet().toString();
      String expected = "Set";
      expect(actual, expected);
    });

    test("Should return: 'Set<String>'", () {
      String actual = Type.ofGenericSet(Type.ofString()).toString();
      String expected = "Set<String>";
      expect(actual, expected);
    });

    test("Should return: 'Map'", () {
      String actual = Type.ofMap().toString();
      String expected = "Map";
      expect(actual, expected);
    });

    test("Should return: 'Map<int, String>'", () {
      String actual =
          Type.ofGenericMap(Type.ofInt(), Type.ofString()).toString();
      String expected = 'Map<\n'
          '  int,\n'
          '  String>';
      expect(actual, expected);
    });

    test("Should return: '_i1.MyClass'", () {
      String actual =
          Type("MyClass", libraryUrl: "package:test/test.dart").toString();
      String expected = "_i1.MyClass";
      expect(actual, expected);
    });
  });

  group('Import class', () {
    test('Given Import => Returns correct code string', () {
      String actual = Import("package:test/test.dart", "_i1").toString();
      String expected = "import 'package:test/test.dart' as _i1;\n";
      expect(actual, expected);
    });
  });

  group('Imports class', () {
    test('Given types => Returns correct import string', () {
      Statements statements = Statements([
        Statement(
            [Type("MyFirstClass", libraryUrl: "package:test/test1.dart")]),
        Statement(
            [Type("MySecondClass", libraryUrl: "package:test/test2.dart")]),
      ]);
      String actual = Imports(statements, Context(statements)).toString();
      String expected = 'import \'package:test/test1.dart\' as _i1;\n'
          'import \'package:test/test2.dart\' as _i2;\n'
          '\n';
      expect(actual, expected);
    });

    test('Given types => Returns correct type code strings', () {
      String actual = Statements([
        Statement(
            [Type("MyFirstClass", libraryUrl: "package:test/test1.dart")]),
        Statement(
            [Type("MySecondClass", libraryUrl: "package:test/test2.dart")]),
      ]).toString();
      String expected = '_i1.MyFirstClass;\n'
          '_i2.MySecondClass;\n';
      expect(actual, expected);
    });
  });
}
