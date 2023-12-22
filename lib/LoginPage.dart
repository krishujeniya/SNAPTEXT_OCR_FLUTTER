// ignore_for_file: file_names, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';

import 'auth.dart';
import 'package:flutter/material.dart';
import 'RegistrationPage.dart';
import 'HomePage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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

   Future<void> signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }

void resetPassword() {
  try {
    
    String email = emailController.text;
    if (email.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter Your Email'),
                    ),
                  );  } else {
    
    authService.resetPassword(email);
    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset email sent'),
                    ),
                  );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email'),
        ),
      );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange, // Set app bar color to black
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
                        color: Colors
                            .orange), // Set the border color to orange when focused
                  ),
                  fillColor: Colors.orange, // Set label color to orange
                ),
                cursorColor: Colors.orange,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  suffixIcon:
                      InkWell(onTap: _tooglePasswordView, child: buildKey()),
                  labelText: 'Password',
                  floatingLabelStyle:
                      const TextStyle(color: Colors.orange), // Set label color to orange

                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .orange), // Set the border color to orange when focused
                  ),
                  fillColor: Colors.orange,
                ),
                cursorColor: Colors.orange,
                // Set cursor color to orange
                obscureText: isHiddenPass,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signIn();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set button background color to orange
                ),
                child: const Text('Login', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10), // Add some spacing
              TextButton(
                onPressed: () {
                  resetPassword();
                  
                },
                child: const Text('Forgot Password ?',
                    style: TextStyle(color: Colors.orange)),
              ),
              const SizedBox(height: 10), // Add some spacing
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );
                },
                child: const Text('Create an Account ?',
                    style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
