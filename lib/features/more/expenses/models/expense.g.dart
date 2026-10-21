// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      id: parseInt(json['id']),
      propertyId: parseInt(json['property_id']),
      propertyName: json['property_name'] as String?,
      ownerId: parseInt(json['owner_id']),
      category: ExpenseCategory.fromJson(json['category']),
      title: json['title'] as String?,
      amount: parseDouble(json['amount']),
      date: parseDateTime(json['expense_date']),
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      receiptDocumentId: parseInt(json['receipt_document_id']),
      createdAt: parseDateTime(json['created_at']),
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'owner_id': instance.ownerId,
      'category': ExpenseCategory.toJsonValue(instance.category),
      'title': instance.title,
      'amount': instance.amount,
      'expense_date': instance.date?.toIso8601String(),
      'description': instance.description,
      'notes': instance.notes,
      'receipt_document_id': instance.receiptDocumentId,
      'created_at': instance.createdAt?.toIso8601String(),
    };
