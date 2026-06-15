class NotificationHistory {
  const NotificationHistory({
    required this.id,
    required this.title,
    required this.body,
    required this.userIds,
    required this.requestedUsers,
    required this.targetDevices,
    required this.sent,
    required this.failed,
    required this.status,
    required this.createdAt,
    this.errorMessage,
  });

  final int id;
  final String title;
  final String body;
  final List<int> userIds;
  final int requestedUsers;
  final int targetDevices;
  final int sent;
  final int failed;
  final String status;
  final DateTime createdAt;
  final String? errorMessage;

  bool get isFailed => status == 'FAILED';

  factory NotificationHistory.fromJson(Map<String, dynamic> json) {
    return NotificationHistory(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      userIds:
          (json['userIds'] as List<dynamic>? ?? const [])
              .map((value) => value as int)
              .toList(),
      requestedUsers: json['requestedUsers'] as int? ?? 0,
      targetDevices: json['targetDevices'] as int? ?? 0,
      sent: json['sent'] as int? ?? 0,
      failed: json['failed'] as int? ?? 0,
      status: json['status'] as String? ?? 'COMPLETED',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

class NotificationRecipient {
  const NotificationRecipient({
    required this.id,
    required this.email,
    required this.nickname,
    required this.isActive,
  });

  final int id;
  final String email;
  final String nickname;
  final bool isActive;

  factory NotificationRecipient.fromJson(Map<String, dynamic> json) {
    return NotificationRecipient(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

class NotificationRecipients {
  const NotificationRecipients({
    required this.recipients,
    required this.missingUserIds,
  });

  final List<NotificationRecipient> recipients;
  final List<int> missingUserIds;

  factory NotificationRecipients.fromJson(Map<String, dynamic> json) {
    return NotificationRecipients(
      recipients:
          (json['recipients'] as List<dynamic>? ?? const [])
              .map(
                (item) => NotificationRecipient.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
      missingUserIds:
          (json['missingUserIds'] as List<dynamic>? ?? const [])
              .map((value) => value as int)
              .toList(),
    );
  }
}
