import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/screens/add_ride/AddRide_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

import '../constants.dart';
import '../enums.dart';
import '../screens/search_ride/search_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.search,
                  color: MenuState.search == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, SearchScreen.routeName),
              ),
              IconButton(
                icon: Icon(Icons.add_outlined,
                color: MenuState.add == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,),
                onPressed: () =>
                   Navigator.pushNamed(context, AddRideScreen.routeName),
                
              ),
              IconButton(
                icon: Icon(Icons.home, 
                color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),

              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
            ],
          )),
    );
  }
}
