// ---------------------------------------------------------------- //
// --- Treatment Record Model (Add this to your controller file) ---
// ---------------------------------------------------------------- //

import 'package:flutter/material.dart';

class TreatmentRecord {
  final String treatmentName;
  final int male;
  final int female;
  final DateTime date;
    final int id;

  TreatmentRecord({
    required this.treatmentName,
    required this.male,
    required this.female,
    required this.date,
    required this.id,
  });

  int get total => male + female;
}

// ---------------------------------------------------------------- //
// --- Treatment Provider (Add this to your controller file) ---
// ---------------------------------------------------------------- //

class TreatmentProvider with ChangeNotifier {
  final List<TreatmentRecord> _treatments = [];

  List<TreatmentRecord> get treatments => _treatments;

  void addTreatment(TreatmentRecord treatment) {
    _treatments.add(treatment);
    notifyListeners();
  }

  void removeTreatment(int index) {
    _treatments.removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    _treatments.clear();
    notifyListeners();
  }

  int get totalPatients {
    return _treatments.fold(0, (sum, item) => sum + item.male + item.female);
  }
}