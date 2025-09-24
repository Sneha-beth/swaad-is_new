import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../models/vendor_model.dart';
import '../../widgets/common/custom_button.dart';

class PickupSlotScreen extends StatefulWidget {
  final VendorModel vendor;
  final void Function(String)? onSlotSelected; // ✅ Direct inline function type

  const PickupSlotScreen({
    super.key,
    required this.vendor,
    this.onSlotSelected,
  });

  @override
  State<PickupSlotScreen> createState() => _PickupSlotScreenState();
}

class _PickupSlotScreenState extends State<PickupSlotScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedSlot;
  int _currentQueuePosition = 5;
  int _estimatedWaitTime = 15;

  final List<String> _days = ['Today', 'Tomorrow'];

  final Map<String, List<Map<String, dynamic>>> _timeSlots = {
    'Today': [
      {
        'time': 'ASAP',
        'subtitle': '15-20 min',
        'available': true,
        'popular': true
      },
      {
        'time': '12:00 PM',
        'subtitle': '12:00-12:30',
        'available': true,
        'popular': false
      },
      {
        'time': '12:30 PM',
        'subtitle': '12:30-1:00',
        'available': true,
        'popular': false
      },
      {
        'time': '1:00 PM',
        'subtitle': '1:00-1:30',
        'available': false,
        'popular': true
      },
      {
        'time': '1:30 PM',
        'subtitle': '1:30-2:00',
        'available': true,
        'popular': false
      },
      {
        'time': '2:00 PM',
        'subtitle': '2:00-2:30',
        'available': true,
        'popular': false
      },
      {
        'time': '2:30 PM',
        'subtitle': '2:30-3:00',
        'available': true,
        'popular': false
      },
      {
        'time': '3:00 PM',
        'subtitle': '3:00-3:30',
        'available': true,
        'popular': false
      },
      {
        'time': '3:30 PM',
        'subtitle': '3:30-4:00',
        'available': true,
        'popular': false
      },
      {
        'time': '4:00 PM',
        'subtitle': '4:00-4:30',
        'available': false,
        'popular': false
      },
    ],
    'Tomorrow': [
      {
        'time': '9:00 AM',
        'subtitle': '9:00-9:30',
        'available': true,
        'popular': false
      },
      {
        'time': '9:30 AM',
        'subtitle': '9:30-10:00',
        'available': true,
        'popular': false
      },
      {
        'time': '10:00 AM',
        'subtitle': '10:00-10:30',
        'available': true,
        'popular': true
      },
      {
        'time': '10:30 AM',
        'subtitle': '10:30-11:00',
        'available': true,
        'popular': false
      },
      {
        'time': '11:00 AM',
        'subtitle': '11:00-11:30',
        'available': true,
        'popular': false
      },
      {
        'time': '11:30 AM',
        'subtitle': '11:30-12:00',
        'available': true,
        'popular': true
      },
      {
        'time': '12:00 PM',
        'subtitle': '12:00-12:30',
        'available': true,
        'popular': false
      },
      {
        'time': '12:30 PM',
        'subtitle': '12:30-1:00',
        'available': true,
        'popular': false
      },
      {
        'time': '1:00 PM',
        'subtitle': '1:00-1:30',
        'available': true,
        'popular': false
      },
      {
        'time': '1:30 PM',
        'subtitle': '1:30-2:00',
        'available': true,
        'popular': false
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'Select Pickup Time',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Vendor Info Header
          _buildVendorHeader(),

          // Current Queue Status
          _buildQueueStatus(),

          // Date Tabs
          _buildDateTabs(),

          // Time Slots
          Expanded(
            child: _buildTimeSlots(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildVendorHeader() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          // Vendor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                image: DecorationImage(
                  image: AssetImage(widget.vendor.image),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: widget.vendor.image.startsWith('assets')
                  ? null
                  : const Icon(
                      Icons.restaurant,
                      color: AppColors.primaryGreen,
                      size: 25,
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Vendor Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vendor.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Prep time: ${widget.vendor.preparationTime} min',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.vendor.isOpen ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.vendor.isOpen ? 'OPEN' : 'CLOSED',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withValues(alpha: 0.1),
            AppColors.lightGreen.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.people,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Queue Status',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_currentQueuePosition orders ahead • ~$_estimatedWaitTime min wait',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Busy',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: _days.map((day) => Tab(text: day)).toList(),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return TabBarView(
      controller: _tabController,
      children: _days.map((day) {
        final slots = _timeSlots[day] ?? [];

        return AnimationLimiter(
          child: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              final slotKey = '${day}_${slot['time']}';

              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildTimeSlotCard(
                      slotKey,
                      slot['time'],
                      slot['subtitle'],
                      slot['available'],
                      slot['popular'],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeSlotCard(
    String slotKey,
    String time,
    String subtitle,
    bool available,
    bool popular,
  ) {
    final isSelected = _selectedSlot == slotKey;

    return GestureDetector(
      onTap: available
          ? () {
              setState(() {
                _selectedSlot = slotKey;
              });
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: !available
              ? AppColors.backgroundColor
              : isSelected
                  ? AppColors.primaryGreen
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: !available
                ? AppColors.borderColor
                : isSelected
                    ? AppColors.primaryGreen
                    : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Popular badge
            if (popular && available)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Popular',
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          time,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: !available
                                ? AppColors.textSecondary
                                : isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    available ? subtitle : 'Not Available',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: !available
                          ? AppColors.textSecondary
                          : isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedSlot != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: AppColors.primaryGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Selected: ${_selectedSlot!.split('_').last}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            CustomButton(
              text: 'Confirm Time Slot',
              onPressed: _selectedSlot != null
                  ? () {
                      // ✅ Simple and direct callback
                      final selectedSlot = _selectedSlot!;
                      widget.onSlotSelected?.call(selectedSlot);
                      Navigator.pop(context, selectedSlot);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
