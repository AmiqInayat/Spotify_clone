import 'package:client/feature/auth/view/page/login_page.dart';
import 'package:client/feature/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/feature/core/widgets/custom_text_field.dart';
import 'package:client/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/feature/core/theme/app_pallette.dart';
import 'package:client/feature/core/utils/utils.dart';
// import 'package:client/feature/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
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
          showSnackBar(context, "Account Created! Successfully");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
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
                "Sign Up",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CustomField(hintText: 'Name', controller: nameController),
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
                buttonText: "Sign Up",
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    ref
                        .read(authViewModelProvider.notifier)
                        .signUpUser(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                  }
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: "Sign In",
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
