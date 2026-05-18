import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/features/home/domain/entities/activity_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityFeed extends StatelessWidget {
  const ActivityFeed({super.key, required this.activities, this.onActivityTap});

  final List<ActivityItem> activities;
  final void Function(ActivityItem)? onActivityTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ActivityFeedItem(
          activity: activity,
          onTap: onActivityTap != null ? () => onActivityTap!(activity) : null,
        );
      },
    );
  }
}

class ActivityFeedItem extends StatelessWidget {
  const ActivityFeedItem({super.key, required this.activity, this.onTap});

  final ActivityItem activity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );
    final timeFormat = DateFormat('MMM d, h:mm a');

    return ListTile(
      leading: _buildIcon(),
      title: Text(
        activity.title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activity.description.isNotEmpty)
            Text(
              activity.description,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (activity.amount != null)
            Text(
              currencyFormat.format(activity.amount),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getAmountColor(activity.type),
                fontWeight: FontWeight.w600,
              ),
            ),
          Text(
            timeFormat.format(activity.timestamp),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      trailing: activity.status != null
          ? _StatusBadge(status: activity.status!)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildIcon() {
    final iconData = _getIconForType(activity.type);
    final color = _getColorForType(activity.type);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 20, color: color),
    );
  }

  IconData _getIconForType(ActivityType type) {
    return switch (type) {
      ActivityType.paymentReceived => Icons.payments,
      ActivityType.maintenanceCreated => Icons.build,
      ActivityType.maintenanceCompleted => Icons.check_circle,
      ActivityType.leaseCreated => Icons.description,
      ActivityType.leaseExpiring => Icons.warning,
      ActivityType.tenantMoveIn => Icons.login,
      ActivityType.tenantMoveOut => Icons.logout,
      ActivityType.documentUploaded => Icons.upload_file,
      ActivityType.inspectionCompleted => Icons.checklist,
      ActivityType.unknown => Icons.info,
    };
  }

  Color _getColorForType(ActivityType type) {
    return switch (type) {
      ActivityType.paymentReceived => Colors.green,
      ActivityType.maintenanceCreated => Colors.orange,
      ActivityType.maintenanceCompleted => Colors.green,
      ActivityType.leaseCreated => AppColors.brand,
      ActivityType.leaseExpiring => Colors.amber,
      ActivityType.tenantMoveIn => AppColors.brand,
      ActivityType.tenantMoveOut => Colors.red,
      ActivityType.documentUploaded => Colors.blue,
      ActivityType.inspectionCompleted => Colors.teal,
      ActivityType.unknown => Colors.grey,
    };
  }

  Color? _getAmountColor(ActivityType type) {
    return switch (type) {
      ActivityType.paymentReceived => Colors.green,
      _ => null,
    };
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Color _getStatusColor(String status) {
    return switch (status.toLowerCase()) {
      'completed' || 'paid' || 'active' => Colors.green,
      'pending' || 'open' => Colors.orange,
      'overdue' || 'expired' || 'cancelled' => Colors.red,
      _ => Colors.grey,
    };
  }
}
