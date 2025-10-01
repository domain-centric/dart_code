// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('class Import', () {
    test('Import toString should return correct code', () {
      Import("package:test/test.dart", "i1")
          .toString()
          .should
          .be("import 'package:test/test.dart' as i1;");
    });

    test('Imports toUnFormattedString should return correct import code', () {
      Imports imports = Imports();
      Statements([
        Statement(
            [Type("MyFirstClass", libraryUri: "package:test/test1.dart")]),
        Statement(
            [Type("MySecondClass", libraryUri: "package:test/test2.dart")]),
      ]).toUnFormattedString(imports);
      imports.toString().should.be("import 'package:test/test1.dart' as i1;"
          "import 'package:test/test2.dart' as i2;");
    });

    test(
        'Statements with capital case in libraryUri should return correct import code',
        () {
      Imports imports = Imports();
      Statements([
        Statement(
            [Type("MyFirstClass", libraryUri: "package:TEST/test1.dart")]),
        Statement(
            [Type("MySecondClass", libraryUri: "package:test/TEST2.dart")]),
      ]).toUnFormattedString(imports);
      imports.toString().should.be("import 'package:test/test1.dart' as i1;"
          "import 'package:test/test2.dart' as i2;");
    });

    test(
        'Imports object with references to assets should return the correct import code',
        () {
      Imports imports = Imports();
      Statements([
        Statement([
          Type("MyFirstClass",
              libraryUri: "asset:map_converter/example/lib/person/person.dart")
        ]),
        Statement([
          Type("MySecondClass",
              libraryUri: "asset:map_converter/example/lib/person/gender.dart")
        ]),
      ]).toUnFormattedString(imports);
      imports
          .toString()
          .should
          .be("// ignore_for_file: avoid_relative_lib_imports\n"
              "import '/example/lib/person/person.dart' as i1;"
              "import '/example/lib/person/gender.dart' as i2;");
    });

    test(
        'statements with references to libraries should result in the correct code',
        () {
      Statements([
        Statement(
            [Type("MyFirstClass", libraryUri: "package:test/test1.dart")]),
        Statement(
            [Type("MySecondClass", libraryUri: "package:test/test2.dart")]),
      ]).toString().should.be('i1.MyFirstClass;i2.MySecondClass;');
    });
  });
}
