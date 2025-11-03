import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/payment_method.dart';
import 'package:ql_moifood_app/resources/widgets/TextFormField/custom_text_field.dart';

class PaymentMethodForm extends StatefulWidget {
  final PaymentMethod? paymentMethod;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;

  const PaymentMethodForm({
    super.key,
    this.paymentMethod,
    required this.formKey,
    required this.nameController,
  });

  @override
  State<PaymentMethodForm> createState() => _PaymentMethodFormState();
}

class _PaymentMethodFormState extends State<PaymentMethodForm> {
  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod != null) {
      widget.nameController.text = widget.paymentMethod!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: widget.nameController,
            labelText: "Tên payment method",
            hintText: "Nhập tên payment method (ví dụ: zalo,..)",
            prefixIcon: Icons.category_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Không được để trống tên payment method';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
