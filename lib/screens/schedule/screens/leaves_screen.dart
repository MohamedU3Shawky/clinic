import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:egphysio_clinic_admin/utils/constants.dart';
import 'package:egphysio_clinic_admin/utils/shared_preferences.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../controllers/leaves_controller.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../models/leave_model.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';

class LeavesScreen extends StatelessWidget {
  const LeavesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LeavesController controller = Get.put(LeavesController());

    return AppScaffoldNew(
      appBartitleText: locale.value.leaves,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          onPressed: () => _showAddLeaveDialog(context, controller),
        ),
      ],
      body: Column(
        children: [
          // Wrap leave types in Obx to show when settings are loaded
          Obx(() {
            if (controller.isLoadingSettings.value) {
              return const SizedBox(
                height: 140,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
                  ),
                ),
              );
            }
            return _buildLeaveTypes(controller);
          }),

          // Static month selector
          _buildMonthSelector(controller),

          // Only this part will rebuild when the month changes
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchLeaves();
                },
                child: _buildLeavesList(controller),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTypes(LeavesController controller) {
    return Container(
      height: 170, // slightly increased for the new hint
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.leaveSettings.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final leaveType = controller.leaveSettings[index];
          final isEnabled = leaveType.isEnabled;
          final color = _getLeaveTypeColor(index);

          final leaveDetails = controller.getLeaveTypeDetails(leaveType.id);
          final hasCustomPolicy = leaveDetails['hasCustomPolicy'] as bool;
          final totalDays = leaveDetails['totalDays'] as int;
          final defaultDays = leaveType.defaultDays;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTap: isEnabled
                  ? () => _showLeaveTypeDetails(context, leaveType, controller)
                  : null,
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  gradient: isEnabled
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.withOpacity(0.8),
                            color.withOpacity(0.4),
                          ],
                        )
                      : null,
                  color: isEnabled ? null : Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isEnabled
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -5,
                      bottom: -5,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(
                          _getLeaveTypeIcon(leaveType.name),
                          size: 80,
                          color: isEnabled ? color : Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isEnabled
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getLeaveTypeIcon(leaveType.name),
                              color: isEnabled
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.5),
                              size: 24,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            leaveType.name,
                            style: boldTextStyle(
                              size: 16,
                              color: isEnabled ? Colors.white : Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Text(
                                '$totalDays ${locale.value.days}',
                                style: secondaryTextStyle(
                                  size: 14,
                                  color: isEnabled
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey,
                                ),
                              ),
                              if (hasCustomPolicy && isEnabled) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.star,
                                  size: 12,
                                  color: Colors.amber,
                                ),
                              ],
                            ],
                          ),

                          if (hasCustomPolicy && isEnabled) ...[
                            const SizedBox(height: 2),
                            Text(
                              '${locale.value.defaultDays}: $defaultDays',
                              style: secondaryTextStyle(
                                size: 10,
                                color: isEnabled
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.grey,
                              ),
                            ),
                          ],

                          const SizedBox(height: 6),

                          // New "View Details" hint
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                locale.value.viewDetails,
                                style: secondaryTextStyle(
                                  size: 11,
                                  color: isEnabled
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthSelector(LeavesController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode.value ? scaffoldDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode.value ? Colors.grey.withOpacity(0.2) : dividerColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous month button
          _buildMonthNavButton(
            icon: Icons.chevron_left,
            onPressed: () {
              final newDate = DateTime(
                controller.selectedDate.value.year,
                controller.selectedDate.value.month - 1,
                1,
              );
              controller.setSelectedDate(newDate);
            },
            isDark: isDarkMode.value,
          ),

          // Month/year display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: isDarkMode.value
                  ? appColorPrimary.withOpacity(0.2)
                  : appColorPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: isDarkMode.value ? Colors.white : appColorPrimary,
                ),
                const SizedBox(width: 8),
                Obx(() => Text(
                      DateFormat('MMMM yyyy')
                          .format(controller.selectedDate.value),
                      style: boldTextStyle(
                        size: 16,
                        color:
                            isDarkMode.value ? Colors.white : appColorPrimary,
                      ),
                    )),
              ],
            ),
          ),

          // Next month button
          _buildMonthNavButton(
            icon: Icons.chevron_right,
            onPressed: () {
              final newDate = DateTime(
                controller.selectedDate.value.year,
                controller.selectedDate.value.month + 1,
                1,
              );
              controller.setSelectedDate(newDate);
            },
            isDark: isDarkMode.value,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? Colors.grey.withOpacity(0.2)
            : appColorPrimary.withOpacity(0.1),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: appColorPrimary.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 24,
          color: isDark ? Colors.white : appColorPrimary,
        ),
        onPressed: onPressed,
        splashRadius: 24,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }

  Widget _buildLeavesList(LeavesController controller) {
    if (controller.leaves.isEmpty) {
      return _buildEmptyState(controller);
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchLeaves(),
      backgroundColor: isDarkMode.value ? scaffoldDarkColor : Colors.white,
      color: appColorPrimary,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.leaves.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final leave = controller.leaves[index];
          return _buildModernLeaveCard(context, leave, controller);
        },
      ),
    );
  }

  Widget _buildModernLeaveCard(
      BuildContext context, LeaveModel leave, LeavesController controller) {
    final statusColor = _getStatusColor(leave.status);
    final isDark = isDarkMode.value;
    final now = DateTime.now();
    final isInPast =
        leave.from.isBefore(DateTime(now.year, now.month, now.day));

    // Use the controller method to get leave type name
    final leaveTypeName = controller.getLeaveTypeName(leave.leaveSettingId);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isDark ? cardDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey.withOpacity(0.2) : dividerColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Status indicator
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getStatusIcon(leave.status),
                    color: statusColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),

                // Leave type and status - now in same row with menu
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            leaveTypeName,
                            style: boldTextStyle(
                              size: 16,
                              color: isDark ? Colors.white : textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStatusText(leave.status),
                            style: secondaryTextStyle(
                              size: 14,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),

                      // Context menu moved inside the same row
                      if (leave.canUpdate && !isInPast || leave.canDelete)
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero, // Remove default padding
                          icon: Icon(
                            Icons.more_vert,
                            color:
                                isDark ? Colors.grey[400] : secondaryTextColor,
                            size: 24, // Slightly larger for better visibility
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            if (value == 'edit' &&
                                leave.canUpdate &&
                                !isInPast) {
                              _showEditLeaveDialog(context, leave, controller);
                            } else if (value == 'delete' && leave.canDelete) {
                              _showDeleteLeaveDialog(
                                  context, leave, controller);
                            }
                          },
                          itemBuilder: (context) => [
                            if (leave.canUpdate && !isInPast)
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit,
                                        size: 20, color: appColorPrimary),
                                    const SizedBox(width: 8),
                                    Text(locale.value.edit),
                                  ],
                                ),
                              ),
                            if (leave.canDelete)
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete,
                                        size: 20, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text(locale.value.delete),
                                  ],
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Leave details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date range
                _buildModernDetailRow(
                  icon: Icons.calendar_today,
                  label: locale.value.leaveDates,
                  value: leave.formattedDateRange,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // Patient
                _buildModernDetailRow(
                  icon: Icons.person_outline,
                  label: locale.value.patient,
                  value: leave.user.name,
                  isDark: isDark,
                ),

                // Reviewed by (if available)
                if (leave.reviewedBy != null) ...[
                  const SizedBox(height: 12),
                  _buildModernDetailRow(
                    icon: Icons.verified_outlined,
                    label: locale.value.reviewedBy,
                    value: leave.reviewedBy!.name,
                    isDark: isDark,
                  ),
                ],

                // Reason (if available)
                if (leave.reason.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildModernDetailRow(
                    icon: Icons.note_outlined,
                    label: locale.value.reason,
                    value: leave.reason,
                    isDark: isDark,
                    isMultiline: true,
                  ),
                ],

                // Review buttons for pending leaves
                if (leave.status.toLowerCase() == 'pending') ...[
                  const SizedBox(height: 16),
                  FutureBuilder<bool>(
                    future: controller.hasReviewPermission(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final success = await controller.reviewLeave(
                                    leaveId: leave.id,
                                    status: 'Approved',
                                  );
                                },
                                icon: const Icon(Icons.check_circle_outline),
                                label: Text(locale.value.approveRequest),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final success = await controller.reviewLeave(
                                    leaveId: leave.id,
                                    status: 'Rejected',
                                  );
                                },
                                icon: const Icon(Icons.cancel_outlined),
                                label: Text(locale.value.rejectRequest),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: appColorPrimary.withOpacity(isDark ? 0.2 : 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: appColorPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: secondaryTextStyle(
                  size: 12,
                  color: isDark ? Colors.grey[400] : textSecondaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: boldTextStyle(
                  size: 14,
                  color: isDark ? Colors.white : textPrimaryColor,
                ),
                maxLines: isMultiline ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(LeavesController controller) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    appColorPrimary.withOpacity(0.2),
                    appColorPrimary.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .beach_access, // Alternative: Icons.event_busy, Icons.work_off
                size: 80,
                color: appColorPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Title with subtle animation
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(
                locale.value.noLeavesFound,
                style: boldTextStyle(
                  size: 18,
                  color: isDarkMode.value ? Colors.white : textPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddLeaveDialog(Get.context!, controller),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text(
                locale.value.requestLeave,
                style: boldTextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColorPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLeaveTypeColor(int index) {
    final colors = [
      const Color(0xFF6C5CE7), // Purple
      const Color(0xFF00B894), // Teal
      const Color(0xFFFD79A8), // Pink
      const Color(0xFFFDCB6E), // Yellow
      const Color(0xFF0984E3), // Blue
      const Color(0xFFE17055), // Orange
    ];
    return colors[index % colors.length];
  }

  IconData _getLeaveTypeIcon(String leaveTypeName) {
    if (leaveTypeName.toLowerCase().contains('sick')) {
      return Icons.medical_services;
    } else if (leaveTypeName.toLowerCase().contains('annual')) {
      return Icons.beach_access;
    } else if (leaveTypeName.toLowerCase().contains('maternity')) {
      return Icons.family_restroom;
    } else if (leaveTypeName.toLowerCase().contains('paternity')) {
      return Icons.child_care;
    } else if (leaveTypeName.toLowerCase().contains('emergency')) {
      return Icons.emergency;
    } else {
      return Icons.event_available;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return locale.value.approved;
      case 'pending':
        return locale.value.pending;
      case 'rejected':
        return locale.value.rejected;
      default:
        return status;
    }
  }

  void _showLeaveTypeDetails(BuildContext context, LeaveSettingModel leaveType,
      LeavesController controller) {
    final color =
        _getLeaveTypeColor(controller.leaveSettings.indexOf(leaveType));

    // Get leave type details including custom policy information
    final leaveDetails = controller.getLeaveTypeDetails(leaveType.id);
    final hasCustomPolicy = leaveDetails['hasCustomPolicy'] as bool;
    final customPolicyName = leaveDetails['customPolicyName'] as String;
    final customPolicyDays = leaveDetails['customPolicyDays'] as int;
    final totalDays = leaveDetails['totalDays'] as int;
    final usedDays = leaveDetails['usedDays'] as int;
    final remainingDays = leaveDetails['remainingDays'] as int;
    final defaultDays = leaveType.defaultDays;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.9),
                color.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: -10,
                right: -10,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    _getLeaveTypeIcon(leaveType.name),
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getLeaveTypeIcon(leaveType.name),
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            leaveType.name,
                            style: boldTextStyle(
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Custom policy badge if applicable
                    if (hasCustomPolicy) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${locale.value.customPolicy}: $customPolicyName',
                              style: boldTextStyle(
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Details cards
                    _buildDetailCard(
                      icon: Icons.calendar_today,
                      title: '${locale.value.totalLeaves}:',
                      value: '$totalDays ${locale.value.days}',
                      color: color,
                      subtitle: hasCustomPolicy
                          ? '${locale.value.customPolicy}: $customPolicyDays ${locale.value.days} | ${locale.value.defaultDays}: $defaultDays ${locale.value.days}'
                          : '${locale.value.defaultDays}: $defaultDays ${locale.value.days}',
                    ),

                    const SizedBox(height: 12),

                    _buildDetailCard(
                      icon: Icons.event_busy,
                      title: '${locale.value.usedLeaves}:',
                      value: '$usedDays ${locale.value.days}',
                      color: color,
                    ),

                    const SizedBox(height: 12),

                    _buildDetailCard(
                      icon: Icons.event_available,
                      title: '${locale.value.remainingLeaves}:',
                      value: '$remainingDays ${locale.value.days}',
                      color: color,
                    ),

                    const SizedBox(height: 12),

                    _buildDetailCard(
                      icon: leaveType.isPaid
                          ? Icons.attach_money
                          : Icons.money_off,
                      title: '${locale.value.isPaid}:',
                      value:
                          leaveType.isPaid ? locale.value.yes : locale.value.no,
                      color: color,
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        locale.value.tapButtonToRequestLeave,
                        style: secondaryTextStyle(
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              locale.value.close,
                              style: boldTextStyle(
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showAddLeaveDialog(context, controller,
                                  leaveTypeId: leaveType.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: color,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: color.withOpacity(0.5),
                            ),
                            child: Text(
                              locale.value.requestLeave,
                              style: boldTextStyle(
                                size: 16,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: secondaryTextStyle(
                    size: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  value,
                  style: boldTextStyle(
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: secondaryTextStyle(
                      size: 12,
                      color: Colors.white.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddLeaveDialog(BuildContext context, LeavesController controller,
      {String? leaveTypeId}) {
    print(
        "userResponse: ${CashHelper.getData(key: SharedPreferenceConst.USER_ID)}");
    final formKey = GlobalKey<FormState>();
    LeaveSettingModel? selectedLeaveType;
    // Use Rx variables to make the UI reactive
    final fromDate = DateTime.now().obs;
    final toDate = DateTime.now().add(const Duration(days: 1)).obs;
    String reason = '';

    if (leaveTypeId != null) {
      selectedLeaveType = controller.leaveSettings
          .firstWhereOrNull((lt) => lt.id == leaveTypeId);
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode.value ? cardDarkColor : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(
                          Icons.airplane_ticket_rounded,
                          color: appColorPrimary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            locale.value.requestLeave,
                            style: boldTextStyle(size: 20),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close,
                              color: isDarkMode.value
                                  ? Colors.grey[400]
                                  : Colors.grey[600]),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Leave Type
                    _SectionTitle(
                        icon: Icons.event_available_rounded,
                        text: locale.value.leaveType),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDarkMode.value
                              ? Colors.grey.withOpacity(0.3)
                              : dividerColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<LeaveSettingModel>(
                          value: selectedLeaveType,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down,
                              color: isDarkMode.value
                                  ? Colors.grey[400]
                                  : textSecondaryColor),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          dropdownColor:
                              isDarkMode.value ? cardDarkColor : Colors.white,
                          items: controller.leaveSettings
                              .where((lt) => lt.isEnabled)
                              .map((lt) {
                            final color = _getLeaveTypeColor(
                                controller.leaveSettings.indexOf(lt));
                            return DropdownMenuItem<LeaveSettingModel>(
                              value: lt,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(lt.name),
                                  const Spacer(),
                                  Text(
                                    '${lt.defaultDays} ${locale.value.days}',
                                    style: secondaryTextStyle(size: 12),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) => selectedLeaveType = value,
                          validator: (value) => value == null
                              ? locale.value.pleaseSelectLeaveType
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dates
                    _SectionTitle(
                        icon: Icons.date_range_rounded,
                        text: locale.value.duration),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _DateField(
                                label: locale.value.from,
                                selectedDate: fromDate.value,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: fromDate.value,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year + 1),
                                    builder: (context, child) => Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                            primary: appColorPrimary),
                                        dialogBackgroundColor: isDarkMode.value
                                            ? cardDarkColor
                                            : Colors.white,
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (picked != null) {
                                    fromDate.value = picked;
                                    // If toDate is before fromDate, update toDate
                                    if (toDate.value.isBefore(fromDate.value)) {
                                      toDate.value = fromDate.value;
                                    }
                                  }
                                },
                              )),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() => _DateField(
                                label: locale.value.to,
                                selectedDate: toDate.value,
                                onTap: () async {
                                  // Fix: Ensure initialDate is not before firstDate
                                  final initialDate =
                                      toDate.value.isBefore(fromDate.value)
                                          ? fromDate.value
                                          : toDate.value;
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: initialDate,
                                    firstDate: fromDate.value,
                                    lastDate: DateTime(DateTime.now().year + 1),
                                    builder: (context, child) => Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                            primary: appColorPrimary),
                                        dialogBackgroundColor: isDarkMode.value
                                            ? cardDarkColor
                                            : Colors.white,
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (picked != null) {
                                    toDate.value = picked;
                                  }
                                },
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Reason
                    _SectionTitle(
                        icon: Icons.notes_rounded, text: locale.value.reason),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 3,
                      onChanged: (val) => reason = val,
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? locale.value.thisFieldIsRequired
                          : null,
                      decoration: InputDecoration(
                        hintText: locale.value.enterReason,
                        filled: true,
                        fillColor: isDarkMode.value
                            ? Colors.grey[850]
                            : Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDarkMode.value
                                ? Colors.grey.withOpacity(0.3)
                                : dividerColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: appColorPrimary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send_rounded),
                        label: Text(locale.value.submit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColorPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              selectedLeaveType != null) {
                            controller.addLeave(
                              leaveSettingId: selectedLeaveType!.id,
                              from: fromDate.value,
                              to: toDate.value,
                              reason: reason,
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditLeaveDialog(
      BuildContext context, LeaveModel leave, LeavesController controller) {
    if (leave.from.isBefore(DateTime.now())) {
      toast(locale.value.cannotEditPastLeaves);
      return;
    }

    final formKey = GlobalKey<FormState>();
    // Use Rx variables to make the UI reactive
    final fromDate = leave.from.obs;
    final toDate = leave.to.obs;
    String reason = leave.reason;

    // Use the controller method to get leave type name
    final leaveTypeName = controller.getLeaveTypeName(leave.leaveSettingId);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    locale.value.editLeave,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode.value ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Leave Type (non-editable)
                  _buildReadOnlyField(
                    label: locale.value.leaveType,
                    value: leaveTypeName,
                    icon: Icons.event_available_rounded,
                  ),
                  const SizedBox(height: 16),

                  // FROM Date
                  Obx(() => _buildDateField(
                        context,
                        label: locale.value.from,
                        date: fromDate.value,
                        onTap: () async {
                          // Use today as the first date for the date picker
                          final firstDate = DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day);
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: fromDate.value,
                            firstDate: firstDate,
                            lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                            builder: (context, child) => Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme:
                                    ColorScheme.light(primary: appColorPrimary),
                                dialogBackgroundColor: isDarkMode.value
                                    ? cardDarkColor
                                    : Colors.white,
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            fromDate.value = picked;
                            if (toDate.value.isBefore(fromDate.value)) {
                              toDate.value = fromDate.value;
                            }
                          }
                        },
                      )),

                  const SizedBox(height: 16),

                  // TO Date
                  Obx(() => _buildDateField(
                        context,
                        label: locale.value.to,
                        date: toDate.value,
                        onTap: () async {
                          // Fix: Ensure initialDate is not before firstDate
                          final firstDate = fromDate.value;
                          final initialDate = toDate.value.isBefore(firstDate)
                              ? firstDate
                              : toDate.value;
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: firstDate,
                            lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                            builder: (context, child) => Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme:
                                    ColorScheme.light(primary: appColorPrimary),
                                dialogBackgroundColor: isDarkMode.value
                                    ? cardDarkColor
                                    : Colors.white,
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            toDate.value = picked;
                          }
                        },
                      )),

                  const SizedBox(height: 16),

                  // Reason Field
                  TextFormField(
                    initialValue: reason,
                    maxLines: 3,
                    onChanged: (value) => reason = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locale.value.thisFieldIsRequired;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: locale.value.enterReason,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(locale.value.cancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              controller.updateLeave(
                                leaveId: leave.id,
                                leaveSettingId: leave.leaveSettingId,
                                from: fromDate.value,
                                to: toDate.value,
                                reason: reason,
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColorPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(locale.value.update),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for read-only fields
  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode.value ? Colors.grey.withOpacity(0.3) : dividerColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDarkMode.value ? Colors.grey[400] : textSecondaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: secondaryTextStyle(
                    size: 12,
                    color: isDarkMode.value
                        ? Colors.grey[400]
                        : textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: boldTextStyle(
                    size: 16,
                    color: isDarkMode.value ? Colors.white : textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper Widget for Date Picker
  Widget _buildDateField(BuildContext context,
      {required String label,
      required DateTime date,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMM d, yyyy').format(date),
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode.value ? Colors.white : Colors.black,
              ),
            ),
            Icon(Icons.calendar_today_outlined, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showDeleteLeaveDialog(
      BuildContext context, LeaveModel leave, LeavesController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locale.value.delete),
        content: Text(locale.value.doYouWantToPerformThisAction),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(locale.value.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteLeaves(leave.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(locale.value.delete),
          ),
        ],
      ),
    );
  }
}

// Helper widgets
class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SectionTitle({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: appColorPrimary),
        const SizedBox(width: 8),
        Text(text, style: boldTextStyle(size: 14)),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;
  final String label;
  const _DateField(
      {required this.selectedDate, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode.value;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey.withOpacity(0.3) : dividerColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 18,
                color: isDark ? Colors.grey[400] : textSecondaryColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                DateFormat('MMM d, yyyy').format(selectedDate),
                style: primaryTextStyle(
                  color: isDark ? Colors.white : textPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
