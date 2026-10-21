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
  @JsonKey(name: 'total_properties', fromJson: parseInt)
  int? get totalProperties => throw _privateConstructorUsedError;
  @JsonKey(name: 'occupied_properties', fromJson: parseInt)
  int? get occupiedProperties => throw _privateConstructorUsedError;
  @JsonKey(name: 'vacant_properties', fromJson: parseInt)
  int? get vacantProperties => throw _privateConstructorUsedError;
  @JsonKey(name: 'under_maintenance_properties', fromJson: parseInt)
  int? get underMaintenanceProperties => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_revenue_current', fromJson: parseDouble)
  double? get monthlyRevenueCurrent => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_revenue_previous', fromJson: parseDouble)
  double? get monthlyRevenuePrevious => throw _privateConstructorUsedError;
  @JsonKey(name: 'outstanding_rent_total', fromJson: parseDouble)
  double? get outstandingRentTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'upcoming_expenses_total', fromJson: parseDouble)
  double? get upcomingExpensesTotal => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'total_properties', fromJson: parseInt) int? totalProperties,
    @JsonKey(name: 'occupied_properties', fromJson: parseInt)
    int? occupiedProperties,
    @JsonKey(name: 'vacant_properties', fromJson: parseInt)
    int? vacantProperties,
    @JsonKey(name: 'under_maintenance_properties', fromJson: parseInt)
    int? underMaintenanceProperties,
    @JsonKey(name: 'monthly_revenue_current', fromJson: parseDouble)
    double? monthlyRevenueCurrent,
    @JsonKey(name: 'monthly_revenue_previous', fromJson: parseDouble)
    double? monthlyRevenuePrevious,
    @JsonKey(name: 'outstanding_rent_total', fromJson: parseDouble)
    double? outstandingRentTotal,
    @JsonKey(name: 'upcoming_expenses_total', fromJson: parseDouble)
    double? upcomingExpensesTotal,
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
    Object? totalProperties = freezed,
    Object? occupiedProperties = freezed,
    Object? vacantProperties = freezed,
    Object? underMaintenanceProperties = freezed,
    Object? monthlyRevenueCurrent = freezed,
    Object? monthlyRevenuePrevious = freezed,
    Object? outstandingRentTotal = freezed,
    Object? upcomingExpensesTotal = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalProperties: freezed == totalProperties
                ? _value.totalProperties
                : totalProperties // ignore: cast_nullable_to_non_nullable
                      as int?,
            occupiedProperties: freezed == occupiedProperties
                ? _value.occupiedProperties
                : occupiedProperties // ignore: cast_nullable_to_non_nullable
                      as int?,
            vacantProperties: freezed == vacantProperties
                ? _value.vacantProperties
                : vacantProperties // ignore: cast_nullable_to_non_nullable
                      as int?,
            underMaintenanceProperties: freezed == underMaintenanceProperties
                ? _value.underMaintenanceProperties
                : underMaintenanceProperties // ignore: cast_nullable_to_non_nullable
                      as int?,
            monthlyRevenueCurrent: freezed == monthlyRevenueCurrent
                ? _value.monthlyRevenueCurrent
                : monthlyRevenueCurrent // ignore: cast_nullable_to_non_nullable
                      as double?,
            monthlyRevenuePrevious: freezed == monthlyRevenuePrevious
                ? _value.monthlyRevenuePrevious
                : monthlyRevenuePrevious // ignore: cast_nullable_to_non_nullable
                      as double?,
            outstandingRentTotal: freezed == outstandingRentTotal
                ? _value.outstandingRentTotal
                : outstandingRentTotal // ignore: cast_nullable_to_non_nullable
                      as double?,
            upcomingExpensesTotal: freezed == upcomingExpensesTotal
                ? _value.upcomingExpensesTotal
                : upcomingExpensesTotal // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(name: 'total_properties', fromJson: parseInt) int? totalProperties,
    @JsonKey(name: 'occupied_properties', fromJson: parseInt)
    int? occupiedProperties,
    @JsonKey(name: 'vacant_properties', fromJson: parseInt)
    int? vacantProperties,
    @JsonKey(name: 'under_maintenance_properties', fromJson: parseInt)
    int? underMaintenanceProperties,
    @JsonKey(name: 'monthly_revenue_current', fromJson: parseDouble)
    double? monthlyRevenueCurrent,
    @JsonKey(name: 'monthly_revenue_previous', fromJson: parseDouble)
    double? monthlyRevenuePrevious,
    @JsonKey(name: 'outstanding_rent_total', fromJson: parseDouble)
    double? outstandingRentTotal,
    @JsonKey(name: 'upcoming_expenses_total', fromJson: parseDouble)
    double? upcomingExpensesTotal,
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
    Object? totalProperties = freezed,
    Object? occupiedProperties = freezed,
    Object? vacantProperties = freezed,
    Object? underMaintenanceProperties = freezed,
    Object? monthlyRevenueCurrent = freezed,
    Object? monthlyRevenuePrevious = freezed,
    Object? outstandingRentTotal = freezed,
    Object? upcomingExpensesTotal = freezed,
  }) {
    return _then(
      _$DashboardOverviewImpl(
        totalProperties: freezed == totalProperties
            ? _value.totalProperties
            : totalProperties // ignore: cast_nullable_to_non_nullable
                  as int?,
        occupiedProperties: freezed == occupiedProperties
            ? _value.occupiedProperties
            : occupiedProperties // ignore: cast_nullable_to_non_nullable
                  as int?,
        vacantProperties: freezed == vacantProperties
            ? _value.vacantProperties
            : vacantProperties // ignore: cast_nullable_to_non_nullable
                  as int?,
        underMaintenanceProperties: freezed == underMaintenanceProperties
            ? _value.underMaintenanceProperties
            : underMaintenanceProperties // ignore: cast_nullable_to_non_nullable
                  as int?,
        monthlyRevenueCurrent: freezed == monthlyRevenueCurrent
            ? _value.monthlyRevenueCurrent
            : monthlyRevenueCurrent // ignore: cast_nullable_to_non_nullable
                  as double?,
        monthlyRevenuePrevious: freezed == monthlyRevenuePrevious
            ? _value.monthlyRevenuePrevious
            : monthlyRevenuePrevious // ignore: cast_nullable_to_non_nullable
                  as double?,
        outstandingRentTotal: freezed == outstandingRentTotal
            ? _value.outstandingRentTotal
            : outstandingRentTotal // ignore: cast_nullable_to_non_nullable
                  as double?,
        upcomingExpensesTotal: freezed == upcomingExpensesTotal
            ? _value.upcomingExpensesTotal
            : upcomingExpensesTotal // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardOverviewImpl implements _DashboardOverview {
  const _$DashboardOverviewImpl({
    @JsonKey(name: 'total_properties', fromJson: parseInt) this.totalProperties,
    @JsonKey(name: 'occupied_properties', fromJson: parseInt)
    this.occupiedProperties,
    @JsonKey(name: 'vacant_properties', fromJson: parseInt)
    this.vacantProperties,
    @JsonKey(name: 'under_maintenance_properties', fromJson: parseInt)
    this.underMaintenanceProperties,
    @JsonKey(name: 'monthly_revenue_current', fromJson: parseDouble)
    this.monthlyRevenueCurrent,
    @JsonKey(name: 'monthly_revenue_previous', fromJson: parseDouble)
    this.monthlyRevenuePrevious,
    @JsonKey(name: 'outstanding_rent_total', fromJson: parseDouble)
    this.outstandingRentTotal,
    @JsonKey(name: 'upcoming_expenses_total', fromJson: parseDouble)
    this.upcomingExpensesTotal,
  });

  factory _$DashboardOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardOverviewImplFromJson(json);

  @override
  @JsonKey(name: 'total_properties', fromJson: parseInt)
  final int? totalProperties;
  @override
  @JsonKey(name: 'occupied_properties', fromJson: parseInt)
  final int? occupiedProperties;
  @override
  @JsonKey(name: 'vacant_properties', fromJson: parseInt)
  final int? vacantProperties;
  @override
  @JsonKey(name: 'under_maintenance_properties', fromJson: parseInt)
  final int? underMaintenanceProperties;
  @override
  @JsonKey(name: 'monthly_revenue_current', fromJson: parseDouble)
  final double? monthlyRevenueCurrent;
  @override
  @JsonKey(name: 'monthly_revenue_previous', fromJson: parseDouble)
  final double? monthlyRevenuePrevious;
  @override
  @JsonKey(name: 'outstanding_rent_total', fromJson: parseDouble)
  final double? outstandingRentTotal;
  @override
  @JsonKey(name: 'upcoming_expenses_total', fromJson: parseDouble)
  final double? upcomingExpensesTotal;

  @override
  String toString() {
    return 'DashboardOverview(totalProperties: $totalProperties, occupiedProperties: $occupiedProperties, vacantProperties: $vacantProperties, underMaintenanceProperties: $underMaintenanceProperties, monthlyRevenueCurrent: $monthlyRevenueCurrent, monthlyRevenuePrevious: $monthlyRevenuePrevious, outstandingRentTotal: $outstandingRentTotal, upcomingExpensesTotal: $upcomingExpensesTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardOverviewImpl &&
            (identical(other.totalProperties, totalProperties) ||
                other.totalProperties == totalProperties) &&
            (identical(other.occupiedProperties, occupiedProperties) ||
                other.occupiedProperties == occupiedProperties) &&
            (identical(other.vacantProperties, vacantProperties) ||
                other.vacantProperties == vacantProperties) &&
            (identical(
                  other.underMaintenanceProperties,
                  underMaintenanceProperties,
                ) ||
                other.underMaintenanceProperties ==
                    underMaintenanceProperties) &&
            (identical(other.monthlyRevenueCurrent, monthlyRevenueCurrent) ||
                other.monthlyRevenueCurrent == monthlyRevenueCurrent) &&
            (identical(other.monthlyRevenuePrevious, monthlyRevenuePrevious) ||
                other.monthlyRevenuePrevious == monthlyRevenuePrevious) &&
            (identical(other.outstandingRentTotal, outstandingRentTotal) ||
                other.outstandingRentTotal == outstandingRentTotal) &&
            (identical(other.upcomingExpensesTotal, upcomingExpensesTotal) ||
                other.upcomingExpensesTotal == upcomingExpensesTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalProperties,
    occupiedProperties,
    vacantProperties,
    underMaintenanceProperties,
    monthlyRevenueCurrent,
    monthlyRevenuePrevious,
    outstandingRentTotal,
    upcomingExpensesTotal,
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
    @JsonKey(name: 'total_properties', fromJson: parseInt)
    final int? totalProperties,
    @JsonKey(name: 'occupied_properties', fromJson: parseInt)
    final int? occupiedProperties,
    @JsonKey(name: 'vacant_properties', fromJson: parseInt)
    final int? vacantProperties,
    @JsonKey(name: 'under_maintenance_properties', fromJson: parseInt)
    final int? underMaintenanceProperties,
    @JsonKey(name: 'monthly_revenue_current', fromJson: parseDouble)
    final double? monthlyRevenueCurrent,
    @JsonKey(name: 'monthly_revenue_previous', fromJson: parseDouble)
    final double? monthlyRevenuePrevious,
    @JsonKey(name: 'outstanding_rent_total', fromJson: parseDouble)
    final double? outstandingRentTotal,
    @JsonKey(name: 'upcoming_expenses_total', fromJson: parseDouble)
    final double? upcomingExpensesTotal,
  }) = _$DashboardOverviewImpl;

  factory _DashboardOverview.fromJson(Map<String, dynamic> json) =
      _$DashboardOverviewImpl.fromJson;

  @override
  @JsonKey(name: 'total_properties', fromJson: parseInt)
  int? get totalProperties;
  @override
  @JsonKey(name: 'occupied_properties', fromJson: parseInt)
  int? get occupiedProperties;
  @override
  @JsonKey(name: 'vacant_properties', fromJson: parseInt)
  int? get vacantProperties;
  @override
  @JsonKey(name: 'under_maintenance_properties', fromJson: parseInt)
  int? get underMaintenanceProperties;
  @override
  @JsonKey(name: 'monthly_revenue_current', fromJson: parseDouble)
  double? get monthlyRevenueCurrent;
  @override
  @JsonKey(name: 'monthly_revenue_previous', fromJson: parseDouble)
  double? get monthlyRevenuePrevious;
  @override
  @JsonKey(name: 'outstanding_rent_total', fromJson: parseDouble)
  double? get outstandingRentTotal;
  @override
  @JsonKey(name: 'upcoming_expenses_total', fromJson: parseDouble)
  double? get upcomingExpensesTotal;

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardOverviewImplCopyWith<_$DashboardOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
