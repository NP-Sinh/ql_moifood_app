class GlobalNotification {
  final int globalNotificationId;
  final String title;
  final String message;
  final String? notificationType;
  final DateTime createdAt;

  GlobalNotification({
    required this.globalNotificationId,
    required this.title,
    required this.message,
    this.notificationType,
    required this.createdAt,
  });

  factory GlobalNotification.fromJson(Map<String, dynamic> json) {
    return GlobalNotification(
      globalNotificationId: json['globalNotificationId'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      notificationType: json['notificationType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'globalNotificationId': globalNotificationId,
      'title': title,
      'message': message,
      'notificationType': notificationType,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
