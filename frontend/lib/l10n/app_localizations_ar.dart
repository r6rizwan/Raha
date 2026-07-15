// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'راحة';

  @override
  String get language => 'اللغة';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get systemDefault => 'لغة الجهاز';

  @override
  String get homeTab => 'الرئيسية';

  @override
  String get foodTab => 'الطعام';

  @override
  String get servicesTab => 'الخدمات';

  @override
  String get profileTab => 'الملف الشخصي';

  @override
  String get loginCreateAccount => 'أنشئ حسابك';

  @override
  String get loginWelcomeBack => 'مرحباً بعودتك';

  @override
  String get loginDescription =>
      'اكتشف الطعام والخدمات والنصائح المحلية لحياة المغتربين في الإمارات.';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get or => 'أو';

  @override
  String get name => 'الاسم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ أنشئ حساباً';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get setupYourAccount => 'إعداد حسابك';

  @override
  String get nationality => 'الجنسية';

  @override
  String get city => 'المدينة';

  @override
  String get neighbourhood => 'المنطقة';

  @override
  String get interests => 'الاهتمامات';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get neighbourhoodHint => 'مثال: دبي مارينا، JLT';

  @override
  String get interestsHint => 'مثال: طعام، تنظيف، استكشاف (مفصولة بفواصل)';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get friend => 'صديقي';

  @override
  String hiName(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get rahaToday => 'راحة اليوم';

  @override
  String get heroDefaultTitle => 'اكتشف ما يجعلك تشعر وكأنك في بيتك';

  @override
  String heroDefaultSubtitle(String area) {
    return 'طعام وخدمات ومساعدة محلية مختارة بعناية حول $area.';
  }

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get quickActionsSubtitle => 'انتقل مباشرة إلى ما تحتاجه';

  @override
  String get findFood => 'ابحث عن طعام';

  @override
  String get homeFlavours => 'نكهات المنزل';

  @override
  String get bookHelp => 'احجز خدمة';

  @override
  String get cleaningAndMore => 'تنظيف وأكثر';

  @override
  String get madeForYourBase => 'مصمم لاحتياجاتك';

  @override
  String usefulPicksAround(String city) {
    return 'خيارات مفيدة في $city';
  }

  @override
  String get usefulPicksRoutine => 'خيارات مفيدة لروتينك اليومي';

  @override
  String cityRhythm(String city) {
    return 'إيقاع $city';
  }

  @override
  String builtAround(String neighbourhood) {
    return 'مبني حول $neighbourhood وتفضيلاتك.';
  }

  @override
  String get generalLifestyle => 'نمط حياة عام';

  @override
  String get tasteOfHome => 'مذاق الوطن';

  @override
  String get tasteOfHomeSubtitle => 'ابدأ بالمطابخ الأقرب لما تحبه';

  @override
  String get openFoodFeed => 'افتح قائمة الطعام';

  @override
  String get bookServiceFast => 'احجز خدمة بسرعة';

  @override
  String get bookServiceFastSubtitle => 'فئات شائعة للحياة اليومية في الإمارات';

  @override
  String get browseProviders => 'تصفح المزوّدين';

  @override
  String get recentBooking => 'آخر حجز';

  @override
  String get recentBookingSubtitle => 'تابع آخر طلب قمت به';

  @override
  String get loadingLatestBooking => 'جارٍ تحميل آخر حجز...';

  @override
  String get bookingHistoryAppear => 'سيظهر سجل حجوزاتك هنا عند توفره.';

  @override
  String get noBookingsYet => 'لا توجد حجوزات بعد';

  @override
  String get noBookingsYetSubtitle => 'احجز خدمة تنظيف أو نقل أو صيانة للبدء.';

  @override
  String get serviceBooking => 'حجز خدمة';

  @override
  String get aiPicksForYou => 'اختيارات الذكاء الاصطناعي لك';

  @override
  String get aiPicksSubtitle => 'توصيات مباشرة بناءً على ملفك الشخصي';

  @override
  String get moreRecommendations =>
      'ستظهر هنا توصيات أكثر تخصيصاً كلما استخدمت راحة.';

  @override
  String get recommendedNow => 'مقترح الآن';

  @override
  String get recommendedNowSubtitle =>
      'مجموعة أوسع من أفكار الطعام والخدمات والنصائح المحلية';

  @override
  String get yourRaha => 'راحة الخاصة بك';

  @override
  String get rahaUser => 'مستخدم راحة';

  @override
  String get noEmailAssociated => 'لا يوجد بريد إلكتروني مرتبط';

  @override
  String get expat => 'مغترب';

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get account => 'الحساب';

  @override
  String get editProfileDetails => 'تعديل بيانات الملف الشخصي';

  @override
  String get updateNameCityNationality => 'حدّث اسمك ومدينتك وجنسيتك';

  @override
  String get paymentMethods => 'وسائل الدفع';

  @override
  String get manageSavedCards => 'إدارة بطاقاتك المحفوظة';

  @override
  String get paymentMethodsSoon => 'وسائل الدفع قريباً!';

  @override
  String get savedLocations => 'الأماكن المحفوظة';

  @override
  String get favoriteFoodSpots => 'أماكن الطعام المفضلة لديك';

  @override
  String get savedLocationsSoon => 'الأماكن المحفوظة قريباً!';

  @override
  String get more => 'المزيد';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get locationAndBackground => 'الموقع والخلفية';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get cityExample => 'المدينة (مثال: دبي)';

  @override
  String get neighbourhoodExample => 'المنطقة (مثال: JLT)';

  @override
  String get pleaseEnterYourName => 'يرجى إدخال اسمك';

  @override
  String get pleaseEnterYourCity => 'يرجى إدخال مدينتك';

  @override
  String get pleaseEnterYourNeighbourhood => 'يرجى إدخال منطقتك';

  @override
  String get pleaseEnterYourNationality => 'يرجى إدخال جنسيتك';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح!';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get getAccountAssistance => 'احصل على مساعدة بخصوص حسابك';

  @override
  String get helpSupportSoon => 'المساعدة والدعم قريباً!';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get signOutSecurely => 'سجّل الخروج من حسابك بأمان';

  @override
  String get failedToLoadBookings => 'تعذر تحميل الحجوزات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noBookingsTitle => 'لا توجد حجوزات بعد';

  @override
  String get noBookingsDescription =>
      'لم تقم بأي مواعيد خدمة أو حجوزات مؤخراً.';

  @override
  String get unknownProvider => 'مزود غير معروف';

  @override
  String get cancelBookingTitle => 'إلغاء الحجز؟';

  @override
  String get cancelBookingMessage => 'هل أنت متأكد أنك تريد إلغاء هذا الموعد؟';

  @override
  String get keepIt => 'الاحتفاظ به';

  @override
  String get yesCancel => 'نعم، إلغاء';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get scheduleService => 'جدولة الخدمة';

  @override
  String get selectDateAndTime => 'اختر التاريخ والوقت';

  @override
  String get bookingInstructionsHint => 'أي تعليمات أو تفاصيل إضافية؟';

  @override
  String get selectAppointmentTime => 'يرجى اختيار وقت الموعد';

  @override
  String get bookingRequestedSuccess =>
      'تم إرسال طلب الحجز! سيؤكد المزود الموعد قريباً.';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get tasteOfHomeBanner => 'نكهة الوطن';

  @override
  String get foodFromHome => 'طعام من الوطن';

  @override
  String cuisineComforts(String cuisine) {
    return 'أطباق $cuisine المريحة';
  }

  @override
  String get foodSpots => 'أماكن الطعام';

  @override
  String get trustedHelpBanner => 'خدمات موثوقة';

  @override
  String get homeServices => 'الخدمات المنزلية';

  @override
  String get searchProviders => 'ابحث عن مزودي الخدمة...';

  @override
  String bookVerifiedProvidersAround(String city) {
    return 'احجز مزودين موثوقين في $city';
  }

  @override
  String noResultsFor(String query) {
    return 'لا توجد نتائج لـ \"$query\"';
  }

  @override
  String get yourCity => 'مدينتك';

  @override
  String get homeServicesType => 'الخدمات المنزلية';

  @override
  String get verified => 'موثّق';

  @override
  String get available => 'متاح';

  @override
  String comingToCitySoon(String city) {
    return 'قريباً في $city';
  }

  @override
  String expandingTypeToCity(String type, String city) {
    return 'نحن نوسّع $type إلى $city. عد لاحقاً - نضيف مدناً جديدة باستمرار!';
  }

  @override
  String get ratingSuffix => 'تقييم';

  @override
  String get cuisine => 'المطبخ';

  @override
  String reviewsCount(int count) {
    return '$count مراجعات';
  }

  @override
  String get details => 'التفاصيل';

  @override
  String get openingHours => 'ساعات العمل';

  @override
  String get livePlaces => 'بيانات مباشرة';

  @override
  String get localData => 'بيانات محلية';

  @override
  String get directions => 'الاتجاهات';

  @override
  String get call => 'اتصال';

  @override
  String get location => 'الموقع';

  @override
  String get phone => 'الهاتف';

  @override
  String get openingHoursUnavailable => 'ساعات العمل غير متاحة';

  @override
  String get todayLabel => 'اليوم';

  @override
  String todayWithDay(String day) {
    return 'اليوم ($day)';
  }

  @override
  String get seedFallbackNote =>
      'هذه بيانات محلية احتياطية. ستظهر تفاصيل Google Places المباشرة بعد مزامنة معرّف مكان حقيقي.';

  @override
  String get livePlacesUnavailable =>
      'تفاصيل Google Places المباشرة غير متاحة حالياً.';

  @override
  String serviceRating(String rating) {
    return 'تقييم $rating';
  }

  @override
  String get verifiedPartner => 'شريك موثّق';

  @override
  String get aboutProvider => 'حول المزوّد';

  @override
  String get serviceArea => 'منطقة الخدمة';

  @override
  String get contactNumber => 'رقم التواصل';

  @override
  String get bookThisProvider => 'احجز هذا المزوّد';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get cancel => 'إلغاء';

  @override
  String get finalRatesMayDiffer =>
      'قد تختلف الأسعار النهائية قليلاً حسب نطاق الخدمة.';
}
