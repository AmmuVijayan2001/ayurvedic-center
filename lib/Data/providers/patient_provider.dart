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

  List<Branch> _branches = [];
  List<Treatment> _treatments = [];

  List<Branch> get branches => _branches;
  List<Treatment> get treatments => _treatments;

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

  Future<void> fetchBranches(String token) async {
    try {
      final response = await _apiService.getBranchList(token);
      if (response.status == true && response.branches != null) {
        _branches = response.branches!;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }

  Future<void> fetchTreatments(String token) async {
    try {
      final response = await _apiService.getTreatmentList(token);
      if (response.status == true && response.treatments != null) {
        _treatments = response.treatments!;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching treatments: $e");
    }
  }

  Future<void> registerPatient(String token, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.registerPatient(token, data);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
