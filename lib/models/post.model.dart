import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? id;
  final String title;
  final String description;
  final String? imageUrl;
  final String category;
  final String posedBy;
  final DateTime postedAt;
  int likeCount;

  // Constructor with default values
  PostModel({
    this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.posedBy,
    required this.postedAt,
    this.likeCount = 0,
  });
  set setLikeCount(int count) => likeCount = count;
  // From DocumentSnapshot (Firebase)
  factory PostModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return PostModel(
      id: doc.id,
      title: doc['title'] ?? '',
      description: doc['description'] ?? '',
      imageUrl: doc['imageUrl'],
      category: doc['category'] ?? '',
      posedBy: doc['posedBy'] ?? '',
      postedAt: (doc['postedAt'] as Timestamp).toDate(),
      likeCount: doc['likeCount'] ?? 0,
    );
  }

  // From Map
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      category: map['category'] ?? '',
      posedBy: map['posedBy'] ?? '',
      postedAt: (map['postedAt'] as Timestamp).toDate(),
      likeCount: map['likeCount'] ?? 0,
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'posedBy': posedBy,
      'postedAt': postedAt,
      'likeCount': likeCount,
    };
  }
}
