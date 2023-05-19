import 'package:shop_app/enums.dart';

class Reservation {
  final String idReservation;
  final String adminId;
  final String departurePoint;
  final String destinationPoint;
  final String startTime;
  final String endTime;
  final DateTime dayTime;
  final ReservationState status;

  Reservation({
    required this.adminId,
    required this.idReservation,
    required this.departurePoint,
    required this.destinationPoint,
    required this.startTime,
    required this.endTime,
    required this.dayTime,
    required this.status,
  });
}
