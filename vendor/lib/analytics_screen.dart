import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Business Insights', style: AppTypography.h2()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMetricGrid(),
          const SizedBox(height: 24),
          _buildChartPlaceholder('Revenue Trend (Last 7 Days)'),
          const SizedBox(height: 24),
          _buildTopItems(),
        ],
      ),
    );
  }

  Widget _buildMetricGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard('Total Orders', '128', Icons.shopping_bag_rounded, Colors.blue),
        _buildMetricCard('Revenue', '₵4.2k', Icons.payments_rounded, Colors.green),
        _buildMetricCard('Avg. Prep', '12m', Icons.timer_rounded, Colors.orange),
        _buildMetricCard('Rating', '4.8', Icons.star_rounded, Colors.amber),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTypography.h2()),
              Text(label, style: AppTypography.bodySm()),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildChartPlaceholder(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.h3()),
          const SizedBox(height: 32),
          Container(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final height = [40, 80, 60, 100, 120, 90, 110][index].toDouble();
                return Container(
                  width: 20,
                  height: height,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2 + (index * 0.1)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ).animate().slideY(begin: 1, duration: 600.ms, delay: (index * 100).ms);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopItems() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Selling Items', style: AppTypography.h3()),
          const SizedBox(height: 16),
          _buildItemRow('Jollof Rice with Chicken', '45 orders'),
          _buildItemRow('Banku & Tilapia', '32 orders'),
          _buildItemRow('Fried Rice & Wings', '28 orders'),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: AppTypography.bodyLg()),
          Text(count, style: AppTypography.bodySm().copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
