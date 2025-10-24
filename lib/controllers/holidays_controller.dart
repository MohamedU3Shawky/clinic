import 'package:get/get.dart';
import 'package:egphysio_clinic_admin/api/holiday_apis.dart';
import 'package:egphysio_clinic_admin/models/holiday_model.dart';
import 'package:egphysio_clinic_admin/utils/app_common.dart';

class HolidaysController extends GetxController {
  final _holidayService = HolidayServiceApis();
  final RxBool isLoading = false.obs;
  final RxList<HolidayModel> holidays = <HolidayModel>[].obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final RxString viewMode = 'list'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHolidaysForMonth();
  }

  void setMonth(DateTime month) {
    selectedMonth.value = month;
    fetchHolidaysForMonth();
  }

  void setSelectedDay(DateTime day) {
    selectedDay.value = day;
  }

  void changeViewMode(String mode) {
    viewMode.value = mode;
  }

  Future<void> fetchHolidaysForMonth() async {
    isLoading.value = true;
    try {
      final response = await _holidayService.getHolidaysForMonth(
        selectedMonth.value.year,
        selectedMonth.value.month,
      );

      // Filter holidays to show only those applicable to current user
      final currentUserId = loginUserData.value.idString;
      final userHolidays = response.where((holiday) {
        return holiday.users.any((user) => user.id == currentUserId);
      }).toList();

      holidays.value = userHolidays;
      print('Fetched ${userHolidays.length} holidays for current user');
    } catch (e) {
      print('Error fetching holidays: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<HolidayModel> getUserHolidays() {
    final currentUserId = loginUserData.value.idString;
    print('Current user ID: $currentUserId');

    final userHolidays = holidays.where((holiday) {
      final isUserInHoliday =
          holiday.users.any((user) => user.id == currentUserId);
      print('Holiday: ${holiday.name}, User in holiday: $isUserInHoliday');
      return isUserInHoliday;
    }).toList();

    print('Found ${userHolidays.length} holidays for current user');
    return userHolidays;
  }

  Set<DateTime> getHolidayDates() {
    final dates = <DateTime>{};
    for (final holiday in holidays) {
      DateTime currentDate = holiday.from;
      while (currentDate.isBefore(holiday.to) ||
          currentDate.isAtSameMomentAs(holiday.to)) {
        dates.add(
            DateTime(currentDate.year, currentDate.month, currentDate.day));
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
    return dates;
  }

  List<HolidayModel> getHolidaysForDay(DateTime day) {
    return holidays.where((holiday) {
      final dayStart = DateTime(day.year, day.month, day.day);
      final holidayStart =
          DateTime(holiday.from.year, holiday.from.month, holiday.from.day);
      final holidayEnd =
          DateTime(holiday.to.year, holiday.to.month, holiday.to.day);
      return (dayStart.isAtSameMomentAs(holidayStart) ||
              dayStart.isAfter(holidayStart)) &&
          (dayStart.isAtSameMomentAs(holidayEnd) ||
              dayStart.isBefore(holidayEnd));
    }).toList();
  }
}
