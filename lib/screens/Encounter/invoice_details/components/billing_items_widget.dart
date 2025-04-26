// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egphysio_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/price_widget.dart';
import '../../../service/model/service_list_model.dart';
import '../../generate_invoice/components/add_billing_item_component.dart';
import '../invoice_details_controller.dart';

class BillingItemsWidget extends StatelessWidget {
  BillingItemsWidget({super.key});

  final InvoiceDetailsController genInvoiceCon = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedListView(
        shrinkWrap: true,
        itemCount: genInvoiceCon.billingItemList.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        listAnimationType: ListAnimationType.None,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: boxDecorationDefault(),
                  child: CachedImageWidget(
                    url: genInvoiceCon.billingItemList[index].serviceDetail != null ? genInvoiceCon.billingItemList[index].serviceDetail!.serviceImage : "",
                    fit: BoxFit.cover,
                    radius: 6,
                  ),
                ).paddingRight(16).visible(genInvoiceCon.billingItemList[index].serviceDetail != null),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(genInvoiceCon.billingItemList[index].itemName, overflow: TextOverflow.ellipsis, style: boldTextStyle(size: 14, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)).expand(),
                        Obx(
                          () => Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                                constraints: const BoxConstraints(),
                                style: const ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  genInvoiceCon.servicesCont.text = genInvoiceCon.billingItemList[index].itemName;
                                  genInvoiceCon.quantityCont.text = genInvoiceCon.billingItemList[index].quantity.toString();
                                  genInvoiceCon.priceCont.text = genInvoiceCon.billingItemList[index].serviceAmount.toString();
                                  Get.bottomSheet(AddBillingItemComponent(billingItem: genInvoiceCon.billingItemList[index], index: index));
                                },
                                icon: const CachedImageWidget(
                                  url: Assets.iconsIcEditReview,
                                  height: 18,
                                  width: 18,
                                  color: iconColor,
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                                constraints: const BoxConstraints(),
                                style: const ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  genInvoiceCon.handleDeleteBillingItemClick(context: context, id: genInvoiceCon.billingItemList[index].id);
                                },
                                icon: const CachedImageWidget(
                                  url: Assets.iconsIcDelete,
                                  height: 18,
                                  width: 18,
                                  color: iconColor,
                                ),
                              ),
                            ],
                          ).visible(genInvoiceCon.isEditMode.value && !isAppointmentService(index)),
                        ),
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
                                  price: genInvoiceCon.billingItemList[index].serviceAmount,
                                  color: dividerColor,
                                  size: 12,
                                  isLineThroughEnabled: genInvoiceCon.billingItemList[index].serviceDetail != null && genInvoiceCon.billingItemList[index].serviceDetail!.discount && isAppointmentService(index) ? true : false,
                                  isBoldText: true,
                                ).paddingRight(6),
                                if (genInvoiceCon.billingItemList[index].serviceDetail != null && genInvoiceCon.billingItemList[index].serviceDetail!.discount && isAppointmentService(index))
                                  PriceWidget(
                                    price: genInvoiceCon.billingItemList[index].serviceDetail!.assignDoctor
                                        .firstWhere(
                                          (e) => e.doctorId == genInvoiceCon.invoiceData.value.doctorId,
                                          orElse: () => AssignDoctor(
                                            charges: genInvoiceCon.billingItemList[index].serviceAmount,
                                            clinicId: genInvoiceCon.invoiceData.value.clinicId,
                                            clinicName: genInvoiceCon.invoiceData.value.clinicName,
                                            doctorName: genInvoiceCon.invoiceData.value.doctorName,
                                            doctorId: genInvoiceCon.invoiceData.value.doctorId,
                                            name: genInvoiceCon.invoiceData.value.serviceName,
                                            serviceId: genInvoiceCon.invoiceData.value.serviceId,
                                            priceDetail: PriceDetail(
                                              serviceAmount: genInvoiceCon.billingItemList[index].serviceAmount,
                                            ),
                                          ),
                                        )
                                        .priceDetail
                                        .serviceAmount,
                                    color: dividerColor,
                                    size: 12,
                                    isBoldText: true,
                                  ),
                                Text(" x ${genInvoiceCon.billingItemList[index].quantity} = ", style: primaryTextStyle(size: 12, color: dividerColor)),
                                PriceWidget(
                                  price: genInvoiceCon.billingItemList[index].totalAmount,
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
      ),
    );
  }

  bool isAppointmentService(index) => genInvoiceCon.billingItemList[index].serviceDetail != null && genInvoiceCon.billingItemList[index].serviceDetail!.id == genInvoiceCon.invoiceData.value.serviceId;
}
