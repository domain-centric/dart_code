// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:dart_code/dart_code.dart';

void main() {
  group('Record Class', () {
    test('should create a non-nullable record with fields', () {
      final record = Record([
        RecordField(Type.ofInt()),
        RecordField.named(Type.ofString(), 'name'),
      ]);
      Should.satisfyAllConditions([
        () => record.fields.length.should.be(2),
        () => record.nullable.should.beFalse(),
        () => record.fields[0].type.name.should.be('int'),
        () => record.fields[0].name.should.beNull(),
        () => record.fields[1].type.name.should.be('String'),
        () => record.fields[1].name!.toString().should.be('name'),
        () => record.toString().should.be('(int,{String name})'),
      ]);
    });
    test('should create a nullable record with nullable fields', () {
      final record = Record([
        RecordField(Type.ofInt(nullable: true)),
        RecordField.named(Type.ofString(nullable: true), 'name'),
      ], nullable: true);

      Should.satisfyAllConditions([
        () => record.fields.length.should.be(2),
        () => record.nullable.should.beTrue(),
        () => record.fields[0].type.name.should.be('int'),
        () => record.fields[0].name.should.beNull(),
        () => record.fields[1].type.name.should.be('String'),
        () => record.fields[1].name!.toString().should.be('name'),
        () => record.toString().should.be('(int?,{String? name})?'),
      ]);
    });
  });

  group('RecordField Class', () {
    test('should create an unnamed RecordField', () {
      final field = RecordField(Type.ofInt());

      Should.satisfyAllConditions([
        () => field.type.name.should.be('int'),
        () => field.name.should.beNull(),
        () => field.toString().should.be('int'),
      ]);
    });

    test('should create a named RecordField', () {
      final field = RecordField.named(Type.ofString(), 'name');

      Should.satisfyAllConditions([
        () => field.type.name.should.be('String'),
        () => field.name!.toString().should.be('name'),
        () => field.toString().should.be('String name'),
      ]);
    });

    test('should handle nullable types in RecordField', () {
      final field = RecordField(Type.ofInt(nullable: true));

      Should.satisfyAllConditions([
        () => field.type.name.should.be('int'),
        () => field.name.should.beNull(),
        () => field.toString().should.be('int?'),
      ]);
    });

    test('should handle named RecordField with nullable type', () {
      final field = RecordField.named(Type.ofString(nullable: true), 'name');

      Should.satisfyAllConditions([
        () => field.type.name.should.be('String'),
        () => field.name!.toString().should.be('name'),
        () => field.toString().should.be('String? name'),
      ]);
    });
  });

  group('RecordFieldValue Tests', () {
    test('should create an unnamed RecordFieldValue', () {
      final fieldValue = RecordFieldValue(Expression.ofInt(42));

      Should.satisfyAllConditions([
        () => fieldValue.value.toString().should.be('42'),
        () => fieldValue.name.should.beNull(),
        () => fieldValue.toString().should.be('42'),
      ]);
    });

    test('should create a named RecordFieldValue', () {
      final fieldValue = RecordFieldValue.named('age', Expression.ofInt(42));

      Should.satisfyAllConditions([
        () => fieldValue.value.toString().should.be('42'),
        () => fieldValue.name!.toString().should.be('age'),
        () => fieldValue.toString().should.be('age: 42'),
      ]);
    });

    test('should handle nullable values in RecordFieldValue', () {
      final fieldValue = RecordFieldValue(Expression.ofNull());

      Should.satisfyAllConditions([
        () => fieldValue.value.toString().should.be('null'),
        () => fieldValue.name.should.beNull(),
        () => fieldValue.toString().should.be('null'),
      ]);
    });

    test('should handle named RecordFieldValue with nullable value', () {
      final fieldValue = RecordFieldValue.named(
        'name',
        Expression.ofString('null'),
      );

      Should.satisfyAllConditions([
        () => fieldValue.value.toString().should.be("'null'"),
        () => fieldValue.name!.toString().should.be('name'),
        () => fieldValue.toString().should.be("name: 'null'"),
      ]);
    });
  });
}
