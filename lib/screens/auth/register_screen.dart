import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tontine/components/button.dart';
import 'package:tontine/components/text_field.dart';
import 'package:tontine/models/user_model.dart';
import 'package:tontine/providers/user_provider.dart';
import 'package:tontine/routes/routes.dart';
import 'package:tontine/screens/auth/login_screen.dart';
import 'package:tontine/utils/utils.dart';
import 'package:tontine/view_models/user_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _role; // e.g. "Member" or "Admin"
  String? _selectedDate;
  File? _profileImage;

  bool _isLoading = false; // For loading animation
  bool _isPasswordHidden = true;

  // Animation controller for button scale
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  void selectImage() async {
    File? img = await pickProfileImage(context);
    print(img);
    if (img != null) {
      setState(() {
        _profileImage = img;
        print(_profileImage);
      });
    } else {
      print("No image selected.");
    }
  }

  void selectDate() async {
    String? selectedDate = await pickDate(context);
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate; // Assuming _dateOfBirth is a String
        _dobController.text = _selectedDate!;
      });
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  void initState() {
    super.initState();
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

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a date of birth")),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final user = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        dob: _selectedDate!,
        address: _addressController.text,
        role: _role!,
        profileImage: _profileImage?.path,
      );

      try {
        final userController = UserViewModel();

        String? errorMessage = await userController.createUser(user);

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $errorMessage")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful!")),
          );

          Provider.of<UserProvider>(context, listen: false).setUser(user);

          Navigator.pushNamed(
            context,
            AppRoutes.login,
            arguments: {'user':user}
            
          );
        }
      }
      // Handle web-specific Firebase exceptions
      catch (e) {
        setState(() {
          _isLoading = false;
        });

        String errorMessage = "An unexpected error occurred.";

        // If the error is a FirebaseException
        if (e is FirebaseException) {
          errorMessage = "Firebase error: ${e.message}";
          print({e.message});
        }
        // If the error is related to JavaScript Object mismatch
        else if (e is TypeError) {
          errorMessage = "Firebase TypeError: ${e.toString()}";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        print('Register error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Register'),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 230, 165, 1),
            Color.fromARGB(255, 239, 139, 0),
            Color.fromARGB(255, 255, 167, 38)
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 64,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage != null
                              ? null
                              : Icon(Icons.person,
                                  size: 50, color: Colors.white),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: selectImage,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 18,
                              child: Icon(Icons.add_a_photo,
                                  color: Colors.black, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  // Allows scrolling if content overflows
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Avoids taking unnecessary space
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // Name Field
                          CustomTextField(
                            controller: _nameController,
                            labelText: "Name",
                            suffixIcon: Icons.person_2,
                            validator: (value) =>
                                value!.isEmpty ? "Name is required" : null,
                          ),
                          const SizedBox(height: 16),
                  
                          // Email Field
                          CustomTextField(
                            controller: _emailController,
                            labelText: "Email",
                            suffixIcon: Icons.email_outlined,
                            validator: (value) =>
                                value!.isEmpty ? "Email is required" : null,
                          ),
                          const SizedBox(height: 16),
                  
                          // Date of Birth Field
                          CustomTextField(
                            controller: _dobController,
                            labelText: "Date of Birth",
                            validator: (value) => value!.isEmpty
                                ? "Date of birth is required"
                                : null,
                            onSuffixIconPressed: selectDate,
                            suffixIcon: Icons.calendar_month,
                          ),
                          const SizedBox(height: 16),
                  
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
                          const SizedBox(height: 16),
                  
                          // Address Field
                          CustomTextField(
                            controller: _addressController,
                            labelText: "Address",
                            validator: (value) =>
                                value!.isEmpty ? "Address is required" : null,
                            suffixIcon: Icons.place,
                          ),
                          const SizedBox(height: 16),
                  
                          // User Type Dropdown
                          DropdownButtonFormField<String>(
                            value: _role,
                            decoration: InputDecoration(
                              labelText: "Role",
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: "member",
                                child: Text("member"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _role = value;
                              });
                            },
                            validator: (value) => value == null
                                ? "Please select a role"
                                : null,
                          ),
                          const SizedBox(height: 10),
                  
                          AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: child,
                              );
                            },
                            child: CustomButton(
                              text: "Register",
                              isLoading: _isLoading,
                              onPressed: _register,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Have an account? ",
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
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
