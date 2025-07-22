import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/loyalty_card.model.dart';
import '../../../data/models/shopping_item.model.dart';
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
  bool? exportSuccess = false;
  String? exportErrorMessage;

  bool isImporting = false;
  bool? importSuccess = false;
  String? importErrorMessage;

  Future saveJsonToFile(BuildContext context) async {
    try {
      setState(() {
        exportErrorMessage = null;
        isExporting = true;
      });

      final loyaltyCardVm = Provider.of<LoyaltyCardViewModel>(
        context,
        listen: false,
      );

      final shoppingItemVm = Provider.of<ShoppingItemViewModel>(
        context,
        listen: false,
      );

      final loyaltyCardList = loyaltyCardVm.cardList;
      final shoppingList = shoppingItemVm.itemList;

      final json = jsonEncode({
        'loyaltyCards':
            exportCardList
                ? loyaltyCardList.map((card) => card.toMap()).toList()
                : [],
        'shoppingItems':
            exportShoppingList
                ? shoppingList.map((item) => item.toMap()).toList()
                : [],
      });
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
      await Future.delayed(const Duration(milliseconds: 500));
      if (savePath != null) {
        setState(() {
          isExporting = false;
          exportSuccess = true;
        });
      } else {
        setState(() {
          isExporting = false;
          exportSuccess = false;
          exportErrorMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        exportErrorMessage = 'Export failed: $e';
        isExporting = false;
        exportSuccess = false;
      });
    }
  }

  Future<void> importFromJson() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      final cardVm = Provider.of<LoyaltyCardViewModel>(context, listen: false);
      final shoppingVm = Provider.of<ShoppingItemViewModel>(
        context,
        listen: false,
      );

      setState(() {
        isImporting = true;
        importErrorMessage = null;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final json = await file.readAsString();
        final data = jsonDecode(json);
        final loyaltyCardsRaw = data['loyaltyCards'] ?? [];
        final shoppingItemsRaw = data['shoppingItems'] ?? [];

        final List<LoyaltyCard> loyaltyCards = [];
        final List<ShoppingItem> shoppingItems = [];

        for (var card in loyaltyCardsRaw) {
          loyaltyCards.add(LoyaltyCard.fromMap(card));
        }

        for (var item in shoppingItemsRaw) {
          shoppingItems.add(ShoppingItem.fromMap(item));
        }

        await cardVm.setAll(loyaltyCards);
        await shoppingVm.setAll(shoppingItems);

        setState(() {
          isImporting = false;
          importSuccess = true;
        });
      } else {
        setState(() {
          isImporting = false;
        });
      }
    } catch (e) {
      setState(() {
        isImporting = false;
        importSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(tabs: [Tab(text: 'Export'), Tab(text: 'Import')]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      CheckboxListTile(
                        value: exportCardList,
                        title: const Text('Loyalty Cards'),
                        onChanged: (value) {
                          setState(() {
                            exportCardList = !exportCardList;
                          });
                        },
                      ),
                      CheckboxListTile(
                        value: exportShoppingList,
                        title: const Text('Shopping List'),
                        onChanged: (value) {
                          setState(() {
                            exportShoppingList = !exportShoppingList;
                          });
                        },
                      ),
                      Column(
                        spacing: 20,
                        children: [
                          ElevatedButton(
                            onPressed:
                                isExporting
                                    ? null
                                    : () => saveJsonToFile(context),
                            child:
                                isExporting
                                    ? const Text('Exporting...')
                                    : const Text('Export'),
                          ),
                          if (exportSuccess == true)
                            Text(
                              textAlign: TextAlign.center,
                              'Export completed successfully!',
                              style: TextStyle(color: Colors.green),
                            ),
                          if (exportErrorMessage != null)
                            Text(
                              exportErrorMessage ?? '',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    spacing: 20,
                    children: [
                      ElevatedButton(
                        onPressed: isImporting ? null : importFromJson,
                        child:
                            isImporting
                                ? const Text('Importing...')
                                : const Text('Import'),
                      ),
                      if (importErrorMessage != null)
                        Text(
                          importErrorMessage ?? '',
                          style: const TextStyle(color: Colors.red),
                        ),
                      if (importSuccess == true)
                        const Text(
                          'Import completed successfully!',
                          style: TextStyle(color: Colors.green),
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
