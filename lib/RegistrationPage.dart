// ignore_for_file: file_names, duplicate_ignore

import 'auth.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController(); // Add confirm password controller
  final _formKey = GlobalKey<FormState>();
  bool isHiddenPass = true;

  void _tooglePasswordView() {
    setState(() {
      isHiddenPass = !isHiddenPass;
    });
  }

  Icon buildKey() {
    if (isHiddenPass == true) {
      return const Icon(Icons.visibility, color: Colors.orange);
    } else {
      return const Icon(Icons.visibility_off, color: Colors.orange);
    }
  }  
  bool isHiddenPass2 = true;

  void _tooglePasswordView2() {
    setState(() {
      isHiddenPass2 = !isHiddenPass2;
    });
  }

  Icon buildKey2() {
    if (isHiddenPass2 == true) {
      return const Icon(Icons.visibility, color: Colors.orange);
    } else {
      return const Icon(Icons.visibility_off, color: Colors.orange);
    }
  }

  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  Future<void> signUp() async {
    String email = emailController.text;
    String password = passwordController.text;
    dynamic result = await authService.signUpWithEmailAndPassword(email, password);

    if (result != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Registration', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  floatingLabelStyle: TextStyle(
                    color: Colors.orange,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                  ),
                  fillColor: Colors.orange,
                ),
                cursorColor: Colors.orange,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  suffixIcon: InkWell(onTap: _tooglePasswordView, child: buildKey()),
                  labelText: 'Password',
                  floatingLabelStyle: const TextStyle(
                      color: Colors.orange), // Set label color to orange
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .orange), // Set the border color to orange when focused
                  ),
                  fillColor: Colors.orange,
                ),
                cursorColor: Colors.orange,
                obscureText: isHiddenPass,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField( // Add confirm password field
                controller: confirmPasswordController,
                
                decoration:  InputDecoration(
                                    suffixIcon: InkWell(onTap: _tooglePasswordView2, child: buildKey2()),

                  labelText: 'Confirm Password',
                  floatingLabelStyle: const TextStyle(
                    color: Colors.orange,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                  ),
                  fillColor: Colors.orange,
                ),
                cursorColor: Colors.orange,
                obscureText: isHiddenPass2, // Always hide confirm password
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Register', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Already Have Account ?', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
