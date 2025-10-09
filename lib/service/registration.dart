import 'package:appoiment_app/model/pationt_model.dart';
import 'package:appoiment_app/service/core.dart';
import 'package:dio/dio.dart';

abstract class RegistrationRepository {
  Future<void> registerPatient(
    String token,
    Map<String, String> formData,
    List<TreatmentBooking> selectedTreatments,
  );
}

class RegistrationRepositoryImpl implements RegistrationRepository {
  final Dio _dio = Dio();

  @override
  Future<void> registerPatient(
    String token,
    Map<String, String> formData,
    List<TreatmentBooking> selectedTreatments,
  ) async {
    final Map<String, String> body = Map.from(formData);

    final treatmentsIds = selectedTreatments
        .map((t) => t.id.toString())
        .join(',');
    body['treatments'] = treatmentsIds;

    final maleIds = selectedTreatments
        .where((t) => t.maleCount > 0)
        .map((t) => t.id.toString())
        .join(',');
    body['male'] = maleIds;

    final femaleIds = selectedTreatments
        .where((t) => t.femaleCount > 0)
        .map((t) => t.id.toString())
        .join(',');
    body['female'] = femaleIds;

    body['id'] = '';

    print('Submitting to PatientUpdate API with body: $body');

    try {
      final response = await _dio.post(
        ApiConfig.baseUrl + '/api/PatientUpdate',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return; // Success
        } else {
          throw Exception(data['message'] ?? 'Patient registration failed.');
        }
      } else {
        throw Exception(
          'Server error during registration: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
