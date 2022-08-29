/*
 * Copyright (c) 2022. By Nils ten Hoeve. See LICENSE file in project.
 */

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

    test('Should result in bool?', () {
      String actual = CodeFormatter().unFormatted(Type.ofBool(nullable: true));
      String expected = "bool?";
      expect(actual, expected);
    });

    test('Should result in num', () {
      String actual = CodeFormatter().unFormatted(Type.ofNum());
      String expected = "num";
      expect(actual, expected);
    });

    test('Should result in num?', () {
      String actual = CodeFormatter().unFormatted(Type.ofNum(nullable: true));
      String expected = "num?";
      expect(actual, expected);
    });

    test('Should result in int', () {
      String actual = CodeFormatter().unFormatted(Type.ofInt());
      String expected = "int";
      expect(actual, expected);
    });

    test('Should result in int?', () {
      String actual = CodeFormatter().unFormatted(Type.ofInt(nullable: true));
      String expected = "int?";
      expect(actual, expected);
    });

    test('Should result in double', () {
      String actual = CodeFormatter().unFormatted(Type.ofDouble());
      String expected = "double";
      expect(actual, expected);
    });
    test('Should result in double?', () {
      String actual =
          CodeFormatter().unFormatted(Type.ofDouble(nullable: true));
      String expected = "double?";
      expect(actual, expected);
    });
    test('Should result in DateTime', () {
      String actual = CodeFormatter().unFormatted(Type.ofDateTime());
      String expected = "DateTime";
      expect(actual, expected);
    });
    test('Should result in DateTime?', () {
      String actual =
          CodeFormatter().unFormatted(Type.ofDateTime(nullable: true));
      String expected = "DateTime?";
      expect(actual, expected);
    });

    test('Should result in String', () {
      String actual = CodeFormatter().unFormatted(Type.ofString());
      String expected = "String";
      expect(actual, expected);
    });
    test('Should result in String?', () {
      String actual =
          CodeFormatter().unFormatted(Type.ofString(nullable: true));
      String expected = "String?";
      expect(actual, expected);
    });

    test("Should return: 'List'", () {
      String actual = CodeFormatter().unFormatted(Type.ofList());
      String expected = "List";
      expect(actual, expected);
    });

    test("Should return: 'List?'", () {
      String actual = CodeFormatter().unFormatted(Type.ofList(nullable: true));
      String expected = "List?";
      expect(actual, expected);
    });

    test("Should return: 'List<String>'", () {
      String actual = CodeFormatter()
          .unFormatted(Type.ofList(genericType: Type.ofString()));
      String expected = "List<String>";
      expect(actual, expected);
    });

    test("Should return: 'List<String>?'", () {
      String actual = CodeFormatter().unFormatted(
          Type.ofList(genericType: Type.ofString(), nullable: true));
      String expected = "List<String>?";
      expect(actual, expected);
    });

    test("Should return: 'Set'", () {
      String actual = CodeFormatter().unFormatted(Type.ofSet());
      String expected = "Set";
      expect(actual, expected);
    });

    test("Should return: 'Set?'", () {
      String actual = CodeFormatter().unFormatted(Type.ofSet(nullable: true));
      String expected = "Set?";
      expect(actual, expected);
    });

    test("Should return: 'Set<String>'", () {
      String actual =
          CodeFormatter().unFormatted(Type.ofSet(genericType: Type.ofString()));
      String expected = "Set<String>";
      expect(actual, expected);
    });

    test("Should return: 'Set<String>?'", () {
      String actual = CodeFormatter().unFormatted(
          Type.ofSet(genericType: Type.ofString(), nullable: true));
      String expected = "Set<String>?";
      expect(actual, expected);
    });

    test("Should return: 'Map'", () {
      String actual = CodeFormatter().unFormatted(Type.ofMap());
      String expected = "Map";
      expect(actual, expected);
    });

    test("Should return: 'Map?'", () {
      String actual = CodeFormatter().unFormatted(Type.ofMap(nullable: true));
      String expected = "Map?";
      expect(actual, expected);
    });

    test("Should return: 'Map<int, String>'", () {
      String actual = CodeFormatter().unFormatted(
          Type.ofMap(keyType: Type.ofInt(), valueType: Type.ofString()));
      String expected = 'Map<int,String>';
      expect(actual, expected);
    });
    test("Should return: 'Map<int, String>?'", () {
      String actual = CodeFormatter().unFormatted(Type.ofMap(
          keyType: Type.ofInt(), valueType: Type.ofString(), nullable: true));
      String expected = 'Map<int,String>?';
      expect(actual, expected);
    });

    test("Should return: 'i1.MyClass'", () {
      String actual = CodeFormatter()
          .unFormatted(Type("MyClass", libraryUri: "package:test/test.dart"));
      String expected = "i1.MyClass";
      expect(actual, expected);
    });

    test("Should return: 'i1.MyClass?'", () {
      String actual = CodeFormatter().unFormatted(Type("MyClass",
          libraryUri: "package:test/test.dart", nullable: true));
      String expected = "i1.MyClass?";
      expect(actual, expected);
    });
  });
}
