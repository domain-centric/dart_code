# dart_code

A package for creating valid and formatted code, e.g. when writing code [builders](https://pub.dev/packages/build).

## Usage
The dart_code package provides a Dart code model that can be converted to code using the toString() method.

Example of a main function with a print statement:
```dart
import 'package:dart_code/dart_code.dart';

main() {
  print(Function.main(Statement.print(Expression.ofString('Hello World.'))).toString());
}
```

Outputs:
```dart
main() {
  print('Hello World.');
}
```

Use the CodeFormatter class for alternative formatting. The CodeFormatter has the following optional parameters:
- int maxLineLength
- String indent
- String wrapIndent
- String newLine

Alternative formatting example:
```dart
import 'package:dart_code/dart_code.dart';

main() {
    print(CodeFormatter(indent: '    ').format(
        Function.main(Statement.print(Expression.ofString('Hello World.')))));
}
```

Outputs:
```dart
main() {
    print('Hello World.');
}
```

An example of a library with unique imports:
```dart
import 'package:dart_code/dart_code.dart';

main() {
    print(Class('Employee',
            superClass: Type('Person', libraryUrl:'package:my_package/person.dart'),
            implements: [Type('Skills', libraryUrl:'package:my_package/skills.dart')],
            abstract: true,
         )]).toString());
}
```

Outputs:
```dart
import 'package:my_package/person.dart' as _i1;
import 'package:my_package/skills.dart' as _i2;

abstract class Employee extends _i1.Person implements _i2.Skills {

}
```

For more examples see: https://github.com/efficientyboosters/dart_code/tree/main/test

## Most important classes to use
You will probably be using the following code modeling classes:

- Library
  - Function
  - Class
    - Field
    - Constructor
    - Method
- Expressions (for code that results in a value)
- Statement (for code that does something)
- Comment
- DocComment
- Annotation

## Inspiration
This package was inspired by the code_builder package.
- dart_code is simpler and likely less complete
- dart_code classes can extended (no fluent builders used) so that code model logic can be included in extended classes.
- dart_code allows you to directly use the toString() method on the code classes or use the CodeFormatter class for alternative formatting settings.