import 'dart:io';

import 'package:cardea/ui/loyalty-card/loyalty-card.viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/loyalty-card.repository.dart';
import '../../data/repositories/shopping-item.repository.dart';
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

  Future<void> _exportData(BuildContext context) async {
    try {
      final useCase = ImportExportJsonUseCase(
        loyaltyCardRepository: _getLoyaltyCardViewModel(context).repository,
        shoppingItemRepository: _getShoppingItemViewModel(context).repository,
      );
      final json = await useCase.exportDataToJson();

      final directory = await getDownloadsDirectory();
      print(directory);
      final timestamp = DateTime.now().toIso8601String();
      final filename = 'cardea_export_$timestamp.json';
      final file = File('${directory?.path}/$filename');
      await file.writeAsString(json);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Data exported to $filename')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
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
        final loyaltyCardRepository = context.read<LoyaltyCardRepository>();
        final shoppingItemRepository = context.read<ShoppingItemRepository>();
        final useCase = ImportExportJsonUseCase(
          loyaltyCardRepository: loyaltyCardRepository,
          shoppingItemRepository: shoppingItemRepository,
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
            title: const Text('Export Data to JSON'),
            onTap: () => _exportData(context),
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Import Data from JSON'),
            onTap: () => _importData(context),
          ),
        ],
      ),
    );
  }
}
