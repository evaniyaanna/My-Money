import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Map<String, String>> transactionHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString('transactions') ?? '[]';
    final transactionsList = jsonDecode(transactionsJson) as List<dynamic>;

    // Reverse the list to show the latest transaction at the top
    setState(() {
      transactionHistory = transactionsList
          .map((item) => Map<String, String>.from(item))
          .toList()
          .reversed
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Match the color with HomePage
        title: Text(
          'Transaction History',
          style: GoogleFonts.bodoniModa(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black, // Match the color with HomePage
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: transactionHistory.length,
            itemBuilder: (context, index) {
              final transaction = transactionHistory[index];
              final amount = transaction['amount'] ?? '0';
              final category = transaction['category'] ?? 'N/A';
              final date = transaction['date'] ?? 'N/A';
              final time = transaction['time'] ?? 'N/A';
              final type = transaction['type'] ?? 'Unknown';

              // Determine color based on type
              Color cardColor;
              Icon leadingIcon;
              if (type == 'Income') {
                cardColor = const Color.fromARGB(221, 99, 53, 177); // Darker color for income
                leadingIcon = const Icon(Icons.add, color: Colors.white); // + icon for income

              } else if (type == 'Expense') {
                cardColor = const Color.fromARGB(230, 46, 15, 100); // Light red for expense
                leadingIcon = const Icon(Icons.remove, color: Colors.white); // - icon for expense
              } else {
                cardColor = Colors.grey.shade300; // Default color
                leadingIcon = const Icon(Icons.help, color: Colors.white); // Default icon
              }

              return Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: leadingIcon,
                  title: Text(
                    category, // Show the category as the heading
                    style: GoogleFonts.arsenal(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // Ensure text is visible on dark backgrounds
                    ),
                  ),
                  subtitle: Text(
                    'Date: $date\nTime: $time',
                    style: GoogleFonts.arsenal(
                      color: Colors.white, // Ensure text is visible on dark backgrounds
                    ),
                  ),
                  trailing: Text(
                    amount,
                    style: GoogleFonts.arsenal(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // Ensure text is visible on dark backgrounds
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}