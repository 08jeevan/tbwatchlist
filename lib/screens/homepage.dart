import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbwatchlist/providers/hivedataprovider.dart';
import 'package:tbwatchlist/providers/stockprovider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<HiveProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Brains'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 14.0,
            ),
            const Text(
              "Enter the stock name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 14.0,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  hintText: 'Start typing',
                ),
                onChanged: (text) {
                  Provider.of<StockProvider>(context, listen: false)
                      .fetchStockSuggestions(text);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Consumer<StockProvider>(
              builder: (context, stockProvider, _) {
                final suggestedStocks = stockProvider.suggestedStocks;
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: suggestedStocks.length,
                    itemBuilder: (context, index) {
                      final stock = suggestedStocks[index];
                      if (suggestedStocks[index].toString().isEmpty) {
                        Container();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.grey.shade200,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        stock.symbol,
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                  Expanded(
                                    flex: 1,
                                    child: FutureBuilder(
                                      future:
                                          stockProvider.fetchLatestClosingPrice(
                                              stock.symbol),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container();
                                        } else if (snapshot.hasError) {
                                          return Text('Error');
                                        } else {
                                          return Text(
                                            snapshot.data ?? 'N/A',
                                            style: TextStyle(fontSize: 20),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.shade100,
                                    child: GestureDetector(
                                      child: const Icon(Icons.add, size: 30),
                                      onTap: () {
                                        userData.addData(
                                            stock.name, stock.symbol);
                                        print(stock.name);
                                        print(stock.symbol);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(stock.name),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
