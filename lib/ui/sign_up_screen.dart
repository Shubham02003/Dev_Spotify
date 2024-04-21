import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/navbar.dart';
import 'package:spotify_clone/repo/user_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  bool isGoogleSignUpLoading = false;

  void _signInWithGoogleBind() async {
    setState(() {
      isGoogleSignUpLoading = true;
    });
    UserCredential? userCredential = await _authService.signInWithGoogle();
    if (!context.mounted) return;
    setState(() {
      isGoogleSignUpLoading = false;
    });
    if (userCredential != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NavBar(),
        ), // Adjust this to your HomePage class
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Google. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Millions Of Songs Free On Spotify",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.05),
                SizedBox(
                  width: size.width,
                  height: 50,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Sign up for free",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                SizedBox(
                  width: size.width,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black12,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.phone_android),
                        Text(
                          "Continue With Phone Number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                          overflow: TextOverflow.clip,
                        ),
                        Icon(Icons.phone_android, color: Colors.transparent),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                SizedBox(
                  width: size.width * 0.75,
                  height: 50,
                  child: TextButton(
                    onPressed: () => _signInWithGoogleBind(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black12,
                    ),
                    child: isGoogleSignUpLoading
                        ? const CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/google_img.png",
                                width: size.width * 0.08,
                              ),
                              const Text(
                                "Sign up for free",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              const SizedBox(),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                SizedBox(
                  width: size.width * 0.75,
                  height: 50,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/facebook_img.png",
                          width: size.width * 0.08,
                        ),
                        const Text(
                          "Sign up for free",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        const SizedBox(),
                      ],
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
}
