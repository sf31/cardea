import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardea/ui/shared/feedback.dart';

import '../../../data/models/backup_data.model.dart';
import '../../../data/services/database.service.dart';
import '../../../l10n/app_localizations.dart';
import '../../loyalty-card/loyalty_card.viewmodel.dart';
import '../../shopping-list/shopping_item.viewmodel.dart';

class ImportExportData extends StatefulWidget {
  const ImportExportData({super.key});

  @override
  State<ImportExportData> createState() => _ImportExportDataState();
}

class _ImportExportDataState extends State<ImportExportData> {
  bool exportCardList = true;
  bool exportShoppingList = true;
  bool isExporting = false;
  bool exportSuccess = false;
  bool exportFailed = false;

  bool isImporting = false;
  bool importSuccess = false;
  bool importFailed = false;

  bool get _isBusy => isExporting || isImporting;

  Future<void> saveJsonToFile() async {
    final loyaltyCardVm = Provider.of<LoyaltyCardViewModel>(
      context,
      listen: false,
    );
    final shoppingItemVm = Provider.of<ShoppingItemViewModel>(
      context,
      listen: false,
    );
    if (_isBusy || !loyaltyCardVm.isReady || !shoppingItemVm.isReady) return;

    try {
      setState(() {
        exportFailed = false;
        exportSuccess = false;
        isExporting = true;
      });

      final loyaltyCardList = loyaltyCardVm.cardList;
      final shoppingList = shoppingItemVm.allItems;

      final json =
          BackupData(
            loyaltyCards: exportCardList ? loyaltyCardList.toList() : null,
            shoppingItems: exportShoppingList ? shoppingList.toList() : null,
          ).toJson();
      final timestamp = DateTime.now().toIso8601String();
      final filename = 'cardea_export_$timestamp.json';
      final jsonBytes = utf8.encode(json);
      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save export file',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: jsonBytes,
      );
      if (!mounted) return;

      // A null path means the user cancelled the save dialog.
      setState(() {
        isExporting = false;
        exportSuccess = savePath != null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        exportFailed = true;
        isExporting = false;
        exportSuccess = false;
      });
    }
  }

  Future<void> importFromJson() async {
    final l10n = AppLocalizations.of(context);
    final cardVm = Provider.of<LoyaltyCardViewModel>(context, listen: false);
    final shoppingVm = Provider.of<ShoppingItemViewModel>(
      context,
      listen: false,
    );
    if (_isBusy || !cardVm.isReady || !shoppingVm.isReady) return;

    try {
      setState(() {
        isImporting = true;
        importFailed = false;
        importSuccess = false;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (!mounted) return;

      if (result == null || result.files.single.path == null) {
        setState(() => isImporting = false);
        return;
      }

      final confirmed = await confirmAction(
        context,
        title: l10n?.settingsImportConfirmTitle ?? '',
        body: l10n?.settingsImportConfirmBody ?? '',
        confirmLabel: l10n?.settingsImportConfirmAction ?? '',
      );
      if (!mounted) return;
      if (!confirmed) {
        setState(() => isImporting = false);
        return;
      }

      final file = File(result.files.single.path!);
      final json = await file.readAsString();
      final backup = BackupData.fromJson(json);
      if (!mounted) return;

      await DatabaseService().database.transaction((transaction) async {
        if (backup.loyaltyCards != null) {
          await cardVm.repository.setAll(
            backup.loyaltyCards!,
            executor: transaction,
          );
        }
        if (backup.shoppingItems != null) {
          await shoppingVm.repository.setAll(
            backup.shoppingItems!,
            executor: transaction,
          );
        }
      });
      if (backup.loyaltyCards != null) {
        if (!await cardVm.loadCards()) {
          throw StateError('Unable to reload loyalty cards after import.');
        }
      }
      if (backup.shoppingItems != null) {
        if (!await shoppingVm.loadItems()) {
          throw StateError('Unable to reload shopping items after import.');
        }
      }
      if (!mounted) return;

      setState(() {
        isImporting = false;
        importSuccess = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isImporting = false;
        importSuccess = false;
        importFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardVm = context.watch<LoyaltyCardViewModel>();
    final shoppingVm = context.watch<ShoppingItemViewModel>();
    final dataReady = cardVm.isReady && shoppingVm.isReady;
    final loadFailed = cardVm.loadFailed || shoppingVm.loadFailed;
    final canOperate = dataReady && !_isBusy;
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: l10n?.settingsExportLabel ?? ''),
              Tab(text: l10n?.settingsImportLabel ?? ''),
            ],
          ),
          if (!dataReady)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                loadFailed
                    ? l10n?.dataLoadError ?? ''
                    : l10n?.dataLoadingLabel ?? '',
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      CheckboxListTile(
                        value: exportCardList,
                        title: Text(l10n?.loyaltyCardsLabel ?? ''),
                        onChanged:
                            canOperate
                                ? (value) {
                                  setState(() {
                                    exportCardList = value ?? false;
                                  });
                                }
                                : null,
                      ),
                      CheckboxListTile(
                        value: exportShoppingList,
                        title: Text(l10n?.shoppingListLabel ?? ''),
                        onChanged:
                            canOperate
                                ? (value) {
                                  setState(() {
                                    exportShoppingList = value ?? false;
                                  });
                                }
                                : null,
                      ),
                      Column(
                        spacing: 20,
                        children: [
                          FilledButton(
                            onPressed: canOperate ? saveJsonToFile : null,
                            child:
                                isExporting
                                    ? Text(l10n?.settingsExportInProgress ?? '')
                                    : Text(l10n?.settingsExportBtn ?? ''),
                          ),
                          if (exportSuccess)
                            Text(
                              textAlign: TextAlign.center,
                              l10n?.settingsExportSuccess ?? '',
                              style: TextStyle(color: colorScheme.primary),
                            ),
                          if (exportFailed)
                            Text(
                              l10n?.settingsExportError ?? '',
                              style: TextStyle(color: colorScheme.error),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    spacing: 20,
                    children: [
                      FilledButton(
                        onPressed: canOperate ? importFromJson : null,
                        child:
                            isImporting
                                ? Text(l10n?.settingsImportInProgress ?? '')
                                : Text(l10n?.settingsImportBtn ?? ''),
                      ),
                      if (importFailed)
                        Text(
                          l10n?.settingsImportError ?? '',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      if (importSuccess)
                        Text(
                          l10n?.settingsImportSuccess ?? '',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
