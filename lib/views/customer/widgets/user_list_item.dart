import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';

class UserListItem extends StatefulWidget {
  final User user;
  final bool isActive;
  final VoidCallback? onView;
  final VoidCallback? onToggleActive;

  const UserListItem({
    super.key,
    required this.user,
    required this.isActive,
    this.onView,
    this.onToggleActive,
  });

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color hoverColor = widget.isActive
        ? AppColor.primary
        : Colors.grey.shade400;
    final List<Color> bgGradient = widget.isActive
        ? [Colors.white, Colors.grey.shade50]
        : [Colors.grey.shade200, Colors.grey.shade100];

    // Icon mặc định nếu Avatar bị null hoặc lỗi
    final circleAvatar = CircleAvatar(
      radius: 32,
      backgroundColor: Colors.grey.shade200,
      backgroundImage:
          (widget.user.avatar != null && widget.user.avatar!.isNotEmpty)
          ? NetworkImage(widget.user.avatar!)
          : null,
      child: (widget.user.avatar == null || widget.user.avatar!.isEmpty)
          ? Icon(Icons.person_rounded, size: 32, color: Colors.grey.shade500)
          : null,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? hoverColor.withValues(alpha: 0.3)
                : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? hoverColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 8 : 4),
              spreadRadius: _isHovered ? 2 : 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                          ? hoverColor.withValues(alpha: 0.3)
                          : Colors.transparent,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: circleAvatar,
              ),
              const SizedBox(width: 16),

              // Thông tin user
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.fullName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.isActive
                            ? Colors.black87
                            : Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: widget.isActive
                            ? AppColor.primary
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.phone ?? 'Chưa cập nhật SĐT',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Nút vai trò
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
                    color: widget.user.role.toLowerCase() == 'admin'
                        ? AppColor.orange
                        : Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget cho các nút hành động
  Widget _buildActionButtons() {
    // Nút Xem chi tiết
    final viewButton = CustomButton(
      tooltip: "Xem chi tiết",
      width: 44,
      height: 44,
      iconSize: 22,
      icon: const Icon(Icons.visibility_rounded, color: Colors.white),
      gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
      onTap: widget.onView,
      borderRadius: 12,
    );

    // Nút Kích hoạt / Vô hiệu hóa
    final toggleButton = CustomButton(
      tooltip: widget.isActive ? "Vô hiệu hóa" : "Kích hoạt",
      width: 44,
      height: 44,
      iconSize: 22,
      icon: Icon(
        widget.isActive ? Icons.lock_person_rounded : Icons.lock_open_rounded,
        color: Colors.white,
      ),
      gradientColors: widget.isActive
          ? [Colors.redAccent.shade200, Colors.redAccent.shade400]
          : [Colors.green.shade500, Colors.green.shade700],
      onTap: widget.onToggleActive,
      borderRadius: 12,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [viewButton, const SizedBox(width: 8), toggleButton],
    );
  }
}
