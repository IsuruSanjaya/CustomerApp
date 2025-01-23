import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> userRecords = [];

  @override
  void initState() {
    super.initState();
    _loadUserRecords();
  }

  Future<void> _loadUserRecords() async {
    // Open the database
    final database = await openDatabase(
      join(await getDatabasesPath(), 'auth.db'),
    );

    try {
      // Query all records from the "user" table
      final List<Map<String, dynamic>> users = await database.query('user');
      print('Query result: $users');

      // Update the state with the fetched records
      setState(() {
        userRecords = users;
      });
    } catch (e) {
      print('Error reading data: $e');
    } finally {
      await database.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userRecords.isEmpty
          ? const Center(child: Text('No user data found.'))
          : Container(
            child: ListView.builder(
                itemCount: userRecords.length,
                itemBuilder: (context, index) {
                  final user = userRecords[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(user['displayName'] ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User Code: ${user['userCode'] ?? 'N/A'}'),
                          Text('Email: ${user['email'] ?? 'N/A'}'),
                          Text('Employee Code: ${user['employeeCode'] ?? 'N/A'}'),
                          Text('Company Code: ${user['companyCode'] ?? 'N/A'}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ),
    );
  }
}
