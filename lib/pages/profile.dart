import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_money/main.dart';  // Ensure this path is correct
import 'package:my_money/pages/login.dart';  // Ensure this path is correct
import 'dart:ui';  // For the ImageFilter

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample user data
    const String userName = "DARTERS";  // Replace with actual user data
    const String userEmail = "Ardra Siva Prasad\nRejeena J Jajin\nEvaniya Anna Suvi";
    const String profilePictureAsset = 'assets/images/team.jpg';  // Path to your local image asset

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Adjust height as needed
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 166, 99, 54), // Current color
                Colors.amber, // Gold shade
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text(
              'About',
              style: GoogleFonts.bodoniModa(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.transparent, // Set to transparent to show the gradient
            elevation: 0, // Remove shadow
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  if (storeClass.store != null) {
                    await storeClass.store!.setBool('isLogin', false);
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            profilePictureAsset,
            fit: BoxFit.cover,
          ),
          // Blurred overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),  // Semi-transparent overlay
            ),
          ),
          // Glass effect container
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // Semi-transparent background
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5), // Border color with opacity
                      width: 2.5,
                      
                      
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80, // Adjust the radius as needed
                        backgroundImage: AssetImage(profilePictureAsset),  // Use AssetImage for local images
                        backgroundColor: Colors.grey[200], // Fallback color
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userName,
                        style: GoogleFonts.abel(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,  // White text color for better visibility
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userEmail,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.abel(
                          fontSize: 16,
                          color: Colors.white70,  // Slightly transparent white for contrast
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}