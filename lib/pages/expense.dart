import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart'; // Import pie_chart package

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  Map<String, double> _categoryData = {};

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString('transactions') ?? '[]';
    final transactionsList = jsonDecode(transactionsJson) as List<dynamic>;

    final categoryData = <String, double>{};
    for (var item in transactionsList) {
      if (item['type'] == 'Expense') {
        final category = item['category'] ?? 'Unknown';
        final amount = double.tryParse(item['amount']?.replaceAll('\$', '') ?? '0') ?? 0;
        categoryData[category] = (categoryData[category] ?? 0) + amount;
      }
    }

    setState(() {
      _categoryData = categoryData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense',
          style: GoogleFonts.bodoniModa(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Pie Chart
              Expanded(
                child: _categoryData.isNotEmpty
                    ? PieChart(
                        dataMap: _categoryData,
                        chartType: ChartType.ring,
                        colorList: const [
                          Colors.red,
                          Colors.blue,
                          Colors.green,
                          Colors.orange,
                          Colors.purple,
                          Colors.yellow,
                          Colors.grey
                        ],
                        legendOptions: LegendOptions(
                          legendPosition: LegendPosition.left,
                          legendTextStyle: GoogleFonts.arsenal(
                            color: const Color.fromARGB(255, 255, 255, 255), // Default legend text color
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                        ),
                      )
                    : Center(
                        child: Text(
                          'No expenses recorded.',
                          style: GoogleFonts.arsenal(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              // Expense Categories
              Text(
                'Expense Categories',
                style: GoogleFonts.arsenal(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: _categoryData.isNotEmpty
                    ? ListView.builder(
                        itemCount: _categoryData.keys.length,
                        itemBuilder: (context, index) {
                          final category = _categoryData.keys.elementAt(index);
                          final amount = _categoryData[category] ?? 0;
                          return Card(
                            color: const Color.fromARGB(230, 46, 15, 100), // Light red for expense
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                category,
                                style: GoogleFonts.arsenal(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              trailing: Text(
                                '\$${amount.toStringAsFixed(2)}',
                                style: GoogleFonts.arsenal(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 255, 254, 254),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No expenses recorded.',
                          style: GoogleFonts.arsenal(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}