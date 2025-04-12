import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import 'model/schedule_model.dart';

class ScheduleController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<ScheduleModel> schedules = <ScheduleModel>[].obs;
  RxInt page = 1.obs;
  RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    getScheduleList();
  }

  Future<void> getScheduleList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }

    try {
      // TODO: Implement API call to fetch schedules
      // For now, using dummy data
      await Future.delayed(Duration(seconds: 1));

      // Dummy data

      hasMoreData(false); // Set to false since we're using dummy data
    } catch (e) {
      log('getScheduleList Error: $e');
      toast(e.toString());
    } finally {
      if (showLoader) {
        isLoading(false);
      }
    }
  }

  void resetPagination() {
    page(1);
    hasMoreData(true);
    schedules.clear();
  }

  Future<void> loadMore() async {
    if (!hasMoreData.value || isLoading.value) return;

    page(page.value + 1);
    await getScheduleList(showLoader: false);
  }
}
