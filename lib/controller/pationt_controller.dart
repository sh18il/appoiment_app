import 'package:appoiment_app/model/pationt_model.dart';
import 'package:appoiment_app/service/pationt_list.dart';
import 'package:flutter/material.dart';

class PationtController with ChangeNotifier {
  final PationtListService _pationtListService = PationtListService();
  List<Patient> _patients = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PationtController() {
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _patients = await _pationtListService.fetchPatients();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error fetching patients: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

  
