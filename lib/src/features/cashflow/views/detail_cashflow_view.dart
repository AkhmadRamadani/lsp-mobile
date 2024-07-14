import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsp_mobile/cores/constants/color_const.dart';
import 'package:lsp_mobile/src/models/cash_flow_model.dart';
import 'package:lsp_mobile/src/repositories/sqlite_repository.dart';
import 'package:lsp_mobile/src/shared/format/text_formatter.dart';

class DetailCashFlowView extends StatefulWidget {
  const DetailCashFlowView({super.key});

  @override
  State<DetailCashFlowView> createState() => _DetailCashFlowViewState();
}

class _DetailCashFlowViewState extends State<DetailCashFlowView> {
  final _sqliteRepository = SQLiteRepository();

  List<CashFlowModel> cashFlowData = [];

  void getCashFlowData() async {
    List<CashFlowModel> result = await _sqliteRepository.getAllCashFlow();

    result.sort((a, b) => b.id!.compareTo(a.id!));

    setState(() {
      cashFlowData = result;
    });
  }

  @override
  void initState() {
    getCashFlowData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorConst.dodgerBlue900,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detail Cashflow',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: ColorConst.dodgerBlue900,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            itemBuilder: (context, index) {
              CashFlowModel data = cashFlowData[index];
              _Type type = _Type.income;
              if (data.type == 0) {
                type = _Type.outcome;
              }
              return _Card(
                type: type,
                data: data,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 16,
              );
            },
            itemCount: cashFlowData.length,
          ),
        ),
      ),
    );
  }
}

enum _Type { income, outcome }

class _Card extends StatelessWidget {
  const _Card({Key? key, required this.data, this.type = _Type.income})
      : super(key: key);

  final _Type type;
  final CashFlowModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConst.primary50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: type == _Type.income
                  ? Colors.green.shade600
                  : Colors.red.shade600,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.money,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type == _Type.income ? 'Pemasukan' : 'Pengeluaran',
                style: TextStyle(
                  color: type == _Type.income
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                TextFormatter.formatAmount(data.amount ?? 0),
                style: TextStyle(
                  color: type == _Type.income
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                TextFormatter.formatDescription(data.description ?? ''),
                style: TextStyle(
                  color: type == _Type.income
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                TextFormatter.formatDate(data.date ?? ''),
                style: TextStyle(
                  color: type == _Type.income
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                TextFormatter.formatTime(data.date ?? ''),
                style: TextStyle(
                  color: type == _Type.income
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
