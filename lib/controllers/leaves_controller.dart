import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../api/leave_apis.dart';
import '../models/leave_model.dart';
import '../main.dart';

class LeavesController extends GetxController {
  // Observable state
  final RxList<LeaveSettingModel> leaveSettings = <LeaveSettingModel>[].obs;
  final RxList<LeaveModel> leaves = <LeaveModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxMap<DateTime, int> leavesPerDay = <DateTime, int>{}.obs;
  final Rx<DateTime> currentMonth = DateTime.now().obs;

  // View mode properties
  final RxString viewMode = 'monthly'.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveSettings();
    fetchLeaves();
  }

  // Toggle between monthly and list view
  void toggleViewMode() {
    viewMode.value = viewMode.value == 'monthly' ? 'list' : 'monthly';
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchLeaves();
  }

  // Fetch leave settings
  Future<void> fetchLeaveSettings() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await LeaveServiceApis.getLeaveSettings();
      if (response != null) {
        leaveSettings.value = response;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch leaves for the current month
  Future<void> fetchLeaves() async {
    try {
      isLoading.value = true;
      error.value = '';

      final firstDay =
          DateTime(selectedDate.value.year, selectedDate.value.month, 1);
      final lastDay =
          DateTime(selectedDate.value.year, selectedDate.value.month + 1, 0);

      final response = await LeaveServiceApis.getLeaves(firstDay, lastDay);
      if (response != null) {
        leaves.value = response.leaves;
        _updateLeavesPerDay();
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new leave
  Future<void> addLeave({
    required String leaveSettingId,
    required DateTime from,
    required DateTime to,
    required String reason,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await LeaveServiceApis.addLeave(
        leaveSettingId: leaveSettingId,
        from: from,
        to: to,
        reason: reason,
      );

      if (response != null) {
        await fetchLeaves();
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Update an existing leave
  Future<void> updateLeave({
    required String leaveId,
    required DateTime from,
    required DateTime to,
    required String reason,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await LeaveServiceApis.updateLeave(
        leaveId: leaveId,
        from: from,
        to: to,
        reason: reason,
      );

      if (response != null) {
        await fetchLeaves();
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a leave
  Future<void> deleteLeaves(String leaveId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await LeaveServiceApis.deleteLeaves(leaveId);

      if (response != null) {
        await fetchLeaves();
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Set current month
  void setCurrentMonth(DateTime month) {
    currentMonth.value = month;
    fetchLeaves();
  }

  // Count leaves for a specific date
  int countLeavesForDate(DateTime date) {
    return leavesPerDay[DateTime(date.year, date.month, date.day)] ?? 0;
  }

  // Update leaves per day count
  void _updateLeavesPerDay() {
    leavesPerDay.clear();

    for (var leave in leaves) {
      DateTime currentDate = leave.from;
      while (currentDate.isBefore(leave.to) ||
          currentDate.isAtSameMomentAs(leave.to)) {
        final key =
            DateTime(currentDate.year, currentDate.month, currentDate.day);
        leavesPerDay[key] = (leavesPerDay[key] ?? 0) + 1;
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  }
}
