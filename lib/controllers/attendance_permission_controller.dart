import 'package:get/get.dart';
import '../api/attendance_permission_api.dart';
import '../models/attendance_permission_model.dart';
import '../utils/app_common.dart';

class AttendancePermissionController extends GetxController {
  final RxList<AttendancePermissionModel> permissions =
      <AttendancePermissionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt totalCount = 0.obs;
  final RxInt approvedCount = 0.obs;
  final RxInt pendingCount = 0.obs;
  final RxInt rejectedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendancePermissions();
  }

  Future<void> fetchAttendancePermissions() async {
    try {
      isLoading.value = true;
      final result = await AttendancePermissionApi.getAttendancePermissions(
        page: 1,
        perPage: 5,
        userId: loginUserData.value.idString,
      );

      // Filter permissions to show only current user's data
      final currentUserId = loginUserData.value.idString;
      final userPermissions =
          (result['permissions'] as List<AttendancePermissionModel>)
              .where((permission) => permission.user.id == currentUserId)
              .toList();

      permissions.assignAll(userPermissions);

      // Update counts based on filtered data
      totalCount.value = userPermissions.length;
      approvedCount.value = userPermissions
          .where((p) => p.status.toLowerCase() == 'approved')
          .length;
      pendingCount.value = userPermissions
          .where((p) => p.status.toLowerCase() == 'pending')
          .length;
      rejectedCount.value = userPermissions
          .where((p) => p.status.toLowerCase() == 'rejected')
          .length;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
