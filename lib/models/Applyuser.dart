import 'package:shop_app/enums.dart';

class ApplyUsers {
  final String idReservation;
  final String userId;
  final String adminId;
  final String userName;
  final ReservationState status;

  ApplyUsers({
    required this.adminId,
    required this.userId,
    required this.idReservation,
    required this.userName,
    required this.status,
  });
}
