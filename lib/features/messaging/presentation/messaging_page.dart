import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

/// Message model
class MessageThread {
  const MessageThread({
    required this.id,
    required this.participantName,
    required this.participantAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.propertyName,
    this.isOnline = false,
  });

  final String id;
  final String participantName;
  final String? participantAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? propertyName;
  final bool isOnline;
}

/// Chat message model
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
  });

  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
}

/// Messaging page showing all conversations
///
/// Messaging will be available when the chat/messaging API endpoints are implemented.
class MessagingPage extends StatelessWidget {
  const MessagingPage({super.key});

  static const _featureItems = [
    _FeaturePreview(
      icon: Icons.chat_rounded,
      text: 'Direct messaging with tenants and owners',
    ),
    _FeaturePreview(
      icon: Icons.image_outlined,
      text: 'Share photos, documents, and files',
    ),
    _FeaturePreview(
      icon: Icons.notifications_active_outlined,
      text: 'Real-time push notifications',
    ),
    _FeaturePreview(
      icon: Icons.history_rounded,
      text: 'Full conversation history and search',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // Icon in colored circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                'Messaging Coming Soon',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              Text(
                'Chat with tenants and property managers directly\nfrom the app once the messaging API is live.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Feature preview card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceSecondary
                      : AppColors.surfaceSecondary,
                  borderRadius: AppRadii.lg,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : AppColors.cardBorder,
                    width: 0.5,
                  ),
                  boxShadow: AppShadows.cardResting,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What to expect',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ..._featureItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.md,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.10),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: AppSpacing.xs,
                                ),
                                child: Text(
                                  item.text,
                                  style:
                                      theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        theme.colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePreview {
  const _FeaturePreview({required this.icon, required this.text});
  final IconData icon;
  final String text;
}
