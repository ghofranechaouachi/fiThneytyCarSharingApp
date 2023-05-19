class NotificationItem {
  final String notificationId;
  final String adminId;
  final String reservationId;
  final String rideId;
  final String userId;
  final String title;
  final String subtitle;
  final DateTime time;

  NotificationItem({
    required this.notificationId,
    required this.adminId,
    required this.reservationId,
    required this.rideId,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
