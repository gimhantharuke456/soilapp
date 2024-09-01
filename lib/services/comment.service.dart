import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soilapp/models/comment.model.dart';

class CommentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath = 'comments';

  // Get all comments as a stream
  Stream<List<CommentModel>> getAllComments() {
    try {
      return _db.collection(collectionPath).snapshots().map((snapshot) =>
          snapshot.docs
              .map((doc) => CommentModel.fromDocumentSnapshot(doc))
              .toList());
    } catch (e) {
      print('Error getting comments: $e');
      return Stream.empty();
    }
  }

  // Get comments by postId as a stream
  Stream<List<CommentModel>> getCommentsByPostId(String postId) {
    try {
      return _db
          .collection(collectionPath)
          .where('postId', isEqualTo: postId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CommentModel.fromDocumentSnapshot(doc))
              .toList());
    } catch (e) {
      print('Error getting comments by postId: $e');
      return Stream.empty();
    }
  }

  // Create a new comment
  Future<void> createComment(CommentModel comment) async {
    try {
      await _db.collection(collectionPath).add(comment.toMap());
    } catch (e) {
      print('Error creating comment: $e');
    }
  }

  // Update a comment
  Future<void> updateComment(CommentModel comment) async {
    try {
      await _db
          .collection(collectionPath)
          .doc(comment.id)
          .update(comment.toMap());
    } catch (e) {
      print('Error updating comment: $e');
    }
  }

  // Delete a comment
  Future<void> deleteComment(String id) async {
    try {
      await _db.collection(collectionPath).doc(id).delete();
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }
}
