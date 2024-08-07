import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/logic/cubits/google_auth/cubit/google_auth_cubit.dart';
import 'package:my_app/model/jwt.dart';
import 'package:my_app/screens/home/home.dart';
import 'package:my_app/screens/login/register.dart';
import 'package:my_app/screens/password/forget_password_screen.dart';
import 'package:my_app/screens/widget/decorate_register.dart';
import 'package:my_app/services/login_service.dart';
import 'package:my_app/services/shared_pref%20_service.dart';

import '../../common/color.dart';
import '../../common/image.dart';
import '../widget/text_form_field_custom.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final SharedPref sharedPref = SharedPref();
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DecorateRegister(),
                  const SizedBox(height: 50.0),
                  const LoginForm(),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen()));
                      },
                      child: const Text(
                        "Quên mật khẩu?",
                        style: TextStyle(
                            fontSize: 18.0, color: AppColor.primaryDark),
                      )),
                  const SizedBox(
                    height: 15.0,
                  ),
                  RichText(
                      text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                        text: "Bạn chưa có tài khoản? ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 18.0)),
                    TextSpan(
                      text: "Đăng ký",
                      style: const TextStyle(
                          color: AppColor.primaryDark,
                          fontSize: 18.0,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register())),
                    )
                  ])),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Row(
                    children: [
                      SizedBox(width: 30.0),
                      Expanded(
                        flex: 1,
                        child: Divider(
                          // indent: 100.0,
                          thickness: 2, // Độ dày của đường thẳng
                          color: Colors.black26, // Màu sắc của đường thẳng
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Đăng nhập với",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Divider(
                          // indent: 100.0,
                          thickness: 2, // Độ dày của đường thẳng
                          color: Colors.black26, // Màu sắc của đường thẳng
                        ),
                      ),
                      SizedBox(width: 30.0),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  BlocConsumer<GoogleAuthCubit, GoogleAuthState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return ElevatedButton.icon(
                          onPressed: state is GoogleAuthLoadingState
                              ? null
                              : () => {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                              child: CircularProgressIndicator(
                                                  color: AppColor.primaryDark));
                                        }),
                                    context
                                        .read<GoogleAuthCubit>()
                                        .login()
                                        .then((result) => {
                                              Navigator.of(context).pop(),
                                              if (result is Jwt)
                                                {
                                                  sharedPref.save(
                                                      "jwt", result),
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Home(
                                                                index: 0)),
                                                    ModalRoute.withName('/'),
                                                  ),
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(SnackBar(
                                                      elevation: 0,
                                                      duration: const Duration(
                                                          milliseconds: 2000),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      content:
                                                          AwesomeSnackbarContent(
                                                        title: 'Login success!',
                                                        message:
                                                            'Welcome ${result.user.toString()} to Thumbsup!',
                                                        contentType:
                                                            ContentType.success,
                                                      ),
                                                    ))
                                                }
                                              else if (result is String)
                                                {
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(SnackBar(
                                                      elevation: 0,
                                                      duration: const Duration(
                                                          milliseconds: 1000),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      content:
                                                          AwesomeSnackbarContent(
                                                        title: 'Login fail!',
                                                        message: result,
                                                        contentType:
                                                            ContentType.failure,
                                                      ),
                                                    ))
                                                }
                                            }),
                                  },
                          icon: const Image(
                            image: AssetImage(googleLogo),
                            width: 30,
                            height: 30,
                          ),
                          label: state is GoogleAuthLoadingState
                              ? const CircularProgressIndicator(
                                  color: AppColor.primaryDark)
                              : const Text("GOOGLE"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryDark,
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                              elevation: 10.0,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0))),
                        );
                      }),
                  const SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SharedPref sharedPref = SharedPref();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 10.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Đăng nhập",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 45.0,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormFieldCustom(
                      label: "Tài khoản",
                      hint: "Nhập tài khoản...",
                      icon: Icons.account_circle_rounded,
                      isPassword: false,
                      controller: userController),
                  const SizedBox(height: 25.0),
                  TextFormFieldCustom(
                      label: "Mật khẩu",
                      hint: "Nhập mật khẩu...",
                      icon: Icons.password,
                      isPassword: true,
                      controller: passwordController),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: AppColor.primaryDark));
                          });
                      LoginService.login(
                              userController.text, passwordController.text)
                          .then((result) => {
                                Navigator.of(context).pop(),
                                if (result is Jwt)
                                  {
                                    sharedPref.save("jwt", result),
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Home(index: 0)),
                                      ModalRoute.withName('/'),
                                    ),
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(SnackBar(
                                        elevation: 0,
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Login success!',
                                          message:
                                              'Welcome ${result.user.toString()} to Thumbsup!',
                                          contentType: ContentType.success,
                                        ),
                                      ))
                                  }
                                else if (result is String)
                                  {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(SnackBar(
                                        elevation: 0,
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Login fail!',
                                          message: result,
                                          contentType: ContentType.failure,
                                        ),
                                      ))
                                  }
                              });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryDark,
                        elevation: 5.0,
                        shadowColor: Colors.black,
                        minimumSize: const Size(double.infinity, 20.0),
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
