class User {
  final String userCode;
  final String displayName;
  final String email;
  final String employeeCode;
  final String companyCode;

  User({
    required this.userCode,
    required this.displayName,
    required this.email,
    required this.employeeCode,
    required this.companyCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userCode: json['User_Code'] ?? '',
      displayName: json['User_Display_Name'] ?? '',
      email: json['Email'] ?? '',
      employeeCode: json['User_Employee_Code'] ?? '',
      companyCode: json['Company_Code'] ?? '',
    );
  }
}
