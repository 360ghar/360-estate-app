// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_payment_intent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantPaymentIntentImpl _$$TenantPaymentIntentImplFromJson(
  Map<String, dynamic> json,
) => _$TenantPaymentIntentImpl(
  paymentUrl: json['payment_url'] as String?,
  paymentInstructions: json['payment_instructions'] as String?,
  provider: json['provider'] as String?,
  reference: parseString(json['reference']),
  payload: json['payload'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$TenantPaymentIntentImplToJson(
  _$TenantPaymentIntentImpl instance,
) => <String, dynamic>{
  'payment_url': instance.paymentUrl,
  'payment_instructions': instance.paymentInstructions,
  'provider': instance.provider,
  'reference': instance.reference,
  'payload': instance.payload,
};
