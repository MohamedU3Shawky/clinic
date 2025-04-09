import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/appointment/components/clinic_info_card_widget.dart';
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

class AppointmentDetail extends StatelessWidget {
  AppointmentDetail({Key? key}) : super(key: key);
  final AppointmentDetailController appointmentDetailCont = Get.put(AppointmentDetailController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: appointmentDetailCont.isUpdateLoading,
      appBartitleText: "${locale.value.appointment} #${appointmentDetailCont.appintmentData.value.id}",
      appBarVerticalSize: Get.height * 0.12,
      body: RefreshIndicator(
        onRefresh: () {
          return appointmentDetailCont.init(showLoader: false);
        },
        child: Obx(
          () => SnapHelperWidget(
            future: appointmentDetailCont.getAppointmentDetails.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  appointmentDetailCont.init();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: appointmentDetailCont.isUpdateLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (appointmentDetailRes) {
              return Obx(
                () => AnimatedScrollView(
                  listAnimationType: ListAnimationType.FadeIn,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: showBtns.obs.value ? 64 : 16),
                  children: [
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locale.value.sessionSummary, style: boldTextStyle(size: Constants.labelTextSize)),

                        ///Invoice Download
                        SizedBox(
                          height: 23,
                          child: AppButton(
                            padding: EdgeInsets.zero,
                            textStyle: secondaryTextStyle(color: Colors.white),
                            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                            onTap: () {
                              appointmentDetailCont.getAppointmentInvoice();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CachedImageWidget(
                                  url: Assets.iconsIcDownload,
                                  height: 14,
                                  width: 14,
                                  color: white,
                                ),
                                6.width,
                                Text(locale.value.invoice, style: primaryTextStyle(size: 12, color: white)),
                              ],
                            ),
                          ),
                        ).visible(appointmentDetailCont.appintmentData.value.status == StatusConst.checkout || appointmentDetailCont.appintmentData.value.status == StatusConst.completed),
                      ],
                    ),
                    8.height,
                    ApppointmentInfoCardWidget(
                      appointmentDet: appointmentDetailCont.appintmentData.value,
                    ),
                    if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)) ...[
                      if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) ...[
                        16.height,
                        Text(locale.value.clinicInfo, style: boldTextStyle(size: Constants.labelTextSize)),
                        8.height,
                        ClinicInfoCardWidget(
                          clinicInfo: appointmentDetailCont.appintmentData.value,
                        ),
                      ],
                      16.height,
                      Text(locale.value.doctorInfo, style: boldTextStyle(size: Constants.labelTextSize)),
                      8.height,
                      DoctorInfoCardWidget(
                        doctorInfo: appointmentDetailCont.appintmentData.value,
                      ),
                    ],
                    16.height,
                    Text(locale.value.patientInfo, style: boldTextStyle(size: Constants.labelTextSize)),
                    8.height,
                    PatientInfoCardWidget(
                      appointmentDet: appointmentDetailCont.appintmentData.value,
                    ),
                    16.height,
                    Text(locale.value.aboutService, style: boldTextStyle(size: Constants.labelTextSize)),
                    8.height,
                    ServiceInfoCardWidget(
                      appointmentDet: appointmentDetailCont.appintmentData.value,
                    ),
                    if ((appointmentDetailCont.appintmentData.value.encounterId ?? 0) > 0 && (appointmentDetailCont.appintmentData.value.status == StatusConst.check_in || appointmentDetailCont.appintmentData.value.status == StatusConst.checkout))
                      Column(
                        children: [
                          16.height,
                          ViewAllLabel(
                            label: locale.value.encounterDetails,
                            trailingText: locale.value.viewAll,
                            onTap: () {
                              final encounterDetail = EncounterElement(
                                id: appointmentDetailCont.appintmentData.value.encounterId ?? -1,
                                appointmentId: int.tryParse(appointmentDetailCont.appintmentData.value.id) ?? -1,
                                clinicId: appointmentDetailCont.appintmentData.value.clinicId ?? -1,
                                clinicName: appointmentDetailCont.appintmentData.value.clinicName ?? "",
                                description: appointmentDetailCont.appintmentData.value.encounterDescription ?? "",
                                doctorId: appointmentDetailCont.appintmentData.value.doctorId ?? -1,
                                doctorName: appointmentDetailCont.appintmentData.value.doctorName ?? "",
                                encounterDate: appointmentDetailCont.appintmentData.value.appointmentDate,
                                userId: int.tryParse(appointmentDetailCont.appintmentData.value.userId) ?? -1,
                                userName: appointmentDetailCont.appintmentData.value.userName ?? "",
                                userImage: appointmentDetailCont.appintmentData.value.userImage ?? "",
                                serviceId: appointmentDetailCont.appintmentData.value.serviceId ?? -1,
                                address: appointmentDetailCont.appintmentData.value.address,
                                userEmail: appointmentDetailCont.appintmentData.value.userEmail ?? "",
                                status: appointmentDetailCont.appintmentData.value.encounterStatus ?? false,
                              );

                              Get.to(
                                () => EncountersDashboardScreen(encounterDetail: encounterDetail),
                                arguments: appointmentDetailCont.appintmentData.value.encounterId,
                              )?.then((value) {
                                if (value == true) {
                                  appointmentDetailCont.init();
                                }
                              });
                            },
                          ),
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(16),
                            decoration: boxDecorationDefault(color: context.cardColor),
                            child: Column(
                              children: [
                                detailWidget(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  leadingWidget: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${locale.value.doctorName}: ', style: secondaryTextStyle()),
                                      Marquee(
                                        child: Text(
                                          appointmentDetailCont.appintmentData.value.doctorName ?? "",
                                          style: boldTextStyle(size: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ).expand(),
                                    ],
                                  ).expand(flex: 3),
                                  trailingWidget: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: boxDecorationDefault(
                                      color: (appointmentDetailCont.appintmentData.value.encounterStatus ?? false) ? lightGreenColor : lightSecondaryColor,
                                      borderRadius: radius(22),
                                    ),
                                    child: Text(
                                      (appointmentDetailCont.appintmentData.value.encounterStatus ?? false) ? locale.value.active : locale.value.closed,
                                      style: boldTextStyle(
                                        size: 12,
                                        color: (appointmentDetailCont.appintmentData.value.encounterStatus ?? false) ? completedStatusColor : pendingStatusColor,
                                      ),
                                    ),
                                  ).paddingLeft(16),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${locale.value.clinicName}: ', style: secondaryTextStyle()),
                                    Text(
                                      appointmentDetailCont.appintmentData.value.clinicName ?? "",
                                      style: boldTextStyle(size: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ).expand(),
                                  ],
                                ),
                                if (appointmentDetailCont.appintmentData.value.encounterDescription?.isNotEmpty ?? false) ...[
                                  commonDivider.paddingSymmetric(vertical: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${locale.value.description}: ', style: secondaryTextStyle()),
                                      Text(
                                        appointmentDetailCont.appintmentData.value.encounterDescription ?? "",
                                        style: boldTextStyle(size: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ).expand(),
                                    ],
                                  )
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    16.height,
                    paymentDetails(context),
                    16.height,
                  ],
                ).paddingSymmetric(horizontal: 16),
              );
            },
          ),
        ),
      ),
      widgetsStackedOverBody: [
        Positioned(
          bottom: 16,
          width: Get.width,
          child: Obx(
            () => showBtns.obs.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppButton(
                        width: Get.width,
                        height: 48,
                        padding: EdgeInsets.zero,
                        color: appColorPrimary,
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                        text: getUpdateStatusText(status: appointmentDetailCont.appintmentData.value.status),
                        textStyle: appButtonPrimaryColorText.copyWith(color: white),
                        onTap: () {
                          final encounterDetail = EncounterElement(
                            id: appointmentDetailCont.appintmentData.value.encounterId ?? -1,
                            appointmentId: int.tryParse(appointmentDetailCont.appintmentData.value.id) ?? -1,
                            clinicId: appointmentDetailCont.appintmentData.value.clinicId ?? -1,
                            clinicName: appointmentDetailCont.appintmentData.value.clinicName ?? "",
                            description: appointmentDetailCont.appintmentData.value.encounterDescription ?? "",
                            doctorId: appointmentDetailCont.appintmentData.value.doctorId ?? -1,
                            doctorName: appointmentDetailCont.appintmentData.value.doctorName ?? "",
                            encounterDate: appointmentDetailCont.appintmentData.value.appointmentDate,
                            userId: int.tryParse(appointmentDetailCont.appintmentData.value.userId) ?? -1,
                            userName: appointmentDetailCont.appintmentData.value.userName ?? "",
                            userImage: appointmentDetailCont.appintmentData.value.userImage ?? "",
                            address: appointmentDetailCont.appintmentData.value.address,
                            userEmail: appointmentDetailCont.appintmentData.value.userEmail ?? "",
                            status: appointmentDetailCont.appintmentData.value.encounterStatus ?? false,
                          );

                          if (appointmentDetailCont.appintmentData.value.status == StatusConst.check_in) {
                            Get.to(
                              () => EncountersDashboardScreen(encounterDetail: encounterDetail),
                              arguments: appointmentDetailCont.appintmentData.value.encounterId,
                            );
                          } else {
                            appointmentDetailCont.updateStatus(
                              id: int.tryParse(appointmentDetailCont.appintmentData.value.id) ?? -1, 
                              status: getUpdateStatusText(status: appointmentDetailCont.appintmentData.value.status), 
                              context: context, 
                              isClockOut: false, 
                              encountDetails: encounterDetail
                            );
                          }
                        },
                      ).expand(),
                    ],
                  ).paddingSymmetric(horizontal: 16)
                : const Offstage(),
          ),
        )
      ],
    );
  }

  bool get showBtns =>
      (appointmentDetailCont.appintmentData.value.status != StatusConst.checkout && appointmentDetailCont.appintmentData.value.status != StatusConst.cancelled) ||
      ((appointmentDetailCont.appintmentData.value.isEnableAdvancePayment ?? false) && appointmentDetailCont.appintmentData.value.paymentStatus == PaymentStatus.ADVANCE_PAID);

  Widget paymentDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(label: locale.value.paymentDetails, isShowAll: false),
        Container(
          width: Get.width,
          padding: const EdgeInsets.all(16),
          decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(locale.value.serviceTotal, style: secondaryTextStyle()).expand(),
                  PriceWidget(
                    price: num.parse(appointmentDetailCont.appintmentData.value.serviceTotal.toString()).toStringAsFixed(Constants.DECIMAL_POINT).toDouble(),
                    color: isDarkMode.value ? null : darkGrayTextColor,
                    size: 12,
                    isBoldText: true,
                  ),
                ],
              ),

              if (appointmentDetailCont.appintmentData.value.enableFinalBillingDiscount ?? false) ...[
                8.height,
                // detailWidgetPrice(title: locale.value.servicePrice, value: appointmentDetailCont.appintmentData.value.servicePrice),
                detailWidgetPrice(
                  leadingWidget: Row(
                    children: [
                      Text(locale.value.discount, style: secondaryTextStyle()),
                      if (appointmentDetailCont.appintmentData.value.billingFinalDiscountType == TaxType.PERCENTAGE)
                        Text(
                          ' (${appointmentDetailCont.appintmentData.value.billingFinalDiscountValue}% ${locale.value.off})',
                          style: boldTextStyle(color: Colors.green, size: 12),
                        )
                      else if (appointmentDetailCont.appintmentData.value.billingFinalDiscountType == TaxType.FIXED)
                        PriceWidget(
                          price: appointmentDetailCont.appintmentData.value.billingFinalDiscountValue ?? 0,
                          color: Colors.green,
                          size: 12,
                          isDiscountedPrice: true,
                        )
                    ],
                  ),
                  value: appointmentDetailCont.appintmentData.value.billingFinalDiscountAmount,
                  textColor: Colors.green,
                ),

                /// Subtotal
                detailWidgetPrice(
                  title: locale.value.subtotal,
                  value: appointmentDetailCont.appintmentData.value.subtotal,
                ),
              ],

              /// Tax
              if (appointmentDetailCont.appintmentData.value.taxData?.isNotEmpty ?? false)
                detailWidgetPrice(
                  leadingWidget: Row(
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
                              return AppoitmentDetailAppliedTaxListBottomSheet(
                                taxes: appointmentDetailCont.appintmentData.value.taxData ?? [],
                              );
                            },
                          );
                        },
                      ),
                      8.width,
                    ],
                  ).expand(),
                  value: appointmentDetailCont.appintmentData.value.totalTax,
                  isSemiBoldText: true,
                  textColor: appColorSecondary,
                ).paddingTop((appointmentDetailCont.appintmentData.value.enableFinalBillingDiscount ?? false) ? 0 : 8),
              commonDivider.paddingSymmetric(vertical: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.value.total, style: boldTextStyle(size: 14)),
                  PriceWidget(
                    price: appointmentDetailCont.appintmentData.value.totalAmount ?? 0,
                    color: appColorPrimary,
                    size: 16,
                  ),
                ],
              ),
              if (appointmentDetailCont.appintmentData.value.paymentStatus == PaymentStatus.PAID &&
                  (appointmentDetailCont.appintmentData.value.isEnableAdvancePayment ?? false) &&
                  !appointmentDetailCont.appintmentData.value.status.toLowerCase().contains(StatusConst.cancel.toLowerCase()))
                Column(
                  children: [
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locale.value.remainingAmount, style: boldTextStyle(size: 14)),
                        Text(appointmentDetailCont.appintmentData.value.paymentStatus?.toUpperCase() ?? "", style: boldTextStyle(size: 14, color: completedStatusColor)),
                      ],
                    ),
                  ],
                ),

              if (appointmentDetailCont.appintmentData.value.paymentStatus == PaymentStatus.ADVANCE_PAID && (appointmentDetailCont.appintmentData.value.isEnableAdvancePayment ?? false) && (appointmentDetailCont.appintmentData.value.advancePaidAmount ?? 0) > 0) ...[
                8.height,

                ///Advance Paid Amount
                detailWidgetPrice(
                  leadingWidget: Row(
                    children: [
                      Text(locale.value.advancePaidAmount, overflow: TextOverflow.ellipsis, maxLines: 2, style: secondaryTextStyle()),
                      Text(
                        ' (${appointmentDetailCont.appintmentData.value.advancePaymentAmount}%)',
                        style: boldTextStyle(color: Colors.green, size: 12),
                      ),
                    ],
                  ).flexible(),
                  textColor: completedStatusColor,
                  value: appointmentDetailCont.appintmentData.value.advancePaidAmount,
                  paddingBottom: 0,
                ),

                ///Remaining Payable Amount
                if ((!appointmentDetailCont.appintmentData.value.status.toLowerCase().contains(StatusConst.cancel.toLowerCase())) && (appointmentDetailCont.appintmentData.value.remainingPayableAmount ?? 0) > 0) ...[
                  10.height,
                  detailWidgetPrice(
                    title: locale.value.remainingPayableAmount,
                    textColor: pendingStatusColor,
                    value: appointmentDetailCont.appintmentData.value.remainingPayableAmount,
                    paddingBottom: 0,
                  )
                ],
              ]
            ],
          ),
        ),
        if(appointmentDetailCont.appintmentData.value.status.toLowerCase() == "cancelled")
          Container(
            width: Get.width,
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: completedStatusColor),
            child: detailWidgetPrice(
              leadingWidget: Text(locale.value.refundableAmount, overflow: TextOverflow.ellipsis, maxLines: 2, style: primaryTextStyle(color: Colors.white)),
              textColor: Colors.white,
              value: (appointmentDetailCont.appintmentData.value.advancePaidAmount ?? 0) > 0
                  ? appointmentDetailCont.appintmentData.value.advancePaidAmount
                  : appointmentDetailCont.appintmentData.value.totalAmount,
              paddingBottom: 0,
            ),
          ).paddingOnly(top: 16)
      ],
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
              color: textColor ?? appColorPrimary,
              size: 14,
              isSemiBoldText: isSemiBoldText,
            )
      ],
    ).paddingBottom(paddingBottom ?? 10);
  }
}
