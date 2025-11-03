import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/viewmodels/statistic_viewmodel.dart';
import 'package:ql_moifood_app/views/reports/widgets/statistic_charts_tab.dart';
import 'package:ql_moifood_app/views/reports/widgets/statistic_list_tab.dart';

class StatisticView extends StatefulWidget {
  static const String routeName = '/statistic';
  const StatisticView({super.key});

  @override
  State<StatisticView> createState() => _StatisticViewState();
}

class _StatisticViewState extends State<StatisticView>
    with TickerProviderStateMixin {
  String _selectedGroupBy = 'month';
  DateTime? _fromDate;
  DateTime? _toDate;
  final int _topFood = 5;
  late TabController _tabController;
  late AnimationController _animationController;

  final _currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
  );

  Future<void> _fetchData() async {
    final viewModel = Provider.of<StatisticViewModel>(context, listen: false);
    _animationController.reset();
    _animationController.forward();

    viewModel.fetchRevenue(
      groupBy: _selectedGroupBy,
      fromDate: _fromDate,
      toDate: _toDate,
    );
    viewModel.fetchOrderCount(
      groupBy: _selectedGroupBy,
      fromDate: _fromDate,
      toDate: _toDate,
    );
    viewModel.fetchFoodOrderStats(
      top: _topFood,
      fromDate: _fromDate,
      toDate: _toDate,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _toDate = DateTime.now();
    _fromDate = DateTime(_toDate!.year - 1, _toDate!.month, _toDate!.day);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const PageStorageKey('analytics_page'),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  // ==================== HEADER SECTION ====================
  Widget _buildHeaderSection() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: _buildHeader(),
        ),
        _buildFilters(),
        const SizedBox(height: 16),
        _buildTabBar(),
      ],
    ),
  );

  // ==================== HEADER ====================
  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Thống kê & Báo cáo',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      _buildRefreshButton(),
    ],
  );

  Widget _buildRefreshButton() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColor.orange, AppColor.orange.withValues(alpha: 0.8)],
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColor.orange.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _fetchData,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Làm mới',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // ==================== FILTERS ====================
  Widget _buildFilters() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      children: [
        Expanded(child: _buildGroupByFilter()),
        const SizedBox(width: 16),
        Expanded(child: _buildFromDatePicker()),
        const SizedBox(width: 16),
        Expanded(child: _buildToDatePicker()),
      ],
    ),
  );

  // Group By Filter
  Widget _buildGroupByFilter() => Container(
    height: 68,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedGroupBy,
        isExpanded: true,
        isDense: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColor.primary,
          size: 22,
        ),
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w600,
        ),
        items: [
          _buildDropdownItem('day', Icons.calendar_today_rounded, 'Theo ngày'),
          _buildDropdownItem(
            'month',
            Icons.calendar_view_month_rounded,
            'Theo tháng',
          ),
          _buildDropdownItem(
            'year',
            Icons.calendar_view_week_rounded,
            'Theo năm',
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedGroupBy = value);
            _fetchData();
          }
        },
      ),
    ),
  );

  DropdownMenuItem<String> _buildDropdownItem(
    String value,
    IconData icon,
    String label,
  ) => DropdownMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppColor.primary),
        const SizedBox(width: 12),
        Text(label),
      ],
    ),
  );

  // From Date Picker
  Widget _buildFromDatePicker() => InkWell(
    onTap: () => _selectFromDate(context),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.event_rounded, size: 20, color: Colors.green.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Từ ngày',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _fromDate != null
                      ? DateFormat('dd/MM/yyyy').format(_fromDate!)
                      : 'Chọn ngày',
                  style: TextStyle(
                    fontSize: 14,
                    color: _fromDate != null
                        ? Colors.grey.shade800
                        : Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.calendar_month_rounded,
            size: 18,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    ),
  );

  // To Date Picker
  Widget _buildToDatePicker() => InkWell(
    onTap: () => _selectToDate(context),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.event_rounded, size: 20, color: Colors.red.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Đến ngày',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _toDate != null
                      ? DateFormat('dd/MM/yyyy').format(_toDate!)
                      : 'Chọn ngày',
                  style: TextStyle(
                    fontSize: 14,
                    color: _toDate != null
                        ? Colors.grey.shade800
                        : Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.calendar_month_rounded,
            size: 18,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    ),
  );

  // ==================== DATE PICKERS ====================
  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: _toDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green.shade600,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _fromDate) {
      setState(() => _fromDate = picked);
      _fetchData();
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red.shade600,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _toDate) {
      setState(() => _toDate = picked);
      _fetchData();
    }
  }

  // ==================== TAB BAR ====================
  Widget _buildTabBar() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
    child: Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.bar_chart_rounded, size: 18),
                SizedBox(width: 6),
                Text('Biểu đồ'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.list_alt_rounded, size: 18),
                SizedBox(width: 6),
                Text('Chi tiết'),
              ],
            ),
          ),
        ],
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelColor: Colors.black54,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        dividerColor: Colors.transparent,
      ),
    ),
  );

  // ==================== TAB BAR VIEW ====================
  Widget _buildTabBarView() => TabBarView(
    controller: _tabController,
    children: [
      StatisticChartsTab(
        currencyFormatter: _currencyFormatter,
        animation: _animationController,
      ),
      StatisticListTab(currencyFormatter: _currencyFormatter),
    ],
  );
}
