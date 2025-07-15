import 'dart:io';

import 'package:cardea/ui/loyalty-card/loyalty-card.viewmodel.dart';
import 'package:cardea/ui/settings/export-data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/import_export_json_usecase.dart';
import '../shopping-list/shopping-item.viewmodel.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  ShoppingItemViewModel _getShoppingItemViewModel(BuildContext context) {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  LoyaltyCardViewModel _getLoyaltyCardViewModel(BuildContext context) {
    return Provider.of<LoyaltyCardViewModel>(context, listen: false);
  }

  Future<void> _importData(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final json = await file.readAsString();
        final useCase = ImportExportJsonUseCase(
          loyaltyCardViewModel: _getLoyaltyCardViewModel(context),
          shoppingItemViewModel: _getShoppingItemViewModel(context),
        );
        await useCase.importDataFromJson(json);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data imported successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Import failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: const Text('Export Cards'),
            onTap:
                () => {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    backgroundColor: Colors.white,
                    builder: (BuildContext context) {
                      return const ExportData();
                      // return SizedBox(
                      //   height: 100,
                      //   child: BarcodeWidget(
                      //     data: 'AA',
                      //     barcode: Barcode.qrCode(),
                      //   ),
                      // );
                    },
                  ),
                },
            // onTap: () => _exportData(context),
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Import Cards'),
            onTap: () => _importData(context),
          ),
        ],
      ),
    );
  }
}
