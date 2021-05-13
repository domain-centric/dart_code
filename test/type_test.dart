import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Type class', () {
    test('Should result in var', () {
      String actual = CodeFormatter().unFormatted(Type.ofVar());
      String expected = "var";
      expect(actual, expected);
    });

    test('Should result in bool', () {
      String actual = CodeFormatter().unFormatted(Type.ofBool());
      String expected = "bool";
      expect(actual, expected);
    });

    test('Should result in int', () {
      String actual = CodeFormatter().unFormatted(Type.ofInt());
      String expected = "int";
      expect(actual, expected);
    });

    test('Should result in double', () {
      String actual = CodeFormatter().unFormatted(Type.ofDouble());
      String expected = "double";
      expect(actual, expected);
    });

    test('Should result in DateTime', () {
      String actual = CodeFormatter().unFormatted(Type.ofDateTime());
      String expected = "DateTime";
      expect(actual, expected);
    });

    test('Should result in String', () {
      String actual = CodeFormatter().unFormatted(Type.ofString());
      String expected = "String";
      expect(actual, expected);
    });

    test("Should return: 'List'", () {
      String actual = CodeFormatter().unFormatted(Type.ofList());
      String expected = "List";
      expect(actual, expected);
    });

    test("Should return: 'List<String>'", () {
      String actual = CodeFormatter()
          .unFormatted(Type.ofList(genericType: Type.ofString()));
      String expected = "List<String>";
      expect(actual, expected);
    });

    test("Should return: 'Set'", () {
      String actual = CodeFormatter().unFormatted(Type.ofSet());
      String expected = "Set";
      expect(actual, expected);
    });

    test("Should return: 'Set<String>'", () {
      String actual =
          CodeFormatter().unFormatted(Type.ofSet(genericType: Type.ofString()));
      String expected = "Set<String>";
      expect(actual, expected);
    });

    test("Should return: 'Map'", () {
      String actual = CodeFormatter().unFormatted(Type.ofMap());
      String expected = "Map";
      expect(actual, expected);
    });

    test("Should return: 'Map<int, String>'", () {
      String actual = CodeFormatter().unFormatted(
          Type.ofMap(keyType: Type.ofInt(), valueType: Type.ofString()));
      String expected = 'Map<int,String>';
      expect(actual, expected);
    });

    test("Should return: '_i1.MyClass'", () {
      String actual = CodeFormatter()
          .unFormatted(Type("MyClass", libraryUri: "package:test/test.dart"));
      String expected = "_i1.MyClass";
      expect(actual, expected);
    });
  });

  group('Import class', () {
    test('Given Import => Returns correct code string', () {
      String actual =
          CodeFormatter().unFormatted(Import("package:test/test.dart", "_i1"));
      String expected = 'import \'package:test/test.dart\' as _i1;';
      expect(actual, expected);
    });
  });

  group('Imports class', () {
    test('Given types => Returns correct import string', () {
      Statements statements = Statements([
        Statement(
            [Type("MyFirstClass", libraryUri: "package:test/test1.dart")]),
        Statement(
            [Type("MySecondClass", libraryUri: "package:test/test2.dart")]),
      ]);
      Context context = Context(statements);
      String actual = CodeFormatter().unFormatted(context.imports);
      String expected =
          'import \'package:test/test1.dart\' as _i1;import \'package:test/test2.dart\' as _i2;';
      expect(actual, expected);
    });

    test('Given types => Returns correct type code strings', () {
      String actual = CodeFormatter().unFormatted(Statements([
        Statement(
            [Type("MyFirstClass", libraryUri: "package:test/test1.dart")]),
        Statement(
            [Type("MySecondClass", libraryUri: "package:test/test2.dart")]),
      ]));
      String expected = '_i1.MyFirstClass;_i2.MySecondClass;';
      expect(actual, expected);
    });
  });
}
