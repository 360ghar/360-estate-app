import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: const AppEmptyView(
        title: 'Messages Coming Soon',
        message: 'You will be able to chat with tenants and property managers here once the messaging API is implemented.',
        icon: Icons.chat_bubble_outline,
      ),
    );
  }
}
