import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecase/login_usecase.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/loader.dart';
import '../widgets/pop_up.dart';
import 'home_page.dart';
import 'signup_page.dart';

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
  bool isLoading = false; // Keep this false initially

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
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true; // Start showing the loader
    });

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final result = await signInUseCase(username, password);

    setState(() {
      isLoading = false; // Hide the loader when the response comes back
    });

    result.fold(
      (failure) {
        showDialog(
          context: context,
          builder: (context) {
            return CommonPopup(
              title: "Login Failed",
              content:
                  "Failed to login. Please check your username and password.",
              icon: Icons.error,
              iconColor: Colors.red,
              onClose: () => Navigator.of(context).pop(),
            );
          },
        );
      },
      (user) async {
        final database = await openDatabase(
          'auth.db',
          version: 1,
          onCreate: (db, version) {
            return db.execute(
                'CREATE TABLE user(userCode TEXT, displayName TEXT, email TEXT, employeeCode TEXT, companyCode TEXT)');
          },
            readOnly: false, // Explicitly make it writable

        );

        await database.insert('user', {
          'userCode': user.userCode,
          'displayName': user.displayName,
          'email': user.email,
          'employeeCode': user.employeeCode,
          'companyCode': user.companyCode,
        });

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return CommonPopup(
              title: "Success",
              content: "Login successful!",
              icon: Icons.check_circle,
              iconColor: Colors.green,
              onClose: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                  AuthButton(onPressed: _handleLogin),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const FancyLoader(
                message: "Authenticating...",
              ),
            ),
        ],
      ),
    );
  }
}
