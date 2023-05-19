import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/RideDetails.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class UserDescription extends StatefulWidget {
  final String userId;

  const UserDescription({required this.userId, Key? key}) : super(key: key);

  @override
  _UserDescriptionState createState() => _UserDescriptionState();
}

class _UserDescriptionState extends State<UserDescription> {
  late String _imageUrl;

  Future<Map<String, dynamic>> getUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(widget.userId).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    /*  FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference =
        storage.ref().child('user-profiles/${widget.userId}/profile.jpg');
    String downloadUrl = await reference.getDownloadURL();
    setState(() {
      _imageUrl = downloadUrl;
    });
*/
    return userData;
  }

  @override
  void initState() {
    super.initState();
    _imageUrl = '';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference =
        storage.ref().child('user-profiles/${widget.userId}/profile.jpg');
    reference.getDownloadURL().then((url) {
      setState(() {
        _imageUrl = url;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(180),
                              child: _imageUrl.isEmpty
                                  ? CircularProgressIndicator()
                                  : Image.network(
                                      _imageUrl,
                                      width: getProportionateScreenWidth(150),
                                      height: getProportionateScreenWidth(150),
                                      fit: BoxFit.cover,
                                    ),
                            ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
            })
        // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
        );
  }
}
