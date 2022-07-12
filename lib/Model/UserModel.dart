class UserModel {
  String user_name;
  String dob;
  String salary;
  String nationality;
  String gender;
  String photo_name;

  UserModel(this.user_name, this.dob, this.salary, this.nationality,this.gender,this.photo_name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "user_name":user_name,
      "dob":dob,
      "salary":salary,
      "nationality":nationality,
      "gender":gender,
      "photo_name":photo_name
    };
    return map;
  }
  UserModel.fromMap(Map<String, dynamic> map)
  {
    user_name = map["user_name"];
    dob = map["dob"];
    salary = map["salary"];
    nationality = map["nationality"];
    gender = map["gender"];
    photo_name = map["photo_name"];
  }
}
class LoginModel{
  String u_name;
  String u_password;

  LoginModel(this.u_name, this.u_password);
  Map<String,dynamic>toMap(){
    var map = <String,dynamic>{
      "u_name":u_name,
      "u_password":u_password
    };
    return map;
  }
  LoginModel.fromMap(Map<String,dynamic> map)
  {
    u_name = map["u_name"];
    u_password = map["u_password"];
  }
}