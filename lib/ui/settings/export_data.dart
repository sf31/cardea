import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/import_export_json_usecase.dart';
import '../loyalty-card/loyalty_card.viewmodel.dart';
import '../shopping-list/shopping_item.viewmodel.dart';

class ExportData extends StatefulWidget {
  const ExportData({super.key});

  @override
  State<ExportData> createState() => _ExportDataState();
}

class _ExportDataState extends State<ExportData> {
  bool exportCard = true;
  bool exportShoppingList = true;
  bool isExporting = false;
  bool? exportSuccess = false;
  String? errorMessage;

  ShoppingItemViewModel _getShoppingItemViewModel(BuildContext context) {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  LoyaltyCardViewModel _getLoyaltyCardViewModel(BuildContext context) {
    return Provider.of<LoyaltyCardViewModel>(context, listen: false);
  }

  Future saveJsonToFile(BuildContext context) async {
    try {
      setState(() {
        errorMessage = null;
        isExporting = true;
      });
      final useCase = ImportExportJsonUseCase(
        loyaltyCardViewModel: _getLoyaltyCardViewModel(context),
        shoppingItemViewModel: _getShoppingItemViewModel(context),
      );
      final json = await useCase.exportDataToJson(
        exportCard,
        exportShoppingList,
      );
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
          errorMessage = 'Export cancelled by user.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Export failed: $e';
        isExporting = false;
        exportSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Export Data', style: TextStyle(fontSize: 20)),
        ),
        Row(
          children: [
            Checkbox(
              value: exportCard,
              onChanged: (value) {
                setState(() {
                  exportCard = value ?? true;
                });
              },
            ),
            const Text('Loyalty Cards'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: exportShoppingList,
              onChanged: (value) {
                setState(() {
                  exportShoppingList = value ?? true;
                });
              },
            ),
            const Text('Shopping List'),
          ],
        ),
        if (isExporting)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(onPressed: null, child: Text('Exporting...')),
          )
        else if (exportSuccess == true)
          Padding(
            padding: const EdgeInsets.all(26),
            child: Text(
              textAlign: TextAlign.center,
              'Export completed successfully!',
              style: TextStyle(color: Colors.green),
            ),
          )
        else if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
          )
        else
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => saveJsonToFile(context),
              child: const Text('Export'),
            ),
          ),
      ],
    );
  }
}
