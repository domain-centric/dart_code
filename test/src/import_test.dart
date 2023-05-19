import 'package:dart_code/dart_code.dart';
import 'package:dart_code/src/import.dart';
import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';

main() {
  given('object: Import', () {
    var import = Import("package:test/test.dart", "i1");

    when('calling: formatter', () {
      var result = CodeFormatter().unFormatted(import);

      String expected = 'import \'package:test/test.dart\' as i1;';
      then('return: $expected', () {
        result.should.be(expected);
      });
    });
  });

  given('object: Imports with references to libraries', () {
    Statements statements = Statements([
      Statement([Type("MyFirstClass", libraryUri: "package:test/test1.dart")]),
      Statement([Type("MySecondClass", libraryUri: "package:test/test2.dart")]),
    ]);
    Context context = Context(statements);
    var imports = context.imports;

    when('calling: formatter', () {
      String result = CodeFormatter().unFormatted(imports);

      String expected = "import 'package:test/test1.dart' as i1;"
          "import 'package:test/test2.dart' as i2;";
      then('return: "$expected"', () {
        result.should.be(expected);
      });
    });
  });

  given(
      'object Imports object with references to libraries with capital letters',
      () {
    Statements statements = Statements([
      Statement([Type("MyFirstClass", libraryUri: "package:TEST/test1.dart")]),
      Statement([Type("MySecondClass", libraryUri: "package:test/TEST2.dart")]),
    ]);
    Context context = Context(statements);
    var imports = context.imports;

    when('calling: formatter', () {
      String result = CodeFormatter().unFormatted(imports);

      String expected = "import 'package:test/test1.dart' as i1;"
          "import 'package:test/test2.dart' as i2;";
      then('return: "$expected"', () {
        result.should.be(expected);
      });
    });
  });

  given('object Imports object with references to assets', () {
    Statements statements = Statements([
      Statement([
        Type("MyFirstClass",
            libraryUri: "asset:map_converter/example/lib/person/person.dart")
      ]),
      Statement([
        Type("MySecondClass",
            libraryUri: "asset:map_converter/example/lib/person/gender.dart")
      ]),
    ]);
    Context context = Context(statements);
    var imports = context.imports;

    when('calling: formatter', () {
      String result = CodeFormatter().unFormatted(imports);

      String expected = "// ignore_for_file: avoid_relative_lib_imports\n"
          "import '/example/lib/person/person.dart' as i1;"
          "import '/example/lib/person/gender.dart' as i2;";
      then('return: "$expected"', () {
        result.should.be(expected);
      });
    });
  });

  given('object: statements with references to libraries', () {
    var statements = Statements([
      Statement([Type("MyFirstClass", libraryUri: "package:test/test1.dart")]),
      Statement([Type("MySecondClass", libraryUri: "package:test/test2.dart")]),
    ]);

    when('calling: formatter', () {
      String result = CodeFormatter().unFormatted(statements);
      String expected = 'i1.MyFirstClass;i2.MySecondClass;';
      then('return: "$expected"', () {
        result.should.be(expected);
      });
    });
  });
}
