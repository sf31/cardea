import 'package:cardea/data/services/shared_prefs.service.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_home.dart';
import 'package:cardea/ui/shopping-list/widgets/shopping_list.dart';
import 'package:flutter/material.dart';

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
              title: Text('Welcome to Cardea!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This app is still under development, so please be aware of potential bugs and missing features.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Hint: you can import/export your data in the settings page for backup or transfer to another device.',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _prefsService.setEarlyAccessAlertShown();
                    Navigator.of(context).pop();
                  },
                  child: Text('Got it!'),
                ),
              ],
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.wallet),
            icon: Icon(Icons.wallet),
            label: 'Cards',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket),
            label: 'Shopping',
          ),
        ],
      ),
    );
  }
}
