import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_we_motion/models/we_motion_video.dart';

import '../models/we_motion_user.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firestore storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // to return current user
  static User get user => auth.currentUser!;

  // for storing self information
  static late WeMotionUser me;

  // for checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for creating a new user
  static Future<void> createUser() async {
    final weMotionUser = WeMotionUser(
      id: user.uid,
      image: user.photoURL.toString(),
      name: user.displayName.toString(),
      email: user.email.toString(),
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(weMotionUser.toJson());
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = WeMotionUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
    });
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    // getting image file extension
    final ext = file.path.split('.').last;

    // storing file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    // uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    // updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  // for posting video
  static Future<void> postVideo(
      WeMotionUser weMotionUser, String videoUrl, String title) async {
    // message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final docRef = firestore
        .collection('videos/').doc();

    // message to send
    final weMotionVideo = WeMotionVideo(
      videoId: docRef.id,
      userId: weMotionUser.id,
      videoUrl: videoUrl,
      title: title,
      uploadTime: time,
      likeCount: 0,
      dislikeCount: 0,
      commentCount: 0,
    );

    await docRef.set(weMotionVideo.toJson());
  }

  // post video
  static Future<void> sendVideo(WeMotionUser weMotionUser, File file, String title) async {
    // getting image file extension
    final ext = file.path.split('.').last;

    // storing file ref with path
    final ref = storage.ref().child(
        'videos/${weMotionUser.id}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'video/$ext'));

    // updating image in firestore database
    final videoUrl = await ref.getDownloadURL();
    await postVideo(weMotionUser, videoUrl, title);
  }

  // for getting all videos from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllVideos() {
    return firestore
        .collection('videos/')
        .orderBy('likeCount', descending: true)
        .snapshots();
  }

  // for getting typing status of a specific user from firestore database
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserByUserId(
      String id) {
    return firestore
        .collection('users')
        .doc(id)
        .get();
  }
}
