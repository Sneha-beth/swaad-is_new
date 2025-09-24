// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  String _userPhone = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await AuthService.getUserData();
    setState(() {
      _userName = userData['name'] ?? 'User';
      _userPhone = userData['phone'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with error handling
          _buildBackgroundImage(),

          // Overlay to make text more readable
          Container(
            color: Colors.black
                .withValues(alpha: 0.4), // Updated to use withValues
          ),

          // Top app bar with logout
          _buildTopAppBar(),

          // Foreground content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message with user name
                _buildWelcomeText(),

                const SizedBox(height: 12),

                // App description
                Text(
                  "Say goodbye to long queues! Order your snacks & meals instantly, pay through your campus wallet, and enjoy vendor discounts on the go.",
                  style: GoogleFonts.inter(
                    // Using project's font
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 40),

                // Action buttons
                _buildActionButtons(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/fastfood_bg.jpg', // cafeteria/fast food background
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback gradient if image is missing
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryGreen,
                AppColors.darkGreen,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopAppBar() {
    return SafeArea(
      child: Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // App logo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 24,
                      );
                    },
                  ),
                ),
              ),

              // Logout button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () => _showLogoutDialog(),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _userName.isNotEmpty ? "Welcome back," : "Welcome to",
          style: GoogleFonts.inter(
            // Using project's font
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Text(
              _userName.isNotEmpty ? _userName : "Swaad!",
              style: GoogleFonts.inter(
                // Using project's font
                color: AppColors.primaryGreen, // Using project's color
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_userName.isNotEmpty)
              Text(
                "!",
                style: GoogleFonts.inter(
                  color: AppColors.primaryGreen,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Browse Menu Button (Primary)
        CustomButton(
          text: "Browse Menu",
          onPressed: () => _showComingSoon("Menu"),
        ),

        const SizedBox(height: 16),

        // Secondary buttons row
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: "My Orders",
                onPressed: () => _showComingSoon("Orders"),
                isOutlined: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: "Wallet",
                onPressed: () => _showComingSoon("Wallet"),
                isOutlined: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                try {
                  await AuthService.logout();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    _showError('Logout failed. Please try again.');
                  }
                }
              },
              child: Text(
                'Logout',
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature feature is coming soon!',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
