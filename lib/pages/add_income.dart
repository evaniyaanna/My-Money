import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class AddIncomePage extends StatefulWidget {
  final List<Map<String, String>> transactions;

  const AddIncomePage({super.key, required this.transactions});

  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Salary';

  void _addIncome() async {
    final amount = _amountController.text;
    final now = DateTime.now();
    final transaction = {
      'type': 'Income',
      'amount': '\$$amount', // Format amount to include '$' sign
      'category': _selectedCategory,
      'date': '${now.day}/${now.month}/${now.year}',
      'time': '${now.hour}:${now.minute}',
    };

    // Update transactions
    final updatedTransactions = List<Map<String, String>>.from(widget.transactions)..add(transaction);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transactions', jsonEncode(updatedTransactions));

    Navigator.pop(context, transaction); // Return to the previous page with transaction data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // White hamburger icon
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Add Income',
          style: GoogleFonts.bodoniModa(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: GoogleFonts.nunito(color: Colors.white),
                filled: true,
                fillColor: const Color.fromARGB(230, 50, 58, 63),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.nunito(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(230, 50, 58, 63),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  dropdownColor: const Color.fromARGB(230, 50, 58, 63),
                  style: GoogleFonts.nunito(color: Colors.white),
                  underline: const SizedBox(), // Remove the default underline
                  items: <String>['Salary', 'Bonus', 'Freelance','Other Incomes'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addIncome,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(230, 84, 36, 165),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Add Income',
                style: GoogleFonts.nunito(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}