import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import 'assing_doctor_screen.dart';
import 'change_price_bottom_component.dart';
import 'components/all_service_card.dart';
import 'manage_service/search_service_widget.dart';
import 'all_service_list_controller.dart';

class AllServicesScreen extends StatelessWidget {
  AllServicesScreen({super.key});

  final AllServicesController serviceListCont = Get.put(AllServicesController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: serviceListCont.appBarTitle.value,
        isLoading: serviceListCont.isLoading,
        appBarVerticalSize: Get.height * 0.12,
        body: SizedBox(
          height: Get.height,
          child: Obx(
            () => Column(
              children: [
                SearchServiceWidget(
                  allServicesCont: serviceListCont,
                  hintText: locale.value.searchServiceHere,
                  onFieldSubmitted: (p0) {
                    hideKeyboard(context);
                  },
                ).paddingSymmetric(horizontal: 16),
                24.height,
                SnapHelperWidget(
                  future: serviceListCont.serviceListFuture.value,
                  loadingWidget: serviceListCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                  errorBuilder: (error) {
                    return NoDataWidget(
                      title: error,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        serviceListCont.page(1);
                        serviceListCont.getAllServices();
                      },
                    );
                  },
                  onSuccess: (res) {
                    return Obx(
                      () => AnimatedListView(
                        shrinkWrap: true,
                        itemCount: serviceListCont.serviceList.length,
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        listAnimationType: ListAnimationType.None,
                        emptyWidget: NoDataWidget(
                          title: locale.value.noServicesFound,
                          subTitle: locale.value.oppsNoServicesFoundAtMomentTryAgainLater,
                          imageWidget: const EmptyStateWidget(),
                        ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!serviceListCont.isLoading.value),
                        onSwipeRefresh: () async {
                          serviceListCont.page(1);
                          return await serviceListCont.getAllServices(showloader: false);
                        },
                        onNextPage: () async {
                          if (!serviceListCont.isLastPage.value) {
                            serviceListCont.page++;
                            serviceListCont.getAllServices();
                          }
                        },
                        itemBuilder: (ctx, index) {
                          return AllServiceCard(
                            serviceElement: serviceListCont.serviceList[index],
                            onChanged: (bool value) async {
                              handleStatusChangeClick(context: context, index: index, statusValue: value);
                            },
                            onClickAssignDoctor: () {
                              if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)) {
                                Get.bottomSheet(ChangePriceComponent(
                                  serviceElement: serviceListCont.serviceList[index],
                                  changePriceCont:
                                      TextEditingController(text: serviceListCont.serviceList[index].assignDoctor.isEmpty ? serviceListCont.serviceList[index].charges.toString() : serviceListCont.serviceList[index].doctorCharges.toString()),
                                  onSave: (p0) {
                                    serviceListCont.changeServicePrice(serviceId: serviceListCont.serviceList[index].id, price: p0);
                                  },
                                ));
                              } else {
                                Get.to(() => AssingDoctorScreen(), arguments: serviceListCont.serviceList[index])?.then((value) {
                                  if (value == true) {
                                    serviceListCont.page(1);
                                    serviceListCont.getAllServices();
                                  }
                                });
                              }
                            },
                          ).paddingBottom(16);
                        },
                      ),
                    ).paddingSymmetric(horizontal: 16);
                  },
                ).expand(),
              ],
            ),
          ).paddingTop(16),
        ),
      ),
    );
  }

  Future<void> handleStatusChangeClick({required BuildContext context, required bool statusValue, required int index}) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.doYouWantToPerformThisChange,
      positiveText: locale.value.yes,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        log('VALUE: $statusValue');
        serviceListCont.serviceList[index].status(statusValue);
        await serviceListCont.updateServicesStatus(id: serviceListCont.serviceList[index].id, status: serviceListCont.serviceList[index].status.value.getIntBool());
      },
    );
  }
}
