import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egphysio_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart' hide errorColor;
import 'package:egphysio_clinic_admin/components/cached_image_widget.dart';
import 'package:egphysio_clinic_admin/components/app_primary_widget.dart';
import 'package:egphysio_clinic_admin/utils/colors.dart';
import 'package:flutter/services.dart';

import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../clinic_detail_screen.dart';
import '../model/clinics_res_model.dart';

class ClinicComponent extends StatefulWidget {
  final ClinicData clinicData;
  final void Function()? onEditClick;
  final void Function()? onDeleteClick;
  const ClinicComponent({Key? key, this.onEditClick, this.onDeleteClick, required this.clinicData}) : super(key: key);

  @override
  State<ClinicComponent> createState() => _ClinicComponentState();
}

class _ClinicComponentState extends State<ClinicComponent> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extract phone from the contactNumber field or directly from the raw data
    String phoneNumber = widget.clinicData.phone ?? widget.clinicData.contactNumber;
    
    // Get status - either from the status field as integer or from a string
    bool isActive = widget.clinicData.status == 1 || 
                   (widget.clinicData.clinicStatus.toLowerCase() == 'active');
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Get.to(() => ClinicDetailScreen(), arguments: widget.clinicData);
        },
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: appColorPrimary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: context.cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clinic image with gradient overlay and status/actions
                  Stack(
                    children: [
                      // Clinic image or fallback with gradient background
                      widget.clinicData.clinicImage.isNotEmpty
                          ? CachedImageWidget(
                              url: widget.clinicData.clinicImage,
                              width: Get.width,
                              height: 160,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: Get.width,
                              height: 160,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    appColorPrimary.withOpacity(0.7),
                                    appColorSecondary.withOpacity(0.9),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  widget.clinicData.name.isNotEmpty 
                                      ? widget.clinicData.name[0].toUpperCase() 
                                      : "C",
                                  style: boldTextStyle(size: 48, color: Colors.white),
                                ),
                              ),
                            ),
                      
                      // Gradient overlay for better text visibility
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      
                      // Clinic name and status at the bottom of image
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status indicator
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isActive ? successColor : inProgressColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isActive ? 'Active' : 'Inactive',
                                style: boldTextStyle(size: 10, color: Colors.white),
                              ),
                            ),
                            8.height,
                            // Clinic name
                            Text(
                              widget.clinicData.name,
                              style: boldTextStyle(color: Colors.white, size: 18),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      // Action buttons at top right
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: appColorPrimary,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: appColorPrimary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                                onPressed: widget.onEditClick,
                              ),
                            ).visible(loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)),
                            8.width,
                            Container(
                              decoration: BoxDecoration(
                                color: errorColor,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: errorColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.delete_outline, color: Colors.white, size: 16),
                                onPressed: widget.onDeleteClick,
                              ),
                            ).visible(loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Clinic information section - simplified for key data
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Contact Info Row: Address and Phone
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Address with icon
                            if (widget.clinicData.address.isNotEmpty)
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () => launchMap(widget.clinicData.address),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: lightPrimaryColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.location_on_outlined, color: appColorPrimary, size: 16),
                                      ),
                                      12.width,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Address', style: boldTextStyle(size: 12, color: secondaryTextColor)),
                                            4.height,
                                            Text(
                                              widget.clinicData.address,
                                              style: primaryTextStyle(size: 14),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            
                            16.width,
                            
                            // Phone number
                            if (phoneNumber.isNotEmpty)
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () => launchCall(phoneNumber),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: lightSecondaryColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.phone_outlined, color: appColorSecondary, size: 16),
                                      ),
                                      8.width,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Phone', style: boldTextStyle(size: 12, color: secondaryTextColor)),
                                            Text(
                                              phoneNumber,
                                              style: primaryTextStyle(color: appColorPrimary),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                        16.height,
                        
                        // Display opening hours in a more compact format if available
                        if (widget.clinicData.openingHours.isNotEmpty)
                          _buildOpeningHoursWidget(widget.clinicData.openingHours),

                        16.height,
                        
                        // Action Buttons - View Details
                        AppPrimaryWidget(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Get.to(() => ClinicDetailScreen(), arguments: widget.clinicData);
                          },
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          borderRadius: 8,
                          isGradientFromRTL: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline, color: Colors.white, size: 16),
                              8.width,
                              Text(
                                'View Details',
                                style: boldTextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Helper method to build opening hours widget - simplified version
  Widget _buildOpeningHoursWidget(List<dynamic> openingHours) {
    Map<String, Map<String, String>> dayHours = {};
    
    // Process opening hours into a structured format
    for (var hour in openingHours) {
      if (hour is Map) {
        String id = hour['id']?.toString() ?? '';
        String time = hour['time']?.toString() ?? '';
        String label = hour['label']?.toString() ?? '';
        
        if (id.isNotEmpty && time.isNotEmpty && label.isNotEmpty) {
          String day = label;
          String type = id.contains('open') ? 'open' : 'close';
          
          if (!dayHours.containsKey(day)) {
            dayHours[day] = {};
          }
          
          dayHours[day]![type] = time;
        }
      }
    }
    
    if (dayHours.isEmpty) return const SizedBox();
    
    // Get today's day name
    final now = DateTime.now();
    final today = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][now.weekday % 7];
    
    // Find today's hours
    final todayHours = dayHours.entries.firstWhere(
      (entry) => entry.key.contains(today),
      orElse: () => MapEntry('', {}),
    );
    
    if (todayHours.key.isEmpty) {
      return const SizedBox();
    }
    
    String openTime = todayHours.value['open'] ?? '';
    String closeTime = todayHours.value['close'] ?? '';
    
    if (openTime.isEmpty || closeTime.isEmpty) {
      return const SizedBox();
    }
    
    // Format times
    openTime = _formatTime(openTime);
    closeTime = _formatTime(closeTime);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: extraLightPrimaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule, color: appColorPrimary, size: 18),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today\'s Hours', style: boldTextStyle(size: 12)),
              4.height,
              Text(
                '$openTime - $closeTime',
                style: primaryTextStyle(size: 14, color: appColorPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Helper method to format time
  String _formatTime(String time) {
    // Convert 24-hour format to 12-hour format
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        
        String period = hour >= 12 ? 'PM' : 'AM';
        hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        
        return '$hour:${minute.toString().padLeft(2, '0')} $period';
      }
    } catch (e) {
      // If parsing fails, return the original time
    }
    return time;
  }
}
