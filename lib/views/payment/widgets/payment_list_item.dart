import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/payment_method.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart'; // Giả sử AppColor ở đây
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';

class PaymentListItem extends StatefulWidget {
  final PaymentMethod paymentMethod;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PaymentListItem({
    super.key,
    required this.paymentMethod,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<PaymentListItem> createState() => _PaymentListItemState();
}

class _PaymentListItemState extends State<PaymentListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final List<Color> iconGradient = [
      AppColor.orange,
      AppColor.orange.withValues(alpha: 0.8),
    ];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
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
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: iconGradient.last.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.credit_card_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Thông tin PTTT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // Tên PTTT
                      widget.paymentMethod.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // ID
                      "ID: ${widget.paymentMethod.methodId}",
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
              _buildActiveButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomButton(
          tooltip: "Sửa",
          width: 44,
          height: 44,
          iconSize: 22,
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
          gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
          onTap: widget.onEdit,
          borderRadius: 12,
        ),
        const SizedBox(width: 8),
        CustomButton(
          tooltip: "Xóa",
          width: 44,
          height: 44,
          iconSize: 22,
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
          gradientColors: [
            Colors.redAccent.shade200,
            Colors.redAccent.shade400,
          ],
          onTap: widget.onDelete,
          borderRadius: 12,
        ),
      ],
    );
  }
}
