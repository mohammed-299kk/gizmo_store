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
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Gizmo Store'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search for products...'**
  String get searchProducts;

  /// No description provided for @featuredProducts.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get featuredProducts;

  /// No description provided for @newArrivals.
  ///
  /// In en, this message translates to:
  /// **'New Arrivals'**
  String get newArrivals;

  /// No description provided for @bestSellers.
  ///
  /// In en, this message translates to:
  /// **'Best Sellers'**
  String get bestSellers;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @youAreGuestNow.
  ///
  /// In en, this message translates to:
  /// **'You are a guest now'**
  String get youAreGuestNow;

  /// No description provided for @loginToViewProfile.
  ///
  /// In en, this message translates to:
  /// **'Log in to view your profile and enjoy the full features of the app.'**
  String get loginToViewProfile;

  /// No description provided for @goToRegistrationPage.
  ///
  /// In en, this message translates to:
  /// **'Go to registration page'**
  String get goToRegistrationPage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @newUser.
  ///
  /// In en, this message translates to:
  /// **'New user'**
  String get newUser;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID (UID):'**
  String get userId;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get registrationDate;

  /// No description provided for @undefined.
  ///
  /// In en, this message translates to:
  /// **'Undefined'**
  String get undefined;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @addressManagementInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Address management is under development'**
  String get addressManagementInDevelopment;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationManagementInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Notification management is under development'**
  String get notificationManagementInDevelopment;

  /// Help and support section title
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @helpAndSupportInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Help and support is under development'**
  String get helpAndSupportInDevelopment;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Security'**
  String get privacyAndSecurity;

  /// No description provided for @privacyAndSecurityInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Privacy and security settings are under development'**
  String get privacyAndSecurityInDevelopment;

  /// About app menu item
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @firebaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Firebase Details'**
  String get firebaseDetails;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Title for about section
  ///
  /// In en, this message translates to:
  /// **'About Gizmo Store'**
  String get aboutGizmoStore;

  /// No description provided for @version100.
  ///
  /// In en, this message translates to:
  /// **'Version: 1.0.0'**
  String get version100;

  /// No description provided for @demoEcommerceApp.
  ///
  /// In en, this message translates to:
  /// **'Demo e-commerce application.'**
  String get demoEcommerceApp;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @privacyAndSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Security'**
  String get privacyAndSecurityTitle;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettings;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @biometricAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthentication;

  /// No description provided for @managePrivacyData.
  ///
  /// In en, this message translates to:
  /// **'Manage Privacy Data'**
  String get managePrivacyData;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @changePasswordUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Change password feature is under development'**
  String get changePasswordUnderDevelopment;

  /// No description provided for @biometricAuthUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication feature is under development'**
  String get biometricAuthUnderDevelopment;

  /// No description provided for @managePrivacyDataUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Manage privacy data feature is under development'**
  String get managePrivacyDataUnderDevelopment;

  /// No description provided for @privacyPolicyUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy feature is under development'**
  String get privacyPolicyUnderDevelopment;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Reviews text
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @searchForProducts.
  ///
  /// In en, this message translates to:
  /// **'Search for products...'**
  String get searchForProducts;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @topRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @smartphones.
  ///
  /// In en, this message translates to:
  /// **'Smartphones'**
  String get smartphones;

  /// Computer category
  ///
  /// In en, this message translates to:
  /// **'Computers'**
  String get computers;

  /// Tablet category
  ///
  /// In en, this message translates to:
  /// **'Tablets'**
  String get tablets;

  /// No description provided for @smartwatches.
  ///
  /// In en, this message translates to:
  /// **'Smartwatches'**
  String get smartwatches;

  /// Headphones category
  ///
  /// In en, this message translates to:
  /// **'Headphones'**
  String get headphones;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessories;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get failedToLoadProducts;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range (EGP)'**
  String priceRange(Object max, Object min);

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get resetFilters;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get emptyCart;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @addressManagement.
  ///
  /// In en, this message translates to:
  /// **'Address Management'**
  String get addressManagement;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @appInformation.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

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

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Affirmative response
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Negative response
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// No description provided for @defaultAddress.
  ///
  /// In en, this message translates to:
  /// **'Default Address'**
  String get defaultAddress;

  /// No description provided for @noAddressesFound.
  ///
  /// In en, this message translates to:
  /// **'No addresses found'**
  String get noAddressesFound;

  /// No description provided for @addYourFirstAddress.
  ///
  /// In en, this message translates to:
  /// **'Add your first address'**
  String get addYourFirstAddress;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Firebase auth error: invalid-email
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password too short'**
  String get passwordTooShort;

  /// Error message when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @pleaseEnterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get pleaseEnterValidName;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @pleaseEnterValidStreet.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid street address'**
  String get pleaseEnterValidStreet;

  /// No description provided for @pleaseEnterValidCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid city'**
  String get pleaseEnterValidCity;

  /// No description provided for @pleaseEnterValidState.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid state'**
  String get pleaseEnterValidState;

  /// No description provided for @pleaseEnterValidPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid postal code'**
  String get pleaseEnterValidPostalCode;

  /// No description provided for @pleaseEnterValidCountry.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid country'**
  String get pleaseEnterValidCountry;

  /// No description provided for @deleteAddressConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get deleteAddressConfirmation;

  /// No description provided for @addressDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Address deleted successfully'**
  String get addressDeletedSuccessfully;

  /// No description provided for @addressSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Address saved successfully'**
  String get addressSavedSuccessfully;

  /// No description provided for @failedToSaveAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to save address'**
  String get failedToSaveAddress;

  /// No description provided for @failedToDeleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete address'**
  String get failedToDeleteAddress;

  /// No description provided for @failedToLoadAddresses.
  ///
  /// In en, this message translates to:
  /// **'Failed to load addresses'**
  String get failedToLoadAddresses;

  /// No description provided for @priceFormat.
  ///
  /// In en, this message translates to:
  /// **'Price: {price} EGP'**
  String priceFormat(Object price);

  /// Text for unspecified values
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

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

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @adminLogin.
  ///
  /// In en, this message translates to:
  /// **'Admin Login'**
  String get adminLogin;

  /// No description provided for @signInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in successful!'**
  String get signInSuccess;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @databaseInitDescription.
  ///
  /// In en, this message translates to:
  /// **'Initializing database with sample data...'**
  String get databaseInitDescription;

  /// The word 'or' used between options
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Text for creating a new account
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// Text prompting user to sign in
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Text inviting user to join
  ///
  /// In en, this message translates to:
  /// **'Join the Gizmo family'**
  String get joinGizmoFamily;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @noAccountCreateNew.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Create new'**
  String get noAccountCreateNew;

  /// Text for users who already have an account
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccountSignIn;

  /// Welcome message for returning users
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Description of the app
  ///
  /// In en, this message translates to:
  /// **'Gizmo Store is your one-stop shop for all electronic gadgets and accessories.'**
  String get aboutDescription;

  /// Confirmation message for logout
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Terms of service menu item
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Text indicating feature is coming soon
  ///
  /// In en, this message translates to:
  /// **'coming soon!'**
  String get comingSoon;

  /// Rate app menu item
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// App information section title
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInfo;

  /// App version information
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// Help center menu item
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// Contact us menu item
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @appLaunchedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'App launched successfully! 🎉'**
  String get appLaunchedSuccessfully;

  /// No description provided for @userType.
  ///
  /// In en, this message translates to:
  /// **'User Type'**
  String get userType;

  /// No description provided for @registeredUser.
  ///
  /// In en, this message translates to:
  /// **'Registered User'**
  String get registeredUser;

  /// No description provided for @appWorkingNormally.
  ///
  /// In en, this message translates to:
  /// **'App is working normally now!'**
  String get appWorkingNormally;

  /// No description provided for @navigationButtons.
  ///
  /// In en, this message translates to:
  /// **'Navigation Buttons'**
  String get navigationButtons;

  /// No description provided for @cartWorks.
  ///
  /// In en, this message translates to:
  /// **'Cart works!'**
  String get cartWorks;

  /// No description provided for @favoritesWork.
  ///
  /// In en, this message translates to:
  /// **'Favorites work!'**
  String get favoritesWork;

  /// No description provided for @settingsWork.
  ///
  /// In en, this message translates to:
  /// **'Settings work!'**
  String get settingsWork;

  /// Wishlist tab label
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// Phone category
  ///
  /// In en, this message translates to:
  /// **'Phones'**
  String get phones;

  /// Watch category
  ///
  /// In en, this message translates to:
  /// **'Watches'**
  String get watches;

  /// Television category
  ///
  /// In en, this message translates to:
  /// **'Televisions'**
  String get televisions;

  /// Currency abbreviation
  ///
  /// In en, this message translates to:
  /// **'SDG'**
  String get currency;

  /// Title for clear cart dialog
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clearCart;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartEmpty;

  /// No description provided for @startAddingProducts.
  ///
  /// In en, this message translates to:
  /// **'Start adding products to your cart'**
  String get startAddingProducts;

  /// No description provided for @browseProducts.
  ///
  /// In en, this message translates to:
  /// **'Browse Products'**
  String get browseProducts;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax (15%)'**
  String get tax;

  /// No description provided for @finalTotal.
  ///
  /// In en, this message translates to:
  /// **'Final Total'**
  String get finalTotal;

  /// No description provided for @proceedToPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceedToPayment;

  /// Success message when product is removed from cart
  ///
  /// In en, this message translates to:
  /// **'{productName} removed from cart'**
  String productRemovedFromCart(Object productName);

  /// Confirmation message for clearing cart
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove all products from cart?'**
  String get clearCartConfirmation;

  /// No description provided for @cartClearedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Cart cleared successfully'**
  String get cartClearedSuccessfully;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @paymentPageComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Payment page coming soon!'**
  String get paymentPageComingSoon;

  /// No description provided for @orderCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order created successfully!'**
  String get orderCreatedSuccessfully;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @minimumRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum Rating'**
  String get minimumRating;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @previousSearches.
  ///
  /// In en, this message translates to:
  /// **'Previous Searches'**
  String get previousSearches;

  /// Button to clear all items
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @tryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or modify filters'**
  String get tryDifferentKeywords;

  /// Smart electronics store description
  ///
  /// In en, this message translates to:
  /// **'Smart Electronics Store'**
  String get smartElectronicsStore;

  /// Product details dialog title
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @noProductDescription.
  ///
  /// In en, this message translates to:
  /// **'No product description available.'**
  String get noProductDescription;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// Message when item is added to cart
  ///
  /// In en, this message translates to:
  /// **'added to cart'**
  String get addedToCart;

  /// No description provided for @removedFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'removed from wishlist'**
  String get removedFromWishlist;

  /// No description provided for @addedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'added to wishlist'**
  String get addedToWishlist;

  /// No description provided for @fromWishlist.
  ///
  /// In en, this message translates to:
  /// **'from wishlist'**
  String get fromWishlist;

  /// No description provided for @toWishlist.
  ///
  /// In en, this message translates to:
  /// **'to wishlist'**
  String get toWishlist;

  /// No description provided for @viewAllReviews.
  ///
  /// In en, this message translates to:
  /// **'View All Reviews'**
  String get viewAllReviews;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'App Name:'**
  String get appName;

  /// No description provided for @projectId.
  ///
  /// In en, this message translates to:
  /// **'Project ID:'**
  String get projectId;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key:'**
  String get apiKey;

  /// No description provided for @appId.
  ///
  /// In en, this message translates to:
  /// **'App ID:'**
  String get appId;

  /// No description provided for @androidClientId.
  ///
  /// In en, this message translates to:
  /// **'Android Client ID:'**
  String get androidClientId;

  /// No description provided for @iosClientId.
  ///
  /// In en, this message translates to:
  /// **'iOS Client ID:'**
  String get iosClientId;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @authStatus.
  ///
  /// In en, this message translates to:
  /// **'Authentication Status'**
  String get authStatus;

  /// No description provided for @loginStatus.
  ///
  /// In en, this message translates to:
  /// **'Login Status:'**
  String get loginStatus;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged In'**
  String get loggedIn;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not Logged In'**
  String get notLoggedIn;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name:'**
  String get displayName;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous:'**
  String get anonymous;

  /// Title for Firebase services status section
  ///
  /// In en, this message translates to:
  /// **'Services Status'**
  String get servicesStatus;

  /// No description provided for @firestoreStatus.
  ///
  /// In en, this message translates to:
  /// **'Firestore: Connected (if app is working)'**
  String get firestoreStatus;

  /// No description provided for @messagingStatus.
  ///
  /// In en, this message translates to:
  /// **'Messaging: Connected (if configured)'**
  String get messagingStatus;

  /// No description provided for @wishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Wishlist is empty'**
  String get wishlistEmpty;

  /// No description provided for @addFavoriteProducts.
  ///
  /// In en, this message translates to:
  /// **'Add your favorite products to access them easily later.'**
  String get addFavoriteProducts;

  /// No description provided for @clearWishlist.
  ///
  /// In en, this message translates to:
  /// **'Clear Wishlist'**
  String get clearWishlist;

  /// No description provided for @clearWishlistConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all products from wishlist?'**
  String get clearWishlistConfirmation;

  /// No description provided for @specialOffer.
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get specialOffer;

  /// No description provided for @upTo50Off.
  ///
  /// In en, this message translates to:
  /// **'Up to 50% off'**
  String get upTo50Off;

  /// No description provided for @availableCoupons.
  ///
  /// In en, this message translates to:
  /// **'Available Coupons'**
  String get availableCoupons;

  /// No description provided for @myCoupons.
  ///
  /// In en, this message translates to:
  /// **'My Coupons'**
  String get myCoupons;

  /// No description provided for @haveCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Have a coupon code?'**
  String get haveCouponCode;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enterCouponCode;

  /// No description provided for @applyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyCoupon;

  /// No description provided for @couponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied:'**
  String get couponApplied;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @noCouponsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No coupons available currently'**
  String get noCouponsAvailable;

  /// No description provided for @noCouponsInWallet.
  ///
  /// In en, this message translates to:
  /// **'No coupons in your wallet'**
  String get noCouponsInWallet;

  /// No description provided for @minimumOrder.
  ///
  /// In en, this message translates to:
  /// **'Minimum Order'**
  String get minimumOrder;

  /// No description provided for @maximumDiscount.
  ///
  /// In en, this message translates to:
  /// **'Maximum Discount'**
  String get maximumDiscount;

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid Until'**
  String get validUntil;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @couponAppliedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied successfully'**
  String get couponAppliedSuccessfully;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Middle Name (Optional)'**
  String get middleName;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (Optional)'**
  String get phoneOptional;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get currentPasswordRequired;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get newPasswordRequired;

  /// Error message for password minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @chooseImageSource.
  ///
  /// In en, this message translates to:
  /// **'Choose Image Source'**
  String get chooseImageSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @errorSelectingImage.
  ///
  /// In en, this message translates to:
  /// **'Error selecting image'**
  String get errorSelectingImage;

  /// No description provided for @selectingImage.
  ///
  /// In en, this message translates to:
  /// **'Selecting image...'**
  String get selectingImage;

  /// No description provided for @imageSelectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image selected successfully'**
  String get imageSelectedSuccessfully;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Selected file not found'**
  String get fileNotFound;

  /// No description provided for @imageSelectionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Image selection cancelled'**
  String get imageSelectionCancelled;

  /// No description provided for @failedToSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to select image'**
  String get failedToSelectImage;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get userNotLoggedIn;

  /// No description provided for @uploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading image...'**
  String get uploadingImage;

  /// No description provided for @imageUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded successfully'**
  String get imageUploadedSuccessfully;

  /// Exception message when uploading image fails
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get failedToUploadImage;

  /// No description provided for @changesSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get changesSavedSuccessfully;

  /// No description provided for @failedToSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes'**
  String get failedToSaveChanges;

  /// No description provided for @adminPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Gizmo Store Admin Panel'**
  String get adminPanelTitle;

  /// No description provided for @unauthorizedAccess.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to access the admin panel'**
  String get unauthorizedAccess;

  /// Firebase auth error: user-not-found
  ///
  /// In en, this message translates to:
  /// **'No user found with this email'**
  String get userNotFound;

  /// Firebase auth error: wrong-password
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get wrongPassword;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get accountDisabled;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts, please try again later'**
  String get tooManyAttempts;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login error'**
  String get loginError;

  /// No description provided for @onlyAdminAccess.
  ///
  /// In en, this message translates to:
  /// **'Only admin can access this panel'**
  String get onlyAdminAccess;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by Status'**
  String get filterByStatus;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get preparing;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @loadingOrders.
  ///
  /// In en, this message translates to:
  /// **'Loading orders...'**
  String get loadingOrders;

  /// No description provided for @errorLoadingOrders.
  ///
  /// In en, this message translates to:
  /// **'Error loading orders'**
  String get errorLoadingOrders;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @noOrdersWithStatus.
  ///
  /// In en, this message translates to:
  /// **'No orders with status'**
  String get noOrdersWithStatus;

  /// No description provided for @startShoppingFirstOrder.
  ///
  /// In en, this message translates to:
  /// **'Start shopping to create your first order'**
  String get startShoppingFirstOrder;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @orderDate.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get orderDate;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method: Credit Card'**
  String get paymentMethod;

  /// No description provided for @orderAddress.
  ///
  /// In en, this message translates to:
  /// **'Address: Khartoum, Riyadh District, Nile Fahd Street'**
  String get orderAddress;

  /// No description provided for @orderProducts.
  ///
  /// In en, this message translates to:
  /// **'Products:'**
  String get orderProducts;

  /// No description provided for @orderSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal:'**
  String get orderSubtotal;

  /// No description provided for @orderShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping:'**
  String get orderShipping;

  /// Free shipping or free item
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @orderTax.
  ///
  /// In en, this message translates to:
  /// **'Tax:'**
  String get orderTax;

  /// No description provided for @orderGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total:'**
  String get orderGrandTotal;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @loginRequiredForOrders.
  ///
  /// In en, this message translates to:
  /// **'You must log in to view orders'**
  String get loginRequiredForOrders;

  /// No description provided for @errorLoadingOrdersMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading orders'**
  String get errorLoadingOrdersMessage;

  /// No description provided for @retryLoading.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLoading;

  /// No description provided for @shippingInformation.
  ///
  /// In en, this message translates to:
  /// **'Shipping Information'**
  String get shippingInformation;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get pleaseEnterFullName;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get pleaseEnterAddress;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @pleaseEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter city'**
  String get pleaseEnterCity;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodLabel;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cashOnDelivery;

  /// Order summary section title
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @productsLabel.
  ///
  /// In en, this message translates to:
  /// **'Products:'**
  String get productsLabel;

  /// No description provided for @shippingLabel.
  ///
  /// In en, this message translates to:
  /// **'Shipping:'**
  String get shippingLabel;

  /// No description provided for @taxLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax:'**
  String get taxLabel;

  /// No description provided for @grandTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Grand Total:'**
  String get grandTotalLabel;

  /// No description provided for @completeOrder.
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get completeOrder;

  /// No description provided for @orderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order Completed'**
  String get orderCompleted;

  /// No description provided for @orderCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your order has been completed successfully. We will contact you soon.'**
  String get orderCompletedMessage;

  /// No description provided for @completeOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get completeOrderButton;

  /// No description provided for @loadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingText;

  /// No description provided for @redScreenIssueFixed.
  ///
  /// In en, this message translates to:
  /// **'Red screen freeze issue has been fixed'**
  String get redScreenIssueFixed;

  /// No description provided for @gizmoStoreTest.
  ///
  /// In en, this message translates to:
  /// **'Gizmo Store - Test'**
  String get gizmoStoreTest;

  /// No description provided for @databaseInitialization.
  ///
  /// In en, this message translates to:
  /// **'Database Initialization'**
  String get databaseInitialization;

  /// No description provided for @readyToInitialize.
  ///
  /// In en, this message translates to:
  /// **'Ready to initialize database'**
  String get readyToInitialize;

  /// No description provided for @initializingDatabase.
  ///
  /// In en, this message translates to:
  /// **'Initializing database...'**
  String get initializingDatabase;

  /// No description provided for @startingInitialization.
  ///
  /// In en, this message translates to:
  /// **'Starting database initialization...'**
  String get startingInitialization;

  /// No description provided for @creatingCategories.
  ///
  /// In en, this message translates to:
  /// **'Creating categories...'**
  String get creatingCategories;

  /// No description provided for @categoriesCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'✅ Categories created successfully'**
  String get categoriesCreatedSuccessfully;

  /// No description provided for @productsCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'✅ Products created successfully'**
  String get productsCreatedSuccessfully;

  /// No description provided for @databaseInitializedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'✅ Database initialized successfully!'**
  String get databaseInitializedSuccessfully;

  /// No description provided for @initializationCompleted.
  ///
  /// In en, this message translates to:
  /// **'🎉 Database initialization completed successfully!'**
  String get initializationCompleted;

  /// No description provided for @initializationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Initialization Success'**
  String get initializationSuccess;

  /// No description provided for @initializationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Database initialized successfully!\nYou can now use the app.'**
  String get initializationSuccessMessage;

  /// No description provided for @initializationFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to initialize database'**
  String get initializationFailed;

  /// No description provided for @operationLog.
  ///
  /// In en, this message translates to:
  /// **'Operation Log:'**
  String get operationLog;

  /// No description provided for @initializeDatabase.
  ///
  /// In en, this message translates to:
  /// **'Initialize Database'**
  String get initializeDatabase;

  /// Message indicating checkout feature is coming soon
  ///
  /// In en, this message translates to:
  /// **'Checkout screen coming soon!'**
  String get checkoutComingSoon;

  /// No description provided for @reviewsSection.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsSection;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Welcome message for guest users
  ///
  /// In en, this message translates to:
  /// **'Welcome, Guest'**
  String get welcomeGuest;

  /// Subtitle encouraging product discovery
  ///
  /// In en, this message translates to:
  /// **'Discover the latest products'**
  String get discoverLatestProducts;

  /// Generic product title placeholder
  ///
  /// In en, this message translates to:
  /// **'Product Title'**
  String get productTitle;

  /// Message when wishlist is empty
  ///
  /// In en, this message translates to:
  /// **'No favorite products yet'**
  String get noFavoriteProducts;

  /// Button to view shopping cart
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get viewCart;

  /// Label for guest user
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @firebaseSettings.
  ///
  /// In en, this message translates to:
  /// **'Firebase Settings'**
  String get firebaseSettings;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @categoriesTab.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTab;

  /// No description provided for @favoritesTab.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTab;

  /// No description provided for @accountTab.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTab;

  /// Error message when products fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading products: {error}'**
  String errorLoadingProducts(String error);

  /// No description provided for @welcomeToGizmoStore.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Gizmo Store!'**
  String get welcomeToGizmoStore;

  /// No description provided for @discoverLatestTechProducts.
  ///
  /// In en, this message translates to:
  /// **'Discover the latest tech products'**
  String get discoverLatestTechProducts;

  /// No description provided for @allProducts.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get allProducts;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @noFavoriteProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No favorite products yet'**
  String get noFavoriteProductsYet;

  /// No description provided for @tapHeartToAddFavorites.
  ///
  /// In en, this message translates to:
  /// **'Tap ♡ to add products to favorites'**
  String get tapHeartToAddFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed {productName} from favorites'**
  String removedFromFavorites(Object productName);

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added {productName} to favorites'**
  String addedToFavorites(Object productName);

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @locationAndDate.
  ///
  /// In en, this message translates to:
  /// **'Khartoum - December 2024'**
  String get locationAndDate;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loadingCategories.
  ///
  /// In en, this message translates to:
  /// **'Loading categories...'**
  String get loadingCategories;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// No description provided for @failedToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories. Showing default categories.'**
  String get failedToLoadCategories;

  /// No description provided for @laptops.
  ///
  /// In en, this message translates to:
  /// **'Laptops'**
  String get laptops;

  /// No description provided for @categoryProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get categoryProducts;

  /// No description provided for @noProductsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No products in this category'**
  String get noProductsInCategory;

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// Label for shipping cost
  ///
  /// In en, this message translates to:
  /// **'Shipping Cost'**
  String get shippingCost;

  /// Button to proceed to checkout
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// Label for number of items
  ///
  /// In en, this message translates to:
  /// **'Item count:'**
  String get itemCount;

  /// Plural form of item
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// Title for remove product dialog
  ///
  /// In en, this message translates to:
  /// **'Remove Product'**
  String get removeProduct;

  /// Confirmation message for removing product from cart
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove \"{productName}\" from cart?'**
  String removeProductConfirmation(Object productName);

  /// Success message when cart is cleared
  ///
  /// In en, this message translates to:
  /// **'Cart cleared completely'**
  String get cartClearedCompletely;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @categoryPhones.
  ///
  /// In en, this message translates to:
  /// **'Phones'**
  String get categoryPhones;

  /// Computers category
  ///
  /// In en, this message translates to:
  /// **'Computers'**
  String get categoryComputers;

  /// Headphones category
  ///
  /// In en, this message translates to:
  /// **'Headphones'**
  String get categoryHeadphones;

  /// Tablets category
  ///
  /// In en, this message translates to:
  /// **'Tablets'**
  String get categoryTablets;

  /// No description provided for @categoryWatches.
  ///
  /// In en, this message translates to:
  /// **'Watches'**
  String get categoryWatches;

  /// No description provided for @categoryTv.
  ///
  /// In en, this message translates to:
  /// **'TV'**
  String get categoryTv;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingAddress;

  /// No description provided for @pleaseSelectAddress.
  ///
  /// In en, this message translates to:
  /// **'Please select an address'**
  String get pleaseSelectAddress;

  /// No description provided for @shippingMethod.
  ///
  /// In en, this message translates to:
  /// **'Shipping Method'**
  String get shippingMethod;

  /// No description provided for @pleaseSelectShippingMethod.
  ///
  /// In en, this message translates to:
  /// **'Please select a shipping method'**
  String get pleaseSelectShippingMethod;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @homeAddress.
  ///
  /// In en, this message translates to:
  /// **'King Fahd Street, Riyadh, Saudi Arabia'**
  String get homeAddress;

  /// No description provided for @workAddress.
  ///
  /// In en, this message translates to:
  /// **'King Abdullah Road, Riyadh, Saudi Arabia'**
  String get workAddress;

  /// No description provided for @mustLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'You must log in first'**
  String get mustLoginFirst;

  /// No description provided for @errorLoadingAddresses.
  ///
  /// In en, this message translates to:
  /// **'Error loading addresses'**
  String get errorLoadingAddresses;

  /// No description provided for @noSavedAddresses.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get noSavedAddresses;

  /// No description provided for @addFirstAddress.
  ///
  /// In en, this message translates to:
  /// **'Add your first address to get started'**
  String get addFirstAddress;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @standardShipping.
  ///
  /// In en, this message translates to:
  /// **'Standard Shipping'**
  String get standardShipping;

  /// No description provided for @standardShippingDesc.
  ///
  /// In en, this message translates to:
  /// **'Takes 5-7 business days'**
  String get standardShippingDesc;

  /// No description provided for @expressShipping.
  ///
  /// In en, this message translates to:
  /// **'Express Shipping'**
  String get expressShipping;

  /// No description provided for @expressShippingDesc.
  ///
  /// In en, this message translates to:
  /// **'Takes 2-3 business days'**
  String get expressShippingDesc;

  /// No description provided for @sameDayShipping.
  ///
  /// In en, this message translates to:
  /// **'Same Day Shipping'**
  String get sameDayShipping;

  /// No description provided for @sameDayShippingDesc.
  ///
  /// In en, this message translates to:
  /// **'Your order arrives the same day'**
  String get sameDayShippingDesc;

  /// No description provided for @gizmoStoreAdminPanel.
  ///
  /// In en, this message translates to:
  /// **'Gizmo Store Admin Panel'**
  String get gizmoStoreAdminPanel;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// Manage products screen title
  ///
  /// In en, this message translates to:
  /// **'Manage Products'**
  String get manageProducts;

  /// No description provided for @welcomeToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Dashboard'**
  String get welcomeToDashboard;

  /// No description provided for @addNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addNewProduct;

  /// No description provided for @addNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Add New Category'**
  String get addNewCategory;

  /// No description provided for @manageOrders.
  ///
  /// In en, this message translates to:
  /// **'Manage Orders'**
  String get manageOrders;

  /// Sudanese Pound currency
  ///
  /// In en, this message translates to:
  /// **'Sudanese Pound'**
  String get sudanesePound;

  /// US Dollar currency
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get usDollar;

  /// Euro currency
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get euro;

  /// Saudi Riyal currency
  ///
  /// In en, this message translates to:
  /// **'Saudi Riyal'**
  String get saudiRiyal;

  /// Emirati Dirham currency
  ///
  /// In en, this message translates to:
  /// **'Emirati Dirham'**
  String get emiratiDirham;

  /// Error message when categories fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading categories'**
  String get errorLoadingCategories;

  /// No description provided for @productAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully'**
  String get productAddedSuccessfully;

  /// Error message when adding product fails
  ///
  /// In en, this message translates to:
  /// **'Error adding product'**
  String get errorAddingProduct;

  /// No description provided for @addNewProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addNewProductTitle;

  /// Label for product name field
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// Validation message for product name field
  ///
  /// In en, this message translates to:
  /// **'Please enter product name'**
  String get pleaseEnterProductName;

  /// Label for product description field
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get productDescription;

  /// Validation message for product description field
  ///
  /// In en, this message translates to:
  /// **'Please enter product description'**
  String get pleaseEnterProductDescription;

  /// Validation message for price field
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get pleaseEnterPrice;

  /// Validation message for numeric fields
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// Validation message for category field
  ///
  /// In en, this message translates to:
  /// **'Please select category'**
  String get pleaseSelectCategory;

  /// No description provided for @discountPercentage.
  ///
  /// In en, this message translates to:
  /// **'Discount Percentage (%)'**
  String get discountPercentage;

  /// Label for location field
  ///
  /// In en, this message translates to:
  /// **'Khartoum, Sudan'**
  String get location;

  /// Label for featured product toggle
  ///
  /// In en, this message translates to:
  /// **'Featured Product'**
  String get featuredProduct;

  /// No description provided for @productImages.
  ///
  /// In en, this message translates to:
  /// **'Product Images'**
  String get productImages;

  /// Label for image URL field
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @specification.
  ///
  /// In en, this message translates to:
  /// **'Specification'**
  String get specification;

  /// Save product button text
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// Search field placeholder for products
  ///
  /// In en, this message translates to:
  /// **'Search for product'**
  String get searchForProduct;

  /// Message when no products are available
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProducts;

  /// Default text when product has no name
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// Category label prefix
  ///
  /// In en, this message translates to:
  /// **'Category: '**
  String get categoryLabel;

  /// Price label prefix
  ///
  /// In en, this message translates to:
  /// **'Price: '**
  String get priceLabel;

  /// Discount label prefix
  ///
  /// In en, this message translates to:
  /// **'Discount: '**
  String get discountLabel;

  /// Hide button text
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// Show button text
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// Delete confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Delete product confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the product \"{productName}\"?'**
  String deleteProductConfirmation(String productName);

  /// Success message when product is deleted
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productDeletedSuccessfully;

  /// Error message when deleting product fails
  ///
  /// In en, this message translates to:
  /// **'Error deleting product'**
  String get errorDeletingProduct;

  /// Message when product is hidden
  ///
  /// In en, this message translates to:
  /// **'Product hidden'**
  String get productHidden;

  /// Message when product is shown
  ///
  /// In en, this message translates to:
  /// **'Product shown'**
  String get productShown;

  /// Error message when updating product fails
  ///
  /// In en, this message translates to:
  /// **'Error updating product'**
  String get errorUpdatingProduct;

  /// Description label prefix
  ///
  /// In en, this message translates to:
  /// **'Description: '**
  String get descriptionLabel;

  /// Text when product has no description
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// Stock label prefix
  ///
  /// In en, this message translates to:
  /// **'Stock: '**
  String get stockLabel;

  /// Rating label prefix
  ///
  /// In en, this message translates to:
  /// **'Rating: '**
  String get ratingLabel;

  /// Status label prefix
  ///
  /// In en, this message translates to:
  /// **'Status: '**
  String get statusLabel;

  /// Available status text
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Unavailable status text
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Edit product screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// Error message when image picking fails
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get errorPickingImage;

  /// Error message when uploading image fails
  ///
  /// In en, this message translates to:
  /// **'Error uploading image'**
  String get errorUploadingImage;

  /// Error message when deleting image fails
  ///
  /// In en, this message translates to:
  /// **'Error deleting image'**
  String get errorDeletingImage;

  /// Success message when image is deleted
  ///
  /// In en, this message translates to:
  /// **'Image deleted successfully'**
  String get imageDeletedSuccessfully;

  /// Success message when product is updated
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get productUpdatedSuccessfully;

  /// Button text to add image from gallery
  ///
  /// In en, this message translates to:
  /// **'Add Image from Gallery'**
  String get addImageFromGallery;

  /// Label for selected image
  ///
  /// In en, this message translates to:
  /// **'Selected Image:'**
  String get selectedImage;

  /// Label for current images section
  ///
  /// In en, this message translates to:
  /// **'Current Images:'**
  String get currentImages;

  /// Button text to add specification
  ///
  /// In en, this message translates to:
  /// **'Add Specification'**
  String get addSpecification;

  /// Label for current specifications section
  ///
  /// In en, this message translates to:
  /// **'Current Specifications:'**
  String get currentSpecifications;

  /// Label for availability toggle
  ///
  /// In en, this message translates to:
  /// **'Available for Sale'**
  String get availableForSale;

  /// Button text to update product
  ///
  /// In en, this message translates to:
  /// **'Update Product'**
  String get updateProduct;

  /// Smartphones category
  ///
  /// In en, this message translates to:
  /// **'Smartphones'**
  String get categorySmartphones;

  /// Laptops category
  ///
  /// In en, this message translates to:
  /// **'Laptops'**
  String get categoryLaptops;

  /// Smart watches category
  ///
  /// In en, this message translates to:
  /// **'Smart Watches'**
  String get categorySmartWatches;

  /// Accessories category
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get categoryAccessories;

  /// Cameras category
  ///
  /// In en, this message translates to:
  /// **'Cameras'**
  String get categoryCameras;

  /// Gaming category
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get categoryGaming;

  /// iPhone 15 Pro description
  ///
  /// In en, this message translates to:
  /// **'Latest Apple phone with A17 Pro chip and enhanced camera'**
  String get productIphone15ProDesc;

  /// Galaxy S24 Ultra description
  ///
  /// In en, this message translates to:
  /// **'Samsung flagship phone with S Pen and 200MP camera'**
  String get productGalaxyS24UltraDesc;

  /// Pixel 8 Pro description
  ///
  /// In en, this message translates to:
  /// **'Google phone with advanced AI and excellent camera'**
  String get productPixel8ProDesc;

  /// MacBook Pro description
  ///
  /// In en, this message translates to:
  /// **'Apple laptop with M3 Pro chip and Retina display'**
  String get productMacBookProDesc;

  /// Dell XPS description
  ///
  /// In en, this message translates to:
  /// **'Lightweight Dell laptop with Intel Core i7 processor'**
  String get productDellXpsDesc;

  /// AirPods Pro description
  ///
  /// In en, this message translates to:
  /// **'Apple wireless earphones with active noise cancellation'**
  String get productAirPodsProDesc;

  /// Sony WH-1000XM5 description
  ///
  /// In en, this message translates to:
  /// **'Sony flagship headphones with excellent noise cancellation'**
  String get productSonyWHDesc;

  /// Apple Watch description
  ///
  /// In en, this message translates to:
  /// **'Apple smart watch with advanced health monitoring'**
  String get productAppleWatchDesc;

  /// iPad Pro description
  ///
  /// In en, this message translates to:
  /// **'iPad Pro with M2 chip and Liquid Retina display'**
  String get productIpadProDesc;

  /// MagSafe charger description
  ///
  /// In en, this message translates to:
  /// **'Apple wireless magnetic charger'**
  String get productMagSafeDesc;

  /// OnePlus 12 description
  ///
  /// In en, this message translates to:
  /// **'OnePlus phone with 100W fast charging and powerful performance'**
  String get productOnePlus12Desc;

  /// MacBook Pro 16 M3 Max description
  ///
  /// In en, this message translates to:
  /// **'Apple professional laptop with M3 Max processor for designers and developers'**
  String get productMacBookPro16M3MaxDesc;

  /// Dell XPS 15 description
  ///
  /// In en, this message translates to:
  /// **'Dell professional laptop with 4K screen and powerful performance'**
  String get productDellXps15Desc;

  /// iPad Pro M2 description
  ///
  /// In en, this message translates to:
  /// **'Professional iPad with M2 processor and Liquid Retina XDR display'**
  String get productIpadProM2Desc;

  /// Galaxy Tab S9 Ultra description
  ///
  /// In en, this message translates to:
  /// **'Samsung tablet with large screen and S Pen'**
  String get productGalaxyTabS9UltraDesc;

  /// Apple Watch Series 9 description
  ///
  /// In en, this message translates to:
  /// **'Apple smart watch with advanced health sensors'**
  String get productAppleWatchSeries9Desc;

  /// Galaxy Watch 6 description
  ///
  /// In en, this message translates to:
  /// **'Samsung smart watch with comprehensive health tracking'**
  String get productGalaxyWatch6Desc;

  /// AirPods Pro 2 description
  ///
  /// In en, this message translates to:
  /// **'Apple wireless earphones with active noise cancellation'**
  String get productAirPodsPro2Desc;

  /// Sony WH-1000XM5 description
  ///
  /// In en, this message translates to:
  /// **'Sony professional headphones with best noise cancellation'**
  String get productSonyWH1000XM5Desc;

  /// Success message when sample data is added
  ///
  /// In en, this message translates to:
  /// **'Sample data added successfully'**
  String get sampleDataAddedSuccess;

  /// Error message when adding sample data fails
  ///
  /// In en, this message translates to:
  /// **'Error adding sample data'**
  String get sampleDataAddError;

  /// Error message when fetching featured products fails
  ///
  /// In en, this message translates to:
  /// **'Error fetching featured products'**
  String get errorFetchingFeaturedProducts;

  /// Error message when fetching products by category fails
  ///
  /// In en, this message translates to:
  /// **'Error fetching category products'**
  String get errorFetchingCategoryProducts;

  /// Error message when search fails
  ///
  /// In en, this message translates to:
  /// **'Error searching'**
  String get errorSearching;

  /// Exception message when adding product fails
  ///
  /// In en, this message translates to:
  /// **'Failed to add product'**
  String get failedToAddProduct;

  /// Exception message when updating product fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update product'**
  String get failedToUpdateProduct;

  /// Exception message when deleting product fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete product'**
  String get failedToDeleteProduct;

  /// Exception message when deleting image fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete image'**
  String get failedToDeleteImage;

  /// Error message when updating product status fails
  ///
  /// In en, this message translates to:
  /// **'Error updating product status'**
  String get errorUpdatingProductStatus;

  /// Exception message when updating product status fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update product status'**
  String get failedToUpdateProductStatus;

  /// Error message when fetching single product fails
  ///
  /// In en, this message translates to:
  /// **'Error fetching product'**
  String get errorFetchingProduct;

  /// Success message for creating sample data
  ///
  /// In en, this message translates to:
  /// **'✅ Sample data created successfully'**
  String get sampleDataCreatedSuccess;

  /// Error message for creating sample data
  ///
  /// In en, this message translates to:
  /// **'❌ Error creating sample data'**
  String get errorCreatingSampleData;

  /// Generic unexpected error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// Error message for sign out failure
  ///
  /// In en, this message translates to:
  /// **'Failed to sign out'**
  String get signOutFailed;

  /// Error message for password reset failure
  ///
  /// In en, this message translates to:
  /// **'Failed to send password reset link'**
  String get passwordResetFailed;

  /// Debug message for user profile creation error
  ///
  /// In en, this message translates to:
  /// **'Error creating user profile'**
  String get errorCreatingUserProfile;

  /// Debug message for guest profile creation error
  ///
  /// In en, this message translates to:
  /// **'Error creating guest profile'**
  String get errorCreatingGuestProfile;

  /// Debug message for last login update error
  ///
  /// In en, this message translates to:
  /// **'Error updating last login'**
  String get errorUpdatingLastLogin;

  /// Debug message for user data fetch error
  ///
  /// In en, this message translates to:
  /// **'Error fetching user data'**
  String get errorFetchingUserData;

  /// Error message for data update failure
  ///
  /// In en, this message translates to:
  /// **'Failed to update data'**
  String get failedToUpdateData;

  /// Debug message for user stats fetch error
  ///
  /// In en, this message translates to:
  /// **'Error fetching user stats'**
  String get errorFetchingUserStats;

  /// Debug message for user stats update error
  ///
  /// In en, this message translates to:
  /// **'Error updating user stats'**
  String get errorUpdatingUserStats;

  /// Firebase auth error: email-already-in-use
  ///
  /// In en, this message translates to:
  /// **'Email is already in use'**
  String get emailAlreadyInUse;

  /// Firebase auth error: weak-password
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPassword;

  /// Firebase auth error: user-disabled
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get userDisabled;

  /// Firebase auth error: too-many-requests
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later'**
  String get tooManyRequests;

  /// Firebase auth error: operation-not-allowed
  ///
  /// In en, this message translates to:
  /// **'This operation is not allowed'**
  String get operationNotAllowed;

  /// Firebase auth error: invalid-credential
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredential;

  /// Firebase auth error: network-request-failed
  ///
  /// In en, this message translates to:
  /// **'Network connection failed'**
  String get networkRequestFailed;

  /// Firebase auth error: requires-recent-login
  ///
  /// In en, this message translates to:
  /// **'Requires recent login'**
  String get requiresRecentLogin;

  /// Generic authentication error message
  ///
  /// In en, this message translates to:
  /// **'Authentication error occurred'**
  String get authenticationError;

  /// Name for guest users
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestName;

  /// Generic authentication failure message
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticationFailed;

  /// Unexpected error during sign-in
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during sign-in'**
  String get unexpectedSignInError;

  /// Account creation failure message
  ///
  /// In en, this message translates to:
  /// **'Account creation failed'**
  String get accountCreationFailed;

  /// Unexpected error during account creation
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during account creation'**
  String get unexpectedSignUpError;

  /// Anonymous sign-in failure message
  ///
  /// In en, this message translates to:
  /// **'Anonymous sign-in failed'**
  String get anonymousSignInFailed;

  /// Unexpected error during anonymous sign-in
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during anonymous sign-in'**
  String get unexpectedAnonymousSignInError;

  /// Unexpected error during sign-out
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during sign-out'**
  String get unexpectedSignOutError;

  /// No description provided for @authGenericError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error occurred'**
  String get authGenericError;

  /// No description provided for @orderStatusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get orderStatusPreparing;

  /// No description provided for @couponTypePercentage.
  ///
  /// In en, this message translates to:
  /// **'{value}% discount'**
  String couponTypePercentage(int value);

  /// No description provided for @couponTypeFixed.
  ///
  /// In en, this message translates to:
  /// **'{value} pound discount'**
  String couponTypeFixed(String value);

  /// No description provided for @couponTypeFreeShipping.
  ///
  /// In en, this message translates to:
  /// **'Free shipping'**
  String get couponTypeFreeShipping;

  /// No description provided for @couponStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get couponStatusActive;

  /// No description provided for @couponStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get couponStatusExpired;

  /// No description provided for @couponStatusUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get couponStatusUsed;

  /// No description provided for @couponStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get couponStatusDisabled;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;

  /// No description provided for @validationNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be more than 2 characters'**
  String get validationNameTooShort;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get validationPhoneInvalid;

  /// No description provided for @validationStreetRequired.
  ///
  /// In en, this message translates to:
  /// **'Street address is required'**
  String get validationStreetRequired;

  /// No description provided for @validationStreetTooShort.
  ///
  /// In en, this message translates to:
  /// **'Street address must be more than 5 characters'**
  String get validationStreetTooShort;

  /// No description provided for @validationCityRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get validationCityRequired;

  /// No description provided for @validationCityTooShort.
  ///
  /// In en, this message translates to:
  /// **'City name must be more than 2 characters'**
  String get validationCityTooShort;

  /// No description provided for @validationStateRequired.
  ///
  /// In en, this message translates to:
  /// **'State is required'**
  String get validationStateRequired;

  /// No description provided for @validationPostalCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Postal code is required'**
  String get validationPostalCodeRequired;

  /// No description provided for @validationPostalCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Postal code must be 5 digits'**
  String get validationPostalCodeInvalid;

  /// No description provided for @validationCountryRequired.
  ///
  /// In en, this message translates to:
  /// **'Country is required'**
  String get validationCountryRequired;

  /// Error message when required fields are empty
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get fillAllRequiredFields;

  /// Error message when name fields are empty
  ///
  /// In en, this message translates to:
  /// **'Please enter first and last name'**
  String get enterFirstAndLastName;

  /// Error message when fetching products fails
  ///
  /// In en, this message translates to:
  /// **'Error fetching products'**
  String get errorFetchingProducts;

  /// Test label
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// Success message for app working
  ///
  /// In en, this message translates to:
  /// **'App is working successfully! 🎉'**
  String get appWorkingSuccessfully;

  /// Message indicating red screen freeze issue is fixed
  ///
  /// In en, this message translates to:
  /// **'Red screen freeze issue has been fixed'**
  String get redScreenFreezeFixed;

  /// Sales label
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// Title for empty wishlist
  ///
  /// In en, this message translates to:
  /// **'Wishlist is empty'**
  String get emptyWishlistTitle;

  /// Message for empty wishlist
  ///
  /// In en, this message translates to:
  /// **'Add products you like to access them easily later.'**
  String get emptyWishlistMessage;

  /// Button text to start shopping
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shopNow;

  /// Stock label for product inventory
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// Images label for product photos
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// Success message for image upload
  ///
  /// In en, this message translates to:
  /// **'Image uploaded successfully'**
  String get imageUploadSuccess;

  /// Error message for image upload failure
  ///
  /// In en, this message translates to:
  /// **'Image upload failed'**
  String get imageUploadFailed;

  /// Success message for saving changes
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get changesSavedSuccess;

  /// Option to set address as default
  ///
  /// In en, this message translates to:
  /// **'Set as default address'**
  String get setAsDefaultAddress;

  /// Success message for address update
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get addressUpdatedSuccessfully;

  /// Success message for address addition
  ///
  /// In en, this message translates to:
  /// **'Address added successfully'**
  String get addressAddedSuccessfully;

  /// Confirmation message for deleting an address
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the address for {name}?'**
  String confirmDeleteAddress(String name);

  /// Country name for Saudi Arabia
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get saudiArabia;

  /// Label for phone number field
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Label for street address field
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddress;

  /// Success message when address is set as default
  ///
  /// In en, this message translates to:
  /// **'Address set as default'**
  String get addressSetAsDefault;

  /// Label for product
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// Error message for image selection failure
  ///
  /// In en, this message translates to:
  /// **'Error selecting image'**
  String get imageSelectionError;

  /// Success message for image selection
  ///
  /// In en, this message translates to:
  /// **'Image selected successfully'**
  String get imageSelectedSuccess;

  /// Error message when image selection fails
  ///
  /// In en, this message translates to:
  /// **'Image selection failed'**
  String get imageSelectionFailed;

  /// Error message when saving changes fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes'**
  String get saveChangesFailed;

  /// Button text to change profile image
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// Button text to place an order
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// Success message when order is placed
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get orderPlacedSuccessfully;

  /// Error message when order placement fails
  ///
  /// In en, this message translates to:
  /// **'Error placing order. Please try again.'**
  String get errorPlacingOrder;

  /// Error message when no address is selected
  ///
  /// In en, this message translates to:
  /// **'Please select a delivery address'**
  String get noAddressSelected;

  /// Label for delivery address section
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// Button text to change something
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Button text to add profile image
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// Label for optional middle name field
  ///
  /// In en, this message translates to:
  /// **'Middle Name (Optional)'**
  String get middleNameOptional;

  /// Error message when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// Status message for services that are connected when app is running
  ///
  /// In en, this message translates to:
  /// **'Connected (if app running)'**
  String get connectedIfAppRunning;

  /// Status text for services that are connected if configured
  ///
  /// In en, this message translates to:
  /// **'Connected (if configured)'**
  String get connectedIfConfigured;

  /// Error message when user data fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load user data'**
  String get failedToLoadUserData;

  /// Message shown when privacy and security settings are not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Privacy and security settings are under development'**
  String get privacyAndSecuritySettingsUnderDevelopment;

  /// General app label
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get app;

  /// Message shown when notification management is not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Notification management is under development'**
  String get notificationManagementUnderDevelopment;

  /// Message shown when help and support is not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Help and support is under development'**
  String get helpAndSupportUnderDevelopment;

  /// Message shown when address management is not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Address Management Under Development'**
  String get addressManagementUnderDevelopment;

  /// Error message when data update fails
  ///
  /// In en, this message translates to:
  /// **'Data update failed'**
  String get dataUpdateFailed;

  /// Message for checkout page under development
  ///
  /// In en, this message translates to:
  /// **'Checkout page coming soon!'**
  String get checkoutPageComingSoon;

  /// Error message when adding item to cart fails
  ///
  /// In en, this message translates to:
  /// **'Error adding to cart: {error}'**
  String errorAddingToCart(String error);

  /// Confirmation message for logout
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmationMessage;

  /// Message asking user to login before adding to favorites
  ///
  /// In en, this message translates to:
  /// **'Please login first to add products to favorites'**
  String get pleaseLoginFirst;
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
      'that was used.');
}
