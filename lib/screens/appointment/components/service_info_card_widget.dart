import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/price_widget.dart';
import '../../service/model/service_list_model.dart';
import '../model/appointments_res_model.dart';

class ServiceInfoCardWidget extends StatelessWidget {
  final AppointmentData appointmentDet;

  const ServiceInfoCardWidget({super.key, required this.appointmentDet});

  @override
  Widget build(BuildContext context) {
    final billingItems = appointmentDet.billingItems ?? [];
    
    return billingItems.isEmpty
        ? Container(
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              children: [
                16.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: boxDecorationDefault(),
                      child: CachedImageWidget(
                        url: appointmentDet.serviceImage ?? "",
                        fit: BoxFit.cover,
                        radius: 6,
                      ),
                    ),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: boxDecorationDefault(
                            color: isDarkMode.value ? Colors.grey.withValues(alpha: 0.1) : lightSecondaryColor,
                            borderRadius: radius(8),
                          ),
                          child: Text(
                            appointmentDet.categoryName ?? "",
                            style: boldTextStyle(size: 10, fontFamily: fontFamilyWeight700, color: appColorSecondary),
                          ),
                        ).visible(appointmentDet.categoryName?.isNotEmpty ?? false),
                        8.height,
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(appointmentDet.serviceName ?? "", overflow: TextOverflow.ellipsis, maxLines: 2, style: boldTextStyle(size: 16)).expand(),
                              ],
                            ),
                            8.height,
                            Row(
                              children: [
                                PriceWidget(
                                  price: appointmentDet.servicePrice ?? 0,
                                  color: dividerColor,
                                  isLineThroughEnabled: (appointmentDet.discountValue ?? 0) > 0 && (appointmentDet.discountAmount ?? 0) > 0 ? true : false,
                                  size: 12,
                                  isBoldText: true,
                                ).paddingRight(6),
                                if ((appointmentDet.discountValue ?? 0) > 0 && (appointmentDet.discountAmount ?? 0) > 0)
                                  PriceWidget(
                                    price: appointmentDet.serviceAmount ?? 0,
                                    color: dividerColor,
                                    size: 12,
                                    isBoldText: true,
                                  ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ).expand(),
                  ],
                ),
                16.height,
              ],
            ).paddingSymmetric(horizontal: 16),
          )
        : AnimatedListView(
            shrinkWrap: true,
            itemCount: billingItems.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            listAnimationType: ListAnimationType.None,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final item = billingItems[index];
              num servicePrice = item.serviceDetail?.assignDoctor
                  .firstWhere(
                    (e) => e.doctorId == appointmentDet.doctorId,
                    orElse: () => AssignDoctor(
                      priceDetail: PriceDetail(
                        serviceAmount: item.serviceAmount,
                      ),
                    ),
                  )
                  .priceDetail
                  .serviceAmount ?? 0;
              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: boxDecorationDefault(),
                      child: CachedImageWidget(
                        url: item.serviceDetail != null ? item.serviceDetail!.serviceImage : "",
                        fit: BoxFit.cover,
                        radius: 6,
                      ),
                    ).paddingRight(16).visible(item.serviceDetail != null),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.itemName, maxLines: 2, overflow: TextOverflow.ellipsis, style: boldTextStyle(size: 14)).expand(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              locale.value.total,
                              overflow: TextOverflow.ellipsis,
                              style: primaryTextStyle(size: 12, color: dividerColor),
                            ),
                            16.width,
                            Flexible(
                              child: Marquee(
                                child: Row(
                                  children: [
                                    PriceWidget(
                                      price: item.serviceAmount,
                                      color: dividerColor,
                                      isLineThroughEnabled: item.serviceDetail != null && item.serviceDetail!.discount && isAppointmentService(index) ? true : false,
                                      size: 12,
                                      isBoldText: true,
                                    ).paddingRight(6),
                                    if (item.serviceDetail != null && item.serviceDetail!.discount && isAppointmentService(index))
                                      PriceWidget(
                                        price: servicePrice,
                                        color: dividerColor,
                                        size: 12,
                                        isBoldText: true,
                                      ),
                                    Text(" x ${item.quantity} = ", style: primaryTextStyle(size: 12, color: dividerColor)),
                                    PriceWidget(
                                      price: item.totalAmount,
                                      color: appColorPrimary,
                                      size: 14,
                                      isBoldText: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).flexible(),
                  ],
                ),
              );
            },
          );
  }

  bool isAppointmentService(index) {
    final items = appointmentDet.billingItems ?? [];
    if (index >= items.length) return false;
    return items[index].serviceDetail != null && items[index].serviceDetail!.id == appointmentDet.serviceId;
  }
}
