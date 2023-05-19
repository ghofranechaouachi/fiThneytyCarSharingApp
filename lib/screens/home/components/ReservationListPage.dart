import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/models/Applyuser.dart';
import 'package:shop_app/models/RideDetails.dart';
import 'package:shop_app/screens/search_ride/Components/userDescription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';
import '../../../models/Reservation.dart';
/*
class ReservationListPage extends StatelessWidget {
  final String rideId;

  ReservationListPage({required this.rideId});

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
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserDescription(userId: "rxwAETy5ArMHMUmjakilz5bbGpF2"),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          child: Icon(Icons.account_circle_rounded,
                              color: Colors.white)
                          /*Text(
                  "JD",
                  style: TextStyle(color: Colors.white),
                ),*/
                          ),
                      title: Text(
                        "ghofrane",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
          );

          // Display other relevant information about the user's reservation
        },
      ),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
*/

class ReservationListPage extends StatefulWidget {
  final String rideId;

  ReservationListPage({required this.rideId});
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  late Stream<List<ApplyUsers>> myApplyStream;

  @override
  void initState() {
    super.initState();
    myApplyStream = getUsers();
  }

  Stream<List<ApplyUsers>> getUsers() {
    return FirebaseFirestore.instance
        .collection('reservations')
        .where('rideId', isEqualTo: widget.rideId)
        .snapshots()
        .asyncMap((snapshot) async {
      final List<ApplyUsers> applyUsersList = [];
      for (QueryDocumentSnapshot resDoc in snapshot.docs) {
        Map<String, dynamic> data = resDoc.data() as Map<String, dynamic>;
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(data["userId"])
            .get();
        ReservationState state = ReservationState.Pending;
        if (data["state"] == "Pending") {
          state = ReservationState.Pending;
        } else if (data["state"] == "Completed") {
          state = ReservationState.Completed;
        } else if (data["state"] == "Accepted") {
          state = ReservationState.Accepted;
        } else if (data["state"] == "Rejected") {
          state = ReservationState.Rejected;
        }

        ApplyUsers apply = ApplyUsers(
          adminId: data["adminId"],
          idReservation: resDoc.id,
          userId: data["userId"],
          userName: userSnapshot["username"],
          status: state,
        );

        applyUsersList.add(apply);
      }
      return applyUsersList;
    });
  }

  /* List<ApplyUsers> myApply = [];

  Future<List<ApplyUsers>> getUsers() async {
    final List<ApplyUsers> applyUsersList = [];
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('reservations')
        .where('rideId', isEqualTo: widget.rideId)
        .get();
    print(widget.rideId);
    for (QueryDocumentSnapshot resDoc in snapshot.docs) {
      Map<String, dynamic> data = resDoc.data() as Map<String, dynamic>;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(data["userId"])
          .get();
      ReservationState state = ReservationState.Pending;
      if (data["state"] == "Pending") {
        state = ReservationState.Pending;
      } else if (data["state"] == "Completed") {
        state = ReservationState.Completed;
      } else if (data["state"] == "Accepted") {
        state = ReservationState.Accepted;
      } else if (data["state"] == "Rejected") {
        state = ReservationState.Rejected;
      }

      ApplyUsers apply = ApplyUsers(
        adminId: data["adminId"],
        idReservation: resDoc.id,
        userId: data["userId"],
        userName: userSnapshot["username"],
        status: state,
      );

      applyUsersList.add(apply);
    }
    return applyUsersList;
  }

  @override
  void initState() {
    super.initState();
    getUsers().then((list) {
      setState(() {
        myApply = list;
      });
    });
  }
*/
  void refuseReservation(
      String reservationId, String adminId, String rideId) async {
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
        .collection('reservations')
        .doc(reservationId)
        .delete();
  }

  void acceptReservation(
      String reservationId, String adminId, String rideId) async {
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
  }

/*
  Future<List<ApplyUsers>> getUsers() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('reservations')
        .where('rideId', isEqualTo: rideId)
        .get();

    final List<ApplyUsers> applyUsersList = snapshot.docs.map((document) {
      QuerySnapshot username = await firestore
        .collection('users')
        .where(doc.id, isEqualTo:document["userId"] )
        .get();
      return ApplyUsers(
          adminId: document['adminId'],
          idReservation: document['reservationId'],
          userId: document['userId'],
          userName: username,
          status: ReservationState.Accepted);
    }).toList();

    return applyUsersList;
  }
*/
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
      body: StreamBuilder<List<ApplyUsers>>(
        stream: myApplyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final List<ApplyUsers> applyUsersList = snapshot.data!;
            return ListView.builder(
              itemCount: applyUsersList.length,
              itemBuilder: (context, index) {
                final ApplyUsers applyuser = applyUsersList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserDescription(userId: applyuser.userId),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: kPrimaryColor,
                              child: Icon(
                                Icons.account_circle_rounded,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              applyuser.userName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                if (applyuser.status ==
                                    ReservationState.Accepted)
                                  Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                if (applyuser.status ==
                                    ReservationState.Accepted)
                                  SizedBox(width: 5),
                                if (applyuser.status ==
                                    ReservationState.Accepted)
                                  Text(
                                    "Accepted",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                  ),
                                if (applyuser.status ==
                                    ReservationState.Pending)
                                  Icon(
                                    Icons.pending,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                SizedBox(width: 5),
                                if (applyuser.status ==
                                    ReservationState.Pending)
                                  Text(
                                    "Pending",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          /* Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),*/
                          if (applyuser.status == ReservationState.Pending)
                            ListTile(
                              trailing: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      acceptReservation(applyuser.idReservation,
                                          applyuser.adminId, widget.rideId);
                                      // TODO: Handle accept button press
                                    },
                                    icon: Icon(Icons.check_circle_outline),
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () {
                                      refuseReservation(applyuser.idReservation,
                                          applyuser.adminId, widget.rideId);
                                    },
                                    icon: Icon(Icons.cancel_outlined),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No reservations found for the specified ride.'),
            );
          }
        },
      ),
    );
  }
}
