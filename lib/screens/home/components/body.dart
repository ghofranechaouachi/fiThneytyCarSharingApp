import 'package:flutter/material.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/models/Reservation.dart';
import 'package:shop_app/models/RideDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../size_config.dart';

import 'ride_card.dart';

// ignore: must_be_immutable
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Reservation> myReservations = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late FirebaseAuth auth;
  late User user;
  late String userId;

  Stream<List<Reservation>> getReservationsStream() {
    return firestore
        .collection("reservations")
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((reservationDoc) {
        Map<String, dynamic> data =
            reservationDoc.data() as Map<String, dynamic>;

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

        Reservation reservationDetails = Reservation(
          idReservation: reservationDoc.id,
          adminId: data["adminId"],
          departurePoint: data["ridedeparturePoint"],
          destinationPoint: data["ridedestinationPoint"],
          startTime: data["ride"],
          endTime: data["rideendTime"],
          dayTime: data["ridedayTime"].toDate(),
          status: state,
        );
        return reservationDetails;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser!;
    userId = user.uid;
    getReservationsStream().listen((list) {
      setState(() {
        myReservations = list;
        print("hiiiiiiiiii");
        print(myReservations);
      });
    });
    getRidesFromFirestore().then((list) {
      setState(() {
        myRides = list;

        print("hiiiiiiiiii");
        print(myRides);
      });
    });
  }

  List<RideDetails> myRides = [];
  Future<List<RideDetails>> getRidesFromFirestore() async {
    List<RideDetails> rideDetailsList = [];
    QuerySnapshot ridesSnapshot = await firestore
        .collection("rides")
        .where('userId', isEqualTo: userId)
        .get();

    for (QueryDocumentSnapshot rideDoc in ridesSnapshot.docs) {
      Map<String, dynamic> data = rideDoc.data() as Map<String, dynamic>;
      DocumentSnapshot userSnapshot =
          await firestore.collection("users").doc(data["userId"]).get();
      print("helooooooo");
      print(rideDoc.data());

      RideDetails rideDetails = RideDetails(
        userid: data["userId"],
        rideid: rideDoc.id,
        user: userSnapshot["username"],
        rating: double.parse(userSnapshot["rating"]),
        departurePoint: data["pickupLocation"],
        destinationPoint: data["dropLocation"],
        startTime: data["selectedStartTime"],
        endTime: data["selectedEndTime"],
        dayTime: data["selectedDate"].toDate(),
        price: double.parse(data["price"]),
        places: double.parse(data["carSeatCount"].toString()),
      );
      rideDetailsList.add(rideDetails);
    }
    return rideDetailsList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            SizedBox(height: getProportionateScreenHeight(20)),
            //HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            Image.asset(
              "assets/images/home.jpg",
              height: getProportionateScreenHeight(265),
              width: getProportionateScreenWidth(235),
            ),
            SizedBox(height: getProportionateScreenWidth(10)),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: getProportionateScreenWidth(20)),
                  child: Text(
                    "Home",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            //DiscountBanner(),
            //Categories(),
            RideCard(
                title: "My Reservations",
                reservations: myReservations,
                isRide: false),
            SizedBox(height: getProportionateScreenWidth(30)),
            //PopularProducts(),
            RideCard(
              title: "My Rides",
              rides: myRides,
            ),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
