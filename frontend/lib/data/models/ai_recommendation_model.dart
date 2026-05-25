class AIRecommendationModel {
  const AIRecommendationModel({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.referenceId,
  });
  final String type, title, subtitle, ctaLabel, referenceId;
  factory AIRecommendationModel.fromJson(Map<String, dynamic> json) =>
      AIRecommendationModel(
        type: json['type'] ?? '',
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
        ctaLabel: json['ctaLabel'] ?? '',
        referenceId: json['referenceId'] ?? '',
      );
  Map<String, dynamic> toJson() => {
    'type': type,
    'title': title,
    'subtitle': subtitle,
    'ctaLabel': ctaLabel,
    'referenceId': referenceId,
  };
  AIRecommendationModel copyWith({
    String? type,
    String? title,
    String? subtitle,
    String? ctaLabel,
    String? referenceId,
  }) => AIRecommendationModel(
    type: type ?? this.type,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    ctaLabel: ctaLabel ?? this.ctaLabel,
    referenceId: referenceId ?? this.referenceId,
  );
}
