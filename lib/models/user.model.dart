import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String description;

  // Constructor with default values
  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.description = '',
  });

  // From DocumentSnapshot (Firebase)
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      description: doc['description'] ?? '',
    );
  }

  // From Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      description: map['description'] ?? '',
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'description': description,
    };
  }
}
