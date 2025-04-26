import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:egphysio_clinic_admin/screens/appointment/components/clinic_info_card_widget.dart';
import '../../../components/app_scaffold.dart';
import '../../../utils/common_base.dart';
import '../../components/cached_image_widget.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../utils/price_widget.dart';
import '../../utils/view_all_label_component.dart';
import '../Encounter/encounter_dashboard/encounter_dashboard.dart';
import '../Encounter/model/encounters_list_model.dart';
import 'appointment_detail_controller.dart';
import 'components/appointment_detail_applied_tax_list_bottom_sheet.dart';
import 'components/doctor_info_card_widget.dart';
import 'components/apppointment_info_card_widget.dart';
import 'components/patient_info_card_widget.dart';
import 'components/service_info_card_widget.dart';
import 'model/appointments_res_model.dart';
import '../../utils/constants.dart';

class AppointmentDetail extends StatelessWidget {
  final AppointmentData appointment;
  final AppointmentDetailController appointmentDetailCont = Get.put(AppointmentDetailController());
  AppointmentDetail({super.key}) : appointment = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: appointmentDetailCont.isUpdateLoading,
      appBartitleText: locale.value.appointment,
      appBarVerticalSize: Get.height * 0.12,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Date Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusBadge(status: appointment.status),
                      Text(
                        DateFormat('MMM dd, yyyy').format(DateTime.parse(appointment.appointmentDate)),
                        style: boldTextStyle(size: 14),
                      ),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: appColorPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.access_time, size: 20, color: appColorPrimary),
                      ),
                      12.width,
                      Text(
                        DateFormat.jm('en_US').format(tz.TZDateTime.from(DateTime.parse(appointment.appointmentDate), tz.getLocation('Africa/Cairo'))),
                        style: primaryTextStyle(size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            16.height,
            // Appointment Type and Location
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: appColorPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_hospital, size: 20, color: appColorPrimary),
                      ),
                      12.width,
                      Text(locale.value.appointmentType, style: boldTextStyle(size: 16)),
                    ],
                  ),
                  16.height,
                  Text(appointment.appointmentType ?? '', style: primaryTextStyle()),
                  16.height,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: appColorPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on, size: 20, color: appColorPrimary),
                      ),
                      12.width,
                      Text(locale.value.location, style: boldTextStyle(size: 16)),
                    ],
                  ),
                  8.height,
                  if (appointment.clinicalRoom.name.isNotEmpty) ...[
                    8.height,
                    Text(
                      '${appointment.appointmentType == "Clinic" ? 'Room' : locale.value.address}: ${appointment.appointmentType == "Clinic" ? appointment.clinicalRoom.name : appointment.address}',
                      style: primaryTextStyle(),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: 
                   Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appColorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      
                    ),
              child:     Text('${appointment.branch.name ?? ''}', style: primaryTextStyle()),),
                  )
                ],
              ),
            ),
            16.height,
            // Patient Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: appColorPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 20, color: appColorPrimary),
                      ),
                      12.width,
                      Text(locale.value.patientInfo, style: boldTextStyle(size: 16)),
                    ],
                  ),
                  16.height,
                  Text('${locale.value.name}: ${appointment.client.name ?? ''}', style: primaryTextStyle()),
                  8.height,
                  if (appointment.client.phones.isNotEmpty)
                    Text('${locale.value.contactNumber}: ${appointment.client.phones.first}', style: primaryTextStyle()),
                  if (appointment.client.email?.isNotEmpty ?? false)
                    Text('${locale.value.email}: ${appointment.client.email}', style: primaryTextStyle()),
                ],
              ),
            ),
            16.height,
            // Doctor Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: appColorPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.medical_services, size: 20, color: appColorPrimary),
                      ),
                      12.width,
                      Text(locale.value.doctorInfo, style: boldTextStyle(size: 16)),
                    ],
                  ),
                  16.height,
                  Text('${locale.value.name}: ${appointment.user.name ?? ''}', style: primaryTextStyle()),
                  if (appointment.user.email?.isNotEmpty ?? false)
                    Text('${locale.value.email}: ${appointment.user.email}', style: primaryTextStyle()),
                ],
              ),
            ),
            16.height,
            // Services and Payment
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: appColorPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.receipt_long, size: 20, color: appColorPrimary),
                      ),
                      12.width,
                      Text(locale.value.services + ' & ' + locale.value.payment, style: boldTextStyle(size: 16)),
                    ],
                  ),
                  16.height,
                  ...appointment.services.map((service) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(service.name ?? '', style: primaryTextStyle()),
                        Text(
                          service.cost != null ? '\$${service.cost!.toStringAsFixed(2)}' : '-',
                          style: primaryTextStyle(),
                        ),
                      ],
                    ),
                  )),
                  const Divider(),
                  8.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(locale.value.total, style: boldTextStyle(size: 16, color: appColorPrimary)),
                      Text(
                        '\$${appointment.services.fold<num>(0, (sum, s) => sum + (s.cost ?? 0)).toStringAsFixed(2)}',
                        style: boldTextStyle(size: 18, color: appColorPrimary),
                      ),
                    ],
                  ),
                  if (appointment.paymentStatus?.isNotEmpty ?? false) ...[
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locale.value.paymentStatus, style: secondaryTextStyle()),
                        Text(
                          appointment.paymentStatus ?? '',
                          style: boldTextStyle(
                            color: appointment.paymentStatus == PaymentStatus.PAID ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            16.height,
            // Action Button
            // if ((appointment.status != StatusConst.checkout && appointment.status != StatusConst.completed && appointment.status != StatusConst.cancelled) || 
            //     ((appointment.isEnableAdvancePayment ?? false) && appointment.paymentStatus == PaymentStatus.ADVANCE_PAID))
            //   AppButton(
            //     width: Get.width,
            //     height: 48,
            //     padding: EdgeInsets.zero,
            //     color: isDarkMode.value ? Colors.grey.withValues(alpha: 0.1) : extraLightPrimaryColor,
            //     shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
            //     text: getUpdateStatusText(status: appointment.status),
            //     textStyle: appButtonPrimaryColorText,
            //     onTap: () {
            //       // Handle action based on status
            //     },
            //   ),
          ],
        ),
      ),
    );
  }
}
