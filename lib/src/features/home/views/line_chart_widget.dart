import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lsp_mobile/cores/constants/color_const.dart';
import 'package:lsp_mobile/src/models/cash_flow_model.dart';
import 'package:lsp_mobile/src/shared/format/text_formatter.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<CashFlowModel> data;

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<CashFlowModel> dataIncome = [];
  List<CashFlowModel> dataOutcome = [];

  List<FlSpot> getIncomeSpot() {
    List<FlSpot> spots = [];
    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i].type == 1) {
        double amount = (widget.data[i].amount ?? 0).toDouble();
        double scaledAmount = amount / 10000;
        dataIncome.add(widget.data[i]);

        if (scaledAmount > 10) {
          scaledAmount = 12;
        }

        spots.add(
          FlSpot(
            DateFormat('yyyy-MM-dd')
                .parse(widget.data[i].date ?? '')
                .day
                .toDouble(),
            scaledAmount,
          ),
        );
      }
    }

    return spots;
  }

  List<FlSpot> getOutcomeSpot() {
    List<FlSpot> spots = [];
    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i].type == 0) {
        double amount = (widget.data[i].amount ?? 0).toDouble();
        double scaledAmount = amount / 10000;
        dataOutcome.add(widget.data[i]);

        if (scaledAmount > 10) {
          scaledAmount = 12;
        }

        spots.add(
          FlSpot(
            DateFormat('yyyy-MM-dd')
                .parse(widget.data[i].date ?? '')
                .day
                .toDouble(),
            scaledAmount,
          ),
        );
      }
    }

    return spots;
  }

  double getMinX() {
    double minX = widget.data.isNotEmpty
        ? DateFormat('yyyy-MM-dd')
            .parse(widget.data[0].date ?? '')
            .day
            .toDouble()
        : 0;
    for (int i = 0; i < widget.data.length; i++) {
      double day = DateFormat('yyyy-MM-dd')
          .parse(widget.data[i].date ?? '')
          .day
          .toDouble();
      if (day < minX) {
        minX = day;
      }
    }
    return minX;
  }

  double getMaxX() {
    double maxX = widget.data.isNotEmpty
        ? DateFormat('yyyy-MM-dd')
            .parse(widget.data[0].date ?? '')
            .day
            .toDouble()
        : 0;
    for (int i = 0; i < widget.data.length; i++) {
      double day = DateFormat('yyyy-MM-dd')
          .parse(widget.data[i].date ?? '')
          .day
          .toDouble();
      if (day > maxX) {
        maxX = day;
      }
    }
    return maxX;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: getMinX(),
        maxX: getMaxX(),
        maxY: 12,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = TextStyle(
                color: touchedSpot.bar.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              if (touchedSpot.y > 10) {
                String text = '';
                CashFlowModel data = CashFlowModel();

                if (touchedSpot.barIndex == 0) {
                  data = dataIncome.firstWhere(
                    (element) =>
                        DateFormat('yyyy-MM-dd')
                            .parse(element.date ?? '')
                            .day ==
                        touchedSpot.x,
                  );
                } else {
                  data = dataOutcome.firstWhere(
                    (element) =>
                        DateFormat('yyyy-MM-dd')
                            .parse(element.date ?? '')
                            .day ==
                        touchedSpot.x,
                  );
                }

                text = '${TextFormatter.formatAmountToK(data.amount ?? 0)}k';
                return LineTooltipItem(
                  text,
                  textStyle,
                );
              }
              return LineTooltipItem(
                '${(touchedSpot.y * 10).toInt()}k',
                textStyle,
              );
            }).toList();
          },
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.white,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10k';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      case 7:
        text = '70k';
        break;
      case 10:
        text = '100k';
        break;
      case 12:
        text = '++';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 42,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );

    String data = value.toInt().toString();

    Widget text = Text(data, style: style, textAlign: TextAlign.center);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: ColorConst.primary500.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.blueAccent,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.blueAccent.withOpacity(0.3),
        ),
        spots: getIncomeSpot(),
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.redAccent,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.redAccent.withOpacity(0.3),
        ),
        spots: getOutcomeSpot(),
      );
}
