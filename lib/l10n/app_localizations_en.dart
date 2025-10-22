// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get confirmBtnLabel => 'Confirm';

  @override
  String get cancelBtnLabel => 'Cancel';

  @override
  String get deleteBtnLabel => 'Delete';

  @override
  String get editBtnLabel => 'Edit';

  @override
  String get saveBtnLabel => 'Save';

  @override
  String get addBtnLabel => 'Add';

  @override
  String get copyToClipboardBtnLabel => 'Add';

  @override
  String get copiedToClipboardLabel => 'Copied to clipboard';

  @override
  String get loyaltyCardsLabel => 'Loyalty Cards';

  @override
  String get shoppingListLabel => 'Shopping List';

  @override
  String get bottomNavLoyaltyCards => 'Cards';

  @override
  String get bottomNavShoppingList => 'Shopping';

  @override
  String get welcomeMsgTitle => 'Welcome to Cardea!';

  @override
  String get welcomeMsgBody =>
      'This app is still under development, so please be aware of potential bugs and missing features.';

  @override
  String get welcomeMsgHint =>
      'Hint: you can import/export your data in the settings page for backup or transfer to another device.';

  @override
  String get welcomeMsgButton => 'Got it!';

  @override
  String get loyaltyCardSectionTitle => 'Your Cards';

  @override
  String get loyaltyCardNewBtn => 'New Card';

  @override
  String get loyaltyCardEmptyLabel => 'Mmmh... nothing here yet!';

  @override
  String get loyaltyCardEmptyBtn =>
      'Tap the + button below to add your first Card.';

  @override
  String get loyaltyCardSortBy => 'Sort by';

  @override
  String get loyaltyCardSortByName => 'Name';

  @override
  String get loyaltyCardSortByUsage => 'Usage';

  @override
  String get loyaltyCardSearchLabel => 'Find a Card';

  @override
  String loyaltyCardEmptySearchResult(String searchTerm) {
    return 'No results found for $searchTerm.';
  }

  @override
  String get loyaltyCardManagerScanLabel => 'Scan your card';

  @override
  String get loyaltyCardManagerScanManually => 'Enter code manually';

  @override
  String get loyaltyCardManagerTitleNew => 'Add New Card';

  @override
  String get loyaltyCardManagerTitleEdit => 'Edit Card';

  @override
  String get loyaltyCardManagerColorLabel => 'Pick a color';

  @override
  String get loyaltyCardManagerNameLabel => 'Card Name';

  @override
  String get loyaltyCardManagerMissingName =>
      'Please provide a name for the card.';

  @override
  String get settingsSectionTitle => 'Settings';

  @override
  String get settingsImportExportBtn => 'Import/Export Data';

  @override
  String get settingsDarkTheme => 'Dark Theme';

  @override
  String get settingsExportLabel => 'Export';

  @override
  String get settingsExportBtn => 'Export Data';

  @override
  String get settingsExportInProgress => 'Exporting...';

  @override
  String get settingsExportSuccess => 'Data exported successfully!';

  @override
  String get settingsExportError => 'Failed to export data. Please try again.';

  @override
  String get settingsImportLabel => 'Import';

  @override
  String get settingsImportBtn => 'Select file';

  @override
  String get settingsImportInProgress => 'Importing...';

  @override
  String get settingsImportSuccess => 'Data imported successfully!';

  @override
  String get settingsImportError =>
      'Failed to import data. Please ensure the file is valid.';

  @override
  String get shoppingListSectionTitle => 'Shopping List';

  @override
  String get shoppingListNewItemBtn => 'New Item';

  @override
  String get shoppingListEmptyLabel => 'Your shopping list is empty!';

  @override
  String get shoppingListInputHint => 'What do you need to buy?';
}
