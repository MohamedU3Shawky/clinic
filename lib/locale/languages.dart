import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) =>
      Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get language;

  String get badRequest;

  String get forbidden;

  String get pageNotFound;

  String get tooManyRequests;

  String get internalServerError;

  String get badGateway;

  String get serviceUnavailable;

  String get gatewayTimeout;

  String get hey;

  String get hello;

  String get thisFieldIsRequired;

  String get contactNumber;

  String get gallery;

  String get camera;

  String get editProfile;

  String get update;

  String get reload;

  String get address;

  String get viewAll;

  String get pressBackAgainToExitApp;

  String get invalidUrl;

  String get cancel;

  String get delete;

  String get deleteAccountConfirmation;

  String get demoUserCannotBeGrantedForThis;

  String get somethingWentWrong;

  String get yourInternetIsNotWorking;

  String get profileUpdatedSuccessfully;

  String get wouldYouLikeToSetProfilePhotoAs;

  String get yourOldPasswordDoesnT;

  String get yourNewPasswordDoesnT;

  String get location;

  String get yes;

  String get no;

  String get submit;

  String get firstName;

  String get lastName;

  String get changePassword;

  String get yourNewPasswordMust;

  String get password;

  String get newPassword;

  String get confirmNewPassword;

  String get email;

  String get mainStreet;

  String get toResetYourNew;

  String get stayTunedNoNew;

  String get noNewNotificationsAt;

  String get signIn;

  String get explore;

  String get settings;

  String get rateApp;

  String get aboutApp;

  String get logout;

  String get rememberMe;

  String get forgotPassword;

  String get forgotPasswordTitle;

  String get registerNow;

  String get createYourAccount;

  String get createYourAccountFor;

  String get signUp;

  String get alreadyHaveAnAccount;

  String get yourPasswordHasBeen;

  String get youCanNowLog;

  String get done;

  String get pleaseAcceptTermsAnd;

  String get deleteAccount;

  String get eG;

  String get merry;

  String get doe;

  String get welcomeBackToThe;

  String get welcomeToThe;

  String get doYouWantToLogout;

  String get appTheme;

  String get guest;

  String get notifications;

  String get newUpdate;

  String get anUpdateTo;

  String get isAvailableGoTo;

  String get later;

  String get closeApp;

  String get updateNow;

  String get signInFailed;

  String get userCancelled;

  String get appleSigninIsNot;

  String get eventStatus;

  String get eventAddedSuccessfully;

  String get notRegistered;

  String get signInWithGoogle;

  String get signInWithApple;

  String get orSignInWith;

  String get ohNoYouAreLeaving;

  String get oldPassword;

  String get oldAndNewPassword;

  String get personalizeYourProfile;

  String get themeAndMore;

  String get showSomeLoveShare;

  String get privacyPolicyTerms;

  String get securelyLogOutOfAccount;

  String get termsOfService;

  String get successfully;

  String get clearAll;

  String get notificationDeleted;

  String get doYouWantToRemoveNotification;

  String get doYouWantToClearAllNotification;

  String get doYouWantToRemoveImage;

  String get locationPermissionDenied;

  String get enableLocation;

  String get permissionDeniedPermanently;

  String get chooseYourLocation;

  String get setAddress;

  String get sorryUserCannotSignin;

  String get iAgreeToThe;

  String get logIn;

  String get country;

  String get selectCountry;

  String get state;

  String get selectState;

  String get city;

  String get pinCode;

  String get selectCity;

  String get addressLine;

  String get searchHere;

  String get noDataFound;

  String get pending;

  String get completed;

  String get confirmed;

  String get cancelled;

  String get rejected;

  String get checkIn;

  String get checkout;

  String get reject;

  String get processing;

  String get delivered;

  String get placed;

  String get inProgress;

  String get paid;

  String get failed;

  String get approved;

  String get doYouWantToCancelBooking;

  String get aboutSelf;

  String get appliedTaxes;

  String get appointment;

  String get online;

  String get inClinic;

  String get patient;

  String get doctor;

  String get payment;

  String get videoCallLinkIsNotFound;

  String get thisIsNotAOnlineService;

  String get oppsThisAppointmentIsNotConfirmedYet;

  String get oppsThisAppointmentHasBeenCancelled;

  String get oppsThisAppointmentHasBeenCompleted;

  String get dateTime;

  String get appointmentType;

  String get searchAppoinmentHere;

  String get noClinicsFoundAtAMoment;

  String get looksLikeThereIsNoClinicsWellKeepYouPostedWhe;

  String get searchDoctorHere;

  String get searchPatientHere;

  String get noPatientFound;

  String get oppsNoPatientFoundAtMomentTryAgainLater;

  String get searchServiceHere;

  String get noServiceFound;

  String get oppsNoServiceFoundAtMomentTryAgainLater;

  String get filterBy;

  String get clearFilter;

  String get doYouWantToPerformThisAction;

  String get statusHasBeenUpdated;

  String get sessionSummary;

  String get clinicInfo;

  String get doctorInfo;

  String get patientInfo;

  String get aboutService;

  String get encounterDetails;

  String get doctorName;

  String get active;

  String get closed;

  String get clinicName;

  String get description;

  String get usersMustClearPaymentBeforeAccessingCheckout;

  String get paymentDetails;

  String get price;

  String get discount;

  String get off;

  String get subtotal;

  String get tax;

  String get total;

  String get appointments;

  String get schedule;

  String get leaves;

  String get holidays;

  String get shifts;

  String get overtime;

  String get noSchedulesFound;

  String get noAppointmentsFound;

  String get thereAreCurrentlyNoAppointmentsAvailable;

  String get resetYourPassword;

  String get enterYourEmailAddressToResetYourNewPassword;

  String get sendCode;

  String get edit;

  String get gender;

  String get profile;

  String get clinics;

  String get manageClinics;

  String get manageSessions;

  String get changeOrAddYourSessions;

  String get doctors;

  String get manageDoctors;

  String get requests;

  String get requestForServiceCategoryAndSpecialization;

  String get receptionists;

  String get allReceptionist;

  String get encounters;

  String get manageEncouterData;

  String get userNotCreated;

  String get pleaseSelectRoleToLogin;

  String get pleaseSelectRoleToRegister;

  String get pleaseSelectClinicToRegister;

  String get chooseYourRole;

  String get demoAccounts;

  String get notAMember;

  String get registerYourAccountForBetterExperience;

  String get selectUserRole;

  String get selectClinic;

  String get termsConditions;

  String get and;

  String get privacyPolicy;

  String get areYouSureYouWantTonupdateTheService;

  String get save;

  String get allCategory;

  String get noCategoryFound;

  String get editClinic;

  String get addClinic;

  String get clinicImage;

  String get chooseImageToUpload;

  String get chooseSpecialization;

  String get searchForSpecialization;

  String get specialization;

  String get timeSlot;

  String get chooseCountry;

  String get searchForCountry;

  String get chooseState;

  String get searchForState;

  String get chooseCity;

  String get searchForCity;

  String get postalCode;

  String get latitude;

  String get longitude;

  String get writeHere;

  String get status;

  String get pleaseSelectAClinicImage;

  String get addBreak;

  String get editBreak;

  String get selectTime;

  String get startDateMustBeBeforeEndDate;

  String get endDateMustBeAfterStartDate;

  String get breakTimeIsOutsideShiftTime;

  String get lblBreak;

  String get clinicSessions;

  String get noSessionsFound;

  String get oppsNoSessionsFoundAtMomentTryAgainLater;

  String get unavailable;

  String get sessions;

  String get clinicSessionsInformation;

  String get services;

  String get serviceAvaliable;

  String get doctorsAvaliable;

  String get photosAvaliable;

  String get clinicDetail;

  String get readMore;

  String get readLess;

  String get clinicGalleryDeleteSuccessfully;

  String get noGalleryFoundAtAMoment;

  String get looksLikeThereIsNoGalleryForThisClinicWellKee;

  String get pleaseSelectImages;

  String get noClinicsFound;

  String get addNewClinic;

  String get areYouSureYouWantToDeleteThisClinic;

  String get clinicDeleteSuccessfully;

  String get totalAppointments;

  String get totalServices;

  String get totalPatient;

  String get totalEarning;

  String get welcomeBack;

  String get totalDoctors;

  String get doYouWantToPerformThisChange;

  String get statusUpdatedSuccessfully;

  String get chooseClinic;

  String get pleaseChooseClinic;

  String get oppsNoClinicsFoundAtMomentTryAgainLater;

  String get change;

  String get analytics;

  String get youDontHaveAnyServicesnPleaseAddYourServices;

  String get addService;

  String get recentAppointment;

  String get yourService;

  String get patients;

  String get noPatientsFound;

  String get oppsNoPatientsFoundAtMomentTryAgainLater;

  String get patientDetail;

  String get appointmentsTillNow;

  String get payoutHistory;

  String get noPayout;

  String get oppsLooksLikeThereIsNoPayoutsAvailable;

  String get addReceptionist;

  String get selectClinicCenters;

  String get noReceptionistsFound;

  String get oppsNoReceptionistsFoundAtMomentTryAgainLater;

  String get addRequest;

  String get name;

  String get selectType;

  String get requestList;

  String get noRequestsFound;

  String get oppsNoRequestsFoundAtMomentTryAgainLater;

  String get changePrice;

  String get assignDoctor;

  String get priceUpdatedSuccessfully;

  String get charges;

  String get doctorsAssignSuccessfully;

  String get pleaseSelectClinic;

  String get searchForClinic;

  String get noDoctorsFound;

  String get looksLikeThereAreNoDoctorsAvilableToAssign;

  String get socialMedia;

  String get revenue;

  String get yearly;

  String get service;

  String get searchClinicHere;

  String get home;

  String get payouts;

  String get editDoctor;

  String get addDoctor;

  String get aboutMyself;

  String get experienceSpecializationContactInfo;

  String get doctorSessionsInformation;

  String get noServicesTillNow;

  String get oopsThisDoctorDoesntHaveAnyServicesYet;

  String get reviews;

  String get noReviewsTillNow;

  String get oopsThisDoctorDoesntHaveAnyReviewsYet;

  String get qualification;

  String get qualificationDetailIsNotAvilable;

  String get qualificationInDetail;

  String get year;

  String get degree;

  String get university;

  String get by;

  String get breaks;

  String get noWeekListFound;

  String get oppsNoWeekListFoundAtMomentTryAgainLater;

  String get addDayOff;

  String get assignClinics;

  String get oppsNoDoctorFoundAtMomentTryAgainLater;

  String get sessionSavedSuccessfully;

  String get doctorSession;

  String get selectDoctor;

  String get pleaseSelectDoctor;

  String get allSession;

  String get addSession;

  String get noDoctorSessionFound;

  String get thereAreCurrentlyNoDoctorSessionAvailable;

  String get oppsNoReviewFoundAtMomentTryAgainLater;

  String get noServicesFound;

  String get oppsNoServicesFoundAtMomentTryAgainLater;

  String get invoice;

  String get encounter;

  String get totalPayableAmountWithTax;

  String get discountAmount;

  String get servicePrice;

  String get contactInfo;

  String get experience;

  String get about;

  String get myProfile;

  String get doctorDetail;

  String get areYouSureYouWantToDeleteThisDoctor;

  String get doctorDeleteSuccessfully;

  String get noQualificationsFound;

  String get looksLikeThereAreNoQualificationsAddedByThisD;

  String get addEncounter;

  String get fillPatientEncounterDetails;

  String get dateIsNotSelected;

  String get date;

  String get chooseDoctor;

  String get choosePatient;

  String get searchForPatient;

  String get bodyChart;

  String get imageDetails;

  String get reset;

  String get imageTitle;

  String get imageDescription;

  String get pleaseUploadTheImage;

  String get patientName;

  String get lastUpdate;

  String get noBodyChartsFound;

  String get oppsNoBodyChartsFoundAtMomentTryAgainLater;

  String get areYouSureYouWantToDeleteThisBodyChart;

  String get editPrescription;

  String get addPrescription;

  String get frequency;

  String get duration;

  String get instruction;

  String get noNotesAdded;

  String get chooseOrAddNotes;

  String get writeNotes;

  String get add;

  String get notes;

  String get observations;

  String get chooseOrAddObservation;

  String get writeObservation;

  String get noObservationAdded;

  String get otherInformation;

  String get write;

  String get prescription;

  String get noPrescriptionAdded;

  String get days;

  String get problems;

  String get chooseOrAddProblems;

  String get writeProblem;

  String get noProblemAdded;

  String get clinicalDetail;

  String get moreInformation;

  String get patientHealthInformation;

  String get showBodyChartRelatedInformation;

  String get viewReport;

  String get showReportRelatedInformation;

  String get billDetails;

  String get showBillDetailsRelatedInformation;

  String get clinic;

  String get encounterDate;

  String get unpaid;

  String get totalPrice;

  String get enterDiscount;

  String get enterPayableAmount;

  String get paymentStatus;

  String get toCloseTheEncounterInvoicePaymentIsMandatory;

  String get noInvoiceDetailsFound;

  String get oppsNoInvoiceDetailsFoundAtMomentTryAgainLate;

  String get invoiceDetail;

  String get noInvoiceFound;

  String get oppsNoInvoiceFoundAtMomentTryAgainLater;

  String get generateInvoice;

  String get invoiceId;

  String get patientDetails;

  String get editMedicalReport;

  String get addMedicalReport;

  String get uploadMedicalReport;

  String get pleaseUploadAMedicalReport;

  String get medicalReports;

  String get thereIsNoMedicalReportsAvilableAtThisMoment;

  String get noMedicalReportsFound;

  String get areYouSureYouWantToDeleteThisMedicalReport;

  String get medicalReportDeleteSuccessfully;

  String get noEncountersFound;

  String get areYouSureYouWantToDeleteThisEncounter;

  String get totalClinic;

  String get subjectiveObjectiveAssessmentAndPlan;

  String get noteTheAcronymSoapStandsForSubjectiveObjectiv;

  String get subjective;

  String get objective;

  String get assessment;

  String get plan;

  String get clearAllFilters;

  String get apply;

  String get reportDetails;

  String get yearIsRequired;

  String get enterAValidYearBetween1900And;

  String get pleaseEnterYourDegree;

  String get pleaseEnterDegree;

  String get pleaseEnterUniversity;

  String get selectYear;

  String get somethingWentWrongPleaseTryAgainLater;

  String get advancePayableAmount;

  String get advancePaidAmount;

  String get remainingPayableAmount;

  String get addYourSignature;

  String get verifyWithEaseYourDigitalMark;

  String get clear;

  String get doctorImage;

  String get serviceTotal;

  String get expert;

  String get percent;

  String get fixed;

  String get discoutValue;

  String get editDiscount;

  String get addDiscount;

  String get totalAmount;

  String get addBillingItem;

  String get serviceImage;

  String get editService;

  String get great;

  String get bookingSuccessful;

  String get yourAppointmentHasBeenBookedSuccessfully;

  String get totalPayment;

  String get goToAppointments;

  String get addAppointment;

  String get selectService;

  String get chooseDate;

  String get noTimeSlotsAvailable;

  String get chooseTime;

  String get asPerDoctorCharges;

  String get remainingAmount;

  String get refundableAmount;

  String get version;

  String get passwordLengthShouldBe8To14Characters;

  String get theConfirmPasswordAndPasswordMustMatch;

  String get chooseCommission;

  String get searchForCommission;

  String get noCommissionFound;

  String get commission;

  String get selectServices;

  String get facebookLink;

  String get instagramLink;

  String get twitterLink;

  String get dribbleLink;

  String get signature;

  String get addNew;

  String get pleaseSelectADoctorImage;

  String get remove;

  String get degreecertification;

  String get noReviewsFoundAtAMoment;

  String get looksLikeThereIsNoReviewsWellKeepYouPostedWhe;

  String get addNewDoctor;

  String get bodyChartDeleteSuccessfully;

  String get editBillingItem;

  String get quantity;

  String get areYouSureYouWantToDeleteThisBillingItem;

  String get pleaseWaitWhileItsLoading;

  String get billingItemRemovedSuccessfully;

  String get closeCheckoutEncounter;

  String get file;

  String get serviceName;

  String get serviceDurationMin;

  String get defaultPrice;

  String get chooseCategory;

  String get searchForCategory;

  String get category;

  String get enterDescription;

  String get pleaseSelectAServiceImage;

  String get sServices;

  String get monthly;

  String get list;

  String get noLeavesOfThisType;

  String get tapButtonToRequestLeave;

  String get selectLeaveType;

  String get leaveDates;

  String get enterReason;

  String get requestLeave;

  String get leaveType;

  String get reviewedBy;

  String get totalLeaves;

  String get isPaid;

  String get from;

  String get id;

  String get to;

  String get noLeavesDescription;

  String get noLeavesFound;

  String get pleaseSelectLeaveType;

  String get customPolicy;

  String get usedLeaves;

  String get remainingLeaves;

  String get defaultDays;

  String get ok;

  String get type;
  String get reason;
  String get fromDate;
  String get toDate;
  String get inactive;

  String get disabled;
  String get used;
  String get remaining;
  String get shift;
  String get addShift;
  String get editShift;
  String get deleteShift;
  String get noShiftsScheduled;
  String get pleaseSelectDate;
  String get pleaseSelectTime;
  String get pleaseSelectBranch;
  String get pleaseSelectUser;
  String get pleaseEnterTitle;
  String get pleaseEnterDescription;
  String get areYouSureDeleteShift;
  // Shift related
  String get shiftAddedSuccessfully;
  String get shiftUpdatedSuccessfully;
  String get shiftDeletedSuccessfully;
  String get failedToAddShift;
  String get failedToUpdateShift;
  String get failedToDeleteShift;
  String get failedToFetchShifts;
  String get getShiftsError;
  String get addShiftError;
  String get updateShiftError;
  String get deleteShiftError;

// Leave specific
  String get leaveTypes;
  String get leaveHistory;
  String get editLeave;
  String get deleteLeave;
  String get noLeavesScheduled;
  String get noEnabledLeaveTypes;
  String get leaveTypeDisabled;
  String get pleaseSelectFromDate;
  String get pleaseSelectToDate;
  String get areYouSureDeleteLeave;
  String get leaveAddedSuccessfully;
  String get leaveUpdatedSuccessfully;
  String get leaveDeletedSuccessfully;
  String get failedToAddLeave;
  String get failedToUpdateLeave;
  String get failedToDeleteLeave;
  String get failedToFetchLeaves;
  String get getLeavesError;
  String get addLeaveError;
  String get updateLeaveError;
  String get deleteLeaveError;
  String get cannotEditPastLeaves;

// Leave management
  String get leaveSettings;
  String get leavePolicies;
  String get addLeavePolicy;
  String get editLeavePolicy;
  String get deleteLeavePolicy;
  String get policyName;
  String get policyDescription;
  String get annualLeave;
  String get sickLeave;
  String get personalLeave;
  String get maternityLeave;
  String get paternityLeave;
  String get bereavementLeave;
  String get otherLeave;
  String get leaveBalance;
  String get leaveRequests;
  String get pendingRequests;
  String get approvedRequests;
  String get rejectedRequests;
  String get requestStatus;
  String get requestDate;
  String get approvedBy;
  String get approvalDate;
  String get comments;
  String get attachments;
  String get addAttachment;
  String get removeAttachment;
  String get submitRequest;
  String get cancelRequest;
  String get approveRequest;
  String get rejectRequest;
  String get requestSubmitted;
  String get requestCancelled;
  String get requestApproved;
  String get requestRejected;

  String get close;
  String get failedToFetchPermissions;
  String get getPermissionsError;
  String get youDontHavePermission;

  String get leaveReviewedSuccessfully;
  String get failedToReviewLeave;
  String get reviewLeaveError;

  String get noHolidaysFound;

  String get noHolidaysDescription;

  String get users;

  String get viewDetails;

  String get applyPermission;

  String get attendance ;

  String get noAttendanceFound ;

  String get noAttendanceFoundDesc ;

  String get failedToFetchAttendance;
  
  String get attendancePermissions;
  String get manageAttendancePermissions;
  String get permissionType;
  String get permissionDuration;
  String get permissionStatus;
  String get permissionDetails;
  String get permissionHistory;
  String get noPermissionsFound;
  String get permissionAddedSuccessfully;
  String get permissionUpdatedSuccessfully;
  String get permissionDeletedSuccessfully;
  String get failedToAddPermission;
  String get failedToUpdatePermission;
  String get failedToDeletePermission;
  String get permissionApproved;
  String get permissionRejected;
  String get permissionPending;
  String get lateIn;
  String get earlyLeave;
  String get totalPermissions;
  String get approvedPermissions;
  String get pendingPermissions;
  String get rejectedPermissions;
  String get permissionReason;
  String get reviewDate;
  String get reviewComment;
  String get submitPermission;
  String get cancelPermission;
  String get approvePermission;
  String get rejectPermission;
  String get permissionSubmitted;
  String get permissionCancelled;
  String get failedToSubmitPermission;
  String get failedToCancelPermission;
  String get failedToApprovePermission;
  String get failedToRejectPermission;
  String get permissionSettings;
  String get permissionPolicies;
  String get addPermissionPolicy;
  String get editPermissionPolicy;
  String get deletePermissionPolicy;
  String get maxDuration;
  String get minDuration;
  String get allowedTypes;
  String get approvalRequired;
  String get autoApprove;
  String get permissionBalance;
  String get usedPermissions;
  String get remainingPermissions;
  String get defaultDuration;
  String get permissionRequests;
  String get failedToSubmitRequest;
  String get failedToCancelRequest;
  String get failedToApproveRequest;
  String get failedToRejectRequest;
  String get noHistoryFound;

  String get getAttendanceError;

  String? get checkInSuccess => null;

  get checkInFailed => null;

  get checkInError => null;

  String? get checkOutSuccess => null;

  get checkOutFailed => null;

  get checkOutError => null;

  get checkStatusError => null;
}
