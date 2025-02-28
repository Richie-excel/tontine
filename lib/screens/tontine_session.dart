import 'package:flutter/material.dart';


class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  final List<Map<String, dynamic>> sessions = const [
    {"id": 1, "date": "Jan 15, 2024", "total": 50000, "status": "Ongoing"},
    {"id": 2, "date": "Feb 10, 2024", "total": 60000, "status": "Closed"},
    {"id": 3, "date": "Mar 5, 2024", "total": 75000, "status": "Ongoing"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tontine Sessions')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text("Session Date: ${session['date']}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Total Collected: \$${session['total']}",
                  style: const TextStyle(fontSize: 16)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: session['status'] == "Ongoing" ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  session['status'],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/session-details',
                  arguments: session['id'],
                );
              },
            ),
          );
        },
      ),
    );
  }
}