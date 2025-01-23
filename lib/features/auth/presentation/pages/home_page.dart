import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/usecase/user_records_use_case.dart';
import '../widgets/pop_up.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GetUserRecordsUseCase getUserRecordsUseCase;
  late DeleteUserUseCase deleteUserUseCase;
  List<Map<String, dynamic>> userRecords = [];

  @override
  void initState() {
    super.initState();
    final userRepository = UserRepository();
    getUserRecordsUseCase = GetUserRecordsUseCase(userRepository);
    deleteUserUseCase = DeleteUserUseCase(userRepository);
    _loadUserRecords();
  }

  Future<void> _loadUserRecords() async {
    try {
      final users = await getUserRecordsUseCase.execute();
      setState(() {
        userRecords = users;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _deleteUser(String userCode) async {
    try {
      await deleteUserUseCase.execute(userCode);
      setState(() {
        userRecords.removeWhere((user) => user['userCode'] == userCode);
      });
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return CommonPopup(
            title: "Success",
            content: "Delete successful!",
            icon: Icons.check_circle,
            iconColor: Colors.green,
            onClose: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            ),
            buttonText: 'Ok',
          );
        },
      );
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['displayName'] ?? 'Unknown',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text('User Code: ${user['userCode'] ?? 'N/A'}'),
                                Text('Email: ${user['email'] ?? 'N/A'}'),
                                Text(
                                    'Employee Code: ${user['employeeCode'] ?? 'N/A'}'),
                                Text(
                                    'Company Code: ${user['companyCode'] ?? 'N/A'}'),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user['userCode']),
                          ),
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
