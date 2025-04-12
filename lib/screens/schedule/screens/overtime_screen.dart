import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../model/schedule_model.dart';

class OvertimeScreen extends StatelessWidget {
  OvertimeScreen({Key? key}) : super(key: key);

  final RxList<ScheduleModel> overtimeSchedules = <ScheduleModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: "Overtime",
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Navigate to add overtime screen
          },
          icon: const Icon(Icons.add_circle_outline_rounded,
              size: 28, color: Colors.white),
        ).paddingOnly(right: 8),
      ],
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Overtime",
                style: boldTextStyle(size: 24),
              ),
              8.height,
              Text(
                locale.value.manageSessions,
                style: secondaryTextStyle(size: 16),
              ),
              24.height,
              _buildOvertimeStats(),
              24.height,
              _buildOvertimeList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOvertimeStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        color: isDarkMode.value ? appBodyColor : white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            title: 'This Month',
            value: '24',
            icon: Assets.iconsIcTimeOutlined,
            color: Colors.purple,
          ),
          _buildStatItem(
            title: 'This Week',
            value: '8',
            icon: Assets.iconsIcTimeOutlined,
            color: Colors.blue,
          ),
          _buildStatItem(
            title: 'Today',
            value: '2',
            icon: Assets.iconsIcTimeOutlined,
            color: Colors.green,
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
            color: color.withOpacity(0.1),
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
          style: boldTextStyle(size: 20),
        ),
        4.height,
        Text(
          title,
          style: secondaryTextStyle(size: 14),
        ),
      ],
    );
  }

  Widget _buildOvertimeList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "All Overtime",
          style: boldTextStyle(size: 18),
        ),
        16.height,
        if (overtimeSchedules.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No overtime found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(vertical: 32)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: overtimeSchedules.length,
            itemBuilder: (context, index) {
              final overtime = overtimeSchedules[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: boxDecorationDefault(
                  color: isDarkMode.value ? appBodyColor : white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: dividerColor),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: boxDecorationDefault(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedImageWidget(
                      url: Assets.iconsIcTimeOutlined,
                      height: 24,
                      width: 24,
                      color: Colors.purple,
                    ),
                  ),
                  title: Text(
                    overtime.title,
                    style: boldTextStyle(size: 16),
                  ),
                  subtitle: Text(
                    '${overtime.startTime.toString().substring(0, 10)} - ${overtime.endTime.toString().substring(0, 10)}',
                    style: secondaryTextStyle(size: 14),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: boxDecorationDefault(
                      color: _getStatusColor(overtime.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      overtime.status,
                      style: boldTextStyle(
                          size: 12, color: _getStatusColor(overtime.status)),
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to overtime detail
                  },
                ),
              );
            },
          ),
      ],
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
}
