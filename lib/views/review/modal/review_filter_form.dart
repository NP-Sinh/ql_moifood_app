import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/widgets/TextFormField/custom_text_field.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';

class ReviewFilterForm extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApply;

  const ReviewFilterForm({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<ReviewFilterForm> createState() => _ReviewFilterFormState();
}

class _ReviewFilterFormState extends State<ReviewFilterForm> {
  late TextEditingController _foodNameController;
  late TextEditingController _fullNameController;
  int? _minRating;
  int? _maxRating;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _foodNameController = TextEditingController(
      text: widget.currentFilters['foodName']?.toString() ?? '',
    );
    _fullNameController = TextEditingController(
      text: widget.currentFilters['fullName']?.toString() ?? '',
    );
    _minRating = widget.currentFilters['minRating'];
    _maxRating = widget.currentFilters['maxRating'];
    _fromDate = widget.currentFilters['fromDate'];
    _toDate = widget.currentFilters['toDate'];
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _foodNameController.clear();
      _fullNameController.clear();
      _minRating = null;
      _maxRating = null;
      _fromDate = null;
      _toDate = null;
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      'foodName': _foodNameController.text.trim().isEmpty
          ? null
          : _foodNameController.text.trim(),
      'fullName': _fullNameController.text.trim().isEmpty
          ? null
          : _fullNameController.text.trim(),
      'minRating': _minRating,
      'maxRating': _maxRating,
      'fromDate': _fromDate,
      'toDate': _toDate,
    };
    widget.onApply(filters);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameInputs(),
          const SizedBox(height: 16),
          _buildRatingFilters(),
          const SizedBox(height: 16),
          _buildDateFilters(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  //NAME INPUTS 
  Widget _buildNameInputs() => Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _foodNameController,
              labelText: 'Tên món ăn',
              hintText: 'Nhập tên món ăn',
              prefixIcon: Icons.fastfood_rounded,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomTextField(
              controller: _fullNameController,
              labelText: 'Tên người dùng',
              hintText: 'Nhập tên người dùng',
              prefixIcon: Icons.person_rounded,
            ),
          ),
        ],
      );

  // RATING FILTERS 
  Widget _buildRatingFilters() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Đánh giá',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildRatingDropdown(isMin: true)),
              const SizedBox(width: 16),
              Expanded(child: _buildRatingDropdown(isMin: false)),
            ],
          ),
        ],
      );

  Widget _buildRatingDropdown({required bool isMin}) =>
      DropdownButtonFormField<int>(
        value: isMin ? _minRating : _maxRating,
        decoration: InputDecoration(
          labelText: isMin ? 'Từ' : 'Đến',
          prefixIcon: const Icon(Icons.star_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
        items: [
          const DropdownMenuItem(value: null, child: Text('Tất cả')),
          ...List.generate(
            5,
            (i) => DropdownMenuItem(
              value: i + 1,
              child: Row(
                children: [
                  Text('${i + 1}'),
                  const SizedBox(width: 4),
                  Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                ],
              ),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            if (isMin) {
              _minRating = value;
            } else {
              _maxRating = value;
            }
          });
        },
      );

  //  DATE FILTERS 
  Widget _buildDateFilters() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Khoảng thời gian',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDateButton(isFromDate: true)),
              const SizedBox(width: 16),
              Expanded(child: _buildDateButton(isFromDate: false)),
            ],
          ),
        ],
      );

  Widget _buildDateButton({required bool isFromDate}) {
    final date = isFromDate ? _fromDate : _toDate;
    final label = isFromDate ? 'Từ ngày' : 'Đến ngày';

    return OutlinedButton.icon(
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          setState(() {
            if (isFromDate) {
              _fromDate = selectedDate;
            } else {
              _toDate = selectedDate;
            }
          });
        }
      },
      icon: const Icon(Icons.calendar_today_rounded),
      label: Text(
        date != null ? '${date.day}/${date.month}/${date.year}' : label,
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ACTION BUTTONS 
  Widget _buildActionButtons() => Row(
        children: [
          Expanded(
            child: CustomButton(
              label: 'Đặt lại',
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              onTap: _resetFilters,
              gradientColors: [Colors.grey.shade500, Colors.grey.shade600],
              height: 48,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              label: 'Áp dụng',
              icon: const Icon(Icons.check_rounded, color: Colors.white),
              onTap: _applyFilters,
              gradientColors: AppColor.btnAdd,
              height: 48,
              fontSize: 14,
            ),
          ),
        ],
      );
}