// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatefulWidget {
  final String recognizedText;

  const ResultPage({Key? key, required this.recognizedText}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late TextEditingController _textEditingController;
  bool _isEditing = false;
  String _editedText = '';

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.recognizedText);
    _editedText = widget.recognizedText;
  }

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  Future<void> _searchInBrowser(String query) async {
    final encodedQuery = Uri.encodeQueryComponent(query);
    final url = 'https://www.google.com/search?q=$encodedQuery';

    // ignore: deprecated_member_use
    await launch(url);
  }

  Future<void> _translateAndOpenBrowser(String query) async {
    final encodedQuery = Uri.encodeQueryComponent(query);
    final url =
        'https://translate.google.com/?sl=auto&tl=en&text=$encodedQuery'; // Google Translate URL

    // ignore: deprecated_member_use
    await launch(url);
  }

  void _updateEditedText(String newText) {
    setState(() {
      _editedText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            color: _isEditing ? Colors.blueGrey : Colors.black,
            tooltip: 'Edit Text',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _searchInBrowser(_editedText);
            },
            color: Colors.black,
            tooltip: 'Search Text',
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _copyText(context, _editedText),
            color: Colors.black,
            tooltip: 'Copy Text',
          ),
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {
              _translateAndOpenBrowser(_editedText);
            },
            color: Colors.black,
            tooltip: 'Translate Text', // Updated tooltip
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (_isEditing)
                TextField(
                  controller: _textEditingController,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                  maxLines: null, // Allow multiple lines
                  onChanged: (newText) {
                    _updateEditedText(newText);
                  },
                )
              else
                Text(
                  _editedText,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
