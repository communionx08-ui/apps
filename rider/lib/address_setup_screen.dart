import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'all_set_screen.dart';

class AddressSetupScreen extends StatefulWidget {
  const AddressSetupScreen({super.key});

  @override
  State<AddressSetupScreen> createState() => _AddressSetupScreenState();
}

class _AddressSetupScreenState extends State<AddressSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      Haptics.medium();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AllSetScreen()),
      );
    } else {
      Haptics.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
        ),
        title: Text('Address Setup', style: AppTypography.h2()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Where are you\nbased?', style: AppTypography.h1()),
              const SizedBox(height: 8),
              Text('Enter your primary operating address to help us assign nearby tasks.', 
                  style: AppTypography.body()(AppColors.textSecondary)),
              const SizedBox(height: 32),
              _buildInputField('Home/Base Address', 'e.g. 12 Oxford Street', _addressCtrl),
              const SizedBox(height: 16),
              _buildInputField('City', 'e.g. Accra', _cityCtrl),
              const SizedBox(height: 16),
              _buildInputField('Landmark (Optional)', 'e.g. Opposite the Bank', _landmarkCtrl, maxLines: 2),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
        child: SafeArea(
          child: SwiftButton(
            label: 'Continue',
            onPressed: _onContinue,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySm().copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (v) => v!.isEmpty ? 'Required' : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          ),
        ),
      ],
    );
  }
}
