import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egphysio_clinic_admin/screens/home/components/timer_component.dart';
import 'package:egphysio_clinic_admin/screens/home/home_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../home/model/attendance_records_model.dart';


class AllAttendanceCard extends StatelessWidget {
  final Record attendanceRecord;
  final bool isLast;
  AllAttendanceCard({
    super.key,
    required this.attendanceRecord,
    required this.isLast,
  });

  final HomeController allAttendanceRecord = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: boxDecorationDefault(
            color: context.cardColor,
            borderRadius: radius(defaultRadius / 2),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Row(
                children: [
                  Text(attendanceRecord.user!.name.toString(), style: boldTextStyle(size: 16)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: boxDecorationDefault(
                      borderRadius: BorderRadius.circular(20),
                      color: attendanceRecord.automatic! ? lightGreenColor : lightSecondaryColor,
                    ),
                    child: Text(attendanceRecord.automatic! ? locale.value.active : locale.value.closed, style: boldTextStyle(size: 10, color: attendanceRecord.automatic! ? completedStatusColor : appColorSecondary, weight: FontWeight.w700)),
                  ),
                ],
              ).paddingSymmetric(horizontal: 16),
              8.height,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${/*locale.value.checkInDate*/'checkIn Date'}:',
                              style: primaryTextStyle(size: 12, color: secondaryTextColor),
                            ),
                            6.width,
                            Text(
                              attendanceRecord.checkInDate!.dateInddMMMyyyyHHmmAmPmFormat,
                              overflow: TextOverflow.ellipsis,
                              style: boldTextStyle(size: 12),
                            ).expand(),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        6.height,
                        Row(
                          children: [
                            Text(
                              '${/*locale.value.checkInDate*/'checkOut Date'}:',
                              style: primaryTextStyle(size: 12, color: secondaryTextColor),
                            ),
                            6.width,
                            Text(
                              attendanceRecord.checkOutDate?.dateInddMMMyyyyHHmmAmPmFormat ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                              style: boldTextStyle(size: 12),
                            ).expand(),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        6.height,
                        Row(
                          children: [
                            Text(
                              '${locale.value.clinicName}:',
                              style: primaryTextStyle(size: 12, color: secondaryTextColor),
                            ),
                            6.width,
                            Text(
                              attendanceRecord.branch!.name.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: boldTextStyle(size: 12),
                            ).expand(),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                      ],
                    ),
                  ),
                  CounterWidget(
                    checkInTime:DateTime.parse(attendanceRecord.checkInDate!).toLocal(),
                    checkOutTime:attendanceRecord.checkOutDate!=null?DateTime.parse(attendanceRecord.checkOutDate!).toLocal():null,// Pass null to keep the timer running
                  ),
                ],
              ),
            ],
          ),
        ),
         SizedBox(
          height: Get.height * 0.1,
        ).visible(isLast)
      ],
    );
  }
}
