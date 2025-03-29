import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageComplaints extends StatefulWidget {
  const ManageComplaints({super.key});

  @override
  _ManageComplaintsState createState() => _ManageComplaintsState();
}

class _ManageComplaintsState extends State<ManageComplaints> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> complaints = [];
  final TextEditingController _replyControllers = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    try {
      final response = await supabase
          .from('tbl_complaint')
          .select('*, tbl_familymember(*, tbl_resident!inner(resident_name))')
          .eq('complaint_status', 0);
      print("compaints $response");
      setState(() {
        complaints = response;
      });
    } catch (error) {
      print('Error fetching complaints: $error');
    }
  }

  Future<void> _submitReply(int complaintId) async {
    print("Started");
    try {
      final replyText = _replyControllers.text;
      if (replyText.isNotEmpty) {
        await supabase
            .from('tbl_complaint')
            .update({'complaint_reply': replyText, 'complaint_status': 1}).eq(
                'complaint_id', complaintId);
        _replyControllers.clear();
        _fetchComplaints();
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error submitting reply: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 227, 242, 253),
      padding: EdgeInsets.all(30),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          final complaintId = complaint['complaint_id'];

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${complaint['complaint_title']}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Date: ${complaint['complaint_date']}'),
                    Text('Priority: ${complaint['complaint_priority']}'),
                    Text('Content: ${complaint['complaint_content']}'),
                    Text(
                      'Resident Name: ${complaint['tbl_familymember']?['tbl_resident']?['resident_name'].toString() ?? 'Unknown'}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        'Complaint Owner: ${complaint['tbl_familymember']['familymember_name']}'),
                    Text(
                        'Phone: ${complaint['tbl_familymember']['familymember_contact']}'),
                    Text(
                        'Email: ${complaint['tbl_familymember']['familymember_email']}'),
                    const SizedBox(height: 10),
                    complaint['complaint_status'] == 0
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 36, 94),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Provide Your Response'),
                                        content: TextFormField(
                                          controller: _replyControllers,
                                          minLines: 2,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            hintText: "Enter Response",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 0, 36, 94),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14, horizontal: 28),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 0, 36, 94),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14, horizontal: 28),
                                            ),
                                            onPressed: () {
                                              print("complaintid $complaintId");
                                              _submitReply(complaintId);
                                            },
                                            child: Text(
                                              'Submit',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                            child: const Text('Reply'),
                          )
                        : Text('Reply: ${complaint['complaint_reply']}')
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
