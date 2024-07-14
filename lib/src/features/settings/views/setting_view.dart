import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsp_mobile/cores/constants/image_const.dart';
import 'package:lsp_mobile/src/features/login/views/login_view.dart';
import 'package:lsp_mobile/src/models/user_model.dart';
import 'package:lsp_mobile/src/repositories/sqlite_repository.dart';
import 'package:lsp_mobile/src/shared/format/text_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late SharedPreferences _sharedPreferences;
  final SQLiteRepository _sqliteRepository = SQLiteRepository();

  TextEditingController passwordLamaController = TextEditingController();
  TextEditingController passwordBaruController = TextEditingController();
  TextEditingController konfirmasiPasswordBaruController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  void initializeSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void logout(BuildContext context) async {
    await _sharedPreferences.remove('username');
    await _sharedPreferences.remove('password');
    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
    );
  }

  void updatePassword(BuildContext context) async {
    String id = _sharedPreferences.getString('id') ?? '';
    String username = _sharedPreferences.getString('username') ?? '';
    String password = _sharedPreferences.getString('password') ?? '';
    String passwordLama = passwordLamaController.text;
    String passwordBaru = passwordBaruController.text;
    String konfirmasiPasswordBaru = konfirmasiPasswordBaruController.text;
    if (passwordLama == password && passwordBaru == konfirmasiPasswordBaru) {
      UserModel userModel = UserModel(
        id: int.tryParse(id) ?? 0,
        username: username,
        password: passwordBaru,
      );

      await _sqliteRepository.updatePassword(userModel);
      if (!context.mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil mengubah password'),
        ),
      );
    } else {
      String text = '';

      if (passwordLama != password) {
        text = 'Password lama tidak sesuai';
      } else if (passwordBaru != konfirmasiPasswordBaru) {
        text = 'Password baru tidak sama dengan konfirmasi password baru';
      }

      showGeneralDialog(
          context: context,
          pageBuilder: (context, _, __) {
            return AlertDialog(
              title: const Text('Gagal'),
              content: Text(text),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.orange.shade600,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Pengaturan',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.orange.shade600,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Ubah Password'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.only(
                              top: 16,
                              left: 16,
                              right: 16,
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Ubah Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: passwordLamaController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Password Lama',
                                    labelText: 'Password Lama',
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: passwordBaruController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Password Baru',
                                    labelText: 'Password Baru',
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: konfirmasiPasswordBaruController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Konfirmasi Password Baru',
                                    labelText: 'Konfirmasi Password Baru',
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      updatePassword(context);
                                    },
                                    child: const Text('Simpan'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Tentang Aplikasi'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // bottom sheet untuk tentang aplikasi
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 180,
                                  height: 180,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundImage: AssetImage(
                                      ImageConst.profile,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  'Tentang Aplikasi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  'Aplikasi ini dibuat oleh',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  'Nama: Akhmad Ramadani',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  'NIM: 2041720002',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'Tanggal: ${TextFormatter.formatedDate(DateTime.now())}',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      logout(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
