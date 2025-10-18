import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/get_middle_ware.dart';
import 'package:kaseapp_ui/views/account_view.dart';
import 'package:kaseapp_ui/views/home_view.dart';
import 'package:kaseapp_ui/views/login_view.dart';
import 'package:kaseapp_ui/views/main_view.dart';
import 'package:kaseapp_ui/views/market_view.dart';
import 'package:kaseapp_ui/views/pre_order_front_view.dart';
import 'package:kaseapp_ui/views/pre_order_view.dart';
import 'package:kaseapp_ui/views/receive_preorder_view.dart';
import 'package:kaseapp_ui/views/register_view.dart';
import 'package:kaseapp_ui/views/splash_screen_view.dart';
import 'package:kaseapp_ui/views/summaryview.dart';
import 'package:kaseapp_ui/views/track_view.dart';
import 'package:kaseapp_ui/views/vendor_front_view.dart';
import 'package:kaseapp_ui/views/upgraderole_view.dart';
import 'package:kaseapp_ui/views/farmer_request_view.dart';
import 'package:kaseapp_ui/views/vendor_receive_order_view.dart';
import 'package:kaseapp_ui/views/vendor_request_view.dart';
import 'package:kaseapp_ui/widgets/vendorpreorderview.dart';


class AppRoutes {
  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Main App
  static const String mainView = '/main';
  static const String home = '/home';
  static const String account = '/account-view';
  static const String splash = '/splash'; 

  // Features
  static const String marketView = '/market';
  static const String vendorFrontView = '/vendor-front';
  static const String track = '/track';
  static const String farmerFrontView = '/farmer-front';

  // vendor role
  static const String vendorOrders = '/vendor-orders';
  static const String preOrderFrontView = '/pre-order/frontview';
  static const String vendorProducts = '/vendor-products';
  static const String vendorFilterStatus = '/vendor-filter-status';

  // Upgrade role
  static const String upgradeRole = '/upgrade-role';
  static const String farmerRequest = '/upgrade-role/farmer';
  static const String vendorRequest = '/upgrade-role/vendor';

  static const String SummaryView = '/view-summary';
  static const String retriveOrder = '/order/details';
  static const String orderRespond = '/order-details/listing';
  // Generate GetPages
static List<GetPage> generateRoutes = [
  // Root route
  GetPage(
    name: '/',
    page: () => const MainView(),
    middlewares: [AuthMiddleware()],
  ),

  // Auth routes
  GetPage(name: splash, page: () => SplashScreenView()),
  GetPage(name: login, page: () => LoginView()),
  GetPage(name: register, page: () => RegisterTestView()),
  GetPage(name: marketView, page: ()=>MarketView()),

  // Track view accessible to all
  GetPage(name: track, page: () => const TrackView()),

  // Main App routes
  GetPage(
    name: home,
    page: () => const HomePage(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: account,
    page: () => AccountView(),
    middlewares: [AuthMiddleware()],
  ),

  // Vendor-specific routes
  GetPage(
    name: vendorFrontView,
    page: () => const VendorFrontView(),
    middlewares: [AuthMiddleware(roleGuard: ['vendor'])],
  ),
  GetPage(
    name: vendorOrders,
    page: () => const PreOrderRequestView(),
    middlewares: [AuthMiddleware(roleGuard: ['vendor'])],
  ),
  GetPage(
    name: preOrderFrontView, 
    page: ()=>const PreOrderFrontView(),
    middlewares: [AuthMiddleware(roleGuard: ['vendor'])]
    ),

  GetPage(
    name: orderRespond,
    page: () =>  VendorReceiveOrderView(),
    middlewares: [AuthMiddleware()],
  ),


  //**
  // Authenticated Routes
  // */
  GetPage(
    name: SummaryView,
    page: () => NotificationSummaryView(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: vendorFilterStatus,
    page: () => const VendorPreOrderView(),
    middlewares: [AuthMiddleware()],
  ),
  
  GetPage(
    name: retriveOrder,
    page: () => ReceivePreorderView(),
    middlewares: [AuthMiddleware()],
  ),

  // Upgrade role routes
  GetPage(
    name: upgradeRole,
    page: () => UpgradeRoleView(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: farmerRequest,
    page: () => FarmerRequestView(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: vendorRequest,
    page: () => VendorRequestView(),
    middlewares: [AuthMiddleware()],
  ),
];

}
