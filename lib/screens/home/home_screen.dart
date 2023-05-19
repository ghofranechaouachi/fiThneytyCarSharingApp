import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/body.dart';
import 'components/icon_btn_with_counter.dart';
import 'components/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<QuerySnapshot> notificationStream;
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    notificationStream = getNotificationStream();
  }

  Stream<QuerySnapshot> getNotificationStream() {
    User? user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<QuerySnapshot> stream = firestore
        .collection('notifications')
        .where('adminId', isEqualTo: userId)
        .snapshots();

    return stream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: notificationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          notificationCount = snapshot.data!.docs.length;
        }

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            child: customBar(context, notificationCount),
          ),
          body: Body(),
          bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        );
      },
    );
  }
}

SafeArea customBar(BuildContext context, int notificationCount) {
  return SafeArea(
    child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: getProportionateScreenWidth(60),
            width: getProportionateScreenWidth(40),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                foregroundColor: kPrimaryColor,
                backgroundColor: Colors.white,
                padding: EdgeInsets.zero,
              ),
              onPressed: () => Navigator.pop(context),
              child: SvgPicture.asset(
                "assets/icons/Back ICon.svg",
                height: 15,
              ),
            ),
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: notificationCount,
            press: () =>
                Navigator.pushNamed(context, NotificationScreen.routeName),
          ),
        ],
      ),
    ),
  );
}
