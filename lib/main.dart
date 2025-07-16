import 'package:cardea/ui/home/home_page.dart';
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

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => SharedPreferencesService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create:
              (_) => LoyaltyCardViewModel(
                repository: LoyaltyCardRepository(db: db),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => ShoppingItemViewModel(
                repository: ShoppingItemRepository(db: db),
              ),
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
