import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/active_order_provider.dart';
import '../providers/order_history_provider.dart';
import '../providers/rider_location_provider.dart';
import 'chat_screen.dart';
import 'help_support_screen.dart';
import 'rate_review_screen.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  final MapController _mapController = MapController();
  
  // Locations
  final LatLng _pickup = const LatLng(6.6884, -1.6244);
  final LatLng _destination = const LatLng(6.7012, -1.6080);

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(orderHistoryProvider.notifier).byId(widget.orderId);
    final riderPos = ref.watch(riderLocationProvider);

    if (order == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          _buildMap(riderPos),
          _buildHeader(order),
          _buildStatusSheet(order, riderPos),
        ],
      ),
    );
  }

  Widget _buildMap(LatLng riderPos) {
    return Positioned.fill(
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: riderPos,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: [_pickup, _destination],
                color: AppColors.primary.withOpacity(0.3),
                strokeWidth: 4,
                isDotted: true,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _pickup,
                width: 40,
                height: 40,
                child: _buildLocationMarker(Icons.storefront_rounded, AppColors.primary),
              ),
              Marker(
                point: _destination,
                width: 40,
                height: 40,
                child: _buildLocationMarker(Icons.home_rounded, Colors.orange),
              ),
              Marker(
                point: riderPos,
                width: 50,
                height: 50,
                child: _buildRiderMarker(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMarker(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildRiderMarker() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
         return Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 15)],
          ),
          child: const Icon(Icons.motorcycle_rounded, color: Colors.white, size: 24),
        );
      },
    );
  }

  Widget _buildHeader(Order order) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20, left: 16, right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white.withOpacity(0)],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTokens.radiusRound),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Text(
                order.id,
                style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
              icon: const Icon(Icons.help_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSheet(Order order, LatLng riderPos) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.radius2Xl)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.status.label.toUpperCase(), style: AppTypography.bodySm()(AppColors.primary).copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
                      Text(
                        order.status == OrderStatus.delivered ? 'Arrived!' : 'Arriving in 8 mins',
                        style: AppTypography.h1(),
                      ),
                    ],
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.timer_outlined, color: AppColors.primary, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              _buildRiderCard(order),
              const SizedBox(height: 32),
              _buildStatusTimeline(order),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRiderCard(Order order) {
    return Row(
      children: [
        CircleAvatar(radius: 28, backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=33')),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.riderName ?? 'Kwame A.', style: AppTypography.h3()),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('4.9 • Swift Elite', style: AppTypography.bodySm()),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
          icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => launchUrl(Uri(scheme: 'tel', path: '+233000000000')),
          icon: const Icon(Icons.phone_outlined, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildStatusTimeline(Order order) {
    return Column(
      children: [
        _buildTimelineItem('Order Placed', 'We have received your order', true, false),
        _buildTimelineItem('Confirmed', 'Store is preparing your order', order.status.index >= OrderStatus.accepted.index, false),
        _buildTimelineItem('Picked Up', 'Rider is on the way to you', order.status.index >= OrderStatus.pickedUp.index, false),
        _buildTimelineItem('Delivered', 'Order successfully delivered', order.status == OrderStatus.delivered, true),
      ],
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, bool isDone, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.success : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDone ? AppColors.success : AppColors.borderLight, width: 2),
                ),
                child: isDone ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: isDone ? AppColors.success : AppColors.borderLight)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.bold, color: isDone ? AppColors.textPrimary : AppColors.textMuted)),
                Text(subtitle, style: AppTypography.bodySm()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
