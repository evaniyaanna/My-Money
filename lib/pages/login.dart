import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_money/main.dart';
import 'package:my_money/pages/home_page.dart';
import 'package:my_money/pages/signup.dart'; // Import SignUpPage to navigate

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true; // Password visibility state

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0), // Dark color to match SignUpPage
              Color.fromARGB(255, 0, 0, 0), // Dark color to match SignUpPage
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MY MONEY',
                  style: GoogleFonts.bodoniModa(
                    color: const Color.fromARGB(255, 255, 255, 255), // Match SignUpPage text color
                    fontSize: 60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Your Budget Buddy.',
                  style: GoogleFonts.satisfy(
                    color: const Color.fromARGB(255, 255, 255, 255), // Match SignUpPage text color
                    fontSize: 20,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/dollar.png', // Adjust the path as needed
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 320,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone number is required!';
                              } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
                                return 'Enter a valid phone number';
                              } else {
                                return null;
                              }
                            },
                            controller: _idController,
                            decoration: inputDeco('Phone Number', Icons.phone),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 320,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required!';
                              } else if (!(value.length >= 6)) {
                                return 'Password must have at least 6 characters';
                              } else {
                                return null;
                              }
                            },
                            controller: _passController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(color: Color(0xFFA8A8A8), width: .8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(color: Color(0xFFA8A8A8), width: .8),
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navigate to SignUpPage if needed
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: GoogleFonts.satisfy(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                          letterSpacing: -.5,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String username = storeClass.store!.getString('username') ?? '';
                          String pass = storeClass.store!.getString('password') ?? '';
                          if (username == _idController.text.trim() && pass == _passController.text.trim()) {
                            await storeClass.store!.setBool('isLogin', true);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      child: Text(
                        'Log In',
                        style: GoogleFonts.arsenal(
                          color: const Color.fromARGB(255, 30, 29, 30),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDeco(String hint, [IconData? icon]) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFA8A8A8), width: .8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFA8A8A8), width: .8),
      ),
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}