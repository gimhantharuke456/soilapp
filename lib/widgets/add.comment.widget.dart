import 'package:flutter/material.dart';

import 'package:soilapp/models/comment.model.dart';
import 'package:soilapp/services/comment.service.dart';

class AddCommentWidget extends StatefulWidget {
  final String postId;

  const AddCommentWidget({Key? key, required this.postId}) : super(key: key);

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final TextEditingController _controller = TextEditingController();
  final CommentService _commentService = CommentService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Add a comment',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                await _commentService.createComment(
                  CommentModel(
                    postId: widget.postId,
                    comment: _controller.text,
                    commentedBy: 'Anonymous', // Replace with actual user name
                  ),
                );
                _controller.clear();
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
