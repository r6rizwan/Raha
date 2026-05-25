class UserModel {
  const UserModel({
    required this.id,
    required this.firebaseUid,
    required this.name,
    required this.email,
    required this.nationality,
    required this.city,
    required this.neighbourhood,
    required this.interestTags,
  });
  final String id, firebaseUid, name, email, nationality, city, neighbourhood;
  final List<String> interestTags;
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id'] ?? json['id'] ?? '',
    firebaseUid: json['firebaseUid'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    nationality: json['nationality'] ?? '',
    city: json['city'] ?? '',
    neighbourhood: json['neighbourhood'] ?? '',
    interestTags: List<String>.from(json['interestTags'] ?? const []),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'firebaseUid': firebaseUid,
    'name': name,
    'email': email,
    'nationality': nationality,
    'city': city,
    'neighbourhood': neighbourhood,
    'interestTags': interestTags,
  };
  UserModel copyWith({
    String? id,
    String? firebaseUid,
    String? name,
    String? email,
    String? nationality,
    String? city,
    String? neighbourhood,
    List<String>? interestTags,
  }) => UserModel(
    id: id ?? this.id,
    firebaseUid: firebaseUid ?? this.firebaseUid,
    name: name ?? this.name,
    email: email ?? this.email,
    nationality: nationality ?? this.nationality,
    city: city ?? this.city,
    neighbourhood: neighbourhood ?? this.neighbourhood,
    interestTags: interestTags ?? this.interestTags,
  );
}
