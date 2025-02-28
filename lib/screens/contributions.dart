import 'package:flutter/material.dart';
import 'package:tontine/models/contribution_model.dart';
import 'package:tontine/screens/contribution_details.dart';
import 'package:tontine/utils/utils.dart';

class ContributionsScreen extends StatefulWidget {
  const ContributionsScreen({super.key});

  @override
  State<ContributionsScreen> createState() => _ContributionsScreenState();
}

class _ContributionsScreenState extends State<ContributionsScreen> {
  List<ContributionModel> contributions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllContributions();
  }



  @override
  Widget build(BuildContext context) {
    double totalAmount =
        contributions.fold(0, (total, item) => total + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Contributions'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Summary section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Contributions: \$${totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text("Total Contributors: ${contributions.length}"),
                    ],
                  ),
                ),

                // List of contributors
                Expanded(
                  child: ListView.builder(
                    itemCount: contributions.length,
                    itemBuilder: (context, index) {
                      final contribution = contributions[index];
                      return FutureBuilder<Map<String, dynamic>>(
                        future: fetchUserDetails(contribution.userUid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text('Loading...'),
                            );
                          } else if (snapshot.hasError) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.error),
                              ),
                              title: Text('Error loading user details'),
                            );
                          } else if (!snapshot.hasData) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text('User not found'),
                            );
                          } else {
                            var userDetails = snapshot.data!;
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      userDetails['profileImage'] ?? ''),
                                ),
                                title: Text(userDetails['name'] ?? 'Unknown'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Amount: \$${contribution.amount.toStringAsFixed(2)}"),
                                    Text("Date: ${contribution.contribDate}"),
                                  ],
                                ),
                                trailing: Icon(Icons.check_circle,
                                    color: Colors.green),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ContributionDetails(
                                        contribution: contribution),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
