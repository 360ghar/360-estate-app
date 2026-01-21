// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant_payment_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TenantPaymentIntent _$TenantPaymentIntentFromJson(Map<String, dynamic> json) {
  return _TenantPaymentIntent.fromJson(json);
}

/// @nodoc
mixin _$TenantPaymentIntent {
  @JsonKey(name: 'payment_url')
  String? get paymentUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_instructions')
  String? get paymentInstructions => throw _privateConstructorUsedError;
  String? get provider => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseString)
  String? get reference => throw _privateConstructorUsedError;
  Map<String, dynamic>? get payload => throw _privateConstructorUsedError;

  /// Serializes this TenantPaymentIntent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TenantPaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantPaymentIntentCopyWith<TenantPaymentIntent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantPaymentIntentCopyWith<$Res> {
  factory $TenantPaymentIntentCopyWith(
    TenantPaymentIntent value,
    $Res Function(TenantPaymentIntent) then,
  ) = _$TenantPaymentIntentCopyWithImpl<$Res, TenantPaymentIntent>;
  @useResult
  $Res call({
    @JsonKey(name: 'payment_url') String? paymentUrl,
    @JsonKey(name: 'payment_instructions') String? paymentInstructions,
    String? provider,
    @JsonKey(fromJson: parseString) String? reference,
    Map<String, dynamic>? payload,
  });
}

/// @nodoc
class _$TenantPaymentIntentCopyWithImpl<$Res, $Val extends TenantPaymentIntent>
    implements $TenantPaymentIntentCopyWith<$Res> {
  _$TenantPaymentIntentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TenantPaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentUrl = freezed,
    Object? paymentInstructions = freezed,
    Object? provider = freezed,
    Object? reference = freezed,
    Object? payload = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentUrl: freezed == paymentUrl
                ? _value.paymentUrl
                : paymentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentInstructions: freezed == paymentInstructions
                ? _value.paymentInstructions
                : paymentInstructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            provider: freezed == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as String?,
            reference: freezed == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String?,
            payload: freezed == payload
                ? _value.payload
                : payload // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TenantPaymentIntentImplCopyWith<$Res>
    implements $TenantPaymentIntentCopyWith<$Res> {
  factory _$$TenantPaymentIntentImplCopyWith(
    _$TenantPaymentIntentImpl value,
    $Res Function(_$TenantPaymentIntentImpl) then,
  ) = __$$TenantPaymentIntentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'payment_url') String? paymentUrl,
    @JsonKey(name: 'payment_instructions') String? paymentInstructions,
    String? provider,
    @JsonKey(fromJson: parseString) String? reference,
    Map<String, dynamic>? payload,
  });
}

/// @nodoc
class __$$TenantPaymentIntentImplCopyWithImpl<$Res>
    extends _$TenantPaymentIntentCopyWithImpl<$Res, _$TenantPaymentIntentImpl>
    implements _$$TenantPaymentIntentImplCopyWith<$Res> {
  __$$TenantPaymentIntentImplCopyWithImpl(
    _$TenantPaymentIntentImpl _value,
    $Res Function(_$TenantPaymentIntentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TenantPaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentUrl = freezed,
    Object? paymentInstructions = freezed,
    Object? provider = freezed,
    Object? reference = freezed,
    Object? payload = freezed,
  }) {
    return _then(
      _$TenantPaymentIntentImpl(
        paymentUrl: freezed == paymentUrl
            ? _value.paymentUrl
            : paymentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentInstructions: freezed == paymentInstructions
            ? _value.paymentInstructions
            : paymentInstructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        provider: freezed == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String?,
        reference: freezed == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String?,
        payload: freezed == payload
            ? _value._payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantPaymentIntentImpl implements _TenantPaymentIntent {
  const _$TenantPaymentIntentImpl({
    @JsonKey(name: 'payment_url') this.paymentUrl,
    @JsonKey(name: 'payment_instructions') this.paymentInstructions,
    this.provider,
    @JsonKey(fromJson: parseString) this.reference,
    final Map<String, dynamic>? payload,
  }) : _payload = payload;

  factory _$TenantPaymentIntentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantPaymentIntentImplFromJson(json);

  @override
  @JsonKey(name: 'payment_url')
  final String? paymentUrl;
  @override
  @JsonKey(name: 'payment_instructions')
  final String? paymentInstructions;
  @override
  final String? provider;
  @override
  @JsonKey(fromJson: parseString)
  final String? reference;
  final Map<String, dynamic>? _payload;
  @override
  Map<String, dynamic>? get payload {
    final value = _payload;
    if (value == null) return null;
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TenantPaymentIntent(paymentUrl: $paymentUrl, paymentInstructions: $paymentInstructions, provider: $provider, reference: $reference, payload: $payload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantPaymentIntentImpl &&
            (identical(other.paymentUrl, paymentUrl) ||
                other.paymentUrl == paymentUrl) &&
            (identical(other.paymentInstructions, paymentInstructions) ||
                other.paymentInstructions == paymentInstructions) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            const DeepCollectionEquality().equals(other._payload, _payload));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    paymentUrl,
    paymentInstructions,
    provider,
    reference,
    const DeepCollectionEquality().hash(_payload),
  );

  /// Create a copy of TenantPaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantPaymentIntentImplCopyWith<_$TenantPaymentIntentImpl> get copyWith =>
      __$$TenantPaymentIntentImplCopyWithImpl<_$TenantPaymentIntentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantPaymentIntentImplToJson(this);
  }
}

abstract class _TenantPaymentIntent implements TenantPaymentIntent {
  const factory _TenantPaymentIntent({
    @JsonKey(name: 'payment_url') final String? paymentUrl,
    @JsonKey(name: 'payment_instructions') final String? paymentInstructions,
    final String? provider,
    @JsonKey(fromJson: parseString) final String? reference,
    final Map<String, dynamic>? payload,
  }) = _$TenantPaymentIntentImpl;

  factory _TenantPaymentIntent.fromJson(Map<String, dynamic> json) =
      _$TenantPaymentIntentImpl.fromJson;

  @override
  @JsonKey(name: 'payment_url')
  String? get paymentUrl;
  @override
  @JsonKey(name: 'payment_instructions')
  String? get paymentInstructions;
  @override
  String? get provider;
  @override
  @JsonKey(fromJson: parseString)
  String? get reference;
  @override
  Map<String, dynamic>? get payload;

  /// Create a copy of TenantPaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantPaymentIntentImplCopyWith<_$TenantPaymentIntentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
