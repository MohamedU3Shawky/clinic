import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../controllers/attendance_permission_controller.dart';
import '../../../models/attendance_permission_model.dart';

class AttendancePermissionsScreen extends StatelessWidget {
  const AttendancePermissionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AttendancePermissionController());

    return AppScaffoldNew(
      appBartitleText: 'Attendance Permissions',
      appBarVerticalSize: Get.height * 0.12,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchAttendancePermissions();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Attendance Permissions",
                      style: boldTextStyle(size: 24),
                    ),
                    8.height,
                    Text(
                      "Manage attendance permissions",
                      style: secondaryTextStyle(size: 16),
                    ),
                    24.height,
                    _buildPermissionStats(controller),
                    16.height,
                    Text(
                      "All Permissions",
                      style: boldTextStyle(size: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildPermissionList(controller),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPermissionStats(AttendancePermissionController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        color: isDarkMode.value ? cardDarkColor : white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDarkMode.value ? dividerDarkColor : dividerColor),
        boxShadow: isDarkMode.value ? null : defaultBoxShadow(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            title: 'Total',
            value: controller.totalCount.value.toString(),
            icon: Assets.iconsIcTimeOutlined,
            color: isDarkMode.value ? Colors.purple.shade300 : Colors.purple,
          ),
          _buildStatItem(
            title: 'Approved',
            value: controller.approvedCount.value.toString(),
            icon: Assets.iconsIcTimeOutlined,
            color: isDarkMode.value ? Colors.green.shade300 : Colors.green,
          ),
          _buildStatItem(
            title: 'Pending',
            value: controller.pendingCount.value.toString(),
            icon: Assets.iconsIcTimeOutlined,
            color: isDarkMode.value ? Colors.orange.shade300 : Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required String icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: boxDecorationDefault(
            color: color.withOpacity(isDarkMode.value ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CachedImageWidget(
            url: icon,
            height: 24,
            width: 24,
            color: color,
          ),
        ),
        8.height,
        Text(
          value,
          style: boldTextStyle(
            size: 20,
            color: isDarkMode.value ? Colors.white : textPrimaryColor,
          ),
        ),
        4.height,
        Text(
          title,
          style: secondaryTextStyle(
            size: 14,
            color: isDarkMode.value ? Colors.white70 : textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionList(AttendancePermissionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.permissions.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  size: 64,
                  color: isDarkMode.value
                      ? Colors.grey.shade600
                      : Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No permissions found',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode.value
                        ? Colors.grey.shade400
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(vertical: 32)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.permissions.length,
            itemBuilder: (context, index) {
              final permission = controller.permissions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: boxDecorationDefault(
                  color: isDarkMode.value ? cardDarkColor : white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color:
                          isDarkMode.value ? dividerDarkColor : dividerColor),
                  boxShadow: isDarkMode.value ? null : defaultBoxShadow(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: boxDecorationDefault(
                              color: _getTypeColor(permission.type)
                                  .withOpacity(isDarkMode.value ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CachedImageWidget(
                              url: Assets.iconsIcTimeOutlined,
                              height: 24,
                              width: 24,
                              color: _getTypeColor(permission.type),
                            ),
                          ),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                permission.user.name,
                                style: boldTextStyle(
                                  size: 16,
                                  color: isDarkMode.value
                                      ? Colors.white
                                      : textPrimaryColor,
                                ),
                              ),
                              4.height,
                              Text(
                                '${permission.type} - ${permission.duration} hours',
                                style: secondaryTextStyle(
                                  size: 14,
                                  color: isDarkMode.value
                                      ? Colors.white70
                                      : textSecondaryColor,
                                ),
                              ),
                              4.height,
                              Text(
                                DateFormat('MMM d, yyyy')
                                    .format(permission.shift.startDate),
                                style: secondaryTextStyle(
                                  size: 12,
                                  color: isDarkMode.value
                                      ? Colors.white60
                                      : textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: boxDecorationDefault(
                              color: _getStatusColor(permission.status)
                                  .withOpacity(isDarkMode.value ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              permission.status,
                              style: boldTextStyle(
                                size: 12,
                                color: _getStatusColor(permission.status),
                              ),
                            ),
                          ),
                          8.width,
                          IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: isDarkMode.value
                                  ? Colors.white70
                                  : appColorPrimary,
                              size: 20,
                            ),
                            onPressed: () => _showPermissionDetails(permission),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showPermissionDetails(AttendancePermissionModel permission) {
    Get.dialog(
      Dialog(
        backgroundColor: isDarkMode.value ? cardDarkColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Permission Details',
                    style: boldTextStyle(
                      size: 18,
                      color: isDarkMode.value ? Colors.white : textPrimaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color:
                          isDarkMode.value ? Colors.white70 : textPrimaryColor,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Employee',
                permission.user.name,
                Icons.person,
              ),
              _buildDetailRow(
                'Type',
                permission.type,
                Icons.timer,
              ),
              _buildDetailRow(
                'Duration',
                '${permission.duration} hours',
                Icons.access_time,
              ),
              _buildDetailRow(
                'Status',
                permission.status,
                Icons.info,
              ),
              _buildDetailRow(
                'Shift Date',
                DateFormat('MMM d, yyyy').format(permission.shift.startDate),
                Icons.calendar_today,
              ),
              _buildDetailRow(
                'Shift Time',
                '${permission.shift.timeTable.checkInTime} - ${permission.shift.timeTable.checkOutTime}',
                Icons.access_time,
              ),
              if (permission.reason != null && permission.reason!.isNotEmpty)
                _buildDetailRow(
                  'Reason',
                  permission.reason!,
                  Icons.note,
                ),
              if (permission.reviewedBy != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Reviewed By',
                  style: boldTextStyle(
                    size: 14,
                    color: isDarkMode.value ? Colors.white : textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Name',
                  permission.reviewedBy!.name,
                  Icons.person,
                ),
                _buildDetailRow(
                  'Email',
                  permission.reviewedBy!.email,
                  Icons.email,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: appColorPrimary.withOpacity(isDarkMode.value ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDarkMode.value ? Colors.white70 : appColorPrimary,
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
                    color:
                        isDarkMode.value ? Colors.white70 : textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: boldTextStyle(
                    size: 14,
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

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'latein':
        return Colors.blue;
      case 'earlyleave':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
