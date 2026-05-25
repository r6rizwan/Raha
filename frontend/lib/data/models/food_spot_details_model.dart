import 'food_place_details_model.dart';
import 'food_spot_model.dart';

class FoodSpotDetailsModel {
  const FoodSpotDetailsModel({required this.spot, required this.place});
  final FoodSpotModel spot;
  final FoodPlaceDetailsModel? place;

  factory FoodSpotDetailsModel.fromJson(Map<String, dynamic> json) =>
      FoodSpotDetailsModel(
        spot: FoodSpotModel.fromJson(json['spot']),
        place: json['place'] == null
            ? null
            : FoodPlaceDetailsModel.fromJson(json['place']),
      );

  Map<String, dynamic> toJson() => {
    'spot': spot.toJson(),
    'place': place?.toJson(),
  };
}
