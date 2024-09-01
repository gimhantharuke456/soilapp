import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String? id;
  final String postId;
  final String comment;
  final String? parentCommentId;
  final String commentedBy;
  final DateTime commentedAt;

  // Constructor with default values
  CommentModel({
    this.id,
    required this.postId,
    required this.comment,
    this.parentCommentId,
    required this.commentedBy,
    DateTime? commentedAt,
  }) : commentedAt = commentedAt ?? DateTime.now();

  // From DocumentSnapshot (Firebase)
  factory CommentModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return CommentModel(
      id: doc.id,
      postId: doc['postId'] ?? '',
      comment: doc['comment'] ?? '',
      parentCommentId: doc['parentCommentId'],
      commentedBy: doc['commentedBy'] ?? '',
      commentedAt: doc['commentedAt'] != null
          ? (doc['commentedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // From Map
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      postId: map['postId'] ?? '',
      comment: map['comment'] ?? '',
      parentCommentId: map['parentCommentId'],
      commentedBy: map['commentedBy'] ?? '',
      commentedAt: map['commentedAt'] != null
          ? (map['commentedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'comment': comment,
      'parentCommentId': parentCommentId,
      'commentedBy': commentedBy,
      'commentedAt': commentedAt,
    };
  }
}
