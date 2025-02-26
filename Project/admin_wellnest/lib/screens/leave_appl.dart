import 'package:admin_wellnest/main.dart';
import 'package:flutter/material.dart';

class LeaveApplication extends StatefulWidget {
  const LeaveApplication({super.key});

  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  List<Map<String, dynamic>> _filetypeList = [];

  @override
  void initState() {
    super.initState();
    fetchFiletype();
  }

  Future<void> fetchFiletype() async {
    try {
      final response =
          await supabase.from('tbl_leave').select().gt('leave_status', 0).neq('leave_status', 2);
      setState(() {
        _filetypeList = response;
      });
    } catch (e) {
      print("ERROR FETCHING FILE TYPE DATA: $e");
    }
  }

  Future<void> updateLeaveStatus(String leaveId, int status) async {
    try {
      await supabase.from('tbl_leave').update(
          {'leave_status': status}).match({'leave_id': leaveId});
      fetchFiletype();
    } catch (e) {
      print("ERROR UPDATING RESIDENT STATUS: $e");
    }
  }
void leaveVerify(String leaveId) {
    updateLeaveStatus(leaveId, 3);
  }
  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: const [
          DataColumn(label: Text("Sl.No")),
          DataColumn(label: Text("Leave Reason")),
          DataColumn(label: Text("From date")),
          DataColumn(label: Text("To Date")),
          DataColumn(label: Text("Applied Date")),
          DataColumn(label: Text("Action")),
        ],
        rows: _filetypeList.asMap().entries.map((entry) {
          print(entry.value);
          return DataRow(
            cells: [
            DataCell(Text((entry.key + 1).toString())),
            DataCell(Text(entry.value['leave_reason'].toString())),
            DataCell(Text(entry.value['leave_fromdate'].toString())),
            DataCell(Text(entry.value['leave_todate'].toString())),
            DataCell(Text(entry.value['leave_date'].toString())),
            DataCell(
              entry.value['leave_status'] == 0
                  ? Row(
                      children: [
                        Text("Leave application pending.."),
                        IconButton(
                          icon: Icon(Icons.verified),
                          onPressed: () {
                            leaveVerify(entry.value['leave_id'].toString());
                          },
                        ),
                      ],
                    )
                  : Text('Done')
            ),
          ]);
        }).toList());
         }
}