import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/active_order_provider.dart';
import '../providers/order_history_provider.dart';
import 'order_confirmation_screen.dart';
import '../services/order_simulation_service.dart';
import 'help_support_screen.dart';

const double _kErrandBaseFee = 15.0;
const double _kErrandKmRate = 1.80;

class ErrandFormScreen extends ConsumerStatefulWidget {
  final ErrandType errandType;
  final String title;

  const ErrandFormScreen({
    super.key,
    required this.errandType,
    required this.title,
  });

  @override
  ConsumerState<ErrandFormScreen> createState() => _ErrandFormScreenState();
}

class _ErrandFormScreenState extends ConsumerState<ErrandFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedSize = 1; // 0: Small, 1: Medium, 2: Large
  bool _isFragile = false;
  bool _isLoading = true;
  bool _isSubmitting = false;

  final _pickupAddrCtrl = TextEditingController();
  final _senderNameCtrl = TextEditingController();
  final _senderPhoneCtrl = TextEditingController();
  final _dropoffAddrCtrl = TextEditingController();
  final _recipientNameCtrl = TextEditingController();
  final _recipientPhoneCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  double get _estimatedKm => 5.2;
  double get _deliveryFee => _kErrandBaseFee + (_estimatedKm * _kErrandKmRate) + (_selectedSize * 5);
  double get _total => _deliveryFee + 2.0; // 2.0 service fee

  @override
  void initState() {
    super.initState();
    Future.delayed(AppTokens.durationSlow, () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _pickupAddrCtrl.dispose();
    _senderNameCtrl.dispose();
    _senderPhoneCtrl.dispose();
    _dropoffAddrCtrl.dispose();
    _recipientNameCtrl.dispose();
    _recipientPhoneCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _handleConfirmation() async {
    if (!_formKey.currentState!.validate()) {
      HapticService.error();
      return;
    }

    setState(() => _isSubmitting = true);
    HapticService.medium();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    final order = Order(
      id: OrderIdGenerator.next(ServiceType.errand),
      customerId: 'USER_123',
      serviceType: ServiceType.errand,
      status: OrderStatus.created,
      createdAt: DateTime.now(),
      errandDescription: _descriptionCtrl.text.trim().isEmpty 
          ? widget.title 
          : _descriptionCtrl.text.trim(),
      parcelDetails: ParcelDetails(
        size: _getSizeLabel(_selectedSize),
        category: 'General',
        isFragile: _isFragile,
      ),
      pickupAddress: _pickupAddrCtrl.text.trim(),
      dropoffAddress: _dropoffAddrCtrl.text.trim(),
      senderName: _senderNameCtrl.text.trim(),
      senderPhone: _senderPhoneCtrl.text.trim(),
      recipientName: _recipientNameCtrl.text.trim(),
      recipientPhone: _recipientPhoneCtrl.text.trim(),
      subtotal: 0,
      deliveryFee: _deliveryFee,
      serviceFee: 2.0,
      total: _total,
      paymentMethod: 'Swift Wallet',
    );

    ref.read(orderHistoryProvider.notifier).placeOrder(order);
    ref.read(activeOrderProvider.notifier).setOrder(
      ActiveOrder(
        orderId: order.id,
        serviceType: order.serviceType,
        statusMessage: 'Looking for a rider...',
        vendorName: 'Swift Agent',
        eta: '25 min',
      ),
    );

    OrderSimulationService.start(ref: ref, context: context, order: order);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(order: order),
        ),
      );
    }
  }

  String _getSizeLabel(int index) {
    switch (index) {
      case 0: return 'Small';
      case 1: return 'Medium';
      case 2: return 'Large';
      default: return 'Medium';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildSkeletonLoader();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
              children: [
                _buildMapPreview(),
                const SizedBox(height: 16),
                _buildAddressSection(),
                const SizedBox(height: 16),
                _buildPackageSection(),
              ],
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close, color: AppColors.textPrimary),
      ),
      title: Text(
        widget.title,
        style: AppTypography.h2(),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
          ),
          icon: const Icon(Icons.help_outline, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.borderLight,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80&w=800'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(AppTokens.radiusRound),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.route_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Optimizing route...',
                style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      children: [
        _buildCard(
          title: 'Pickup Details',
          icon: Icons.circle,
          iconColor: AppColors.primary,
          children: [
            _buildTextField(
              controller: _pickupAddrCtrl,
              label: 'Pickup Address',
              hint: 'Where should the rider go?',
              icon: Icons.location_on_outlined,
              required: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _senderNameCtrl,
                    label: 'Sender Name',
                    hint: 'Full name',
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _senderPhoneCtrl,
                    label: 'Phone',
                    hint: '0XX XXX XXXX',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCard(
          title: 'Drop-off Details',
          icon: Icons.location_on,
          iconColor: Colors.orange,
          children: [
            _buildTextField(
              controller: _dropoffAddrCtrl,
              label: 'Drop-off Address',
              hint: 'Destination address',
              icon: Icons.flag_outlined,
              required: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _recipientNameCtrl,
                    label: 'Recipient Name',
                    hint: 'Full name',
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _recipientPhoneCtrl,
                    label: 'Phone',
                    hint: '0XX XXX XXXX',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPackageSection() {
    return _buildCard(
      title: 'Package Information',
      children: [
        _buildTextField(
          controller: _descriptionCtrl,
          label: 'What are you sending?',
          hint: 'e.g. A box of books, keys, laundry...',
          maxLines: 2,
        ),
        const SizedBox(height: 20),
        Text('Package Size', style: AppTypography.h3()),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildSizeItem(0, 'Small', 'Bike', Icons.motorcycle)),
            const SizedBox(width: 10),
            Expanded(child: _buildSizeItem(1, 'Medium', 'Car', Icons.directions_car)),
            const SizedBox(width: 10),
            Expanded(child: _buildSizeItem(2, 'Large', 'Van', Icons.local_shipping)),
          ],
        ),
        const SizedBox(height: 20),
        _buildFragileToggle(),
      ],
    );
  }

  Widget _buildSizeItem(int index, String label, String vehicle, IconData icon) {
    final isSelected = _selectedSize == index;
    return AnimatedPress(
      onPressed: () {
        HapticService.selection();
        setState(() => _selectedSize = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMuted),
            const SizedBox(height: 8),
            Text(label, style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.bold)),
            Text(vehicle, style: AppTypography.bodySm()),
          ],
        ),
      ),
    );
  }

  Widget _buildFragileToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isFragile ? Colors.amber.withOpacity(0.05) : AppColors.borderLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: _isFragile ? Colors.amber : Colors.transparent),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fragile Item', style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.bold)),
                Text('Extra care for your delivery', style: AppTypography.bodySm()),
              ],
            ),
          ),
          Switch.adaptive(
            value: _isFragile,
            activeColor: Colors.amber,
            onChanged: (v) {
              HapticService.light();
              setState(() => _isFragile = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    IconData? icon,
    Color? iconColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusXl),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: iconColor),
                const SizedBox(width: 8),
              ],
              Text(title, style: AppTypography.h3()),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySm().copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: required ? (v) => v!.isEmpty ? 'Required' : null : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            filled: true,
            fillColor: AppColors.borderLight.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.radius2Xl)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ESTIMATED COST', style: AppTypography.bodySm()),
                    Text('₵${_total.toStringAsFixed(2)}', style: AppTypography.h1()),
                  ],
                ),
                Text('~25 mins', style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            SwipeToConfirm(
              text: 'Swipe to Request Delivery',
              isLoading: _isSubmitting,
              onConfirm: _handleConfirmation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: List.generate(4, (index) => Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          )),
        ),
      ),
    );
  }
}
