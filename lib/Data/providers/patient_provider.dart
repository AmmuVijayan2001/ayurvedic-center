import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../services/api_service.dart';

class PatientProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  List<Patient> _patients = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Patient> get patients => _patients;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPatients(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getPatientList(token);

      if (response.status == true && response.patient != null) {
        _patients = response.patient!;
      } else {
        _errorMessage = response.message ?? 'Failed to load patients';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
