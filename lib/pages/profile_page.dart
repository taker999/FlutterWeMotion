import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../apis/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/we_motion_user.dart';
import 'login_page.dart';

// profile screen -- to show signed in user info
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});

  final WeMotionUser user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // app bar
        appBar: AppBar(
          title: const Text('Profile'),
        ),

        // floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              // for showing progress dialog
              Dialogs.showProgressBar(context);

              // sign out from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  // for hiding progress dialog
                  Navigator.pop(context);

                  // for moving to home screen
                  Navigator.pop(context);

                  APIs.auth = FirebaseAuth.instance;

                  // replacing home screen with login screen
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                });
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),

        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(width: mq.width, height: mq.height * .03),

                  // user profile pic
                  Stack(
                    children: [
                      // profile picture
                      _image != null
                          ?
                      // local image
                      InstaImageViewer(
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(mq.height * .1),
                          child: Image.file(
                            File(_image!),
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          :
                      // image from server
                      InstaImageViewer(
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(mq.height * .1),
                          child: CachedNetworkImage(
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover,
                            imageUrl: widget.user.image,
                            placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                            const CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                          ),
                        ),
                      ),

                      // edit image button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),

                  // for adding some space
                  SizedBox(height: mq.height * .03),

                  // user email label
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),

                  // for adding some space
                  SizedBox(height: mq.height * .05),

                  // name input field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Happy Singh',
                      label: const Text('Name'),
                    ),
                  ),

                  //for adding some space
                  SizedBox(height: mq.height * .05),

                  // update profile button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const StadiumBorder(),
                        minimumSize: Size(mq.width * .4, mq.height * .06)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackBar(
                              context, 'Profile Updated Successfully!');
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 28,
                    ),
                    label: const Text(
                      'UPDATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              // pick profile picture label
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),

              // for adding some space
              SizedBox(
                height: mq.height * .02,
              ),

              // buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(mq.width * .3, mq.height * .15),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          // for hiding bottom sheet
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image.png')),

                  // take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(mq.width * .3, mq.height * .15),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Capture a photo.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          // for hiding bottom sheet
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              ),
            ],
          );
        });
  }
}
