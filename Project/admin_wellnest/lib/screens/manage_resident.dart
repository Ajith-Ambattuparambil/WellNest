import 'package:admin_wellnest/main.dart';
import 'package:admin_wellnest/screens/assign_caretaker.dart';
import 'package:flutter/material.dart';

class ManageResident extends StatefulWidget {
  const ManageResident({super.key});

  @override
  State<ManageResident> createState() => _ManageResidentState();
}

class _ManageResidentState extends State<ManageResident> {
  List<Map<String, dynamic>> _filetypeList = [];

  @override
  void initState() {
    super.initState();
    fetchFiletype();
  }

  Future<void> fetchFiletype() async {
    try {
      final response = await supabase
          .from('tbl_resident')
          .select()
          .gt('resident_status', 0)
          .neq('resident_status', 2);
      setState(() {
        _filetypeList = response;
      });
    } catch (e) {
      print("ERROR FETCHING FILE TYPE DATA: $e");
    }
  }

  Future<void> updateResidentStatus(String residentId, int status) async {
    try {
      await supabase.from('tbl_resident').update(
          {'resident_status': status}).match({'resident_id': residentId});
      fetchFiletype();
    } catch (e) {
      print("ERROR UPDATING RESIDENT STATUS: $e");
    }
  }

  void paymentVerify(String residentId) {
    updateResidentStatus(residentId, 3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromARGB(255, 227, 242, 253),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: const Color(0xFFEEEEEE),
          dataTableTheme: DataTableThemeData(
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 24, 56, 111),
              fontSize: 16,
            ),
            dataTextStyle: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
            ),
          ),
        ),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            const Color(0xFFF5F7FA),
          ),
          dataRowColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFFE8F0FE);
              }
              return Colors.transparent;
            },
          ),
          horizontalMargin: 20,
          columnSpacing: 25,
          dividerThickness: 1,
          border: TableBorder(
            horizontalInside: BorderSide(
              width: 1,
              color: Colors.grey.withAlpha(51),
            ),
            top: BorderSide(
              width: 1,
              color: Colors.grey.withAlpha(51),
            ),
            bottom: BorderSide(
              width: 1,
              color: Colors.grey.withAlpha(51),
            ),
          ),
          showBottomBorder: true,
          columns: const [
            DataColumn(label: Text("Sl.No")),
            DataColumn(label: Text("Resident Name")),
            DataColumn(label: Text("Room ID")),
            DataColumn(label: Text("Relation ID")),
            DataColumn(label: Text("Contact")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Action")),
          ],
          rows: _filetypeList.asMap().entries.map((entry) {
            print(entry.value);
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return entry.key % 2 == 0
                      ? const Color(0xFFFAFAFA)
                      : Colors.white;
                },
              ),
              cells: [
                DataCell(
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 24, 56, 111),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      (entry.key + 1).toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  entry.value['resident_name'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                )),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.value['room_id'].toString(),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 24, 56, 111)),
                    ),
                  ),
                ),
                DataCell(Text(entry.value['relation_id'].toString())),
                DataCell(Text(entry.value['resident_contact'].toString())),
                DataCell(Text(
                  entry.value['resident_email'].toString(),
                  style: const TextStyle(color: Colors.blue),
                )),
                DataCell(
                  entry.value['resident_status'] == 1
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFFFFD54F), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Payment Pending",
                                style: TextStyle(
                                  color: Color(0xFFFF8F00),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.verified,
                                  color: Color(0xFF4CAF50),
                                ),
                                onPressed: () {
                                  paymentVerify(
                                      entry.value['resident_id'].toString());
                                },
                              ),
                            ],
                          ),
                        )
                      : ElevatedButton.icon(
                          icon: const Icon(
                            Icons.person_add,
                            size: 18,
                          ),
                          label: const Text("Assign"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssignCaretaker(
                                    id: entry.value['resident_id']),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 24, 56, 111),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                        ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
