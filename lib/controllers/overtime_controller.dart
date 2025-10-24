import 'package:get/get.dart';
import '../api/overtime_api.dart';
import '../models/overtime_model.dart';
import '../utils/app_common.dart';

class OvertimeController extends GetxController {
  final RxList<OvertimeModel> overtime = <OvertimeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt totalCount = 0.obs;
  final RxInt approvedCount = 0.obs;
  final RxInt pendingCount = 0.obs;
  final RxInt rejectedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOvertime();
  }

  Future<void> fetchOvertime() async {
    try {
      isLoading.value = true;
      final result = await OvertimeApi.getOvertime(
        page: 1,
        perPage: 5,
        userId: loginUserData.value.idString,
      );

      // Filter overtime to show only current user's data
      final currentUserId = loginUserData.value.idString;
      final userOvertime = (result['overtime'] as List<OvertimeModel>)
          .where((overtime) => overtime.user.id == currentUserId)
          .toList();

      overtime.assignAll(userOvertime);

      // Update counts based on filtered data
      totalCount.value = userOvertime.length;
      approvedCount.value = userOvertime
          .where((o) => o.status.toLowerCase() == 'approved')
          .length;
      pendingCount.value =
          userOvertime.where((o) => o.status.toLowerCase() == 'pending').length;
      rejectedCount.value = userOvertime
          .where((o) => o.status.toLowerCase() == 'rejected')
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
