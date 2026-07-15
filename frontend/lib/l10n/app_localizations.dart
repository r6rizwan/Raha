import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Raha'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @foodTab.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get foodTab;

  /// No description provided for @servicesTab.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get loginCreateAccount;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeBack;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover food, services, and local tips for expat life in the UAE.'**
  String get loginDescription;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get dontHaveAccount;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @setupYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Setup Your Account'**
  String get setupYourAccount;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @neighbourhood.
  ///
  /// In en, this message translates to:
  /// **'Neighbourhood'**
  String get neighbourhood;

  /// No description provided for @interests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interests;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @neighbourhoodHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dubai Marina, JLT'**
  String get neighbourhoodHint;

  /// No description provided for @interestsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Food, Cleaning, Exploring (Comma-separated)'**
  String get interestsHint;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get friend;

  /// No description provided for @hiName.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String hiName(String name);

  /// No description provided for @rahaToday.
  ///
  /// In en, this message translates to:
  /// **'RAHA TODAY'**
  String get rahaToday;

  /// No description provided for @heroDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover what feels familiar'**
  String get heroDefaultTitle;

  /// No description provided for @heroDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Food, services, and local help curated around {area}.'**
  String heroDefaultSubtitle(String area);

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @quickActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Jump straight into what you need'**
  String get quickActionsSubtitle;

  /// No description provided for @findFood.
  ///
  /// In en, this message translates to:
  /// **'Find food'**
  String get findFood;

  /// No description provided for @homeFlavours.
  ///
  /// In en, this message translates to:
  /// **'Home flavours'**
  String get homeFlavours;

  /// No description provided for @bookHelp.
  ///
  /// In en, this message translates to:
  /// **'Book help'**
  String get bookHelp;

  /// No description provided for @cleaningAndMore.
  ///
  /// In en, this message translates to:
  /// **'Cleaning and more'**
  String get cleaningAndMore;

  /// No description provided for @madeForYourBase.
  ///
  /// In en, this message translates to:
  /// **'Made for your base'**
  String get madeForYourBase;

  /// No description provided for @usefulPicksAround.
  ///
  /// In en, this message translates to:
  /// **'Useful picks around {city}'**
  String usefulPicksAround(String city);

  /// No description provided for @usefulPicksRoutine.
  ///
  /// In en, this message translates to:
  /// **'Useful picks for your daily routine'**
  String get usefulPicksRoutine;

  /// No description provided for @cityRhythm.
  ///
  /// In en, this message translates to:
  /// **'{city} rhythm'**
  String cityRhythm(String city);

  /// No description provided for @builtAround.
  ///
  /// In en, this message translates to:
  /// **'Built around {neighbourhood} and your preferences.'**
  String builtAround(String neighbourhood);

  /// No description provided for @generalLifestyle.
  ///
  /// In en, this message translates to:
  /// **'General lifestyle'**
  String get generalLifestyle;

  /// No description provided for @tasteOfHome.
  ///
  /// In en, this message translates to:
  /// **'Taste of home'**
  String get tasteOfHome;

  /// No description provided for @tasteOfHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with cuisines likely to feel familiar'**
  String get tasteOfHomeSubtitle;

  /// No description provided for @openFoodFeed.
  ///
  /// In en, this message translates to:
  /// **'Open food feed'**
  String get openFoodFeed;

  /// No description provided for @bookServiceFast.
  ///
  /// In en, this message translates to:
  /// **'Book a service fast'**
  String get bookServiceFast;

  /// No description provided for @bookServiceFastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Popular categories for busy UAE city life'**
  String get bookServiceFastSubtitle;

  /// No description provided for @browseProviders.
  ///
  /// In en, this message translates to:
  /// **'Browse providers'**
  String get browseProviders;

  /// No description provided for @recentBooking.
  ///
  /// In en, this message translates to:
  /// **'Recent booking'**
  String get recentBooking;

  /// No description provided for @recentBookingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your latest request'**
  String get recentBookingSubtitle;

  /// No description provided for @loadingLatestBooking.
  ///
  /// In en, this message translates to:
  /// **'Loading your latest booking...'**
  String get loadingLatestBooking;

  /// No description provided for @bookingHistoryAppear.
  ///
  /// In en, this message translates to:
  /// **'Your booking history will appear here once it is available.'**
  String get bookingHistoryAppear;

  /// No description provided for @noBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get noBookingsYet;

  /// No description provided for @noBookingsYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book a cleaner, mover, or handyman to get started.'**
  String get noBookingsYetSubtitle;

  /// No description provided for @serviceBooking.
  ///
  /// In en, this message translates to:
  /// **'Service booking'**
  String get serviceBooking;

  /// No description provided for @aiPicksForYou.
  ///
  /// In en, this message translates to:
  /// **'AI Picks for You'**
  String get aiPicksForYou;

  /// No description provided for @aiPicksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live recommendations based on your profile'**
  String get aiPicksSubtitle;

  /// No description provided for @moreRecommendations.
  ///
  /// In en, this message translates to:
  /// **'More personalised recommendations will appear here as you use Raha.'**
  String get moreRecommendations;

  /// No description provided for @recommendedNow.
  ///
  /// In en, this message translates to:
  /// **'Recommended now'**
  String get recommendedNow;

  /// No description provided for @recommendedNowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A fuller set of ideas for food, services, and local tips'**
  String get recommendedNowSubtitle;

  /// No description provided for @yourRaha.
  ///
  /// In en, this message translates to:
  /// **'YOUR RAHA'**
  String get yourRaha;

  /// No description provided for @rahaUser.
  ///
  /// In en, this message translates to:
  /// **'Raha User'**
  String get rahaUser;

  /// No description provided for @noEmailAssociated.
  ///
  /// In en, this message translates to:
  /// **'No email associated'**
  String get noEmailAssociated;

  /// No description provided for @expat.
  ///
  /// In en, this message translates to:
  /// **'Expat'**
  String get expat;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @editProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Details'**
  String get editProfileDetails;

  /// No description provided for @updateNameCityNationality.
  ///
  /// In en, this message translates to:
  /// **'Update your name, city, and nationality'**
  String get updateNameCityNationality;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @manageSavedCards.
  ///
  /// In en, this message translates to:
  /// **'Manage your saved cards'**
  String get manageSavedCards;

  /// No description provided for @paymentMethodsSoon.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods coming soon!'**
  String get paymentMethodsSoon;

  /// No description provided for @savedLocations.
  ///
  /// In en, this message translates to:
  /// **'Saved Locations'**
  String get savedLocations;

  /// No description provided for @favoriteFoodSpots.
  ///
  /// In en, this message translates to:
  /// **'Your favorite food spots'**
  String get favoriteFoodSpots;

  /// No description provided for @savedLocationsSoon.
  ///
  /// In en, this message translates to:
  /// **'Saved Locations coming soon!'**
  String get savedLocationsSoon;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @locationAndBackground.
  ///
  /// In en, this message translates to:
  /// **'Location & Background'**
  String get locationAndBackground;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @cityExample.
  ///
  /// In en, this message translates to:
  /// **'City (e.g. Dubai)'**
  String get cityExample;

  /// No description provided for @neighbourhoodExample.
  ///
  /// In en, this message translates to:
  /// **'Neighbourhood (e.g. JLT)'**
  String get neighbourhoodExample;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @pleaseEnterYourCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter your city'**
  String get pleaseEnterYourCity;

  /// No description provided for @pleaseEnterYourNeighbourhood.
  ///
  /// In en, this message translates to:
  /// **'Please enter your neighbourhood'**
  String get pleaseEnterYourNeighbourhood;

  /// No description provided for @pleaseEnterYourNationality.
  ///
  /// In en, this message translates to:
  /// **'Please enter your nationality'**
  String get pleaseEnterYourNationality;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @getAccountAssistance.
  ///
  /// In en, this message translates to:
  /// **'Get assistance with your account'**
  String get getAccountAssistance;

  /// No description provided for @helpSupportSoon.
  ///
  /// In en, this message translates to:
  /// **'Help & Support coming soon!'**
  String get helpSupportSoon;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @signOutSecurely.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account securely'**
  String get signOutSecurely;

  /// No description provided for @failedToLoadBookings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bookings'**
  String get failedToLoadBookings;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Bookings Yet'**
  String get noBookingsTitle;

  /// No description provided for @noBookingsDescription.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t made any service appointments or reservations recently.'**
  String get noBookingsDescription;

  /// No description provided for @unknownProvider.
  ///
  /// In en, this message translates to:
  /// **'Unknown Provider'**
  String get unknownProvider;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking?'**
  String get cancelBookingTitle;

  /// No description provided for @cancelBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get cancelBookingMessage;

  /// No description provided for @keepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepIt;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get yesCancel;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @scheduleService.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULE SERVICE'**
  String get scheduleService;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Select date and time'**
  String get selectDateAndTime;

  /// No description provided for @bookingInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions or details?'**
  String get bookingInstructionsHint;

  /// No description provided for @selectAppointmentTime.
  ///
  /// In en, this message translates to:
  /// **'Please select an appointment time'**
  String get selectAppointmentTime;

  /// No description provided for @bookingRequestedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking requested! Provider will confirm shortly.'**
  String get bookingRequestedSuccess;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tasteOfHomeBanner.
  ///
  /// In en, this message translates to:
  /// **'TASTE OF HOME'**
  String get tasteOfHomeBanner;

  /// No description provided for @foodFromHome.
  ///
  /// In en, this message translates to:
  /// **'Food From Home'**
  String get foodFromHome;

  /// No description provided for @cuisineComforts.
  ///
  /// In en, this message translates to:
  /// **'{cuisine} Comforts'**
  String cuisineComforts(String cuisine);

  /// No description provided for @foodSpots.
  ///
  /// In en, this message translates to:
  /// **'food spots'**
  String get foodSpots;

  /// No description provided for @trustedHelpBanner.
  ///
  /// In en, this message translates to:
  /// **'TRUSTED HELP'**
  String get trustedHelpBanner;

  /// No description provided for @homeServices.
  ///
  /// In en, this message translates to:
  /// **'Home Services'**
  String get homeServices;

  /// No description provided for @searchProviders.
  ///
  /// In en, this message translates to:
  /// **'Search providers...'**
  String get searchProviders;

  /// No description provided for @bookVerifiedProvidersAround.
  ///
  /// In en, this message translates to:
  /// **'Book verified providers around {city}'**
  String bookVerifiedProvidersAround(String city);

  /// No description provided for @noResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String noResultsFor(String query);

  /// No description provided for @yourCity.
  ///
  /// In en, this message translates to:
  /// **'your city'**
  String get yourCity;

  /// No description provided for @homeServicesType.
  ///
  /// In en, this message translates to:
  /// **'home services'**
  String get homeServicesType;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @comingToCitySoon.
  ///
  /// In en, this message translates to:
  /// **'Coming to {city} soon'**
  String comingToCitySoon(String city);

  /// No description provided for @expandingTypeToCity.
  ///
  /// In en, this message translates to:
  /// **'We\'re expanding our {type} to {city}. Check back soon - we add new cities regularly!'**
  String expandingTypeToCity(String type, String city);

  /// No description provided for @ratingSuffix.
  ///
  /// In en, this message translates to:
  /// **'rating'**
  String get ratingSuffix;

  /// No description provided for @cuisine.
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get cuisine;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(int count);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening Hours'**
  String get openingHours;

  /// No description provided for @livePlaces.
  ///
  /// In en, this message translates to:
  /// **'Live Places'**
  String get livePlaces;

  /// No description provided for @localData.
  ///
  /// In en, this message translates to:
  /// **'Local data'**
  String get localData;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @openingHoursUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Opening hours unavailable'**
  String get openingHoursUnavailable;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @todayWithDay.
  ///
  /// In en, this message translates to:
  /// **'Today ({day})'**
  String todayWithDay(String day);

  /// No description provided for @seedFallbackNote.
  ///
  /// In en, this message translates to:
  /// **'This is local fallback data. Live Google Places details appear after syncing a real Place ID.'**
  String get seedFallbackNote;

  /// No description provided for @livePlacesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Live Google Places details are unavailable right now.'**
  String get livePlacesUnavailable;

  /// No description provided for @serviceRating.
  ///
  /// In en, this message translates to:
  /// **'{rating} Rating'**
  String serviceRating(String rating);

  /// No description provided for @verifiedPartner.
  ///
  /// In en, this message translates to:
  /// **'Verified Partner'**
  String get verifiedPartner;

  /// No description provided for @aboutProvider.
  ///
  /// In en, this message translates to:
  /// **'ABOUT PROVIDER'**
  String get aboutProvider;

  /// No description provided for @serviceArea.
  ///
  /// In en, this message translates to:
  /// **'Service Area'**
  String get serviceArea;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @bookThisProvider.
  ///
  /// In en, this message translates to:
  /// **'Book this provider'**
  String get bookThisProvider;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @finalRatesMayDiffer.
  ///
  /// In en, this message translates to:
  /// **'Final rates may differ slightly depending on scope of service.'**
  String get finalRatesMayDiffer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
