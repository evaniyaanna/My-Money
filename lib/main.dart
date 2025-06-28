import 'package:flutter/material.dart';
import 'package:my_money/pages/home_page.dart';
import 'package:my_money/pages/login.dart';
import 'package:my_money/pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await storeClass.getStorage();
  final bool login = storeClass.store!.getBool('isLogin') ?? false;
  final String signUp = storeClass.store!.getString('username') ?? 'null';
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: (signUp != 'null')
        ? (login)
            ? const HomePage()
            : const LoginPage()
        : const SignUpPage(),
    title: 'My MONEY',
  ));
}

class GetStorage {
  late SharedPreferences? store;
  getStorage() async {
    store = await SharedPreferences.getInstance();
  }
}

final GetStorage storeClass = GetStorage();