import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  Dio _dio = Dio();
  String _baseUrl = "https://crudcrud.com/api/06a474ad3a6d4141a54275cc0d7ed573";
  static const String _apiKeyTimestampKey = 'apiKeyTimestamp';

  ApiService() {
    _initializeApiKey();
  }

  Future<void> updateApiKey(String apiKey) async {
    _baseUrl = "https://crudcrud.com/api/$apiKey";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey', apiKey);
    await prefs.setInt(_apiKeyTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _initializeApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('apiKey');
    if (apiKey != null) {
      _baseUrl = "https://crudcrud.com/api/$apiKey";
    }
  }

  Future<bool> canUpdateApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastUpdate = prefs.getInt(_apiKeyTimestampKey);
    if (lastUpdate != null) {
      DateTime lastUpdateDate = DateTime.fromMillisecondsSinceEpoch(lastUpdate);
      return DateTime.now().difference(lastUpdateDate).inHours >= 24;
    }
    return true;
  }

  Future<bool> isConnected() async {
    try {
      var response = await _dio.get("$_baseUrl/users");
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    try {
      var response = await _dio.get("$_baseUrl/users");
      if (response.data is List) {
        return (response.data as List).map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Response is not a list');
      }
    } catch (e) {
      throw Exception('Failed to fetch users: ${e.toString()}');
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _dio.post("$_baseUrl/users", data: user.toJson());
    } catch (e) {
      throw Exception('Failed to create user: ${e.toString()}');
    }
  }

  Future<void> updateUser(String id, UserModel user) async {
    try {
      await _dio.put("$_baseUrl/users/$id", data: user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _dio.delete("$_baseUrl/users/$id");
    } catch (e) {
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }
}
