class BookingModel {
  const BookingModel({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.providerName,
    required this.scheduledAt,
    required this.status,
    required this.notes,
    required this.amount,
  });
  final String id, userId, providerId, providerName, status, notes;
  final DateTime scheduledAt;
  final double amount;
  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json['_id'] ?? json['id'] ?? '',
    userId: _idOf(json['userId']),
    providerId: _idOf(json['providerId']),
    providerName: json['providerName'] ?? '',
    scheduledAt: DateTime.tryParse(json['scheduledAt'] ?? '') ?? DateTime.now(),
    status: json['status'] ?? 'pending',
    notes: json['notes'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
  );
  static String _idOf(dynamic value) =>
      value is Map ? (value['_id'] ?? '') : (value ?? '').toString();
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'providerId': providerId,
    'providerName': providerName,
    'scheduledAt': scheduledAt.toIso8601String(),
    'status': status,
    'notes': notes,
    'amount': amount,
  };
  BookingModel copyWith({
    String? id,
    String? userId,
    String? providerId,
    String? providerName,
    DateTime? scheduledAt,
    String? status,
    String? notes,
    double? amount,
  }) => BookingModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    providerId: providerId ?? this.providerId,
    providerName: providerName ?? this.providerName,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    amount: amount ?? this.amount,
  );
}
