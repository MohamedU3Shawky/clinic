import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:egphysio_clinic_admin/locale/language_en.dart';
import 'app_theme.dart';
import 'configs.dart';
import 'firebase_options.dart';
import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'screens/splash_screen.dart';
import 'utils/app_common.dart';
import 'utils/colors.dart';
import 'utils/common_base.dart';
import 'utils/constants.dart';
import 'utils/local_storage.dart';
import 'utils/push_notification_service.dart';
import 'utils/shared_preferences.dart';
import 'controllers/leaves_controller.dart';
import 'controllers/permissions_controller.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('${FirebaseTopicConst.notificationDataKey}: ${message.data}');
  log('${FirebaseTopicConst.notificationKey} -->: ${message.notification}');
  log('${FirebaseTopicConst.notificationTitleKey} -->: ${message.notification!.title}');
  log('${FirebaseTopicConst.notificationBodyKey} -->: ${message.notification!.body}');
}

Rx<BaseLanguage> locale = LanguageEn().obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before anything else
  try {
    await CashHelper.init();
    log('SharedPreferences initialized successfully');
  } catch (e) {
    log('Error initializing SharedPreferences: $e');
    // We'll continue without shared preferences, but the app will use defaults
  }

  // Initialize Firebase
  // try {
  //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
  //     PushNotificationService().initFirebaseMessaging();
  //     if (kReleaseMode) {
  //       FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  //     }
  //   }).catchError((error) {
  //     log('Firebase initialization error: $error');
  //   });
  // } catch (e) {
  //   log('Firebase initialization failed: $e');
  //   // Continue with app initialization even if Firebase fails
  // }

  // Initialize GetStorage
  try {
    await GetStorage.init();
    log('GetStorage initialized successfully');
  } catch (e) {
    log('Error initializing GetStorage: $e');
  }

  // Initialize app settings
  try {
    // Font configuration
    fontFamilyPrimaryGlobal =
        GoogleFonts.interTight(fontWeight: FontWeight.w500).fontFamily;
    textPrimarySizeGlobal = 14;
    fontFamilySecondaryGlobal =
        GoogleFonts.interTight(fontWeight: FontWeight.w400).fontFamily;
    textSecondarySizeGlobal = 12;
    fontFamilyBoldGlobal =
        GoogleFonts.interTight(fontWeight: FontWeight.w600).fontFamily;

    // Button and UI configuration
    defaultBlurRadius = 0;
    defaultRadius = 12;
    defaultSpreadRadius = 0;
    appButtonBackgroundColorGlobal = appColorPrimary;
    defaultAppButtonRadius = defaultRadius;
    defaultAppButtonElevation = 0;
    defaultAppButtonTextColorGlobal = Colors.white;

    // Set minimum password length validation
    passwordLengthGlobal = 8;

    // Initialize language settings
    selectedLanguageCode(
        getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);
    await initialize(
        aLocaleLanguageList: languageList(),
        defaultLanguage: selectedLanguageCode.value);

    BaseLanguage temp =
        await const AppLocalizations().load(Locale(selectedLanguageCode.value));
    locale = temp.obs;
    locale.value =
        await const AppLocalizations().load(Locale(selectedLanguageCode.value));

    // Initialize theme settings
    final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
    if (getThemeFromLocal is int) {
      toggleThemeMode(themeId: getThemeFromLocal);
    } else {
      toggleThemeMode(themeId: THEME_MODE_LIGHT);
    }
  } catch (e) {
    log('Error during app initialization: $e');
    // Set default values if initialization fails
    selectedLanguageCode(DEFAULT_LANGUAGE);
    locale = LanguageEn().obs;
    toggleThemeMode(themeId: THEME_MODE_LIGHT);
  }

  // Set up custom HTTP overrides for handling certificates
  HttpOverrides.global = MyHttpOverrides();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Obx(
        () => GetMaterialApp(
          navigatorKey: navigatorKey,
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: const [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          localeResolutionCallback: (locale, supportedLocales) =>
              Locale(selectedLanguageCode.value),
          fallbackLocale: const Locale(DEFAULT_LANGUAGE),
          locale: Locale(selectedLanguageCode.value),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          initialBinding: BindingsBuilder(() {
            //initialBinding logic
            setStatusBarColor(transparentColor);
          }),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
