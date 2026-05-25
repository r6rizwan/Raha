class ServiceProviderModel {
  const ServiceProviderModel({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.rating,
    required this.priceRange,
    required this.isVerified,
    required this.photos,
    required this.bio,
    required this.contactPhone,
  });
  final String id, name, category, city, priceRange, bio, contactPhone;
  final double rating;
  final bool isVerified;
  final List<String> photos;
  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) =>
      ServiceProviderModel(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        category: json['category'] ?? '',
        city: json['city'] ?? '',
        rating: (json['rating'] ?? 0).toDouble(),
        priceRange: json['priceRange'] ?? '',
        isVerified: json['isVerified'] ?? false,
        photos: List<String>.from(json['photos'] ?? const []),
        bio: json['bio'] ?? '',
        contactPhone: json['contactPhone'] ?? '',
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'city': city,
    'rating': rating,
    'priceRange': priceRange,
    'isVerified': isVerified,
    'photos': photos,
    'bio': bio,
    'contactPhone': contactPhone,
  };
  ServiceProviderModel copyWith({
    String? id,
    String? name,
    String? category,
    String? city,
    double? rating,
    String? priceRange,
    bool? isVerified,
    List<String>? photos,
    String? bio,
    String? contactPhone,
  }) => ServiceProviderModel(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    city: city ?? this.city,
    rating: rating ?? this.rating,
    priceRange: priceRange ?? this.priceRange,
    isVerified: isVerified ?? this.isVerified,
    photos: photos ?? this.photos,
    bio: bio ?? this.bio,
    contactPhone: contactPhone ?? this.contactPhone,
  );
}
