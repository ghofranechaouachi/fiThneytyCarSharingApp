import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../models/NotificationItem.dart';

class NotificationBody extends StatelessWidget {
  final List<NotificationItem> notifications;

  const NotificationBody({required this.notifications, Key? key})
      : super(key: key);

  void acceptReservation(String notificationId, String reservationId,
      String adminId, String rideId) async {
    User? user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String userName = userData['username'];
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .update({'state': 'Accepted'})
        .then((value) => print('Reservation state updated'))
        .catchError(
            (error) => print('Failed to update reservation state: $error'));

    // Update the carseat value by subtracting 1
    await FirebaseFirestore.instance
        .collection('rides')
        .doc(rideId)
        .update({'carSeatCount': FieldValue.increment(-1)})
        .then((value) => print('carseat value updated'))
        .catchError((error) => print('Failed to update carseat value: $error'));

    final notification = {
      'reservationId':
          reservationId, // Store the reservation ID as an attribute in the notification
      'userId': userId,
      'adminId': adminId,
      'rideId': rideId,
      'title': 'Reservation Accepted',
      'subtitle': userName + ' has accept your reservation.',
      'time': DateTime.now(),
    };
    await FirebaseFirestore.instance
        .collection('notifications')
        .add(notification);
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  void refuseReservation(String notificationId, String reservationId,
      String adminId, String rideId) async {
    User? user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String userName = userData['username'];

    final notification = {
      'reservationId':
          reservationId, // Store the reservation ID as an attribute in the notification
      'userId': userId,
      'adminId': adminId,
      'rideId': rideId,
      'title': 'Reservation Rejected',
      'subtitle': userName + ' has reject your reservation.',
      'time': DateTime.now(),
    };
    await FirebaseFirestore.instance
        .collection('notifications')
        .add(notification);
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .delete();
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .delete();
  }

  void deleteNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: /*CircleAvatar(
                  backgroundImage: notifications[index].image != null
                      ? NetworkImage(notifications[index].image)
                      : _image != null
                          ? FileImage(_image!) as ImageProvider<Object>?
                          : AssetImage("assets/images/Profile Image.png"),
                ),*/
                    Icon(
                  Icons.notifications,
                  color: Colors.orangeAccent,
                ),
                title: Text(notifications[index].title),
                subtitle: Text(notifications[index].subtitle +
                    "\n" +
                    notifications[index].time.toString().substring(0, 10)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (notifications[index].title == "New Reservation") {
                          acceptReservation(
                              notifications[index].notificationId,
                              notifications[index].reservationId,
                              notifications[index].userId,
                              notifications[index].rideId);
                        } else {
                          deleteNotification(
                              notifications[index].notificationId);
                        }
                        // TODO: Handle accept button press
                      },
                      icon: Icon(Icons.check_circle_outline),
                      color: Colors.green,
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (notifications[index].title == "New Reservation") {
                          refuseReservation(
                              notifications[index].notificationId,
                              notifications[index].reservationId,
                              notifications[index].userId,
                              notifications[index].rideId);
                        } else {
                          deleteNotification(
                              notifications[index].notificationId);
                        }
                        // TODO: Handle deny button press
                      },
                      icon: Icon(Icons.cancel_outlined),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
