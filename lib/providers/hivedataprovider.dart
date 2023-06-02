import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tbwatchlist/models/hivedatamodel.dart';

class HiveProvider with ChangeNotifier {
  final Box<HiveDataModel> _userBox = Hive.box<HiveDataModel>('stockData');

  List<HiveDataModel> get sData => _userBox.values.toList();

  void addData(String stockName, String stockSymbol) {
    final stockData = HiveDataModel()
      ..stockId = stockName
      ..stockName = stockSymbol;

    _userBox.put(stockData.stockId, stockData);
    notifyListeners();
  }

  void deleteData(String id) {
    _userBox.delete(id);
    notifyListeners();
  }
}
