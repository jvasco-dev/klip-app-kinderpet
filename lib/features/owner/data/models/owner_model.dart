class Owner {
  final String id;
  final int? document;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? address;

  Owner({
    required this.id,
    this.document,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
  });

  factory Owner.fromJson(dynamic json) {
    if (json == null) return Owner(id: '');

    if (json is String) {
      return Owner(id: json);
    }

    return Owner(
      id: json['_id'] ?? '',
      document: json['document'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'document': document,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}
