class Owner {
  final String id;
  final int? document;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;

  Owner({
    required this.id,
    this.document,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Owner.fromJson(dynamic json) {
    if (json == null) {
      return Owner(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        address: '',
      );
    }

    if (json is String) {
      return Owner(
        id: json,
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        address: '',
      );
    }

    if (json is Map<String, dynamic>) {
      return Owner(
        id: json['_id'] ?? '',
        document: json['document'],
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
      );
    }

    return Owner(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      address: '',
    );
  }
}
