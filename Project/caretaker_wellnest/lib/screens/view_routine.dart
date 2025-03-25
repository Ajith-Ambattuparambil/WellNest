import 'package:caretaker_wellnest/components/notification_service.dart';
import 'package:caretaker_wellnest/screens/update_routine.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewRoutine extends StatefulWidget {
  String resident_id;
   ViewRoutine({super.key, required  this.resident_id});

  @override
  State<ViewRoutine> createState() => _ViewRoutineState();
}

class _ViewRoutineState extends State<ViewRoutine> {
  final supabase = Supabase.instance.client;
  Map<String, String> routineData = {}; // No default values

  @override
  void initState() {
    super.initState();
    NotificationService.init();
    fetchAndScheduleRoutine();
  }

  Future<void> fetchAndScheduleRoutine() async {
    try {
      final response = await supabase.from('tbl_routine').select().eq('resident_id', widget.resident_id).single();
      print("Fetched Routine Data: $response");

      {
        Map<String, String> tempData = {};

        Map<String, String> routineMapping = {
          'routine_waketime': 'Wake Time',
          'routine_bftime': 'Breakfast Time',
          'routine_lunchtime': 'Lunch Time',
          'routine_exercisetime': 'Exercise Time',
          'routine_calltime': 'Call Time',
          'routine_dinnertime': 'Dinner Time',
          'routine_sleeptime': 'Sleep Time',
          
        };

        response.forEach((key, value) {
          if (routineMapping.containsKey(key) && value != null) {
            tempData[routineMapping[key]!] = value;
          }
        });

        setState(() {
          routineData = tempData;
        });

        // Schedule notifications
        routineData.forEach((name, time) {
          try {
            DateTime routineTime = DateTime.parse("2025-02-27 $time");
            print("Scheduling notification for $name at $routineTime");
            NotificationService.scheduleNotification(
                routineData.keys.toList().indexOf(name), name, routineTime);
          } catch (e) {
            print("Error parsing time for $name: $e");
          }
        });
      }
    } catch (e) {
      print("Error fetching data from Supabase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(230, 255, 252, 197),
    
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 36, 94),
        foregroundColor: Colors.white,
        title: const Text('View Routine',
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 23, fontWeight: FontWeight.bold),)),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: routineData.isEmpty
                ? const Center(child: Text("No routine data available."))
                : ListView.builder(
                    itemCount: routineData.length,
                    itemBuilder: (context, index) {
                      String routineName = routineData.keys.elementAt(index);
                      String routineTime = routineData.values.elementAt(index);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(routineName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(routineTime),
                          leading:
                              const Icon(Icons.access_time, color: Colors.blue),
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
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateRoutine(
                  resident_id:widget.resident_id
                )),
              );
            },
            child: const Text('Update Routine',style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold
            ),),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
