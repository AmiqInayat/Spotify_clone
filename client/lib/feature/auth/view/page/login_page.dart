import 'package:client/feature/auth/view/page/signup_page.dart';
import 'package:client/feature/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/feature/core/widgets/custom_text_field.dart';
import 'package:client/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/feature/core/utils/utils.dart';
import 'package:client/feature/home/view/pages/home_page.dart';
// import 'package:client/feature/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_pallette.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewModelProvider.select((val) => val.isLoading),
    );
    ref.listen(authViewModelProvider, (_, next) {
      next.when(
        data: (data) {
          // Todo: Navigate to home page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const HomePage();
              },
            ),
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    // print(isLoading);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign In",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 15),
              CustomField(hintText: 'Email', controller: emailController),
              const SizedBox(height: 15),
              CustomField(
                hintText: 'Password',
                controller: passwordController,
                isObscureText: true,
              ),
              const SizedBox(height: 20),
              AuthGradientButton(
                buttonText: "Sign In",
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    await ref
                        .read(authViewModelProvider.notifier)
                        .loginUser(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                  } else {
                    showSnackBar(context, "Missing Fields");
                  }
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: Pallete.gradient2,
                          fontWeight: FontWeight.bold,
                        ),
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
// class LoginPage extends ConsumerStatefulWidget {
//   const LoginPage({super.key});

//   @override
//   ConsumerState<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends ConsumerState<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = ref
//         .watch(authViewModelProvider.select((val) => val?.isLoading == true));

//     ref.listen(
//       authViewModelProvider,
//       (_, next) {
//         next?.when(
//           data: (data) {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const HomePage(),
//               ),
//               (_) => false,
//             );
//           },
//           error: (error, st) {
//             showSnackBar(context, error.toString());
//           },
//           loading: () {},
//         );
//       },
//     );

//     return Scaffold(
//       appBar: AppBar(),
//       body: isLoading
//           ? const Loader()
//           : Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Sign In.',
//                       style: TextStyle(
//                         fontSize: 50,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     CustomField(
//                       hintText: 'Email',
//                       controller: emailController,
//                     ),
//                     const SizedBox(height: 15),
//                     CustomField(
//                       hintText: 'Password',
//                       controller: passwordController,
//                       isObscureText: true,
//                     ),
//                     const SizedBox(height: 20),
//                     AuthGradientButton(
//                       buttonText: 'Sign in',
//                       onTap: () async {
//                         if (formKey.currentState!.validate()) {
//                           await ref
//                               .read(authViewModelProvider.notifier)
//                               .loginUser(
//                                 email: emailController.text,
//                                 password: passwordController.text,
//                               );
//                         } else {
//                           showSnackBar(context, 'Missing fields!');
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SignupPage(),
//                           ),
//                         );
//                       },
//                       child: RichText(
//                         text: TextSpan(
//                           text: 'Don\'t have an account? ',
//                           style: Theme.of(context).textTheme.titleMedium,
//                           children: const [
//                             TextSpan(
//                               text: 'Sign Up',
//                               style: TextStyle(
//                                 color: Pallete.gradient2,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
