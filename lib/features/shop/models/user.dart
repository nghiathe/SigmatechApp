class User {
  final int id;
  final String name;
  final String email;
  final String? address;
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
}
