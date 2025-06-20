// lib/main.dart

import 'package:clothing_store/frontend/screens/faqs_screen.dart';
import 'package:clothing_store/frontend/screens/help_center_screen.dart';
import 'package:clothing_store/frontend/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:go_router/go_router.dart';

import '../firebase_options.dart';
import 'constants.dart'             as cst;                 // алиас для constants
import 'services/auth_service.dart';
import 'models/app_user.dart';
import 'models/product.dart';
import 'models/clothing_category.dart';
import 'screens/home.dart';
import 'screens/clothes_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_summary_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/map_screen.dart';
import 'screens/new_review_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/product_detail_page.dart';
import 'screens/product_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/not_found_screen.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final authNotifier = ValueNotifier<bool>(false);
final currentUser  = ValueNotifier<AppUser?>(null);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // читаем сохранённые настройки темы и акцента
  final prefs      = await SharedPreferences.getInstance();
  final isLight    = prefs.getBool('lightTheme') ?? true;
  final accentIdx  = prefs.getInt('accentColor') ?? 0;

  // слушаем авторизацию
  AuthService.authStateChanges().listen((fb.User? u) {
    authNotifier.value = u != null;
    currentUser.value  = u != null ? AppUser.fromFirebase(u) : null;
  });

  runApp(FashionHubApp(
    initialThemeIsLight: isLight,
    initialAccentIndex: accentIdx,
  ));
}

class FashionHubApp extends StatefulWidget {
  final bool initialThemeIsLight;
  final int  initialAccentIndex;

  const FashionHubApp({
    super.key,
    required this.initialThemeIsLight,
    required this.initialAccentIndex,
  });

  @override
  State<FashionHubApp> createState() => _FashionHubAppState();
}

class _FashionHubAppState extends State<FashionHubApp> {
  late ThemeMode _themeMode;
  late cst.ColorSelection _colorSelected;
  int _currentIndex = 0;
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeIsLight
        ? ThemeMode.light
        : ThemeMode.dark;
    _colorSelected = cst.ColorSelection.values[widget.initialAccentIndex];
  }
  void _changeLocale(Locale newLocale) => setState(() {
    _locale = newLocale;
  });

  Future<void> _changeTheme(bool useLight) async {
    setState(() => _themeMode = useLight ? ThemeMode.light : ThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lightTheme', useLight);
  }

  Future<void> _changeColor(int idx) async {
    setState(() => _colorSelected = cst.ColorSelection.values[idx]);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accentColor', idx);
  }

  void _onTab(int i) => setState(() => _currentIndex = i);

  late final GoRouter _router = GoRouter(
    refreshListenable: authNotifier,
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (ctx, state, child) {
          final loc = state.subloc;
          return Scaffold(
            appBar: AppBar(
              leading: loc != '/'
                  ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => ctx.pop(),
              )
                  : null,
              title: Text(_titleFor(loc)),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () => ctx.push('/notifications'),
                ),
              ],
            ),
            body: child,
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (i) {
                _onTab(i);
                switch (i) {
                  case 0: ctx.go('/'); break;
                  case 1: ctx.go('/clothes-screen'); break;
                  case 2: ctx.go('/cart'); break;
                  case 3: ctx.go('/order-summary'); break;
                  case 4: ctx.go('/profile'); break;
                }
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => HomeScreen(
              changeTheme: _changeTheme,
              changeColor: _changeColor,
              colorSelected: _colorSelected,
            ),
          ),
          GoRoute(
            path: '/clothes-screen',
            builder: (_, __) => const ClothesScreen(),
          ),
          GoRoute(path: '/cart',         builder: (_, __) => const CartScreen()),
          GoRoute(path: '/order-summary',builder: (_, __) => const OrderSummaryScreen()),
          GoRoute(path: '/profile',      builder: (_, __) => const ProfileScreen()),
          GoRoute(path: '/wishlist',     builder: (_, __) => const WishlistScreen()),
          GoRoute(path: '/map',          builder: (_, __) => const MapScreen()),
          // GoRoute(path: '/newreview',    builder: (_, __) => const NewReviewScreen(productId: '')),
          GoRoute(path: '/checkout',     builder: (_, __) => const CheckoutScreen()),
          GoRoute(path: '/faqs', builder: (_, __) => const FaqsScreen()),
          GoRoute(path: '/help', builder: (_, __) => const HelpCenterScreen()),
          GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
          GoRoute(
            path: '/settings',
            builder: (_, __) => SettingsScreen(
              themeMode: _themeMode,
              colorSelected: _colorSelected,
              currentLocale: _locale,                // ← прокидываем
              onThemeChanged: _changeTheme,
              onColorChanged: _changeColor,
              onLocaleChanged: _changeLocale,        // ← прокидываем
            ),
          ),
          GoRoute(path: '/login',   builder: (_, __) => const LoginScreen()),
          GoRoute(path: '/register',builder: (_, __) => const RegisterScreen()),
        ],
      ),

      // slide transition to product detail
      GoRoute(
        path: '/product',
        pageBuilder: (ctx, state) {
          final p = state.extra as Product;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProductDetailPage(product: p),
            transitionsBuilder: (ctx, anim, sec, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: anim,
                  curve: Curves.easeOut,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/category',
        builder: (ctx, state) {
          final cat = state.extra as ClothingCategory;
          return ProductDetailScreen(category: cat);
        },
      ),

    ],
    redirect: (ctx, state) {
      final loggedIn = authNotifier.value;
      final toLogin  = state.subloc == '/login';
      final toReg    = state.subloc == '/register';
      if (!loggedIn && ['/cart','/order-summary','/profile','/newreview']
          .contains(state.subloc)) return '/login';
      if (loggedIn && (toLogin || toReg)) return '/';
      return null;
    },
    errorBuilder: (_,__) => const NotFoundScreen(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Saints & Scars',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _colorSelected.color,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _colorSelected.color,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }

  String _titleFor(String loc) {
    switch (loc) {
      case '/':               return 'Saints & Scars';
      case '/clothes-screen': return 'Saints & Scars';
      case '/cart':           return 'My Cart';
      case '/order-summary':  return 'My Orders';
      case '/profile':        return 'Account';
      case '/wishlist':       return 'Wishlist';
      case '/map':            return 'Map';
      case '/newreview':      return 'Write a Review';
      case '/checkout':       return 'Checkout';
      case '/settings':       return 'Settings';
      case '/faqs':           return 'FAQs';
      case '/help':           return 'Help Center';
      case '/notifications':  return 'Notifications';
      default:                return '';
    }
  }
}
