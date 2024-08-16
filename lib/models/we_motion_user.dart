class WeMotionUser {
  WeMotionUser({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
  });
  late String id;
  late String image;
  late String name;
  late String email;

  WeMotionUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
