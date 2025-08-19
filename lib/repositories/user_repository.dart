import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/models/profile_model.dart';
import 'package:expenseek/models/user_model.dart';
import 'package:expenseek/repositories/base_repository.dart';
import 'package:sqflite/sqflite.dart' as sql;

class UserRepository extends BaseRepository {
 Future<String> userExists() async {
  try 
  {
     var results = await dbHelper.getAllDataQuery('select * from ${TableHelper.tblUser}');
     
     var users = fromJsonToModel(results);

     return users.first.username ?? "";
  } 
  catch (e) 
  {
    print(e);
    return "";
  }
 }

 Future<int> registerUser(UserModel user) async {
  try 
  {
    var result = dbHelper.insertRecord(TableHelper.tblUser, user.toJson(), sql.ConflictAlgorithm.replace);
    return result;
  }
  catch (e) 
  {
    return 0;
  }
 }

 Future<String?> loginUser(UserModel user) async {
  try {
    var result = dbHelper.queryValue<String?>('select username from ${TableHelper.tblUser} where username = ? and pin = ?', [user.username, user.pin]);
    return result;
  } catch(e) {
    print(e);
    return null;
  }
 }

 List<UserModel> fromJsonToModel(List<Map<String, dynamic>> json) {
  var results = json.map((m) => UserModel.fromJson(m)).toList();

  return results;
 }
}