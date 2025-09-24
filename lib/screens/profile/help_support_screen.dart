import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  String _selectedCategory = 'General Inquiry';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General Inquiry',
    'Order Issues',
    'Payment Problems',
    'Account Issues',
    'App Bugs',
    'Feature Request',
  ];

  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'How do I place an order?',
      'answer':
          'Browse vendors, select items, add to cart, and proceed to checkout. Choose your pickup time and payment method to complete the order.',
      'isExpanded': false,
    },
    {
      'question': 'What payment methods are accepted?',
      'answer':
          'We accept Wallet payments, UPI, Credit/Debit cards, and Cash on Pickup for your convenience.',
      'isExpanded': false,
    },
    {
      'question': 'How do I track my order?',
      'answer':
          'Go to the Orders tab to view real-time order status. You\'ll receive notifications about order updates.',
      'isExpanded': false,
    },
    {
      'question': 'Can I cancel my order?',
      'answer':
          'Orders can be cancelled within 2 minutes of placing. After that, please contact the vendor directly.',
      'isExpanded': false,
    },
    {
      'question': 'How do I add money to my wallet?',
      'answer':
          'Go to Profile > Wallet > Add Money. Choose your preferred payment method and amount to top up.',
      'isExpanded': false,
    },
    {
      'question': 'What if my order is delayed?',
      'answer':
          'Check the order tracking screen for updates. If significantly delayed, contact the vendor or our support team.',
      'isExpanded': false,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

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
          'Help & Support',
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
                // Contact Options
                _buildContactOptions(),

                // FAQ Section
                _buildFAQSection(),

                // Contact Form
                _buildContactForm(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactOptions() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get Quick Help',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  'Call Us',
                  'Talk to support',
                  Icons.phone,
                  Colors.green,
                  () => _makePhoneCall(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildContactCard(
                  'Chat',
                  'Live chat support',
                  Icons.chat,
                  Colors.blue,
                  () => _startLiveChat(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  'Email',
                  'Send us an email',
                  Icons.email,
                  Colors.orange,
                  () => _sendEmail(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildContactCard(
                  'WhatsApp',
                  'Message on WhatsApp',
                  Icons.message,
                  Colors.green.shade600,
                  () => _openWhatsApp(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
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
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _faqItems[index]['isExpanded'] = !isExpanded;
                });
              },
              elevation: 0,
              dividerColor: AppColors.borderColor,
              children: _faqItems.map<ExpansionPanel>((item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        item['question'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item['answer'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  isExpanded: item['isExpanded'],
                  canTapOnHeader: true,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send us a Message',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Category Dropdown
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: GoogleFonts.inter(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryGreen),
              ),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category, style: GoogleFonts.inter()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),

          const SizedBox(height: 16),

          // Message TextField
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Your Message',
              labelStyle: GoogleFonts.inter(color: AppColors.textSecondary),
              hintText: 'Describe your issue or question...',
              hintStyle: GoogleFonts.inter(
                  color: AppColors.textSecondary.withValues(alpha: 0.7)),
              filled: true,
              fillColor: AppColors.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryGreen),
              ),
            ),
            style: GoogleFonts.inter(),
          ),

          const SizedBox(height: 20),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Send Message',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Response Time Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'We typically respond within 24 hours during business days.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.phone, color: Colors.white),
            const SizedBox(width: 8),
            const Expanded(child: Text('Calling support: +91 98765 43210')),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        action: SnackBarAction(
          label: 'Call',
          textColor: Colors.white,
          onPressed: () {
            // Implement actual phone call functionality
          },
        ),
      ),
    );
  }

  void _startLiveChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live chat feature coming soon!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _sendEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email app...'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _openWhatsApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening WhatsApp...'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _submitMessage() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your message'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Message sent successfully! We\'ll get back to you soon.'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    _messageController.clear();
  }
}
