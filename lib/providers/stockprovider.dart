import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tbwatchlist/models/stockmodel.dart';
import 'package:http/http.dart' as http;

class StockProvider with ChangeNotifier {
  List<Stock> suggestedStocks = [];
  Map<String, String> stockClosingPrices = {};

  Future<void> fetchStockSuggestions(String keywords) async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$keywords&apikey=WW4Q0RMIVG4QKKT8'));

      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);

        if (parsedData.containsKey('bestMatches')) {
          final bestMatches = parsedData['bestMatches'] as List<dynamic>?;

          if (bestMatches != null) {
            suggestedStocks = bestMatches
                .map((stockData) => Stock(
                      symbol: stockData['1. symbol'],
                      name: stockData['2. name'],
                    ))
                .toList();
          }
        }

        notifyListeners();
      } else {
        throw Exception('Failed to fetch stock suggestions');
      }
    } catch (e) {
      print('Error fetching stock suggestions: $e');
    }
  }

  Future<void> fetchStockData(String symbol) async {
    final response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=WW4Q0RMIVG4QKKT8'));

    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body);
      final timeSeriesData =
          parsedData['Time Series (5min)'] as Map<String, dynamic>?;

      if (timeSeriesData != null) {
        final latestEntry = timeSeriesData.keys.toList().first;
        final closeValue = timeSeriesData[latestEntry]['4. close'];

        stockClosingPrices[symbol] = closeValue;
        notifyListeners();
      }
    } else {
      throw Exception('Failed to fetch stock data');
    }
  }

  Future<String?> fetchLatestClosingPrice(String symbol) async {
    if (stockClosingPrices.containsKey(symbol)) {
      return stockClosingPrices[symbol];
    } else {
      await fetchStockData(symbol);
      return stockClosingPrices[symbol];
    }
  }

  Future<void> fetchUserStockPrice(List<String> symbols) async {
    for (final symbol in symbols) {
      await fetchStockData(symbol);
    }
  }
}
