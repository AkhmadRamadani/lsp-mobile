import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsp_mobile/cores/constants/color_const.dart';
import 'package:lsp_mobile/src/models/cash_flow_model.dart';
import 'package:lsp_mobile/src/repositories/sqlite_repository.dart';

class AddIncomeView extends StatefulWidget {
  const AddIncomeView({super.key});

  @override
  State<AddIncomeView> createState() => _AddIncomeViewState();
}

class _AddIncomeViewState extends State<AddIncomeView> {
  final _formKey = GlobalKey<FormState>();

  final SQLiteRepository _sqliteRepository = SQLiteRepository();

  TextEditingController dateController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addIncome(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    CashFlowModel cashFlowModel = CashFlowModel(
      date: dateController.text,
      amount: int.tryParse(nominalController.text) ?? 0,
      description: descriptionController.text,
      type: 1,
    );

    int result =
        await _sqliteRepository.insert('cashflow', cashFlowModel.toJson());
    if (!context.mounted) return;
    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil menambahkan pemasukan'),
        ),
      );
      reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambahkan pemasukan'),
        ),
      );
    }
  }

  void reset() {
    dateController.clear();
    nominalController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorConst.green400,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tambah Pemasukan',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: ColorConst.green400,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: ColorConst.green400,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: dateController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Pilih Tanggal',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        label: Text(
                          'Tanggal',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(
                          top: 10,
                          left: 10,
                          bottom: 8,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                        errorStyle: TextStyle(
                          color: ColorConst.secondary500,
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorConst.secondary500,
                          ),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          if (!context.mounted) return;
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (time != null) {
                            String timeText = time.hour.toString().length == 1
                                ? '0${time.hour}'
                                : time.hour.toString();
                            timeText += ':';
                            timeText += time.minute.toString().length == 1
                                ? '0${time.minute}'
                                : time.minute.toString();
                            dateController.text =
                                '${date.toString().split(' ')[0]} $timeText';
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nominal tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        label: Text(
                          'Nominal',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: ColorConst.secondary500,
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorConst.secondary500,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(
                          top: 10,
                          left: 10,
                          bottom: 8,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Keterangan',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        label: Text(
                          'Keterangan',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(
                          top: 10,
                          left: 10,
                          bottom: 8,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        reset();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        addIncome(context);
                      },
                      child: const Text('Simpan'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
