import 'package:flutter/material.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';

import '../../../size_config.dart';
import '../../profile_user/profile_user_screen.dart';
import 'profile_user_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Body extends StatelessWidget {
  Future<Map<String, dynamic>> getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(user!.uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getUserData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> userData = snapshot.data!;

            return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 35),
                      Center(
                        child: ProfilePic(),
                      ),
                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: getProportionateScreenWidth(20)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  userData['username'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black),
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        userData['rating'],
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  userData['email'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  userData['address'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  userData['phoneNumber'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ])),
                    ]));
          } else {
            // User is not signed in
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
