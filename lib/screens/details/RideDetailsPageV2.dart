import 'package:flutter/material.dart';
import 'package:shop_app/models/RideDetails.dart';
import 'package:shop_app/screens/details/components/bodyRide.dart';

import 'components/custom_app_bar.dart';

class RideDetailsPageV2 extends StatelessWidget {
  final RideDetails rideDetails;
  const RideDetailsPageV2({required this.rideDetails,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(rating: rideDetails.rating),
      ),
      body: BodyRide(rideDetails: rideDetails),
    );
  }
}