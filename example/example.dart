import 'package:dart_code/dart_code.dart';

main() {
  //TODO check outputs
  /// A simple formatting example:
  print(DartFunction.main(Statement.print(Expression.ofString('Hello World.')))
      .toFormattedString());

  // OUTPUTS:
  // main() {
  //   print('Hello World.');
  // }

  /// An alternative formatting example
  print(DartFunction.main(Statement.print(Expression.ofString('Hello World.')))
      .toFormattedString(pageWidth: 20));

  // OUTPUTS:
  // main() {
  //   print(
  //     'Hello World.');
  // }

  /// An library example with imports
  print(Library(classes: [
    Class(
      'Employee',
      superClass: Type('Person', libraryUri: 'package:my_package/person.dart'),
      implements: [
        Type('Skills', libraryUri: 'package:my_package/skills.dart')
      ],
      abstract: true,
    )
  ]).toFormattedString());

  // OUTPUTS:
  // import 'package:my_package/person.dart' as i1;
  // import 'package:my_package/skills.dart' as i2;
  //
  // abstract class Employee extends i1.Person implements i2.Skills {}
}
