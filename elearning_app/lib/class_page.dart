import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Import ApiService

class ClassPage extends StatefulWidget {
  @override
  _ClassPageState createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  Map<String, dynamic>? userData;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mata Pelajaran'),
      ),
      body: userData != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daftar kelas
                  Text(
                    'Mata Pelajaran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}