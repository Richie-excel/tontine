import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tontine/models/contribution_model.dart';
import 'package:tontine/models/user_model.dart';

class ContributionViewModel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage store = FirebaseStorage.instance;
  
  final CollectionReference contribRef = FirebaseFirestore.instance.collection('contributions');

  Future<UserModel?> fetchUserDetails(UserModel user) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching user details: $e");
    }
  }

  Future<String> addContribution(ContributionModel contribution) async {
  try {
    DocumentReference docRef = await contribRef.add(contribution.toJson());
    return docRef.id; // Return generated document ID
  } catch (e) {
    throw Exception("Error adding contribution: $e");
  }
}

  /// 🔹 Read (Fetch) a contribution by ID
  Future<ContributionModel?> getContribution(String id) async {
    try {
      DocumentSnapshot doc = await contribRef.doc(id).get();
      if (doc.exists) {
        return ContributionModel.fromJson(
            doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching contribution: $e");
    }
  }

  /// 🔹 Read (Fetch) all contributions for a specific user
  Future<List<ContributionModel>> getUserContributions(String userUid) async {
    try {
      QuerySnapshot querySnapshot = await contribRef
          .where("userUid", isEqualTo: userUid)
          .get();

      return querySnapshot.docs.map((doc) {
        return ContributionModel.fromJson(
            doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception("Error fetching user contributions: $e");
    }
  }

  /// 🔹 Read (Fetch) all contributions
  Future<List<ContributionModel>> getAllContributions() async {
    try {
      QuerySnapshot querySnapshot = await contribRef.get();

      return querySnapshot.docs.map((doc) {
        return ContributionModel.fromJson(
            doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception("Error fetching all contributions: $e");
    }
  }

  /// 🔹 Update a contribution
  Future<void> updateContribution(
      String id, ContributionModel updatedContribution) async {
    try {
      await contribRef
          .doc(id)
          .update(updatedContribution.toJson());
    } catch (e) {
      throw Exception("Error updating contribution: $e");
    }
  }

  /// 🔹 Delete a contribution
  Future<void> deleteContribution(String id) async {
    try {
      await contribRef.doc(id).delete();
    } catch (e) {
      throw Exception("Error deleting contribution: $e");
    }
  }
}
