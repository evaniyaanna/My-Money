import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart'; // Import pie_chart package
import 'package:google_fonts/google_fonts.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  Map<String, double> _categoryData = {};

  // Define colors for pie chart
  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString('transactions') ?? '[]';
    final transactionsList = jsonDecode(transactionsJson) as List<dynamic>;

    final categoryData = <String, double>{};
    for (var item in transactionsList) {
      if (item['type'] == 'Income') {
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
          'Income',
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
                        colorList: _colors,
                        legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.left,
                          legendTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          chartValueStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'No incomes recorded.',
                          style: GoogleFonts.arsenal(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              // Income Categories
              Text(
                'Income Categories',
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
                            color: const Color.fromARGB(221, 99, 53, 177), // Light green for income
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                category,
                                style: GoogleFonts.arsenal(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 255, 252, 252),
                                ),
                              ),
                              trailing: Text(
                                '\$${amount.toStringAsFixed(2)}',
                                style: GoogleFonts.arsenal(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No income recorded.',
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