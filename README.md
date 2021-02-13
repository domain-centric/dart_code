# dart_code

A package for creating valid and formatted code, e.g. when creating builders.

## Usage

TODO  main print 'Hello World' example

TODO Library with import example

TODO alternative formatting example

Most important classes to use:
- Library
  - Function
  - Class
    - Field
    - PropertyAccessor
    - Constructor
    - Method
- Expressions (for code that results in a value)
- Statement (for code that does something)
- Comment
- DocComment


## Inspiration

This package was inspired by the code_builder package.
- dart_code is simpler and likely less complete
- dart_code classed can extended (no fluent builders used) so that build logic can be included in extended classes.
- dart_code allows you to directly use the toString method on the code classes or use the CodeFormatter class for alternative formatting settings.