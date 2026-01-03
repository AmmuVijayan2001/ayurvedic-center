import 'dart:ui';

import 'package:ayurvediccenter/Application/screens/PatientListScreen/patientlist.dart';
import 'package:ayurvediccenter/Data/providers/auth_provider.dart';
import 'package:ayurvediccenter/Domain/Common/widgets/app_text_style.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final username = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter username and password")),
      );
      return;
    }

    final success = await authProvider.login(username, password);

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PatientListScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? "Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Image.asset(
                    "assets/images/background.jpg",
                    width: double.infinity,
                    height: height * 0.32,
                    fit: BoxFit.cover,
                  ),
                ),

                Container(
                  width: double.infinity,
                  height: height * 0.32,
                  color: Colors.black.withOpacity(0.25),
                ),

                Image.asset("assets/images/Group.png", width: width * 0.3),
              ],
            ),

            // 🔹 Login Form Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Login Or Register To Book Your Appointments",
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w600,
                  ),

                  SizedBox(height: height * 0.03),

                  AppText(
                    text: "Email",
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: height * 0.01),

                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.015,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  AppText(
                    text: "Password",
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: height * 0.01),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.015,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  SizedBox(
                    width: double.infinity,
                    height: height * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A6A3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: authProvider.isLoading ? null : _handleLogin,
                      child:
                          authProvider.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : AppText(
                                text: "Login",
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppText.defaultStyle(
                          fontSize: width * 0.032,
                          color: Colors.black,
                        ),
                        children: const [
                          TextSpan(
                            text:
                                "By creating or logging into an account you are agreeing\nwith our ",
                          ),
                          TextSpan(
                            text: "Terms and Conditions",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
