import 'package:flutter/material.dart';

import '../helper/my_date_util.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'user.name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('12pm'),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Icon(Icons.video_camera_back),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              label: const Text('Reply'),
              icon: const Icon(Icons.reply),
            ),
          ),
        ],
      ),
    );
  }
}
