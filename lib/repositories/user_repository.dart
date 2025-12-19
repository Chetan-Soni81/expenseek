import 'package:expenseek/exceptions/app_exceptions.dart';
import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/models/profile_model.dart';
import 'package:expenseek/models/user_model.dart';
import 'package:expenseek/repositories/base_repository.dart';
import 'package:expenseek/utils/logger.dart';
import 'package:sqflite/sqflite.dart' as sql;

class UserRepository extends BaseRepository {
 Future<String> userExists() async {
  try 
  {
     var results = await dbHelper.getAllDataQuery('select * from ${TableHelper.tblUser}');
     
     var users = fromJsonToModel(results);

     return users.isNotEmpty ? (users.first.username ?? "") : "";
  } 
  catch (e, stackTrace) 
  {
    AppLogger.error('Failed to check if user exists', e, stackTrace);
    throw DatabaseException('Failed to check user existence: ${e.toString()}');
  }
 }

 Future<int> registerUser(UserModel user) async {
  try 
  {
    var result = await dbHelper.insertRecord(TableHelper.tblUser, user.toJson(), sql.ConflictAlgorithm.replace);
    return result;
  }
  catch (e, stackTrace) 
  {
    AppLogger.error('Failed to register user', e, stackTrace);
    throw DatabaseException('Failed to register user: ${e.toString()}');
  }
 }

 Future<String?> loginUser(UserModel user) async {
  try {
    var result = await dbHelper.queryValue<String?>(sqlQuery: 'select username from ${TableHelper.tblUser} where username = ? and pin = ?', args: [user.username, user.pin]);
    return result;
  } catch(e, stackTrace) {
    AppLogger.error('Failed to login user', e, stackTrace);
    throw DatabaseException('Failed to login user: ${e.toString()}');
  }
 }

 List<UserModel> fromJsonToModel(List<Map<String, dynamic>> json) {
  var results = json.map((m) => UserModel.fromJson(m)).toList();

  return results;
 }
}