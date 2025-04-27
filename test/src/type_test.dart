// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

main() {
  group('Type class', () {
    test('Should result in var', () {
      Type.ofVar().toString().should.be("var");
    });

    test('Should result in Object', () {
      Type.ofObject().toString().should.be("Object");
    });

    test('Should result in Object?', () {
      Type.ofObject(nullable: true).toString().should.be("Object?");
    });

    test('Should result in dynamic', () {
      Type.ofDynamic().toString().should.be("dynamic");
    });

    test('Should result in dynamic?', () {
      Type.ofDynamic(nullable: true).toString().should.be("dynamic?");
    });

    test('Should result in bool', () {
      Type.ofBool().toString().should.be("bool");
    });

    test('Should result in bool?', () {
      Type.ofBool(nullable: true).toString().should.be("bool?");
    });

    test('Should result in num', () {
      Type.ofNum().toString().should.be("num");
    });

    test('Should result in num?', () {
      Type.ofNum(nullable: true).toString().should.be("num?");
    });

    test('Should result in int', () {
      Type.ofInt().toString().should.be("int");
    });

    test('Should result in int?', () {
      Type.ofInt(nullable: true).toString().should.be("int?");
    });

    test('Should result in double', () {
      Type.ofDouble().toString().should.be("double");
    });

    test('Should result in double?', () {
      Type.ofDouble(nullable: true).toString().should.be("double?");
    });

    test('Should result in BigInt', () {
      Type.ofBigInt().toString().should.be("BigInt");
    });

    test('Should result in BigInt?', () {
      Type.ofBigInt(nullable: true).toString().should.be("BigInt?");
    });

    test('Should result in String', () {
      Type.ofString().toString().should.be("String");
    });

    test('Should result in String?', () {
      Type.ofString(nullable: true).toString().should.be("String?");
    });

    test('Should result in Uri', () {
      Type.ofUri().toString().should.be("Uri");
    });

    test('Should result in Uri?', () {
      Type.ofUri(nullable: true).toString().should.be("Uri?");
    });

    test('Should result in DateTime', () {
      Type.ofDateTime().toString().should.be("DateTime");
    });

    test('Should result in DateTime?', () {
      Type.ofDateTime(nullable: true).toString().should.be("DateTime?");
    });

    test('Should result in Duration', () {
      Type.ofDuration().toString().should.be("Duration");
    });
    test('Should result in Duration?', () {
      Type.ofDuration(nullable: true).toString().should.be("Duration?");
    });

    test("Should return: 'List'", () {
      Type.ofList().toString().should.be("List");
    });

    test("Should return: 'List?'", () {
      Type.ofList(nullable: true).toString().should.be("List?");
    });

    test("Should return: 'List<String>'", () {
      Type.ofList(genericType: Type.ofString())
          .toString()
          .should
          .be("List<String>");
    });

    test("Should return: 'List<String>?'", () {
      Type.ofList(genericType: Type.ofString(), nullable: true)
          .toString()
          .should
          .be("List<String>?");
    });

    test("Should return: 'Set'", () {
      Type.ofSet().toString().should.be("Set");
    });

    test("Should return: 'Set?'", () {
      Type.ofSet(nullable: true).toString().should.be("Set?");
    });

    test("Should return: 'Set<String>'", () {
      Type.ofSet(genericType: Type.ofString())
          .toString()
          .should
          .be("Set<String>");
    });

    test("Should return: 'Set<String>?'", () {
      Type.ofSet(genericType: Type.ofString(), nullable: true)
          .toString()
          .should
          .be("Set<String>?");
    });

    test("Should return: 'Map'", () {
      Type.ofMap().toString().should.be("Map");
    });

    test("Should return: 'Map?'", () {
      Type.ofMap(nullable: true).toString().should.be("Map?");
    });

    test("Should return: 'Map<int, String>'", () {
      Type.ofMap(keyType: Type.ofInt(), valueType: Type.ofString())
          .toString()
          .should
          .be("Map<int,String>");
    });
    test("Should return: 'Map<int, String>?'", () {
      Type.ofMap(
              keyType: Type.ofInt(), valueType: Type.ofString(), nullable: true)
          .toString()
          .should
          .be("Map<int,String>?");
    });

    test("Should return: 'i1.MyClass'", () {
      Type("MyClass", libraryUri: "package:test/test.dart")
          .toString()
          .should
          .be("i1.MyClass");
    });

    test("Should return: 'i1.MyClass?'", () {
      Type("MyClass", libraryUri: "package:test/test.dart", nullable: true)
          .toString()
          .should
          .be("i1.MyClass?");
    });
  });
}
