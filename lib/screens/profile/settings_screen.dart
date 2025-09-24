import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _locationServices = true;
  bool _biometricLogin = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'INR (₹)';

  final List<String> _languages = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Bengali'
  ];
  final List<String> _currencies = [
    'INR (₹)',
    'USD (\$)',
    'EUR (€)',
    'GBP (£)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                // App Preferences
                _buildSection(
                  'App Preferences',
                  [
                    _buildSwitchTile(
                      'Dark Mode',
                      'Switch between light and dark theme',
                      Icons.dark_mode,
                      _darkMode,
                      (value) {
                        setState(() {
                          _darkMode = value;
                        });
                        _showComingSoon();
                      },
                    ),
                    _buildSelectTile(
                      'Language',
                      'Choose your preferred language',
                      Icons.language,
                      _selectedLanguage,
                      () => _showLanguageDialog(),
                    ),
                    _buildSelectTile(
                      'Currency',
                      'Select your preferred currency',
                      Icons.monetization_on,
                      _selectedCurrency,
                      () => _showCurrencyDialog(),
                    ),
                  ],
                ),

                // Notifications
                _buildSection(
                  'Notifications',
                  [
                    _buildSwitchTile(
                      'Push Notifications',
                      'Receive notifications about orders',
                      Icons.notifications,
                      _pushNotifications,
                      (value) {
                        setState(() {
                          _pushNotifications = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      'Email Notifications',
                      'Receive email updates',
                      Icons.email,
                      _emailNotifications,
                      (value) {
                        setState(() {
                          _emailNotifications = value;
                        });
                      },
                    ),
                  ],
                ),

                // Privacy & Security
                _buildSection(
                  'Privacy & Security',
                  [
                    _buildSwitchTile(
                      'Location Services',
                      'Allow app to access your location',
                      Icons.location_on,
                      _locationServices,
                      (value) {
                        setState(() {
                          _locationServices = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      'Biometric Login',
                      'Use fingerprint or face ID to login',
                      Icons.fingerprint,
                      _biometricLogin,
                      (value) {
                        setState(() {
                          _biometricLogin = value;
                        });
                        _showComingSoon();
                      },
                    ),
                    _buildActionTile(
                      'Change Password',
                      'Update your account password',
                      Icons.lock,
                      () => _showChangePasswordDialog(),
                    ),
                  ],
                ),

                // Data & Storage
                _buildSection(
                  'Data & Storage',
                  [
                    _buildActionTile(
                      'Clear Cache',
                      'Free up space by clearing cached data',
                      Icons.cleaning_services,
                      () => _showClearCacheDialog(),
                    ),
                    _buildActionTile(
                      'Download Data',
                      'Download your personal data',
                      Icons.download,
                      () => _showComingSoon(),
                    ),
                  ],
                ),

                // Support
                _buildSection(
                  'Support',
                  [
                    _buildActionTile(
                      'Privacy Policy',
                      'Read our privacy policy',
                      Icons.privacy_tip,
                      () => _showComingSoon(),
                    ),
                    _buildActionTile(
                      'Terms of Service',
                      'Read our terms and conditions',
                      Icons.description,
                      () => _showComingSoon(),
                    ),
                    _buildActionTile(
                      'About',
                      'App version and information',
                      Icons.info,
                      () => _showAboutDialog(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryGreen,
      ),
    );
  }

  Widget _buildSelectTile(
    String title,
    String subtitle,
    IconData icon,
    String value,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Select Language',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) {
            return RadioListTile<String>(
              title: Text(language, style: GoogleFonts.inter()),
              value: language,
              groupValue: _selectedLanguage,
              activeColor: AppColors.primaryGreen,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Select Currency',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _currencies.map((currency) {
            return RadioListTile<String>(
              title: Text(currency, style: GoogleFonts.inter()),
              value: currency,
              groupValue: _selectedCurrency,
              activeColor: AppColors.primaryGreen,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Change Password',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                labelStyle: GoogleFonts.inter(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: GoogleFonts.inter(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                labelStyle: GoogleFonts.inter(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password changed successfully'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            child: Text('Change',
                style: GoogleFonts.inter(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Clear Cache',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text(
          'This will clear cached data to free up space. Your personal data will not be affected.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            child: Text('Clear',
                style: GoogleFonts.inter(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('About Swaad',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0', style: GoogleFonts.inter()),
            const SizedBox(height: 8),
            Text('Build: 100', style: GoogleFonts.inter()),
            const SizedBox(height: 16),
            Text(
              'Swaad is your campus food delivery companion, connecting you with the best food vendors on campus.',
              style: GoogleFonts.inter(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK',
                style: GoogleFonts.inter(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature coming soon!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}
