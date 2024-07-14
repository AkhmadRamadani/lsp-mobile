import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsp_mobile/cores/constants/color_const.dart';
import 'package:lsp_mobile/src/features/cashflow/views/add_income_view.dart';
import 'package:lsp_mobile/src/features/cashflow/views/add_outcome_view.dart';
import 'package:lsp_mobile/src/features/cashflow/views/detail_cashflow_view.dart';
import 'package:lsp_mobile/src/features/home/views/line_chart_widget.dart';
import 'package:lsp_mobile/src/features/settings/views/setting_view.dart';
import 'package:lsp_mobile/src/models/cash_flow_model.dart';
import 'package:lsp_mobile/src/repositories/sqlite_repository.dart';
import 'package:lsp_mobile/src/shared/format/text_formatter.dart';
import 'package:lsp_mobile/src/shared/helpers/date_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SQLiteRepository _sqliteRepository = SQLiteRepository();
  List<CashFlowModel> cashFlowData = [];
  num totalIncome = 0;
  num totalOutcome = 0;

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _getCashFlowData();
    _getCashFlowDataForGraph();
  }

  Future<void> _getCashFlowData() async {
    totalIncome = 0;
    totalOutcome = 0;

    List<CashFlowModel> result = await _sqliteRepository.getAllCashFlow(
      startDate: DateTime(now.year, now.month - 1,
          DateHelper.daysInMonth(now.year, now.month - 1), 0, 0, 0),
      endDate: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
    );

    for (var item in result) {
      if (item.type == 0) {
        totalOutcome += item.amount ?? 0;
      } else {
        totalIncome += item.amount ?? 0;
      }
    }

    setState(() {});
  }

  Future<void> _getCashFlowDataForGraph() async {
    cashFlowData.clear();

    DateTime startDate = DateTime(now.year, now.month, now.day - 5);
    DateTime endDate = DateTime(now.year, now.month, now.day);

    List<CashFlowModel> result = await _sqliteRepository.getAllCashFlow(
      startDate: startDate,
      endDate: endDate,
    );

    result.sort(
        (a, b) => DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));

    List<CashFlowModel> totalData = [];
    for (var item in result) {
      bool isSameDate = false;
      for (var data in totalData) {
        DateTime date1 = DateTime.parse(data.date!);
        DateTime date2 = DateTime.parse(item.date!);

        if (date1.day == date2.day && data.type == item.type) {
          isSameDate = true;
          data.amount = (data.amount ?? 0) + (item.amount ?? 0);
          break;
        }
      }

      if (!isSameDate) {
        totalData.add(item);
      }
    }

    cashFlowData.addAll(totalData);
    setState(() {});
  }

  Widget _buildSummaryCard(String title, num amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          TextFormatter.formatAmount(amount),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem({
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required Widget Function(BuildContext) destination,
  }) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: destination),
        );
        _initializeData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 64,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorConst.primary400,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                height: 200,
                width: double.infinity,
                color: ColorConst.primary400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rangkuman Bulan Ini",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(
                        'Pengeluaran', totalOutcome, Colors.redAccent),
                    const SizedBox(height: 24),
                    _buildSummaryCard('Pemasukan', totalIncome, Colors.green),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ExpansionTileTheme(
                        data: const ExpansionTileThemeData(
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          backgroundColor: ColorConst.primary400,
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          tilePadding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          collapsedBackgroundColor: ColorConst.primary400,
                        ),
                        child: ExpansionTile(
                          title: const Text(
                            'Grafik 5 hari terakhir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(
                                color: ColorConst.primary400,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                              ),
                              child: cashFlowData.isEmpty
                                  ? const SizedBox(
                                      height: 250,
                                      child: Center(
                                        child: Text(
                                          'Tidak ada data',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 200,
                                          child: LineChartWidget(
                                            data: cashFlowData,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: Colors.blueAccent,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'Pemasukan',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(width: 12),
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'Pengeluaran',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildGridItem(
                              title: 'Tambah Pemasukan',
                              icon: Icons.playlist_add_check_circle_outlined,
                              color: Colors.green.shade50,
                              iconColor: ColorConst.green400,
                              destination: (context) => const AddIncomeView(),
                            ),
                            _buildGridItem(
                              title: 'Tambah Pengeluaran',
                              icon: Icons.playlist_remove_rounded,
                              color: Colors.red.shade50,
                              iconColor: Colors.redAccent,
                              destination: (context) => const AddOutcomeView(),
                            ),
                            _buildGridItem(
                              title: 'Detail Cash Flow',
                              icon: Icons.list_alt_rounded,
                              color: ColorConst.dodgerBlue50,
                              iconColor: ColorConst.dodgerBlue800,
                              destination: (context) =>
                                  const DetailCashFlowView(),
                            ),
                            _buildGridItem(
                              title: 'Pengaturan',
                              icon: Icons.settings,
                              color: Colors.orange.shade50,
                              iconColor: Colors.orangeAccent,
                              destination: (context) => const SettingView(),
                            ),
                          ],
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
