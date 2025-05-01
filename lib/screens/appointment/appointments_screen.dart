import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egphysio_clinic_admin/screens/appointment/add_appointment/add_appointment_form_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:egphysio_clinic_admin/screens/Encounter/model/encounters_list_model.dart';
import 'package:egphysio_clinic_admin/utils/colors.dart';
import 'package:egphysio_clinic_admin/utils/constants.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/empty_error_state_widget.dart';
import '../Encounter/encounter_dashboard/encounter_dashboard.dart';
import '../doctor/model/doctor_list_res.dart' as doctor_model;
import 'appointments_controller.dart';
import 'components/appointment_card.dart';
import 'filter/filter_screen.dart';
import 'components/search_appointment_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatelessWidget {
  AppointmentsScreen({super.key});
  final AppointmentsController appointmentsCont =
      Get.put(AppointmentsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.appointments,
      hasLeadingWidget:
          appointmentsCont.patientDetailArgument.value.isFromPatientDetail,
      appBarVerticalSize: Get.height * 0.12,
      resizeToAvoidBottomPadding: true,
      isLoading: false.obs,
      actions: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
          ? [
              IconButton(
                onPressed: () async {
                  final doctorData = doctor_model.Doctor(
                    id: loginUserData.value.id,
                    doctorId: loginUserData.value.id,
                    firstName: loginUserData.value.firstName,
                    lastName: loginUserData.value.lastName,
                    email: loginUserData.value.email,
                    profileImage: loginUserData.value.profileImage,
                    address: loginUserData.value.address,
                  );
                  Get.to(() => AddAppointmentFormScreen(),
                          arguments: doctorData)
                      ?.then((value) {
                    if (value == true) {
                      appointmentsCont.page(1);
                      appointmentsCont.getAppointmentList();
                    }
                  });
                },
                icon: const Icon(Icons.add_circle_outline_rounded,
                    size: 28, color: Colors.white),
              ).paddingOnly(right: 8),
            ]
          : null,
      body: Column(
        children: [
          // Date View Toggle
          Obx(() => Container(
                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: isDarkMode.value ? appBodyColor : white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: dividerColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          appointmentsCont.toggleViewMode();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: appointmentsCont.viewMode.value == 'daily'
                                ? appColorPrimary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Daily',
                              style: TextStyle(
                                color:
                                    appointmentsCont.viewMode.value == 'daily'
                                        ? Colors.white
                                        : appColorPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          appointmentsCont.toggleViewMode();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: appointmentsCont.viewMode.value == 'weekly'
                                ? appColorPrimary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Weekly',
                              style: TextStyle(
                                color:
                                    appointmentsCont.viewMode.value == 'weekly'
                                        ? Colors.white
                                        : appColorPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          // Date Selector
          Obx(() {
            if (appointmentsCont.viewMode.value == 'daily') {
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: TableCalendar(
                  rowHeight: Get.height * 0.045,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: appointmentsCont.selectedDate.value,
                  selectedDayPredicate: (day) {
                    return isSameDay(appointmentsCont.selectedDate.value, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    appointmentsCont.setSelectedDate(selectedDay);
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: appColorPrimary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: appColorPrimary.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              );
            } else {
              // Weekly view date selector
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        final newStartDate = appointmentsCont
                            .weekStartDate.value
                            .subtract(const Duration(days: 7));
                        final newEndDate = appointmentsCont.weekEndDate.value
                            .subtract(const Duration(days: 7));
                        appointmentsCont.setWeekDates(newStartDate, newEndDate);
                      },
                    ),
                    Text(
                      '${DateFormat('MMM d').format(appointmentsCont.weekStartDate.value)} - ${DateFormat('MMM d, yyyy').format(appointmentsCont.weekEndDate.value)}',
                      style: boldTextStyle(size: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        final newStartDate = appointmentsCont
                            .weekStartDate.value
                            .add(const Duration(days: 7));
                        final newEndDate = appointmentsCont.weekEndDate.value
                            .add(const Duration(days: 7));
                        appointmentsCont.setWeekDates(newStartDate, newEndDate);
                      },
                    ),
                  ],
                ),
              );
            }
          }),
          16.height,
          Expanded(
            child: Obx(() {
              if (appointmentsCont.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading appointments...',
                        style: secondaryTextStyle(size: 14),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  if (appointmentsCont.viewMode.value == 'daily') {
                    await appointmentsCont.getAppointmentList();
                  } else {
                    await appointmentsCont.getAppointmentList();
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: appointmentsCont.appointments.isEmpty
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: Get.height * 0.6,
                            alignment: Alignment.center,
                            child: NoDataWidget(
                              title: locale.value.noAppointmentsFound,
                              imageWidget: const EmptyStateWidget(),
                              subTitle: locale.value
                                  .thereAreCurrentlyNoAppointmentsAvailable,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: appointmentsCont.appointments.length,
                                itemBuilder: (context, index) {
                                  final appointment =
                                      appointmentsCont.appointments[index];
                                  final encounterDetail = EncounterElement(
                                    id: appointment.encounterId ?? -1,
                                    appointmentId:
                                        int.tryParse(appointment.id) ?? -1,
                                    clinicId: appointment.clinicId ?? -1,
                                    clinicName: appointment.clinicName ?? "",
                                    description:
                                        appointment.encounterDescription ?? "",
                                    doctorId: appointment.doctorId ?? -1,
                                    doctorName: appointment.doctorName ?? "",
                                    encounterDate: appointment.appointmentDate,
                                    userId:
                                        int.tryParse(appointment.userId) ?? -1,
                                    userName: appointment.userName ?? "",
                                    userImage: appointment.userImage ?? "",
                                    address: appointment.address,
                                    userEmail: appointment.userEmail ?? "",
                                    status:
                                        appointment.encounterStatus ?? false,
                                  );
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    child: AppointmentCard(
                                      key: ValueKey(appointment.id),
                                      appointment: appointment,
                                      onCheckIn: () {
                                        if (appointment.status ==
                                            StatusConst.check_in) {
                                          Get.to(
                                            () => EncountersDashboardScreen(
                                                encounterDetail:
                                                    encounterDetail),
                                            arguments: appointment.encounterId,
                                          )?.then((value) {
                                            if (value == true) {
                                              appointmentsCont
                                                  .getAppointmentList();
                                            }
                                          });
                                        } else {
                                          appointmentsCont.updateStatus(
                                            id: int.tryParse(appointment.id) ??
                                                -1,
                                            status: getUpdateStatusText(
                                                status: appointment.status),
                                            context: context,
                                            isBack: false,
                                            isCheckOut: false,
                                          );
                                        }
                                      },
                                      onEncounter: () {
                                        Get.to(
                                          () => EncountersDashboardScreen(
                                              encounterDetail: encounterDetail),
                                          arguments: appointment.encounterId,
                                        )?.then((value) {
                                          if (value == true) {
                                            appointmentsCont
                                                .getAppointmentList();
                                          }
                                        });
                                      },
                                    ).paddingBottom(16),
                                  );
                                },
                              ),
                              // if (!appointmentsCont.isLastPage.value)
                              //   const Padding(
                              //     padding: EdgeInsets.symmetric(vertical: 16),
                              //     child: Center(
                              //       child: CircularProgressIndicator(),
                              //     ),
                              //   ),
                            ],
                          ).paddingSymmetric(horizontal: 16),
                        ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
