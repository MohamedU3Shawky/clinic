import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../api/leave_apis.dart';
import '../models/leave_model.dart';
import '../main.dart';
import '../utils/shared_preferences.dart';
import '../utils/constants.dart';
import '../controllers/permissions_controller.dart';

class LeavesController extends GetxController {
  // Observable state
  final RxList<LeaveSettingModel> leaveSettings = <LeaveSettingModel>[].obs;
  final RxList<LeaveModel> leaves = <LeaveModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSettings = false.obs;
  final RxString error = ''.obs;
  final RxMap<DateTime, int> leavesPerDay = <DateTime, int>{}.obs;
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final RxList<Map<String, dynamic>> userLeaveBalances =
      <Map<String, dynamic>>[].obs;

  // View mode properties
  final RxString viewMode = 'monthly'.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  // Initialize data in the correct order
  Future<void> _initializeData() async {
    await fetchLeaveSettings();
    await fetchUserLeaveBalances();
    if (leaveSettings.isNotEmpty) {
      await fetchLeaves();
    }
  }

  // Check if user has permission to review leaves
  Future<bool> hasReviewPermission() async {
    final permissionsController = Get.find<PermissionsController>();
    return permissionsController.hasPermission('Review Leaves');
  }

  // Review a leave request
  Future<bool> reviewLeave({
    required String leaveId,
    required String status,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await LeaveServiceApis.reviewLeave(
        leaveId: leaveId,
        status: status,
      );

      if (success) {
        await fetchLeaves();
      }

      return success;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch user leave balances
  Future<void> fetchUserLeaveBalances() async {
    try {
      final balances = await LeaveServiceApis.getUserLeaveBalances();
      userLeaveBalances.value = balances;
    } catch (e) {
      error.value = e.toString();
    }
  }

  // Toggle between monthly and list view
  void toggleViewMode() {
    viewMode.value = viewMode.value == 'monthly' ? 'list' : 'monthly';
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    if (leaveSettings.isNotEmpty) {
      fetchLeaves();
    }
  }

  // Fetch leave settings
  Future<void> fetchLeaveSettings() async {
    try {
      isLoadingSettings.value = true;
      error.value = '';

      final response = await LeaveServiceApis.getLeaveSettings();
      if (response != null) {
        leaveSettings.value = response;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingSettings.value = false;
    }
  }

  // Fetch leaves for the current month
  Future<void> fetchLeaves() async {
    if (leaveSettings.isEmpty) {
      error.value = 'Leave settings not loaded';
      return;
    }

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
    if (leaveSettings.isEmpty) {
      error.value = 'Leave settings not loaded';
      return;
    }

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
    required String leaveSettingId,
    required DateTime from,
    required DateTime to,
    required String reason,
  }) async {
    if (leaveSettings.isEmpty) {
      error.value = 'Leave settings not loaded';
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final response = await LeaveServiceApis.updateLeave(
        leaveId: leaveId,
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

  // Delete a leave
  Future<void> deleteLeaves(String leaveId) async {
    if (leaveSettings.isEmpty) {
      error.value = 'Leave settings not loaded';
      return;
    }

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
    if (leaveSettings.isNotEmpty) {
      fetchLeaves();
    }
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

  // Get leave type name by ID
  String getLeaveTypeName(String leaveTypeId) {
    final leaveType =
        leaveSettings.firstWhereOrNull((lt) => lt.id == leaveTypeId);
    return leaveType?.name ?? 'Unknown Leave Type';
  }

  // Get available days for a leave type based on user ID
  int getAvailableDaysForLeaveType(String leaveTypeId) {
    // Get current user ID from shared preferences
    final userId = CashHelper.getData(key: SharedPreferenceConst.USER_ID);
    if (userId == null) return 0;

    // Find the leave type
    final leaveType =
        leaveSettings.firstWhereOrNull((lt) => lt.id == leaveTypeId);
    if (leaveType == null) return 0;

    // Check if user has a custom policy
    for (var policy in leaveType.customPolicies) {
      for (var user in policy.users) {
        if (user.id == userId) {
          return policy.noOfDays;
        }
      }
    }

    // Return default days if no custom policy found
    return leaveType.defaultDays;
  }

  // Get leave type details including custom policy information
  Map<String, dynamic> getLeaveTypeDetails(String leaveTypeId) {
    final leaveType =
        leaveSettings.firstWhereOrNull((lt) => lt.id == leaveTypeId);
    if (leaveType == null) {
      return {
        'name': 'Unknown Leave Type',
        'totalDays': 0,
        'usedDays': 0,
        'remainingDays': 0,
        'isEnabled': false,
        'isPaid': false,
        'hasCustomPolicy': false,
        'customPolicyName': '',
        'customPolicyDays': 0
      };
    }

    // Get current user ID
    final userId = CashHelper.getData(key: SharedPreferenceConst.USER_ID);

    // Check for custom policy
    bool hasCustomPolicy = false;
    String customPolicyName = '';
    int customPolicyDays = 0;

    for (var policy in leaveType.customPolicies) {
      for (var user in policy.users) {
        if (user.id == userId) {
          hasCustomPolicy = true;
          customPolicyName = policy.name;
          customPolicyDays = policy.noOfDays;
          break;
        }
      }
      if (hasCustomPolicy) break;
    }

    // Check if we have balance data from the API
    final balanceData = userLeaveBalances.firstWhereOrNull(
        (balance) => balance['leaveSettingId'] == leaveTypeId);

    // Calculate used days
    int usedDays = 0;
    int totalDays = 0;
    int remainingDays = 0;

    if (balanceData != null) {
      // Use data from the API
      totalDays = balanceData['leaveBalance'].toInt() ?? 0;
      usedDays = balanceData['leaveTaken'].toInt() ?? 0;
      remainingDays = balanceData['leaveRemaining'].toInt() ?? 0;
    } else {
      // Fallback to calculating from leaves
      for (var leave in leaves) {
        if (leave.leaveSettingId == leaveTypeId &&
            (leave.status == 'Approved' || leave.status == 'approved')) {
          // Calculate days between from and to dates
          final difference = leave.to.difference(leave.from).inDays + 1;
          usedDays += difference;
        }
      }

      // Calculate total and remaining days
      totalDays = hasCustomPolicy ? customPolicyDays : leaveType.defaultDays;
      remainingDays = totalDays - usedDays;
    }

    return {
      'name': leaveType.name,
      'totalDays': totalDays,
      'usedDays': usedDays,
      'remainingDays': remainingDays,
      'isEnabled': leaveType.isEnabled,
      'isPaid': leaveType.isPaid,
      'hasCustomPolicy': hasCustomPolicy,
      'customPolicyName': customPolicyName,
      'customPolicyDays': customPolicyDays
    };
  }
}
