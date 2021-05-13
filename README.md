# dart_code

A package for creating valid and formatted code, e.g. when writing code [builders](https://pub.dev/packages/build).

## Usage
The dart_code package provides a Dart code model that can be converted to code using the toString() method.

Example of a main function with a print statement:
```dart
import 'package:dart_code/dart_code.dart';

main() {
  print(Function.main(Statement.print(Expression.ofString('Hello World.'))));
}
```

Outputs:
```dart
main() {
  print('Hello World.');
}
```

Use the CodeFormatter class for alternative formatting.
It uses the official (dartfmt)[https://github.com/dart-lang/dart_style/wiki/Formatting-Rules] with the dart_style package
You can use the following CodeFormatter constructor parameters:
- String lineEnding
- int pageWidth
- int indent

Note that this formatter may throw parsing exceptions.
You can use the [CodeFormatter.unFormatted] method when you need a code partial that can not be parsed by the Dart formatter

Alternative formatting example:
```dart
import 'package:dart_code/dart_code.dart';

main() {
  print(CodeFormatter(pageWidth: 20).format(
      Function.main(Statement.print(Expression.ofString('Hello World.')))));
}
```

Outputs:
```dart
main() {
  print(
      'Hello World.');
}
```

An example of a library with unique imports:
```dart
import 'package:dart_code/dart_code.dart';

main() {
   print(Library(classes: [
     Class(
       'Employee',
       superClass: Type('Person', libraryUri: 'package:my_package/person.dart'),
       implements: [
         Type('Skills', libraryUri: 'package:my_package/skills.dart')
       ],
       abstract: true,
     )
   ]));
}
```

Outputs:
```dart
import 'package:my_package/person.dart' as _i1;
import 'package:my_package/skills.dart' as _i2;

abstract class Employee extends _i1.Person implements _i2.Skills {}
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
- Code (for anything else)

## Inspiration
This package was inspired by the code_builder package.
- dart_code is simpler and likely less complete
- dart_code classes can extended (no fluent builders used) so that code model logic can be writien inside the constructor of the extended classes.
- dart_code allows you to directly use the toString() method on the code classes or use the CodeFormatter class for alternative formatting settings.