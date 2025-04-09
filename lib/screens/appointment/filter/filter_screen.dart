import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import 'components/type_list_component.dart';
import 'filter_controller.dart';

class FilterScreen extends StatelessWidget {
  FilterScreen({super.key});

  final FilterController filterCont = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.filterBy,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        TextButton(
          onPressed: () {
            filterCont.clearFilter();
          },
          child: Text(locale.value.clearAllFilters, style: boldTextStyle(size: 14, color: whiteTextColor)),
        ),
      ],
      body: Container(
        height: Get.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkMode.value ? appScreenBackgroundDark : appScreenBackground,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilterTypeListComponent().expand(flex: 1),
                Obx(() => filterCont.viewFilterWidget()),
              ],
            ).expand(),
            Obx(
              () => Container(
                decoration: boxDecorationDefault(borderRadius: radius(0), color: context.cardColor),
                width: Get.width,
                padding: const EdgeInsets.all(16),
                child: filterCont.applyButton(),
              ).visible(filterCont.selectedDoctor.value.doctorId > 0 || filterCont.selectedServiceData.value.id > 0 || filterCont.selectedPatient.value.id > 0 || filterCont.status.isNotEmpty),
            ),
          ],
        ),
      ),
    );
  }
}
