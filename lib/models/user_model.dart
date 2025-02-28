
class UserModel {
  String? uid;
  final String? name;
  final String? email;
  String? password;
  final String? dob;
  final String? address;
  final String? role;
  String? profileImage; // this data type will be changed to File for mobile

  UserModel({
    this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.dob,
    required this.address,
    required this.role,
    this.profileImage,
  });

  // Convert model to a map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'dob': dob,
      'address': address,
      'role': role,
      'profileImage': profileImage,
    };
  }

  // Create a model from Firestore document snapshot
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      dob: json['dob'] ?? '',
      address: json['address'] ?? '',
      role: json['userType'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
