import 'package:flutter/material.dart';
import 'package:shop_app/models/RideDetails.dart';
import 'package:shop_app/screens/search_ride/Components/userDescription.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class RideDescription extends StatelessWidget {
  final RideDetails rideDetails;
  const RideDescription({required this.rideDetails, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(50)),
          child: Text(
            rideDetails.departurePoint + ", " + rideDetails.startTime,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        /* Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            width: getProportionateScreenWidth(64),
            decoration: BoxDecoration(
              color:
                  product.isFavourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: SvgPicture.asset(
              "assets/icons/Heart Icon_2.svg",
              color:
                  product.isFavourite ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
              height: getProportionateScreenWidth(16),
            ),
          ),
        ),*/
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(55),
              right: getProportionateScreenWidth(64),
              top: 10),
          child: Text(
            "Driver : ${rideDetails.user}\n" +
                "Rates : ${rideDetails.rating}\n" +
                "Price : ${rideDetails.price}DT\n" +
                "Available seats: ${rideDetails.places}",
            maxLines: 4,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(57),
            vertical: 20,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserDescription(userId: rideDetails.userid),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  "See User profile",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
