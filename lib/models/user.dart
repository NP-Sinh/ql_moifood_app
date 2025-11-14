class User {
  final int userId;
  final String userName;
  final String fullName;
  final String email;
  final String? phone;
  final String? address;
  final String? avatar;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.userId,
    required this.userName,
    required this.fullName,
    required this.email,
    this.phone,
    this.address,
    this.avatar,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String avatar = json['avatar'] ?? '';
    if (!avatar.startsWith('http')) {
      avatar = "https://localhost:7128$avatar";
    }

    return User(
      userId: json['userId'] ?? 0,
      userName: json['username'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      avatar: avatar,
      role: json['role'] as String? ?? 'User',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': userName,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
