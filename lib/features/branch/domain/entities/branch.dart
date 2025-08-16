// branch.dart
class Branch {
  final String id;
  final String name;
  final String location;
  final String city;
  final num pricePerHour;
  final num latitude;
  final num longitude;
  final String address;
  final String description;
  final List<String> amenities;
  final Map<String, String> operatingHours;
  final List<String> imageUrls;

  const Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.pricePerHour,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.description,
    required this.amenities,
    required this.operatingHours,
    required this.imageUrls,
  });
}
