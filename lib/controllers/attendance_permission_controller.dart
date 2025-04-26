import 'package:get/get.dart';
import '../api/attendance_permission_api.dart';
import '../models/attendance_permission_model.dart';

class AttendancePermissionController extends GetxController {
  final RxList<AttendancePermissionModel> permissions = <AttendancePermissionModel>[].obs;
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
      );

      permissions.assignAll(result['permissions'] as List<AttendancePermissionModel>);
      totalCount.value = result['totalCount'] as int;
      approvedCount.value = result['approvedCount'] as int;
      pendingCount.value = result['pendingCount'] as int;
      rejectedCount.value = result['rejectedCount'] as int;
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