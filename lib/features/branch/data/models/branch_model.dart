

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innerspace_booking_app/features/branch/domain/entities/branch.dart';

class BranchModel extends Branch {
  const BranchModel({
    required String id,
    required String name,
    required String location,
    required String city,
    required num pricePerHour,
    required num latitude,
    required num longitude,
    required String address,
    required String description,
    required List<String> amenities,
    required Map<String, String> operatingHours,
    required List<String> imageUrls,
  }) : super(
          id: id,
          name: name,
          location: location,
          city: city,
          pricePerHour: pricePerHour,
          latitude: latitude,
          longitude: longitude,
          address: address,
          description: description,
          amenities: amenities,
          operatingHours: operatingHours,
          imageUrls: imageUrls,
        );

  factory BranchModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return BranchModel(
      id: snap.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      city: data['city'] ?? '',
      pricePerHour: data['pricePerHour'] ?? 0,
      latitude: data['latitude'] ?? 0,
      longitude: data['longitude'] ?? 0,
      address: data['address'] ?? '',
      description: data['description'] ?? '',
      amenities: List<String>.from(data['amenities'] ?? []),
      operatingHours: Map<String, String>.from(data['operatingHours'] ?? {}),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'location': location,
      'city': city,
      'pricePerHour': pricePerHour,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'description': description,
      'amenities': amenities,
      'operatingHours': operatingHours,
      'imageUrls': imageUrls,
    };
  }
}
