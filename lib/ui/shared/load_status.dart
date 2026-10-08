import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Shown while local data is loading, or with a retry button if it failed.
class LoadStatus extends StatelessWidget {
  final bool failed;
  final VoidCallback onRetry;

  const LoadStatus({super.key, required this.failed, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children:
              failed
                  ? [
                    Text(
                      l10n?.dataLoadError ?? '',
                      textAlign: TextAlign.center,
                    ),
                    FilledButton(
                      onPressed: onRetry,
                      child: Text(l10n?.retryBtnLabel ?? ''),
                    ),
                  ]
                  : [
                    const CircularProgressIndicator(),
                    Text(l10n?.dataLoadingLabel ?? ''),
                  ],
        ),
      ),
    );
  }
}
