import 'package:caretaker_wellnest/components/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import 'update_medication.dart';

class ViewMedication extends StatefulWidget {
  String resident_id;
  ViewMedication({super.key, required this.resident_id});

  @override
  State<ViewMedication> createState() => _ViewMedicationState();
}

class _ViewMedicationState extends State<ViewMedication> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> medications = [];

  @override
  void initState() {
    super.initState();
    fetchMedications();
  }

  Future<void> fetchMedications() async {
    try {
      final response = await supabase
          .from('tbl_medication')
          .select()
          .eq('resident_id', widget.resident_id);

      print("Supabase Response: $response"); // Debugging Output

      setState(() {
        medications = List<Map<String, dynamic>>.from(response);
      });

      if (medications.isEmpty) {
        print("No medications found in the database.");
      } else {
        print("Medications fetched successfully: $medications");
      }

      // Schedule notifications for medications
      // for (var medication in medications) {
      //   scheduleNotification(medication);
      // }
    } catch (error) {
      print("Error fetching medications: $error");
    }
  }

  // void scheduleNotification(Map<String, dynamic> medication) {
  //   String time = medication['medication_timing']; // Format: HH:mm:ss
  //   // int count = medication['medication_count'];
  //   String name = medication['medication_time']; // Medication Name

  //   DateTime now = DateTime.now();
  //   DateTime medicationDateTime = DateTime(
  //     now.year, now.month, now.day,
  //     int.parse(time.split(":")[0]), // Hour
  //     int.parse(time.split(":")[1]), // Minute
  //   );

  //   // Schedule a notification 10 minutes before the medication time
  //   DateTime reminderTime =
  //       medicationDateTime.subtract(const Duration(minutes: 10));

  //   if (reminderTime.isAfter(now)) {
  //     NotificationService.scheduleNotification(
  //       medicationDateTime.millisecondsSinceEpoch ~/ 1000, // Unique ID
  //       "Medication Reminder: $name",
  //       reminderTime,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 252, 197),
      appBar: AppBar(title: const Text('View Medication', style: TextStyle(
        fontSize: 23, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)
      ),), 
      backgroundColor: Color.fromARGB(255, 0, 36, 94),
      foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            medications.isEmpty
                ? const Center(child: Text("No Medications Available"))
                : Expanded(
                    child: ListView.builder(
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        final medication = medications[index];
                        String formattedTime = DateFormat('hh:mm a').format(
                            DateTime.parse(
                                "2000-01-01 ${medication['medication_timing']}"));
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                                "Medication: ${medication['medication_time']}"),
                            subtitle: Text(
                              "Time: $formattedTime\nCount: ${medication['medication_count']}",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 36, 94),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              onPressed: () async {
                bool? updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpdateMedication(resident_id: widget.resident_id),
                  ),
                );

                // Check if update was successful and refresh the data
                if (updated == true) {
                  fetchMedications(); // Refresh the medication list
                }
              },
              child: const Text(
                'Update Medication',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
