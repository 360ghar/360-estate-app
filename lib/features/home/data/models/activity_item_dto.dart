import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/home/domain/entities/activity_item.dart';

final class ActivityItemDto {
  const ActivityItemDto({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.title,
    required this.description,
    this.propertyId,
    this.propertyName,
    this.leaseId,
    this.amount,
    this.status,
  });

  factory ActivityItemDto.fromJson(Map<String, dynamic> json) {
    return ActivityItemDto(
      id: parseInt(json['id']) ?? 0,
      type: json['type'] as String? ?? 'unknown',
      timestamp: parseDateTime(json['at']) ?? DateTime.now(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      propertyId: (json['property_id'] as num?)?.toInt(),
      propertyName: json['property_name'] as String?,
      leaseId: (json['lease_id'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      status: json['status'] as String?,
    );
  }

  final int id;
  final String type;
  final DateTime timestamp;
  final String title;
  final String description;
  final int? propertyId;
  final String? propertyName;
  final int? leaseId;
  final double? amount;
  final String? status;

  ActivityItem toEntity() {
    return ActivityItem(
      id: id,
      type: ActivityType.fromString(type),
      timestamp: timestamp,
      title: title,
      description: description,
      propertyId: propertyId,
      propertyName: propertyName,
      leaseId: leaseId,
      amount: amount,
      status: status,
    );
  }
}
