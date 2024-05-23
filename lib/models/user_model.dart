import 'dart:convert';

class UserModel {
  String? id;
  String? name;
  DateTime? birthdate;

  UserModel({this.id, this.name, this.birthdate});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (birthdate != null) {
      data['birthdate'] = birthdate!.toIso8601String();
    }
    return data;
  }

  int? calculateAge() {
    if (birthdate != null) {
      DateTime now = DateTime.now();
      int age = now.year - birthdate!.year;
      if (now.month < birthdate!.month || (now.month == birthdate!.month && now.day < birthdate!.day)) {
        age--;
      }
      return age;
    }
    return null;
  }

  String? getHoroscope() {
    if (birthdate != null) {
      int day = birthdate!.day;
      int month = birthdate!.month;
      switch (month) {
        case 1:
          return day >= 20 ? "Aquarius" : "Capricorn";
        case 2:
          return day >= 19 ? "Pisces" : "Aquarius";
        case 3:
          return day >= 21 ? "Aries" : "Pisces";
        case 4:
          return day >= 20 ? "Taurus" : "Aries";
        case 5:
          return day >= 21 ? "Gemini" : "Taurus";
        case 6:
          return day >= 21 ? "Cancer" : "Gemini";
        case 7:
          return day >= 23 ? "Leo" : "Cancer";
        case 8:
          return day >= 23 ? "Virgo" : "Leo";
        case 9:
          return day >= 23 ? "Libra" : "Virgo";
        case 10:
          return day >= 23 ? "Scorpio" : "Libra";
        case 11:
          return day >= 22 ? "Sagittarius" : "Scorpio";
        case 12:
          return day >= 22 ? "Capricorn" : "Sagittarius";
        default:
          return null;
      }
    }
    return null;
  }
}
