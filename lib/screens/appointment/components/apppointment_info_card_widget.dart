import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../model/appointments_res_model.dart';

class ApppointmentInfoCardWidget extends StatelessWidget {
  final AppointmentData appointmentDet;
  const ApppointmentInfoCardWidget({super.key, required this.appointmentDet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${locale.value.dateTime}:", style: secondaryTextStyle(size: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  6.height,
                  Text("${appointmentDet.appointmentDate} at ${appointmentDet.appointmentTime?.format24HourtoAMPM ?? ''}", style: boldTextStyle(size: 12)),
                ],
              ).expand(flex: 3),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${locale.value.appointmentType}:", style: secondaryTextStyle(size: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  6.height,
                  Text(isOnlineService ? locale.value.online : locale.value.inClinic, style: boldTextStyle(size: 12)),
                ],
              ).expand(flex: 2).visible(appointmentDet.serviceName?.isNotEmpty ?? false),
            ],
          ),
          commonDivider.paddingSymmetric(vertical: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${locale.value.appointment}:", style: secondaryTextStyle(size: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  6.height,
                  Text(getBookingStatus(status: appointmentDet.status), style: boldTextStyle(size: 12, color: getBookingStatusColor(status: appointmentDet.status))),
                ],
              ).expand(flex: 3),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${locale.value.payment}:", style: secondaryTextStyle(size: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  6.height,
                  Text(getBookingPaymentStatus(status: appointmentDet.paymentStatus ?? ""), style: boldTextStyle(size: 12, color: getPriceStatusColor(paymentStatus: appointmentDet.paymentStatus ?? ""))),
                ],
              ).expand(flex: 2),
            ],
          ),
        ],
      ),
    );
  }

  bool get isOnlineService => appointmentDet.serviceType?.toLowerCase() == ServiceTypes.online;
}
