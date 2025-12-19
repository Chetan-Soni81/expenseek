import 'package:expenseek/helpers/db_helper_v2.dart';

class BaseRepository {
  late DbHelperV2 dbHelper;

  BaseRepository() {
    dbHelper = DbHelperV2();
  }
}