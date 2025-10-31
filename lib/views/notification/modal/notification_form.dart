import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/TextFormField/custom_text_field.dart';

class NotificationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController? userIdController;
  final TextEditingController titleController;
  final TextEditingController messageController;
  final String initialType;
  final ValueChanged<String> onTypeChanged;
  final bool isPersonal;
  final User? targetUser;

  const NotificationForm({
    super.key,
    required this.formKey,
    this.userIdController,
    required this.titleController,
    required this.messageController,
    required this.initialType,
    required this.onTypeChanged,
    this.isPersonal = false,
    this.targetUser,
  });

  @override
  State<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.targetUser != null) ...[
              _buildTargetUserInfo(widget.targetUser!),
              const SizedBox(height: 16),
            ] else if (widget.isPersonal) ...[
              CustomTextField(
                controller: widget.userIdController!,
                labelText: 'Mã người dùng',
                hintText: 'Nhập mã người dùng',
                prefixIcon: Icons.person_rounded,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mã người dùng không được để trống';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Mã người dùng không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            CustomTextField(
              controller: widget.titleController,
              labelText: 'Tiêu đề',
              hintText: 'Nhập tiêu đề thông báo',
              prefixIcon: Icons.title_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tiêu đề không được để trống';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: widget.messageController,
              labelText: 'Nội dung',
              hintText: 'Nhập nội dung thông báo',
              prefixIcon: Icons.message_rounded,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nội dung không được để trống';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTypeSelector(),
          ],
        ),
      ),
    );
  }

  // Lấy modal send userId
  Widget _buildTargetUserInfo(User user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_circle_rounded,
            color: AppColor.primary,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ID: ${user.userId} - ${user.email}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build noti
  Widget _buildTypeSelector() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Loại thông báo',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildTypeChip(
            'System',
            'Hệ thống',
            Icons.info_outline_rounded,
            Colors.blue,
          ),
          _buildTypeChip(
            'Order',
            'Đơn hàng',
            Icons.check_circle_outline_rounded,
            Colors.green,
          ),
          _buildTypeChip(
            'Promotion',
            'Khuyến mãi',
            Icons.warning_amber_rounded,
            Colors.orange,
          ),
          _buildTypeChip(
            'NewFood',
            'Món mới',
            Icons.fastfood_rounded,
            Colors.red,
          ),
        ],
      ),
    ],
  );

  Widget _buildTypeChip(
    String value,
    String label,
    IconData icon,
    MaterialColor color,
  ) {
    final isSelected = _selectedType == value;

    return InkWell(
      onTap: () {
        setState(() => _selectedType = value);
        widget.onTypeChanged(value);
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color.shade400, color.shade600])
              : null,
          color: isSelected ? null : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : color.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
