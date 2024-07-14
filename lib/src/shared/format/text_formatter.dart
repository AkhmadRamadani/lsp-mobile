import 'package:intl/intl.dart';

class TextFormatter {
  TextFormatter._();

  static String formatDate(String date) {
    List<String> dateSplit = date.split(' ')[0].split('-');
    String year = dateSplit.isNotEmpty ? dateSplit[0] : '2021';
    String month = dateSplit.length > 1 ? dateSplit[1] : '01';
    String day = dateSplit.length > 2 ? dateSplit[2] : '01';
    String monthName = '';
    switch (month) {
      case '01':
        monthName = 'Januari';
        break;
      case '02':
        monthName = 'Februari';
        break;
      case '03':
        monthName = 'Maret';
        break;
      case '04':
        monthName = 'April';
        break;
      case '05':
        monthName = 'Mei';
        break;
      case '06':
        monthName = 'Juni';
        break;
      case '07':
        monthName = 'Juli';
        break;
      case '08':
        monthName = 'Agustus';
        break;
      case '09':
        monthName = 'September';
        break;
      case '10':
        monthName = 'Oktober';
        break;
      case '11':
        monthName = 'November';
        break;
      case '12':
        monthName = 'Desember';
        break;
      default:
        monthName = 'Januari';
        break;
    }
    return '$day $monthName $year';
  }

  static String setMonthName(int month) {
    String monthName = '';
    switch (month) {
      case 1:
        monthName = 'Januari';
        break;
      case 2:
        monthName = 'Februari';
        break;
      case 3:
        monthName = 'Maret';
        break;
      case 4:
        monthName = 'April';
        break;
      case 5:
        monthName = 'Mei';
        break;
      case 6:
        monthName = 'Juni';
        break;
      case 7:
        monthName = 'Juli';
        break;
      case 8:
        monthName = 'Agustus';
        break;
      case 9:
        monthName = 'September';
        break;
      case 10:
        monthName = 'Oktober';
        break;
      case 11:
        monthName = 'November';
        break;
      case 12:
        monthName = 'Desember';
        break;
      default:
        monthName = 'Januari';
        break;
    }

    return monthName;
  }

  static String formatAmount(num amount) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  static String formatAmountToK(num amount) {
    return (amount ~/ 1000).toString();
  }

  static String formatDescription(String description) {
    if (description.length > 20) {
      return '${description.substring(0, 20)}...';
    }
    return description;
  }

  static String formatTime(String date) {
    String dateSplit = date.split(' ')[1];
    return dateSplit;
  }

  static String formatedDate(DateTime date) {
    String year = date.year.toString();
    int month = date.month;
    String day = date.day.toString();
    String monthName = setMonthName(month);

    return '$day $monthName $year';
  }
}
