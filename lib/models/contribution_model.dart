
class ContributionModel {
  String? id;
  String userUid; // Reference to the user via uid
  double amount;
  String contribDate;

  ContributionModel( {
    this.id,
    required this.userUid,     
    required this.amount,
    required this.contribDate,
  });

   Map<String, dynamic> toJson() {
    return {
      "userUid": userUid,
      "amount": amount,
      "contribDate": contribDate,
    };
  }

  // Create model from Firestore document
  factory ContributionModel.fromJson(Map<String, dynamic> json) {
    return ContributionModel(
      id: json["id"],
      userUid: json["userUid"],
      amount: (json["amount"] as num).toDouble(), // Ensure correct type
      contribDate: json["contribDate"],
    );
  }
  
  
}



