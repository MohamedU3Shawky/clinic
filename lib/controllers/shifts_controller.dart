import 'package:get/get.dart';
import '../models/shift_model.dart';
import '../api/shift_apis.dart';

class ShiftsController extends GetxController {
  final RxList<ShiftModel> shifts = <ShiftModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShifts();
  }

  Future<void> fetchShifts() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get current month's start and end dates
      final now = DateTime.now();
      final startDate =
          DateTime(now.year, now.month, 1).toString().split(' ')[0];
      final endDate =
          DateTime(now.year, now.month + 1, 0).toString().split(' ')[0];

      final fetchedShifts = await ShiftServiceApis.getShifts(
        startDate: startDate,
        endDate: endDate,
      );

      shifts.assignAll(fetchedShifts);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addShift(ShiftModel shift) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await ShiftServiceApis.addShift(shift);
      if (success) {
        await fetchShifts(); // Refresh the list
      }
      return success;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateShift(ShiftModel shift) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await ShiftServiceApis.updateShift(shift);
      if (success) {
        await fetchShifts(); // Refresh the list
      }
      return success;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteShift(String id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await ShiftServiceApis.deleteShift(id);
      if (success) {
        await fetchShifts(); // Refresh the list
      }
      return success;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
