import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Core/Bottom Naigation Bar/bottom_bar_screen.dart';
import '../Core/Bottom Naigation Bar/bottom_bar_navigation.dart';
import '../Features/Add Product/Screens/add_product_screen.dart';
import '../Features/Authentication/Email Verification OTP/email_otp_verification_screen.dart';
import '../Features/Authentication/Forget Password/Screens/forget_password_Screen.dart';
import '../Features/Authentication/Forget Verification OTP/forget_verification_otp.dart';
import '../Features/Authentication/Login Verification OTP/Screens/login_verification_otp_screen.dart';
import '../Features/Authentication/Login/Screens/login_screen.dart';
import '../Features/Authentication/Registration/Screen/registration_screen.dart';
import '../Features/Authentication/Rest Password/reset_password_screen.dart';
import '../Features/Bulk Imort/Screens/bulk_import_screen.dart';
import '../Features/Campaign/Screens/campaigns_screen.dart';
import '../Features/Change Password/Screens/change_password_screen.dart';
import '../Features/Chat/Screens/chat_detail_screen.dart';
import '../Features/Chat/Screens/chat_list_screen.dart';
import '../Features/Dashboard/dashboard_screen.dart';
import '../Features/Edit Product/edit_product_screen.dart';
import '../Features/More/more_screen.dart';
import '../Features/My Product/Models/my_product_model.dart';
import '../Features/My Product/my_products_screen.dart';
import '../Features/Onboarding/onboarding_screen.dart';
import '../Features/Order/Order Detail/Models/order_detail_model.dart';
import '../Features/Order/Order Detail/screens/order_detail_screen.dart';
import '../Features/Order/Order List/screens/orders_screen.dart';
import '../Features/Product Detail/Model/product_detail_model.dart';
import '../Features/Product Detail/Screens/product_detail_screen.dart';
import '../Features/Splash/splash_screen.dart';
import '../Features/Support/screen/create_support_ticket_screen.dart';
import '../Features/Support/screen/support_screen.dart';
import '../Features/Ticket/Create Ticket/create_ticket_screen.dart';
import '../Features/Ticket/Detail ticket/ticket_detail_screen.dart';
import '../Features/Ticket/List Ticket/ticket_list_screen.dart';
import '../Features/Ticket/Models/create_ticket_model.dart';
import '../Features/Ticket/Models/ticket_model.dart';
import '../Features/analytics/Screens/analytics_screen.dart';

abstract final class AppRoutes {
  AppRoutes._();

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTE NAMES
  // ═══════════════════════════════════════════════════════════════════════════

  static const String splash = '/';

  static const String onboarding = '/onboarding';

  static const String login = '/login';

  static const String register = '/register';

  static const String emailotpVerification = '/email-otp-verification';

  static const String loginotpVerification = '/login-otp-verification';

  static const String forgotPassword = '/forgot-password';

  static const String forgetotpVerification = '/forget-otp-verification';

  static const String resetPassword = '/reset-password';

  static const String changePassword = '/change-password';

  static const String bottombar = '/bottombar';

  static const String dashboard = '/dashboard';

  static const String products = '/products';

  static const String orders = '/orders';

  static const String orderDetail = '/orders/detail';

  static const String profile = '/profile';

  static const String chatList = '/chat-list';

  static const String chatDetail = '/chat-detail';

  static const String editProduct = '/products/edit';

  static const String addProduct = '/products/create';

  static const String productDetail = '/products/detail';

  static const String bulkImport = '/products/bulk-import';

  static const String supportTickets = '/support-tickets';

  static const String ticketDetail = '/support-tickets/detail';

  static const String createTicket = '/support-tickets/create';

  static const String support = '/support';

  static const String createSupportTicket = '/support/create';

  static const String campaigns = '/campaigns';

  static const String analytics = '/analytics';

  static const String more = '/more';
}

// ═════════════════════════════════════════════════════════════════════════════
// APP ROUTER
// ══════════════════════

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,

  debugLogDiagnostics: true,

  routes: [
    // ═══════════════════════════════════════════════════════════════════════
    // SPLASH
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // ONBOARDING
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // LOGIN
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginScreen(
          onRegister: () {
            context.push(AppRoutes.register);
          },

          onForgotPassword: () {
            context.push(AppRoutes.forgotPassword);
          },
        );
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // REGISTER
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (BuildContext context, GoRouterState state) {
        return RegisterScreen(
          onBackToLogin: () {
            context.go(AppRoutes.login);
          },
        );
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // EMAIL VERIFICATION REGISTER
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.emailotpVerification,
      name: 'emailotpVerification',
      builder: (BuildContext context, GoRouterState state) {
        final email = state.extra as String;

        return EmailOtpVerificationScreen(
          email: email,

          onVerifyOtp: (otp) async {
            debugPrint('OTP: $otp');
            debugPrint('EMAIL: $email');

            // API verification here
          },

          onResendOtp: () async {
            debugPrint('Resend OTP for: $email');

            // Resend OTP API here
          },

          onBack: () {
            context.pop();
          },
        );
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // LOGIN VERIFICATION
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
  path: AppRoutes.loginotpVerification,
  name: 'loginotpVerification',
  builder: (context, state) {
    final extra = state.extra;

    final data = extra is Map
        ? Map<String, dynamic>.from(extra)
        : <String, dynamic>{};

    final email = data['email'] as String? ?? '';
    final merchantId = data['merchant_id'] as int? ?? 0;
    final expiresInMinutes = data['expires_in_minutes'] as int? ?? 0;

    return LoginOtpVerificationScreen(
      email: email,
      merchantId: merchantId,
      expiresInMinutes: expiresInMinutes,
    );
  },
),

    // ═══════════════════════════════════════════════════════════════════════
    // FORGET PASSWORD
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgot-password',
      builder: (BuildContext context, GoRouterState state) {
        return ForgotPasswordScreen(
          onBackToLogin: () {
            context.go(AppRoutes.login);
          },
        );
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // FORGET VERIFICATION
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.forgetotpVerification,
      name: 'forgetotpVerification',
      builder: (BuildContext context, GoRouterState state) {
        final email = state.extra as String;

        return ForgetOtpVerificationScreen(
          email: email,

          onVerifyOtp: (otp) async {
            debugPrint('OTP: $otp');
            debugPrint('EMAIL: $email');

            // API verification here
          },

          onResendOtp: () async {
            debugPrint('Resend OTP for: $email');

            // Resend OTP API here
          },

          onBack: () {
            context.pop();
          },
        );
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // REST PASSWORD
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.resetPassword,
      name: 'reset-password',
      builder: (BuildContext context, GoRouterState state) {
        final token = state.uri.queryParameters['token'] ?? '';

        return ResetPasswordScreen(
          token: token,
          onBackToLogin: () {
            context.go(AppRoutes.login);
          },
          onResetPassword: (token, password, passwordConfirmation) async {
            // API call yahan later connect karenge.
            debugPrint('Reset Token: $token');
            debugPrint('Password: $password');
            debugPrint('Password Confirmation: $passwordConfirmation');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.bottombar,
      name: 'bottombar',
      builder: (context, state) {
        final initialTab = state.extra is BottomTab
            ? state.extra as BottomTab
            : BottomTab.dashboard;

        return BottomMainScreen(initialTab: initialTab);
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // CHANGE PASSWORD
    // ═══════════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.changePassword,
      name: 'change-password',
      builder: (context, state) {
        return ChangePasswordScreen(
          onBack: () {
            context.pop();
          },

          onPasswordChanged: () {
            // API / Riverpod will be connected later.
            debugPrint('Password changed successfully');
          },
        );
      },
    ),

    // Dashboard
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) {
        return const DashboardScreen();
      },
    ),

    // Products
    GoRoute(
      path: AppRoutes.products,
      name: 'products',
      builder: (context, state) {
        return const MyProductScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.addProduct,
      name: 'add-product',
      builder: (context, state) {
        return const AddProductScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.editProduct,
      name: 'edit-product',
      builder: (context, state) {
        final extra = state.extra;

        if (extra is! MyProductModel) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Product data is missing.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        return EditProductScreen(product: extra);
      },
    ),

    GoRoute(
      path: AppRoutes.productDetail,
      name: 'product-detail',
      builder: (context, state) {
        final product = state.extra as ProductDetailModel;

        return ProductDetailScreen(
          product: product,
          onEdit: () {
            final myProduct = MyProductModel(
              id: product.id,
              name: product.productName,
              price: product.price ?? 0,
              originalPrice: product.compareAtPrice,
              stockQuantity: product.stock,
              status: product.status,
              imageUrl: product.images.isNotEmpty ? product.images.first : '',
              category: product.categoryName ?? 'Uncategorized',
              inStock: product.stock > 0,
              sku: product.sku,
              createdAt: product.createdAt,
            );

            context.push(AppRoutes.editProduct, extra: myProduct);
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.bulkImport,
      name: 'bulk-import',
      builder: (context, state) {
        return const BulkImportScreen();
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // SUPPORT TICKETS
    // ═══════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.supportTickets,
      name: 'support-tickets',
      builder: (context, state) {
        return TicketListScreen(
          onCreateTicket: () {
            context.push(AppRoutes.createTicket);
          },

          onTicketTap: (ticket) {
            context.push(AppRoutes.ticketDetail, extra: ticket);
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.ticketDetail,
      name: 'ticket-detail',
      builder: (context, state) {
        final extra = state.extra;

        if (extra is! TicketModel) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Ticket data is missing.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        return TicketDetailScreen(
          ticket: extra,

          onBack: () {
            context.pop();
          },

          onCreateTicket: () {
            context.push(AppRoutes.createTicket);
          },

          onSendReply: (message) {
            // API will be connected later.
            debugPrint('Ticket ID: ${extra.id}');
            debugPrint('Reply: $message');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createTicket,
      name: 'create-ticket',
      builder: (context, state) {
        return CreateTicketScreen(
          onBack: () {
            context.pop();
          },

          onSubmit: (CreateTicketModel ticket) {
            // API will be connected later.
            debugPrint('Create Ticket');
            debugPrint('Subject: ${ticket.subject}');
            debugPrint('Category: ${ticket.category}');
            debugPrint('Priority: ${ticket.priority}');
            debugPrint('Message: ${ticket.message}');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.campaigns,
      name: 'campaigns',
      builder: (context, state) {
        return const CampaignsScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.chatList,
      name: 'chat-list',
      builder: (context, state) {
        return const ChatListScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.chatDetail,
      name: 'chat-detail',
      builder: (context, state) {
        return const ChatDetailScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.analytics,
      name: 'analytics',
      builder: (context, state) {
        return AnalyticsScreen(
          onProductsTap: () {
            context.push(AppRoutes.bottombar, extra: BottomTab.products);
          },
        );
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // SUPPORT
    // ═══════════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.support,
      name: 'support',
      builder: (context, state) {
        return SupportScreen(
          onBack: () {
            context.pop();
          },

          onCustomerChatTap: () {
            context.push(AppRoutes.chatList);
          },

          onCampaignsTap: () {
            context.push(AppRoutes.campaigns);
          },

          onKycTap: () {
            // KYC route will be connected here.
            debugPrint('KYC tapped');
          },

          onOrdersTap: () {
            context.push(AppRoutes.orders);
          },

          onPaymentsTap: () {
            debugPrint('Payments & payouts tapped');
          },

          onCampaignRequestTap: () {
            context.push(AppRoutes.campaigns);
          },

          onAnalyticsTap: () {
            context.push(AppRoutes.analytics);
          },

          onProductsTap: () {
            context.push(AppRoutes.products);
          },

          onSettingsTap: () {
            // Settings route will be connected here.
            debugPrint('Settings tapped');
          },

          onCreateTicketTap: () {
            context.push(AppRoutes.createSupportTicket);
          },

          onEmailTap: () {
            debugPrint('Support email tapped');
            // mailto will be connected here.
          },

          onPhoneTap: () {
            debugPrint('Support phone tapped');
            // tel will be connected here.
          },

          onWhatsAppTap: () {
            debugPrint('WhatsApp support tapped');
            // WhatsApp deep link will be connected here.
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createSupportTicket,
      name: 'create-support-ticket',
      builder: (context, state) {
        return CreateSupportTicketScreen(
          onBack: () {
            context.pop();
          },

          onSubmit:
              ({
                required String subject,
                required String message,
                required String priority,
              }) async {
                // API will be connected later.
                debugPrint('Create Support Ticket');
                debugPrint('Subject: $subject');
                debugPrint('Message: $message');
                debugPrint('Priority: $priority');
              },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.more,
      name: 'more',
      builder: (context, state) {
        return MoreScreen(
          onOrders: () {
            context.push(AppRoutes.orders);
          },

          onBulkProducts: () {
            context.push(AppRoutes.bulkImport);
          },

          onTickets: () {
            context.push(AppRoutes.supportTickets);
          },

          onCampaigns: () {
            context.push(AppRoutes.campaigns);
          },

          onAnalytics: () {
            context.push(AppRoutes.analytics);
          },

          onSupport: () {
            context.push(AppRoutes.support);
          },

          onChangePassword: () {
            context.push(AppRoutes.changePassword);
          },
        );
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // ORDERS
    // ═══════════════════════════════════════════════════════════════════════════
    GoRoute(
      path: AppRoutes.orders,
      name: 'orders',
      builder: (context, state) {
        return OrdersScreen(
          onOrderTap: (order) {
            final detailOrder = OrderDetailModel.fromJson({
              ...order.toJson(),
              'items': order.items.map((item) => item.toJson()).toList(),
              'timeline': [],
              'payment': null,
              'shipping_address': null,
              'billing_address': null,
              'notes': null,
              'payment_proof_url': null,
            });

            context.push(AppRoutes.orderDetail, extra: detailOrder);
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.orderDetail,
      name: 'order-detail',
      builder: (context, state) {
        final extra = state.extra;

        if (extra is! OrderDetailModel) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Order data is missing.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        return OrderDetailScreen(
          order: extra,
          onBack: () {
            context.pop();
          },
          onRefresh: () {
            debugPrint('Refresh Order: ${extra.orderNumber}');
          },
        );
      },
    ),

    // Profile
    // GoRoute(
    //   path: AppRoutes.profile,
    //   name: 'profile',
    //   builder: (context, state) {
    //     return const ProfileScreen();
    //   },
    // ),
  ],

  // ═════════════════════════════════════════════════════════════════════════
  // ERROR PAGE
  // ═════════════════════════════════════════════════════════════════════════
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red,
              ),

              const SizedBox(height: 16),

              const Text(
                'Page Not Found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 8),

              Text(
                state.uri.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.splash);
                },
                child: const Text('Go to Splash'),
              ),
            ],
          ),
        ),
      ),
    );
  },
);
