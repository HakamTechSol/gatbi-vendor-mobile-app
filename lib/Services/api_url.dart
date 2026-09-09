class ApiUrls {
  ApiUrls._();

  static const String baseUrl = 'https://gatbi.ae/api/mobile/';

  // Auth
  static const String register = 'vendor/auth/register';
  static const String verifyOtp = 'vendor/auth/verify-otp';
  static const String login = 'vendor/auth/login';
  static const String forgotPassword = 'vendor/auth/forgot-password';
  static const String resetPassword = 'vendor/auth/reset-password';
  static const String resendOtp = 'vendor/auth/resend-otp';
  static const String logout = 'vendor/auth/logout';

  // Vendor
  static const String me = 'vendor/me';

  // Dashboard
  static const String dashboard = 'vendor/dashboard';

  // Products
  static const String products = 'vendor/products';

  static String product(int id) => 'vendor/products/$id';

  static String updateProduct(int id) => 'vendor/products/$id/update';

  static String deleteProduct(int id) => 'vendor/products/$id/delete';

  static String updateStock(int id) => 'vendor/products/$id/stock';

  static const String translateProduct = 'vendor/products/translate';

  static String translateExistingProduct(int id) =>
      'vendor/products/$id/translate';

  // Attributes / Variants
  static const String attributes = 'vendor/attributes';

  static String productVariants(int productId) =>
      'vendor/products/$productId/variants';

  static String createVariant(int productId) =>
      'vendor/products/$productId/variants';

  static String updateVariant(int productId, int variantId) =>
      'vendor/products/$productId/variants/$variantId/update';

  static String deleteVariant(int productId, int variantId) =>
      'vendor/products/$productId/variants/$variantId/delete';

  // Bulk Import
  static const String sampleCsv = 'vendor/products/import/sample-csv';

  static const String templateXlsx = 'vendor/products/import/template-xlsx';

  static const String importProducts = 'vendor/products/import';

  static const String startImport = 'vendor/products/import/start';

  static const String processImport = 'vendor/products/import/process';

  // Orders
  static const String orders = 'vendor/orders';

  static String order(int id) => 'vendor/orders/$id';

  static String updateOrderStatus(int id) => 'vendor/orders/$id/status';

  static String verifyPaymentProof(int id) =>
      'vendor/orders/$id/payment-proof/verify';

  static String rejectPaymentProof(int id) =>
      'vendor/orders/$id/payment-proof/reject';

  // KYC
  static const String kyc = 'vendor/kyc';

  static const String submitKyc = 'vendor/kyc/submit';

  // Chat
  static const String chats = 'vendor/chats';

  static String chat(int id) => 'vendor/chat/$id';

  static String sendChatMessage(int id) => 'vendor/chat/$id/message';

  // Tickets
  static const String tickets = 'vendor/tickets';

  static String ticket(int id) => 'vendor/tickets/$id';

  static String replyTicket(int id) => 'vendor/tickets/$id/reply';

  // Reviews
  static const String reviews = 'vendor/reviews';

  static const String reviewsSummary = 'vendor/reviews/summary';

  static String review(int id) => 'vendor/reviews/$id';

  // Payouts
  static const String payouts = 'vendor/payouts';

  static const String eligiblePayout = 'vendor/payouts/eligible';

  static String payout(int id) => 'vendor/payouts/$id';

  static const String requestPayout = 'vendor/payouts/request';

  // Settings
  static const String settings = 'vendor/settings';

  static const String updateProfile = 'vendor/settings/profile';

  static const String updateBusiness = 'vendor/settings/business';

  static const String updateBank = 'vendor/settings/bank';

  static const String changePassword = 'vendor/settings/password';

  static const String preferences = 'vendor/settings/preferences';
}
