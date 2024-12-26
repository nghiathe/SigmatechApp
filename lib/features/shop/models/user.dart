class User {
  final int id;
  final String name;
  final String email;
  String? address;
  final String? phone;
  final String? gender;
  final String utype;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.address,
    this.phone,
    this.gender,
    required this.utype,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      gender: json['gender'],
      utype: json['utype'],
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? address,
    String? phone,
    String? gender,
    String? utype,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      utype: utype ?? this.utype,
    );
  }
}
