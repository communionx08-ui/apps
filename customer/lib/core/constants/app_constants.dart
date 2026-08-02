class AppConstants {
  AppConstants._();

  // ── App identity ───────────────────────────────────────────────────────────
  static const String appName = 'Swift';
  static const String currency = '₵';
  static const String currencyCode = 'GHS';

  // ── API (filled in by backend team) ────────────────────────────────────────
  static const String apiBaseUrl = 'https://api.Swift.com/v1';
  static const String apiStagingUrl = 'https://staging-api.Swift.com/v1';

  // ── Asset paths — images ───────────────────────────────────────────────────
  static const String userPlaceholder = 'assets/images/user_placeholder.png';
  static const String loginGif = 'assets/images/login.gif';
  static const String locationGif = 'assets/images/location.gif';
  static const String foodDeliveryGif = 'assets/images/food_delivery.gif';
  static const String foodDeliveryPng = 'assets/images/food_delivery.png';
  static const String voiceWaveGif = 'assets/images/voice_wave.gif';
  static const String walletImg = 'assets/images/wallet.png';
  static const String referFriendImg = 'assets/images/refer_friend.png';
  static const String offerGif = 'assets/images/offer_gif.gif';
  static const String getStartedBg = 'assets/images/get_started_bg.png';

  // ── Asset paths — map markers ──────────────────────────────────────────────
  static const String mapDeliveryMarker = 'assets/images/food_delivery.png';
  static const String mapPickupMarker = 'assets/images/pickup.png';
  static const String mapDropoffMarker = 'assets/images/dropoff.png';

  // ── Asset paths — icons helper ─────────────────────────────────────────────
  static String icon(String name) => 'assets/icons/$name';

  // ── Map config (OpenStreetMap — no key needed) ─────────────────────────────
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String osmUserAgent = 'Swift.app';

  // ── Default location (Kumasi, Ghana) ──────────────────────────────────────
  static const double defaultLat = 6.6884;
  static const double defaultLng = -1.6244;
  static const String defaultLocationName = 'Kumasi, Ghana';

  // ── Delivery / fee config ─────────────────────────────────────────────────
  static const double deliveryFeeDefault = 5.00;
  static const double serviceFee = 2.50;
  static const double errandFee = 15.00;
  static const int estimatedMinMin = 15;
  static const int estimatedMinMax = 45;

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int pageSize = 10;

  // ── Animation durations ───────────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animPageTransition = Duration(milliseconds: 350);

  // ── SharedPreferences keys ────────────────────────────────────────────────
  static const String prefKeyOnboardingDone = 'Swift_onboarding_done';
  static const String prefKeyUserLoggedIn = 'Swift_user_logged_in';
  static const String prefKeyUserToken = 'Swift_user_token';
  static const String prefKeyUserId = 'Swift_user_id';
  static const String prefKeyUserName = 'Swift_user_name';
  static const String prefKeyUserPhone = 'Swift_user_phone';
  static const String prefKeyUserEmail = 'Swift_user_email';
  static const String prefKeyUserAvatar = 'Swift_user_avatar';
  static const String prefKeyFavourites = 'Swift_favourites';
  static const String prefKeySearchHistory = 'Swift_search_history';

  // ── Named routes ─────────────────────────────────────────────────────────
  static const String routeWelcome = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeGetStarted = '/get-started';
  static const String routeHome = '/home';
  static const String routeProfile = '/profile';
  static const String routeOrders = '/orders';
  static const String routeWallet = '/wallet';
  static const String routeNotifications = '/notifications';
  static const String routeSearch = '/search';
  static const String routeCheckout = '/checkout';
  static const String routeOrderTracking = '/order-tracking';
  static const String routeChat = '/chat';
}
