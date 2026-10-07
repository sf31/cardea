import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty-card-manager/loyalty_card_manager.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

class LoyaltyCardScanner extends StatefulWidget {
  const LoyaltyCardScanner({super.key});

  @override
  State<LoyaltyCardScanner> createState() => _LoyaltyCardScannerState();
}

class _LoyaltyCardScannerState extends State<LoyaltyCardScanner> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isNavigating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (_isNavigating) return;
    Barcode? barcode = barcodes.barcodes.firstOrNull;
    String? value = barcode?.rawValue ?? barcode?.displayValue;

    if (value == null) return;

    _openCardManager(
      barcode: value,
      barcodeFormat: barcode?.format ?? BarcodeFormat.unknown,
    );
  }

  void _manualAdd() {
    _openCardManager(barcode: '', barcodeFormat: BarcodeFormat.code128);
  }

  void _openCardManager({
    required String barcode,
    required BarcodeFormat barcodeFormat,
  }) {
    if (_isNavigating) return;
    _isNavigating = true;

    final card = LoyaltyCard(
      id: const Uuid().v4(),
      name: '',
      barcode: barcode,
      barcodeFormat: barcodeFormat,
      color: Colors.blue,
      usageCount: 0,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoyaltyCardManager(card: card, isNewCard: true),
      ),
    );
  }

  /// The camera area: only barcodes inside the frame are read.
  Widget _camera(AppLocalizations? l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final width = (size.width - 48).clamp(0.0, 340.0);
        // Same proportions as a payment card.
        final scanWindow = Rect.fromCenter(
          center: size.center(Offset.zero),
          width: width,
          height: width / 1.586,
        );
        return Stack(
          children: [
            MobileScanner(
              controller: _controller,
              scanWindow: scanWindow,
              onDetect: _handleBarcode,
            ),
            IgnorePointer(
              child: ScanWindowOverlay(
                controller: _controller,
                scanWindow: scanWindow,
                borderColor: Colors.white,
                borderWidth: 3,
                borderRadius: BorderRadius.circular(16),
                color: Colors.black54,
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              top: scanWindow.bottom + 24,
              child: Text(
                l10n?.loyaltyCardManagerScanLabel ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _flashlightButton(AppLocalizations? l10n) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, state, child) {
        if (!state.isInitialized ||
            !state.isRunning ||
            state.torchState == TorchState.unavailable) {
          return const SizedBox.shrink();
        }
        final isOn = state.torchState == TorchState.on;
        return IconButton(
          tooltip: l10n?.loyaltyCardManagerFlashlight,
          isSelected: isOn,
          onPressed: _controller.toggleTorch,
          icon: Icon(isOn ? Icons.flash_on : Icons.flash_off),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const CloseButton(),
        title: Text(l10n?.loyaltyCardManagerTitleNew ?? ''),
        actions: [_flashlightButton(l10n)],
      ),
      body: Column(
        children: [
          Expanded(child: _camera(l10n)),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Text(
                    l10n?.loyaltyCardManagerScanManuallyHint ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _manualAdd,
                      icon: const Icon(Icons.keyboard),
                      label: Text(l10n?.loyaltyCardManagerScanManually ?? ''),
                    ),
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
