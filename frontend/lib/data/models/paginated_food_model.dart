import 'food_spot_model.dart';

class PaginatedFoodModel {
  const PaginatedFoodModel({
    required this.spots,
    required this.total,
    required this.page,
  });
  final List<FoodSpotModel> spots;
  final int total, page;
  factory PaginatedFoodModel.fromJson(Map<String, dynamic> json) =>
      PaginatedFoodModel(
        spots: (json['spots'] as List? ?? [])
            .map((e) => FoodSpotModel.fromJson(e))
            .toList(),
        total: json['total'] ?? 0,
        page: json['page'] ?? 1,
      );
  Map<String, dynamic> toJson() => {
    'spots': spots.map((e) => e.toJson()).toList(),
    'total': total,
    'page': page,
  };
  PaginatedFoodModel copyWith({
    List<FoodSpotModel>? spots,
    int? total,
    int? page,
  }) => PaginatedFoodModel(
    spots: spots ?? this.spots,
    total: total ?? this.total,
    page: page ?? this.page,
  );
}

class FoodFilter {
  const FoodFilter({required this.city, this.cuisine});
  final String city;
  final String? cuisine;
  @override
  bool operator ==(Object other) =>
      other is FoodFilter && city == other.city && cuisine == other.cuisine;
  @override
  int get hashCode => Object.hash(city, cuisine);
}
