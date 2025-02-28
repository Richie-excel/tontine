import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tontine/models/user_model.dart';


class UserViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Reference to the "users" collection
  CollectionReference get usersCollection => _firestore.collection('users');

  /// 🔹 Create User


Future<String?> createUser(UserModel user) async {
  try {
    // Register user with Firebase Auth and get UID
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: user.email!,
      password: user.password!,
    );

    String? uid = userCredential.user?.uid; // Get Firebase Auth UID
    user.uid = uid; // Assign correct UID

    // Upload profile image (if available)
    if (user.profileImage != null && user.profileImage is File) {
      try {
        final storageRef = _storage.ref().child('profile_images/$uid.jpg');

        // Upload image to Firebase Storage
        await storageRef.putFile(user.profileImage as File);

        // Get the download URL and store it as a String
        String imageUrl = await storageRef.getDownloadURL();
        user.profileImage = imageUrl; // Store the URL in profileImage
        print('Profile image uploaded successfully: $imageUrl');
      } catch (storageError) {
        return "Error uploading profile image: ${storageError.toString()}";
      }
    }

    // Save user data in Firestore with correct UID
    await _firestore.collection('users').doc(uid).set(user.toJson());

    return null; // Success
  } on FirebaseAuthException catch (e) {
    return e.message ?? "Authentication failed";
  } on FirebaseException catch (e) {
    return e.message ?? "Firebase error occurred";
  } catch (e) {
    return "Error creating user: ${e.toString()}";
  }
}



  /// 🔹 Read User by Email (Fetch user details)
Future<UserModel?> getUserByEmail(String email) async {
  try {
    // Query the users collection for the document with the given email
    QuerySnapshot querySnapshot = await usersCollection
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming the email is unique and the first result is the desired user
      DocumentSnapshot doc = querySnapshot.docs.first;
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      return null; // No user found with the given email
    }
  } catch (e) {
    throw Exception("Error fetching user by email: $e");
  }
}


  /// 🔹 Update User
  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    try {
      await usersCollection.doc(uid).update(updates);
    } catch (e) {
      throw Exception("Error updating user: $e");
    }
  }

  /// 🔹 Delete User
  Future<void> deleteUser(String uid) async {
    try {
      await usersCollection.doc(uid).delete();
    } catch (e) {
      throw Exception("Error deleting user: $e");
    }
  }
}
