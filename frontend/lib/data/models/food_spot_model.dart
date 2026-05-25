class FoodSpotModel {
  const FoodSpotModel({
    required this.id,
    required this.name,
    required this.cuisineTypes,
    required this.city,
    required this.districtTag,
    required this.rating,
    required this.priceRange,
    required this.photos,
    required this.googlePlaceId,
  });
  final String id, name, city, districtTag, priceRange, googlePlaceId;
  final List<String> cuisineTypes, photos;
  final double rating;
  factory FoodSpotModel.fromJson(Map<String, dynamic> json) => FoodSpotModel(
    id: json['_id'] ?? json['id'] ?? '',
    name: json['name'] ?? '',
    cuisineTypes: List<String>.from(json['cuisineTypes'] ?? const []),
    city: json['city'] ?? '',
    districtTag: json['districtTag'] ?? '',
    rating: (json['rating'] ?? 0).toDouble(),
    priceRange: json['priceRange'] ?? '',
    photos: List<String>.from(json['photos'] ?? const []),
    googlePlaceId: json['googlePlaceId'] ?? '',
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cuisineTypes': cuisineTypes,
    'city': city,
    'districtTag': districtTag,
    'rating': rating,
    'priceRange': priceRange,
    'photos': photos,
    'googlePlaceId': googlePlaceId,
  };
  FoodSpotModel copyWith({
    String? id,
    String? name,
    List<String>? cuisineTypes,
    String? city,
    String? districtTag,
    double? rating,
    String? priceRange,
    List<String>? photos,
    String? googlePlaceId,
  }) => FoodSpotModel(
    id: id ?? this.id,
    name: name ?? this.name,
    cuisineTypes: cuisineTypes ?? this.cuisineTypes,
    city: city ?? this.city,
    districtTag: districtTag ?? this.districtTag,
    rating: rating ?? this.rating,
    priceRange: priceRange ?? this.priceRange,
    photos: photos ?? this.photos,
    googlePlaceId: googlePlaceId ?? this.googlePlaceId,
  );
}
