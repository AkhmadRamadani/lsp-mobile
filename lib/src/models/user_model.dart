class UserModel {
  int? id;
  String? username;
  String? password;

  UserModel({
    this.id,
    this.username,
    this.password,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
      };

  UserModel copyWith({
    int? id,
    String? username,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
