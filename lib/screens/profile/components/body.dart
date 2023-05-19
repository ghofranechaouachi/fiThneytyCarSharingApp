import 'package:flutter/material.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/home/components/notification_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import '../../profile_user/profile_user_screen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Body extends StatelessWidget {
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () =>
                {Navigator.pushNamed(context, ProfileUserScreen.routeName)},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () =>
                {Navigator.pushNamed(context, NotificationScreen.routeName)},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () =>
                {Navigator.pushNamed(context, CompleteProfileScreen.routeName)},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              _logout();
              Navigator.pushNamed(context, SignInScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
