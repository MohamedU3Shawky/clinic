import 'package:get/get.dart';
import '../api/overtime_api.dart';
import '../models/overtime_model.dart';

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
      );

      overtime.assignAll(result['overtime'] as List<OvertimeModel>);
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