class UserModel {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  UserModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password
  });

  Map<String, dynamic> toJson() => {
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'password': password,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    firstname: json['firstname'],
    lastname: json['lastname'],
    email: json['email'],
    password: json['password'],
  );
}