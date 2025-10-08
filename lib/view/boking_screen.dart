import 'package:appoiment_app/controller/pationt_controller.dart';
import 'package:appoiment_app/service/auth.dart';
import 'package:appoiment_app/view/registration_form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Date';
    Provider.of<PationtController>(context, listen: false).fetchPatients();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: MediaQuery.of(context).viewInsets.bottom == 0
          ? Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationForm(),
                            ),
                          );
                        },
                        child: Text(
                          "Register Now",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF006837),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // Implement search functionality here
            },
            icon: Icon(Icons.notifications),
          ),
        ],
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
            // Shimmer effect while loading
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 16,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 80,
                          height: 14,
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 60,
                              height: 14,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 18,
                              height: 18,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 60,
                              height: 14,
                              color: Colors.grey.shade200,
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.grey.shade200,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (controller.patients.isEmpty) {
            return Center(child: Text('No patients found.'));
          } else {
            return ListView.builder(
              itemCount: controller.patients.length,
              itemBuilder: (context, index) {
                final patient = controller.patients[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Row
                          Text(
                            '${index + 1}. ${patient.patientName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            patient.packageName!,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                patient.bookedDate.toString().split(' ')[0],

                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Icon(
                                Icons.people,
                                color: Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                patient.attenderName!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'View Booking details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
