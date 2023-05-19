import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/RideDetails.dart';
import 'package:shop_app/screens/details/components/top_rounded_container.dart';
import 'package:shop_app/screens/search_ride/Components/rideDescription.dart';

import '../../../components/default_button.dart';
import '../../../components/rounded_icon_btn.dart';
import '../../../size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BodyRide extends StatelessWidget {
  final RideDetails rideDetails;
  const BodyRide({required this.rideDetails, Key? key}) : super(key: key);
  Future<void> addReservation() async {
    User? user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String userName = userData['username'];
    final data = {
      'userId': userId,
      'ridedayTime': rideDetails.dayTime,
      'ridedeparturePoint': rideDetails.departurePoint,
      'ridedestinationPoint': rideDetails.destinationPoint,
      'rideendTime': rideDetails.endTime,
      'rideprice': rideDetails.price,
      'rideuserrating': rideDetails.rating,
      'adminId': rideDetails.userid,
      'rideId': rideDetails.rideid,
      'rideuser': rideDetails.user,
      'ride': rideDetails.startTime,
      'state': 'Pending',
    };
    // Add the reservation document and retrieve its ID

    final reservationReference =
        await FirebaseFirestore.instance.collection('reservations').add(data);
    final reservationId = reservationReference.id;
    final notification = {
      'reservationId':
          reservationId, // Store the reservation ID as an attribute in the notification
      'userId': userId,
      'adminId': rideDetails.userid,
      'rideId': rideDetails.rideid,
      'title': 'New Reservation',
      'subtitle': userName + ' has added a new reservation.',
      'time': DateTime.now(),
    };
    await FirebaseFirestore.instance
        .collection('notifications')
        .add(notification);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(
              width: mediaQuery.size.width / 1.2,
              child: AspectRatio(
                aspectRatio: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Depart + time container
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    rideDetails.departurePoint,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 12),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Icon(Icons.time_to_leave),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    rideDetails.startTime,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //--------------------------------------
                    // destination + time container
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    rideDetails.destinationPoint,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 12),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Icon(
                                      Icons.share_arrival_time,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    rideDetails.endTime,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //----------------------------------------------
                    //Time + average duration row
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Time : ",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                rideDetails.dayTime.toString().substring(0, 10),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 239, 207, 165)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Average duration :",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                "2h 46min",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 239, 207, 165)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        //---------------------
        //Ride details section
        TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [RideDescription(rideDetails: rideDetails)],
            )),
        //---------------------------
        //user profile + call btn section
        TopRoundedContainer(
            color: Color(0xFFF6F7F9),
            child: Column(
              children: [
                //call rider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.account_circle_rounded),
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rideDetails.user),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "${rideDetails.rating}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  SvgPicture.asset(
                                      "assets/icons/Star Icon.svg"),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    RoundedIconBtn(
                      icon: Icons.call,
                      press: () {},
                    ),
                  ],
                ),

                //Reservation button
                TopRoundedContainer(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.screenWidth * 0.15,
                      right: SizeConfig.screenWidth * 0.15,
                      bottom: getProportionateScreenWidth(40),
                      top: getProportionateScreenWidth(15),
                    ),
                    child: DefaultButton(
                      text: "Reserve Now",
                      press: () {
                        addReservation();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Reservation added successfully')));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
