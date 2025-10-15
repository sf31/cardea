// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get confirmBtnLabel => 'Conferma';

  @override
  String get cancelBtnLabel => 'Annulla';

  @override
  String get deleteBtnLabel => 'Elimina';

  @override
  String get editBtnLabel => 'Modifica';

  @override
  String get saveBtnLabel => 'Aggiungi';

  @override
  String get loyaltyCardsLabel => 'Carte Fedeltà';

  @override
  String get shoppingListLabel => 'Lista della Spesa';

  @override
  String get bottomNavLoyaltyCards => 'Carte';

  @override
  String get bottomNavShoppingList => 'Lista';

  @override
  String get welcomeMsgTitle => 'Benvenutə in Cardea!';

  @override
  String get welcomeMsgBody =>
      'L\'app è ancora in fase di sviluppo, quindi tieni presente che potrebbero esserci bug e funzionalità mancanti.';

  @override
  String get welcomeMsgHint =>
      'Suggerimento: puoi importare/esportare i tuoi dati nella pagina delle impostazioni per backup o trasferimento a un altro dispositivo.';

  @override
  String get welcomeMsgButton => 'Capito!';

  @override
  String get loyaltyCardSectionTitle => 'Le tue carte';

  @override
  String get loyaltyCardNewBtn => 'Aggiungi carta';

  @override
  String get loyaltyCardEmptyLabel => 'Mmmh... niente qui per ora!';

  @override
  String get loyaltyCardEmptyBtn =>
      'Tocca il pulsante + qui sotto per aggiungere la tua prima carta.';

  @override
  String get loyaltyCardSortBy => 'Ordina per';

  @override
  String get loyaltyCardSearchLabel => 'Cerca';

  @override
  String loyaltyCardEmptySearchResult(String searchTerm) {
    return 'Nessun risultato trovato per $searchTerm.';
  }

  @override
  String get loyaltyCardManagerScanLabel => 'Scansiona la tua carta';

  @override
  String get loyaltyCardManagerScanManually =>
      'Inserisci il codice manualmente';

  @override
  String get loyaltyCardManagerTitleNew => 'Aggiungi nuova carta';

  @override
  String get loyaltyCardManagerTitleEdit => 'Modifica carta';

  @override
  String get loyaltyCardManagerColorLabel => 'Scegli un colore';

  @override
  String get loyaltyCardManagerNameLabel => 'Nome della carta';

  @override
  String get loyaltyCardManagerMissingName => 'Fornisci un nome per la carta';

  @override
  String get settingsSectionTitle => 'Impostazioni';

  @override
  String get settingsImportExportBtn => 'Importa/Esporta Dati';

  @override
  String get settingsDarkTheme => 'Tema Scuro';

  @override
  String get settingsExportLabel => 'Esporta';

  @override
  String get settingsExportBtn => 'Esporta Dati';

  @override
  String get settingsExportInProgress => 'Esportazione in corso...';

  @override
  String get settingsExportSuccess => 'Dati esportati con successo!';

  @override
  String get settingsExportError =>
      'Esportazione dei dati non riuscita. Per favore riprova.';

  @override
  String get settingsImportLabel => 'Importa';

  @override
  String get settingsImportBtn => 'Seleziona file';

  @override
  String get settingsImportInProgress => 'Importazione in corso...';

  @override
  String get settingsImportSuccess => 'Dati importati con successo!';

  @override
  String get settingsImportError =>
      'Importazione dei dati non riuscita. Assicurati che il file sia valido.';

  @override
  String get shoppingListSectionTitle => 'Lista della Spesa';

  @override
  String get shoppingListNewItemBtn => 'Aggiungi';

  @override
  String get shoppingListEmptyLabel => 'La tua lista della spesa è vuota!';

  @override
  String get shoppingListInputHint => 'Cosa devi comprare?';
}
