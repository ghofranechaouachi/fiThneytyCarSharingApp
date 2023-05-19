import 'package:flutter/material.dart';
import 'package:shop_app/screens/search_ride/Components/filterInput.dart';
import 'package:shop_app/screens/details/RideDetailsPageV2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import '../../models/RideDetails.dart';
import '../../size_config.dart';

class RidesScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const RidesScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  List<RideDetails> _filteredData = [];

  List<RideDetails> filteredList1 = [];

  List<RideDetails> rideDetailsList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /* Future<void> getRidesFromFirestore() async {
    final rides = await firestore.collection('rides').get();
    rides.docs.forEach((e) {
      RideDetails rideDetails = RideDetails(
          departurePoint: "New York City", //e.get('pickupLocation'),
          destinationPoint: "Los Angeles", //e.get('dropLocation'),
          startTime: e.get('selectedStartTime'),
          endTime: '30:00 AM', //e.get('selectedEndTime'),
          user: 'user',
          dayTime: DateTime.now(),
          rating: 4.5,
          price: 60.5,
          places: 2);
      rideDetailsList.add(rideDetails);
    });
  }*/

  Future<List<RideDetails>> getRidesFromFirestore() async {
    List<RideDetails> rideDetailsList = [];
    QuerySnapshot ridesSnapshot = await firestore.collection("rides").get();

    // ridesSnapshot.docs.forEach((rideDoc) {

    for (QueryDocumentSnapshot rideDoc in ridesSnapshot.docs) {
      Map<String, dynamic> data = rideDoc.data() as Map<String, dynamic>;
      DocumentSnapshot userSnapshot =
          await firestore.collection("users").doc(data["userId"]).get();
      print("helooooooo");
      print(data["selectedStartTime"]);
      print(rideDoc.data());
      print(userSnapshot);
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
  void initState() {
    super.initState();

    getRidesFromFirestore().then((list) {
      setState(() {
        rideDetailsList = list;

        print("hiiiiiiiiii");
        print(rideDetailsList);

        _filteredData.addAll(rideDetailsList);

        List<RideDetails> filteredList = [];
        filteredList.addAll(rideDetailsList);
        if (widget.data['departInput'] != '') {
          filteredList.retainWhere((item) =>
              item.dayTime.day == widget.data['DayN'] &&
                  monthName[item.dayTime.month] == widget.data['Month'] &&
                  item.departurePoint == widget.data['departInput'] ||
              item.destinationPoint.toLowerCase() ==
                  widget.data['destInput'].toLowerCase());
        }
        /*if(filterData['startTime']!=""){
      filteredList.retainWhere((item) => 
      item.startTime == filterData['startTime'] 
      );
    }*/
        setState(() {
          _filteredData.clear();
          _filteredData.addAll(filteredList);
          filteredList1.addAll(filteredList);
        });
      });
    });
  }

  void applyFilters(Map<String, dynamic> filterData) {
    // filter the list of rides based on the selected options
    List<RideDetails> filteredList2 = [];
    filteredList2.addAll(_filteredData);
    if (filterData['startTime'] == '') {
      setState(() {
        _filteredData.clear();
        _filteredData.addAll(filteredList1);
      });
    } else {
      filteredList2
          .retainWhere((item) => item.startTime == filterData['startTime']);
      setState(() {
        _filteredData.clear();
        _filteredData.addAll(filteredList2);
      });
    }
  }

  void _openFilterPage(Map<String, dynamic> filterData) async {
    // navigate to Page 2 to select filter options
    final selectedOptions = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
          builder: (context) => filterInput(filterData: filterData)),
    );

    if (selectedOptions != null) {
      // apply the selected filters to the list of rides

      applyFilters(selectedOptions);
    }
  }

  Map<String, dynamic> filterData = {'option': '', 'startTime': ''};

  Map<int, String> weekdayName = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  Map<int, String> monthName = {
    1: "jan",
    2: "fev",
    3: "mars",
    4: "avr",
    5: "may",
    6: "juin",
    7: "juillet",
    8: "aout",
    9: "sept",
    10: "oct",
    11: "nov",
    12: "dec"
  };

  @override
  Widget build(BuildContext context) {
    String departInput = widget.data['departInput'];
    String destInput = widget.data['destInput'];
    String day = widget.data['Day'];
    int dayN = widget.data['DayN'];
    String month = widget.data['Month'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(getProportionateScreenWidth(20)),
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenWidth(15),
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Departure: $departInput',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Destination: $destInput',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(day + " " + dayN.toString() + " " + month,
                        style: TextStyle(color: Colors.white)),
                    Text(
                        filterData['startTime'] != null
                            ? filterData['startTime']
                            : "",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                IconButton(
                    icon: Icon(Icons.filter_alt_outlined),
                    color: Colors.white,
                    onPressed: () async => _openFilterPage(filterData)
                    /* final Map<String, dynamic> filterData = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => filterInput())
            );
            setState(() {
              if(filterData != null)
              this.filterData = filterData;
            });*/
                    ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                return cardv1(index, _filteredData, context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget cardv1(
    int index, List<RideDetails> rideDetailsList, BuildContext context) {
  Map<int, String> monthName = {
    1: "jan",
    2: "fev",
    3: "mars",
    4: "avr",
    5: "may",
    6: "juin",
    7: "juillet",
    8: "aout",
    9: "sept",
    10: "oct",
    11: "nov",
    12: "dec"
  };

  RideDetails ride = RideDetails(
      userid: rideDetailsList[index].userid,
      rideid: rideDetailsList[index].rideid,
      user: rideDetailsList[index].user,
      rating: rideDetailsList[index].rating,
      departurePoint: rideDetailsList[index].departurePoint,
      destinationPoint: rideDetailsList[index].destinationPoint,
      startTime: rideDetailsList[index].startTime,
      endTime: rideDetailsList[index].endTime,
      dayTime: rideDetailsList[index].dayTime,
      price: rideDetailsList[index].price,
      places: rideDetailsList[index].places);
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RideDetailsPageV2(rideDetails: ride),
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
                  child: Icon(Icons.account_circle_rounded, color: Colors.white)
                  /*Text(
                  "JD",
                  style: TextStyle(color: Colors.white),
                ),*/
                  ),
              title: Text(
                ride.user.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Text(
                    ride.rating.toString(),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                ride.price.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.departurePoint.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        ride.startTime.toString() +
                            " " +
                            ride.dayTime.day.toString() +
                            " " +
                            monthName[ride.dayTime.month].toString(),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: Icon(Icons.arrow_forward, color: Colors.grey),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        ride.destinationPoint.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        ride.endTime.toString(),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
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
}
