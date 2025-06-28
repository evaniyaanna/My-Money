import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import Shared Preferences
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart for pie charts
import '../main.dart';
import 'add_expense.dart';
import 'add_income.dart';
import 'expense.dart';
import 'income.dart';
import 'login.dart';
import 'transaction.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> transactions = [];
  double _balance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load balance
    setState(() {
      _balance = prefs.getDouble('balance') ?? 0.0;
    });

    // Load transactions
    final transactionsJson = prefs.getString('transactions') ?? '[]';
    final transactionsList = jsonDecode(transactionsJson) as List<dynamic>;
    setState(() {
      transactions = transactionsList.map((item) => Map<String, String>.from(item)).toList();
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save balance
    await prefs.setDouble('balance', _balance);

    // Save transactions
    final transactionsJson = jsonEncode(transactions);
    await prefs.setString('transactions', transactionsJson);
  }

  void _addTransaction(Map<String, String> transaction) {
    setState(() {
      transactions.add(transaction);
      if (transaction['type'] == 'Income') {
        _balance += double.parse(transaction['amount']!.substring(1));
      } else if (transaction['type'] == 'Expense') {
        _balance -= double.parse(transaction['amount']!.substring(1));
      }
    });
    _savePreferences(); // Save changes to Shared Preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
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
            'MY MONEY',
            style: GoogleFonts.bodoniModa(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                if (storeClass.store != null) {
                  await storeClass.store!.setBool('isLogin', false);
                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage())
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout failed. Please try again.'))
                  );
                }
              },
            ),
            const SizedBox(width: 20), // Add some space between icons
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.transparent, // Set drawer background color to transparent
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: const Color.fromARGB(219, 51, 49, 49).withOpacity(0.4), // Set a semi-transparent background color
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: 70,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.black, // Transparent color for DrawerHeader
                    ),
                    child: Text(
                      'MENU',
                      style: GoogleFonts.bodoniModa(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: Text('Home', style: GoogleFonts.arsenal(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: Text('Profile', style: GoogleFonts.arsenal(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);  // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: Text('Settings', style: GoogleFonts.arsenal(color: Colors.white)),
                  onTap: () {
                    // Navigate to Settings Page
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: Text('Logout', style: GoogleFonts.arsenal(color: Colors.white)),
                  onTap: () async {
                    if (storeClass.store != null) {
                      await storeClass.store!.setBool('isLogin', false);
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginPage())
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout failed. Please try again.'))
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(230, 50, 58, 63),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(238, 232, 232, 232).withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity, // Ensures the container width is full
                        constraints: const BoxConstraints(maxWidth: 350), // Set max width
                        child: Column(
                          children: [
                            Text(
                              'Total Balance',
                              style: GoogleFonts.arsenal(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 228, 227, 227),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '\$$_balance',
                              style: GoogleFonts.arsenal(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 228, 227, 227),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150, // Increased width
                      height: 35, // Increased height
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddIncomePage(transactions: transactions),
                            ),
                          );
                          if (result != null && result is Map<String, String>) {
                            _addTransaction(result);
                          }
                        },
                        icon: const Icon(Icons.add,color: Colors.white,),
                        label: Text('Add Income',
                          style: GoogleFonts.arsenal(color: const Color.fromARGB(255, 255, 255, 255)),

                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(238, 107, 81, 153),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150, // Increased width
                      height: 35, // Increased height
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddExpensePage(transactions: transactions),
                            ),
                          );
                          if (result != null && result is Map<String, String>) {
                            _addTransaction(result);
                          }
                        },
                        icon: const Icon(Icons.remove,color: Colors.white ,),
                        label: Text('Add Expense',
                          style: GoogleFonts.arsenal(color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(230, 46, 15, 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(230, 50, 58, 63),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 184, 183, 184).withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Summary',
                              style: GoogleFonts.arsenal(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(179, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 200, // Increased height for the chart container
                              child: PieChart(
                                PieChartData(
                                  sections: _getSections(),
                                  borderData: FlBorderData(show: true),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: const Color.fromARGB(230, 107, 81, 153), // Color for Income
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Income',
                                      style: GoogleFonts.arsenal(
                                        color: Colors.white,
                                        fontSize: 16),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: const Color.fromARGB(230, 46, 15, 100), // Color for Expense
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Expense',
                                      style: GoogleFonts.arsenal(
                                        color: Colors.white,
                                        fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150, // Increased width
                      height: 60, // Increased height
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExpensePage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(230, 46, 15, 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Expenses', style: GoogleFonts.arsenal(
                          color: Colors.white,
                        )
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150, // Increased width
                      height: 60, // Increased height
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IncomePage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(230, 84, 36, 165),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Income', style: GoogleFonts.arsenal(
                          color: Colors.white,
                        )),
                      ),
                    ),
                    SizedBox(
                      width: 150, // Increased width
                      height: 60, // Increased height
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TransactionPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(230, 107, 81, 153),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Transactions', style: GoogleFonts.arsenal(
                          color: Colors.white,
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30), // Extra space to ensure layout doesn't clip
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    double income = transactions
        .where((t) => t['type'] == 'Income')
        .fold(0.0, (sum, t) => sum + double.parse(t['amount']!.substring(1)));
    
    double expense = transactions
        .where((t) => t['type'] == 'Expense')
        .fold(0.0, (sum, t) => sum + double.parse(t['amount']!.substring(1)));

    return [
      PieChartSectionData(
        color: const Color.fromARGB(230, 84, 36, 165),
        value: income,
        title: income.toStringAsFixed(0),
        radius: 100,
        titleStyle: GoogleFonts.arsenal(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(230, 46, 15, 100),
        value: expense,
        title: expense.toStringAsFixed(0),
        radius: 100,
        titleStyle: GoogleFonts.arsenal(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }
}