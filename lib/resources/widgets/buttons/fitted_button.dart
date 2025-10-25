import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';

class FittedButton extends StatelessWidget {
  final String? text;
  final bool? isActive;
  final VoidCallback onPressed;

  const FittedButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        backgroundColor: isActive! ? AppColor.orange : const Color(0xFFF1F1F1),
      ),
      child: Text(
        text!.toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: isActive! ? AppColor.white : AppColor.black.withOpacity(0.8),
        ),
      ),
    );
  }
}
