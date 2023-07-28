import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/sign_in/sign_in_bloc.dart';
import '../../models/custom_error_model.dart';
import '../../repositories/auth/auth_repos.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../../widgets/main_button_widget.dart';
import '../../widgets/text_field_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const LoginPage(),
    );
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController userPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignInBloc(authRepository: context.read<AuthRepository>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Skip",
                        style: kNormalStyle.copyWith(color: Colors.black45),
                      ),
                      const Icon(
                        FontAwesomeIcons.angleRight,
                        size: 14,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                const SizedBox(height: 35.0),
                Text(
                  'Welcome Back!',
                  style: kTitleStyle.copyWith(color: kPrimaryColor),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Please sign in to your account',
                  style: kNormalStyle.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 60.0),
                textFieldWidget(
                  controller: userName,
                  icon: FontAwesomeIcons.user,
                  hintTxt: 'email',
                ),
                textFieldWidget(
                  controller: userPass,
                  icon: FontAwesomeIcons.eyeSlash,
                  isObs: true,
                  hintTxt: 'Password',
                ),
                //SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: kNormalStyle.copyWith(color: Colors.black45),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      BlocConsumer<SignInBloc, SignInState>(
                        listener: (context, state) {
                          if (state.status == SignInStatus.error) {
                            showErrorDialog(context, state.error);
                          }
                          if (state.status == SignInStatus.submitting) {
                            // ignore: avoid_print
                            print("submitting");
                          }
                          if (state.status == SignInStatus.success) {
                            const SnackBar(content: Text("login success"));
                            Navigator.pushNamed(context, '/');
                          }
                        },
                        builder: (context, state) {
                          return Mainbutton(
                            onTap: () {
                              state.status == SignInStatus.submitting
                                  ? null
                                  : context.read<SignInBloc>().add(
                                      SignInWithCredentia(
                                          email: userName.text,
                                          password: userPass.text));
                            },
                            text: state.status == SignInStatus.submitting
                                ? 'Wait...'
                                : 'Sign in',
                            btnColor: kPrimaryColor,
                            txtColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      BlocConsumer<SignInBloc, SignInState>(
                        listener: (context, state) {
                          if (state.status == SignInStatus.error) {
                            showErrorDialog(context, state.error);
                          }
                          if (state.status == SignInStatus.submitting) {
                            // ignore: avoid_print
                            print("submitting");
                          }
                          if (state.status == SignInStatus.success) {
                            const SnackBar(content: Text("login success"));
                            Navigator.pushNamed(context, '/');
                          }
                        },
                        builder: (context, state) {
                          return Mainbutton(
                            onTap: () {
                              state.status == SignInStatus.submitting
                                  ? null
                                  : context
                                      .read<SignInBloc>()
                                      .add(GoogleSignIn());
                            },
                            text: 'Sign in with google',
                            image: 'google.png',
                            btnColor: Colors.black,
                            txtColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/sign-up");
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Don\' have an account? ',
                              style:
                                  kNormalStyle.copyWith(color: Colors.black54),
                            ),
                            TextSpan(
                              text: ' Sign Up',
                              style:
                                  kNormalStyle.copyWith(color: kPrimaryColor),
                            ),
                          ]),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showErrorDialog(BuildContext ctx, CustomError err) {
  final textTheme = Theme.of(ctx).textTheme;

  showDialog(
    context: ctx,
    builder: (ctx) => AlertDialog(
      title: Text(
        err.code,
        style: textTheme.headline3,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(err.plugin),
          const SizedBox(height: 10),
          Text(err.message),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Ok'),
        ),
      ],
    ),
  );
}
