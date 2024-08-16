import 'package:flutter/material.dart';
import 'package:flutter_we_motion/models/we_motion_user.dart';
import 'package:flutter_we_motion/models/we_motion_video.dart';
import 'package:flutter_we_motion/pages/comment_page.dart';
import 'package:flutter_we_motion/widgets/we_motion_video_player.dart';

import '../helper/my_date_util.dart';

class HomePageCard extends StatelessWidget {
  const HomePageCard({
    super.key,
    required this.video,
    required this.user, this.shouldNavigate,
  });

  final WeMotionVideo video;
  final WeMotionUser user;
  final bool? shouldNavigate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: shouldNavigate != null && shouldNavigate == true ? () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommentPage(video: video, user: user),
        ),
      ) : null,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CircleAvatar(
                      child: Image.network(user.image),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(MyDateUtil.getFormattedTime(
                      context: context, time: video.uploadTime)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                video.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            WeMotionVideoPlayer(
              uri: video.videoUrl,
              onTap: () {},
            ),
            Row(
              children: [
                Card(
                  shape: const StadiumBorder(),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        label: Text(video.likeCount.toString()),
                        icon: const Icon(Icons.arrow_upward),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.arrow_downward),
                        label: Text(video.dislikeCount.toString()),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Card(
                  shape: const StadiumBorder(),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        label: Text(video.commentCount.toString()),
                        icon: const Icon(
                          Icons.comment,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
