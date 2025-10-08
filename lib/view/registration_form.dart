import 'package:appoiment_app/controller/reatment_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 20),

              const FormFieldWidget(
                header: "Name",
                labelText: "Enter your full name",
              ),
              const SizedBox(height: 20),

              const FormFieldWidget(
                header: "WhatsApp Number",
                labelText: "Enter your WhatsApp number",
              ),
              const SizedBox(height: 20),

              const FormFieldWidget(
                header: "Address",
                labelText: "Enter your full address",
              ),
              const SizedBox(height: 20),

              const DropdownField(
                header: 'Location',
                labelText: 'Select Location',
                items: ['Calicut', 'Kochi', 'Malappuram'],
                selectedValue: 'Kochi',
                onChanged: null,
              ),
              const SizedBox(height: 20),

              const DropdownField(
                header: 'Branch',
                labelText: 'Select the Branch',
                items: ['Calicut', 'Kochi', 'Malappuram'],
                selectedValue: 'Kochi',
                onChanged: null,
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
              const FormFieldWidget(header: "Total Amount", labelText: ""),
              const SizedBox(height: 20),
              const FormFieldWidget(header: "Discount Amount", labelText: ""),
              const SizedBox(height: 20),
              // Payment method checkboxes need to use boolean values and state management
              Column(
                children: [
                  Row(children: [const Text('Payment Method')]),
                  const SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (context, setState) {
                      bool cash = false;
                      bool card = false;
                      bool upi = false;
                      return Row(
                        children: [
                          Checkbox(
                            shape: const CircleBorder(),
                            value: cash,
                            onChanged: (val) {
                              setState(() => cash = val ?? false);
                            },
                          ),
                          const Text('Cash'),
                          Checkbox(
                            shape: const CircleBorder(),
                            value: card,
                            onChanged: (val) {
                              setState(() => card = val ?? false);
                            },
                          ),
                          const Text('Card'),
                          Checkbox(
                            shape: const CircleBorder(),
                            value: upi,
                            onChanged: (val) {
                              setState(() => upi = val ?? false);
                            },
                          ),
                          const Text('UPI'),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const FormFieldWidget(header: "Advance Amount", labelText: ""),
              const SizedBox(height: 20),
              const FormFieldWidget(header: "Balance Amount", labelText: ""),

              const SizedBox(height: 20),
              const SizedBox(width: 20),
              Column(
                children: [
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
                  Builder(
                    builder: (context) {
                      final TextEditingController dateController =
                          TextEditingController();
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return SizedBox(
                            child: TextFormField(
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
                          );
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Column(
                children: [
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
                          value: 1,
                          items: List.generate(12, (index) {
                            final hour = index + 1;
                            return DropdownMenuItem<int>(
                              value: hour,
                              child: Text(hour.toString().padLeft(2, '0')),
                            );
                          }),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: "Minute",
                            border: OutlineInputBorder(),
                          ),
                          value: 0,
                          items: List.generate(60, (index) {
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text(index.toString().padLeft(2, '0')),
                            );
                          }),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<TreatmentProvider>(
                      context,
                      listen: false,
                    );

                    if (provider.treatments.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add at least one treatment'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Form submitted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
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
