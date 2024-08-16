import 'package:flutter/material.dart';
import 'package:flutter_we_motion/apis/apis.dart';
import 'package:flutter_we_motion/models/we_motion_video.dart';
import 'package:flutter_we_motion/widgets/home_page_card.dart';

import '../models/we_motion_user.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<WeMotionVideo> _videoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeMotion'),
      ),
      body: StreamBuilder(
        stream: APIs.getAllVideos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const SizedBox();

            // if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              _videoList = data
                      ?.map((e) => WeMotionVideo.fromJson(e.data()))
                      .toList() ??
                  [];

              if (_videoList.isNotEmpty) {
                return ListView.builder(
                  itemCount: _videoList.length,
                  itemBuilder: (context, index) {
                    WeMotionVideo currentVideo = _videoList[index];

                    return FutureBuilder(
                      future: APIs.getUserByUserId(currentVideo.userId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(); // or a loading indicator
                        } else if (userSnapshot.connectionState ==
                            ConnectionState.done) {
                          if (userSnapshot.hasData &&
                              userSnapshot.data != null) {
                            final userData = userSnapshot.data?.data();
                            WeMotionUser user =
                                WeMotionUser.fromJson(userData!);

                            return HomePageCard(
                              shouldNavigate: true,
                              video: currentVideo,
                              user: user,
                            );
                          } else {
                            return const SizedBox(); // Handle case where user data is not available
                          }
                        } else {
                          return const SizedBox(); // Handle any other states if necessary
                        }
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'Say Hi! 👋',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
