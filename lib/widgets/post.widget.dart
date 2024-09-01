import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soilapp/models/comment.model.dart';
import 'package:soilapp/models/post.model.dart';
import 'package:soilapp/models/user.model.dart';
import 'package:soilapp/services/app.user.service.dart';
import 'package:soilapp/services/comment.service.dart';
import 'package:soilapp/services/post.service.dart';
import 'package:soilapp/widgets/comment.container.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  final PostModel post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CommentService commentService = CommentService();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            post.posedBy == 'Anonymous'
                ? Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                        radius: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.posedBy,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              timeago.format(post.postedAt),
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : FutureBuilder<UserModel?>(
                    future: UserService().getUserById(post.posedBy),
                    builder: (context, AsyncSnapshot<UserModel?> snapshot) {
                      return Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                            radius: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data?.name ?? 'Anonymous',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  timeago.format(post.postedAt),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
            const SizedBox(height: 12),
            Text(
              post.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(post.description),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                post.category,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ],
            const SizedBox(height: 8),
            StreamBuilder<List<CommentModel>>(
                stream: commentService.getCommentsByPostId(post.id ?? ''),
                builder: (context, AsyncSnapshot<List<CommentModel>> snapshot) {
                  return Row(
                    children: [
                      InkWell(
                        onTap: likePost,
                        child: Icon(Icons.thumb_up_outlined,
                            size: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likeCount}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          onCommentClick(context, snapshot.data ?? []);
                        },
                        child: Icon(Icons.comment_outlined,
                            size: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${snapshot.data?.length}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      if (post.posedBy ==
                          FirebaseAuth.instance.currentUser?.uid)
                        Icon(Icons.more_horiz, color: Colors.grey[600]),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  void onCommentClick(BuildContext context, List<CommentModel> comments) {
    showBottomSheet(
        context: context,
        builder: (context) => CommentContainer(
              comments: comments,
              postId: post.id ?? '',
            ));
  }

  void likePost() {
    PostModel currentPost = post;
    currentPost.setLikeCount = post.likeCount + 1;
    PostService().updatePost(currentPost);
  }
}
