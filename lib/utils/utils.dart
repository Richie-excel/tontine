import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tontine/models/contribution_model.dart';
import 'package:tontine/models/user_model.dart';

Future<String?> pickDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime(1950),
    firstDate: DateTime(1950),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    return DateFormat('yyyy-MM-dd').format(picked);
  }
  return null; // Explicitly return null if no date is selected
}

Future<File?> pickProfileImage(BuildContext context) async {
  final ImagePicker picker = ImagePicker();

  // Show a dialog to let the user choose between Camera and Gallery
  final ImageSource? source = await showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        title: const Text("Select Source"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text("Gallery"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, null), // Cancel option
              child: const Text("Cancel"),
            ),
          ],
        ),
      );
    },
  );

  // If user cancels the dialog, return null
  if (source == null) return null;

  // Pick image from the selected source
  final XFile? image = await picker.pickImage(source: source);

  if (image != null) {
    print({image.path});
    // Convert the picked image to a File
    return File(image.path);
  }

  return null; // Return null if no image was picked
}

Future<List<UserModel>> getAllUsers() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference usersCollection = firestore.collection('users');

  try {
    // Get all documents in the users collection
    QuerySnapshot querySnapshot = await usersCollection.get();

    // Convert each document into a UserModel list
    List<UserModel> users = querySnapshot.docs.map((doc) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return users;
  } catch (e) {
    print("Error fetching users: $e"); // ✅ Print error for debugging
    throw Exception("Error fetching all users: $e");
  }
}

Future<Map<String, dynamic>> fetchUserDetails(String userUid) async {
  DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userUid).get();

  if (userSnapshot.exists) {
    return userSnapshot.data() as Map<String, dynamic>;
  } else {
    throw Exception('User not found');
  }
}

Future<Object> getAllContributions() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference contributionsCollection =
      firestore.collection('contributions');

  try {
    // Fetch all documents from Firestore
    QuerySnapshot querySnapshot = await contributionsCollection.get();

    // Convert Firestore data to Contribution list
    List<ContributionModel> contributions = querySnapshot.docs.map((doc) {
      return ContributionModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return contributions;
  } catch (e) {
    print("Error fetching contributions: $e");
    return e.toString();
  }
}

void showUserDetails(BuildContext context, UserModel user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text(user.name!)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.profileImage!),
            ),
            SizedBox(height: 16),

            Text('email: ${user.email}'),
            Text('dob: ${user.dob}'),
            Text('address: ${user.address}'),
            Text('role: ${user.role}')
            // Text('uid':${user.uid})
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
