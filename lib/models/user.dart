class User {
  final Name name;
  final Picture picture;
  final String email;
  final String phone;

  const User({
    required this.name,
    required this.picture,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: Name.fromJson(json['name']),
      picture: Picture.fromJson(json['picture']),
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name.toJson(),
        'picture': picture.toJson(),
        'email': email,
        'phone': phone,
      };

  @override
  String toString() => '$phone | $email | ${name.first}';
}

class Name {
  final String last;
  final String first;

  const Name({required this.last, required this.first});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      last: json['last'] ?? '',
      first: json['first'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'last': last, 'first': first};
}

class Picture {
  final String medium;

  const Picture({required this.medium});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(medium: json['large'] ?? '');
  }

  Map<String, dynamic> toJson() => {'medium': medium};
}
