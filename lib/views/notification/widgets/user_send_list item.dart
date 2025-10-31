import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/views/notification/controller/notification_controller.dart';

class UserSendListItem extends StatefulWidget {
  final User user;
  final NotificationController controller;

  const UserSendListItem({required this.user, required this.controller});

  @override
  State<UserSendListItem> createState() => UserSendListItemState();
}

class UserSendListItemState extends State<UserSendListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Icon Avatar
    final circleAvatar = CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey.shade200,
      backgroundImage:
          (widget.user.avatar != null && widget.user.avatar!.isNotEmpty)
          ? NetworkImage(widget.user.avatar!)
          : null,
      child: (widget.user.avatar == null || widget.user.avatar!.isEmpty)
          ? Icon(Icons.person_rounded, size: 28, color: Colors.grey.shade500)
          : null,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              _isHovered ? Colors.white : Colors.grey.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColor.orange.withValues(alpha: 0.3)
                : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColor.orange.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 4),
              spreadRadius: _isHovered ? 1 : 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar 
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? AppColor.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: circleAvatar,
              ),
              const SizedBox(width: 16),

              // Thông tin 
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${widget.user.userId} - ${widget.user.phone ?? 'Chưa có SĐT'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Vai trò
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.user.role.toLowerCase() == 'admin'
                      ? AppColor.orange.withValues(alpha: 0.1)
                      : Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.user.role,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: widget.user.role.toLowerCase() == 'admin'
                        ? AppColor.orange
                        : Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Nút Gửi
              CustomButton(
                tooltip: "Gửi thông báo cho người dùng này",
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                width: 44,
                height: 44,
                iconSize: 22,
                gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
                borderRadius: 12,
                onTap: () {
                  widget.controller.showSendToUserModal(
                    targetUser: widget.user,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
