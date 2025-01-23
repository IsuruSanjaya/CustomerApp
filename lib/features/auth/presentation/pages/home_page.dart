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
      backgroundColor: Colors.grey[200], // Light grey background for the page
      body: userRecords.isEmpty
          ? const Center(child: Text('No user data found.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: userRecords.length,
                itemBuilder: (context, index) {
                  final user = userRecords[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 5, // Shadow for the card
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // Padding inside the card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['displayName'] ?? 'Unknown',
                            style: Theme.of(context).textTheme.headline6?.copyWith(
                                  color: Colors.blueAccent, // Title text color
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
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
