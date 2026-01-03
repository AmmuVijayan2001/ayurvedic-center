import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_model.dart';
import '../models/patient_model.dart';

class ApiService {
  final String baseUrl = "https://flutter-amr.noviindus.in/api";

  Future<LoginResponse> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/Login');
    try {
      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password,
        },
      );

      print('Login Response: ${response.body}');

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<PatientListResponse> getPatientList(String token) async {
    final url = Uri.parse('$baseUrl/PatientList');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('PatientList Response: ${response.body}');

      if (response.statusCode == 200) {
        return PatientListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load patient list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load patient list: $e');
    }
  }
}
