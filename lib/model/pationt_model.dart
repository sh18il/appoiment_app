import 'dart:math';

class Patient {
  final int id;
  final String patientName;
  final String packageName;
  final String date;
  final String attenderName;
  // Simulated fields for detailed view/PDF
  final String address;
  final String whatsappNumber;
  final DateTime bookedDate;
  final DateTime treatmentDate;
  final List<TreatmentBooking> bookedTreatments;
  final double totalAmount;
  final double discount;
  final double advance;

  Patient({
    required this.id,
    required this.patientName,
    required this.packageName,
    required this.date,
    required this.attenderName,
    this.address = 'Nadakkave, Kozhikkode',
    this.whatsappNumber = '+91 9876543210',
    required this.bookedDate,
    required this.treatmentDate,
    required this.bookedTreatments,
    required this.totalAmount,
    required this.discount,
    required this.advance,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    final random = Random();
    final bookedDate = DateTime.now().subtract(
      Duration(days: random.nextInt(30)),
    );
    final treatmentDate = bookedDate.add(
      Duration(days: 1 + random.nextInt(10)),
    );

    // Simulated treatments
    final bookedTreatments = [
      TreatmentBooking(
        name: 'Panchakarma',
        price: 230,
        maleCount: 4,
        femaleCount: 4,
      ),
      TreatmentBooking(
        name: 'Njavara Kizhi Treatment',
        price: 230,
        maleCount: 4,
        femaleCount: 4,
      ),
      TreatmentBooking(
        name: 'Panchakarma',
        price: 230,
        maleCount: 4,
        femaleCount: 6,
      ),
    ];

    double calculatedTotal = bookedTreatments.fold(
      0.0,
      (sum, t) => sum + (t.price * (t.maleCount + t.femaleCount)),
    );

    // Simulated financial details
    double simDiscount = 500.0;
    double simAdvance = 1200.0;

    return Patient(
      id: json['id'] as int? ?? 0,
      patientName: json['name'] as String? ?? 'N/A',
      packageName: json['treatment_name'] as String? ?? 'No Package',
      date: json['date_time'] as String? ?? 'N/A', // Use raw date for display
      attenderName: json['branch']?['name'] as String? ?? 'Jithesh',
      bookedDate: bookedDate,
      treatmentDate: treatmentDate,
      bookedTreatments: bookedTreatments,
      totalAmount: calculatedTotal,
      discount: simDiscount,
      advance: simAdvance,
    );
  }
}

class TreatmentBooking {
  final String name;
  final double price;
  final int maleCount;
  final int femaleCount;
  final int id;

  TreatmentBooking({
    required this.name,
    required this.price,
    required this.maleCount,
    required this.femaleCount,
    this.id = 0,
  });

  double get total => price * (maleCount + femaleCount);
}
