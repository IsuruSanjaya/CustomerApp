// import 'package:customers/core/theme/app_pallet.dart';
// import 'package:customers/features/auth/presentation/widgets/auth_button.dart';
// import 'package:customers/features/auth/presentation/widgets/auth_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formkey = GlobalKey<FormState>();
//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Form(
//           key: formkey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Sign Up',
//                 style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 30),
//               AuthField(
//                 hintText: 'username',
//                 controller: usernameController,
//               ),
//               const SizedBox(height: 30),
//               AuthField(
//                 hintText: 'password',
//                 controller: passwordController,
//                 isObscureText: true,
//               ),
//               const SizedBox(height: 40),
//               AuthButton(),
//               const SizedBox(height: 20),
//               RichText(
//                 text: TextSpan(
//                     text: "Don't have an account ? ",
//                     style: Theme.of(context).textTheme.titleMedium,
//                     children: [
//                       TextSpan(
//                           text: 'Sign In ',
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium
//                               ?.copyWith(
//                                   color: AppPallete.gradient3,
//                                   fontWeight: FontWeight.bold))
//                     ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
