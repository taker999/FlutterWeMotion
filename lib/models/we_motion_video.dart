import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_we_motion/models/we_motion_comment.dart';

class WeMotionVideo {
  final String videoId;        // Unique identifier for the video
  final String userId;         // ID of the user who uploaded the video
  final String videoUrl;       // URL where the video is stored
  final String title;          // Title of the video
  final String uploadTime;       // Number of views the video has received
  final int likeCount;         // Number of likes the video has received
  final int dislikeCount;         // Number of likes the video has received
  final int commentCount;      // Whether the video has been flagged for inappropriate content
  final List<WeMotionComment> comments;   // List of root-level comments (i.e., the start of the comment tree)

  WeMotionVideo({
    required this.videoId,
    required this.userId,
    required this.videoUrl,
    required this.title,
    required this.uploadTime,
    required this.likeCount,
    required this.dislikeCount,
    required this.commentCount,
    this.comments = const [],
  });

  // Factory constructor for creating a Video instance from a Firestore
  factory WeMotionVideo.fromJson(Map<String, dynamic> json) {
    return WeMotionVideo(
      videoId: json['videoId'],
      userId: json['userId'],
      videoUrl: json['videoUrl'],
      title: json['title'],
      uploadTime: json['uploadTime'],
      likeCount: json['likeCount'],
      dislikeCount: json['dislikeCount'],
      commentCount: json['commentCount'],
        comments: (json['comments'] as List<dynamic>)
            .map((comment) => WeMotionComment.fromJson(comment))
            .toList(),
    );
  }

  // Method to convert a Video instance to a Map for uploading to Firestore
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'userId': userId,
      'videoUrl': videoUrl,
      'title': title,
      'uploadTime': uploadTime,
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
      'commentCount': commentCount,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
