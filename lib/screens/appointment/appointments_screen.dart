import 'package:flutter/material.dart' ;
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/appointment/add_appointment/add_appointment_form_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/model/encounters_list_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/empty_error_state_widget.dart';
import '../Encounter/encounter_dashboard/encounter_dashboard.dart';
import '../doctor/model/doctor_list_res.dart';
import 'appointments_controller.dart';
import 'components/appointment_card.dart';
import 'filter/filter_screen.dart';
import 'components/search_appointment_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatelessWidget {
  AppointmentsScreen({super.key});
  final AppointmentsController appointmentsCont = Get.put(AppointmentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: locale.value.appointments,
        hasLeadingWidget: appointmentsCont.patientDetailArgument.value.isFromPatientDetail,
        appBarVerticalSize: Get.height * 0.12,
        resizeToAvoidBottomPadding: true,
        isLoading: appointmentsCont.isLoading,
        actions: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
            ? [
                IconButton(
                  onPressed: () async {
                    final doctorData = Doctor(
                      id: loginUserData.value.id,
                      doctorId: loginUserData.value.id,
                      firstName: loginUserData.value.firstName,
                      lastName: loginUserData.value.lastName,
                      email: loginUserData.value.email,
                      profileImage: loginUserData.value.profileImage,
                      address: loginUserData.value.address,
                    );
                    Get.to(() => AddAppointmentFormScreen(), arguments: doctorData)?.then((value) {
                      if (value == true) {
                        appointmentsCont.page(1);
                        appointmentsCont.getAppointmentList();
                      }
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
                ).paddingOnly(right: 8),
              ]
            : null,
        body: Obx(
          () => SnapHelperWidget(
            future: appointmentsCont.getAppointments.value,
            initialData: appointmentsCont.appointments.isNotEmpty ? appointmentsCont.appointments : null,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  appointmentsCont.page(1);
                  appointmentsCont.getAppointmentList();
                },
              ).paddingSymmetric(horizontal: 24);
            },
            loadingWidget: appointmentsCont.isLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (res) {
              return Obx(
                () => Column(
                  children: [
                    16.height,
                    // Date View Toggle
                    Obx(() => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
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
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: appointmentsCont.viewMode.value == 'daily'
                                          ? appColorPrimary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                        'Daily',
                                        style: TextStyle(
                                          color: appointmentsCont.viewMode.value == 'daily'
                                              ? Colors.white
                                              : appColorPrimary,
                                          fontWeight: FontWeight.bold,
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
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: appointmentsCont.viewMode.value == 'weekly'
                                          ? appColorPrimary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                        'Weekly',
                                        style: TextStyle(
                                          color: appointmentsCont.viewMode.value == 'weekly'
                                              ? Colors.white
                                              : appColorPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    8.height,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: () {
                                  final newStartDate = appointmentsCont.weekStartDate.value.subtract(const Duration(days: 7));
                                  final newEndDate = appointmentsCont.weekEndDate.value.subtract(const Duration(days: 7));
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
                                  final newStartDate = appointmentsCont.weekStartDate.value.add(const Duration(days: 7));
                                  final newEndDate = appointmentsCont.weekEndDate.value.add(const Duration(days: 7));
                                  appointmentsCont.setWeekDates(newStartDate, newEndDate);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                    16.height,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     SearchAppoinmentWidget(
                    //       appointmentsCont: appointmentsCont,
                    //       onFieldSubmitted: (p0) {
                    //         hideKeyboard(context);
                    //       },
                    //     ).expand(),
                    //     12.width,
                    //     InkWell(
                    //       onTap: () {
                    //         Get.to(
                    //           () => FilterScreen(),
                    //           arguments: [
                    //             appointmentsCont.selectedPatient.value,
                    //             appointmentsCont.selectedDoctor.value,
                    //             appointmentsCont.selectedServiceData.value,
                    //             appointmentsCont.status.value,
                    //           ],
                    //         );
                    //       },
                    //       child: Container(
                    //         height: 46,
                    //         width: 46,
                    //         alignment: Alignment.center,
                    //         decoration: boxDecorationDefault(color: appColorPrimary, borderRadius: BorderRadius.circular(12)),
                    //         child: const CachedImageWidget(
                    //           url: Assets.iconsIcFilter,
                    //           height: 28,
                    //           color: white,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // 16.height,
                    AnimatedListView(
                      shrinkWrap: true,
                      itemCount: appointmentsCont.appointments.length,
                      listAnimationType: ListAnimationType.None,
                      padding: EdgeInsets.only(bottom: appointmentsCont.patientDetailArgument.value.isFromPatientDetail ? 24 : 80),
                      physics: const AlwaysScrollableScrollPhysics(),
                      emptyWidget: NoDataWidget(
                        title: locale.value.noAppointmentsFound,
                        imageWidget: const EmptyStateWidget(),
                        subTitle: locale.value.thereAreCurrentlyNoAppointmentsAvailable,
                      ).paddingSymmetric(horizontal: 24).paddingBottom(Get.height * 0.15).visible(!appointmentsCont.isLoading.value),
                      itemBuilder: (context, index) {
                        final appointment = appointmentsCont.appointments[index];
                        final encounterDetail = EncounterElement(
                          id: appointment.encounterId ?? -1,
                          appointmentId: int.tryParse(appointment.id) ?? -1,
                          clinicId: appointment.clinicId ?? -1,
                          clinicName: appointment.clinicName ?? "",
                          description: appointment.encounterDescription ?? "",
                          doctorId: appointment.doctorId ?? -1,
                          doctorName: appointment.doctorName ?? "",
                          encounterDate: appointment.appointmentDate,
                          userId: int.tryParse(appointment.userId) ?? -1,
                          userName: appointment.userName ?? "",
                          userImage: appointment.userImage ?? "",
                          address: appointment.address,
                          userEmail: appointment.userEmail ?? "",
                          status: appointment.encounterStatus ?? false,
                        );
                        return AppointmentCard(
                            appointment: appointment,
                            onCheckIn: () {
                              if (appointment.status == StatusConst.check_in) {
                                Get.to(
                                  () => EncountersDashboardScreen(encounterDetail: encounterDetail),
                                  arguments: appointment.encounterId,
                                )?.then((value) {
                                  if (value == true) {
                                    appointmentsCont.getAppointmentList();
                                  }
                                });
                              } else {
                                appointmentsCont.updateStatus(
                                  id: int.tryParse(appointment.id) ?? -1,
                                  status: getUpdateStatusText(status: appointment.status),
                                  context: context,
                                  isBack: false,
                                  isCheckOut: false,
                                );
                              }
                            },
                            onEncounter: () {
                              Get.to(
                                () => EncountersDashboardScreen(encounterDetail: encounterDetail),
                                arguments: appointment.encounterId,
                              )?.then((value) {
                                if (value == true) {
                                  appointmentsCont.getAppointmentList();
                                }
                              });
                            }).paddingBottom(16);
                      },
                      onNextPage: () async {
                        if (!appointmentsCont.isLastPage.value) {
                          appointmentsCont.page(appointmentsCont.page.value + 1);
                          appointmentsCont.getAppointmentList();
                        }
                      },
                      onSwipeRefresh: () async {
                        appointmentsCont.page(1);
                        return await appointmentsCont.getAppointmentList(showloader: false);
                      },
                    ).expand(),
                  ],
                ),
              ).paddingSymmetric(horizontal: 16);
            },
          ).makeRefreshable,
        ),
      ),
    );
  }
}
