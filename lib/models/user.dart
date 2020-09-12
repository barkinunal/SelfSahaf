class User {
  int userID;
  String name;
  String password;
  String surname;
  String dateOfBirth;
  String phoneNumber;
  String email;
  String role;

  User({mail, name, surname, password, dob, role}) {
    this.email = mail;
    this.password = password;
    this.surname = surname;
    this.name = name;
    this.dateOfBirth = dob;
    this.role = role;
  }
  String getUserName() {
    return this.name + " " + this.surname;
  }

  Map<String, dynamic> toJsonsignup() => {
        "email": email,
        "password": password,
        "surname": surname,
        "dob": dateOfBirth,
        "name": name,
        "phoneNumber": phoneNumber,
        "role": "ROLE_USER",
      };
  Map<String, dynamic> toJsonUpdate(bool changePassowrd) {
    if (changePassowrd) {
      print(password);

      return {
        "email": email,
        "password": password,
        "surname": surname,
        "dob": dateOfBirth,
        "name": name,
        "phoneNumber": phoneNumber,
        "role": role,
        "userID": userID
      };
    } else {
      return {
        "email": email,
        "surname": surname,
        "dob": dateOfBirth,
        "name": name,
        "phoneNumber": phoneNumber,
        "role": role,
        "userID": userID
      };
    }
  }

  Map<String, dynamic> toJsonBecameSeller() {
    this.role="ROLE_SELLER";
    return {
        "role": "ROLE_SELLER",
        "email": email,
        "surname": surname,
        "dob": dateOfBirth,
        "name": name,
        "phoneNumber": phoneNumber,
        "userID": userID,
      };
      }

  User.fromJson(Map<String, dynamic> json)
      : role = json["role"],
        userID = json['userID'],
        password = json['password'],
        email = json['email'],
        name = json["name"],
        surname = json["surname"],
        dateOfBirth = json["dob"],
        phoneNumber = json["phoneNumber"];
}
