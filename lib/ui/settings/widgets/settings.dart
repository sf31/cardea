import 'dart:io';

import 'package:cardea/ui/settings/settings.viewmodel.dart';
import 'package:cardea/ui/settings/widgets/export_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme_provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  SettingsViewModel _getViewModel(BuildContext context) {
    return Provider.of<SettingsViewModel>(context, listen: false);
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
        await _getViewModel(context).importJson(json);
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
            leading: const Icon(Icons.brightness_6),
            title: const Text('Dark Mode'),
            trailing: Consumer<ThemeProvider>(
              builder:
                  (context, themeProvider, _) => Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: const Text('Export Cards'),
            onTap:
                () => {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (BuildContext context) {
                      return const ExportData();
                    },
                  ),
                },
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
