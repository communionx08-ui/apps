import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StoreSettingsScreen extends ConsumerStatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  ConsumerState<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends ConsumerState<StoreSettingsScreen> {
  final String _vendorName = 'Mama\'s Kitchen';

  @override
  Widget build(BuildContext context) {
    final registry = ref.watch(liveRegistryProvider);
    final status = registry.getVendorStatus(_vendorName);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS Background Color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Store Control', style: AppTypography.h2()),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildStatusSection(status),
          const SizedBox(height: 32),
          _buildSectionHeader('OPERATING HOURS'),
          _buildHoursList(),
          const SizedBox(height: 32),
          _buildSectionHeader('DELIVERY SETTINGS'),
          _buildSettingsList([
            _SettingsTile(
              icon: Icons.map_outlined,
              title: 'Delivery Radius',
              trailing: '5.0 km',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.timer_outlined,
              title: 'Base Prep Time',
              trailing: '15 mins',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildStatusSection(StoreStatus currentStatus) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatusOption(
                label: 'OPEN',
                status: StoreStatus.open,
                isActive: currentStatus == StoreStatus.open,
                activeColor: AppColors.success,
                onSelect: () => _updateStatus(StoreStatus.open),
              ),
              const SizedBox(width: 8),
              _StatusOption(
                label: 'BUSY',
                status: StoreStatus.busy,
                isActive: currentStatus == StoreStatus.busy,
                activeColor: Colors.orange,
                onSelect: () => _updateStatus(StoreStatus.busy),
              ),
              const SizedBox(width: 8),
              _StatusOption(
                label: 'CLOSED',
                status: StoreStatus.closed,
                isActive: currentStatus == StoreStatus.closed,
                activeColor: AppColors.danger,
                onSelect: () => _updateStatus(StoreStatus.closed),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _getStatusMessage(currentStatus),
            style: AppTypography.bodySm()(AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStatusMessage(StoreStatus status) {
    switch (status) {
      case StoreStatus.open: return 'Customers can place orders as usual.';
      case StoreStatus.busy: return 'Store is under heavy load. +15 mins added to all ETAs.';
      case StoreStatus.closed: return 'Store is hidden from search and cannot receive orders.';
    }
  }

  void _updateStatus(StoreStatus status) {
    HapticService.heavy();
    ref.read(liveRegistryProvider).setVendorStatus(_vendorName, status);
    setState(() {});
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 16, 10),
      child: Text(title, style: AppTypography.caption().copyWith(letterSpacing: 1.2)),
    );
  }

  Widget _buildHoursList() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: days.map((day) => _HoursTile(day: day, hours: '09:00 - 22:00')).toList(),
      ),
    );
  }

  Widget _buildSettingsList(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final String label;
  final StoreStatus status;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onSelect;

  const _StatusOption({
    required this.label,
    required this.status,
    required this.isActive,
    required this.activeColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onSelect,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.bodySm()(isActive ? Colors.white : AppColors.textMuted).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class _HoursTile extends StatelessWidget {
  final String day;
  final String hours;
  const _HoursTile({required this.day, required this.hours});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(day, style: AppTypography.bodyLg()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(hours, style: AppTypography.body()(AppColors.primary)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFC7C7CC)),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.textPrimary, size: 22),
      title: Text(title, style: AppTypography.bodyLg()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing, style: AppTypography.body()(AppColors.textMuted)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFC7C7CC)),
        ],
      ),
    );
  }
}
