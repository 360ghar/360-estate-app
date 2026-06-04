import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/feedback/models/bug_report.dart';

class BugReportPayload {
  const BugReportPayload({
    required this.bugType,
    required this.title,
    required this.description,
    this.source = 'mobile',
    this.severity = 'medium',
    this.stepsToReproduce,
    this.expectedBehavior,
    this.actualBehavior,
    this.deviceInfo,
    this.appVersion,
    this.tags,
  });

  final String source;
  final String bugType;
  final String severity;
  final String title;
  final String description;
  final String? stepsToReproduce;
  final String? expectedBehavior;
  final String? actualBehavior;
  final Map<String, dynamic>? deviceInfo;
  final String? appVersion;
  final List<String>? tags;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'source': source,
      'bug_type': bugType,
      'severity': severity,
      'title': title,
      'description': description,
    };
    if (stepsToReproduce != null && stepsToReproduce!.trim().isNotEmpty) {
      payload['steps_to_reproduce'] = stepsToReproduce!.trim();
    }
    if (expectedBehavior != null && expectedBehavior!.trim().isNotEmpty) {
      payload['expected_behavior'] = expectedBehavior!.trim();
    }
    if (actualBehavior != null && actualBehavior!.trim().isNotEmpty) {
      payload['actual_behavior'] = actualBehavior!.trim();
    }
    if (deviceInfo != null && deviceInfo!.isNotEmpty) {
      payload['device_info'] = deviceInfo;
    }
    if (appVersion != null && appVersion!.trim().isNotEmpty) {
      payload['app_version'] = appVersion!.trim();
    }
    if (tags != null && tags!.isNotEmpty) {
      payload['tags'] = tags;
    }
    return payload;
  }
}

class FeedbackRepository {
  FeedbackRepository(this._client);

  final ApiClient _client;

  Future<BugReport> submitBugReport(BugReportPayload payload) async {
    final response = await _client.post<dynamic>('/bugs', data: payload.toJson());
    final data = unwrapMap(response.data);
    return BugReport.fromJson(data);
  }
}
