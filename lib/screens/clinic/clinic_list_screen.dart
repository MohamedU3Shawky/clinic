import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart' hide errorColor;
import 'package:egphysio_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:egphysio_clinic_admin/screens/home/home_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../components/app_primary_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import 'clinic_session/clinic_session_screen.dart';
import 'components/clinic_component.dart';
import 'add_clinic_form/add_clinic_form.dart';
import 'clinic_list_controller.dart';
import 'search_clinic_widget.dart';
import '../../api/clinic_api.dart';

class ClinicListScreen extends StatefulWidget {
  const ClinicListScreen({super.key});

  @override
  State<ClinicListScreen> createState() => _ClinicListScreenState();
}

class _ClinicListScreenState extends State<ClinicListScreen> with SingleTickerProviderStateMixin {
  final ClinicListController clinicListController = Get.put(ClinicListController());
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize the FAB animation controller
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start the animation when the screen loads
    _fabAnimationController.forward();
    
    // Listen to scroll events to hide/show FAB
    _scrollController.addListener(_scrollListener);
  }
  
  @override
  void dispose() {
    _fabAnimationController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _showFab) {
      setState(() {
        _showFab = false;
        _fabAnimationController.reverse();
      });
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward && !_showFab) {
      setState(() {
        _showFab = true;
        _fabAnimationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: locale.value.clinics,
        isLoading: clinicListController.isLoading,
        appBarVerticalSize: Get.height * 0.12,
        body: Stack(
          children: [
            // Search and filter section
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SearchClinicWidget(
                    clinicListController: clinicListController,
                    onFieldSubmitted: (p0) {
                      hideKeyboard(context);
                    },
                  ),
                  
                  // Stats and filters
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        clinicListController.clinicList.isNotEmpty
                            ? '${clinicListController.clinicList.length} ${clinicListController.clinicList.length == 1 ? 'Clinic' : 'Clinics'}'
                            : 'No clinics found',
                        style: secondaryTextStyle(),
                      ),
                      
                      // Refresh button
                      TextButton.icon(
                        onPressed: () {
                          clinicListController.page(1);
                          clinicListController.getAllClinics();
                        },
                        icon: const Icon(Icons.refresh, size: 18, color: appColorPrimary),
                        label: Text('Refresh', style: primaryTextStyle(color: appColorPrimary, size: 14)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            
            // Clinic list
            Expanded(
              child: SnapHelperWidget(
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
                    () => clinicListController.clinicList.isEmpty
                        ? NoDataWidget(
                            title: locale.value.noClinicsFound,
                            retryText: !loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) ? null : locale.value.addNewClinic,
                            imageWidget: const EmptyStateWidget(),
                            onRetry: !loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)
                                ? null
                                : () async {
                                    Get.to(() => AddClinicForm())?.then((result) {
                                      if (result == true) {
                                        clinicListController.page(1);
                                        clinicListController.getAllClinics();
                                      }
                                    });
                                  },
                        ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!clinicListController.isLoading.value)
                      : RefreshIndicator(
                          onRefresh: () async {
                            clinicListController.page(1);
                            return await clinicListController.getAllClinics();
                          },
                          color: appColorPrimary,
                          child: AnimationLimiter(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: clinicListController.clinicList.length,
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: ClinicComponent(
                                        clinicData: clinicListController.clinicList[index],
                                        onEditClick: () {
                                          if (loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)) {
                                            Get.to(() => ClinicSessionScreen(), arguments: clinicListController.clinicList[index]);
                                          } else {
                                            Get.to(() => AddClinicForm(isEdit: true), arguments: clinicListController.clinicList[index])?.then((value) {
                                              if (value == true) {
                                                clinicListController.page(1);
                                                clinicListController.getAllClinics();
                                              }
                                            });
                                          }
                                        },
                                        onDeleteClick: () => handleDeleteClinicClick(clinicListController.clinicList, index, context),
                                      ).paddingBottom(16),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
        fabWidget: loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)
            ? AnimatedOpacity(
                opacity: _showFab ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: FloatingActionButton(
                  backgroundColor: appColorPrimary,
                  child: Icon(Icons.add),
                  onPressed: () async {
                    Get.to(() => AddClinicForm())?.then((result) {
                      if (result == true) {
                        clinicListController.page(1);
                        clinicListController.getAllClinics();
                      }
                    });
                  },
                ),
              )
            : null,
      ),
    );
  }

  Future<void> handleDeleteClinicClick(List<ClinicData> clinicList, int index, BuildContext context) async {
    HapticFeedback.mediumImpact();
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      dialogType: DialogType.DELETE,
      title: locale.value.areYouSureYouWantToDeleteThisClinic,
      positiveText: locale.value.yes,
      negativeText: locale.value.no,
      onAccept: (ctx) async {
        clinicListController.isLoading(true);
        ClinicApis.deleteClinic(clinicId: clinicList[index].id).then((value) {
          clinicList.removeAt(index);

          toast(value.message.trim().isEmpty ? locale.value.clinicDeleteSuccessfully : value.message.trim());
          try {
            HomeController hcont = Get.find();
            hcont.getDashboardDetail();
          } catch (e) {
            log('deleteClinic hcont = Get.find() E: $e');
          }
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => clinicListController.isLoading(false));
      },
    );
  }
}
