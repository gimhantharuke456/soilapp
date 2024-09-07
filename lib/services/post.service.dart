import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soilapp/models/post.model.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath = 'posts';

  // Get all posts as a stream
  Stream<List<PostModel>> getAllPosts(String category) {
    try {
      return _db
          .collection(collectionPath)
          .where("category", isEqualTo: category)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => PostModel.fromDocumentSnapshot(doc))
              .toList());
    } catch (e) {
      print('Error getting posts: $e');
      return Stream.empty();
    }
  }

  // Create a new post
  Future<void> createPost(PostModel post) async {
    try {
      await _db.collection(collectionPath).add(post.toMap());
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  // Update a post
  Future<void> updatePost(PostModel post) async {
    try {
      await _db.collection(collectionPath).doc(post.id).update(post.toMap());
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  // Delete a post
  Future<void> deletePost(String id) async {
    try {
      await _db.collection(collectionPath).doc(id).delete();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }
}
