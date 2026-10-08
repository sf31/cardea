import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Tells the user a local change could not be saved.
void showPersistenceError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(AppLocalizations.of(context)?.persistenceSaveError ?? ''),
    ),
  );
}

/// Asks the user to confirm an action; resolves to `true` only on confirm.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)?.cancelBtnLabel ?? ''),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        ),
  );
  return confirmed == true;
}
