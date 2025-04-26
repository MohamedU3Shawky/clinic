import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:egphysio_clinic_admin/utils/colors.dart';
import 'package:egphysio_clinic_admin/utils/price_widget.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/constants.dart';
import '../model/billing_details_resp.dart';
import 'tax_list_bottom_sheet.dart';

class PaymentComponent extends StatelessWidget {
  final BillingDetailModel paymentData;
  const PaymentComponent({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(locale.value.serviceTotal, style: secondaryTextStyle()).expand(),
              PriceWidget(
                price: num.parse(paymentData.totalAmount.toString()).toStringAsFixed(Constants.DECIMAL_POINT).toDouble(),
                color: isDarkMode.value ? null : darkGrayTextColor,
                size: 12,
                isBoldText: true,
              ),
            ],
          ),
          if (paymentData.enableFinalBillingDiscount)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(locale.value.discount, style: secondaryTextStyle()),
                        if (paymentData.billingFinalDiscountType == TaxType.PERCENTAGE)
                          Text(
                            ' (${paymentData.billingFinalDiscountValue}% ${locale.value.off})',
                            style: boldTextStyle(color: Colors.green, size: 12),
                          )
                        else if (paymentData.discountType == TaxType.FIXED)
                          PriceWidget(
                            price: paymentData.billingFinalDiscountValue,
                            color: Colors.green,
                            size: 12,
                            isDiscountedPrice: true,
                          )
                      ],
                    ),
                    PriceWidget(
                      price: paymentData.billingFinalDiscountAmount,
                      color: Colors.green,
                      size: 14,
                      isSemiBoldText: false,
                    )
                  ],
                ).paddingTop(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(locale.value.subtotal, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
                    PriceWidget(
                      price: num.parse(paymentData.subTotal.toString()).toStringAsFixed(Constants.DECIMAL_POINT).toDouble(),
                      color: isDarkMode.value ? null : darkGrayTextColor,
                      size: 12,
                      isBoldText: true,
                    ),
                  ],
                ).paddingTop(8),
              ],
            ),
          if (paymentData.taxData.isNotEmpty)
            detailWidgetPrice(
              leadingWidget: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(locale.value.tax, style: secondaryTextStyle()).expand(),
                  const Icon(Icons.info_outline_rounded, size: 20, color: appColorPrimary).onTap(
                    () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: radiusCircular(16),
                            topRight: radiusCircular(16),
                          ),
                        ),
                        builder: (_) {
                          return TaxListBottomSheet(
                            taxes: paymentData.taxData,
                          );
                        },
                      );
                    },
                  ),
                  8.width,
                ],
              ).expand(),
              value: paymentData.totalTax,
              isSemiBoldText: true,
              textColor: appColorSecondary,
            ).paddingTop(8),
          Divider(color: isDarkMode.value ? borderColor.withValues(alpha: 0.2) : context.dividerColor.withValues(alpha: 0.2)),
          4.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(locale.value.totalAmount, style: boldTextStyle(size: 14, color: isDarkMode.value ? null : darkGrayTextColor)).expand(),
              PriceWidget(
                price: num.parse(paymentData.finalTotalAmount.toString()).toStringAsFixed(Constants.DECIMAL_POINT).toDouble(),
                color: appColorSecondary,
                size: 18,
                isBoldText: true,
              ),
            ],
          ),
          if (paymentData.paymentStatus != 1 && paymentData.isEnableAdvancePayment && paymentData.advancePaidAmount > 0) ...[
            8.height,

            ///Advance Paid Amount
            detailWidgetPrice(
              paddingBottom: 0,
              leadingWidget: Row(
                children: [
                  Text(locale.value.advancePaidAmount, overflow: TextOverflow.ellipsis, maxLines: 2, style: secondaryTextStyle()),
                  Text(
                    ' (${paymentData.advancePaymentAmount}%)',
                    style: boldTextStyle(color: Colors.green, size: 12),
                  ),
                ],
              ).flexible(),
              textColor: completedStatusColor,
              value: paymentData.advancePaidAmount,
            ),

            if (paymentData.remainingPayableAmount > 0) ...[
              10.height,

              ///Remaining Payable Amount
              detailWidgetPrice(
                title: locale.value.remainingPayableAmount,
                textColor: pendingStatusColor,
                value: paymentData.remainingPayableAmount,
                paddingBottom: 0,
              ),
            ],
          ]
        ],
      ),
    );
  }

  Widget detailWidgetPrice({Widget? leadingWidget, Widget? trailingWidget, String? title, num? value, Color? textColor, bool isSemiBoldText = false, double? paddingBottom}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leadingWidget ?? Text(title.validate(), style: secondaryTextStyle()),
        trailingWidget ??
            PriceWidget(
              price: value.validate(),
              color: textColor ?? black,
              size: 12,
              isSemiBoldText: isSemiBoldText,
            )
      ],
    ).paddingBottom(paddingBottom ?? 10);
  }
}
