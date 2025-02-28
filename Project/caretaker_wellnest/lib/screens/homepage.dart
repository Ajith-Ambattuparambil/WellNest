import 'package:caretaker_wellnest/main.dart';
import 'package:caretaker_wellnest/screens/apply_leave.dart';
import 'package:caretaker_wellnest/screens/manage_leave.dart';
import 'package:caretaker_wellnest/screens/resident_profile.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the LoginPage

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isSidebarExpanded = true;
  final double sidebarWidth = 200.0;
  final double collapsedSidebarWidth = 60.0;
  bool isLoading = true;
  List<Map<String, dynamic>> residentList = [];
  String caretaker_name="";
  String caretaker_photo="";

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchcaretaker();
  }

Future<void> fetchcaretaker() async {
    setState(() {
      isLoading = true;
    });
    try {
      final caretaker=await supabase.auth.currentUser!.id;
      final response = await supabase.from('tbl_caretaker').select().eq('caretaker_id', caretaker).single();
      print("Fetched data: $response");
      setState(() {
        caretaker_name=response['caretaker_name'];
        caretaker_photo=response['caretaker_photo'];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase.from('tbl_resident').select();
      print("Fetched data: $response");
      setState(() {
        residentList = (response);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(230, 255, 252, 197),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 24, 56, 111),
              ),
              child: const Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home,
                  color: Color.fromARGB(255, 24, 56, 111)),
              title: const Text('Home',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Homepage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person,
                  color: Color.fromARGB(255, 24, 56, 111)),
              title: const Text('Apply Leave',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ApplyLeave()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings,
                  color: Color.fromARGB(255, 24, 56, 111)),
              title: const Text('Leave Management',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageLeave()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout,
                  color: Color.fromARGB(255, 24, 56, 111)),
              title: const Text('Logout',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          AppBar(
            title: const Text('CareTaker Wellnest'),
            actions: [
              IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  }),
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(caretaker_photo),
              ),
              const SizedBox(width: 16),
              
               Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(caretaker_name,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications, size: 30),
                onPressed: () {},
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: residentList.length,
              itemBuilder: (context, index) {
                final resident = residentList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResidentProfile(
                      resident: resident['resident_id'],
                    ),));
                  },
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            resident['resident_photo'] ?? "",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 15),
                          Text("Resident - ${index + 1}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(resident['resident_name']),
                          const SizedBox(height: 8),
                          Text(resident['resident_dob'] ?? "")
                  
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
