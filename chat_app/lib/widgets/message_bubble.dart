import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../themes/app_theme.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isCurrentUser;
  final bool showTime;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.showTime = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),
      child: Row(
        mainAxisAlignment: isCurrentUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Text(
                'A', // In real app, use sender's initial
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? (isDarkMode 
                        ? AppTheme.sentMessageColorDark 
                        : AppTheme.sentMessageColor)
                    : (isDarkMode 
                        ? AppTheme.receivedMessageColorDark 
                        : AppTheme.receivedMessageColor),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: isCurrentUser 
                      ? Radius.circular(16) 
                      : Radius.circular(4),
                  bottomRight: isCurrentUser 
                      ? Radius.circular(4) 
                      : Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message content
                  Text(
                    message.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isCurrentUser
                          ? (isDarkMode ? Colors.white : Colors.black87)
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  
                  if (showTime) ...[
                    SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isCurrentUser
                                ? (isDarkMode 
                                    ? Colors.white.withOpacity(0.7) 
                                    : Colors.black54)
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                        
                        if (isCurrentUser) ...[
                          SizedBox(width: 4),
                          Icon(
                            message.isRead 
                                ? Icons.done_all 
                                : Icons.done,
                            size: 14,
                            color: message.isRead
                                ? Theme.of(context).colorScheme.primary
                                : (isDarkMode 
                                    ? Colors.white.withOpacity(0.7) 
                                    : Colors.black54),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          if (isCurrentUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Text(
                'Y', // In real app, use current user's initial
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}