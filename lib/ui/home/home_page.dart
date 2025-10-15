import 'package:cardea/data/services/shared_prefs.service.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_home.dart';
import 'package:cardea/ui/shopping-list/widgets/shopping_list.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _prefsService.earlyAccessAlertShown()) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)?.welcomeMsgTitle ?? ''),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)?.welcomeMsgBody ?? ''),
                  SizedBox(height: 16),
                  Text(AppLocalizations.of(context)?.welcomeMsgHint ?? ''),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _prefsService.setEarlyAccessAlertShown();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)?.welcomeMsgButton ?? '',
                  ),
                ),
              ],
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: <Widget>[LoyaltyCardHome(), ShoppingList()][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.green,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.wallet),
            icon: Icon(Icons.wallet),
            label: l10n?.bottomNavLoyaltyCards ?? '',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket),
            label: l10n?.bottomNavShoppingList ?? '',
          ),
        ],
      ),
    );
  }
}
