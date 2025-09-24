import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';

class SalesAnalyticsScreen extends StatefulWidget {
  const SalesAnalyticsScreen({super.key});

  @override
  State<SalesAnalyticsScreen> createState() => _SalesAnalyticsScreenState();
}

class _SalesAnalyticsScreenState extends State<SalesAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Today';

  // Mock analytics data
  final Map<String, Map<String, dynamic>> _analyticsData = {
    'Today': {
      'revenue': 3240.0,
      'orders': 24,
      'averageOrder': 135.0,
      'customers': 22,
      'growth': 8.5,
      'popularItems': [
        {'name': 'Margherita Pizza', 'orders': 8, 'revenue': 2392.0},
        {'name': 'Pepperoni Pizza', 'orders': 6, 'revenue': 2094.0},
        {'name': 'Garlic Bread', 'orders': 10, 'revenue': 1490.0},
      ],
      'hourlyData': [
        {'hour': '9 AM', 'orders': 2, 'revenue': 280.0},
        {'hour': '10 AM', 'orders': 3, 'revenue': 420.0},
        {'hour': '11 AM', 'orders': 5, 'revenue': 675.0},
        {'hour': '12 PM', 'orders': 8, 'revenue': 1080.0},
        {'hour': '1 PM', 'orders': 6, 'revenue': 810.0},
      ],
    },
    'Week': {
      'revenue': 22680.0,
      'orders': 168,
      'averageOrder': 135.0,
      'customers': 142,
      'growth': 12.3,
      'popularItems': [
        {'name': 'Margherita Pizza', 'orders': 56, 'revenue': 16744.0},
        {'name': 'Pepperoni Pizza', 'orders': 42, 'revenue': 14658.0},
        {'name': 'Veggie Pizza', 'orders': 38, 'revenue': 12160.0},
      ],
      'dailyData': [
        {'day': 'Mon', 'orders': 20, 'revenue': 2700.0},
        {'day': 'Tue', 'orders': 25, 'revenue': 3375.0},
        {'day': 'Wed', 'orders': 22, 'revenue': 2970.0},
        {'day': 'Thu', 'orders': 28, 'revenue': 3780.0},
        {'day': 'Fri', 'orders': 35, 'revenue': 4725.0},
        {'day': 'Sat', 'orders': 24, 'revenue': 3240.0},
        {'day': 'Sun', 'orders': 14, 'revenue': 1890.0},
      ],
    },
    'Month': {
      'revenue': 95400.0,
      'orders': 708,
      'averageOrder': 134.7,
      'customers': 589,
      'growth': 15.7,
      'popularItems': [
        {'name': 'Margherita Pizza', 'orders': 235, 'revenue': 70265.0},
        {'name': 'Pepperoni Pizza', 'orders': 178, 'revenue': 62122.0},
        {'name': 'Veggie Pizza', 'orders': 162, 'revenue': 51840.0},
      ],
      'weeklyData': [
        {'week': 'Week 1', 'orders': 180, 'revenue': 24300.0},
        {'week': 'Week 2', 'orders': 195, 'revenue': 26325.0},
        {'week': 'Week 3', 'orders': 172, 'revenue': 23220.0},
        {'week': 'Week 4', 'orders': 161, 'revenue': 21735.0},
      ],
    },
  };

  final List<String> _periods = ['Today', 'Week', 'Month'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _currentData => _analyticsData[_selectedPeriod]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sales Analytics',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showExportOptions(),
            icon: const Icon(Icons.download, color: AppColors.primaryGreen),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryGreen,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Products'),
            Tab(text: 'Trends'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Period Selector
          _buildPeriodSelector(),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildProductsTab(),
                _buildTrendsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(16),
      child: Row(
        children: _periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGreen : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.borderColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    period,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              // Key Metrics
              _buildKeyMetrics(),

              // Revenue Chart
              _buildRevenueChart(),

              // Performance Indicators
              _buildPerformanceIndicators(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyMetrics() {
    final data = _currentData;

    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Metrics',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Revenue',
                  AppHelpers.formatCurrency(data['revenue']),
                  '+${data['growth']}%',
                  Icons.monetization_on,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Orders',
                  data['orders'].toString(),
                  '+${(data['growth'] * 0.8).toStringAsFixed(1)}%',
                  Icons.receipt_long,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Avg Order',
                  AppHelpers.formatCurrency(data['averageOrder']),
                  '+${(data['growth'] * 0.6).toStringAsFixed(1)}%',
                  Icons.shopping_cart,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Customers',
                  data['customers'].toString(),
                  '+${(data['growth'] * 0.7).toStringAsFixed(1)}%',
                  Icons.people,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String growth,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  growth,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Trend',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Simple bar chart representation
          SizedBox(
            height: 200,
            child: _buildSimpleChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleChart() {
    List<dynamic> chartData;
    String labelKey, valueKey;

    switch (_selectedPeriod) {
      case 'Today':
        chartData = _currentData['hourlyData'];
        labelKey = 'hour';
        valueKey = 'revenue';
        break;
      case 'Week':
        chartData = _currentData['dailyData'];
        labelKey = 'day';
        valueKey = 'revenue';
        break;
      case 'Month':
        chartData = _currentData['weeklyData'];
        labelKey = 'week';
        valueKey = 'revenue';
        break;
      default:
        chartData = [];
        labelKey = '';
        valueKey = '';
    }

    if (chartData.isEmpty) return const SizedBox();

    final maxValue = chartData
        .map((e) => e[valueKey] as double)
        .reduce((a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: chartData.map((data) {
        final value = data[valueKey] as double;
        final label = data[labelKey] as String;
        final heightRatio = value / maxValue;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 140 * heightRatio,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  AppHelpers.formatCurrency(value),
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPerformanceIndicators() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Indicators',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildIndicatorRow(
              'Revenue Growth', '${_currentData['growth']}%', Colors.green),
          _buildIndicatorRow('Order Completion Rate', '94.5%', Colors.blue),
          _buildIndicatorRow('Customer Satisfaction', '4.7/5', Colors.orange),
          _buildIndicatorRow('Average Prep Time', '16 min', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildIndicatorRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    final popularItems = _currentData['popularItems'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Items',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...popularItems.map((item) {
            final index = popularItems.indexOf(item);
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${item['orders']} orders',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          AppHelpers.formatCurrency(item['revenue']),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trends & Insights',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildTrendCard(
            'Peak Hours',
            '12 PM - 2 PM generates 45% of daily revenue',
            Icons.trending_up,
            Colors.green,
          ),
          _buildTrendCard(
            'Best Day',
            'Fridays show 25% higher sales than average',
            Icons.calendar_today,
            Colors.blue,
          ),
          _buildTrendCard(
            'Customer Behavior',
            'Average customer orders 2.3 times per week',
            Icons.people,
            Colors.orange,
          ),
          _buildTrendCard(
            'Menu Performance',
            'Pizza items account for 70% of total sales',
            Icons.restaurant_menu,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard(
      String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Analytics',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text('Export as PDF',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _exportReport('PDF');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: Text('Export as Excel',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _exportReport('Excel');
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.primaryGreen),
              title: Text('Share Report',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _shareReport();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _exportReport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting analytics as $format...'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing analytics report...'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}
