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
import '../../../controllers/overtime_controller.dart';
import '../../../models/overtime_model.dart';

class OvertimeScreen extends StatelessWidget {
  const OvertimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OvertimeController());

    return AppScaffoldNew(
      appBartitleText: 'Overtime',
      appBarVerticalSize: Get.height * 0.12,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Overtime",
                    style: boldTextStyle(size: 24),
                  ),
                  8.height,
                  Text(
                    "Manage overtime requests",
                    style: secondaryTextStyle(size: 16),
                  ),
                  24.height,
                  _buildOvertimeStats(controller),
                  16.height,
                  Text(
                    "All Overtime",
                    style: boldTextStyle(size: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildOvertimeList(controller),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildOvertimeStats(OvertimeController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        color: isDarkMode.value ? cardDarkColor : white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDarkMode.value ? dividerDarkColor : dividerColor),
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

  Widget _buildOvertimeList(OvertimeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.overtime.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  size: 64,
                  color: isDarkMode.value ? Colors.grey.shade600 : Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No overtime found',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode.value ? Colors.grey.shade400 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(vertical: 32)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.overtime.length,
            itemBuilder: (context, index) {
              final overtime = controller.overtime[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: boxDecorationDefault(
                  color: isDarkMode.value ? cardDarkColor : white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDarkMode.value ? dividerDarkColor : dividerColor),
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
                              color: _getTypeColor(overtime.type).withOpacity(isDarkMode.value ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CachedImageWidget(
                              url: Assets.iconsIcTimeOutlined,
                              height: 24,
                              width: 24,
                              color: _getTypeColor(overtime.type),
                            ),
                          ),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${overtime.from} - ${overtime.to}',
                                style: boldTextStyle(
                                  size: 16,
                                  color: isDarkMode.value ? Colors.white : textPrimaryColor,
                                ),
                              ),
                              4.height,
                              Text(
                                'Type: ${overtime.type}',
                                style: secondaryTextStyle(
                                  size: 14,
                                  color: isDarkMode.value ? Colors.white70 : textSecondaryColor,
                                ),
                              ),
                              4.height,
                              Text(
                                'Shift: ${overtime.shift}',
                                style: secondaryTextStyle(
                                  size: 12,
                                  color: isDarkMode.value ? Colors.white60 : textSecondaryColor,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: boxDecorationDefault(
                              color: _getStatusColor(overtime.status).withOpacity(isDarkMode.value ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              overtime.status,
                              style: boldTextStyle(
                                size: 12,
                                color: _getStatusColor(overtime.status),
                              ),
                            ),
                          ),
                          8.width,
                          IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: isDarkMode.value ? Colors.white70 : appColorPrimary,
                              size: 20,
                            ),
                            onPressed: () => _showOvertimeDetails(overtime),
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

  void _showOvertimeDetails(OvertimeModel overtime) {
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
                    'Overtime Details',
                    style: boldTextStyle(
                      size: 18,
                      color: isDarkMode.value ? Colors.white : textPrimaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDarkMode.value ? Colors.white70 : textPrimaryColor,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Time',
                '${overtime.from} - ${overtime.to}',
                Icons.access_time,
              ),
              _buildDetailRow(
                'Type',
                overtime.type,
                Icons.timer,
              ),
              _buildDetailRow(
                'Shift',
                overtime.shift,
                Icons.calendar_today,
              ),
              _buildDetailRow(
                'Status',
                overtime.status,
                Icons.info,
              ),
              if (overtime.reason != null && overtime.reason!.isNotEmpty)
                _buildDetailRow(
                  'Reason',
                  overtime.reason!,
                  Icons.note,
                ),
              if (overtime.reviewedBy != null) ...[
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
                  overtime.reviewedBy!,
                  Icons.person,
                ),
              ],
              if (overtime.reviewedAt != null)
                _buildDetailRow(
                  'Reviewed At',
                  overtime.reviewedAt!,
                  Icons.access_time,
                ),
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
                    color: isDarkMode.value ? Colors.white70 : textSecondaryColor,
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
      case 'regular':
        return Colors.blue;
      case 'holiday':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
