import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_money/main.dart';
import 'package:my_money/pages/home_page.dart';
import 'package:my_money/pages/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});//constructor

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureText = true; // Password visibility state

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {//
    storeClass.getStorage();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)],
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
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Your Budget Buddy.',
                  style: GoogleFonts.satisfy(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/dollar.png', // Adjust the path as needed
                  width: 200, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 320, // Adjust the width as needed
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone no is required!';
                              } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
                                return 'Enter a valid phone number';
                              } else {
                                return null;
                              }
                            },
                            controller: _idController,
                            decoration: inputDeco('Phone Number', Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 320, // Adjust the width as needed
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required!';
                              } else if (!(value.length >= 6)) {
                                return 'Password must have at least 6 letters';
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'already have an account?',
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: 150,
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await storeClass.store!.setString('username', _idController.text.trim());
                            await storeClass.store!.setString('password', _passController.text.trim());
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(100, 40), // Smaller button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Smaller border radius
                          ),
                          backgroundColor: Colors.white, // White background
                          side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)), // Purple border color
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.arsenal(
                            color: const Color.fromARGB(255, 30, 29, 30), // Purple text color
                            fontSize: 16, // Adjust font size if needed
                            fontWeight: FontWeight.w700,
                          ),
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
  InputDecoration inputDeco(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey),
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
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}