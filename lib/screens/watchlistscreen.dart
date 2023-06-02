import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbwatchlist/providers/hivedataprovider.dart';
import 'package:tbwatchlist/providers/stockprovider.dart';

final stockProvider = StockProvider();

class WatchlistScreen extends StatefulWidget {
  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();

    final savedModelData = Provider.of<HiveProvider>(context, listen: false);
    final users = savedModelData.sData;

    for (final user in users) {
      stockProvider.fetchStockData(user.stockName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedModelData = Provider.of<HiveProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        centerTitle: true,
      ),
      body: Consumer<HiveProvider>(
        builder: (context, userProvider, _) {
          final users = userProvider.sData;

          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No Data Found',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      stockProvider.fetchLatestClosingPrice(user.stockName);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.grey.shade200,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    user.stockName,
                                    style: const TextStyle(fontSize: 20),
                                  )),
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<String?>(
                                  future: stockProvider
                                      .fetchLatestClosingPrice(user.stockName),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text("LOADING...");
                                    } else if (snapshot.hasError) {
                                      return const Text('Error');
                                    } else {
                                      final closingPrice =
                                          snapshot.data ?? 'No data found';

                                      return Text(closingPrice);
                                    }
                                  },
                                ),
                              ),
                              Container(
                                color: Colors.grey.shade100,
                                child: GestureDetector(
                                  child: const Icon(Icons.delete_outline,
                                      size: 30, color: Colors.red),
                                  onTap: () {
                                    savedModelData.deleteData(user.stockId);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(user.stockId),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
