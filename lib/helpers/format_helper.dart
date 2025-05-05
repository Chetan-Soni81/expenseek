import 'package:intl/intl.dart';

class FormatHelper {
  static final nFormat = NumberFormat('##,##,###.0#');
  static final dFormat =  DateFormat('dd-MMM-yyyy hh:mm:ss a');
  
}

extension DateTimeFormatting on DateTime 
{ 
  String dFormat() { 
    return DateFormat('dd-MMM-yyyy hh:mm:ss a').format(this); // Placeholder, replace with your custom formatting logic 
  } 
  String sqlFormat() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  }
}

extension NumberFormatting on double {
  String nFormat () {
    return NumberFormat('##,##,###').format(this);
  }
}
