import 'package:caretaker_wellnest/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for time formatting

class UpdateRoutine extends StatefulWidget {
  const UpdateRoutine({super.key});

  @override
  State<UpdateRoutine> createState() => _UpdateRoutineState();
}

class _UpdateRoutineState extends State<UpdateRoutine> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _waketime = TextEditingController();
  final TextEditingController _sleeptime = TextEditingController();
  final TextEditingController _breakfasttime = TextEditingController();
  final TextEditingController _lunchtime = TextEditingController();
  final TextEditingController _exercisetime = TextEditingController();
  final TextEditingController _dinnertime = TextEditingController();
  final TextEditingController _calltime = TextEditingController();

  bool isLoading = true;

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      await supabase.from('tbl_routine').insert({
        'routine_waketime': _waketime.text,
        'routine_sleeptime': _sleeptime.text,
        'routine_bftime': _breakfasttime.text,
        'routine_lunchtime': _lunchtime.text,
        'routine_dinnertime': _dinnertime.text,
        'routine_exercisetime': _exercisetime.text,
        'routine_calltime': _calltime.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Updation Successful"),
          backgroundColor: Color.fromARGB(255, 86, 1, 1),
        ),
      );
      Navigator.pop(context);
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
          "Create Account",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(230, 255, 252, 197)),
        ),
        backgroundColor: Color.fromARGB(255, 24, 56, 111),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(230, 255, 252, 197)),
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
                      "Set Routine",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 24, 56, 111)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(_waketime, 'Wake Up Time', Icons.person),
                    _buildTextField(
                      _breakfasttime,
                      'Breakfast Time',
                      Icons.home,
                    ),
                    _buildTextField(
                      _lunchtime,
                      'Lunch Time',
                      Icons.lunch_dining,
                    ),
                    _buildTextField(_exercisetime, 'Exercise Time',
                        Icons.sports_gymnastics),
                    _buildTextField(
                      _calltime,
                      'Call Reminder Time',
                      Icons.call,
                    ),
                    _buildTextField(
                        _dinnertime, 'Dinner Time', Icons.dinner_dining),
                    _buildTextField(
                        _sleeptime, 'Bed Time', Icons.single_bed_sharp),
                    const Divider(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 24, 56, 111),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        {
                          submit();
                        }
                      },
                      child: const Text(
                        'Update Routine',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(230, 255, 252, 197)),
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
        onTap: () async {
          // Show time picker when the text field is tapped
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (pickedTime != null) {
            // Format the selected time and set it to the text field
            final formattedTime = DateFormat('HH:mm').format(
              DateTime(2023, 1, 1, pickedTime.hour, pickedTime.minute),
            );
            controller.text = formattedTime;
          }
        },
      ),
    );
  }
}