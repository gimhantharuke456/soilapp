import 'package:flutter/material.dart';
import 'package:soilapp/models/comment.model.dart';
import 'package:soilapp/services/comment.service.dart';
import 'package:soilapp/utils/index.dart';
import 'package:soilapp/widgets/custom.input.field.dart';

class CommentContainer extends StatefulWidget {
  final String postId;
  final List<CommentModel> comments;
  const CommentContainer(
      {Key? key, required this.postId, required this.comments})
      : super(key: key);

  @override
  _CommentContainerState createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer> {
  final CommentService _commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<CommentModel> topLevelComments = widget.comments
        .where((comment) => comment.parentCommentId == null)
        .toList();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topLevelComments.length,
            itemBuilder: (context, index) {
              return _buildCommentItem(topLevelComments[index]);
            },
          ),
        ),
        _buildCommentInput(null),
      ],
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    List<CommentModel> replies =
        widget.comments.where((c) => c.parentCommentId == comment.id).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Image.network(
                width: 24,
                height: 24,
                'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png'),
            title: Text(comment.commentedBy),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.comment),
                Text(
                  '${comment.commentedAt.formatTime()} ${comment.commentedAt.formatDate()}',
                  style: const TextStyle(
                    fontSize: 8,
                  ),
                )
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.reply),
              onPressed: () => _showReplyInput(comment.id!),
            ),
          ),
          if (replies.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 32.0),
              child: Divider(),
            ),
          if (replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children:
                    replies.map((reply) => _buildCommentItem(reply)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(String? parentCommentId) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomInputField(
              label: '',
              hint: parentCommentId == null
                  ? 'Add a comment...'
                  : 'Add a reply...',
              controller: _commentController,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => _submitComment(parentCommentId),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _submitComment(parentCommentId),
          ),
        ],
      ),
    );
  }

  void _showReplyInput(String parentCommentId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _buildCommentInput(parentCommentId),
            ),
          ],
        );
      },
      isScrollControlled: true,
    );
  }

  void _submitComment(String? parentCommentId) async {
    if (_commentController.text.isNotEmpty) {
      CommentModel newComment = CommentModel(
        postId: widget.postId,
        comment: _commentController.text,
        parentCommentId: parentCommentId,
        commentedBy: 'Current User', // Replace with actual user data
      );

      await _commentService.createComment(newComment);
      _commentController.clear();
      if (parentCommentId != null) {
        Navigator.pop(context); // Close the reply input bottom sheet
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
