import 'package:flutter/material.dart';
import 'package:tontine/components/drawer.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("FinancePro")),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      drawer: DrawerComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [   
                  _buildTontineGroupCard("Group 1", "5 members"),
                  _buildTontineGroupCard("Group 2", "7 members"),
                  _buildTontineGroupCard("Group 3", "10 members"),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle create new group button press
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTontineGroupCard(String groupName, String members) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(groupName),
        subtitle: Text(members),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Handle group tap
        },
      ),
    );
  }
}