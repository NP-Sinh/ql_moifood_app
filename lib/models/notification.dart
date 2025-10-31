class NotificationModel {
  final int notificationId;
  final String title;
  final String message;
  final String notificationType;
  bool? isRead;
  final DateTime createdAt;
  final int? userId;
  final String? fullName;
  final String phone;
  final String email;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.notificationType,
    this.isRead,
    required this.createdAt,
    this.userId,
    this.fullName,
    required this.phone,
    required this.email,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      notificationType: json['notificationType'] as String,
      isRead: json['isRead'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as int?,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
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
      'userId': userId,
      'email': email,
      'phone': phone,
      'fullName': fullName,
    };
  }
}
