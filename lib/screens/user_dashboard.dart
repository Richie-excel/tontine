import 'package:flutter/material.dart';
import 'package:tontine/routes/routes.dart';

class UserDashboard extends StatelessWidget {
  UserDashboard({super.key});

  // Sample data
  final List<Map<String, String>> recentContributions = [
    {'amount': '100', 'date': 'Feb 10, 2025', 'session': 'Session 1'},
    {'amount': '200', 'date': 'Feb 8, 2025', 'session': 'Session 2'},
    {'amount': '150', 'date': 'Feb 5, 2025', 'session': 'Session 3'},
  ];

  final List<Map<String, String>> upcomingSessions = [
    {'date': 'Feb 15, 2025', 'time': '10:00 AM', 'location': 'Tontine Hall'},
    {
      'date': 'Feb 20, 2025',
      'time': '02:00 PM',
      'location': 'Community Center'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Recent Contributions
            SectionTitle(title: 'Recent Contributions'),
            _buildRecentContributions(),

            SizedBox(height: 20),

            // Upcoming Tontine Sessions
            SectionTitle(title: 'Upcoming Tontine Sessions'),
            _buildUpcomingSessions(),

            SizedBox(height: 20),

            // User's Turn to Benefit
            SectionTitle(title: 'Your Turn to Benefit'),
            _buildUserTurnToBenefit(),

            SizedBox(height: 20),

            // Other Important Info
            SectionTitle(title: 'Important Announcements'),
            _buildImportantInfo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Contribute',
        backgroundColor: Color.fromARGB(201, 254, 1, 43),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.contribute);
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  Widget _buildRecentContributions() {
    return Column(
      children: recentContributions.map((contribution) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('Amount: ${contribution['amount']}'),
            subtitle: Text(
                'Date: ${contribution['date']} \nSession: ${contribution['session']}'),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpcomingSessions() {
    return Column(
      children: upcomingSessions.map((session) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('Date: ${session['date']}'),
            subtitle: Text(
                'Time: ${session['time']} \nLocation: ${session['location']}'),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserTurnToBenefit() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.blueAccent,
      child: ListTile(
        title: Text('You are next to benefit from the tontine pool!',
            style: TextStyle(color: Colors.white)),
        subtitle: Text('Your turn will be on Feb 20, 2025.'),
      ),
    );
  }

  Widget _buildImportantInfo() {
    return Column(
      children: [
        ListTile(
          title: Text('New tontine session added!'),
          subtitle: Text('Check out the details for the upcoming session.'),
        ),
        ListTile(
          title: Text('Reminder: Your contribution deadline is coming up!'),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
