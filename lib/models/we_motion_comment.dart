import 'package:cloud_firestore/cloud_firestore.dart';

class WeMotionComment {
  final String commentId;        // Unique identifier for the comment
  final String userId;           // ID of the user who made the comment
  final String content;          // Text content of the comment
  final DateTime timestamp;      // Time when the comment was posted
  final String? parentId;        // ID of the parent comment, null if it's a root comment
  final List<WeMotionComment> replies;   // List of replies (child comments)

  WeMotionComment({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.timestamp,
    this.parentId,
    this.replies = const [],
  });

  // Factory constructor for creating a Comment instance from a Firestore jsonument
  factory WeMotionComment.fromJson(Map<String, dynamic> json) {
    return WeMotionComment(
      commentId: json['commentId'],
      userId: json['userId'],
      content: json['content'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      parentId: json['parentId'],
      replies: [], // Replies can be populated later
    );
  }

  // Method to convert a Comment instance to a Map for uploading to Firestore
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'content': content,
      'timestamp': timestamp,
      'parentId': parentId,
    };
  }
}
