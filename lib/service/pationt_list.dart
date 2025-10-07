import 'dart:convert';

import 'package:appoiment_app/model/pationt_model.dart';
import 'package:appoiment_app/service/auth.dart';
import 'package:appoiment_app/service/core.dart';
import 'package:dio/dio.dart';

class PationtListService {
  final Dio dio = Dio();

  Future<List<Patient>> fetchPatients() async {
    final token = await TokenManager.getToken();

    final response = await dio.get(
      ApiConfig.baseUrl + '/api/PatientList',
      options: Options(
        headers: <String, String>{'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? json.decode(response.data)
          : response.data;

      if (data['status'] == true && data['patient'] is List) {
        final List patientsJson = data['patient'];

        return patientsJson.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to load patient list.');
      }
    } else {
      throw Exception('Server error: HTTP ${response.statusCode}');
    }
  }
}
