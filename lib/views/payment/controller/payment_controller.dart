import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/payment_method.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/configs/snackbar_config.dart';
import 'package:ql_moifood_app/viewmodels/payment_viewmodel.dart';
import 'package:ql_moifood_app/views/payment/modal/payment_metod_form.dart';

class PaymentController {
  final BuildContext context;
  late final PaymentViewModel _viewModel;

  PaymentController(this.context) {
    _viewModel = context.read<PaymentViewModel>();
  }

  // LOAD DATA
  Future<void> loadAllPaymentMethods() async {
    await _viewModel.fetchAllPaymentMethods();
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        _viewModel.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  // thêm/ sửa
  void _showModifPaymentMethodModal({
    PaymentMethod? paymentMethod,
    required List<PaymentMethod> allPaymentMethod,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: paymentMethod?.name);

    AppUtils.showBaseModal(
      context,
      maxWidth: 500,
      maxHeight: 500,
      title: paymentMethod == null ? 'Thêm món' : 'Cập nhật',
      child: PaymentMethodForm(
        formKey: formKey,
        paymentMethod: paymentMethod,
        nameController: nameController,
      ),
      secondaryAction: CustomButton(
        label: 'Hủy',
        onTap: () => Navigator.pop(context),
        gradientColors: AppColor.btnCancel,
      ),
      primaryAction: Consumer<PaymentViewModel>(
        builder: (context, vm, _) => CustomButton(
          label: paymentMethod == null ? 'Thêm' : 'Cập nhật',
          gradientColors: AppColor.btnAdd,
          onTap: () async {
            if (formKey.currentState!.validate()) {
              final success = await vm.modifyPaymentMethod(
                id: paymentMethod?.methodId ?? 0,
                name: nameController.text.trim(),
              );

              if (context.mounted) {
                Navigator.pop(context);
                AppUtils.showSnackBar(
                  context,
                  success
                      ? (paymentMethod == null
                            ? 'Thêm thành công'
                            : 'Cập nhật thành công')
                      : vm.errorMessage ?? 'Thao tác thất bại',
                  type: success ? SnackBarType.success : SnackBarType.error,
                );
                if (success) {
                  await vm.fetchAllPaymentMethods();
                }
              }
            }
          },
        ),
      ),
    );
  }

  void showAddFoodModal() {
    final pm = context.read<PaymentViewModel>().paymentMethods;
    _showModifPaymentMethodModal(paymentMethod: null, allPaymentMethod: pm);
  }

  void showEditFoodModal(PaymentMethod paymentMethod) {
    final pm = context.read<PaymentViewModel>().paymentMethods;
    _showModifPaymentMethodModal(
      paymentMethod: paymentMethod,
      allPaymentMethod: pm,
    );
  }

  // DELETE
  void confirmPaymentMethod(PaymentMethod paymetMethod) {
    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận xóa',
      message: 'Bạn có chắc muốn xóa paymet method này không?',
      confirmText: 'Xóa',
      confirmColor: Colors.redAccent,
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await _viewModel.deletePaymentMethod(
          paymetMethod.methodId,
        );
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            success
                ? 'Đã xóa paymet method thành công'
                : _viewModel.errorMessage ?? 'Xóa thất bại',
            type: success ? SnackBarType.success : SnackBarType.error,
          );
        }
      }
    });
  }
}
