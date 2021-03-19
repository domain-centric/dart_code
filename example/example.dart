import 'package:dart_code/dart_code.dart';

main() {
  /// A simple formatting example:
  print(Function.main(Statement.print(Expression.ofString('Hello World.')))
      .toString());

  // OUTPUTS:
  // main() {
  //   print('Hello World.');
  // }

  /// An alternative formatting example
  print(CodeFormatter(indent: '    ').format(
      Function.main(Statement.print(Expression.ofString('Hello World.')))));

  // OUTPUTS:
  // main() {
  //     print('Hello World.');
  // }

  /// An library example with imports
  print(Class(
    'Employee',
    superClass: Type('Person', libraryUrl: 'package:my_package/person.dart'),
    implements: [Type('Skills', libraryUrl: 'package:my_package/skills.dart')],
    abstract: true,
  ).toString());

  // OUTPUTS:
  // import 'package:my_package/person.dart' as _i1;
  // import 'package:my_package/skills.dart' as _i2;
  //
  // abstract class Employee extends _i1.Person implements _i2.Skills {
  //
  // }
}
