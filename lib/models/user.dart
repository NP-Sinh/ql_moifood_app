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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? 0,
      userName: json['username'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'User',
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
