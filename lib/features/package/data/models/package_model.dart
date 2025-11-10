class Package {
  final String id;
  final String name;
  final int hours;
  final bool status;

  Package({
    required this.id,
    required this.name,
    required this.hours,
    required this.status,
  });

  factory Package.fromJson(dynamic json) {
    if (json == null) {
      return Package(id: '', name: '', hours: 0, status: false);
    }

    if (json is String) {
      return Package(id: json, name: '', hours: 0, status: false);
    }

    if (json is Map<String, dynamic>) {
      return Package(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        hours: json['hours'] ?? 0,
        status: json['status'] ?? false,
      );
    }

    return Package(id: '', name: '', hours: 0, status: false);
  }
}
