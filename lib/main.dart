import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/loyalty-card.repository.dart';
import 'data/repositories/shopping-item.repository.dart';
import 'data/services/database.service.dart';
import 'ui/loyalty-card/loyalty-card.viewmodel.dart';
import 'ui/loyalty-card/widgets/loyalty-card-list.dart';
import 'ui/shopping-list/shopping-item.viewmodel.dart';
import 'ui/shopping-list/widgets/shopping-list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().init();
  // runApp(
  //   ChangeNotifierProvider(
  //     create:
  //         (context) => LoyaltyCardProvider(
  //           repository: LoyaltyCardRepository(db: DatabaseService().database),
  //         ),
  //     child: MyApp(brightness: brightness),
  //   ),
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (context) => LoyaltyCardViewModel(
                repository: LoyaltyCardRepository(
                  db: DatabaseService().database,
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => ShoppingItemViewModel(
                repository: ShoppingItemRepository(
                  db: DatabaseService().database,
                ),
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
