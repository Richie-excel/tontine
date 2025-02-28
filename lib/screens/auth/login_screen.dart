import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tontine/components/button.dart';
import 'package:tontine/components/text_field.dart';
import 'package:tontine/models/user_model.dart';
import 'package:tontine/providers/user_provider.dart';
import 'package:tontine/routes/routes.dart';
import 'package:tontine/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserModel? user;
  const LoginScreen({super.key, this.user});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordHidden = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading animation
      });

      try {
        // Sign in with Firebase Auth
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Simulate a delay for Firebase password reset
        await Future.delayed(const Duration(seconds: 2));

        // Check if the widget is still mounted
        if (!mounted) return;

        setState(() {
          _isLoading = false; // Stop loading animation
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful!")),
        );

        Navigator.pushNamed(
          context,
          AppRoutes.userDashboard,
        );

        // Navigate to the home screen or another screen after login
        // Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        // Check if the widget is still mounted
        if (!mounted) return;

        setState(() {
          _isLoading = false; // Stop loading animation
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      } catch (e) {
        setState(() {
          _isLoading = false; // Stop loading animation
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Login"),)
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 230, 165, 1),
            Color.fromARGB(255, 239, 139, 0),
            Color.fromARGB(255, 255, 167, 38)
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              // Elevated Form

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage: user?.profileImage != null
                          ? NetworkImage('https://${user!.profileImage!}')  // Use NetworkImage to load from URL
                          : null,  
                      child: user?.profileImage == null
                          ? Icon(Icons.person, size: 60, color: Colors.white)  // Show icon if no image
                          : null,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 60,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Welcome back ${user?.name?? 'user'}",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                                  
                          // Sign Up Link
                          // Email Field
                          CustomTextField(
                            controller: _emailController,
                            labelText: "Email",
                            suffixIcon: Icons.email_outlined,
                            validator: (value) =>
                                value!.isEmpty ? "Email is required" : null,
                          ),
                                  
                          SizedBox(
                            height: 30,
                          ),
                                  
                          // Password Field
                          CustomTextField(
                            controller: _passwordController,
                            labelText: "Password",
                            obscureText: _isPasswordHidden,
                            validator: (value) =>
                                (value == null || value.length < 6)
                                    ? "Minimum 6 characters required"
                                    : null,
                            suffixIcon: (_isPasswordHidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onSuffixIconPressed: togglePasswordVisibility,
                          ),
                                  
                          SizedBox(
                            height: 30,
                          ),
                                  
                          AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: child,
                              );
                            },
                            child: CustomButton(
                              text: "Login",
                              isLoading: _isLoading,
                              onPressed: _login,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
