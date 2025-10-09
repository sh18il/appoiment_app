import 'package:appoiment_app/controller/reatment_controller.dart';
import 'package:appoiment_app/model/pationt_model.dart';
import 'package:appoiment_app/service/auth.dart';
import 'package:appoiment_app/service/registration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final whatsappController = TextEditingController();
  final addressController = TextEditingController();
  final totalAmountController = TextEditingController();
  final discountController = TextEditingController();
  final advanceController = TextEditingController();
  final balanceController = TextEditingController();
  final dateController = TextEditingController();

  String location = 'Kochi';
  String branch = 'Kochi';
  int hour = 1;
  int minute = 0;
  String paymentMethod = 'Cash'; // You can use a list for multiple selection

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    whatsappController.dispose();
    addressController.dispose();
    totalAmountController.dispose();
    discountController.dispose();
    advanceController.dispose();
    balanceController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<TreatmentProvider>(context, listen: false);

    if (provider.treatments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one treatment'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final formData = {
      'name': nameController.text,
      'whatsapp': whatsappController.text,
      'address': addressController.text,
      'location': location,
      'branch': branch,
      'total_amount': totalAmountController.text,
      'discount': discountController.text,
      'advance': advanceController.text,
      'balance': balanceController.text,
      'date': dateController.text,
      'hour': hour.toString(),
      'minute': minute.toString(),
      'payment_method': paymentMethod,
    };

    final repo = RegistrationRepositoryImpl();
    final token = await TokenManager.getToken();
    try {
      await repo.registerPatient(
        token!, // Replace with actual token
        formData,
        provider.treatments.map((t) => TreatmentBooking(
          name: t.treatmentName,
         price: t.total.toDouble(),
         maleCount: t.male,
         femaleCount: t.female,

        )).toList(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(height: 20),
                FormFieldWidget(
                  header: "Name",
                  labelText: "Enter your full name",
                  controller: nameController,
                ),
                const SizedBox(height: 20),
                FormFieldWidget(
                  header: "WhatsApp Number",
                  labelText: "Enter your WhatsApp number",
                  controller: whatsappController,
                ),
                const SizedBox(height: 20),
                FormFieldWidget(
                  header: "Address",
                  labelText: "Enter your full address",
                  controller: addressController,
                ),
                const SizedBox(height: 20),
                DropdownField(
                  header: 'Location',
                  labelText: 'Select Location',
                  items: ['Calicut', 'Kochi', 'Malappuram'],
                  selectedValue: location,
                  onChanged: (val) => setState(() => location = val ?? 'Kochi'),
                ),
                const SizedBox(height: 20),
                DropdownField(
                  header: 'Branch',
                  labelText: 'Select the Branch',
                  items: ['Calicut', 'Kochi', 'Malappuram'],
                  selectedValue: branch,
                  onChanged: (val) => setState(() => branch = val ?? 'Kochi'),
                ),
                const SizedBox(height: 20),
                Consumer<TreatmentProvider>(
                  builder: (context, provider, child) {
                    if (provider.treatments.isEmpty) {
                      return const Text(
                        "No treatments added yet.",
                        style: TextStyle(color: Colors.grey),
                      );
                    }
                    return Column(
                      children: List.generate(provider.treatments.length, (
                        index,
                      ) {
                        final treatment = provider.treatments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(treatment.treatmentName),
                            subtitle: Text(
                              'Male: ${treatment.male}, Female: ${treatment.female}, Total: ${treatment.total}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                provider.removeTreatment(index);
                              },
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => TreatmentAlertDialog(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 189, 218, 204),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "+ Add Treatments",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 19, 72, 30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FormFieldWidget(
                  header: "Total Amount",
                  labelText: "",
                  controller: totalAmountController,
                ),
                const SizedBox(height: 20),
                FormFieldWidget(
                  header: "Discount Amount",
                  labelText: "",
                  controller: discountController,
                ),
                const SizedBox(height: 20),
                // Payment method selection (simplified)
                Row(
                  children: [
                    const Text('Payment Method'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Cash',
                      groupValue: paymentMethod,
                      onChanged: (val) => setState(() => paymentMethod = val!),
                    ),
                    const Text('Cash'),
                    Radio<String>(
                      value: 'Card',
                      groupValue: paymentMethod,
                      onChanged: (val) => setState(() => paymentMethod = val!),
                    ),
                    const Text('Card'),
                    Radio<String>(
                      value: 'UPI',
                      groupValue: paymentMethod,
                      onChanged: (val) => setState(() => paymentMethod = val!),
                    ),
                    const Text('UPI'),
                  ],
                ),
                const SizedBox(height: 20),
                FormFieldWidget(
                  header: "Advance Amount",
                  labelText: "",
                  controller: advanceController,
                ),
                const SizedBox(height: 20),
                FormFieldWidget(
                  header: "Balance Amount",
                  labelText: "",
                  controller: balanceController,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Select Date",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(now.year - 5),
                      lastDate: DateTime(now.year + 5),
                    );
                    if (picked != null) {
                      dateController.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "Treatment Time",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: "Hour",
                          border: OutlineInputBorder(),
                        ),
                        value: hour,
                        items: List.generate(12, (index) {
                          final h = index + 1;
                          return DropdownMenuItem<int>(
                            value: h,
                            child: Text(h.toString().padLeft(2, '0')),
                          );
                        }),
                        onChanged: (value) => setState(() => hour = value ?? 1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: "Minute",
                          border: OutlineInputBorder(),
                        ),
                        value: minute,
                        items: List.generate(60, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(index.toString().padLeft(2, '0')),
                          );
                        }),
                        onChanged: (value) =>
                            setState(() => minute = value ?? 0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006837),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Save",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//..............
class FormFieldWidget extends StatelessWidget {
  final String header;
  final String labelText;
  final TextEditingController? controller;

  const FormFieldWidget({
    super.key,
    required this.header,
    required this.labelText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
          validator: (value) => (value == null || value.isEmpty)
              ? 'Please enter some text'
              : null,
        ),
      ],
    );
  }
}
//....................

class DropdownField extends StatelessWidget {
  final String header;
  final String labelText;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;

  const DropdownField({
    super.key,
    required this.header,
    required this.labelText,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
          validator: (value) => (value == null || value.isEmpty)
              ? 'Please select an option'
              : null,
        ),
      ],
    );
  }
}
//......................

class TreatmentAlertDialog extends StatefulWidget {
  @override
  _TreatmentAlertDialogState createState() => _TreatmentAlertDialogState();
}

class _TreatmentAlertDialogState extends State<TreatmentAlertDialog> {
  String selectedTreatment = '';
  int maleCount = 0;
  int femaleCount = 0;

  final List<String> treatments = [
    'Dental Cleaning',
    'Root Canal',
    'Tooth Extraction',
    'Teeth Whitening',
    'Dental Implant',
    'Orthodontics',
    'Cavity Filling',
    'Gum Treatment',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Treatment',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 20,

                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedTreatment.isEmpty
                                ? null
                                : selectedTreatment,
                            hint: Text(
                              'Choose prefered treatment',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            isExpanded: true,
                            icon: Icon(
                              Icons.check,
                              color: Colors.green[700],
                              size: 10,
                            ),
                            items: treatments.map((String treatment) {
                              return DropdownMenuItem<String>(
                                value: treatment,
                                child: Text(
                                  treatment,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTreatment = newValue ?? '';
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Add Patients',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildCounterRow('Male', maleCount, (value) {
                setState(() => maleCount = value);
              }),
              const SizedBox(height: 20),
              _buildCounterRow('Female', femaleCount, (value) {
                setState(() => femaleCount = value);
              }),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 25,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedTreatment.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a treatment'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (maleCount == 0 && femaleCount == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add at least one patient'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final treatment = TreatmentRecord(
 id: DateTime.now().millisecondsSinceEpoch,
                      treatmentName: selectedTreatment,
                      male: maleCount,
                      female: femaleCount,
                      date: DateTime.now(),
                    );

                    Provider.of<TreatmentProvider>(
                      context,
                      listen: false,
                    ).addTreatment(treatment);

                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Treatment added successfully!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D5C3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounterRow(String label, int count, Function(int) onChanged) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        InkWell(
          onTap: () {
            if (count > 0) onChanged(count - 1);
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF0D5C3A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.remove, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          width: 50,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: Center(
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        InkWell(
          onTap: () => onChanged(count + 1),
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF0D5C3A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }
}
// //.............
// import 'package:appoiment_app/model/pationt_model.dart';
// import 'package:appoiment_app/controller/reatment_controller.dart';
// import 'package:appoiment_app/service/registration.dart';
// import 'package:appoiment_app/service/auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class RegistrationForm extends StatefulWidget {
//   const RegistrationForm({super.key});

//   @override
//   State<RegistrationForm> createState() => _RegistrationFormState();
// }

// class _RegistrationFormState extends State<RegistrationForm> {
//   final _formKey = GlobalKey<FormState>();

//   final nameController = TextEditingController();
//   final excecutiveController = TextEditingController();
//   final paymentController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();
//   final totalAmountController = TextEditingController();
//   final discountAmountController = TextEditingController();
//   final advanceAmountController = TextEditingController();
//   final balanceAmountController = TextEditingController();
//   final dateController = TextEditingController();

//   String branch = 'Kochi';
//   String location = 'Kochi';
//   int hour = 10;
//   int minute = 0;
//   String paymentMethod = 'Cash';

//   bool isLoading = false;

//   @override
//   void dispose() {
//     nameController.dispose();
//     excecutiveController.dispose();
//     paymentController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     totalAmountController.dispose();
//     discountAmountController.dispose();
//     advanceAmountController.dispose();
//     balanceAmountController.dispose();
//     dateController.dispose();
//     super.dispose();
//   }

//   Future<void> submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     final provider = Provider.of<TreatmentProvider>(context, listen: false);

//     if (provider.treatments.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please add at least one treatment'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     // Collect treatment ids for male/female/treatments
//     final treatments = provider.treatments;
//     final treatmentsIds = treatments.map((t) => t.id.toString()).join(',');
//     final maleIds = treatments
//         .where((t) => t.male > 0)
//         .map((t) => t.id.toString())
//         .join(',');
//     final femaleIds = treatments
//         .where((t) => t.female > 0)
//         .map((t) => t.id.toString())
//         .join(',');

//     // Format date and time
//     final dateTimeString =
//         "${dateController.text}-${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${hour < 12 ? 'AM' : 'PM'}";

//     final formData = {
//       'name': nameController.text,
//       'excecutive': excecutiveController.text,
//       'payment': paymentMethod,
//       'phone': phoneController.text,
//       'address': addressController.text,
//       'total_amount': totalAmountController.text,
//       'discount_amount': discountAmountController.text,
//       'advance_amount': advanceAmountController.text,
//       'balance_amount': balanceAmountController.text,
//       'date_nd_time': dateTimeString,
//       'id': '',
//       'male': maleIds,
//       'female': femaleIds,
//       'branch': branch,
//       'treatments': treatmentsIds,
//     };

//     final repo = RegistrationRepositoryImpl();
//     final token = await TokenManager.getToken();
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Authentication token not found.')),
//       );
//       setState(() => isLoading = false);
//       return;
//     }
//     try {
//       await repo.registerPatient(
//         token,
//         formData,
//         treatments.map((e) => TreatmentBooking(name: e.treatmentName, price: 0, maleCount: e.male, femaleCount: e.female, id: e.id)).toList(),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Registration successful!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Registration failed: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back),
//         ),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Register',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 20),

//                 FormFieldWidget(
//                   header: "Name",
//                   labelText: "Enter your full name",
//                   controller: nameController,
//                 ),
//                 const SizedBox(height: 20),

//                 FormFieldWidget(
//                   header: "Executive",
//                   labelText: "Enter executive name",
//                   controller: excecutiveController,
//                 ),
//                 const SizedBox(height: 20),

//                 FormFieldWidget(
//                   header: "Payment",
//                   labelText: "Enter payment",
//                   controller: paymentController,
//                 ),
//                 const SizedBox(height: 20),

//                 FormFieldWidget(
//                   header: "Phone",
//                   labelText: "Enter your phone number",
//                   controller: phoneController,
//                 ),
//                 const SizedBox(height: 20),

//                 FormFieldWidget(
//                   header: "Address",
//                   labelText: "Enter your full address",
//                   controller: addressController,
//                 ),
//                 const SizedBox(height: 20),

//                 DropdownField(
//                   header: 'Location',
//                   labelText: 'Select Location',
//                   items: ['Calicut', 'Kochi', 'Malappuram'],
//                   selectedValue: location,
//                   onChanged: (val) => setState(() => location = val ?? 'Kochi'),
//                 ),
//                 const SizedBox(height: 20),

//                 DropdownField(
//                   header: 'Branch',
//                   labelText: 'Select the Branch',
//                   items: ['Calicut', 'Kochi', 'Malappuram'],
//                   selectedValue: branch,
//                   onChanged: (val) => setState(() => branch = val ?? 'Kochi'),
//                 ),
//                 const SizedBox(height: 20),

//                 Consumer<TreatmentProvider>(
//                   builder: (context, provider, child) {
//                     if (provider.treatments.isEmpty) {
//                       return const Text(
//                         "No treatments added yet.",
//                         style: TextStyle(color: Colors.grey),
//                       );
//                     }
//                     return Column(
//                       children: List.generate(provider.treatments.length, (
//                         index,
//                       ) {
//                         final treatment = provider.treatments[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           child: ListTile(
//                             title: Text(treatment.treatmentName),
//                             subtitle: Text(
//                               'Male: ${treatment.male}, Female: ${treatment.female}, Total: ${treatment.total}',
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(
//                                 Icons.delete,
//                                 color: Colors.redAccent,
//                               ),
//                               onPressed: () {
//                                 provider.removeTreatment(index);
//                               },
//                             ),
//                           ),
//                         );
//                       }),
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 20),

//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () => showDialog(
//                       context: context,
//                       builder: (context) => TreatmentAlertDialog(),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 189, 218, 204),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: const Text(
//                       "+ Add Treatments",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color.fromARGB(255, 19, 72, 30),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//                 FormFieldWidget(
//                   header: "Total Amount",
//                   labelText: "",
//                   controller: totalAmountController,
//                 ),
//                 const SizedBox(height: 20),
//                 FormFieldWidget(
//                   header: "Discount Amount",
//                   labelText: "",
//                   controller: discountAmountController,
//                 ),
//                 const SizedBox(height: 20),

//                 // Payment method selection
//                 Row(
//                   children: [
//                     const Text('Payment Method'),
//                     Radio<String>(
//                       value: 'Cash',
//                       groupValue: paymentMethod,
//                       onChanged: (val) => setState(() => paymentMethod = val!),
//                     ),
//                     const Text('Cash'),
//                     Radio<String>(
//                       value: 'Card',
//                       groupValue: paymentMethod,
//                       onChanged: (val) => setState(() => paymentMethod = val!),
//                     ),
//                     const Text('Card'),
//                     Radio<String>(
//                       value: 'UPI',
//                       groupValue: paymentMethod,
//                       onChanged: (val) => setState(() => paymentMethod = val!),
//                     ),
//                     const Text('UPI'),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 FormFieldWidget(
//                   header: "Advance Amount",
//                   labelText: "",
//                   controller: advanceAmountController,
//                 ),
//                 const SizedBox(height: 20),
//                 FormFieldWidget(
//                   header: "Balance Amount",
//                   labelText: "",
//                   controller: balanceAmountController,
//                 ),

//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     const Text(
//                       "Date",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w300,
//                       ),
//                     ),
//                   ],
//                 ),
//                 TextFormField(
//                   controller: dateController,
//                   readOnly: true,
//                   decoration: const InputDecoration(
//                     labelText: "Select Date",
//                     border: OutlineInputBorder(),
//                     suffixIcon: Icon(Icons.calendar_today),
//                   ),
//                   onTap: () async {
//                     final now = DateTime.now();
//                     final picked = await showDatePicker(
//                       context: context,
//                       initialDate: now,
//                       firstDate: DateTime(now.year - 5),
//                       lastDate: DateTime(now.year + 5),
//                     );
//                     if (picked != null) {
//                       dateController.text =
//                           "${picked.day}/${picked.month}/${picked.year}";
//                       setState(() {});
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     const Text(
//                       "Treatment Time",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w300,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButtonFormField<int>(
//                         decoration: const InputDecoration(
//                           labelText: "Hour",
//                           border: OutlineInputBorder(),
//                         ),
//                         value: hour,
//                         items: List.generate(12, (index) {
//                           final h = index + 1;
//                           return DropdownMenuItem<int>(
//                             value: h,
//                             child: Text(h.toString().padLeft(2, '0')),
//                           );
//                         }),
//                         onChanged: (value) =>
//                             setState(() => hour = value ?? 10),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: DropdownButtonFormField<int>(
//                         decoration: const InputDecoration(
//                           labelText: "Minute",
//                           border: OutlineInputBorder(),
//                         ),
//                         value: minute,
//                         items: List.generate(60, (index) {
//                           return DropdownMenuItem<int>(
//                             value: index,
//                             child: Text(index.toString().padLeft(2, '0')),
//                           );
//                         }),
//                         onChanged: (value) =>
//                             setState(() => minute = value ?? 0),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : ElevatedButton(
//                           onPressed: submitForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF006837),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             "Save",
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//..............
// class FormFieldWidget extends StatelessWidget {
//   final String header;
//   final String labelText;
//   final TextEditingController? controller;

//   const FormFieldWidget({
//     super.key,
//     required this.header,
//     required this.labelText,
//     this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           header,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
//         ),
//         const SizedBox(height: 5),
//         TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: labelText,
//             border: const OutlineInputBorder(),
//           ),
//           validator: (value) => (value == null || value.isEmpty)
//               ? 'Please enter some text'
//               : null,
//         ),
//       ],
//     );
//   }
// }
// //....................

// class DropdownField extends StatelessWidget {
//   final String header;
//   final String labelText;
//   final List<String> items;
//   final String? selectedValue;
//   final ValueChanged<String?>? onChanged;

//   const DropdownField({
//     super.key,
//     required this.header,
//     required this.labelText,
//     required this.items,
//     required this.selectedValue,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           header,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
//         ),
//         const SizedBox(height: 5),
//         DropdownButtonFormField<String>(
//           value: selectedValue,
//           decoration: InputDecoration(
//             labelText: labelText,
//             border: const OutlineInputBorder(),
//           ),
//           items: items
//               .map(
//                 (item) =>
//                     DropdownMenuItem<String>(value: item, child: Text(item)),
//               )
//               .toList(),
//           onChanged: onChanged,
//           validator: (value) => (value == null || value.isEmpty)
//               ? 'Please select an option'
//               : null,
//         ),
//       ],
//     );
//   }
// }
// //......................

// class TreatmentAlertDialog extends StatefulWidget {
//   @override
//   _TreatmentAlertDialogState createState() => _TreatmentAlertDialogState();
// }

// class _TreatmentAlertDialogState extends State<TreatmentAlertDialog> {
//   String selectedTreatment = '';
//   int maleCount = 0;
//   int femaleCount = 0;

//   final List<String> treatments = [
//     'Dental Cleaning',
//     'Root Canal',
//     'Tooth Extraction',
//     'Teeth Whitening',
//     'Dental Implant',
//     'Orthodontics',
//     'Cavity Filling',
//     'Gum Treatment',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.white,
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.45,
//         padding: const EdgeInsets.all(30),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Choose Treatment',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 height: 30,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.blue, width: 2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 15,
//                   vertical: 5,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: SizedBox(
//                         width: 20,

//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             value: selectedTreatment.isEmpty
//                                 ? null
//                                 : selectedTreatment,
//                             hint: Text(
//                               'Choose prefered treatment',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 12,
//                               ),
//                             ),
//                             isExpanded: true,
//                             icon: Icon(
//                               Icons.check,
//                               color: Colors.green[700],
//                               size: 10,
//                             ),
//                             items: treatments.map((String treatment) {
//                               return DropdownMenuItem<String>(
//                                 value: treatment,
//                                 child: Text(
//                                   treatment,
//                                   style: const TextStyle(fontSize: 12),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedTreatment = newValue ?? '';
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 'Add Patients',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildCounterRow('Male', maleCount, (value) {
//                 setState(() => maleCount = value);
//               }),
//               const SizedBox(height: 20),
//               _buildCounterRow('Female', femaleCount, (value) {
//                 setState(() => femaleCount = value);
//               }),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 height: 25,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (selectedTreatment.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please select a treatment'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }
//                     if (maleCount == 0 && femaleCount == 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please add at least one patient'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }

//                     final treatment = TreatmentRecord(
//                       treatmentName: selectedTreatment,
//                       male: maleCount,
//                       female: femaleCount,
//                       date: DateTime.now(), id: 0,
//                     );

//                     Provider.of<TreatmentProvider>(
//                       context,
//                       listen: false,
//                     ).addTreatment(treatment);

//                     Navigator.of(context).pop();

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Treatment added successfully!'),
//                         backgroundColor: Colors.green,
//                         behavior: SnackBarBehavior.floating,
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0D5C3A),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'Save',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCounterRow(String label, int count, Function(int) onChanged) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 1,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.grey[300]!, width: 1),
//             ),
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 15),
//         InkWell(
//           onTap: () {
//             if (count > 0) onChanged(count - 1);
//           },
//           child: Container(
//             width: 30,
//             height: 30,
//             decoration: const BoxDecoration(
//               color: Color(0xFF0D5C3A),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.remove, color: Colors.white, size: 24),
//           ),
//         ),
//         const SizedBox(width: 15),
//         Container(
//           width: 50,
//           height: 30,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.grey[300]!, width: 2),
//           ),
//           child: Center(
//             child: Text(
//               '$count',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 15),
//         InkWell(
//           onTap: () => onChanged(count + 1),
//           child: Container(
//             width: 30,
//             height: 30,
//             decoration: const BoxDecoration(
//               color: Color(0xFF0D5C3A),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.add, color: Colors.white, size: 24),
//           ),
//         ),
//       ],
//     );
//   }
// }
