import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_row.freezed.dart';
part 'report_row.g.dart';

/// One line of a report on screen. The app builds the lines from the typed
/// report payloads (see `ReportRowMapper`): the backend sends no labels.
/// A money line sets [amount]. Any other line sets [value]. [detail] is the
/// second line of text under the label.
@freezed
class ReportRow with _$ReportRow {
  const factory ReportRow({
    String? label,
    @JsonKey(fromJson: parseDouble) double? amount,
    String? value,
    String? detail,
  }) = _ReportRow;

  factory ReportRow.fromJson(Map<String, dynamic> json) =>
      _$ReportRowFromJson(json);
}
