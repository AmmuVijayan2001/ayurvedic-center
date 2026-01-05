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

  Future<BranchListResponse> getBranchList(String token) async {
    final url = Uri.parse('$baseUrl/BranchList');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('BranchList Response: ${response.body}');

      if (response.statusCode == 200) {
        return BranchListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load branch list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load branch list: $e');
    }
  }

  Future<TreatmentListResponse> getTreatmentList(String token) async {
    final url = Uri.parse('$baseUrl/TreatmentList');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('TreatmentList Response: ${response.body}');

      if (response.statusCode == 200) {
        return TreatmentListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load treatment list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load treatment list: $e');
    }
  }

  Future<void> registerPatient(String token, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/PatientUpdate');
    try {
      // Use FormData to send fields
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Register Response: $responseBody');

      if (response.statusCode == 200) {
        // Success
        final decoded = json.decode(responseBody);
        if (decoded['status'] == true) {
          return;
        } else {
          throw Exception(decoded['message'] ?? 'Registration failed');
        }
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
