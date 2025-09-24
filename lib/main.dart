import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'services/wallet_service.dart';
import 'services/order_service.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => WalletService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
      ],
      child: const SwaadApp(),
    ),
  );
}

class SwaadApp extends StatelessWidget {
  const SwaadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swaad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primaryGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.errorRed),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
          ),
          labelStyle: GoogleFonts.inter(color: AppColors.textSecondary),
          hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: const AppWrapper(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/main': (context) => const MainNavigationScreen(),
      },
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeServices();
    });
  }

  Future<void> _initializeServices() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.initialize();

      OrderService.initializeDummyOrders();

      final walletService = Provider.of<WalletService>(context, listen: false);
      if (walletService.balance == 0) {
        walletService.addMoney(1000.0, 'Initial Balance');
      }
    } catch (e) {
      debugPrint('Service initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return FutureBuilder<bool>(
          future: _checkFirstTime(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen();
            }

            final isFirstTime = snapshot.data ?? false;

            if (isFirstTime) {
              return const WelcomeScreen();
            } else {
              if (authService.isLoggedIn) {
                return const MainNavigationScreen();
              } else {
                return const WelcomeScreen();
              }
            }
          },
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.restaurant,
                color: AppColors.primaryGreen,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Swaad',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Campus Food Delivery',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: AppColors.primaryGreen,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkFirstTime() async {
    try {
      return await AuthService.isFirstTime();
    } catch (e) {
      debugPrint('Error checking first time: $e');
      return false;
    }
  }
}
