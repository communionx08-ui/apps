import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Settings', style: AppTypography.h2()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 32),
          _buildSection('Account Settings', [
            _buildTile(Icons.person_outline_rounded, 'Business Profile', 'Edit name, description, address'),
            _buildTile(Icons.notifications_none_rounded, 'Notifications', 'Manage alerts and sounds'),
            _buildTile(Icons.lock_outline_rounded, 'Privacy & Security', 'Password, biometric login'),
          ]),
          const SizedBox(height: 24),
          _buildSection('Operations', [
            _buildTile(Icons.access_time_rounded, 'Store Hours', 'Manage opening and closing times'),
            _buildTile(Icons.delivery_dining_rounded, 'Delivery Settings', 'Set radiuses and fees'),
            _buildTile(Icons.payments_outlined, 'Payout Methods', 'Manage bank accounts'),
          ]),
          const SizedBox(height: 24),
          _buildSection('Support', [
            _buildTile(Icons.help_outline_rounded, 'Help Center', 'FAQs and guides'),
            _buildTile(Icons.chat_bubble_outline_rounded, 'Live Chat', 'Talk to Swift support'),
          ]),
          const SizedBox(height: 40),
          SwiftButton(
            text: 'Logout',
            variant: SwiftButtonVariant.secondary,
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          Center(child: Text('Version 1.0.0 (Build 42)', style: AppTypography.caption())),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mama\'s Kitchen', style: AppTypography.h2()),
              Text('ID: SWFT-VND-9831', style: AppTypography.bodySm()),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 20),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: AppTypography.bodySm().copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTokens.radiusXl),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle) {
    return ListTile(
      onTap: () => HapticService.selection(),
      leading: Icon(icon, color: AppColors.textPrimary, size: 22),
      title: Text(title, style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: AppTypography.bodySm()),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
    );
  }
}
