import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_row.freezed.dart';
part 'report_row.g.dart';

@freezed
class ReportRow with _$ReportRow {
  const factory ReportRow({
    String? label,
    @JsonKey(fromJson: parseDouble) double? amount,
    String? value,
  }) = _ReportRow;

  factory ReportRow.fromJson(Map<String, dynamic> json) =>
      _$ReportRowFromJson(json);
}
