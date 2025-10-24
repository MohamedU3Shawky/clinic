import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:egphysio_clinic_admin/utils/app_common.dart';
import '../api/attendance_api.dart';
import '../models/attendance.dart';
import '../main.dart';

class AttendanceController extends GetxController {
  final AttendanceApi _api = AttendanceApi();
  final RxBool isLoading = false.obs;
  final RxList<EmployeeAttendance> attendanceList = <EmployeeAttendance>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    if (isLoading.value) return;

    isLoading(true);
    try {
      final startOfWeek = selectedDate.value.subtract(
        Duration(days: selectedDate.value.weekday - 1),
      );
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      final response = await _api.getAttendance(
        from: startOfWeek,
        to: endOfWeek,
      );

      if (response.success) {
        final currentUserId = loginUserData.value.idString;

        // Filter to show only current user's attendance data
        final userAttendance = response.data.data.firstWhere(
          (attendance) => attendance.user.id == currentUserId,
          orElse: () => EmployeeAttendance(
            user: User(
              id: currentUserId,
              name: loginUserData.value.firstName ?? '',
              email: loginUserData.value.email ?? '',
              phone: loginUserData.value.mobile,
            ),
            days: [],
          ),
        );

        // Only show current user's data
        attendanceList.assignAll([userAttendance]);
        hasMoreData(false); // No pagination needed for single user
      } else {
        Get.snackbar(
          'Error',
          response.message ?? locale.value.failedToFetchAttendance,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        '${locale.value.failedToFetchAttendance}: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void setSelectedDate(DateTime date) {
    selectedDate(date);
    fetchAttendance();
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'latein':
        return Colors.orange;
      case 'earlyleave':
        return Colors.purple;
      case 'no shift':
        return Colors.grey;
      case 'holiday':
        return Colors.blue;
      case 'leave':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'latein':
        return Icons.warning;
      case 'earlyleave':
        return Icons.timer_off;
      case 'no shift':
        return Icons.event_busy;
      case 'holiday':
        return Icons.celebration;
      case 'leave':
        return Icons.airplanemode_active;
      default:
        return Icons.help;
    }
  }

  String getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return 'You were present for your shift';
      case 'absent':
        return 'You were absent from your shift';
      case 'latein':
        return 'You arrived late to your shift';
      case 'earlyleave':
        return 'You left early from your shift';
      case 'no shift':
        return 'No shift scheduled for this day';
      case 'holiday':
        return 'This is a holiday';
      case 'leave':
        return 'You are on leave';
      default:
        return 'Unknown status';
    }
  }
}
