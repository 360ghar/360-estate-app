import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_payment_intent.freezed.dart';
part 'tenant_payment_intent.g.dart';

@freezed
class TenantPaymentIntent with _$TenantPaymentIntent {
  const factory TenantPaymentIntent({
    @JsonKey(name: 'payment_url') String? paymentUrl,
    @JsonKey(name: 'payment_instructions') String? paymentInstructions,
    String? provider,
    @JsonKey(fromJson: parseString) String? reference,
    Map<String, dynamic>? payload,
  }) = _TenantPaymentIntent;

  factory TenantPaymentIntent.fromJson(Map<String, dynamic> json) =>
      _$TenantPaymentIntentFromJson(json);
}
