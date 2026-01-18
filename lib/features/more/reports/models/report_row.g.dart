// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportRowImpl _$$ReportRowImplFromJson(Map<String, dynamic> json) =>
    _$ReportRowImpl(
      label: json['label'] as String?,
      amount: parseDouble(json['amount']),
      value: json['value'] as String?,
    );

Map<String, dynamic> _$$ReportRowImplToJson(_$ReportRowImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amount': instance.amount,
      'value': instance.value,
    };
