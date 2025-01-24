class RegistrationModel{
  late String firstName;
  late String lastName;
  late String email;
  late String contact;
  late String gender;
  late String fCMToken;

  RegistrationModel(this.firstName, this.lastName, this.email, this.contact,
      this.gender, this.fCMToken);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'FirstName': firstName,
    'LastName': lastName,
    'Email': email,
    'ContactNumber': contact,
    'Gender': gender,
    'FCMToken': fCMToken,
  };
}