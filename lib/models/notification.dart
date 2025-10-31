class NotificationModel {
  final int notificationId;
  final String title;
  final String message;
  final String notificationType;
  bool? isRead; 
  final DateTime createdAt;
  final bool isGlobal;
  final int? userId;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.notificationType,
    this.isRead,
    required this.createdAt,
    required this.isGlobal,
    this.userId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      notificationType: json['notificationType'] as String,
      isRead: json['isRead'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isGlobal: json['isGlobal'] as bool,
      userId: json['userId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'message': message,
      'notificationType': notificationType,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'isGlobal': isGlobal,
      'userId': userId,
    };
  }

  // Helper getter để check notification type
  bool get isInfo => notificationType.toLowerCase() == 'info';
  bool get isSuccess => notificationType.toLowerCase() == 'success';
  bool get isWarning => notificationType.toLowerCase() == 'warning';
  bool get isError => notificationType.toLowerCase() == 'error';

  // Copy with method để update isRead
  NotificationModel copyWith({
    int? notificationId,
    String? title,
    String? message,
    String? notificationType,
    bool? isRead,
    DateTime? createdAt,
    bool? isGlobal,
    int? userId,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      message: message ?? this.message,
      notificationType: notificationType ?? this.notificationType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      isGlobal: isGlobal ?? this.isGlobal,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $notificationId, title: $title, type: $notificationType, isGlobal: $isGlobal, isRead: $isRead)';
  }
}