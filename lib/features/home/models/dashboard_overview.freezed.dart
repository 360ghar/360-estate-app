// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardOverview _$DashboardOverviewFromJson(Map<String, dynamic> json) {
  return _DashboardOverview.fromJson(json);
}

/// @nodoc
mixin _$DashboardOverview {
  @JsonKey(name: 'properties', fromJson: parseInt)
  int? get propertiesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenants', fromJson: parseInt)
  int? get tenantsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'charges_due', fromJson: parseInt)
  int? get chargesDue => throw _privateConstructorUsedError;
  @JsonKey(name: 'charges_overdue', fromJson: parseInt)
  int? get chargesOverdue => throw _privateConstructorUsedError;
  @JsonKey(name: 'maintenance_open', fromJson: parseInt)
  int? get maintenanceOpen => throw _privateConstructorUsedError;
  @JsonKey(name: 'rent_collected', fromJson: parseDouble)
  double? get rentCollected => throw _privateConstructorUsedError;
  @JsonKey(name: 'occupancy_rate', fromJson: parseDouble)
  double? get occupancyRate => throw _privateConstructorUsedError;

  /// Serializes this DashboardOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardOverviewCopyWith<DashboardOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardOverviewCopyWith<$Res> {
  factory $DashboardOverviewCopyWith(
    DashboardOverview value,
    $Res Function(DashboardOverview) then,
  ) = _$DashboardOverviewCopyWithImpl<$Res, DashboardOverview>;
  @useResult
  $Res call({
    @JsonKey(name: 'properties', fromJson: parseInt) int? propertiesCount,
    @JsonKey(name: 'tenants', fromJson: parseInt) int? tenantsCount,
    @JsonKey(name: 'charges_due', fromJson: parseInt) int? chargesDue,
    @JsonKey(name: 'charges_overdue', fromJson: parseInt) int? chargesOverdue,
    @JsonKey(name: 'maintenance_open', fromJson: parseInt) int? maintenanceOpen,
    @JsonKey(name: 'rent_collected', fromJson: parseDouble)
    double? rentCollected,
    @JsonKey(name: 'occupancy_rate', fromJson: parseDouble)
    double? occupancyRate,
  });
}

/// @nodoc
class _$DashboardOverviewCopyWithImpl<$Res, $Val extends DashboardOverview>
    implements $DashboardOverviewCopyWith<$Res> {
  _$DashboardOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertiesCount = freezed,
    Object? tenantsCount = freezed,
    Object? chargesDue = freezed,
    Object? chargesOverdue = freezed,
    Object? maintenanceOpen = freezed,
    Object? rentCollected = freezed,
    Object? occupancyRate = freezed,
  }) {
    return _then(
      _value.copyWith(
            propertiesCount: freezed == propertiesCount
                ? _value.propertiesCount
                : propertiesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            tenantsCount: freezed == tenantsCount
                ? _value.tenantsCount
                : tenantsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            chargesDue: freezed == chargesDue
                ? _value.chargesDue
                : chargesDue // ignore: cast_nullable_to_non_nullable
                      as int?,
            chargesOverdue: freezed == chargesOverdue
                ? _value.chargesOverdue
                : chargesOverdue // ignore: cast_nullable_to_non_nullable
                      as int?,
            maintenanceOpen: freezed == maintenanceOpen
                ? _value.maintenanceOpen
                : maintenanceOpen // ignore: cast_nullable_to_non_nullable
                      as int?,
            rentCollected: freezed == rentCollected
                ? _value.rentCollected
                : rentCollected // ignore: cast_nullable_to_non_nullable
                      as double?,
            occupancyRate: freezed == occupancyRate
                ? _value.occupancyRate
                : occupancyRate // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardOverviewImplCopyWith<$Res>
    implements $DashboardOverviewCopyWith<$Res> {
  factory _$$DashboardOverviewImplCopyWith(
    _$DashboardOverviewImpl value,
    $Res Function(_$DashboardOverviewImpl) then,
  ) = __$$DashboardOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'properties', fromJson: parseInt) int? propertiesCount,
    @JsonKey(name: 'tenants', fromJson: parseInt) int? tenantsCount,
    @JsonKey(name: 'charges_due', fromJson: parseInt) int? chargesDue,
    @JsonKey(name: 'charges_overdue', fromJson: parseInt) int? chargesOverdue,
    @JsonKey(name: 'maintenance_open', fromJson: parseInt) int? maintenanceOpen,
    @JsonKey(name: 'rent_collected', fromJson: parseDouble)
    double? rentCollected,
    @JsonKey(name: 'occupancy_rate', fromJson: parseDouble)
    double? occupancyRate,
  });
}

/// @nodoc
class __$$DashboardOverviewImplCopyWithImpl<$Res>
    extends _$DashboardOverviewCopyWithImpl<$Res, _$DashboardOverviewImpl>
    implements _$$DashboardOverviewImplCopyWith<$Res> {
  __$$DashboardOverviewImplCopyWithImpl(
    _$DashboardOverviewImpl _value,
    $Res Function(_$DashboardOverviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertiesCount = freezed,
    Object? tenantsCount = freezed,
    Object? chargesDue = freezed,
    Object? chargesOverdue = freezed,
    Object? maintenanceOpen = freezed,
    Object? rentCollected = freezed,
    Object? occupancyRate = freezed,
  }) {
    return _then(
      _$DashboardOverviewImpl(
        propertiesCount: freezed == propertiesCount
            ? _value.propertiesCount
            : propertiesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        tenantsCount: freezed == tenantsCount
            ? _value.tenantsCount
            : tenantsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        chargesDue: freezed == chargesDue
            ? _value.chargesDue
            : chargesDue // ignore: cast_nullable_to_non_nullable
                  as int?,
        chargesOverdue: freezed == chargesOverdue
            ? _value.chargesOverdue
            : chargesOverdue // ignore: cast_nullable_to_non_nullable
                  as int?,
        maintenanceOpen: freezed == maintenanceOpen
            ? _value.maintenanceOpen
            : maintenanceOpen // ignore: cast_nullable_to_non_nullable
                  as int?,
        rentCollected: freezed == rentCollected
            ? _value.rentCollected
            : rentCollected // ignore: cast_nullable_to_non_nullable
                  as double?,
        occupancyRate: freezed == occupancyRate
            ? _value.occupancyRate
            : occupancyRate // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardOverviewImpl implements _DashboardOverview {
  const _$DashboardOverviewImpl({
    @JsonKey(name: 'properties', fromJson: parseInt) this.propertiesCount,
    @JsonKey(name: 'tenants', fromJson: parseInt) this.tenantsCount,
    @JsonKey(name: 'charges_due', fromJson: parseInt) this.chargesDue,
    @JsonKey(name: 'charges_overdue', fromJson: parseInt) this.chargesOverdue,
    @JsonKey(name: 'maintenance_open', fromJson: parseInt) this.maintenanceOpen,
    @JsonKey(name: 'rent_collected', fromJson: parseDouble) this.rentCollected,
    @JsonKey(name: 'occupancy_rate', fromJson: parseDouble) this.occupancyRate,
  });

  factory _$DashboardOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardOverviewImplFromJson(json);

  @override
  @JsonKey(name: 'properties', fromJson: parseInt)
  final int? propertiesCount;
  @override
  @JsonKey(name: 'tenants', fromJson: parseInt)
  final int? tenantsCount;
  @override
  @JsonKey(name: 'charges_due', fromJson: parseInt)
  final int? chargesDue;
  @override
  @JsonKey(name: 'charges_overdue', fromJson: parseInt)
  final int? chargesOverdue;
  @override
  @JsonKey(name: 'maintenance_open', fromJson: parseInt)
  final int? maintenanceOpen;
  @override
  @JsonKey(name: 'rent_collected', fromJson: parseDouble)
  final double? rentCollected;
  @override
  @JsonKey(name: 'occupancy_rate', fromJson: parseDouble)
  final double? occupancyRate;

  @override
  String toString() {
    return 'DashboardOverview(propertiesCount: $propertiesCount, tenantsCount: $tenantsCount, chargesDue: $chargesDue, chargesOverdue: $chargesOverdue, maintenanceOpen: $maintenanceOpen, rentCollected: $rentCollected, occupancyRate: $occupancyRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardOverviewImpl &&
            (identical(other.propertiesCount, propertiesCount) ||
                other.propertiesCount == propertiesCount) &&
            (identical(other.tenantsCount, tenantsCount) ||
                other.tenantsCount == tenantsCount) &&
            (identical(other.chargesDue, chargesDue) ||
                other.chargesDue == chargesDue) &&
            (identical(other.chargesOverdue, chargesOverdue) ||
                other.chargesOverdue == chargesOverdue) &&
            (identical(other.maintenanceOpen, maintenanceOpen) ||
                other.maintenanceOpen == maintenanceOpen) &&
            (identical(other.rentCollected, rentCollected) ||
                other.rentCollected == rentCollected) &&
            (identical(other.occupancyRate, occupancyRate) ||
                other.occupancyRate == occupancyRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    propertiesCount,
    tenantsCount,
    chargesDue,
    chargesOverdue,
    maintenanceOpen,
    rentCollected,
    occupancyRate,
  );

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardOverviewImplCopyWith<_$DashboardOverviewImpl> get copyWith =>
      __$$DashboardOverviewImplCopyWithImpl<_$DashboardOverviewImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardOverviewImplToJson(this);
  }
}

abstract class _DashboardOverview implements DashboardOverview {
  const factory _DashboardOverview({
    @JsonKey(name: 'properties', fromJson: parseInt) final int? propertiesCount,
    @JsonKey(name: 'tenants', fromJson: parseInt) final int? tenantsCount,
    @JsonKey(name: 'charges_due', fromJson: parseInt) final int? chargesDue,
    @JsonKey(name: 'charges_overdue', fromJson: parseInt)
    final int? chargesOverdue,
    @JsonKey(name: 'maintenance_open', fromJson: parseInt)
    final int? maintenanceOpen,
    @JsonKey(name: 'rent_collected', fromJson: parseDouble)
    final double? rentCollected,
    @JsonKey(name: 'occupancy_rate', fromJson: parseDouble)
    final double? occupancyRate,
  }) = _$DashboardOverviewImpl;

  factory _DashboardOverview.fromJson(Map<String, dynamic> json) =
      _$DashboardOverviewImpl.fromJson;

  @override
  @JsonKey(name: 'properties', fromJson: parseInt)
  int? get propertiesCount;
  @override
  @JsonKey(name: 'tenants', fromJson: parseInt)
  int? get tenantsCount;
  @override
  @JsonKey(name: 'charges_due', fromJson: parseInt)
  int? get chargesDue;
  @override
  @JsonKey(name: 'charges_overdue', fromJson: parseInt)
  int? get chargesOverdue;
  @override
  @JsonKey(name: 'maintenance_open', fromJson: parseInt)
  int? get maintenanceOpen;
  @override
  @JsonKey(name: 'rent_collected', fromJson: parseDouble)
  double? get rentCollected;
  @override
  @JsonKey(name: 'occupancy_rate', fromJson: parseDouble)
  double? get occupancyRate;

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardOverviewImplCopyWith<_$DashboardOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
