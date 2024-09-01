import 'package:flutter/material.dart';

import 'package:soilapp/models/comment.model.dart';
import 'package:soilapp/services/comment.service.dart';

class CommentListWidget extends StatelessWidget {
  final String postId;
  final CommentService _commentService = CommentService();

  CommentListWidget({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentModel>>(
      stream: _commentService.getCommentsByPostId(postId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final comments = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(comments[index].comment),
              subtitle: Text('By: ${comments[index].commentedBy}'),
            );
          },
        );
      },
    );
  }
}
