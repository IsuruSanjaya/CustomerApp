import 'package:customers/core/theme/app_pallet.dart';
import 'package:customers/features/auth/presentation/pages/home_page.dart';
import 'package:customers/features/auth/presentation/pages/signup_page.dart';
import 'package:customers/features/auth/presentation/widgets/auth_button.dart';
import 'package:customers/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecase/login_usecase.dart';
import '../widgets/loader.dart';
import '../widgets/pop_up.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late final SignInUseCase signInUseCase;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final client = http.Client();
    final remoteDataSource = AuthRemoteDataSourceImpl(client);
    final repository = AuthRepositoryImpl(remoteDataSource);
    signInUseCase = SignInUseCase(repository);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true; // Show the loader when the login process starts
    });

    if (formKey.currentState!.validate()) {
      final username = usernameController.text;
      final password = passwordController.text;

      // Log username and password for debugging
      print('Username: $username');
      print('Password: $password');

      final result = await signInUseCase(username, password);

      setState(() {
        isLoading = false; // Hide the loader when the response comes
      });

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
        (user) async {
          // Save response to SQLite DB
          final database = await openDatabase(
            'auth.db',
            version: 1,
            onCreate: (db, version) {
              return db.execute(
                  'CREATE TABLE user(userCode TEXT, displayName TEXT, email TEXT, employeeCode TEXT, companyCode TEXT)');
            },
          );
          print('Database path: $database');

          try {
            final id = await database.insert('user', {
              'userCode': user.userCode,
              'displayName': user.displayName,
              'email': user.email,
              'employeeCode': user.employeeCode,
              'companyCode': user.companyCode,
            });
            print("Data inserted with ID: $id");
          } catch (e) {
            print("Error inserting data: $e");
          }

          // Show success dialog
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) {
              return CommonPopup(
                title: "Success",
                content: "Login successful!",
                onClose: () {
                  Navigator.of(context).pop(); // Close the popup
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                buttonText: "OK", // Text for the button
              );
            },
          );
        },
      );
    } else {
      setState(() {
        isLoading = false; // Hide the loader if form validation fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              AuthField(
                hintText: 'Username',
                controller: usernameController,
              ),
              const SizedBox(height: 30),
              AuthField(
                hintText: 'Password',
                controller: passwordController,
                isObscureText: true,
              ),
              const SizedBox(height: 40),
              // Show the loader while the login request is being processed
             AuthButton(onPressed: _handleLogin),
              const SizedBox(height: 20),
              GestureDetector(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account ? ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign In ',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: AppPallete.gradient3,
                                fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
