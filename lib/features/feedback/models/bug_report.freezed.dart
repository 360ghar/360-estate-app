// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bug_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BugReport _$BugReportFromJson(Map<String, dynamic> json) {
  return _BugReport.fromJson(json);
}

/// @nodoc
mixin _$BugReport {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'bug_type')
  String? get bugType => throw _privateConstructorUsedError;
  String? get severity => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'steps_to_reproduce')
  String? get stepsToReproduce => throw _privateConstructorUsedError;
  @JsonKey(name: 'expected_behavior')
  String? get expectedBehavior => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_behavior')
  String? get actualBehavior => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_version')
  String? get appVersion => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringList)
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BugReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BugReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BugReportCopyWith<BugReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BugReportCopyWith<$Res> {
  factory $BugReportCopyWith(BugReport value, $Res Function(BugReport) then) =
      _$BugReportCopyWithImpl<$Res, BugReport>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? source,
    @JsonKey(name: 'bug_type') String? bugType,
    String? severity,
    String? title,
    String? description,
    @JsonKey(name: 'steps_to_reproduce') String? stepsToReproduce,
    @JsonKey(name: 'expected_behavior') String? expectedBehavior,
    @JsonKey(name: 'actual_behavior') String? actualBehavior,
    @JsonKey(name: 'app_version') String? appVersion,
    String? status,
    @JsonKey(fromJson: parseStringList) List<String>? tags,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class _$BugReportCopyWithImpl<$Res, $Val extends BugReport>
    implements $BugReportCopyWith<$Res> {
  _$BugReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BugReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? source = freezed,
    Object? bugType = freezed,
    Object? severity = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? stepsToReproduce = freezed,
    Object? expectedBehavior = freezed,
    Object? actualBehavior = freezed,
    Object? appVersion = freezed,
    Object? status = freezed,
    Object? tags = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            source: freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String?,
            bugType: freezed == bugType
                ? _value.bugType
                : bugType // ignore: cast_nullable_to_non_nullable
                      as String?,
            severity: freezed == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            stepsToReproduce: freezed == stepsToReproduce
                ? _value.stepsToReproduce
                : stepsToReproduce // ignore: cast_nullable_to_non_nullable
                      as String?,
            expectedBehavior: freezed == expectedBehavior
                ? _value.expectedBehavior
                : expectedBehavior // ignore: cast_nullable_to_non_nullable
                      as String?,
            actualBehavior: freezed == actualBehavior
                ? _value.actualBehavior
                : actualBehavior // ignore: cast_nullable_to_non_nullable
                      as String?,
            appVersion: freezed == appVersion
                ? _value.appVersion
                : appVersion // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BugReportImplCopyWith<$Res>
    implements $BugReportCopyWith<$Res> {
  factory _$$BugReportImplCopyWith(
    _$BugReportImpl value,
    $Res Function(_$BugReportImpl) then,
  ) = __$$BugReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? source,
    @JsonKey(name: 'bug_type') String? bugType,
    String? severity,
    String? title,
    String? description,
    @JsonKey(name: 'steps_to_reproduce') String? stepsToReproduce,
    @JsonKey(name: 'expected_behavior') String? expectedBehavior,
    @JsonKey(name: 'actual_behavior') String? actualBehavior,
    @JsonKey(name: 'app_version') String? appVersion,
    String? status,
    @JsonKey(fromJson: parseStringList) List<String>? tags,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class __$$BugReportImplCopyWithImpl<$Res>
    extends _$BugReportCopyWithImpl<$Res, _$BugReportImpl>
    implements _$$BugReportImplCopyWith<$Res> {
  __$$BugReportImplCopyWithImpl(
    _$BugReportImpl _value,
    $Res Function(_$BugReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BugReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? source = freezed,
    Object? bugType = freezed,
    Object? severity = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? stepsToReproduce = freezed,
    Object? expectedBehavior = freezed,
    Object? actualBehavior = freezed,
    Object? appVersion = freezed,
    Object? status = freezed,
    Object? tags = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$BugReportImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        source: freezed == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        bugType: freezed == bugType
            ? _value.bugType
            : bugType // ignore: cast_nullable_to_non_nullable
                  as String?,
        severity: freezed == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        stepsToReproduce: freezed == stepsToReproduce
            ? _value.stepsToReproduce
            : stepsToReproduce // ignore: cast_nullable_to_non_nullable
                  as String?,
        expectedBehavior: freezed == expectedBehavior
            ? _value.expectedBehavior
            : expectedBehavior // ignore: cast_nullable_to_non_nullable
                  as String?,
        actualBehavior: freezed == actualBehavior
            ? _value.actualBehavior
            : actualBehavior // ignore: cast_nullable_to_non_nullable
                  as String?,
        appVersion: freezed == appVersion
            ? _value.appVersion
            : appVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BugReportImpl implements _BugReport {
  const _$BugReportImpl({
    @JsonKey(fromJson: parseInt) this.id,
    this.source,
    @JsonKey(name: 'bug_type') this.bugType,
    this.severity,
    this.title,
    this.description,
    @JsonKey(name: 'steps_to_reproduce') this.stepsToReproduce,
    @JsonKey(name: 'expected_behavior') this.expectedBehavior,
    @JsonKey(name: 'actual_behavior') this.actualBehavior,
    @JsonKey(name: 'app_version') this.appVersion,
    this.status,
    @JsonKey(fromJson: parseStringList) final List<String>? tags,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
  }) : _tags = tags;

  factory _$BugReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$BugReportImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  final String? source;
  @override
  @JsonKey(name: 'bug_type')
  final String? bugType;
  @override
  final String? severity;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'steps_to_reproduce')
  final String? stepsToReproduce;
  @override
  @JsonKey(name: 'expected_behavior')
  final String? expectedBehavior;
  @override
  @JsonKey(name: 'actual_behavior')
  final String? actualBehavior;
  @override
  @JsonKey(name: 'app_version')
  final String? appVersion;
  @override
  final String? status;
  final List<String>? _tags;
  @override
  @JsonKey(fromJson: parseStringList)
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BugReport(id: $id, source: $source, bugType: $bugType, severity: $severity, title: $title, description: $description, stepsToReproduce: $stepsToReproduce, expectedBehavior: $expectedBehavior, actualBehavior: $actualBehavior, appVersion: $appVersion, status: $status, tags: $tags, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BugReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.bugType, bugType) || other.bugType == bugType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.stepsToReproduce, stepsToReproduce) ||
                other.stepsToReproduce == stepsToReproduce) &&
            (identical(other.expectedBehavior, expectedBehavior) ||
                other.expectedBehavior == expectedBehavior) &&
            (identical(other.actualBehavior, actualBehavior) ||
                other.actualBehavior == actualBehavior) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    source,
    bugType,
    severity,
    title,
    description,
    stepsToReproduce,
    expectedBehavior,
    actualBehavior,
    appVersion,
    status,
    const DeepCollectionEquality().hash(_tags),
    createdAt,
  );

  /// Create a copy of BugReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BugReportImplCopyWith<_$BugReportImpl> get copyWith =>
      __$$BugReportImplCopyWithImpl<_$BugReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BugReportImplToJson(this);
  }
}

abstract class _BugReport implements BugReport {
  const factory _BugReport({
    @JsonKey(fromJson: parseInt) final int? id,
    final String? source,
    @JsonKey(name: 'bug_type') final String? bugType,
    final String? severity,
    final String? title,
    final String? description,
    @JsonKey(name: 'steps_to_reproduce') final String? stepsToReproduce,
    @JsonKey(name: 'expected_behavior') final String? expectedBehavior,
    @JsonKey(name: 'actual_behavior') final String? actualBehavior,
    @JsonKey(name: 'app_version') final String? appVersion,
    final String? status,
    @JsonKey(fromJson: parseStringList) final List<String>? tags,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
  }) = _$BugReportImpl;

  factory _BugReport.fromJson(Map<String, dynamic> json) =
      _$BugReportImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  String? get source;
  @override
  @JsonKey(name: 'bug_type')
  String? get bugType;
  @override
  String? get severity;
  @override
  String? get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'steps_to_reproduce')
  String? get stepsToReproduce;
  @override
  @JsonKey(name: 'expected_behavior')
  String? get expectedBehavior;
  @override
  @JsonKey(name: 'actual_behavior')
  String? get actualBehavior;
  @override
  @JsonKey(name: 'app_version')
  String? get appVersion;
  @override
  String? get status;
  @override
  @JsonKey(fromJson: parseStringList)
  List<String>? get tags;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;

  /// Create a copy of BugReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BugReportImplCopyWith<_$BugReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
