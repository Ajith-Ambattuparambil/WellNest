import 'package:caretaker_wellnest/main.dart';
import 'package:flutter/material.dart';

class UpdateMedication extends StatefulWidget {
  String resident_id;
   UpdateMedication({super.key, required this.resident_id});

  @override
  State<UpdateMedication> createState() => _UpdateMedicationState();
}

class _UpdateMedicationState extends State<UpdateMedication> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _foodtiming = TextEditingController();
  final TextEditingController _medicinecount = TextEditingController();

  String? _medicinetime = 'Before food';

  bool isLoading = true;

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      await supabase.from('tbl_medication').insert({
        'medication_timing': _foodtiming.text,
        'medication_count': _medicinecount.text,
        'medication_time': _medicinetime, // Use the selected radio button value
        'resident_id': widget.resident_id
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Updation Successful"),
          backgroundColor: Color.fromARGB(255, 86, 1, 1),
        ),
      );
      Navigator.pop(context,true);
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 252, 197),
      appBar: AppBar(
        title: const Text(
          "Update Medication",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 36, 94),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Set Medication",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 36, 94)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _foodtiming,
                        decoration: InputDecoration(
                          labelText: 'Medicine timing',
                          prefixIcon:
                              Icon(Icons.food_bank, color: Colors.blueGrey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time,
                                color: Colors.blueGrey),
                            onPressed: () async {
                              // Open the time picker
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              // If a time is selected, update the text field
                              if (pickedTime != null) {
                                final time =
                                    '${pickedTime.hour}:${pickedTime.minute}';
                                _foodtiming.text = time;
                              }
                            },
                          ),
                        ),
                        readOnly: true, 
                        onTap: () async {
                          
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            final time =
                                '${pickedTime.hour}:${pickedTime.minute}';
                            _foodtiming.text = time;
                          }
                        },
                      ),
                    ),
                    _buildTextField(
                      _medicinecount,
                      'Total',
                      Icons.medication_rounded,
                    ),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Medicines time",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Before food',
                              groupValue: _medicinetime,
                              onChanged: (String? value) {
                                setState(() {
                                  _medicinetime = value;
                                });
                              },
                            ),
                            const Text('Before food'),
                            const SizedBox(width: 20),
                            Radio<String>(
                              value: 'After food',
                              groupValue: _medicinetime,
                              onChanged: (String? value) {
                                setState(() {
                                  _medicinetime = value;
                                });
                              },
                            ),
                            const Text('After food'),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 36, 94),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        submit();
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
