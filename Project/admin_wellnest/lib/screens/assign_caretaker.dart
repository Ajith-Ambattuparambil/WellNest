import 'package:admin_wellnest/main.dart';
import 'package:flutter/material.dart';

class AssignCaretaker extends StatefulWidget {
  final String id;
  const AssignCaretaker({super.key, required this.id});

  @override
  State<AssignCaretaker> createState() => _AssignCaretakerState();
}

class _AssignCaretakerState extends State<AssignCaretaker> {
  bool isLoading = true;
  List<Map<String, dynamic>> caretaker = [];
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase.from('tbl_caretaker').select();
      print("Fetched data: $response");
      setState(() {
        caretaker = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> assign(String id)
  async {
    try {
      await supabase.from('tbl_assign').insert({
        'resident_id':widget.id,
        'caretaker_id':id,
      }) ;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Assigned")));
      Navigator.pop(context);
    } catch (e) {
      print("Error:$e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign Caretaker",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Color.fromARGB(255, 24, 56, 111),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
                  Color.fromARGB(255, 227, 242, 253),
            Color.fromARGB(255, 227, 242, 253),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Caretaker List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 56, 111),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : caretaker.isEmpty
                    ? Text("No caretakers found.")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: caretaker.length,
                        itemBuilder: (context, index) {
                          final data = caretaker[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text(data['caretaker_name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Email: ${data['caretaker_email']}"),
                                      ElevatedButton(
                                        onPressed: () {
                                          assign(data['caretaker_id']);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 24, 56, 111),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 17, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          "Assign",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text("Contact: ${data['caretaker_contact']}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}