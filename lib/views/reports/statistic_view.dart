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
          // Header và TabBar
          Container(
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
                _buildTabBar(),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Sử dụng component con cho Tab 1
                StatisticChartsTab(
                  currencyFormatter: _currencyFormatter,
                  animation: _animationController,
                ),
                // Sử dụng component con cho Tab 2
                StatisticListTab(currencyFormatter: _currencyFormatter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header mới theo style FoodView
  Widget _buildHeader() {
    return Row(
      children: [
        // Tiêu đề
        const Text(
          'Thống kê & Báo cáo',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 24),
        // Nhóm theo
        SizedBox(
          width: 200,
          child: _buildCompactFilter(
            label: 'Nhóm theo',
            icon: Icons.category_rounded,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGroupBy,
                isExpanded: true,
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
                items: const [
                  DropdownMenuItem(value: 'day', child: Text('Theo ngày')),
                  DropdownMenuItem(value: 'month', child: Text('Theo tháng')),
                  DropdownMenuItem(value: 'year', child: Text('Theo năm')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedGroupBy = value;
                    });
                    _fetchData();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(width: 300, child: _buildDateRangeButton()),
      ],
    );
  }

  Widget _buildCompactFilter({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }

  // TabBar mới theo style FoodView
  Widget _buildTabBar() {
    return Padding(
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
                  Icon(Icons.bar_chart_outlined, size: 18),
                  SizedBox(width: 6),
                  Text('Biểu đồ'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt_outlined, size: 18),
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
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelColor: Colors.black54,
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          dividerColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildDateRangeButton() {
    return InkWell(
      onTap: () => _selectDateRange(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.date_range_rounded,
              size: 18,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _fromDate != null && _toDate != null
                    ? '${DateFormat('dd/MM/yy').format(_fromDate!)} - ${DateFormat('dd/MM/yy').format(_toDate!)}'
                    : 'Chọn khoảng thời gian',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade700,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.deepOrange.shade400),
          ),
          child: child!,
        );
      },
    );

    if (range != null) {
      setState(() {
        _fromDate = range.start;
        _toDate = range.end;
      });
      _fetchData();
    }
  }
}