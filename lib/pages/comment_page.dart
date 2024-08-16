import 'package:flutter/material.dart';
import 'package:flutter_we_motion/widgets/home_page_card.dart';

import '../main.dart';
import '../models/we_motion_user.dart';
import '../models/we_motion_video.dart';
import '../widgets/comment card.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({super.key, required this.video, required this.user});

  final WeMotionVideo video;
  final WeMotionUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HomePageCard(shouldNavigate: false, video: video, user: user),
              ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: mq.height*.1),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return const CommentCard();
                    },
                    childCount: 5, // Number of comments
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'Add a comment',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
