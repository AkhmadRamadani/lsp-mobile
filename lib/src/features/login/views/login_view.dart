import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsp_mobile/cores/constants/color_const.dart';
import 'package:lsp_mobile/cores/constants/image_const.dart';
import 'package:lsp_mobile/src/features/home/views/home_view.dart';
import 'package:lsp_mobile/src/models/user_model.dart';
import 'package:lsp_mobile/src/repositories/sqlite_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final SQLiteRepository _sqliteRepository = SQLiteRepository();

  late SharedPreferences _sharedPreferences;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      (bool, UserModel) isLogin = await _sqliteRepository.login(
        usernameController.text,
        passwordController.text,
      );

      if (!context.mounted) return;

      if (isLogin.$1) {
        await _sharedPreferences.setString('username', usernameController.text);
        await _sharedPreferences.setString('password', passwordController.text);
        await _sharedPreferences.setString('id', isLogin.$2.id.toString());

        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username atau password salah'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  void initializeSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorConst.primary50,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  color: ColorConst.primary50,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            ImageConst.logo,
                            width: 144,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Madani Cashbook",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 81),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username harus diisi';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: 'Username',
                                label: Text(
                                  'Username',
                                  style: TextStyle(color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 10, left: 10, bottom: 8),
                              ),
                            ),
                            const SizedBox(height: 36),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              obscureText: !isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password harus diisi';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                label: const Text(
                                  'Password',
                                  style: TextStyle(color: Colors.black),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    top: 10, left: 10, bottom: 8),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    togglePasswordVisibility();
                                  },
                                  child: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  login(context);
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
