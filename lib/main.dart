import 'package:cardea/ui/home/home_page.dart';
import 'package:cardea/ui/settings/settings.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/loyalty_card.repository.dart';
import 'data/repositories/shopping_item.repository.dart';
import 'data/services/database.service.dart';
import 'data/services/shared_prefs.service.dart';
import 'ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'ui/shopping-list/shopping_item.viewmodel.dart';
import 'utils/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().init();
  final db = DatabaseService().database;
  final sharedPrefsService = SharedPreferencesService();
  final loyaltyCardRepository = LoyaltyCardRepository(sharedPrefsService, db);
  final shoppingItemRepository = ShoppingItemRepository(db: db);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create:
              (_) => LoyaltyCardViewModel(repository: loyaltyCardRepository),
        ),
        ChangeNotifierProvider(
          create:
              (_) => ShoppingItemViewModel(repository: shoppingItemRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(sharedPrefs: sharedPrefsService),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Brightness brightness;

  const MyApp({super.key, this.brightness = Brightness.light});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: const MyHomePage(),
    );
  }
}
