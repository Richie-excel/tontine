import 'package:flutter/material.dart';

class SessionDetailsScreen extends StatelessWidget {
  final int sessionId;
  const SessionDetailsScreen({super.key, required this.sessionId});

  final List<Map<String, dynamic>> contributors = const [
    {"name": "John Doe", "amount": 10000, "isBeneficiary": false, "contact": "123-456-7890"},
    {"name": "Jane Smith", "amount": 20000, "isBeneficiary": true, "contact": "987-654-3210"},
    {"name": "Mark Lee", "amount": 15000, "isBeneficiary": false, "contact": "456-789-0123"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Session Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Contributors:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: contributors.length,
                itemBuilder: (context, index) {
                  final contributor = contributors[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(
                        contributor['isBeneficiary'] ? Icons.star : Icons.person,
                        color: contributor['isBeneficiary'] ? Colors.amber : Colors.grey,
                      ),
                      title: Text(contributor['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Contributed: \$${contributor['amount']}"),
                      trailing: Text(contributor['contact'],
                          style: const TextStyle(color: Colors.blueGrey)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Beneficiary:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Name: Jane Smith",
                      style: const TextStyle(fontSize: 16)),
                  Text("Contact: 987-654-3210",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  const Text("Total Amount Collected: \$45000",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}