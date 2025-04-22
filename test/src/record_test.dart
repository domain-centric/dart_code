import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:dart_code/dart_code.dart';

void main() {
  group('Record Tests', () {
    var dummyContext = Context(Code('Dummy'));
    test('should create a non-nullable record with fields', () {
      final record = Record([
        RecordField(Type.ofInt()),
        RecordField.named(Type.ofString(), 'name'),
      ]);

      record.fields.length.should.be(2);
      record.nullable.should.beFalse();
      record.fields[0].type.name.should.be('int');
      record.fields[0].name.should.beNull();
      record.fields[1].type.name.should.be('String');
      record.fields[1].name!
          .toUnFormattedString(dummyContext)
          .should
          .be('name');
      CodeFormatter().unFormatted(record).should.be('(int,{String name})');
    });
    test('should create a nullable record with nullable fields', () {
      final record = Record([
        RecordField(Type.ofInt(nullable: true)),
        RecordField.named(Type.ofString(nullable: true), 'name'),
      ], nullable: true);

      record.fields.length.should.be(2);
      record.nullable.should.beTrue();
      record.fields[0].type.name.should.be('int');
      record.fields[0].name.should.beNull();
      record.fields[1].type.name.should.be('String');
      record.fields[1].name!
          .toUnFormattedString(Context(Code('Dummy')))
          .should
          .be('name');
      CodeFormatter().unFormatted(record).should.be('(int?,{String? name})?');
    });
  });

  group('RecordField Tests', () {
    var dummyContext = Context(Code('Dummy'));

    test('should create an unnamed RecordField', () {
      final field = RecordField(Type.ofInt());

      field.type.name.should.be('int');
      field.name.should.beNull();
      CodeFormatter().unFormatted(field).should.be('int');
    });

    test('should create a named RecordField', () {
      final field = RecordField.named(Type.ofString(), 'name');

      field.type.name.should.be('String');
      field.name!.toUnFormattedString(dummyContext).should.be('name');
      CodeFormatter().unFormatted(field).should.be('String name');
    });

    test('should handle nullable types in RecordField', () {
      final field = RecordField(Type.ofInt(nullable: true));

      field.type.name.should.be('int');
      field.name.should.beNull();
      CodeFormatter().unFormatted(field).should.be('int?');
    });

    test('should handle named RecordField with nullable type', () {
      final field = RecordField.named(Type.ofString(nullable: true), 'name');

      field.type.name.should.be('String');
      field.name!.toUnFormattedString(dummyContext).should.be('name');
      CodeFormatter().unFormatted(field).should.be('String? name');
    });
  });

  group('RecordFieldValue Tests', () {
    var dummyContext = Context(Code('Dummy'));

    test('should create an unnamed RecordFieldValue', () {
      final fieldValue = RecordFieldValue(Expression.ofInt(42));

      fieldValue.value.toUnFormattedString(dummyContext).should.be('42');
      fieldValue.name.should.beNull();
      CodeFormatter().unFormatted(fieldValue).should.be('42');
    });

    test('should create a named RecordFieldValue', () {
      final fieldValue = RecordFieldValue.named('age', Expression.ofInt(42));

      fieldValue.value.toUnFormattedString(dummyContext).should.be('42');
      fieldValue.name!.toUnFormattedString(dummyContext).should.be('age');
      CodeFormatter().unFormatted(fieldValue).should.be('age: 42');
    });

    test('should handle nullable values in RecordFieldValue', () {
      final fieldValue = RecordFieldValue(Expression.ofNull());

      fieldValue.value.toUnFormattedString(dummyContext).should.be('null');
      fieldValue.name.should.beNull();
      CodeFormatter().unFormatted(fieldValue).should.be('null');
    });

    test('should handle named RecordFieldValue with nullable value', () {
      final fieldValue =
          RecordFieldValue.named('name', Expression.ofString('null'));

      fieldValue.value.toUnFormattedString(dummyContext).should.be("'null'");
      fieldValue.name!.toUnFormattedString(dummyContext).should.be('name');
      CodeFormatter().unFormatted(fieldValue).should.be("name: 'null'");
    });
  });
}
