import 'package:appoiment_app/controller/pationt_controller.dart';
import 'package:appoiment_app/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BokingScreen extends StatelessWidget {
  const BokingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<PationtController>(context, listen: false).fetchPatients();
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Screen'),
        leading: IconButton(
          onPressed: () {
            TokenManager.deleteToken();
            Navigator.pop(context);
          },
          icon: Icon(Icons.logout),
        ),
      ),
      body: Consumer<PationtController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.patients.isEmpty) {
            return Center(child: Text('No patients found.'));
          } else {
            return ListView.builder(
              itemCount: controller.patients.length,
              itemBuilder: (context, index) {
                final patient = controller.patients[index];
                return ListTile(
                  title: Text(patient.patientName),
                  subtitle: Text('Age: ${patient.packageName}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
