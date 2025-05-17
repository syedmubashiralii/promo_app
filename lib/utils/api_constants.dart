class ApiConstants {
  static const String baseUrl = 'https://routineapp.bsite.net/';
  static const String login = '/login';
  static const String updaterUser = 'api/User/userDetails';
  static const String register = '/register';
  static const String forgotEmail = 'api/User/forgot-password';
  static const String forgotPassword = 'api/User/reset-password';
  static const String deleteUser = 'api/User/';
  static const String createPlan = 'api/Plan';
  static const String getUserPlan = 'api/Plan/userPlans';
  static const String searchPlan = 'api/Plan/search';
  static const String getMood = 'api/Mood/getByUserId';
  static const String addMood = 'api/Mood';
  static const String product = 'api/Product';
  static const String checkProductStock = 'api/Order/check-product-stock';
  static const String placeOrder = 'api/Order/placeOrder';
  static const String trackOrder = 'api/Order/trackOrder';
  static const String getAllOrder = 'api/Order/userOrders';
  static const String claimReward = 'api/Plan/claim-rewards';
  static const String setPlanProgressStatus =
      'api/PlanProgress/setPlanProgressStatus';
}
