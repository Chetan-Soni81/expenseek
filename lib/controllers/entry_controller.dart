import 'package:expenseek/helpers/db_helper.dart';
import 'package:get/get.dart';

class EntryController extends GetxController {
  RxBool isLogin = false.obs;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    checkUserExists();
  }

  checkUserExists() async {
    isLogin.value = await DbHelper.userExists();
  }
}
