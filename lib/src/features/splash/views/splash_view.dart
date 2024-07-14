import 'package:flutter/material.dart';
import 'package:lsp_mobile/cores/constants/color_const.dart';
import 'package:lsp_mobile/cores/constants/image_const.dart';
import 'package:lsp_mobile/src/features/home/views/home_view.dart';
import 'package:lsp_mobile/src/features/login/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SharedPreferences? _sharedPreferences;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 3), () {
      checkLogin();
    });
  }

  void initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void checkLogin() {
    String username = _sharedPreferences?.getString('username') ?? '';
    String password = _sharedPreferences?.getString('password') ?? '';
    if (username.isNotEmpty && password.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primary50,
      body: Center(
        child: Image.asset(
          ImageConst.logo,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
