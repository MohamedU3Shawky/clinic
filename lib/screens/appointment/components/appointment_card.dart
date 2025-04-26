import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:egphysio_clinic_admin/generated/assets.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../../utils/price_widget.dart';
import '../appointment_detail.dart';
import '../appointments_controller.dart';
import '../model/appointments_res_model.dart';
import '../../../utils/constants.dart';

class AppointmentCard extends StatelessWidget {
  final Function? onCheckIn;
  final Function? onEncounter;
  final AppointmentData appointment;
  AppointmentCard({
    super.key,
    required this.appointment,
    this.onCheckIn,
    this.onEncounter,
  }) {
    tz.initializeTimeZones();
  }

  final AppointmentsController appointmentsCont = Get.put(AppointmentsController());

  bool get showBtns =>
      (appointment.status != StatusConst.checkout && appointment.status != StatusConst.completed && appointment.status != StatusConst.cancelled) || 
      ((appointment.isEnableAdvancePayment ?? false) && appointment.paymentStatus == PaymentStatus.ADVANCE_PAID);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        Get.to(() => AppointmentDetail(), arguments: appointment);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.cardColor.withOpacity(0.98),
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
                  style: secondaryTextStyle(size: 12),
                ),
              ],
            ),
            8.height,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appColorPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.access_time, size: 16, color: appColorPrimary),
                ),
                8.width,
                Text(
                  DateFormat.jm('en_US').format(tz.TZDateTime.from(DateTime.parse(appointment.appointmentDate), tz.getLocation('Africa/Cairo'))),
                  style: boldTextStyle(size: 14),
                ),
              ],
            ),
            8.height,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appColorPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 16, color: appColorPrimary),
                ),
                8.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.client.name ?? '',
                        style: boldTextStyle(size: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        locale.value.patient,
                        style: secondaryTextStyle(size: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            8.height,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appColorPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.medical_services, size: 16, color: appColorPrimary),
                ),
                8.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.user.name ?? '',
                        style: boldTextStyle(size: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        locale.value.doctor,
                        style: secondaryTextStyle(size: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showBtns) ...[
              8.height,
              AppButton(
                width: Get.width,
                height: 36,
                padding: EdgeInsets.zero,
                color: isDarkMode.value ? Colors.grey.withValues(alpha: 0.1) : extraLightPrimaryColor,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                text: locale.value.viewDetails,
                textStyle: appButtonPrimaryColorText.copyWith(fontSize: 12),
                onTap: () {
                  hideKeyboard(context);
                  Get.to(() => AppointmentDetail(), arguments: appointment);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool get isOnlineService => appointment.serviceType?.toLowerCase() == ServiceTypes.online;
}
