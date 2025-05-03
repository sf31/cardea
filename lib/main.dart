import 'package:cardea/ui/loyalty-card/widgets/loyalty-card-list.dart';
import 'package:cardea/ui/shopping-list/widgets/shopping-list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/loyalty-card.repository.dart';
import 'data/repositories/shopping-item.repository.dart';
import 'data/services/database.service.dart';
import 'data/services/shared-prefs.service.dart';
import 'ui/loyalty-card/loyalty-card.viewmodel.dart';
import 'ui/shopping-list/shopping-item.viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().init();
  final db = DatabaseService().database;

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => SharedPreferencesService()),
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: brightness,
        ),
      ),
      // home: SafeArea(child: const MyHomePage(title: 'Flutter Demo Home Page')),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[LoyaltyCardList(), ShoppingList()][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
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
