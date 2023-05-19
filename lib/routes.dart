import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/home/components/ReservationListPage.dart';
import 'package:shop_app/screens/signup_success/signup_success_screen.dart';
import 'screens/add_ride/AddRide_screen.dart';
import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/components/notification_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/search_ride/search_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/profile_user/profile_user_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SearchScreen.routeName: (context) => SearchScreen(),
  AddRideScreen.routeName: (context) => AddRideScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
  SignupSuccessScreen.routeName: (context) => SignupSuccessScreen(),
  ProfileUserScreen.routeName: (context) => ProfileUserScreen(),
};
