import 'package:egphysio_clinic_admin/screens/auth/sign_in_sign_up/sign_in_landing_screen.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs.dart';
import '../model/theme_mode_data_model.dart';
import '../../../api/auth_apis.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';
import '../sign_in_sign_up/signin_screen.dart';

class SettingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPayment = false.obs;
  RxBool isTouchId = false.obs;

  Rx<LanguageDataModel> selectedLang = LanguageDataModel().obs;
  List<ThemeModeData> themeModes = [ThemeModeData(id: THEME_MODE_SYSTEM, mode: "System"), ThemeModeData(id: THEME_MODE_LIGHT, mode: "Light"), ThemeModeData(id: THEME_MODE_DARK, mode: "Dark")];
  Rx<ThemeModeData> dropdownValue = ThemeModeData().obs;

  void handleDeleteAccountClick() {
    ifNotTester(() {
      isLoading(true);

      AuthServiceApis.deleteAccountCompletely().then((value) {
        AuthServiceApis.clearData(isFromDeleteAcc: true);
        toast(value.message);
        Get.offAll(() => SignInLandingScreen());
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => isLoading(false));
    });
  }

  @override
  Future<void> onInit() async {
    if (localeLanguageList.isNotEmpty) {
      selectedLanguageCode(getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);
      selectedLang(localeLanguageList.firstWhere(
        (element) => element.languageCode == selectedLanguageCode.value,
        orElse: () => LanguageDataModel(id: -1),
      ));
    }
    log('ISDARK: ${isDarkMode.value}');

    super.onInit();
  }

  @override
  void onReady() {
    try {
      final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
      if (getThemeFromLocal is int) {
        dropdownValue(themeModes.firstWhere(
          (element) => element.id == getThemeFromLocal,
          orElse: () => ThemeModeData(),
        ));
        toggleThemeMode(themeId: getThemeFromLocal);
      }
    } catch (e) {
      log('getThemeFromLocal from cache E: $e');
    }
    super.onReady();
  }
}
