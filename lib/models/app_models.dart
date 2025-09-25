// lib/models/app_models.dart

/// Enum for payment method selection.
enum PaymentMethod { wallet, other }

/// Model for fare confirmation and digital ticket screens.
class TripDetails {
  final String ticketId;
  final String userName;
  final String busNumber;
  final String startStop;
  final String destinationStop;
  final double fare;
  final DateTime purchaseTime;

  TripDetails({
    required this.ticketId,
    required this.userName,
    required this.busNumber,
    required this.startStop,
    required this.destinationStop,
    required this.fare,
    required this.purchaseTime,
  });
}

/// Model for the destination entry modal.
class BusInfo {
  final String number;
  final String currentStop;
  BusInfo({required this.number, required this.currentStop});
}

/// Model for the bus markers on the home screen map.
enum Occupancy { low, medium, high }

class BusMarker {
  final String id;
  final String route;
  final double lat;
  final double lng;
  final Occupancy occupancy;
  final String eta;
  final String nextStop;

  BusMarker({
    required this.id,
    required this.route,
    required this.lat,
    required this.lng,
    required this.occupancy,
    required this.eta,
    required this.nextStop,
  });
}
