import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:caretaker_wellnest/main.dart';

class UpdateMedappointments extends StatefulWidget {
  String resident_id;
  UpdateMedappointments({super.key, required this.resident_id});

  @override
  State<UpdateMedappointments> createState() => _UpdateMedappointmentsState();
}

class _UpdateMedappointmentsState extends State<UpdateMedappointments> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _docNameController = TextEditingController();

  bool isLoading = false;

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await supabase.from('tbl_appointment').insert({
        'appointment_date': _dateController.text,
        'appointment_time': _timeController.text,
        'appointment_name': _docNameController.text,
        'resident_id':widget.resident_id
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Updation Successful"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context,true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
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
        backgroundColor: const Color.fromARGB(255, 0, 36, 94),
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
                      "Set Doctor Appointment",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 24, 56, 111)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: "Appointment Date",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _selectDate,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please select a date" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: "Appointment Time",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: _selectTime,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please select a time" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _docNameController,
                      decoration: const InputDecoration(
                        labelText: "Doctor's Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Please enter doctor's name" : null,
                    ),
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
                        'Update Appointment',
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
}
