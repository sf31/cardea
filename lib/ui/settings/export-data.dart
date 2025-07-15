import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cardea/ui/loyalty-card/loyalty-card.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../data/services/import_export_json_usecase.dart';
import '../shopping-list/shopping-item.viewmodel.dart';

class ExportData extends StatelessWidget {
  const ExportData({super.key});

  ShoppingItemViewModel _getShoppingItemViewModel(BuildContext context) {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  LoyaltyCardViewModel _getLoyaltyCardViewModel(BuildContext context) {
    return Provider.of<LoyaltyCardViewModel>(context, listen: false);
  }

  Future toJson(BuildContext context) async {
    try {
      final useCase = ImportExportJsonUseCase(
        loyaltyCardViewModel: _getLoyaltyCardViewModel(context),
        shoppingItemViewModel: _getShoppingItemViewModel(context),
      );
      final json = await useCase.exportDataToJson();
      return json;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future saveJsonToFile(BuildContext context, String json) async {
    try {
      final directory = await getDownloadsDirectory();
      final timestamp = DateTime.now().toIso8601String();
      final filename = 'cardea_export_$timestamp.json';
      final file = File('${directory?.path}/$filename');
      await file.writeAsString(json);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Data exported to $filename')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: toJson(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data to export'));
        }

        final json = snapshot.data!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height / 2.5,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: json,
                width: double.infinity,
                height: double.infinity,
                backgroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () => saveJsonToFile(context, json),
              child: const Text('Save to File'),
            ),
          ],
        );
      },
    );
  }
}
