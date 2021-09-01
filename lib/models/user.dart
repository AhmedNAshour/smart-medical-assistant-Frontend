class AuthUser {
  final String uid;
  final String email;
  final String role;
  AuthUser({this.uid, this.email, this.role});
}

class UserModel {
  final String uid;
  final String fName;
  final String lName;
  final String gender;
  final int age;
  final String password;
  final String email;

  UserModel({
    this.age,
    this.email,
    this.password,
    this.uid,
    this.fName,
    this.lName,
    this.gender,
  });
}
