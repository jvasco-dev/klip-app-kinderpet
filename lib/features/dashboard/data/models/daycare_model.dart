class Daycare {
  final String pet;
  final String package;
  final String status;
  final String owner;
  final String id;
  final double leftHours;
  final double additionalHours;

  Daycare({
    required this.pet,
    required this.package,
    required this.status,
    required this.owner,
    required this.id,
    required this.leftHours,
    required this.additionalHours,
  });

  factory Daycare.fromJson(Map<String, dynamic> json) {
    return Daycare(
      id: json['_id'] ?? '',
      leftHours: (json['leftHours'] ?? 0).toDouble(),
      additionalHours: (json['additionalHours'] ?? 0).toDouble(),
      pet: '',
      package: '',
      status: '',
      owner: '',
    );
  }
}
