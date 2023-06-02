import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tbwatchlist/models/hivedatamodel.dart';
import 'package:tbwatchlist/providers/hivedataprovider.dart';
import 'package:tbwatchlist/providers/stockprovider.dart';
import 'package:tbwatchlist/screens/bottomnavbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveDataModelAdapter());
  await Hive.openBox<HiveDataModel>('stockData');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HiveProvider>(create: (_) => HiveProvider()),
        ChangeNotifierProvider<StockProvider>(create: (_) => StockProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trade Brains',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BottomBar(),
      ),
    );
  }
}
