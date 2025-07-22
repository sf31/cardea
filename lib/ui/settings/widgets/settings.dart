import 'package:cardea/ui/settings/widgets/import_export_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme_provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
            title: const Text('Import/Export Data'),
            onTap:
                () => {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (BuildContext context) {
                      return const ImportExportData();
                    },
                  ),
                },
          ),
        ],
      ),
    );
  }
}
