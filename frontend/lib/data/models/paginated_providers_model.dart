import 'service_provider_model.dart';

class PaginatedProvidersModel {
  const PaginatedProvidersModel({
    required this.providers,
    required this.total,
    required this.page,
  });
  final List<ServiceProviderModel> providers;
  final int total, page;
  factory PaginatedProvidersModel.fromJson(Map<String, dynamic> json) =>
      PaginatedProvidersModel(
        providers: (json['providers'] as List? ?? [])
            .map((e) => ServiceProviderModel.fromJson(e))
            .toList(),
        total: json['total'] ?? 0,
        page: json['page'] ?? 1,
      );
  Map<String, dynamic> toJson() => {
    'providers': providers.map((e) => e.toJson()).toList(),
    'total': total,
    'page': page,
  };
  PaginatedProvidersModel copyWith({
    List<ServiceProviderModel>? providers,
    int? total,
    int? page,
  }) => PaginatedProvidersModel(
    providers: providers ?? this.providers,
    total: total ?? this.total,
    page: page ?? this.page,
  );
}

class ServiceFilter {
  const ServiceFilter({required this.city, this.category});
  final String city;
  final String? category;
  @override
  bool operator ==(Object other) =>
      other is ServiceFilter &&
      city == other.city &&
      category == other.category;
  @override
  int get hashCode => Object.hash(city, category);
}
