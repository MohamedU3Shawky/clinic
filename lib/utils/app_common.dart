import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:egphysio_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import '../configs.dart';
import '../main.dart';
import '../screens/appointment/model/save_booking_res.dart';
import '../screens/auth/model/about_page_res.dart';
import '../screens/auth/model/app_configuration_res.dart';
import '../screens/auth/model/login_response.dart';
import 'colors.dart';
import 'constants.dart';

bool isIqonicProduct = DOMAIN_URL.contains("apps.iqonic.design") ||
    DOMAIN_URL.contains("iqonic.design") ||
    DOMAIN_URL.contains("innoquad.in");

RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
RxBool isLoggedIn = false.obs;
Rx<UserData> loginUserData = UserData().obs;
RxBool isDarkMode = false.obs;
RxInt unreadNotificationCount = 0.obs;

Rx<Currency> appCurrency = Currency().obs;
Rx<ConfigurationResponse> appConfigs = ConfigurationResponse(
  patientAppUrl: PatientAppUrl(),
  clinicadminAppUrl: ClinicadminAppUrl(),
  razorPay: RazorPay(),
  stripePay: StripePay(),
  paystackPay: PaystackPay(),
  paypalPay: PaypalPay(),
  flutterwavePay: FlutterwavePay(),
  currency: Currency(),
).obs;

//
Rx<PackageInfoData> currentPackageinfo = PackageInfoData().obs;
Rx<ClinicData> selectedAppClinic = ClinicData().obs;

// Currency position common
bool get isCurrencyPositionLeft =>
    appCurrency.value.currencyPosition ==
    CurrencyPosition.CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight =>
    appCurrency.value.currencyPosition ==
    CurrencyPosition.CURRENCY_POSITION_RIGHT;

bool get isCurrencyPositionLeftWithSpace =>
    appCurrency.value.currencyPosition ==
    CurrencyPosition.CURRENCY_POSITION_LEFT_WITH_SPACE;

bool get isCurrencyPositionRightWithSpace =>
    appCurrency.value.currencyPosition ==
    CurrencyPosition.CURRENCY_POSITION_RIGHT_WITH_SPACE;
//endregion

RxList<AboutDataModel> aboutPages = RxList();

Rx<SaveBookingRes> saveBookingRes =
    SaveBookingRes(saveBookingResData: SaveBookingResData()).obs;
//Booking Success
RxString bookingSuccessDate = "".obs;
// Rx<SaveBookingRes> saveBookingRes = SaveBookingRes().obs;
//

bool canLaunchVideoCall({required String status}) =>
    status.toLowerCase().contains(StatusConst.confirmed) ||
    status.toLowerCase().contains(StatusConst.check_in);

String getBookingStatus({required String status}) {
  if (status.toLowerCase().contains(StatusConst.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(StatusConst.completed)) {
    return locale.value.completed;
  } else if (status.toLowerCase().contains(StatusConst.confirmed)) {
    return locale.value.confirmed;
  } else if (status.toLowerCase().contains(StatusConst.cancel)) {
    return locale.value.cancelled;
  } else if (status.toLowerCase().contains(StatusConst.inprogress)) {
    return locale.value.inProgress;
  } else if (status.toLowerCase().contains(StatusConst.reject)) {
    return locale.value.rejected;
  } else if (status.toLowerCase().contains(StatusConst.check_in)) {
    return locale.value.checkIn;
  } else if (status.toLowerCase().contains(StatusConst.checkout)) {
    return locale.value.completed;
  } else {
    return "";
  }
}

Color getBookingStatusColor({required String status}) {
  if (status.toLowerCase().contains(StatusConst.pending)) {
    return pendingStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.upcoming)) {
    return upcomingStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.confirmed)) {
    return confirmedStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.check_in)) {
    return inprogressStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.completed)) {
    return confirmedStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.cancel)) {
    return cancelStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.reject)) {
    return cancelStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.checkout)) {
    return confirmedStatusColor;
  } else {
    return defaultStatusColor;
  }
}

String getBookingPaymentStatus({required String status}) {
  if (status.toLowerCase().contains(PaymentStatus.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(PaymentStatus.ADVANCE_PAID)) {
    return 'Advance Paid';
  } else if (status.toLowerCase().contains(PaymentStatus.PAID)) {
    return locale.value.paid;
  } else if (status.toLowerCase().contains(PaymentStatus.ADVANCE_REFUNDED)) {
    return 'Advance Refunded';
  } else if (status.toLowerCase().contains(PaymentStatus.REFUNDED)) {
    return 'Refunded';
  } else if (status.toLowerCase().contains(PaymentStatus.failed)) {
    return locale.value.failed;
  } else {
    return "";
  }
}

Color getPriceStatusColor({required String paymentStatus}) {
  if (paymentStatus.toLowerCase().contains(PaymentStatus.pending)) {
    return pendingStatusColor;
  } else if (paymentStatus.toLowerCase().contains(PaymentStatus.ADVANCE_PAID)) {
    return completedStatusColor;
  } else if (paymentStatus.toLowerCase().contains(PaymentStatus.PAID)) {
    return completedStatusColor;
  } else if (paymentStatus
      .toLowerCase()
      .contains(PaymentStatus.ADVANCE_REFUNDED)) {
    return confirmedStatusColor;
  } else if (paymentStatus.toLowerCase().contains(PaymentStatus.REFUNDED)) {
    return confirmedStatusColor;
  } else {
    return defaultStatusColor;
  }
}

String getRequestStatus({required String status}) {
  if (status.toLowerCase().contains(RequestStatus.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(RequestStatus.approved) ||
      status.toLowerCase().contains(RequestStatus.accept)) {
    return locale.value.approved;
  } else if (status.toLowerCase().contains(RequestStatus.rejected)) {
    return locale.value.rejected;
  } else {
    return "";
  }
}

Color getRequestStatusColor({required String requestStatus}) {
  if (requestStatus.toLowerCase().contains(RequestStatus.pending)) {
    return pendingStatusColor;
  } else if (requestStatus.toLowerCase().contains(RequestStatus.approved) ||
      requestStatus.toLowerCase().contains(RequestStatus.accept)) {
    return completedStatusColor;
  } else if (requestStatus.toLowerCase().contains(RequestStatus.rejected)) {
    return cancelStatusColor;
  } else {
    return defaultStatusColor;
  }
}

String getUserRoleTopic(String userRole) {
  return userRole.toLowerCase().replaceAll(' ', '_');
}

String get failedToFetchAttendance => 'Failed to fetch attendance';
String get getAttendanceError => 'Error fetching attendance: ';
String get checkInSuccess => 'Checked in successfully';
String get failedToCheckIn => 'Failed to check in';
String get checkInError => 'Error checking in: ';
String get checkOutSuccess => 'Checked out successfully';
String get failedToCheckOut => 'Failed to check out';
String get checkOutError => 'Error checking out: ';
