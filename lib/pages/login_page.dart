import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../apis/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import 'bottom_nav_bar_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //handle google login button click
  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {

      if(user != null) {
        if((await APIs.userExists())) {
          //for hiding progress bar
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BottomNavBarPage()),
          );
        } else {
          await APIs.createUser().then((value) {
            //for hiding progress bar
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BottomNavBarPage()),
            );
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      try {
        await InternetAddress.lookup('google.com');
      } catch (e) {
        log('\n_InternetAddress: $e');
      }
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      if(context.mounted) {
        Dialogs.showSnackBar(context, 'Something went wrong (Check Internet!)');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Welcome to We Chat'),
      ),

      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            left: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('assets/images/icon.png'),
          ),

          //google login button
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 223, 255, 187),
                shape: const StadiumBorder(),
                elevation: 1,
              ),

              onPressed: () {
                _handleGoogleBtnClick();
              },

              ///google icon
              icon: Image.asset(
                'assets/images/google.png',
                height: mq.height * .03,
              ),

              //login with google label
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(text: 'Login with '),
                    TextSpan(
                      text: 'Google',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
