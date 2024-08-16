import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_we_motion/apis/apis.dart';
import 'package:flutter_we_motion/helper/dialogs.dart';
import 'package:flutter_we_motion/pages/video_player_page.dart';
import 'package:flutter_we_motion/widgets/we_motion_video_player.dart';
import 'package:image_picker/image_picker.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? _video;
  final TextEditingController _titleController = TextEditingController();

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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: _video != null ? () async {
                Dialogs.showProgressBar(context);
                await APIs.sendVideo(APIs.me, File(_video.toString()), _titleController.text);
                Navigator.pop(context);
                Navigator.pop(context);
              } : null,
              style: TextButton.styleFrom(
                disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey,
                  foregroundColor: Colors.white, backgroundColor: Colors.blue),
              child: const Text('Post'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _titleController,
              maxLength: 300,
              maxLines: null,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _video != null ? WeMotionVideoPlayer(shouldPlay: true, uri: _video.toString(), onTap: () {
            setState(() {
              _video = null;
            });
          },) : const SizedBox(),
          const Spacer(),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.video_call),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? galleryVideo =
                  await picker.pickVideo(source: ImageSource.gallery);
                  setState(() {
                    if(galleryVideo != null) {
                      _video = galleryVideo.path;
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
