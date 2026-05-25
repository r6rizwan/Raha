class FoodPlaceDetailsModel {
  const FoodPlaceDetailsModel({
    required this.placeId,
    required this.name,
    required this.address,
    required this.phone,
    required this.website,
    required this.mapsUrl,
    required this.rating,
    required this.userRatingCount,
    required this.openingHours,
    required this.photoNames,
  });

  final String placeId;
  final String name;
  final String address;
  final String phone;
  final String website;
  final String mapsUrl;
  final double rating;
  final int userRatingCount;
  final List<String> openingHours;
  final List<String> photoNames;

  factory FoodPlaceDetailsModel.fromJson(Map<String, dynamic> json) =>
      FoodPlaceDetailsModel(
        placeId: json['placeId'] ?? '',
        name: json['name'] ?? '',
        address: json['address'] ?? '',
        phone: json['phone'] ?? '',
        website: json['website'] ?? '',
        mapsUrl: json['mapsUrl'] ?? '',
        rating: (json['rating'] ?? 0).toDouble(),
        userRatingCount: json['userRatingCount'] ?? 0,
        openingHours: List<String>.from(json['openingHours'] ?? const []),
        photoNames: List<String>.from(json['photoNames'] ?? const []),
      );

  Map<String, dynamic> toJson() => {
    'placeId': placeId,
    'name': name,
    'address': address,
    'phone': phone,
    'website': website,
    'mapsUrl': mapsUrl,
    'rating': rating,
    'userRatingCount': userRatingCount,
    'openingHours': openingHours,
    'photoNames': photoNames,
  };
}
