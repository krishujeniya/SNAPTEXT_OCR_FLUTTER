// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'LoginPage.dart';
import 'auth.dart';
import 'dart:io';
import 'ResultPage.dart';
import 'HistoryPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  final TextRecognizer textRecognizer = TextRecognizer();
  Future<File> processImage(File image) async {
    return image;
  }

  void captureImage(ImageSource source) async {
    final image = await picker.pickImage(source: source);
    if (image != null) {
      final processedImage = await processImage(File(image.path));
      setState(() {
        imageFile = processedImage;
      });
    }
  }

  Future<void> signOutUser() async {
    dynamic result = await authService.signOut();
    if (result == null) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  // void UserNameDisplay() async {
  //   String? result1 = authService.getCurrentUser()?.email;
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(result1!),
  //     ),
  //   );
  // }

void recognizeText() async {
  if (imageFile == null) {
    return;
  }

  final recognizedText1 =
      await textRecognizer.processImage(InputImage.fromFile(imageFile!));

  final recognizedText = recognizedText1.text;

  // Get the current user's email
  final currentUserEmail = authService.getCurrentUser()?.email;

  // Store the recognized text in Firestore under the user's email
  if (currentUserEmail != null) {
    await FirebaseFirestore.instance.collection('users').doc(currentUserEmail).collection('history').add({
      'text': recognizedText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Navigate to the ResultPage as before
  // ignore: use_build_context_synchronously
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ResultPage(recognizedText: recognizedText),
    ),
  );
}


  final qrTextController = TextEditingController();
  String qrData = "Hello, QR Code!";
  late GlobalKey qrKey;
  late QRViewController qrController;

  @override
  void initState() {
    super.initState();
    qrKey = GlobalKey();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('SnapText', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              signOutUser();
            },
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HistoryPage(), // Replace 'HistoryPage()' with your actual class name
      ),
    );
  },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.grey[600]!),
                    ),
                    child: imageFile != null
                        ? Image.file(
                            imageFile!,
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                            fit: BoxFit.contain,
                          )
                        : Icon(
                            Icons.image,
                            size: MediaQuery.of(context).size.width * 0.2,
                            color: Colors.grey[600],
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () => captureImage(ImageSource.camera),
                          icon: const Icon(Icons.camera, color: Colors.black),
                          label: const Text(
                            'Camera',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () => captureImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo, color: Colors.black),
                          label: const Text(
                            'Gallery',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: recognizeText,
                    icon: const Icon(Icons.text_fields, color: Colors.black),
                    label: const Text(
                      'Recognize Text',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: qrTextController,
                    decoration: const InputDecoration(
                      labelText: 'Enter text for QR Code',
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
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        qrData = qrTextController.text;
                      });
                    },
                    icon: const Icon(Icons.qr_code, color: Colors.black),
                    label: const Text(
                      'Generate QR',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[600]!),
                        ),
                        child: QrImageView(
                          data: qrData,
                          key: qrKey,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text Recognizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Code Generator',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}
