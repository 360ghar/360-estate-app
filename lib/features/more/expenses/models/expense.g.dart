// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      id: parseInt(json['id']),
      title: json['title'] as String?,
      amount: parseDouble(json['amount']),
      date: parseDateTime(json['expense_date']),
      category: json['category'] as String?,
      notes: json['notes'] as String?,
      propertyName: json['property_name'] as String?,
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'expense_date': instance.date?.toIso8601String(),
      'category': instance.category,
      'notes': instance.notes,
      'property_name': instance.propertyName,
    };
