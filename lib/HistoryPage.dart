// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'ResultPage.dart';
import 'auth.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final currentUserEmail = authService.getCurrentUser()?.email;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentUserEmail ?? 'History Page', style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserEmail)
            .collection('history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final historyItems = snapshot.data!.docs;
          return ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final historyItem = historyItems[index];
              final text = historyItem['text'];
              final timestamp = historyItem['timestamp'] as Timestamp;

              // Format timestamp to include both date and time
              final formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(timestamp.toDate());

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(recognizedText: text),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                        formattedDateTime,
                        style: const TextStyle(fontSize: 18, color: Colors.orange),
                      ),
                      Text(
                        '$text',
                        style: const TextStyle(fontSize: 16),
                      ),
                      
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

