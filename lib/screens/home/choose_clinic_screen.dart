import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:egphysio_clinic_admin/screens/home/home_controller.dart';
import 'package:egphysio_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../utils/shared_preferences.dart';
import '../clinic/model/clinics_res_model.dart';
import '../dashboard/dashboard_screen.dart';
import 'choose_clinic_controller.dart';

class ChooseClinicScreen extends StatelessWidget {
  ChooseClinicScreen({super.key});

  final ChooseClinicController clinicListController = Get.put(ChooseClinicController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
        appBartitleText: locale.value.chooseClinic,
        appBarVerticalSize: Get.height * 0.12,
        isLoading: clinicListController.isLoading,
        actions: [
          IconButton(
            onPressed: () async {
              if (clinicListController.singleClinicSelect.value.id==null||clinicListController.singleClinicSelect.value.id==-1) {

                     toast(locale.value.pleaseChooseClinic);
                }
                else {
                  selectedAppClinic(clinicListController.singleClinicSelect.value);
                  CashHelper.saveData(key:SharedPreferenceConst.CLINIC_ID,value:clinicListController.singleClinicSelect.value.id);
                  CashHelper.saveData(key:SharedPreferenceConst.CLINIC_DATA,value: clinicListController.singleClinicSelect.value);
                  Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
                    Get.put(HomeController());
                  }));
                  //  Get.back(result: clinicListController.singleClinicSelect.value);
                }
            },
            icon: const Icon(Icons.check, size: 20, color: Colors.white),
          ).paddingOnly(right: 8, top: 12, bottom: 12),
        ],
        body: SizedBox(
          height: Get.height,
          child: Obx(
            () => Column(
              children: [
                SnapHelperWidget(
                  future: clinicListController.getClinics.value,
                  loadingWidget: clinicListController.isLoading.value ? const Offstage() : const LoaderWidget(),
                  errorBuilder: (error) {
                    return NoDataWidget(
                      title: error,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        clinicListController.page(1);
                        clinicListController.getAllClinics();
                      },
                    );
                  },
                  onSuccess: (res) {
                    return Obx(
                      () => AnimatedListView(
                        shrinkWrap: true,
                        itemCount: clinicListController.clinicList.length,
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        listAnimationType: ListAnimationType.None,
                        emptyWidget: NoDataWidget(
                          title: locale.value.noClinicsFound,
                          subTitle: locale.value.oppsNoClinicsFoundAtMomentTryAgainLater,
                          imageWidget: const EmptyStateWidget(),
                          onRetry: () async {
                            clinicListController.page(1);
                            clinicListController.getAllClinics();
                          },
                        ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!clinicListController.isLoading.value),
                        onSwipeRefresh: () async {
                          clinicListController.page(1);
                          return await clinicListController.getAllClinics();
                        },
                        onNextPage: () async {
                          if (!clinicListController.isLastPage.value) {
                            clinicListController.page++;
                            clinicListController.getAllClinics();
                          }
                        },
                        itemBuilder: (ctx, index) {
                          return ChooseClinicCard(
                            clinicData: clinicListController.clinicList[index],
                            clinicListController: clinicListController,
                          ).paddingBottom(16);
                        },
                      ),
                    );
                  },
                ).expand(),
              ],
            ),
          ).paddingTop(16),
        ));
  }
}

class ChooseClinicCard extends StatefulWidget {
  final ClinicData clinicData;
  final ChooseClinicController clinicListController;
  const ChooseClinicCard({
    super.key,
    required this.clinicData,
    required this.clinicListController,
  });

  @override
  State<ChooseClinicCard> createState() => _ChooseClinicCardState();
}

class _ChooseClinicCardState extends State<ChooseClinicCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extract phone from the contactNumber field or phone field
    String phoneNumber = widget.clinicData.phone ?? widget.clinicData.contactNumber;
    
    // Get status from the status field
    bool isActive = widget.clinicData.status == 1 || 
                  (widget.clinicData.clinicStatus.toLowerCase() == 'active');
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.clinicListController.singleClinicSelect(widget.clinicData);
        },
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: context.cardColor,
            boxShadow: [
              BoxShadow(
                color: appColorPrimary.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  // Clinic image or gradient container with first letter
                  Stack(
                    children: [
                      // Image or gradient background
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: widget.clinicData.clinicImage.isNotEmpty
                          ? CachedImageWidget(
                              url: widget.clinicData.clinicImage,
                              height: 90,
                              width: Get.width,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 90,
                              width: Get.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    appColorPrimary.withOpacity(0.7),
                                    appColorSecondary.withOpacity(0.9),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  widget.clinicData.name.isNotEmpty 
                                      ? widget.clinicData.name[0].toUpperCase() 
                                      : "C",
                                  style: boldTextStyle(size: 36, color: Colors.white),
                                ),
                              ),
                            ),
                      ),
                      
                      // Status indicator overlay at top
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive ? successColor : inProgressColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isActive ? 'Active' : 'Inactive',
                            style: boldTextStyle(size: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Content section
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Clinic name
                        Text(
                          widget.clinicData.name,
                          style: boldTextStyle(size: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        8.height,
                        
                        // Address and phone in compact format
                        Row(
                          children: [
                            // Address with icon
                            if (widget.clinicData.address.isNotEmpty)
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: lightPrimaryColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(Icons.location_on_outlined, 
                                        color: appColorPrimary, size: 14),
                                    ),
                                    8.width,
                                    Expanded(
                                      child: Text(
                                        widget.clinicData.address,
                                        style: secondaryTextStyle(size: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                            // Phone with icon
                            if (phoneNumber.isNotEmpty)
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: lightSecondaryColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(Icons.phone_outlined, 
                                        color: appColorSecondary, size: 14),
                                    ),
                                    8.width,
                                    Expanded(
                                      child: Text(
                                        phoneNumber,
                                        style: secondaryTextStyle(size: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Selection indicator
              Positioned(
                top: 8,
                right: 8,
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: widget.clinicListController.singleClinicSelect.value.id == widget.clinicData.id
                          ? appColorPrimary 
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: appColorPrimary, width: 2),
                    ),
                    child: widget.clinicListController.singleClinicSelect.value.id == widget.clinicData.id
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : const SizedBox(width: 16, height: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
