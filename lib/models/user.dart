class UserModel {
  String? email;
  String? fullName;
  DateTime? birthday;
  String? age;
  String? gender;
  String? status;
  String? birthplace;
  String? purok;
  String? type = 'user';
  DateTime createdAt = DateTime.now();
  String? id;

  UserModel({
    required this.email,
    required this.fullName,
    required this.birthday,
    required this.age,
    required this.gender,
    required this.status,
    required this.birthplace,
    required this.purok,
    this.id,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    fullName = json['fullName'];
    birthday = json['birthday'].toDate();
    age = json['age'];

    gender = json['gender'];
    status = json['status'];
    birthplace = json['birthplace'];
    purok = json['purok'];
    type = json['type'];
    createdAt = json['createdAt'].toDate();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['birthday'] = birthday;
    data['age'] = age;
    data['status'] = status;
    data['birthplace'] = birthplace;
    data['purok'] = purok;
    return data;
  }
}
