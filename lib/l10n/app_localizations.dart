import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

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
    Locale('en'),
    Locale('it'),
  ];

  /// Label for confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmBtnLabel;

  /// Label for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBtnLabel;

  /// Label for delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteBtnLabel;

  /// Label for edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editBtnLabel;

  /// Label for save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveBtnLabel;

  /// Label for loyalty cards
  ///
  /// In en, this message translates to:
  /// **'Loyalty Cards'**
  String get loyaltyCardsLabel;

  /// Label for shopping list
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingListLabel;

  /// Label for the loyalty cards tab in the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get bottomNavLoyaltyCards;

  /// Label for the shopping list tab in the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get bottomNavShoppingList;

  /// Title for the welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cardea!'**
  String get welcomeMsgTitle;

  /// Body text for the welcome message
  ///
  /// In en, this message translates to:
  /// **'This app is still under development, so please be aware of potential bugs and missing features.'**
  String get welcomeMsgBody;

  /// Hint text for the welcome message
  ///
  /// In en, this message translates to:
  /// **'Hint: you can import/export your data in the settings page for backup or transfer to another device.'**
  String get welcomeMsgHint;

  /// Button text to dismiss the welcome message
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get welcomeMsgButton;

  /// Title for the loyalty cards section
  ///
  /// In en, this message translates to:
  /// **'Your Cards'**
  String get loyaltyCardSectionTitle;

  /// Button text to add a new loyalty card
  ///
  /// In en, this message translates to:
  /// **'New Card'**
  String get loyaltyCardNewBtn;

  /// Text displayed when there are no loyalty cards
  ///
  /// In en, this message translates to:
  /// **'Mmmh... nothing here yet!'**
  String get loyaltyCardEmptyLabel;

  /// Instruction text to add the first loyalty card
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first Card.'**
  String get loyaltyCardEmptyBtn;

  /// Label for sorting options
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get loyaltyCardSortBy;

  /// Label for the search bar to find a loyalty card
  ///
  /// In en, this message translates to:
  /// **'Find a Card'**
  String get loyaltyCardSearchLabel;

  /// Text displayed when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No results found for {searchTerm}.'**
  String loyaltyCardEmptySearchResult(String searchTerm);

  /// Label for the scan card button in the loyalty card manager
  ///
  /// In en, this message translates to:
  /// **'Scan your card'**
  String get loyaltyCardManagerScanLabel;

  /// Label for the manual code entry option in the loyalty card manager
  ///
  /// In en, this message translates to:
  /// **'Enter code manually'**
  String get loyaltyCardManagerScanManually;

  /// Title for the loyalty card manager when adding a new card
  ///
  /// In en, this message translates to:
  /// **'Add New Card'**
  String get loyaltyCardManagerTitleNew;

  /// Title for the loyalty card manager when editing an existing card
  ///
  /// In en, this message translates to:
  /// **'Edit Card'**
  String get loyaltyCardManagerTitleEdit;

  /// Label for the color picker in the loyalty card manager
  ///
  /// In en, this message translates to:
  /// **'Pick a color'**
  String get loyaltyCardManagerColorLabel;

  /// Label for the card name input field in the loyalty card manager
  ///
  /// In en, this message translates to:
  /// **'Card Name'**
  String get loyaltyCardManagerNameLabel;

  /// Error message when the card name is missing
  ///
  /// In en, this message translates to:
  /// **'Please provide a name for the card.'**
  String get loyaltyCardManagerMissingName;

  /// Title for the settings section
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSectionTitle;

  /// Button text for the import/export data option in settings
  ///
  /// In en, this message translates to:
  /// **'Import/Export Data'**
  String get settingsImportExportBtn;

  /// Button text for the theme option in settings
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get settingsDarkTheme;

  /// No description provided for @settingsExportLabel.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get settingsExportLabel;

  /// No description provided for @settingsExportBtn.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingsExportBtn;

  /// No description provided for @settingsExportInProgress.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get settingsExportInProgress;

  /// No description provided for @settingsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully!'**
  String get settingsExportSuccess;

  /// No description provided for @settingsExportError.
  ///
  /// In en, this message translates to:
  /// **'Failed to export data. Please try again.'**
  String get settingsExportError;

  /// No description provided for @settingsImportLabel.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get settingsImportLabel;

  /// No description provided for @settingsImportBtn.
  ///
  /// In en, this message translates to:
  /// **'Select file'**
  String get settingsImportBtn;

  /// No description provided for @settingsImportInProgress.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get settingsImportInProgress;

  /// No description provided for @settingsImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully!'**
  String get settingsImportSuccess;

  /// No description provided for @settingsImportError.
  ///
  /// In en, this message translates to:
  /// **'Failed to import data. Please ensure the file is valid.'**
  String get settingsImportError;

  /// Title for the shopping list section
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingListSectionTitle;

  /// Button text to add a new item to the shopping list
  ///
  /// In en, this message translates to:
  /// **'New Item'**
  String get shoppingListNewItemBtn;

  /// Text displayed when the shopping list is empty
  ///
  /// In en, this message translates to:
  /// **'Your shopping list is empty!'**
  String get shoppingListEmptyLabel;

  /// Hint text for the shopping list input field
  ///
  /// In en, this message translates to:
  /// **'What do you need to buy?'**
  String get shoppingListInputHint;
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
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
