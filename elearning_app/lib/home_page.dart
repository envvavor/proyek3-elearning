import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Import ApiService
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userData;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Gunakan ApiService untuk mengambil data pengguna
      final data = await ApiService.fetchUserData();
      setState(() {
        userData = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _logout() async {
    try {
      await ApiService.logout(); // Panggil fungsi logout dari ApiService
      Navigator.pushReplacementNamed(context, '/'); // Arahkan ke halaman login
    } catch (e) {
      // Tampilkan pesan error yang lebih informatif
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _confirmLogout() async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Konfirmasi Log Out'),
        content: Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Log Out'),
          ),
        ],
      );
    },
  );

  if (shouldLogout == true) {
    _logout(); 
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              // Tambahkan fungsionalitas notifikasi di sini
            },
          ),
        ],
      ),
      body: userData != null
          ? IndexedStack(
              index: _selectedIndex,
              children: [
                // Halaman Beranda
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header dengan informasi pengguna
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.white, size: 50),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat Datang Kembali',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  userData!['name'],
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Daftar tugas yang belum dikerjakan
                      Text(
                        'Tugas Belum Dikerjakan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      SizedBox(height: 10),
                      userData!['tasks'] != null && userData!['tasks'].isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: userData!['tasks'].length,
                                itemBuilder: (context, index) {
                                  final task = userData!['tasks'][index];
                                  return Card(
                                    child: ListTile(
                                      title: Text(task['title']),
                                      subtitle: Text('Due Date: ${task['due_date']}'),
                                      onTap: () {
                                        // Arahkan ke halaman detail tugas
                                        Navigator.pushNamed(
                                          context,
                                          '/task',
                                          arguments: task,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Text('Semua Tugas Sudah dikerjakkan.'),
                            ),
                    ],
                  ),
                ),
                // Halaman Kelas
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Daftar kelas
                      Text(
                        'Mata Pelajaran',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Kelas : D3 TI 2A',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Klik pada kelas untuk melihat detailnya',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      userData!['classes'] != null && userData!['classes'].isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: userData!['classes'].length,
                                itemBuilder: (context, index) {
                                  final classData = userData!['classes'][index];
                                  return Card(
                                    child: ListTile(
                                      title: Text(classData['title']),
                                      subtitle: Text('Jumlah Siswa: ${classData['student_count']}'),
                                      trailing: Icon(Icons.arrow_forward),
                                      onTap: () {
                                        // Arahkan ke halaman detail kelas
                                        Navigator.pushNamed(
                                          context,
                                          '/class',
                                          arguments: classData,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Text('Tidak ada kelas yang tersedia.'),
                            ),
                    ],
                  ),
                ),
                // Halaman Akun
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white, size: 50),
                            ),
                            SizedBox(height: 10),
                            Text(
                              userData!['name'],
                              style: TextStyle(color: const Color.fromARGB(255, 56, 56, 56), fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Kelola Akun'),
                        onTap: () {
                          // Tambahkan fungsionalitas kelola akun di sini
                        },
                      ),
                      Divider(color: Colors.grey, thickness: 1),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Pengaturan'),
                        onTap: () {
                          // Tambahkan fungsionalitas pengaturan di sini
                        },
                      ),
                      Divider(color: Colors.grey, thickness: 1),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text('Pertanyaan'),
                        onTap: () {
                          // Tambahkan fungsionalitas pertanyaan di sini
                        },
                      ),
                      Divider(color: Colors.grey, thickness: 1),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Log Out'),
                        onTap: _confirmLogout, // Panggil fungsi konfirmasi logout
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Kelas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}