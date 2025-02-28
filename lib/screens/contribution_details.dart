import 'package:flutter/material.dart';
import 'package:tontine/models/contribution_model.dart';
import 'package:tontine/utils/utils.dart';

class ContributionDetails extends StatelessWidget {
  final ContributionModel contribution;

  const ContributionDetails({super.key, required this.contribution});

  

 @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text('Contribution Details'),
      content: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserDetails(contribution.userUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('User details not found'));
          } else {
            var userDetails = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text('Name: ${userDetails['name']}'),
                  Text('Email: ${userDetails['email']}'),
                  Text('Amount: ${contribution.amount}'),
                  Text('Date: ${contribution.contribDate}'),
                ],
              ),
            );
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }
}
