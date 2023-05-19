class RideDetails {
  final String userid;
  final String rideid;
  final String departurePoint;
  final String destinationPoint;
  final String startTime;
  final String endTime;
  final String user;
  final DateTime dayTime;
  final double rating;
  final double price;
  final double places;

  RideDetails(
      {required this.userid,
      required this.rideid,
      required this.departurePoint,
      required this.destinationPoint,
      required this.startTime,
      required this.endTime,
      required this.user,
      required this.dayTime,
      required this.rating,
      required this.price,
      required this.places});
}
