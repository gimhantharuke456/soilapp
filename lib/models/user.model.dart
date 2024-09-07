import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String description;
  final String phoneNumber;
  final String city;
  bool isExpert;

  // Constructor with default values
  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.description = '',
    required this.phoneNumber,
    required this.city,
    this.isExpert = false,
  });

  set setIsExpert(bool value) => isExpert = value;

  // From DocumentSnapshot (Firebase)
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel(
        id: doc.id,
        name: doc['name'] ?? '',
        email: doc['email'] ?? '',
        description: doc['description'] ?? '',
        city: doc["city"] ?? '',
        phoneNumber: doc["phoneNumber"] ?? '',
        isExpert: doc['isExpert'] ?? false);
  }

  // From Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        description: map['description'] ?? '',
        city: map['city'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        isExpert: map['isExpert'] ?? false);
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'description': description,
      'phoneNumber': phoneNumber,
      'city': city,
      'isExpert': isExpert,
    };
  }
}
