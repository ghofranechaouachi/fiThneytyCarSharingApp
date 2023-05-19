import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../models/NotificationItem.dart';
import 'notification_body.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "/notifications";

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  void getNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await firestore
        .collection('notifications')
        .where('adminId', isEqualTo: userId)
        .get();

    setState(() {
      notifications = snapshot.docs.map((document) {
        return NotificationItem(
          notificationId: document.id,
          adminId: document['adminId'],
          reservationId: document['reservationId'],
          rideId: document['rideId'],
          userId: document['userId'],
          title: document['title'],
          subtitle: document['subtitle'],
          time: document['time'].toDate(),
        );
      }).toList();
    });
    // Set up a listener for real-time updates
    firestore
        .collection('notifications')
        .where('adminId', isEqualTo: userId)
        .snapshots()
        .listen((querySnapshot) {
      setState(() {
        notifications = querySnapshot.docs.map((document) {
          return NotificationItem(
            notificationId: document.id,
            adminId: document['adminId'],
            reservationId: document['reservationId'],
            rideId: document['rideId'],
            userId: document['userId'],
            title: document['title'],
            subtitle: document['subtitle'],
            time: document['time'].toDate(),
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: NotificationBody(notifications: notifications),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(
            "Your Notifications",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
